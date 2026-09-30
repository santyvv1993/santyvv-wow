#!/usr/bin/env bash
# Puerta de publicacion: no deja subir datos internos, credenciales ni ficheros del cliente.
# Uso: herramientas/verificar-publicacion.sh [ruta]   (por defecto, la raiz del repo)
set -u

RAIZ="$(cd "${1:-$(dirname "$0")/..}" && pwd)"
fallas=0
aviso() { printf 'FALLA  %s\n' "$1"; fallas=$((fallas + 1)); }
nota()  { printf 'nota   %s\n' "$1"; }

echo "auditando: $RAIZ"

# ---------- 1. rutas y tamanos ----------
while IFS= read -r f; do
  rel="${f#"$RAIZ"/}"
  case "$rel" in
    .git/*) continue ;;
  esac
  case "$rel" in
    *.pkt|*.pcap|*.pcapng|*.db2|*.dbc|*.mpq|*.casc|*.blp|*.m2|*.wmo|*.adt|*.wdt|*.zip|*.7z|*.rar|\
    *.exe|*.dll|*.pdb|*.so|*.dylib|*.env|*.key|*.pem|*.pfx|*.p12|*.token|*.sqlite|*.bak|*.log)
      aviso "archivo prohibido: $rel" ;;
  esac
  case "$rel" in
    *.conf) aviso "config real (puede traer credenciales): $rel" ;;
    .secrets/*|*/secrets/*) aviso "carpeta de secretos: $rel" ;;
  esac
  sz=$(wc -c <"$f" 2>/dev/null || echo 0)
  if [ "${sz:-0}" -gt 10485760 ]; then
    aviso "archivo de mas de 10 MB (va a Releases): $rel ($((sz / 1048576)) MB)"
  fi
done < <(find "$RAIZ" -type f -not -path '*/.git/*')

# ---------- 2. contenido ----------
PATRONES='BEGIN (RSA|OPENSSH|EC|DSA) PRIVATE KEY'
PATRONES="$PATRONES"'|mysql://|jdbc:mysql|User Id=|Pwd=|Password[[:space:]]*=[[:space:]]*[^[:space:]]'
PATRONES="$PATRONES"'|api[_-]?key[[:space:]]*[[:space:]]*[=:]|Bearer [A-Za-z0-9._-]{20,}'
PATRONES="$PATRONES"'|gh(p|o|u|s|r)_[A-Za-z0-9]{20,}|github_pat_[A-Za-z0-9_]{20,}|xox[baprs]-'
PATRONES="$PATRONES"'|C:\\\\Users\\\\|C:/Users/|/c/Users/|/mnt/c/Users/'
PATRONES="$PATRONES"'|E:/Servidor|D:/Proyectos|D:\\\\Proyectos'
PATRONES="$PATRONES"'|@gmail\.com|@hotmail\.com|@outlook\.com'
PATRONES="$PATRONES"'|discord\.com/api/webhooks|discord:1[0-9]{17}'
PATRONES="$PATRONES"'|192\.168\.[0-9]{1,3}\.[0-9]{1,3}|172\.(1[6-9]|2[0-9]|3[01])\.[0-9]{1,3}\.[0-9]{1,3}'
PATRONES="$PATRONES"'|10\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}|zerotier|tailscale'
PATRONES="$PATRONES"'|INSERT INTO [`"]?(account|characters|character_[a-z_]+)'
PATRONES="$PATRONES"'|1553436240307814400'

while IFS= read -r f; do
  rel="${f#"$RAIZ"/}"
  # estas dos herramientas contienen los patrones por diseno: no se auditan a si mismas
  case "$rel" in
    herramientas/verificar-publicacion.sh|herramientas/sanear.sh) continue ;;
  esac
  hallazgos=$(grep -I -n -i -E "$PATRONES" "$f" 2>/dev/null | head -3)
  if [ -n "$hallazgos" ]; then
    aviso "contenido sospechoso en $rel"
    printf '       %s\n' "$hallazgos"
  fi
done < <(find "$RAIZ" -type f -not -path '*/.git/*')

# ---------- 3. resultado ----------
if [ "$fallas" -eq 0 ]; then
  echo "OK: nada interno detectado. Se puede publicar."
  exit 0
fi
echo
echo "$fallas problema(s). NO se publica hasta limpiarlo."
exit 1
