-- SV migracion sv_2026_09_21_07_world.sql
-- Arreglo de la dificultad de los spawns de la captura del 21-sep (sesion larga):
-- el armador les puso '0' (token de mapa de MUNDO) y en una mazmorra ese token no
-- existe, asi que el cargador los tiraba con 'unsupported difficulty 0 for map'.
-- Ahora llevan la union de las dificultades REALES del mapa (volcado del cliente).
-- El arreglo es data: no hace falta recompilar nada.

-- creature mapa 0: 12 filas -> dificultades '0'
UPDATE `creature` SET `spawnDifficulties` = '0' WHERE `guid` IN (3323830652, 3323830653, 3323830654, 3323830655, 3323830656, 3323830657, 3323830658, 3323830659, 3323830660, 3323830661, 3323830716, 3323830717);
-- creature mapa 643: 16 filas -> dificultades '1,2,8,23,24'
UPDATE `creature` SET `spawnDifficulties` = '1,2,8,23,24' WHERE `guid` IN (3373933623, 3373933624, 3373933625, 3373933626, 3373933627, 3373933628, 3373933629, 3373933630, 3373933631, 3373933632, 3373933633, 3373933634, 3373933635, 3373933636, 3373933637, 3373933638);
-- creature mapa 645: 20 filas -> dificultades '1,2,24'
UPDATE `creature` SET `spawnDifficulties` = '1,2,24' WHERE `guid` IN (3373933603, 3373933604, 3373933605, 3373933606, 3373933607, 3373933608, 3373933609, 3373933610, 3373933611, 3373933612, 3373933613, 3373933614, 3373933615, 3373933616, 3373933617, 3373933618, 3373933619, 3373933620, 3373933621, 3373933622);
-- creature mapa 720: 1 filas -> dificultades '14,15,33'
UPDATE `creature` SET `spawnDifficulties` = '14,15,33' WHERE `guid` IN (3373933647);
-- creature mapa 755: 37 filas -> dificultades '1,2,24'
UPDATE `creature` SET `spawnDifficulties` = '1,2,24' WHERE `guid` IN (3373933540, 3373933541, 3373933542, 3373933543, 3373933544, 3373933545, 3373933546, 3373933547, 3373933548, 3373933549, 3373933550, 3373933551, 3373933552, 3373933553, 3373933554, 3373933555, 3373933556, 3373933557, 3373933558, 3373933559, 3373933560, 3373933561, 3373933562, 3373933563, 3373933564, 3373933565, 3373933566, 3373933567, 3373933568, 3373933569, 3373933570, 3373933571, 3373933572, 3373933573, 3373933574, 3373933575, 3373933576);
-- creature mapa 1762: 2 filas -> dificultades '2,8,23,24'
UPDATE `creature` SET `spawnDifficulties` = '2,8,23,24' WHERE `guid` IN (3373933645, 3373933646);
-- creature mapa 2521: 1 filas -> dificultades '1,2,8,23,24,205'
UPDATE `creature` SET `spawnDifficulties` = '1,2,8,23,24,205' WHERE `guid` IN (3373933652);
-- creature mapa 2648: 37 filas -> dificultades '1,2,8,23,205,216'
UPDATE `creature` SET `spawnDifficulties` = '1,2,8,23,205,216' WHERE `guid` IN (3373933503, 3373933504, 3373933505, 3373933506, 3373933507, 3373933508, 3373933509, 3373933510, 3373933511, 3373933512, 3373933513, 3373933514, 3373933515, 3373933516, 3373933517, 3373933518, 3373933519, 3373933520, 3373933521, 3373933522, 3373933523, 3373933524, 3373933525, 3373933526, 3373933527, 3373933528, 3373933529, 3373933530, 3373933531, 3373933532, 3373933533, 3373933534, 3373933535, 3373933536, 3373933537, 3373933538, 3373933539);
-- creature mapa 2859: 1 filas -> dificultades '1,2,8,23,205'
UPDATE `creature` SET `spawnDifficulties` = '1,2,8,23,205' WHERE `guid` IN (3373933651);
-- creature mapa 2962: 1 filas -> dificultades '208'
UPDATE `creature` SET `spawnDifficulties` = '208' WHERE `guid` IN (3373933650);
-- creature mapa 3004: 1 filas -> dificultades '14,15,16,17,220,241'
UPDATE `creature` SET `spawnDifficulties` = '14,15,16,17,220,241' WHERE `guid` IN (3373933648);
-- gameobject mapa 643: 1 filas -> dificultades '1,2,8,23,24'
UPDATE `gameobject` SET `spawnDifficulties` = '1,2,8,23,24' WHERE `guid` IN (3323830717);
-- gameobject mapa 645: 1 filas -> dificultades '1,2,24'
UPDATE `gameobject` SET `spawnDifficulties` = '1,2,24' WHERE `guid` IN (3323830716);
-- gameobject mapa 755: 1 filas -> dificultades '1,2,24'
UPDATE `gameobject` SET `spawnDifficulties` = '1,2,24' WHERE `guid` IN (3323830661);
-- gameobject mapa 2648: 9 filas -> dificultades '1,2,8,23,205,216'
UPDATE `gameobject` SET `spawnDifficulties` = '1,2,8,23,205,216' WHERE `guid` IN (3323830652, 3323830653, 3323830654, 3323830655, 3323830656, 3323830657, 3323830658, 3323830659, 3323830660);
