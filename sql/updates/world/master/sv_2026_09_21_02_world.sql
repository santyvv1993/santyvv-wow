-- SV migracion sv_2026_09_21_02_world.sql
-- Altar de Colmillos (mapa 2993): el TERCER JEFE y la faccion del contenido.
--
-- 1) Zul'jan (entry 259447) faltaba en la primera migracion (sv_2026_09_21_01_world.sql). No era
--    un hueco de la captura: el cliente lo manda como **Vehicle**, no como `Creature`, y el
--    extractor solo miraba `Creature/` y `GameObject/`. Su posicion sale de la captura
--    (1453.8385, 2115.2292, 1.9214258). Verificado ademas contra el diario del cliente: el
--    encuentro 2880 "Zul'jan" de la instancia 1322 "Altar de Colmillos" (JournalEncounterCreature).
--
-- 2) FACCION: los 42 entries venian en 35 (amistosa) —tal como los trae el paquete de datos—, o
--    sea que en el juego no atacarian. La convencion de los calabozos 12.x de casa es 16 (los
--    jefes de la temporada: King Dazar, Yazma, Kyrakka, Writhing Coil) y 14 en algunos. Se aplica
--    SOLO a los entries que viven unicamente en este mapa (40 de 41),
--    para no cambiar el mismo entry en otro contenido: los que tienen spawn afuera se revisan
--    aparte.
--
-- 3) CLASIFICACION: los tres jefes pasan a 1 (elite), como el resto de los jefes de la temporada
--    (King Dazar 1, Yazma 1, Kyrakka 1).
--
-- Idempotente de forma natural: el INSERT va precedido del DELETE de esa misma guid y los UPDATE
-- son UPDATE (la segunda pasada no cambia nada).

DELETE FROM `creature` WHERE `guid` = 3373932684;
INSERT INTO `creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`, `phaseUseFlags`,
                        `PhaseId`, `PhaseGroup`, `terrainSwapMap`, `modelid`, `equipment_id`,
                        `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`,
                        `wander_distance`, `currentwaypoint`, `curHealthPct`, `MovementType`, `npcflag`,
                        `unit_flags`, `unit_flags2`, `unit_flags3`, `ScriptName`, `StringId`, `VerifiedBuild`)
VALUES (3373932684, 259447, 2993, 0, 0, '1,2,8,23,205', 0, 0, 0, -1, 0, 0,
        1453.838500, 2115.229200, 1.921426, 0.000000, 300, 0, 0, NULL, 0, 0, 0, 0, 0, '', NULL, 0);

UPDATE `creature_template` SET `faction` = 16
WHERE `entry` IN (232475, 253169, 253172, 253864, 258940, 259445, 259446, 261550, 261552, 261553, 261554, 261556, 261557, 261560, 261573, 262011, 262034, 262035, 262398, 263109, 263112, 263188, 263790, 263792, 264798, 264902, 265502, 268358, 270098, 270306, 270378, 270390, 270417, 271453, 271864, 272097, 272104, 272271, 272278, 272672, 259447);

UPDATE `creature_template` SET `Classification` = 1
WHERE `entry` IN (259445, 259446, 259447);
