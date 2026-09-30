-- Isla del Exilio (zona 10424, mapa 2175): el tramo que hoy no se puede jugar.
--
-- Qué pasa: la isla se juega desde el barco hasta "Westward Bound" y ahí se corta, igual en los
-- dos bandos. No es un problema de enlaces (hay 0 enlaces rotos y 0 contradicciones con la wiki):
-- es que las misiones del nido de arpías en adelante no tienen quién las dé ni quién las cierre.
-- El core arma el menú de un NPC con `creature_queststarter` / `creature_questender`
-- (Player::PrepareQuestMenu, Player.cpp:14355): sin fila ahí, la misión no existe para el jugador.
--
-- Cómo se eligió cada NPC: la isla se escalona por FASES (`phase_area` + condiciones de tipo 47
-- = CONDITION_QUESTSTATE, SourceTypeOrReferenceId 26 en `conditions`). El comentario de cada fase
-- dice para qué es ("See Henry and Kee-La at Harpy Roost"), así que el dador de cada misión es el
-- NPC spawneado en la fase que se activa justo cuando esa misión está disponible.
-- Auditoría completa y hoja de trabajo: docs/ANALISIS-MISIONES-ISLA-DEL-EXILIO.md y
-- docs/inventario/misiones-isla-del-exilio-*.md
--
-- Todo idempotente (INSERT IGNORE sobre claves primarias completas): se puede re-aplicar sin daño.

-- ---------------------------------------------------------------------------------------------
-- 1) Fase del nido de arpías de la Horda (15354): Bo y Shuja Grimaxe están spawneados en esa fase,
--    pero la fase no estaba declarada en `phase_area` ni tenía condiciones, así que nadie la recibía
--    (los NPC existían y eran invisibles para siempre). Se espeja la estructura de la 13811 (Alianza).
-- ---------------------------------------------------------------------------------------------
INSERT IGNORE INTO `phase_area` (`AreaId`, `PhaseId`, `Comment`) VALUES
(10528, 15354, 'See Shuja Grimaxe and Bo at Harpy Roost (H)'),
(10529, 15354, 'See Shuja Grimaxe and Bo at Harpy Roost (H)'),
(10588, 15354, 'See Shuja Grimaxe and Bo at Harpy Roost (H)');

