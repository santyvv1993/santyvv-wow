#!/usr/bin/env bash
# Aplica esta version sobre un checkout limpio de TrinityCore (master).
# Uso:  herramientas/aplicar.sh <ruta-del-core> [commit-base]
#   CORE=... herramientas/aplicar.sh        (usa $CORE y el commit base del README)
set -euo pipefail

AQUI="$(cd "$(dirname "$0")/.." && pwd)"
# git es nativo: le pasamos rutas en formato mixto (D:/...)
if command -v cygpath >/dev/null 2>&1; then AQUI="$(cygpath -m "$AQUI")"; fi
CORE="${1:-${CORE:-}}"
BASE="${2:-34cd48e6f9}"

if [ -z "$CORE" ] || [ ! -d "$CORE/.git" ]; then
  echo "falta la ruta del clon de TrinityCore (argumento 1 o variable CORE)" >&2
  exit 1
fi

cd "$CORE"
if [ -n "$BASE" ]; then
  echo "== base: $BASE =="
  git checkout "$BASE"
fi

for p in "$AQUI"/parches/*.patch; do
  echo "== $(basename "$p") =="
  git apply --3way "$p"
done

echo "== migraciones =="
if [ -d "$AQUI/sql/updates" ]; then
  cp -r "$AQUI"/sql/updates/. sql/updates/
  echo "copiadas a sql/updates/ (las aplica el updater en el arranque)"
fi

cat <<'FIN'

listo. Compilar:
  cmake -S . -B build -DCMAKE_BUILD_TYPE=RelWithDebInfo && cmake --build build -j
  (Windows: Build.bat <Proyecto>Editor Win64 Development -Project=<ruta>.uproject -WaitMutex)
FIN
