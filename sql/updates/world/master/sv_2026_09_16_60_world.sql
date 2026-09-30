-- ============================================================================
--  RP del Ojo de Azshara (mapa 1456): Parjesh, Lady Odio Espiral, Serpentrix y la Colera
-- ============================================================================
--  Cuarta estancia con RP. Misma receta append-only de las migraciones 58 (Ara-Kara) y 59 (Priorato):
--  los cuatro jefes se armaron con SmartAI en la tanda 5 (migracion 51) sin RP, y el habla se agrega con
--  filas ids 10..13 que no chocan con las del encuentro (0..6). No se reescribe nada.
--      id 10: event 4 (AGGRO) -> grupo 0 · id 11: event 2 (HEALTH_PCT <= 50, una vez) -> grupo 1
--      id 12: event 5 (KILL)  -> grupo 2 · id 13: event 6 (DEATH) -> grupo 3
--  Rey Barbahonda (91797) NO va aca: trae guion del core y ya tiene sus propios textos en la base.
--  Texto: redaccion nuestra en espanol, con el registro del mar (mareas, tormentas, veneno, la reina
--  Azshara). No son las frases de retail: la wiki no las tiene y el cliente no las ata a la criatura.
-- ============================================================================

DELETE FROM `smart_scripts` WHERE `source_type` = 0 AND `entryorguid` IN (91784, 91789, 91808, 96028) AND `id` BETWEEN 10 AND 19;
DELETE FROM `creature_text` WHERE `CreatureID` IN (91784, 91789, 91808, 96028);

INSERT INTO `creature_text` (`CreatureID`, `GroupID`, `ID`, `Text`, `Type`, `Language`, `Probability`, `Emote`, `Duration`, `Sound`, `BroadcastTextId`, `TextRange`, `comment`) VALUES
-- Parjesh, señor de la guerra de las profundidades: lanza, ensarta y llama refuerzos
(91784, 0, 0, '¡El mar os reclama, intrusos!', 14, 0, 100, 0, 0, 0, 0, 0, 'Parjesh: entra en combate'),
(91784, 1, 0, '¡Cientos de lanzas os esperan!', 14, 0, 100, 0, 0, 0, 0, 0, 'Parjesh: aviso de lluvia de lanzas'),
(91784, 2, 0, '¡Ahogado en mi propia marea!', 14, 0, 100, 0, 0, 0, 0, 0, 'Parjesh: mata a un jugador'),
(91784, 3, 0, 'Azshara... mi reina...', 14, 0, 100, 0, 0, 0, 0, 0, 'Parjesh: muere'),
-- Lady Odio Espiral: la bruja del mar que levanta la tormenta
(91789, 0, 0, '¡La tormenta obedece a mi voz!', 14, 0, 100, 0, 0, 0, 0, 0, 'Hatecoil: entra en combate'),
(91789, 1, 0, '¡Sentid el poder de la tormenta!', 14, 0, 100, 0, 0, 0, 0, 0, 'Hatecoil: aviso de nova/monson'),
(91789, 2, 0, '¡El mar os traga!', 14, 0, 100, 0, 0, 0, 0, 0, 'Hatecoil: mata a un jugador'),
(91789, 3, 0, 'Mi reina... la tormenta... se apaga...', 14, 0, 100, 0, 0, 0, 0, 0, 'Hatecoil: muere'),
-- Serpentrix: la serpiente que escupe veneno y se sumerge
(91808, 0, 0, 'Sssssiente el veneno de las profundidades.', 14, 0, 100, 0, 0, 0, 0, 0, 'Serpentrix: entra en combate'),
(91808, 1, 0, '¡El veneno corre por vuestras venas!', 14, 0, 100, 0, 0, 0, 0, 0, 'Serpentrix: aviso de inmersion/veneno'),
(91808, 2, 0, '¡Devueltos al fondo!', 14, 0, 100, 0, 0, 0, 0, 0, 'Serpentrix: mata a un jugador'),
(91808, 3, 0, 'El abismo... me llama...', 14, 0, 100, 0, 0, 0, 0, 0, 'Serpentrix: muere'),
-- La Colera de Azshara: el jefe final, la furia del mar hecha elemento
(96028, 0, 0, '¡Las mareas se alzan contra vosotros!', 14, 0, 100, 0, 0, 0, 0, 0, 'Colera de Azshara: entra en combate'),
(96028, 1, 0, '¡Ningun barco sobrevive a mi furia!', 14, 0, 100, 0, 0, 0, 0, 0, 'Colera de Azshara: aviso de diluvio/tornados'),
(96028, 2, 0, '¡Al fondo del mar!', 14, 0, 100, 0, 0, 0, 0, 0, 'Colera de Azshara: mata a un jugador'),
(96028, 3, 0, 'La marea... se... retira...', 14, 0, 100, 0, 0, 0, 0, 0, 'Colera de Azshara: muere');

INSERT INTO `smart_scripts`
(`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`,
 `event_param1`, `event_param2`, `event_param3`, `event_param4`,
 `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`,
 `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(91784, 0, 10, 0, 4, 0, 100, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Parjesh: grito al entrar en combate'),
(91784, 0, 11, 0, 2, 0, 100, 1, 0, 50, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Parjesh: aviso al bajar del 50%'),
(91784, 0, 12, 0, 5, 0, 100, 0, 0, 0, 0, 0, 1, 2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Parjesh: grito al matar'),
(91784, 0, 13, 0, 6, 0, 100, 0, 0, 0, 0, 0, 1, 3, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Parjesh: grito al morir'),
(91789, 0, 10, 0, 4, 0, 100, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Hatecoil: grito al entrar en combate'),
(91789, 0, 11, 0, 2, 0, 100, 1, 0, 50, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Hatecoil: aviso al bajar del 50%'),
(91789, 0, 12, 0, 5, 0, 100, 0, 0, 0, 0, 0, 1, 2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Hatecoil: grito al matar'),
(91789, 0, 13, 0, 6, 0, 100, 0, 0, 0, 0, 0, 1, 3, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Hatecoil: grito al morir'),
(91808, 0, 10, 0, 4, 0, 100, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Serpentrix: grito al entrar en combate'),
(91808, 0, 11, 0, 2, 0, 100, 1, 0, 50, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Serpentrix: aviso al bajar del 50%'),
(91808, 0, 12, 0, 5, 0, 100, 0, 0, 0, 0, 0, 1, 2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Serpentrix: grito al matar'),
(91808, 0, 13, 0, 6, 0, 100, 0, 0, 0, 0, 0, 1, 3, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Serpentrix: grito al morir'),
(96028, 0, 10, 0, 4, 0, 100, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Colera de Azshara: grito al entrar en combate'),
(96028, 0, 11, 0, 2, 0, 100, 1, 0, 50, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Colera de Azshara: aviso al bajar del 50%'),
(96028, 0, 12, 0, 5, 0, 100, 0, 0, 0, 0, 0, 1, 2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Colera de Azshara: grito al matar'),
(96028, 0, 13, 0, 6, 0, 100, 0, 0, 0, 0, 0, 1, 3, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Colera de Azshara: grito al morir');
