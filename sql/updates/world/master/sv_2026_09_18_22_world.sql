-- SV migracion sv_2026_09_18_22_world.sql
-- spawnDifficulties contra MapDifficulty.db2 del cliente: las instancias no aceptan la 0 (el core
-- descartaba el spawn) y los mapas sin dificultades no admiten spawns. Idempotente.
--
-- A. creature mapa 1136: 1610 filas con dificultad corregida a '14' (cliente: [14, 15, 16, 17, 241])
-- A. creature mapa 1760: 911 filas con dificultad corregida a '12' (cliente: [12])
-- A. creature mapa 2516: 1626 filas con dificultad corregida a '1' (cliente: [1, 2, 8, 23, 205])
-- B. creature mapa 2695: 1546 filas borradas (el cliente no declara ninguna dificultad para ese mapa)
-- B. creature mapa 2735: 5327 filas borradas (el cliente no declara ninguna dificultad para ese mapa)
-- B. creature mapa 2736: 2984 filas borradas (el cliente no declara ninguna dificultad para ese mapa)
-- A. gameobject mapa 1136: 574 filas con dificultad corregida a '14' (cliente: [14, 15, 16, 17, 241])
-- A. gameobject mapa 1760: 106 filas con dificultad corregida a '12' (cliente: [12])
-- A. gameobject mapa 2516: 1 filas con dificultad corregida a '1' (cliente: [1, 2, 8, 23, 205])
-- B. gameobject mapa 2735: 1219 filas borradas (el cliente no declara ninguna dificultad para ese mapa)
-- B. gameobject mapa 2736: 2337 filas borradas (el cliente no declara ninguna dificultad para ese mapa)

UPDATE `creature` SET `spawnDifficulties` = '14' WHERE `map` = 1136 AND `guid` >= 3100000000 AND `spawnDifficulties` <> '14';
UPDATE `creature` SET `spawnDifficulties` = '12' WHERE `map` = 1760 AND `guid` >= 3100000000 AND `spawnDifficulties` <> '12';
UPDATE `creature` SET `spawnDifficulties` = '1' WHERE `map` = 2516 AND `guid` >= 3100000000 AND `spawnDifficulties` <> '1';
DELETE FROM `creature` WHERE `map` = 2695 AND `guid` >= 3100000000;
DELETE FROM `creature` WHERE `map` = 2735 AND `guid` >= 3100000000;
DELETE FROM `creature` WHERE `map` = 2736 AND `guid` >= 3100000000;
UPDATE `gameobject` SET `spawnDifficulties` = '14' WHERE `map` = 1136 AND `guid` >= 3050000000 AND `spawnDifficulties` <> '14';
UPDATE `gameobject` SET `spawnDifficulties` = '12' WHERE `map` = 1760 AND `guid` >= 3050000000 AND `spawnDifficulties` <> '12';
UPDATE `gameobject` SET `spawnDifficulties` = '1' WHERE `map` = 2516 AND `guid` >= 3050000000 AND `spawnDifficulties` <> '1';
DELETE FROM `gameobject` WHERE `map` = 2735 AND `guid` >= 3050000000;
DELETE FROM `gameobject` WHERE `map` = 2736 AND `guid` >= 3050000000;
