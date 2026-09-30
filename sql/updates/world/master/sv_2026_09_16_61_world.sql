-- ============================================================================
--  RP de los Estanques de Vida Rubí (mapa 2521): Melidrussa, Kokia, Kyrakka y Erkhart
-- ============================================================================
--  Quinta estancia con RP. Misma receta append-only (migraciones 58, 59 y 60): filas de habla ids 10..13,
--  que no chocan con las del encuentro (0..4/0..5) y no lo tocan.
--      id 10: event 4 (AGGRO) -> grupo 0 · id 11: event 2 (HEALTH_PCT <= 50, una vez) -> grupo 1
--      id 12: event 5 (KILL)  -> grupo 2 · id 13: event 6 (DEATH) -> grupo 3
--  Se incluye a **Erkhart (199791)**: es la otra mitad de la pelea final (Kyrakka y Erkhart, el jefe_final
--  de la estancia son los dos), y tambien quedo sin RP en la tanda 6.
--  Texto: redaccion nuestra en espanol, con el registro de los Estanques ("vida" roja, fuego y escarcha).
-- ============================================================================

DELETE FROM `smart_scripts` WHERE `source_type` = 0 AND `entryorguid` IN (188252, 189232, 199790, 199791) AND `id` BETWEEN 10 AND 19;
DELETE FROM `creature_text` WHERE `CreatureID` IN (188252, 189232, 199790, 199791);

INSERT INTO `creature_text` (`CreatureID`, `GroupID`, `ID`, `Text`, `Type`, `Language`, `Probability`, `Emote`, `Duration`, `Sound`, `BroadcastTextId`, `TextRange`, `comment`) VALUES
-- Melidrussa Tejescarcha: la que teje la escarcha y llama a las crias
(188252, 0, 0, '¡El hielo apagará vuestro fuego!', 14, 0, 100, 0, 0, 0, 0, 0, 'Melidrussa: entra en combate'),
(188252, 1, 0, '¡Sentid la escarcha en los huesos!', 14, 0, 100, 0, 0, 0, 0, 0, 'Melidrussa: aviso de tormenta/ola'),
(188252, 2, 0, '¡Congelados para siempre!', 14, 0, 100, 0, 0, 0, 0, 0, 'Melidrussa: mata a un jugador'),
(188252, 3, 0, 'El hielo... se... derrite...', 14, 0, 100, 0, 0, 0, 0, 0, 'Melidrussa: muere'),
-- Kokia Pezuña Ardiente: la que aplasta con roca fundida y apila heridas ardientes
(189232, 0, 0, '¡Seréis aplastados bajo la montaña!', 14, 0, 100, 0, 0, 0, 0, 0, 'Kokia: entra en combate'),
(189232, 1, 0, '¡La roca fundida os espera!', 14, 0, 100, 0, 0, 0, 0, 0, 'Kokia: aviso de roca/ritual'),
(189232, 2, 0, '¡Cenizas al viento!', 14, 0, 100, 0, 0, 0, 0, 0, 'Kokia: mata a un jugador'),
(189232, 3, 0, 'El fuego... se... apaga...', 14, 0, 100, 0, 0, 0, 0, 0, 'Kokia: muere'),
-- Kyrakka: el ave de fuego de la pareja final
(199790, 0, 0, '¡Nuestro calor os secará!', 14, 0, 100, 0, 0, 0, 0, 0, 'Kyrakka: entra en combate'),
(199790, 1, 0, '¡Arded conmigo!', 14, 0, 100, 0, 0, 0, 0, 0, 'Kyrakka: aviso de aliento/brasas'),
(199790, 2, 0, '¡Humo y ceniza!', 14, 0, 100, 0, 0, 0, 0, 0, 'Kyrakka: mata a un jugador'),
(199790, 3, 0, 'Erkhart... la tormenta...', 14, 0, 100, 0, 0, 0, 0, 0, 'Kyrakka: muere'),
-- Erkhart Sangre Tormentosa: la tormenta de la pareja final
(199791, 0, 0, '¡El vendaval os arranca del suelo!', 14, 0, 100, 0, 0, 0, 0, 0, 'Erkhart: entra en combate'),
(199791, 1, 0, '¡La tormenta arrecia!', 14, 0, 100, 0, 0, 0, 0, 0, 'Erkhart: aviso de golpe/tormenta'),
(199791, 2, 0, '¡Enterrados en el granizo!', 14, 0, 100, 0, 0, 0, 0, 0, 'Erkhart: mata a un jugador'),
(199791, 3, 0, 'Kyrakka... el viento... cae...', 14, 0, 100, 0, 0, 0, 0, 0, 'Erkhart: muere');

INSERT INTO `smart_scripts`
(`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`,
 `event_param1`, `event_param2`, `event_param3`, `event_param4`,
 `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`,
 `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(188252, 0, 10, 0, 4, 0, 100, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Melidrussa: grito al entrar en combate'),
(188252, 0, 11, 0, 2, 0, 100, 1, 0, 50, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Melidrussa: aviso al bajar del 50%'),
(188252, 0, 12, 0, 5, 0, 100, 0, 0, 0, 0, 0, 1, 2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Melidrussa: grito al matar'),
(188252, 0, 13, 0, 6, 0, 100, 0, 0, 0, 0, 0, 1, 3, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Melidrussa: grito al morir'),
(189232, 0, 10, 0, 4, 0, 100, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Kokia: grito al entrar en combate'),
(189232, 0, 11, 0, 2, 0, 100, 1, 0, 50, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Kokia: aviso al bajar del 50%'),
(189232, 0, 12, 0, 5, 0, 100, 0, 0, 0, 0, 0, 1, 2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Kokia: grito al matar'),
(189232, 0, 13, 0, 6, 0, 100, 0, 0, 0, 0, 0, 1, 3, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Kokia: grito al morir'),
(199790, 0, 10, 0, 4, 0, 100, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Kyrakka: grito al entrar en combate'),
(199790, 0, 11, 0, 2, 0, 100, 1, 0, 50, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Kyrakka: aviso al bajar del 50%'),
(199790, 0, 12, 0, 5, 0, 100, 0, 0, 0, 0, 0, 1, 2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Kyrakka: grito al matar'),
(199790, 0, 13, 0, 6, 0, 100, 0, 0, 0, 0, 0, 1, 3, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Kyrakka: grito al morir'),
(199791, 0, 10, 0, 4, 0, 100, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Erkhart: grito al entrar en combate'),
(199791, 0, 11, 0, 2, 0, 100, 1, 0, 50, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Erkhart: aviso al bajar del 50%'),
(199791, 0, 12, 0, 5, 0, 100, 0, 0, 0, 0, 0, 1, 2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Erkhart: grito al matar'),
(199791, 0, 13, 0, 6, 0, 100, 0, 0, 0, 0, 0, 1, 3, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Erkhart: grito al morir');
