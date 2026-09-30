-- ============================================================================================
-- Isla del Exilio (zona 10424 · mapas 2175/2261/2369) · P8c: las MISIONES DE CLASE.
-- ============================================================================================
-- APLICADA a la base viva el 17-sep-2026 (migración 2026_09_17_05 del repo).
-- Validación previa: el mismo SQL se corrió DOS veces dentro de una transacción con ROLLBACK
-- sobre la base viva -> 14 spawns nuevos, 28 dadores, 29 cierres, 36 filas de
-- quest_template_addon y las filas de phase_area/conditions 4 -> 9; la segunda pasada no
-- agregó ni una fila (idempotente) y la base quedó intacta hasta la aplicación real.
--
-- Qué cierra: las 28 misiones de clase de los dos bandos que hoy no tienen quién las dé
-- (`creature_queststarter`). Con las migraciones 2026_09_16_04 y _05 la isla ya llega hasta el
-- tramo final, pero las cadenas de clase seguían muertas: los entrenadores de clase o no están
-- spawneados en ningún mapa o no tienen fila en la tabla de relaciones.
--
-- De dónde sale cada dato (nada inventado):
--
--  1) QUIÉN da y cierra cada misión y QUÉ clase es: la wiki canónica (`warcraft.wiki.gg`,
--     Questbox: start/end/previous/next) bajada con `herramientas/misiones-wiki.py`
--     (`docs/inventario/misiones-isla-del-exilio-parche.md` + `misiones-isla-del-exilio-wiki.json`).
--     La clase NO es una suposición: cada par Alianza/Horda comparte el `RewardSpell` que enseña
--     la habilidad (58914 = 59971 = 317073 «Execute» → guerrero; 58917 = 59967 = 317099 «Instant
--     Poison» → pícaro; 58923 = 59958 = 317131 → paladín; 58953 = 59961 = 317430 → sacerdote;
--     58962 = 59970 = 317521 → brujo; 59002 = 59969 = 317706 → chamán; 59355 = 59952 = 321159 →
--     cazador; 59352 = 59954 = 321117 → mago; 59350 = 59951 = 321047 → druida), y el título de la
--     cadena lo dice («A Rogue's End», «A Paladin's Service», …). De ahí sale la máscara de clase
--     (bit 1 << (clase-1)) que va en `quest_template_addon.AllowableClasses`.
--
--  2) ENTRADA del NPC: `world.quest_objectives.ObjectID` de su propia misión («Speak with the ghost
--     paladin» → 162998 Yorah; «First expedition's rogue found» → 162972 Coulston Nereus; …) y, si no
--     hay objetivo que la cite, el bloque de IDs del bando + el flag NPC: por ejemplo el «Summoned
--     Voidwalker» de la Alianza (163246) vive en el mismo bloque 162xxx-163xxx que el resto del
--     elenco de clase aliado y la Horda usa 167481 para la misma misión (167/167xxx), con
--     UNIT_NPC_FLAG_QUESTGIVER. Todas las entradas elegidas existen en `creature_template`; a las
--     que les falta el flag de dador se les pone al final del archivo (misma red de seguridad que
--     en las migraciones anteriores).
--
--  3) POSICIÓN (x, y, z): `world.quest_poi` + `world.quest_poi_points` — el propio dato de la
--     misión, en coordenadas del mundo y sin conversión. Es mejor fuente que la API de Wowhead que
--     se usó en las migraciones 04/05: acá el punto está a 0 yd de error porque no hay que
--     transformar nada (p. ej. 58917 trae (167,-2062,77) para el cadáver de Coulston Nereus y el
--     spawn real que ya existe en el mapa está a 4 yd). Cuando la misión no trae POI para el NPC se
--     usó la conversión afín calibrada de `herramientas/misiones-posiciones.py`
--     (error mediano 2,3 yd; `herramientas/calibracion-afin.json`), y en todos los casos la Z se
--     contrastó contra el spawn vecino que ya existe (columna que se cita por NPC en el informe).
--     La `orientation` va en 0: no hay fuente para ella, se ajusta en el juego.
--
--  4) FASE: la capa de clase usa las dos fases que la TDB ya dedica a ese tramo y que se activan
--     justo cuando la wiki dice que se abren las misiones de clase («Stocking Up on Supplies»):
--       · Alianza → fase 15011 «Cosmetic - See Private Cole at Alliance Populated Camp»
--         (condición: misión 55879 «Ride of the Scientifically Enhanced Boar» entregada, que es la
--         que va inmediatamente antes de Stocking Up on Supplies).
--       · Horda   → fase 15447 «Cosmetic - NPE - See Grunt Throg at Ogre Ruins»
--         (condición: misión 59942 «The Re-Deather» entregada, el espejo Horda de 55879).
--     Las dos fases solo estaban declaradas para las áreas del campamento (15011: 10527/10529/10588)
--     y para el área padre (15447: 10424), así que se agregan las filas de `phase_area` y las
--     `conditions` que faltan para las áreas donde viven los entrenadores (11011 Killclaw's Lair,
--     10530 Piedra del druida). Sin esa fila el NPC existiría en una fase que el jugador no recibe
--     en esa área: invisible para siempre (el mismo error que dejó invisibles a Bo y Shuja en 15354).
--
--  5) ORDEN: `PrevQuestID` según la wiki (start/previous), solo dentro del mismo bando. Donde la
--     wiki lista dos prerrequisitos o su campo viene mal formado, se deja sin `PrevQuestID` y se
--     anota en el informe (no se inventa una cadena).
--
-- Idempotente: INSERT IGNORE / ON DUPLICATE KEY en todo.
--
-- Evidencia completa, NPC por NPC, con la fuente de cada coordenada y la auditoría antes/después:
--   docs/investigacion/misiones-clase-exilio.md
-- ============================================================================================


