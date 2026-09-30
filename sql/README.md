# SQL

- `updates/<base>/master/sv_*.sql` — nuestras migraciones, con el mismo layout que el core: se
  copian a `sql/updates/` del checkout y el updater las aplica solo en el arranque. Los archivos
  sembrados por nosotros (no los del core) van con el prefijo `sv_`.
- `datos/` — manifiesto (`manifest.tsv`, con `sha256`) de los volcados pesados; los archivos se
  bajan del Release del repo. Ver `datos/README.md`.

Los encabezados conservan la nota de medición con la que se validó cada migración (qué se contó, con
qué resultado, y qué se rechazó). Son nuestras notas de trabajo: las referencias a rutas internas del
fork privado (`docs/...`, `herramientas/...`) quedan sin destino en este repo — el archivo aplica
igual, el cuerpo es autocontenido.

Los datos de spawns, objetos y botín son de estilo TDB. **No** hay volcados de cuentas ni de
personajes: este repo no publica datos de jugadores.
