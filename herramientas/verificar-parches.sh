#!/usr/bin/env bash
# Comprueba que los parches aplican sobre el commit base de upstream (sin tocar el working tree).
# Uso:  CORE=<ruta del clon> herramientas/verificar-parches.sh [commit-base]
set -euo pipefail

AQUI="$(cd "$(dirname "$0")/.." && pwd)"
# git es nativo: le pasamos rutas en formato mixto (D:/...)
if command -v cygpath >/dev/null 2>&1; then AQUI="$(cygpath -m "$AQUI")"; fi
CORE="${CORE:-${1:-}}"
BASE="${2:-34cd48e6f9}"

[ -n "$CORE" ] && [ -d "$CORE/.git" ] || { echo "exporta CORE=<ruta del clon de TrinityCore>"; exit 1; }

cd "$CORE"
# indice temporal: comprobamos contra el arbol del commit base sin ensuciar el indice real
IDXDIR="$(mktemp -d)"
# git es un binario nativo: necesita la ruta en formato windows/mixto
if command -v cygpath >/dev/null 2>&1; then IDXDIR="$(cygpath -m "$IDXDIR")"; fi
IDX="$IDXDIR/idx"
export GIT_INDEX_FILE="$IDX"
git read-tree "$BASE"

fallas=0
for p in "$AQUI"/parches/*.patch; do
  printf '%-32s ' "$(basename "$p")"
  if git apply --cached --check "$p" 2>/dev/null; then
    echo "aplica"
  else
    echo "NO APLICA"; fallas=$((fallas + 1))
  fi
done

# todos juntos, en orden
printf '%-32s ' "conjunto completo"
if git apply --cached --check "$AQUI"/parches/*.patch 2>/dev/null; then
  echo "aplica"
else
  echo "NO APLICA"; fallas=$((fallas + 1))
fi

rm -rf "$IDXDIR"
[ "$fallas" -eq 0 ] && echo "parches OK contra $BASE" || { echo "$fallas parche(s) con problemas"; exit 1; }
