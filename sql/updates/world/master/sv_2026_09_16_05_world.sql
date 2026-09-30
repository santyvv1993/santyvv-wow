-- Isla del Exilio (zona 10424, mapa 2175): el tramo final (Darkmaul Citadel).
--
-- Con la migración 2026_09_16_04 la isla ya se entrega hasta el tramo final; ésta agrega lo que
-- faltaba para cerrarla: los NPC del final (que existen en la plantilla pero no tienen ni un spawn)
-- y los objetos de sus misiones.
--
-- Las POSICIONES son reales, no inventadas: la API de Wowhead (nether.wowhead.com/tooltip/npc/<entry>)
-- devuelve los spawns del NPC que su rastreador vio en el cliente, como % del mapa de la zona; la
-- conversión a coordenadas del mundo es afín (el mapa está rotado respecto de los ejes del mundo) y
-- se calibró contra los ~31 NPC de la isla cuyos spawns ya están en la base: error mediano 2,3
-- yardas (herramientas/misiones-posiciones.py, tabla en docs/inventario/isla-del-exilio-posiciones.md).
-- La altura (z) sale del spawn vecino que ya existe o de los POI de la misión.
-- Los objetos copian la posición del mismo objeto del otro bando (los campamentos están uno encima
-- del otro) o de los POI de su propia misión.
--
-- Fase: la Alianza usa la 13840 ("See Alliance Heroes near Darkmaul Citadel", ya existía con sus
-- condiciones). La Horda NO tiene en la TDB su fase equivalente del cliente, así que se usa la 15485
-- ("See Warlord Breka Grimaxe at Ogre Ruins", la última fase Horda del mapa: se activa con The
-- Re-Deather y queda activa) y el orden del flujo se garantiza con PrevQuestID. Desviación conocida:
-- el elenco del final se ve en la Horda un tramo antes de lo que lo vería en retail.
--
-- Idempotente: INSERT IGNORE con las claves primarias completas.

-- -------------------------------------------------------------------------------------------
-- 1) NPC del tramo final (sin spawn en ningún mapa hasta hoy).
-- -------------------------------------------------------------------------------------------
INSERT IGNORE INTO `creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`,
    `phaseUseFlags`, `PhaseId`, `PhaseGroup`, `terrainSwapMap`, `modelid`, `equipment_id`,
    `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`,
    `currentwaypoint`, `MovementType`, `VerifiedBuild`) VALUES
-- Henry Garrick en la entrada de Darkmaul (Wowhead 40.2,32.4)
(11801001, 156942, 2175, 10424, 10424, '0', 0, 13840, 0, -1, 0, 0, 701.00, -1876.00, 187.50, 4.2000, 120, 0, 0, 0, 0),
-- Captain Kelra (Wowhead 40.0,32.2)
(11801002, 156954, 2175, 10424, 10424, '0', 0, 13840, 0, -1, 0, 0, 706.00, -1870.00, 187.50, 4.2000, 120, 0, 0, 0, 0),
-- Kalecgos (Wowhead 39.8,32.2)
(11801003, 244389, 2175, 10424, 10424, '0', 0, 13840, 0, -1, 0, 0, 706.00, -1863.00, 187.50, 4.2000, 120, 0, 0, 0, 0),
-- Thrall en el campamento ogro (Wowhead 48.8,49.4)
(11801011, 167596, 2175, 10424, 10424, '0', 0, 15485, 0, -1, 0, 0, 318.00, -2170.00, 106.10, 3.1000, 120, 0, 0, 0, 0),
-- Warlord Breka Grimaxe (Wowhead 40.2,32.4)
(11801012, 167632, 2175, 10424, 10424, '0', 0, 15485, 0, -1, 0, 0, 701.00, -1877.00, 187.50, 4.2000, 120, 0, 0, 0, 0),
-- Shuja Grimaxe (Wowhead 40.2,32.6)
(11801013, 167630, 2175, 10424, 10424, '0', 0, 15485, 0, -1, 0, 0, 697.00, -1877.00, 187.50, 4.2000, 120, 0, 0, 0, 0),
-- Warlord Mulgrin Thunderwalker (Wowhead 40.0,32.2)
(11801014, 167183, 2175, 10424, 10424, '0', 0, 15485, 0, -1, 0, 0, 706.00, -1870.00, 187.50, 4.2000, 120, 0, 0, 0, 0);

