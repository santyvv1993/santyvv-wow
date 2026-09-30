-- SV migracion sv_2026_09_21_03_world.sql
-- Altar de Colmillos (mapa 2993): dos correcciones despues de mirar lo que carga el mundo.
--
-- 1) FACCIÓN de los NPC de la historia. La migracion 02 puso facción 16 (hostil, la de la chusma
--    de la era) a los 42 entries del mapa, y entre esos entraron los acompanantes de la trama:
--    Lady Liadrin (263790, 265502, 270390) y Orweyna (263792, 270098). Son NPC de escolta/guion,
--    no enemigos: vuelven a 35 (amistosa). La base no los marca (npcflag 0, sin relaciones de
--    mision), asi que la decision es por nombre y por lo que se ve en la captura: aparecen
--    quietos en la sala del ritual y el jugador nunca los ataca.
--
-- 2) LOS 30 SPAWNS DE OBJETO SIN PLANTILLA. Se insertaron con la migracion 01 y el cargador los
--    descarta uno por uno en cada arranque
--    (`Table 'gameobject' has gameobject (GUID: N) with non existing gameobject entry X, skipped`):
--    no existen en `gameobject_template`, ni en `ref_lw`, ni en la copia local del DB2 `GameObjects`
--    del cliente. Se borran para no dejar una familia de 30 avisos por levante; las posiciones
--    capturadas quedan guardadas en docs/investigacion/captura-2993/objetos_2993.csv, listas para
--    volver a insertarse cuando se escriban las plantillas.
--
-- La condicion del DELETE es la misma del cargador, asi que es idempotente y no necesita lista de
-- guids: borra lo que el core ya descarta.

UPDATE `creature_template` SET `faction` = 35
WHERE `entry` IN (263790, 263792, 265502, 270098, 270390);

DELETE g FROM `gameobject` g
  LEFT JOIN `gameobject_template` t ON t.`entry` = g.`id`
WHERE g.`map` = 2993 AND t.`entry` IS NULL;
