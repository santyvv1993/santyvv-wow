-- Dervishian del War Creche (mapa 2570): el duplicado se va y la misión queda en el de la fuente
--
-- Contexto medido: en `sv_2026_09_18_01_world.sql` se puso a mano un Dervishian (entrada **182069**,
-- guid 9100001) porque el mapa 2570 estaba vacío (49 criaturas). El lote del 18-sep (tarde) trajo la zona
-- completa desde la fuente de referencia (LoreWalkerTDB 12.1) y esa fuente **ya trae su propio Dervishian**
-- (entrada **181596**, guid 3100000001) en (5815,0 / −2915,8), a **0,2 yd** de nuestro (5815,0 / −2916,0):
-- quedaban dos NPCs con el mismo nombre apilados en el mismo piso.
--
-- Lo medido en la base:
--   · `creature_queststarter`: 181596 → 64863 «Arcane Guardians» (vino de la fuente)
--   · `creature_questender`  : 182069 → 64863 (lo puso el parche a mano)
--   · `creature_queststarter`: 182069 → 64865 «Gear Up» (lo puso el parche a mano)
--   · el spawn nuestro tenía `zoneId`/`areaId` en **0**; el de la fuente trae **13769 / 13806** (la zona
--     y el área del creche, que es lo que el core usa para acreditar objetivos por zona).
--
-- Decisión: se conserva el spawn de la FUENTE (es el que tiene el área declarada) y se le pasa la relación
-- de misión; el nuestro se borra. Idempotente: el `DELETE` va por guid y las relaciones por la clave
-- (id, quest), así que una segunda pasada no cambia nada.
--
-- Prueba: `SELECT id, guid, ROUND(position_x,2), ROUND(position_y,2) FROM creature WHERE id IN (181596,182069)`
-- debe quedar con UNA sola fila (181596), y las misiones 64863/64865 con su dador y su entregador en
-- criaturas spawneadas.

DELETE FROM `creature` WHERE `guid` = 9100001 AND `id` = 182069;

DELETE FROM `creature_queststarter` WHERE `id` = 182069 AND `quest` = 64865;
INSERT IGNORE INTO `creature_queststarter` (`id`, `quest`) VALUES (181596, 64865);

DELETE FROM `creature_questender` WHERE `id` = 182069 AND `quest` = 64863;
INSERT IGNORE INTO `creature_questender` (`id`, `quest`) VALUES (181596, 64863);
