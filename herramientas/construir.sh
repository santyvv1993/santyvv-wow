#!/usr/bin/env bash
# Regenera el contenido de este repo desde el clon del fork.
# Uso:  CORE=<ruta-al-clon> herramientas/construir.sh
# No tiene rutas nuestras grabadas a proposito: se pasa por variable.
set -euo pipefail

AQUI="$(cd "$(dirname "$0")/.." && pwd)"
CORE="${CORE:?exporta CORE=<ruta del clon del fork>}"
UPSTREAM="${UPSTREAM:-upstream/master}"
MAX=$((2 * 1024 * 1024))   # lo mas pesado va a Releases: solo entran migraciones livianas
MAXPARTE=$((62 * 1024 * 1024))   # tope por parte de los volcados
MINPARTE=$((16 * 1024 * 1024))   # una parte final mas chica que esto se pega a la anterior

cd "$CORE"

# 1. parches: nucleo compartido + un parche por sistema (rutas exclusivas de cada uno)
grupo() {
  local destino="$1"; shift
  git diff "$UPSTREAM" HEAD -- "$@" >"$AQUI/parches/$destino"
  # el diff sale con CRLF en esta maquina (el clon tiene autocrlf=true): el parche se guarda en LF
  sed -i 's/\r$//' "$AQUI/parches/$destino"
  echo "  parche: $destino ($(wc -l <"$AQUI/parches/$destino") lineas)"
}
mkdir -p "$AQUI/parches"
grupo 00-nucleo-compartido.patch \
  src/common/Common.cpp src/common/Logging/AppenderFile.cpp \
  src/server/database src/server/game/Entities/Creature src/server/game/Entities/Player \
  src/server/game/Entities/Unit src/server/game/Server/Packets/AllPackets.h \
  src/server/game/Server/Protocol/Opcodes.cpp src/server/game/Server/WorldSession.cpp \
  src/server/game/Server/WorldSession.h src/server/game/Spells/Auras/SpellAuraEffects.cpp \
  src/server/scripts/Custom/custom_script_loader.cpp \
  src/server/scripts/DragonIsles src/server/scripts/Zandalar
grupo 01-miticas.patch src/server/game/MythicPlus src/server/scripts/Custom/miticas_custom.cpp \
  src/server/game/Handlers/ChallengeModeHandler.cpp src/server/game/Server/Packets/ChallengeModePackets.h
grupo 02-vuelo-dinamico.patch src/server/game/VueloDinamico \
  src/server/scripts/Custom/vuelo_dinamico_custom.cpp src/server/game/Server/Packets/MovementPackets.cpp \
  src/server/game/Server/Packets/MovementPackets.h
grupo 03-warband.patch src/server/game/Entities/Account \
  src/server/scripts/Custom/mentoria_warband_custom.cpp \
  src/server/game/Handlers/CharacterHandler.cpp \
  src/server/game/Server/Packets/CharacterPackets.cpp src/server/game/Server/Packets/CharacterPackets.h
grupo 04-banco-de-cuenta.patch src/server/game/Handlers/BankHandler.cpp \
  src/server/game/Server/Packets/BankPackets.cpp src/server/game/Server/Packets/BankPackets.h
grupo 05-quest-item-usability.patch src/server/game/Handlers/QuestHandler.cpp \
  src/server/game/Server/Packets/QuestPackets.cpp src/server/game/Server/Packets/QuestPackets.h

# 2. SQL: las migraciones livianas al repo; los volcados pesados van a Releases **por partes de peso**
#    (un archivo no se parte nunca: si uno solo supera el tope, es una parte por si mismo)
rm -rf "$AQUI/sql/updates" "$AQUI/sql/datos"
mkdir -p "$AQUI/sql/updates" "$AQUI/sql/datos" "$AQUI/sql/datos/partes"
MAN="$AQUI/sql/datos/manifest.tsv"
LISTA="$(mktemp)"
chicos=0
while IFS= read -r ruta; do
  sz=$(git cat-file -s "HEAD:$ruta")
  if [ "$sz" -le "$MAX" ]; then
    mkdir -p "$AQUI/$(dirname "$ruta")"
    git show "HEAD:$ruta" >"$AQUI/$ruta"
    chicos=$((chicos + 1))
    continue
  fi
  printf '%s\t%s\t%s\t%s\n' "$ruta" "$sz" \
    "$(git show "HEAD:$ruta" | sha256sum | cut -d' ' -f1)" "$(basename "$ruta")" >>"$LISTA"
done < <(git diff --name-only --diff-filter=A "$UPSTREAM" HEAD -- sql/updates)

# partes: tope de 62 MB, en orden de fecha; un archivo no se parte nunca y una parte final corta
# (menos de 16 MB) se pega a la anterior para no dejar un Release de dos archivos.
awk -F'\t' -v OFS='\t' -v tope="$MAXPARTE" -v piso="$MINPARTE" '
  BEGIN { p = 1 }
  { ruta[NR]=$1; bytes[NR]=$2; sha[NR]=$3; base[NR]=$4; n=NR
    if (acum > 0 && acum + bytes[NR] > tope) { p++; acum = 0 }
    parte[NR]=p; acum += bytes[NR]; pesa[p] += bytes[NR] }
  END {
    if (n > 0 && p > 1 && pesa[p] < piso) for (i = 1; i <= n; i++) if (parte[i] == p) parte[i] = p - 1
    for (i = 1; i <= n; i++) printf "%s\t%s\t%s\tparte-%02d\t%s\n", ruta[i], bytes[i], sha[i], parte[i], base[i]
  }' "$LISTA" >"$MAN"
rm -f "$LISTA"
pesados=$(wc -l <"$MAN")
echo "  sql: $chicos migraciones livianas al repo, $pesados volcados en partes"

# 3. indice por parte: lo que se sube como adjunto de cada Release
awk -F'\t' '{print $4}' "$MAN" | sort -u | while read -r p; do
  awk -F'\t' -v p="$p" '$4==p {printf "%s\t%s\t%s\n", $5, $2, $3}' "$MAN" >"$AQUI/sql/datos/partes/$p.tsv"
  printf '  %s: %d archivo(s), %.1f MB\n' "$p" \
    "$(awk -F'\t' -v p="$p" '$4==p' "$MAN" | wc -l)" \
    "$(awk -F'\t' -v p="$p" '$4==p {s+=$2} END {print s/1048576}' "$MAN")"
done

bash "$AQUI/herramientas/sanear.sh"

echo "listo. Ahora: herramientas/verificar-publicacion.sh"