-- --------------------------------------------------------------------------------------------
-- 1) La capa de clase en las áreas que faltaban (fase → área) y sus condiciones.
--    15011 ya está declarada para 10527/10529/10588; se agrega 11011 (Killclaw's Lair), donde está
--    Coulston Nereus / Drizza Sidestabber. 15447 ya está declarada para 10424 (toda la zona); se
--    agregan las subáreas donde viven los entrenadores para no depender del área padre.
-- --------------------------------------------------------------------------------------------
INSERT IGNORE INTO `phase_area` (`AreaId`, `PhaseId`, `Comment`) VALUES
(11011, 15011, 'Cosmetic - See Private Cole at Alliance Populated Camp (Killclaw''s Lair)'),
(10529, 15447, 'Cosmetic - NPE - See Grunt Throg at Ogre Ruins (Horde Populated Camp)'),
(10588, 15447, 'Cosmetic - NPE - See Grunt Throg at Ogre Ruins (Darkmaul Plains)'),
(11011, 15447, 'Cosmetic - NPE - See Grunt Throg at Ogre Ruins (Killclaw''s Lair)'),
(10530, 15447, 'Cosmetic - NPE - See Grunt Throg at Ogre Ruins (Druid Stone)');

INSERT IGNORE INTO `conditions`
    (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`,
     `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`,
     `ConditionValue3`, `ConditionStringValue1`, `NegativeCondition`, `ErrorType`, `ErrorTextId`,
     `ScriptName`, `Comment`) VALUES
-- Mismo criterio que la fila que ya existe para 15011 en 10527/10529/10588.
(26, 15011, 11011, 0, 0, 47, 0, 55879, 64, 0, '', 0, 0, 0, '', 'Apply Phase 15011 if Quest 55879 (Ride of the Scientifically Enhanced Boar) is rewarded'),
-- Mismo criterio que la fila que ya existe para 15447 en 10424.
(26, 15447, 10529, 0, 0, 47, 0, 59942, 64, 0, '', 0, 0, 0, '', 'Apply Phase 15447 if Quest 59942 (The Re-Deather) is rewarded'),
(26, 15447, 10588, 0, 0, 47, 0, 59942, 64, 0, '', 0, 0, 0, '', 'Apply Phase 15447 if Quest 59942 (The Re-Deather) is rewarded'),
(26, 15447, 11011, 0, 0, 47, 0, 59942, 64, 0, '', 0, 0, 0, '', 'Apply Phase 15447 if Quest 59942 (The Re-Deather) is rewarded'),
(26, 15447, 10530, 0, 0, 47, 0, 59942, 64, 0, '', 0, 0, 0, '', 'Apply Phase 15447 if Quest 59942 (The Re-Deather) is rewarded');


-- --------------------------------------------------------------------------------------------
-- 2) Los entrenadores de clase que no están spawneados en ningún mapa (12 NPC).
--    x,y,z salen del POI de su propia misión (`quest_poi_points`); el informe cita por NPC el
--    vecino que se usó para contrastar la Z. Fase: 15011 (Alianza) / 15447 (Horda).
--    Hjalmar (162943) y el Ghost Wolf (163329) son del mismo bando los dos: la wiki les da
--    reacción Alianza **y** Horda, así que van dos filas de la misma entrada, una por fase.
-- --------------------------------------------------------------------------------------------
INSERT IGNORE INTO `creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`,
    `phaseUseFlags`, `PhaseId`, `PhaseGroup`, `terrainSwapMap`, `modelid`, `equipment_id`,
    `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`,
    `currentwaypoint`, `MovementType`, `VerifiedBuild`) VALUES
-- ---- Alianza (fase 15011) ----
-- Hjalmar the Undying — POI de 58914/58915 (extremidad oeste del Puente de Darkmaul)
(11801101, 162943, 2175, 10424, 10588, '0', 0, 15011, 0, -1, 0, 0, 355.00, -2264.00, 103.00, 0.0000, 120, 0, 0, 0, 0),
-- Coulston Nereus — POI de 58917/58933 (Killclaw's Lair)
(11801102, 162972, 2175, 10424, 11011, '0', 0, 15011, 0, -1, 0, 0, 167.00, -2062.00, 77.00, 0.0000, 120, 0, 0, 0, 0),
-- Yorah — POI de 58923/58946 (Darkmaul Plains)
(11801103, 162998, 2175, 10424, 10588, '0', 0, 15011, 0, -1, 0, 0, 248.00, -2453.00, 120.00, 0.0000, 120, 0, 0, 0, 0),
-- Branven Hammerheart — POI de 58953/58960 (Darkmaul Plains)
(11801104, 163108, 2175, 10424, 10588, '0', 0, 15011, 0, -1, 0, 0, 223.00, -2416.00, 90.00, 0.0000, 120, 0, 0, 0, 0),
-- Ghost Wolf — POI de 59002 (campamento poblado)
(11801105, 163329, 2175, 10424, 10529, '0', 0, 15011, 0, -1, 0, 0, 179.00, -2287.00, 82.00, 0.0000, 120, 0, 0, 0, 0),
-- Summoned Voidwalker — POI del objetivo 3 de 58962 (sitio del grimorio)
(11801106, 163246, 2175, 10424, 10588, '0', 0, 15011, 0, -1, 0, 0, 408.00, -2298.00, 113.00, 0.0000, 120, 0, 0, 0, 0),
-- ---- Horda (fase 15447) ----
-- Hjalmar the Undying — POI de 59971/59972 (mismo sitio que el de la Alianza)
(11801111, 162943, 2175, 10424, 10588, '0', 0, 15447, 0, -1, 0, 0, 355.00, -2264.00, 103.00, 0.0000, 120, 0, 0, 0, 0),
-- Daelya Twilightsbane — POI de 59958/60174 (Darkmaul Plains; 15 yd de Yorah, el espejo aliado)
(11801112, 167179, 2175, 10424, 10588, '0', 0, 15447, 0, -1, 0, 0, 256.00, -2465.00, 120.00, 0.0000, 120, 0, 0, 0, 0),
-- Drizza Sidestabber — POI de 59967 (Killclaw's Lair; mismo sitio que Coulston)
(11801113, 167184, 2175, 10424, 11011, '0', 0, 15447, 0, -1, 0, 0, 167.00, -2062.00, 77.00, 0.0000, 120, 0, 0, 0, 0),
-- Sha'zul — POI de 59961/59965 (Darkmaul Plains; mismo sitio que Branven)
(11801114, 167188, 2175, 10424, 10588, '0', 0, 15447, 0, -1, 0, 0, 222.00, -2416.00, 90.00, 0.0000, 120, 0, 0, 0, 0),
-- Herbert Gloomburst — POI de 59954/59955 (campamento poblado; el objetivo de 59955 lo cita)
(11801115, 167309, 2175, 10424, 10529, '0', 0, 15447, 0, -1, 0, 0, 182.00, -2282.00, 82.00, 0.0000, 120, 0, 0, 0, 0),
-- Crenna Earth-Daughter — POI de 59951 y espejo de Ralia Dreamchaser 164907, que ya vive ahí
-- en la fase aliada 15005 (Piedra del druida, área 10530)
(11801116, 167473, 2175, 10424, 10530, '0', 0, 15447, 0, -1, 0, 0, 321.00, -2057.00, 112.00, 0.0000, 120, 0, 0, 0, 0),
-- Ghost Wolf — POI de 59969 (mismo sitio que el de la Alianza)
(11801117, 163329, 2175, 10424, 10529, '0', 0, 15447, 0, -1, 0, 0, 179.00, -2287.00, 82.00, 0.0000, 120, 0, 0, 0, 0),
-- Summoned Voidwalker — la base ya lo usa como entregador de 59970; el POI lo pone acá
(11801118, 167481, 2175, 10424, 10588, '0', 0, 15447, 0, -1, 0, 0, 408.00, -2298.00, 111.00, 0.0000, 120, 0, 0, 0, 0);


-- --------------------------------------------------------------------------------------------
-- 3) Quién da y quién cierra cada misión de clase.
--    Alianza: el hub es Private Cole (156801, ya spawneado en la fase 15011) y los fantasmas del
--    primer destacamento. Horda: el hub es Grunt Throg (167216, ya spawneado en la fase 15447) y
--    los entrenadores del campamento/nido.
-- --------------------------------------------------------------------------------------------
INSERT IGNORE INTO `creature_queststarter` (`id`, `quest`, `VerifiedBuild`) VALUES
-- ---- Alianza ----
-- Private Cole (fase 15011): hub de las cadenas de guerrero, pícaro, paladín, sacerdote y brujo
(156801, 58914, 0),
(156801, 58917, 0),
(156801, 58923, 0),
(156801, 58953, 0),
(156801, 58962, 0),
-- Hjalmar the Undying (fase 15011): la segunda parte del guerrero
(162943, 58915, 0),
-- Coulston Nereus (fase 15011): la segunda parte del pícaro
(162972, 58933, 0),
-- Yorah (fase 15011): la segunda parte del paladín
(162998, 58946, 0),
-- Branven Hammerheart (fase 15011): la segunda parte del sacerdote
(163108, 58960, 0),
-- Ghost Wolf (fase 15011): chamán
(163329, 59002, 0),
-- ---- Horda ----
-- Crenna Earth-Daughter (fase 15447): druida
(167473, 59951, 0),
-- Mithdran Dawntracker (fase 15377, ya spawneado): cazador
(167215, 59952, 0),
(167215, 59953, 0),
(167215, 60162, 0),
-- Herbert Gloomburst (fase 15447, nuevo): mago
(167309, 59954, 0),
(167309, 59955, 0),
-- Bo (fase 15354, ya spawneado en el nido de arpías): monje
(167291, 59956, 0),
(167291, 59957, 0),
-- Grunt Throg (fase 15447, ya spawneado): hub de las cadenas de paladín, sacerdote, pícaro,
-- brujo y guerrero
(167216, 59958, 0),
(167216, 59961, 0),
(167216, 59967, 0),
(167216, 59970, 0),
(167216, 59971, 0),
-- Daelya Twilightsbane (fase 15447): la segunda parte del paladín
(167179, 60174, 0),
-- Sha'zul (fase 15447): la segunda parte del sacerdote
(167188, 59965, 0),
-- Drizza Sidestabber (fase 15447): la segunda parte del pícaro
(167184, 59968, 0),
-- Hjalmar the Undying (fase 15447): la segunda parte del guerrero
(162943, 59972, 0),
-- Ghost Wolf (fase 15447): chamán
(163329, 59969, 0);

INSERT IGNORE INTO `creature_questender` (`id`, `quest`, `VerifiedBuild`) VALUES
-- ---- Alianza ----
-- Hjalmar the Undying: cierra A Warrior's End
(162943, 58914, 0),
-- Private Cole: cierra la segunda parte de guerrero / pícaro / brujo
(156801, 58915, 0),
(156801, 58933, 0),
(156801, 58962, 0),
-- Private Cole: cierra El escudo divino y Paladín — el POI de entrega de 58946 es el campamento
-- (186,-2280), no la posición de Yorah
(156801, 58946, 0),
-- Coulston Nereus: cierra A Rogue's End
(162972, 58917, 0),
-- Yorah: cierra A Paladin's Service
(162998, 58923, 0),
-- Branven Hammerheart: cierra A Priest's End y Resurrecting the Recruits (POI de entrega en su
-- propia posición, 223,-2416)
(163108, 58953, 0),
(163108, 58960, 0),
-- Summoned Voidwalker: cierra A Warlock's Bargain
(163246, 58962, 0),
-- Ghost Wolf: cierra A Shaman's Duty (POI de entrega en su propia posición)
(163329, 59002, 0),
-- Ghost Wolf: cierra la copia Horda de la misma misión (mismo POI de entrega)
(163329, 59969, 0),
-- ---- Horda ----
-- Crenna Earth-Daughter: la wiki la da como inicio y fin de A Druid's Form
(167473, 59951, 0),
-- Mithdran Dawntracker: cierra cazador (POI de entrega en su propia posición, 183,-2296)
(167215, 59952, 0),
(167215, 59953, 0),
(167215, 60162, 0),
-- Herbert Gloomburst: cierra las dos del mago (POI de entrega en su propia posición)
(167309, 59954, 0),
(167309, 59955, 0),
-- Bo: cierra A Monk's Focus (el POI de entrega apunta al campamento; ver desvío en el informe)
(167291, 59956, 0),
-- Warlord Breka Grimaxe: cierra One Last Spar. Se usa 166906, la Breka que YA existe en el mundo
-- (campamento abandonado, fase 15298); el POI pide ese cierre en (317,-2298). Desvío anotado.
(166906, 59957, 0),
-- Daelya Twilightsbane: cierra A Paladin's Service y El escudo divino
(167179, 59958, 0),
(167179, 60174, 0),
-- Sha'zul: cierra A Priest's End y Resurrecting the Recruits
(167188, 59961, 0),
(167188, 59965, 0),
-- Drizza Sidestabber: cierra A Rogue's End
(167184, 59967, 0),
-- Grunt Throg: cierra la segunda parte de pícaro y guerrero
(167216, 59968, 0),
(167216, 59972, 0),
-- Summoned Voidwalker: cierra A Warlock's Bargain (la relación ya existía; la fila es idempotente)
(167481, 59970, 0),
-- Hjalmar the Undying: cierra A Warrior's End (Horda)
(162943, 59971, 0);


-- --------------------------------------------------------------------------------------------
-- 4) Máscara de clase (bit 1 << (clase-1)) y orden de la cadena (PrevQuestID).
--    La TDB no tiene fila en `quest_template_addon` para ninguna de estas misiones, así que hay que
--    INSERTAR (no actualizar); ON DUPLICATE KEY deja intacto lo que ya existiera.
--    Máscaras: guerrero 1 · paladín 2 · cazador 4 · pícaro 8 · sacerdote 16 · chamán 64 ·
--              mago 128 · brujo 256 · monje 512 · druida 1024.
-- --------------------------------------------------------------------------------------------
INSERT INTO `quest_template_addon` (`ID`, `AllowableClasses`, `PrevQuestID`) VALUES
-- Guerreros (58914 = A Warrior's End, 58915 = Hjalmar's Final Execution, par Horda 59971/59972)
(58914, 1, 55639),      -- prev: Who Lurks in the Pit (Alianza)
(58915, 1, 58914),
(59971, 1, 59950),      -- prev: Stocking Up on Supplies (Horda)
(59972, 1, 59971),
-- Paladines (58923/58946 y 59958/60174)
(58923, 2, 55194),      -- prev inferido del espejo Horda 59958 (la wiki trae el campo mal armado)
(58946, 2, 58923),
(59958, 2, 59950),      -- prev: Stocking Up on Supplies (Horda)
(60174, 2, 59958),
-- Cazadores (59355/59356/60168 y 59952/59953/60162)
(59355, 4, 0),          -- prev: Message to Base **y** Who Lurks in the Pit: dos, no se puede con un ID
(59356, 4, 59355),
(60168, 4, 59356),
(59952, 4, 0),          -- ídem (Message to Base + Who Lurks in the Pit, Horda)
(59953, 4, 59952),
(60162, 4, 59953),
-- Pícaros (58917/58933 y 59967/59968)
(58917, 8, 55194),      -- prev: Stocking Up on Supplies (Alianza)
(58933, 8, 58917),
(59967, 8, 59950),      -- prev: Stocking Up on Supplies (Horda)
(59968, 8, 59967),
-- Sacerdotes (58953/58960 y 59961/59965)
(58953, 16, 55194),     -- prev inferido del espejo Horda 59961
(58960, 16, 58953),
(59961, 16, 59950),     -- prev: Stocking Up on Supplies (Horda)
(59965, 16, 59961),
-- Chamanes (59002 Alianza / 59969 Horda: el par comparte el RewardSpell 317706)
(59002, 64, 55639),     -- prev: Who Lurks in the Pit (Alianza)
(59969, 64, 0),         -- la wiki no documenta un prev propio para la copia Horda
-- Magos (59352/59354 y 59954/59955)
(59352, 128, 0),        -- la wiki trae el campo mal armado; ver informe
(59354, 128, 59352),
(59954, 128, 59947),    -- prev: Message to Base (Horda)
(59955, 128, 59954),
-- Brujos (58962 y 59970)
(58962, 256, 55639),    -- prev: Who Lurks in the Pit (Alianza)
(59970, 256, 59950),    -- prev: Stocking Up on Supplies (Horda)
-- Monjes (59347/59349 y 59956/59957)
(59347, 512, 0),        -- la wiki trae el campo mal armado; ver informe
(59349, 512, 59347),
(59956, 512, 0),        -- prev: Message to Base **y** Who Lurks in the Pit: dos
(59957, 512, 59956),
-- Druidas (59350 Alianza / 59951 Horda)
(59350, 1024, 55639),   -- prev: Who Lurks in the Pit (Alianza)
(59951, 1024, 59949)    -- prev: Who Lurks in the Pit (Horda)
ON DUPLICATE KEY UPDATE `AllowableClasses` = VALUES(`AllowableClasses`),
                        `PrevQuestID`      = VALUES(`PrevQuestID`);


-- --------------------------------------------------------------------------------------------
-- 5) Red de seguridad del flag de dador (UNIT_NPC_FLAG_QUESTGIVER = 0x2) para las criaturas que
--    acaban de recibir relación. Mismo UPDATE que 2026_09_16_01/04/05: sin el flag el NPC no
--    interactúa y la relación no sirve de nada.
-- --------------------------------------------------------------------------------------------
UPDATE `creature_template` ct
JOIN (
    SELECT DISTINCT `id` FROM `creature_queststarter`
    UNION
    SELECT DISTINCT `id` FROM `creature_questender`
) rel ON rel.`id` = ct.`entry`
SET ct.`npcflag` = ct.`npcflag` | 2
WHERE (ct.`npcflag` & 2) = 0;