INSERT IGNORE INTO `conditions`
    (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`,
     `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`,
     `ConditionValue3`, `ConditionStringValue1`, `NegativeCondition`, `ErrorType`, `ErrorTextId`,
     `ScriptName`, `Comment`) VALUES
(26, 15354, 10528, 0, 0, 47, 0, 59943, 74, 0, '', 0, 0, 0, '', 'Apply Phase 15354 if Quest 59943 (The Harpy Problem) is in progress | complete | rewarded'),
(26, 15354, 10528, 0, 0, 47, 0, 59944, 1, 0, '', 0, 0, 0, '', 'Apply Phase 15354 if Quest 59944 (The Rescue of Herbert Gloomburst) is not taken'),
(26, 15354, 10528, 0, 1, 47, 0, 59943, 74, 0, '', 0, 0, 0, '', 'Apply Phase 15354 if Quest 59943 (The Harpy Problem) is in progress | complete | rewarded'),
(26, 15354, 10528, 0, 1, 47, 0, 59945, 1, 0, '', 0, 0, 0, '', 'Apply Phase 15354 if Quest 59945 (Harpy Culling) is not taken'),
(26, 15354, 10528, 0, 2, 47, 0, 59943, 74, 0, '', 0, 0, 0, '', 'Apply Phase 15354 if Quest 59943 (The Harpy Problem) is in progress | complete | rewarded'),
(26, 15354, 10528, 0, 2, 47, 0, 59946, 1, 0, '', 0, 0, 0, '', 'Apply Phase 15354 if Quest 59946 (Purge the Totems) is not taken'),
(26, 15354, 10528, 0, 3, 47, 0, 59944, 66, 0, '', 0, 0, 0, '', 'Apply Phase 15354 if Quest 59944 (The Rescue of Herbert Gloomburst) is completed | rewarded'),
(26, 15354, 10528, 0, 3, 47, 0, 59947, 1, 0, '', 0, 0, 0, '', 'Apply Phase 15354 if Quest 59947 (Message to Base) is not taken'),
(26, 15354, 10528, 0, 4, 47, 0, 59945, 66, 0, '', 0, 0, 0, '', 'Apply Phase 15354 if Quest 59945 (Harpy Culling) is completed | rewarded'),
(26, 15354, 10528, 0, 4, 47, 0, 59947, 1, 0, '', 0, 0, 0, '', 'Apply Phase 15354 if Quest 59947 (Message to Base) is not taken'),
(26, 15354, 10528, 0, 5, 47, 0, 59946, 66, 0, '', 0, 0, 0, '', 'Apply Phase 15354 if Quest 59946 (Purge the Totems) is completed | rewarded'),
(26, 15354, 10528, 0, 5, 47, 0, 59947, 1, 0, '', 0, 0, 0, '', 'Apply Phase 15354 if Quest 59947 (Message to Base) is not taken'),
(26, 15354, 10529, 0, 0, 47, 0, 59943, 74, 0, '', 0, 0, 0, '', 'Apply Phase 15354 if Quest 59943 (The Harpy Problem) is in progress | complete | rewarded'),
(26, 15354, 10529, 0, 0, 47, 0, 59944, 1, 0, '', 0, 0, 0, '', 'Apply Phase 15354 if Quest 59944 (The Rescue of Herbert Gloomburst) is not taken'),
(26, 15354, 10529, 0, 1, 47, 0, 59943, 74, 0, '', 0, 0, 0, '', 'Apply Phase 15354 if Quest 59943 (The Harpy Problem) is in progress | complete | rewarded'),
(26, 15354, 10529, 0, 1, 47, 0, 59945, 1, 0, '', 0, 0, 0, '', 'Apply Phase 15354 if Quest 59945 (Harpy Culling) is not taken'),
(26, 15354, 10529, 0, 2, 47, 0, 59943, 74, 0, '', 0, 0, 0, '', 'Apply Phase 15354 if Quest 59943 (The Harpy Problem) is in progress | complete | rewarded'),
(26, 15354, 10529, 0, 2, 47, 0, 59946, 1, 0, '', 0, 0, 0, '', 'Apply Phase 15354 if Quest 59946 (Purge the Totems) is not taken'),
(26, 15354, 10529, 0, 3, 47, 0, 59944, 66, 0, '', 0, 0, 0, '', 'Apply Phase 15354 if Quest 59944 (The Rescue of Herbert Gloomburst) is completed | rewarded'),
(26, 15354, 10529, 0, 3, 47, 0, 59947, 1, 0, '', 0, 0, 0, '', 'Apply Phase 15354 if Quest 59947 (Message to Base) is not taken'),
(26, 15354, 10529, 0, 4, 47, 0, 59945, 66, 0, '', 0, 0, 0, '', 'Apply Phase 15354 if Quest 59945 (Harpy Culling) is completed | rewarded'),
(26, 15354, 10529, 0, 4, 47, 0, 59947, 1, 0, '', 0, 0, 0, '', 'Apply Phase 15354 if Quest 59947 (Message to Base) is not taken'),
(26, 15354, 10529, 0, 5, 47, 0, 59946, 66, 0, '', 0, 0, 0, '', 'Apply Phase 15354 if Quest 59946 (Purge the Totems) is completed | rewarded'),
(26, 15354, 10529, 0, 5, 47, 0, 59947, 1, 0, '', 0, 0, 0, '', 'Apply Phase 15354 if Quest 59947 (Message to Base) is not taken'),
(26, 15354, 10588, 0, 0, 47, 0, 59943, 74, 0, '', 0, 0, 0, '', 'Apply Phase 15354 if Quest 59943 (The Harpy Problem) is in progress | complete | rewarded'),
(26, 15354, 10588, 0, 0, 47, 0, 59944, 1, 0, '', 0, 0, 0, '', 'Apply Phase 15354 if Quest 59944 (The Rescue of Herbert Gloomburst) is not taken'),
(26, 15354, 10588, 0, 1, 47, 0, 59943, 74, 0, '', 0, 0, 0, '', 'Apply Phase 15354 if Quest 59943 (The Harpy Problem) is in progress | complete | rewarded'),
(26, 15354, 10588, 0, 1, 47, 0, 59945, 1, 0, '', 0, 0, 0, '', 'Apply Phase 15354 if Quest 59945 (Harpy Culling) is not taken'),
(26, 15354, 10588, 0, 2, 47, 0, 59943, 74, 0, '', 0, 0, 0, '', 'Apply Phase 15354 if Quest 59943 (The Harpy Problem) is in progress | complete | rewarded'),
(26, 15354, 10588, 0, 2, 47, 0, 59946, 1, 0, '', 0, 0, 0, '', 'Apply Phase 15354 if Quest 59946 (Purge the Totems) is not taken'),
(26, 15354, 10588, 0, 3, 47, 0, 59944, 66, 0, '', 0, 0, 0, '', 'Apply Phase 15354 if Quest 59944 (The Rescue of Herbert Gloomburst) is completed | rewarded'),
(26, 15354, 10588, 0, 3, 47, 0, 59947, 1, 0, '', 0, 0, 0, '', 'Apply Phase 15354 if Quest 59947 (Message to Base) is not taken'),
(26, 15354, 10588, 0, 4, 47, 0, 59945, 66, 0, '', 0, 0, 0, '', 'Apply Phase 15354 if Quest 59945 (Harpy Culling) is completed | rewarded'),
(26, 15354, 10588, 0, 4, 47, 0, 59947, 1, 0, '', 0, 0, 0, '', 'Apply Phase 15354 if Quest 59947 (Message to Base) is not taken'),
(26, 15354, 10588, 0, 5, 47, 0, 59946, 66, 0, '', 0, 0, 0, '', 'Apply Phase 15354 if Quest 59946 (Purge the Totems) is completed | rewarded'),
(26, 15354, 10588, 0, 5, 47, 0, 59947, 1, 0, '', 0, 0, 0, '', 'Apply Phase 15354 if Quest 59947 (Message to Base) is not taken');

-- ---------------------------------------------------------------------------------------------
-- 2) Quién da y quién cierra las misiones del tramo (relaciones que faltaban).
--    Sólo entra lo que tiene NPC spawneado en la fase correcta. Queda pendiente (necesita spawn
--    nuevo, va en otra migración): el tramo final de los dos bandos (To Darkmaul Citadel en
--    adelante), las misiones de clase de guerra/pícaro/paladín/sacerdote/brujo/chamán y toda la
--    Horda después de "Message to Base" (Thrall 167596, Breka 167632, Shuja 167630, Mulgrin 167183,
--    Kalecgos 244496, Herbert Gloomburst 167182, entrenadores de clase).
-- ---------------------------------------------------------------------------------------------
INSERT IGNORE INTO `creature_queststarter` (`id`, `quest`, `VerifiedBuild`) VALUES
-- Lightspawn (fase 13878) - Freeing the Light (opcional)
(157114, 54933, 0),
-- Henry Garrick (fase 13809, campamento) - The Harpy Problem
(156833, 55196, 0),
-- Kee-La (fase 13811, nido) - Harpy Culling
(156860, 55764, 0),
-- Henry Garrick (fase 13811, nido) - Purge the Totems
(156859, 55881, 0),
-- Henry Garrick (fase 13811, nido) - The Rescue of Meredy Huntswell
(156859, 55763, 0),
-- Henry Garrick (fase 13811, nido) - Message to Base
(156859, 55882, 0),
-- Alaria (fase 13816, Hrun's Barrow) - Who Lurks in the Pit
(156803, 55639, 0),
-- Kee-La (fase 13318, campamento) - A Monk's Focus
(156885, 59347, 0),
-- Kee-La (fase 13318, campamento) - One Last Spar
(156885, 59349, 0),
-- Meredy Huntswell (fase 13836, campamento) - A Mage's Knowledge
(156886, 59352, 0),
-- Meredy Huntswell (fase 13836, campamento) - The Best Way to Use Sheep
(156886, 59354, 0),
-- Austin Huxworth (fase 15017, campamento) - A Hunter's Trap
(161666, 59355, 0),
-- Austin Huxworth (fase 15017, campamento) - Hunting the Stalker
(161666, 59356, 0),
-- Austin Huxworth (fase 15017, campamento) - The Art of Taming
(161666, 60168, 0),
-- Shuja Grimaxe (fase 15353, campamento) - The Harpy Problem
(167219, 59943, 0),
-- Bo (fase 15354, nido) - Harpy Culling
(167291, 59945, 0),
-- Bo (fase 15354, nido) - Purge the Totems
(167291, 59946, 0),
-- Shuja Grimaxe (fase 15354, nido) - The Rescue of Herbert Gloomburst
(167290, 59944, 0),
-- Shuja Grimaxe (fase 15354, nido) - Message to Base
(167290, 59947, 0),
-- Lana Jordan (fase 15337, Hrun's Barrow) - Who Lurks in the Pit
(167225, 59949, 0);

INSERT IGNORE INTO `creature_questender` (`id`, `quest`, `VerifiedBuild`) VALUES
-- Henry Garrick (fase 13811, nido)
(156859, 55196, 0),
-- Kee-La (fase 13811, nido)
(156860, 55764, 0),
-- Henry Garrick (fase 13811, nido)
(156859, 55881, 0),
-- Meredy Huntswell (fase 13836, de vuelta en el campamento)
(156886, 55763, 0),
-- Henry Garrick (fase 13318, campamento) - la wiki dice Captain Garrick, que no tiene spawn ahí
(156887, 55882, 0),
-- Alaria (fase 13816 / 13832 / 13833)
(156803, 55639, 0),
-- Kee-La
(156885, 59347, 0),
-- Kee-La
(156885, 59349, 0),
-- Meredy Huntswell
(156886, 59352, 0),
-- Meredy Huntswell
(156886, 59354, 0),
-- Austin Huxworth
(161666, 59355, 0),
-- Austin Huxworth
(161666, 59356, 0),
-- Austin Huxworth
(161666, 60168, 0);

-- ---------------------------------------------------------------------------------------------
-- 3) Red de seguridad: el flag de dador (UNIT_NPC_FLAG_QUESTGIVER = 0x2) para las criaturas que
--    acaban de recibir relación (mismo patrón que 2026_09_16_01_world.sql; ahí no quedan porque
--    esa migración corrió antes que ésta). Sin el flag, el NPC no interactúa.
-- ---------------------------------------------------------------------------------------------
UPDATE `creature_template` ct
JOIN (
    SELECT DISTINCT `id` FROM `creature_queststarter`
    UNION
    SELECT DISTINCT `id` FROM `creature_questender`
) rel ON rel.`id` = ct.`entry`
SET ct.`npcflag` = ct.`npcflag` | 2
WHERE (ct.`npcflag` & 2) = 0;
