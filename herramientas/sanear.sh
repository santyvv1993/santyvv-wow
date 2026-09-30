#!/usr/bin/env bash
# Sanea lo copiado antes de publicar: saca de los encabezados las lineas que citan credenciales o
# rutas de nuestra maquina. Lo llama construir.sh; tambien se puede correr suelto.
set -euo pipefail

AQUI="$(cd "$(dirname "$0")/.." && pwd)"
cd "$AQUI"

[ -d sql ] || { echo "no hay sql/ que sanear"; exit 0; }

antes=$(grep -rIl -E 'MYSQL_PWD|credenciales\.txt|E:/Servidor|D:/Proyectos|/c/Users|C:/Users' sql 2>/dev/null | wc -l)

find sql -type f -name '*.sql' -print0 | xargs -0 -r sed -i -E \
  -e 's#^.*(MYSQL_PWD|credenciales\.txt).*$#--      (la aplicacion la hace la herramienta del repo con sus propias credenciales)#' \
  -e 's#^([[:space:]]*--[[:space:]]*)mysql +-h.*$#\1(comando de aplicacion omitido a proposito)#' \
  -e 's#E:/Servidor Wow#<raiz del fork>#g' \
  -e 's#D:/Proyectos#<mis proyectos>#g' \
  -e 's#C:/Users/[A-Za-z0-9._-]+#<usuario>#g'

echo "  saneado: $antes archivo(s) con datos de nuestra maquina"
