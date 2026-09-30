-- ============================================================================
--  RP de Ara-Kara (mapa 2660): Anub'zekt (215405) y Ki'katal (215407)
-- ============================================================================
--  Estos dos jefes los arme yo con SmartAI en las tandas 1 (migraciones 45 y 46) y **los escribi sin RP**:
--  tenian las mecanicas pero ninguna linea de dialogo. Aca se agrega el habla SIN tocar lo ya hecho.
--
--  COMO (append-only, sin reescribir el guion):
--    Las filas de habla entran como filas NUEVAS con ids 10..13, que no chocan con las del encuentro
--    (esas usan 0..6). Un jefe puede tener varias filas sobre el mismo evento: el motor las corre todas,
--    asi que no hace falta encadenarlas con `link` a las filas existentes.
--      id 10: event 4 (AGGRO)                    -> acción 1 (TALK) grupo 0
--      id 11: event 2 (HEALTH_PCT <= 50, 1 sola vez) -> grupo 1 (aviso de fase)
--      id 12: event 5 (KILL, solo jugadores)     -> grupo 2
--      id 13: event 6 (DEATH)                    -> grupo 3
--    `target_type = 1` (uno mismo) es lo correcto para un grito del jefe.
--
--  Texto: redacción nuestra en español (la wiki no tiene las frases de pelea de estos jefes y los
--  `BroadcastText` del cliente no se pueden atar a una criatura). Anub'zekt es un nerubiano de la colmena
--  y Ki'katal es una cosechadora que cambia sangre por poder: el registro va por ahí.
-- ============================================================================

DELETE FROM `smart_scripts` WHERE `source_type` = 0 AND `entryorguid` IN (215405, 215407) AND `id` BETWEEN 10 AND 19;
DELETE FROM `creature_text` WHERE `CreatureID` IN (215405, 215407);

INSERT INTO `creature_text` (`CreatureID`, `GroupID`, `ID`, `Text`, `Type`, `Language`, `Probability`, `Emote`, `Duration`, `Sound`, `BroadcastTextId`, `TextRange`, `comment`) VALUES
-- Anub'zekt: sale del suelo, ensarta, infecta y llama al enjambre
(215405, 0, 0, '¡La colmena se alza!', 14, 0, 100, 0, 0, 0, 0, 0, 'Anub''zekt: entra en combate'),
(215405, 1, 0, '¡Tiembla la tierra bajo vuestros pies!', 14, 0, 100, 0, 0, 0, 0, 0, 'Anub''zekt: aviso de carga/ensartar'),
(215405, 2, 0, '¡Envuelto en seda, podrido por dentro!', 14, 0, 100, 0, 0, 0, 0, 0, 'Anub''zekt: mata a un jugador'),
(215405, 3, 0, 'La colmena... se apaga...', 14, 0, 100, 0, 0, 0, 0, 0, 'Anub''zekt: muere'),
-- Ki'katal la Cosechadora: el rito de sangre, las sangres que agarran y el enjambre
(215407, 0, 0, '¡Vuestra sangre alimentará el rito!', 14, 0, 100, 0, 0, 0, 0, 0, 'Ki''katal: entra en combate'),
(215407, 1, 0, '¡La Sangre Negra os reclama!', 14, 0, 100, 0, 0, 0, 0, 0, 'Ki''katal: aviso de Sangre Agarrante'),
(215407, 2, 0, '¡Otra ofrenda para el enjambre!', 14, 0, 100, 0, 0, 0, 0, 0, 'Ki''katal: mata a un jugador'),
(215407, 3, 0, 'El rito... queda... incompleto...', 14, 0, 100, 0, 0, 0, 0, 0, 'Ki''katal: muere');

INSERT INTO `smart_scripts`
(`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`,
 `event_param1`, `event_param2`, `event_param3`, `event_param4`,
 `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`,
 `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(215405, 0, 10, 0, 4, 0, 100, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Anub''zekt: grito al entrar en combate'),
(215405, 0, 11, 0, 2, 0, 100, 1, 0, 50, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Anub''zekt: aviso al bajar del 50% (una vez)'),
(215405, 0, 12, 0, 5, 0, 100, 0, 0, 0, 0, 0, 1, 2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Anub''zekt: grito al matar a un jugador'),
(215405, 0, 13, 0, 6, 0, 100, 0, 0, 0, 0, 0, 1, 3, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Anub''zekt: grito al morir'),
(215407, 0, 10, 0, 4, 0, 100, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Ki''katal: grito al entrar en combate'),
(215407, 0, 11, 0, 2, 0, 100, 1, 0, 50, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Ki''katal: aviso al bajar del 50% (una vez)'),
(215407, 0, 12, 0, 5, 0, 100, 0, 0, 0, 0, 0, 1, 2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Ki''katal: grito al matar a un jugador'),
(215407, 0, 13, 0, 6, 0, 100, 0, 0, 0, 0, 0, 1, 3, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Ki''katal: grito al morir');
