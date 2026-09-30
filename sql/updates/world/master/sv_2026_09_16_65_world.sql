-- ============================================================================
--  RP de la Ciudad de los Hilos (mapa 2669): Nx, Vx, la Coaglamacion e Izo
-- ============================================================================
--  Octava y ultima estancia de las que arme con SmartAI. Misma receta append-only (ids 10..13 sobre los del
--  encuentro 0..5).
--      id 10: event 4 (AGGRO) -> grupo 0 · id 11: event 2 (HEALTH_PCT <= 50, una vez) -> grupo 1
--      id 12: event 5 (KILL)  -> grupo 2 · id 13: event 6 (DEATH) -> grupo 3
--  NO va aca el Orador Krix'vizk (216619): trae guion del core (`boss_orator_krix_vizk`).
--  Texto: redaccion nuestra en espanol, con el registro de la ciudad nerubiana: seda, colmena y la Obra.
--  Nx y Vx son los dos Colmillos de la reina (pelea doble) y hablan como una pareja.
-- ============================================================================

DELETE FROM `smart_scripts` WHERE `source_type` = 0 AND `entryorguid` IN (216648, 216649, 216320, 216658) AND `id` BETWEEN 10 AND 19;
DELETE FROM `creature_text` WHERE `CreatureID` IN (216648, 216649, 216320, 216658);

INSERT INTO `creature_text` (`CreatureID`, `GroupID`, `ID`, `Text`, `Type`, `Language`, `Probability`, `Emote`, `Duration`, `Sound`, `BroadcastTextId`, `TextRange`, `comment`) VALUES
-- Nx, uno de los Colmillos de la reina
(216648, 0, 0, '¡La reina os ha visto!', 14, 0, 100, 0, 0, 0, 0, 0, 'Nx: entra en combate'),
(216648, 1, 0, '¡Tejemos vuestro fin!', 14, 0, 100, 0, 0, 0, 0, 0, 'Nx: aviso de seda/veneno'),
(216648, 2, 0, '¡Envuelto en seda!', 14, 0, 100, 0, 0, 0, 0, 0, 'Nx: mata a un jugador'),
(216648, 3, 0, 'La reina... lo... sabrá...', 14, 0, 100, 0, 0, 0, 0, 0, 'Nx: muere'),
-- Vx, el otro Colmillo (la pareja)
(216649, 0, 0, '¡Colmillos, a la carne!', 14, 0, 100, 0, 0, 0, 0, 0, 'Vx: entra en combate'),
(216649, 1, 0, '¡La seda corta más que el acero!', 14, 0, 100, 0, 0, 0, 0, 0, 'Vx: aviso de corte'),
(216649, 2, 0, '¡Colgado de la telaraña!', 14, 0, 100, 0, 0, 0, 0, 0, 'Vx: mata a un jugador'),
(216649, 3, 0, 'Mi hermana... os... vengará...', 14, 0, 100, 0, 0, 0, 0, 0, 'Vx: muere'),
-- La Coaglamacion: masa viviente de Sangre Negra
(216320, 0, 0, 'La negra... se... mueve...', 14, 0, 100, 0, 0, 0, 0, 0, 'Coaglamacion: entra en combate'),
(216320, 1, 0, 'Devoramos... todo...', 14, 0, 100, 0, 0, 0, 0, 0, 'Coaglamacion: aviso de absorcion'),
(216320, 2, 0, 'Disuelto... en la negra...', 14, 0, 100, 0, 0, 0, 0, 0, 'Coaglamacion: mata a un jugador'),
(216320, 3, 0, 'Se... derrama...', 14, 0, 100, 0, 0, 0, 0, 0, 'Coaglamacion: muere'),
-- Izo, la Gran Fusionadora (jefe final)
(216658, 0, 0, '¡La Gran Obra no se detiene!', 14, 0, 100, 0, 0, 0, 0, 0, 'Izo: entra en combate'),
(216658, 1, 0, '¡Seréis parte del diseño!', 14, 0, 100, 0, 0, 0, 0, 0, 'Izo: aviso de fusion'),
(216658, 2, 0, '¡Fundido en la obra!', 14, 0, 100, 0, 0, 0, 0, 0, 'Izo: mata a un jugador'),
(216658, 3, 0, 'La Gran Obra... es... incompleta...', 14, 0, 100, 0, 0, 0, 0, 0, 'Izo: muere');

INSERT INTO `smart_scripts`
(`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`,
 `event_param1`, `event_param2`, `event_param3`, `event_param4`,
 `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`,
 `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(216648, 0, 10, 0, 4, 0, 100, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Nx: grito al entrar en combate'),
(216648, 0, 11, 0, 2, 0, 100, 1, 0, 50, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Nx: aviso al bajar del 50%'),
(216648, 0, 12, 0, 5, 0, 100, 0, 0, 0, 0, 0, 1, 2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Nx: grito al matar'),
(216648, 0, 13, 0, 6, 0, 100, 0, 0, 0, 0, 0, 1, 3, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Nx: grito al morir'),
(216649, 0, 10, 0, 4, 0, 100, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Vx: grito al entrar en combate'),
(216649, 0, 11, 0, 2, 0, 100, 1, 0, 50, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Vx: aviso al bajar del 50%'),
(216649, 0, 12, 0, 5, 0, 100, 0, 0, 0, 0, 0, 1, 2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Vx: grito al matar'),
(216649, 0, 13, 0, 6, 0, 100, 0, 0, 0, 0, 0, 1, 3, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Vx: grito al morir'),
(216320, 0, 10, 0, 4, 0, 100, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Coaglamacion: grito al entrar en combate'),
(216320, 0, 11, 0, 2, 0, 100, 1, 0, 50, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Coaglamacion: aviso al bajar del 50%'),
(216320, 0, 12, 0, 5, 0, 100, 0, 0, 0, 0, 0, 1, 2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Coaglamacion: grito al matar'),
(216320, 0, 13, 0, 6, 0, 100, 0, 0, 0, 0, 0, 1, 3, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Coaglamacion: grito al morir'),
(216658, 0, 10, 0, 4, 0, 100, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Izo: grito al entrar en combate'),
(216658, 0, 11, 0, 2, 0, 100, 1, 0, 50, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Izo: aviso al bajar del 50%'),
(216658, 0, 12, 0, 5, 0, 100, 0, 0, 0, 0, 0, 1, 2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Izo: grito al matar'),
(216658, 0, 13, 0, 6, 0, 100, 0, 0, 0, 0, 0, 1, 3, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Izo: grito al morir');