-- -------------------------------------------------------------------------------------------
-- 2) Objetos de las misiones del tramo final.
-- -------------------------------------------------------------------------------------------
INSERT IGNORE INTO `gameobject` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`,
    `phaseUseFlags`, `PhaseId`, `PhaseGroup`, `terrainSwapMap`, `position_x`, `position_y`,
    `position_z`, `orientation`, `rotation0`, `rotation1`, `rotation2`, `rotation3`,
    `spawntimesecs`, `animprogress`, `state`, `VerifiedBuild`) VALUES
-- Catapult (copia del 351477 de la Horda)
(11801021, 326651, 2175, 10424, 10530, '0', 0, 0, 0, -1, 463.78, -1997.08, 143.71, 0, 0, 0, 0.995905, 0.090407, 7200, 255, 1, 0),
-- Catapult (copia del 351477)
(11801022, 326651, 2175, 10424, 10530, '0', 0, 0, 0, -1, 489.90, -2051.60, 143.90, 0, 0, 0, 0.995905, 0.090407, 7200, 255, 1, 0),
-- Catapult (copia del 351477)
(11801023, 326651, 2175, 10424, 10530, '0', 0, 0, 0, -1, 610.70, -2118.40, 158.90, 0, 0, 0, 0.995905, 0.090407, 7200, 255, 1, 0),
-- Catapult (copia del 351477)
(11801024, 326651, 2175, 10424, 10530, '0', 0, 0, 0, -1, 536.00, -2085.60, 158.30, 0, 0, 0, 0.995905, 0.090407, 7200, 255, 1, 0),
-- Ogre Runestone (POI de Controlling their Stones)
(11801031, 339865, 2175, 10424, 10424, '0', 0, 0, 0, -1, 703.00, -1876.00, 187.00, 0, 0, 0, 0.000000, 0.000000, 7200, 255, 1, 0),
-- Ogre Runestone (POI)
(11801032, 339865, 2175, 10424, 10424, '0', 0, 0, 0, -1, 705.00, -1861.00, 187.00, 0, 0, 0, 0.000000, 0.000000, 7200, 255, 1, 0),
-- Ogre Runestone (POI)
(11801033, 339865, 2175, 10424, 10424, '0', 0, 0, 0, -1, 707.00, -1869.00, 187.00, 0, 0, 0, 0.000000, 0.000000, 7200, 255, 1, 0),
-- Ogre Runestone Horda (POI)
(11801034, 351476, 2175, 10424, 10424, '0', 0, 0, 0, -1, 703.00, -1876.00, 187.00, 0, 0, 0, 0.000000, 0.000000, 7200, 255, 1, 0),
-- Ogre Runestone Horda (POI)
(11801035, 351476, 2175, 10424, 10424, '0', 0, 0, 0, -1, 705.00, -1861.00, 187.00, 0, 0, 0, 0.000000, 0.000000, 7200, 255, 1, 0),
-- Ogre Runestone Horda (POI)
(11801036, 351476, 2175, 10424, 10424, '0', 0, 0, 0, -1, 707.00, -1869.00, 187.00, 0, 0, 0, 0.000000, 0.000000, 7200, 255, 1, 0),
-- Thick Cocoon (copia del 339568 de la Alianza)
(11801041, 350796, 2175, 10424, 10527, '0', 0, 0, 0, -1, 80.50, -2279.50, 60.40, 0, 0, 0, -0.090744, 0.995876, 7200, 255, 1, 0),
-- Thick Cocoon (copia)
(11801042, 350796, 2175, 10424, 10527, '0', 0, 0, 0, -1, 36.00, -2199.40, 17.00, 0, 0, 0, -0.197591, 0.980289, 7200, 255, 1, 0),
-- Thick Cocoon (copia)
(11801043, 350796, 2175, 10424, 10527, '0', 0, 0, 0, -1, 123.60, -2238.90, -5.90, 0, 0, 0, -0.075917, 0.997115, 7200, 255, 1, 0),
-- Thick Cocoon (copia)
(11801044, 350796, 2175, 10424, 10527, '0', 0, 0, 0, -1, 111.10, -2217.90, 33.00, 0, 0, 0, -0.186835, 0.982393, 7200, 255, 1, 0),
-- Thick Cocoon (copia)
(11801045, 350796, 2175, 10424, 10527, '0', 0, 0, 0, -1, 65.30, -2276.60, -0.70, 0, 0, 0, -0.151949, 0.988389, 7200, 255, 1, 0);

-- -------------------------------------------------------------------------------------------
-- 3) Quién da y quién cierra las misiones del tramo final.
-- -------------------------------------------------------------------------------------------
INSERT IGNORE INTO `creature_queststarter` (`id`, `quest`, `VerifiedBuild`) VALUES
-- Henry Garrick (fase 13318, campamento poblado) - To Darkmaul Citadel
(156887, 56344, 0),
-- Henry Garrick (fase 13840, campamento ogro) - Right Beneath Their Eyes
(156942, 55981, 0),
-- Henry Garrick (fase 13840, entrada de Darkmaul) - Like Ogres to the Slaughter
(156942, 55988, 0),
-- Captain Garrick (fase 13840) - Catapult Destruction
(156941, 55989, 0),
-- Henry Garrick (fase 13840) - Controlling their Stones
(156942, 55990, 0),
-- Captain Kelra (nueva, fase 13840) - Dungeon: Darkmaul Citadel
(156954, 55992, 0),
-- Captain Kelra (nueva, fase 13840) - An End to Beginnings
(156954, 55991, 0),
-- Thrall (fase 15485, ya spawneado) - To Darkmaul Citadel
(167212, 59975, 0),
-- Thrall (nueva, fase 15485) - Right Beneath Their Eyes
(167596, 59978, 0),
-- Warlord Breka Grimaxe (nueva, fase 15485) - Like Ogres to the Slaughter
(167632, 59979, 0),
-- Shuja Grimaxe (nueva, fase 15485) - Catapult Destruction
(167630, 59980, 0),
-- Thrall (nueva, fase 15485) - Controlling their Stones
(167596, 59981, 0),
-- Warlord Mulgrin Thunderwalker (nueva, fase 15485) - Dungeon: Darkmaul Citadel
(167183, 59984, 0),
-- Thrall (nueva, fase 15485) - An End to Beginnings
(167596, 59985, 0);

INSERT IGNORE INTO `creature_questender` (`id`, `quest`, `VerifiedBuild`) VALUES
-- Henry Garrick (fase 13840, campamento ogro)
(156942, 56344, 0),
-- Henry Garrick (fase 13840, entrada de Darkmaul)
(156942, 55981, 0),
-- Henry Garrick
(156942, 55988, 0),
-- Captain Garrick
(156941, 55989, 0),
-- Captain Kelra (nueva)
(156954, 55990, 0),
-- Henry Garrick
(156942, 55992, 0),
-- Kalecgos (nueva)
(244389, 55991, 0),
-- Thrall (nueva)
(167596, 59975, 0),
-- Thrall (nueva)
(167596, 59978, 0),
-- Warlord Breka Grimaxe (nueva)
(167632, 59979, 0),
-- Shuja Grimaxe (nueva)
(167630, 59980, 0),
-- Warlord Mulgrin Thunderwalker (nueva)
(167183, 59981, 0),
-- Thrall (nueva)
(167596, 59984, 0),
-- Thrall (nueva)
(167596, 59985, 0);

-- -------------------------------------------------------------------------------------------
-- 4) Orden del tramo final (PrevQuestID). En retail lo garantiza la fase; acá lo hace explícito,
--    sobre todo en la Horda, que no tiene su fase del cliente. Ojo: la TDB no tiene filas de
--    `quest_template_addon` para estas misiones (sólo las crea cuando necesita pisar algo), así que
--    hay que insertarlas; para las que ya existieran, sólo se pisa PrevQuestID.
-- -------------------------------------------------------------------------------------------
INSERT INTO `quest_template_addon` (`ID`, `PrevQuestID`) VALUES
-- Alianza: To Darkmaul Citadel exige Who Lurks in the Pit
(56344, 55639),
-- Alianza: Right Beneath Their Eyes exige To Darkmaul Citadel
(55981, 56344),
-- Alianza: Like Ogres exige Right Beneath Their Eyes
(55988, 55981),
-- Alianza: Catapult Destruction exige Right Beneath Their Eyes
(55989, 55981),
-- Alianza: Controlling their Stones exige Right Beneath Their Eyes
(55990, 55981),
-- Alianza: Dungeon exige Right Beneath Their Eyes (las tres del campamento ogro son paralelas)
(55992, 55981),
-- Alianza: An End to Beginnings exige la mazmorra
(55991, 55992),
-- Horda: To Darkmaul Citadel exige Who Lurks in the Pit
(59975, 59949),
-- Horda: Right Beneath Their Eyes exige To Darkmaul Citadel
(59978, 59975),
-- Horda: Like Ogres exige Right Beneath Their Eyes
(59979, 59978),
-- Horda: Catapult Destruction exige Right Beneath Their Eyes
(59980, 59978),
-- Horda: Controlling their Stones exige Right Beneath Their Eyes
(59981, 59978),
-- Horda: Dungeon exige Right Beneath Their Eyes
(59984, 59978),
-- Horda: An End to Beginnings exige la mazmorra
(59985, 59984)
ON DUPLICATE KEY UPDATE `PrevQuestID` = VALUES(`PrevQuestID`);

-- Red de seguridad del flag de dador (igual que en las migraciones anteriores).
UPDATE `creature_template` ct
JOIN (
    SELECT DISTINCT `id` FROM `creature_queststarter`
    UNION
    SELECT DISTINCT `id` FROM `creature_questender`
) rel ON rel.`id` = ct.`entry`
SET ct.`npcflag` = ct.`npcflag` | 2
WHERE (ct.`npcflag` & 2) = 0;
