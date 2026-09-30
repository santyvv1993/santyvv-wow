-- SV migracion sv_2026_09_18_11_world.sql
-- Correctiva del lote de Karesh (10): movimiento/wander coherentes, listas de botin de objeto que
-- faltaban y modelid invalido. Idempotente (escribe el estado final, no un delta).
--
-- A1. wander_distance a 0 por movimiento no aleatorio: 367 filas
-- A2. MovementType aleatorio sin distancia -> quieto (lo mismo que hace el core): 98 filas
-- C. modelid a 0 (el modelo lo pone la plantilla): 1 filas
-- B. 6 listas de botin de objeto faltan y la fuente no las tiene

UPDATE `creature` SET `wander_distance` = 0 WHERE `map` IN (2738) AND `guid` >= 3100000000 AND `MovementType` <> 1 AND `wander_distance` <> 0;
UPDATE `creature` SET `MovementType` = 0 WHERE `map` IN (2738) AND `guid` >= 3100000000 AND `MovementType` = 1 AND (`wander_distance` IS NULL OR `wander_distance` = 0);
UPDATE `creature` SET `modelid` = 0 WHERE `map` IN (2738) AND `guid` >= 3100000000 AND `modelid` <> 0;
