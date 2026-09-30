-- ============================================================================================
-- Isla del Exilio (zona 10424 · mapa 2175) · la mision 56839 "Killclaw the Terrible".
-- ============================================================================================
-- APLICADA a la base viva el 17-sep-2026 (migracion 2026_09_17_06 del repo).
--
-- Que cierra: era una de las 4 misiones que quedaban SIN-DADOR despues de cablear las misiones de
-- clase (migracion 2026_09_17_05, P8c) y la unica de esas 4 que SI es de la isla. Medido:
--
--   * La mision la ofrece un OBJETO, no un NPC: el *Danger Sign* (gameobject_template 330627,
--     tipo 2 = QUESTGIVER, con `questGiver` 23167 en el DB2 del cliente). Su unico spawn es el
--     guid 600229 en (210.639, -2167.5, 92.235), mapa 2175, zona 10424, area 11011 (Killclaw's
--     Lair) — el mismo sitio que la wiki da para el cartel: [48.8, 54.3] -> con la transformacion
--     afin calibrada (herramientas/calibracion-afin.json, error mediano 2,3 yd) da (207.2, -2169.7),
--     a 3,4 yd del spawn real. Y `gameobject_queststarter` tenia **0 filas** para 330627: en la
--     base el cartel existia, era interactuable (tipo 2) y no daba nada.
--
--   * La mision se cierra en el *Hidden Treasure Chest*, que en esta TDB esta declarado como
--     CRIATURA (155733, `type = 10` = GAMEOBJECT, `npcflag = 2` = QUESTGIVER, display 84585) y ya
--     figura como `creature_questender` de la 56839... pero **no tiene ni un spawn en el mapa**
--     (0 filas en `world.creature`): o sea que la mision tampoco se podia entregar.
--     Posicion: el fin de la mision es [43.6, 51.4] -> (272.7, -1992.8). Ahi adentro de la cueva
--     hay un racimo de *Cockroach* (172026) que la wiki describe como parte de la cueva de Killclaw
--     ("bones, cockroaches, glowing blue mushrooms"): el mas cercano esta a 2,9 yd con z 77.8348,
--     asi que la Z del cofre sale de ese vecino medido (no inventada). El navmesh del mapa 2175 en
--     ese punto da piso 78.37 (poligono 77.92..80.59), consistente con el vecino.
--
-- Fuentes: warcraft.wiki.gg/wiki/Killclaw_the_Terrible_(quest) (Start: Danger Sign [48.8, 54.3] ·
-- End: Hidden Treasure Chest [43.6, 51.4]), wowpedia (misma ficha) y la guia de la isla de Wowhead
-- ("Pick up the quest from a sign on your way to Darkmaul Citadel"). El core valida en el cargador
-- que el GO de `gameobject_queststarter` sea tipo QUESTGIVER (`ObjectMgr.cpp:8558`): 330627 lo es.
--
-- Idempotente: INSERT IGNORE en las dos tablas.
-- ============================================================================================

-- --------------------------------------------------------------------------------------------
-- 1) El cartel da la mision (el spawn ya estaba: guid 600229).
-- --------------------------------------------------------------------------------------------
INSERT IGNORE INTO `gameobject_queststarter` (`id`, `quest`, `VerifiedBuild`) VALUES
(330627, 56839, 0);


-- --------------------------------------------------------------------------------------------
-- 2) El cofre que la cierra, spawneado donde la mision dice que esta (cueva de Killclaw).
--    Mismo idioma que sus vecinos: fase 0, dificultad '0', quieto y con respawn normal.
-- --------------------------------------------------------------------------------------------
INSERT IGNORE INTO `creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`,
    `phaseUseFlags`, `PhaseId`, `PhaseGroup`, `terrainSwapMap`, `modelid`, `equipment_id`,
    `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`,
    `currentwaypoint`, `MovementType`, `VerifiedBuild`) VALUES
(11801120, 155733, 2175, 10424, 11011, '0', 0, 0, 0, -1, 0, 0,
 272.74, -1992.79, 77.84, 0.0000, 120, 0, 0, 0, 0);
