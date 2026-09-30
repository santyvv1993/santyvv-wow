-- ============================================================================
--  RP del Reposo de los Reyes (mapa 1762): los 5 jefes
-- ============================================================================
--  Septima estancia con RP. Misma receta append-only de las migraciones 58-63: filas de habla ids 10..13,
--  que no chocan con las del encuentro (0..5) y no lo tocan.
--      id 10: event 4 (AGGRO) -> grupo 0 · id 11: event 2 (HEALTH_PCT <= 50, una vez) -> grupo 1
--      id 12: event 5 (KILL)  -> grupo 2 · id 13: event 6 (DEATH) -> grupo 3
--  NO va aca La serpiente dorada (135322): trae guion del core (`boss_the_golden_serpent`), asi que su RP
--  es solo texto y va aparte, leyendo su enum de frases (mismo camino que Rezan/Vol'kaal/Alun'za).
--  Texto: redaccion nuestra en espanol, con el registro de las tumbas de los reyes Zandalari.
-- ============================================================================

DELETE FROM `smart_scripts` WHERE `source_type` = 0 AND `entryorguid` IN (134993, 135470, 135472, 135475, 136160) AND `id` BETWEEN 10 AND 19;
DELETE FROM `creature_text` WHERE `CreatureID` IN (134993, 135470, 135472, 135475, 136160);

INSERT INTO `creature_text` (`CreatureID`, `GroupID`, `ID`, `Text`, `Type`, `Language`, `Probability`, `Emote`, `Duration`, `Sound`, `BroadcastTextId`, `TextRange`, `comment`) VALUES
-- Mchimba el Embalsamador
(134993, 0, 0, '¡Vuestros cuerpos servirán al rito!', 14, 0, 100, 0, 0, 0, 0, 0, 'Mchimba: entra en combate'),
(134993, 1, 0, '¡La ceremonia exige carne fresca!', 14, 0, 100, 0, 0, 0, 0, 0, 'Mchimba: aviso de drenaje/embalsamado'),
(134993, 2, 0, '¡Otro listo para la tumba!', 14, 0, 100, 0, 0, 0, 0, 0, 'Mchimba: mata a un jugador'),
(134993, 3, 0, 'El rito... queda... a medias...', 14, 0, 100, 0, 0, 0, 0, 0, 'Mchimba: muere'),
-- Aka'ali la Conquistadora
(135470, 0, 0, '¡Ningún intruso sale de estas tumbas!', 14, 0, 100, 0, 0, 0, 0, 0, 'Aka''ali: entra en combate'),
(135470, 1, 0, '¡El juicio de los reyes os condena!', 14, 0, 100, 0, 0, 0, 0, 0, 'Aka''ali: aviso de juicio'),
(135470, 2, 0, '¡Caído ante los reyes eternos!', 14, 0, 100, 0, 0, 0, 0, 0, 'Aka''ali: mata a un jugador'),
(135470, 3, 0, 'Los reyes... me... reclaman...', 14, 0, 100, 0, 0, 0, 0, 0, 'Aka''ali: muere'),
-- Zanazal el Sabio
(135472, 0, 0, '¡Las llamas juzgan a los vivos!', 14, 0, 100, 0, 0, 0, 0, 0, 'Zanazal: entra en combate'),
(135472, 1, 0, '¡Que el fuego os ilumine... o os consuma!', 14, 0, 100, 0, 0, 0, 0, 0, 'Zanazal: aviso de brasas/fuego'),
(135472, 2, 0, '¡Ceniza al viento!', 14, 0, 100, 0, 0, 0, 0, 0, 'Zanazal: mata a un jugador'),
(135472, 3, 0, 'El saber... se... apaga...', 14, 0, 100, 0, 0, 0, 0, 0, 'Zanazal: muere'),
-- Kula la Carnicera
(135475, 0, 0, '¡La carne vuelve a la tumba!', 14, 0, 100, 0, 0, 0, 0, 0, 'Kula: entra en combate'),
(135475, 1, 0, '¡Mi filo os despedaza!', 14, 0, 100, 0, 0, 0, 0, 0, 'Kula: aviso de despedazado'),
(135475, 2, 0, '¡Cortado y servido!', 14, 0, 100, 0, 0, 0, 0, 0, 'Kula: mata a un jugador'),
(135475, 3, 0, 'Mi filo... se... rompe...', 14, 0, 100, 0, 0, 0, 0, 0, 'Kula: muere'),
-- Rey Dazar, el primer rey (jefe final)
(136160, 0, 0, '¡Osasteis despertar a los reyes eternos!', 14, 0, 100, 0, 0, 0, 0, 0, 'Rey Dazar: entra en combate'),
(136160, 1, 0, '¡Arrodillaos ante el primer rey!', 14, 0, 100, 0, 0, 0, 0, 0, 'Rey Dazar: aviso de fase'),
(136160, 2, 0, '¡La tumba os reclama!', 14, 0, 100, 0, 0, 0, 0, 0, 'Rey Dazar: mata a un jugador'),
(136160, 3, 0, 'Los reyes... vuelven... a dormir...', 14, 0, 100, 0, 0, 0, 0, 0, 'Rey Dazar: muere');

