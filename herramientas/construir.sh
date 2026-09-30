#!/usr/bin/env bash
# Regenera el contenido de este repo desde el clon del fork.
# Uso:  CORE=<ruta-al-clon> herramientas/construir.sh
# No tiene rutas nuestras grabadas a proposito: se pasa por variable.
set -euo pipefail

AQUI="$(cd "$(dirname "$0")/.." && pwd)"
CORE="${CORE:?exporta CORE=<ruta del clon del fork>}"
UPSTREAM="${UPSTREAM:-upstream/master}"
MAX=$((2 * 1024 * 1024))   # lo mas pesado va a Releases: solo entran migraciones livianas

cd "$CORE"

# 1. parches: nucleo compartido + un parche por sistema (rutas exclusivas de cada uno)
grupo() {
  local destino="$1"; shift
  git diff "$UPSTREAM" HEAD -- "$@" >"$AQUI/parches/$destino"
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

# 2. SQL: las migraciones livianas al repo, los volcados pesados a un manifiesto (van a Releases)
rm -rf "$AQUI/sql/updates" "$AQUI/sql/datos"
mkdir -p "$AQUI/sql/updates" "$AQUI/sql/datos"
: >"$AQUI/sql/datos/manifest.tsv"
chicos=0; pesados=0
while IFS= read -r ruta; do
  sz=$(git cat-file -s "HEAD:$ruta")
  if [ "$sz" -le "$MAX" ]; then
    mkdir -p "$AQUI/$(dirname "$ruta")"
    git show "HEAD:$ruta" >"$AQUI/$ruta"
    chicos=$((chicos + 1))
  else
    printf '%s\t%s\t%s\n' "$ruta" "$sz" "$(git show "HEAD:$ruta" | sha256sum | cut -d' ' -f1)" >>"$AQUI/sql/datos/manifest.tsv"
    pesados=$((pesados + 1))
  fi
done < <(git diff --name-only --diff-filter=A "$UPSTREAM" HEAD -- sql/updates)
echo "  sql: $chicos migraciones livianas al repo, $pesados volcados al manifiesto"

bash "$AQUI/herramientas/sanear.sh"

echo "listo. Ahora: herramientas/verificar-publicacion.sh"
