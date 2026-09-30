# Rotación de logs rota en Windows

Estado: arreglado y medido. Candidato a reportarse en TrinityCore.

**El problema.** Con `LogsDir` en una ruta absoluta, al llegar al tamaño máximo el appender
*truncaba* el archivo anterior en vez de respaldarlo: no quedaba ninguna copia y se perdía el log
previo. Es un bug de Windows (el respaldo se hace renombrando con el nombre de ruta completo).

**Medición** (mismo binario, misma configuración, misma máquina, contenido determinista de 161.596
líneas por levante):

| | Respaldos que aparecen | Contenido anterior |
|---|---|---|
| Sin el arreglo | 0 | perdido (truncado en cada rotación) |
| Con el arreglo | 7 (`DBErrors.log.2026-09-17_11-40-53` … `11-41-05`, ~2 MB cada uno) | preservado |

Archivos: `src/common/Logging/AppenderFile.cpp`.

Nota de configuración: `worldserver.conf` no acepta comentarios en línea — `,a,2000000  # prueba`
deja el valor entero como argumento y el appender se descarta **en silencio** (el archivo no se crea
y no hay ninguna pista en el log).
