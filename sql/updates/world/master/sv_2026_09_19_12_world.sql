-- SV migracion de spawns de OBJETOS: contenedores con botin definido y sin spawnear
-- (cofres y nodos de la Isla del Exilio que la captura del oficial vio con su posicion).
--
-- De donde salen: `D:/Games/ymir/analisis/gameobjects.csv` (posicion y orientacion tal como
-- las mando el servidor oficial); generador: `herramientas/extraer-gameobjects.py` +
-- `herramientas/generar-spawns-objetos.py`.
--
-- Por que importan: los seis primeros YA tienen su lista de botin en casa
-- (`gameobject_loot_template`) pero no existian en el mundo, asi que ese botin era inalcanzable.
--
-- Convenciones (las mismas de sv_2026_09_18_49_world.sql):
--  * banda de guid libre 3050000000+ (aca, por encima del maximo de la banda: 3323828914);
--  * zoneId/areaId 0, fases 0, terrainSwapMap -1, StringId NULL, VerifiedBuild 0;
--  * spawnDifficulties '0' en mundo abierto y '150' en 2236;
--  * rotacion derivada de la orientacion (rotation2 = sin(o/2), rotation3 = cos(o/2)).
-- filas a insertar: 7
-- IDEMPOTENTE (regla de la casa): mismo motivo que en la _11 — el archivo tiene CRLF, el hash del
-- updater se calcula sobre el contenido en modo texto y un registro manual con sha1sum de bytes
-- crudos hace que se re-aplique en cada arranque. Se borran los guids de la banda antes de insertar.
DELETE FROM `gameobject` WHERE `guid` IN (3323828915,3323828916,3323828917,3323828918,3323828919,3323828920,3323828921);
INSERT INTO `gameobject` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`, `phaseUseFlags`, `PhaseId`, `PhaseGroup`, `terrainSwapMap`, `position_x`, `position_y`, `position_z`, `orientation`, `rotation0`, `rotation1`, `rotation2`, `rotation3`, `spawntimesecs`, `animprogress`, `state`, `ScriptName`, `StringId`, `VerifiedBuild`) VALUES
('3323828915', 327407, 2175, 0, 0, '0', 0, 0, 0, -1, 466.710080, -1932.545200, 155.781020, 5.531120, 0, 0, 0.367233, -0.930129, 300, 255, 1, '', NULL, 0),
('3323828916', 329918, 2175, 0, 0, '0', 0, 0, 0, -1, 85.678820, -2563.581500, 66.442245, 0.000000, 0, 0, 0.000000, 1.000000, 300, 255, 1, '', NULL, 0),
('3323828917', 329919, 2175, 0, 0, '0', 0, 0, 0, -1, 585.461800, -2524.276100, 157.117970, 0.647406, 0, 0, 0.318080, 0.948064, 300, 255, 1, '', NULL, 0),
('3323828918', 339770, 2175, 0, 0, '0', 0, 0, 0, -1, -108.319440, -2448.069600, 15.123479, 3.886337, 0, 0, 0.931467, -0.363826, 300, 255, 1, '', NULL, 0),
('3323828919', 341951, 2175, 0, 0, '0', 0, 0, 0, -1, 177.779510, -2045.979100, 74.674790, 1.268895, 0, 0, 0.592732, 0.805399, 300, 255, 1, '', NULL, 0),
('3323828920', 346278, 2175, 0, 0, '0', 0, 0, 0, -1, 238.177080, -2285.484400, 80.895850, 3.941943, 0, 0, 0.920993, -0.389580, 300, 255, 1, '', NULL, 0),
('3323828921', 376386, 2444, 0, 0, '0', 0, 0, 0, -1, 3559.020800, -1811.439200, 21.130663, 3.894804, 0, 0, 0.929918, -0.367766, 300, 255, 1, '', NULL, 0);