INSERT INTO `smart_scripts`
(`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`,
 `event_param1`, `event_param2`, `event_param3`, `event_param4`,
 `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`,
 `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(134993, 0, 10, 0, 4, 0, 100, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Mchimba: grito al entrar en combate'),
(134993, 0, 11, 0, 2, 0, 100, 1, 0, 50, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Mchimba: aviso al bajar del 50%'),
(134993, 0, 12, 0, 5, 0, 100, 0, 0, 0, 0, 0, 1, 2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Mchimba: grito al matar'),
(134993, 0, 13, 0, 6, 0, 100, 0, 0, 0, 0, 0, 1, 3, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Mchimba: grito al morir'),
(135470, 0, 10, 0, 4, 0, 100, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Aka''ali: grito al entrar en combate'),
(135470, 0, 11, 0, 2, 0, 100, 1, 0, 50, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Aka''ali: aviso al bajar del 50%'),
(135470, 0, 12, 0, 5, 0, 100, 0, 0, 0, 0, 0, 1, 2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Aka''ali: grito al matar'),
(135470, 0, 13, 0, 6, 0, 100, 0, 0, 0, 0, 0, 1, 3, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Aka''ali: grito al morir'),
(135472, 0, 10, 0, 4, 0, 100, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Zanazal: grito al entrar en combate'),
(135472, 0, 11, 0, 2, 0, 100, 1, 0, 50, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Zanazal: aviso al bajar del 50%'),
(135472, 0, 12, 0, 5, 0, 100, 0, 0, 0, 0, 0, 1, 2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Zanazal: grito al matar'),
(135472, 0, 13, 0, 6, 0, 100, 0, 0, 0, 0, 0, 1, 3, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Zanazal: grito al morir'),
(135475, 0, 10, 0, 4, 0, 100, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Kula: grito al entrar en combate'),
(135475, 0, 11, 0, 2, 0, 100, 1, 0, 50, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Kula: aviso al bajar del 50%'),
(135475, 0, 12, 0, 5, 0, 100, 0, 0, 0, 0, 0, 1, 2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Kula: grito al matar'),
(135475, 0, 13, 0, 6, 0, 100, 0, 0, 0, 0, 0, 1, 3, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Kula: grito al morir'),
(136160, 0, 10, 0, 4, 0, 100, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Rey Dazar: grito al entrar en combate'),
(136160, 0, 11, 0, 2, 0, 100, 1, 0, 50, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Rey Dazar: aviso al bajar del 50%'),
(136160, 0, 12, 0, 5, 0, 100, 0, 0, 0, 0, 0, 1, 2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Rey Dazar: grito al matar'),
(136160, 0, 13, 0, 6, 0, 100, 0, 0, 0, 0, 0, 1, 3, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Rey Dazar: grito al morir');
