-- sv_2026_09_18_05_world.sql
-- Correccion del "terreno" de los objetos importados por el lote 03.
-- En esta base el valor "sin terreno alternativo" es -1 (103.875 filas de gameobject). El lote 03 puso 0
-- y el core lo rechaza: "gameobject ... with `terrainSwapMap` 0 which cannot be used on spawn map, set to -1"
-- (836 lineas por arranque). Se acota a los guids que importamos nosotros.
UPDATE `gameobject` SET `terrainSwapMap` = -1
 WHERE `guid` BETWEEN 305000001 AND 305000999 AND `terrainSwapMap` = 0;
