# Correcciones de datos (estilo TDB)

Estado: aplicadas y medidas por `DBErrors.log`. Candidatas a reportarse en TrinityCore una por una.

Medición base: `DBErrors.log` del levante en cabecera, comparado **por familia de error**, no por
total. Todo lo que sigue dejó la base igual o mejor.

- **1.028 filas huérfanas** que el core ya ignoraba o reportaba como rotas (`creature_model_info`,
  `game_event_gameobject`, `conversation_actors`): `DBErrors.log` de 161.596 → 160.568 líneas.
- **Spawns de jefes sin spawn** (Alun'za, Yazma, Kyrakka): la entrada del jefe existía sin fila de
  spawn, lo que además afectaba el registro de `DungeonEncounterData` y `BossBoundaryData` — por eso
  salir del área durante la pelea no se detectaba.
- **Botín inservible**: 176 entradas que el core ya consideraba inutilizables, más las 25 plantillas
  y 86 condiciones que quedaban colgando (-142 filas netas).
- **Relaciones de misión y dadores faltantes**: 2.037 dadores de misión ausentes resueltos sobre
  1.095 plantillas (`creature_queststarter`), y el contenido de la Isla del Exilio y su tramo final.

Regla que se siguió: nada se toca "porque sí" — primero se mide qué reporta el core y después se
corrige el dato o se elimina la fila, con el conteo antes/después en el encabezado de cada migración.
