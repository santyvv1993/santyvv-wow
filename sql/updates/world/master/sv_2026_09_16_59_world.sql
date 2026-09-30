-- ============================================================================
--  RP del Priorato de la Llama Sagrada (mapa 2649): Dailcry, Braunpyke y la Prioresa
-- ============================================================================
--  Misma receta que Ara-Kara (migracion 58), que ya quedo verificada: los jefes se armaron con SmartAI en
--  la tanda 4 (migracion 50) SIN RP, y el habla se agrega **append-only** con ids 10..13, que no chocan
--  con los del encuentro (0..6). No se reescribe nada de lo que ya funcionaba.
--      id 10: event 4 (AGGRO) -> grupo 0 · id 11: event 2 (HEALTH_PCT <= 50, una vez) -> grupo 1
--      id 12: event 5 (KILL)  -> grupo 2 · id 13: event 6 (DEATH) -> grupo 3
--  Texto: redaccion nuestra en espanol, con el registro de la catedral de la Llama Sagrada (fe, sentencia,
--  purga). No son las frases de retail: la wiki no las tiene y el cliente no las ata a la criatura.
-- ============================================================================

DELETE FROM `smart_scripts` WHERE `source_type` = 0 AND `entryorguid` IN (207946, 207939, 207940) AND `id` BETWEEN 10 AND 19;
DELETE FROM `creature_text` WHERE `CreatureID` IN (207946, 207939, 207940);

INSERT INTO `creature_text` (`CreatureID`, `GroupID`, `ID`, `Text`, `Type`, `Language`, `Probability`, `Emote`, `Duration`, `Sound`, `BroadcastTextId`, `TextRange`, `comment`) VALUES
-- Capitan Dailcry: el que corta y hace sangrar, y parte el piso con la lanza
(207946, 0, 0, '¡Por la Llama Sagrada, no pasareis!', 14, 0, 100, 0, 0, 0, 0, 0, 'Dailcry: entra en combate'),
(207946, 1, 0, '¡Que la luz os parta en dos!', 14, 0, 100, 0, 0, 0, 0, 0, 'Dailcry: aviso de lanza/desgarro'),
(207946, 2, 0, '¡La Llama juzga y condena!', 14, 0, 100, 0, 0, 0, 0, 0, 'Dailcry: mata a un jugador'),
(207946, 3, 0, 'La Llama... me... perdona...', 14, 0, 100, 0, 0, 0, 0, 0, 'Dailcry: muere'),
-- Baron Braunpyke: se potencia, se escuda y llama al martillo
(207939, 0, 0, '¡Mi martillo trae la sentencia!', 14, 0, 100, 0, 0, 0, 0, 0, 'Braunpyke: entra en combate'),
(207939, 1, 0, '¡La luz me protege, necios!', 14, 0, 100, 0, 0, 0, 0, 0, 'Braunpyke: aviso de escudo'),
(207939, 2, 0, '¡Arrodillaos ante la Llama!', 14, 0, 100, 0, 0, 0, 0, 0, 'Braunpyke: mata a un jugador'),
(207939, 3, 0, 'La luz... se... apaga...', 14, 0, 100, 0, 0, 0, 0, 0, 'Braunpyke: muere'),
-- Prioresa Murrpray: castiga, se enciende y se escuda al 50%
(207940, 0, 0, '¡Nadie profana este santuario!', 14, 0, 100, 0, 0, 0, 0, 0, 'Murrpray: entra en combate'),
(207940, 1, 0, '¡Que el fuego os purifique!', 14, 0, 100, 0, 0, 0, 0, 0, 'Murrpray: aviso de llama/rayo'),
(207940, 2, 0, '¡La Llama os reclama!', 14, 0, 100, 0, 0, 0, 0, 0, 'Murrpray: mata a un jugador'),
(207940, 3, 0, 'Perdonadme... Llama...', 14, 0, 100, 0, 0, 0, 0, 0, 'Murrpray: muere');

INSERT INTO `smart_scripts`
(`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`,
 `event_param1`, `event_param2`, `event_param3`, `event_param4`,
 `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`,
 `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(207946, 0, 10, 0, 4, 0, 100, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Dailcry: grito al entrar en combate'),
(207946, 0, 11, 0, 2, 0, 100, 1, 0, 50, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Dailcry: aviso al bajar del 50%'),
(207946, 0, 12, 0, 5, 0, 100, 0, 0, 0, 0, 0, 1, 2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Dailcry: grito al matar'),
(207946, 0, 13, 0, 6, 0, 100, 0, 0, 0, 0, 0, 1, 3, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Dailcry: grito al morir'),
(207939, 0, 10, 0, 4, 0, 100, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Braunpyke: grito al entrar en combate'),
(207939, 0, 11, 0, 2, 0, 100, 1, 0, 50, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Braunpyke: aviso al bajar del 50%'),
(207939, 0, 12, 0, 5, 0, 100, 0, 0, 0, 0, 0, 1, 2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Braunpyke: grito al matar'),
(207939, 0, 13, 0, 6, 0, 100, 0, 0, 0, 0, 0, 1, 3, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Braunpyke: grito al morir'),
(207940, 0, 10, 0, 4, 0, 100, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Murrpray: grito al entrar en combate'),
(207940, 0, 11, 0, 2, 0, 100, 1, 0, 50, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Murrpray: aviso al bajar del 50% (se escuda)'),
(207940, 0, 12, 0, 5, 0, 100, 0, 0, 0, 0, 0, 1, 2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Murrpray: grito al matar'),
(207940, 0, 13, 0, 6, 0, 100, 0, 0, 0, 0, 0, 1, 3, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Murrpray: grito al morir');
