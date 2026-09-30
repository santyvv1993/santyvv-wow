-- ============================================================================
--  RP de Grieta Llama Oscura (mapa 2651): Ol' Waxbeard (210153) y La Oscuridad (210797)
-- ============================================================================
--  Sexta estancia con RP. Misma receta append-only (ids 10..13 sobre los del encuentro 0..4):
--      id 10: event 4 (AGGRO) -> grupo 0 · id 11: event 2 (HEALTH_PCT <= 50, una vez) -> grupo 1
--      id 12: event 5 (KILL)  -> grupo 2 · id 13: event 6 (DEATH) -> grupo 3
--  NO van aca:
--    · El Rey Vela (208745): trae guion del core (`boss_the_candle_king`), su RP es suyo.
--    · Blazikon (208743): su guion existe (migracion 53) pero **no tiene spawn** — falta que Santiago lo
--      ponga en el mapa con `.npc add 208743`. Cuando exista, ya tendra mecanicas; el habla se le agrega
--      despues, cuando sepamos que la criatura existe de verdad.
--  Texto: redaccion nuestra en espanol. Waxbeard es un kobold gruñon de las velas y La Oscuridad habla
--  despacio, cortando las frases (es literalmente un vacio de sombra).
-- ============================================================================

DELETE FROM `smart_scripts` WHERE `source_type` = 0 AND `entryorguid` IN (210153, 210797) AND `id` BETWEEN 10 AND 19;
DELETE FROM `creature_text` WHERE `CreatureID` IN (210153, 210797);

INSERT INTO `creature_text` (`CreatureID`, `GroupID`, `ID`, `Text`, `Type`, `Language`, `Probability`, `Emote`, `Duration`, `Sound`, `BroadcastTextId`, `TextRange`, `comment`) VALUES
-- Ol' Waxbeard: kobold de las velas, carga, derriba el techo y llama a los obreros
(210153, 0, 0, '¡Nadie toca mis velas!', 14, 0, 100, 0, 0, 0, 0, 0, 'Waxbeard: entra en combate'),
(210153, 1, 0, '¡Mi barba arde por vosotros!', 14, 0, 100, 0, 0, 0, 0, 0, 'Waxbeard: aviso de carga/derrumbe'),
(210153, 2, 0, '¡Aplastado como una vela!', 14, 0, 100, 0, 0, 0, 0, 0, 'Waxbeard: mata a un jugador'),
(210153, 3, 0, 'Mis... velas...', 14, 0, 100, 0, 0, 0, 0, 0, 'Waxbeard: muere'),
-- La Oscuridad: el jefe final, un vacio de sombra que habla cortado
(210797, 0, 0, 'No... hay... luz...', 14, 0, 100, 0, 0, 0, 0, 0, 'Oscuridad: entra en combate'),
(210797, 1, 0, 'La sombra... os... traga...', 14, 0, 100, 0, 0, 0, 0, 0, 'Oscuridad: aviso de explosion/esbirros'),
(210797, 2, 0, 'Uno menos... en la oscuridad...', 14, 0, 100, 0, 0, 0, 0, 0, 'Oscuridad: mata a un jugador'),
(210797, 3, 0, 'La luz... regresa...', 14, 0, 100, 0, 0, 0, 0, 0, 'Oscuridad: muere');

INSERT INTO `smart_scripts`
(`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`,
 `event_param1`, `event_param2`, `event_param3`, `event_param4`,
 `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`,
 `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(210153, 0, 10, 0, 4, 0, 100, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Waxbeard: grito al entrar en combate'),
(210153, 0, 11, 0, 2, 0, 100, 1, 0, 50, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Waxbeard: aviso al bajar del 50%'),
(210153, 0, 12, 0, 5, 0, 100, 0, 0, 0, 0, 0, 1, 2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Waxbeard: grito al matar'),
(210153, 0, 13, 0, 6, 0, 100, 0, 0, 0, 0, 0, 1, 3, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Waxbeard: grito al morir'),
(210797, 0, 10, 0, 4, 0, 100, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Oscuridad: grito al entrar en combate'),
(210797, 0, 11, 0, 2, 0, 100, 1, 0, 50, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Oscuridad: aviso al bajar del 50%'),
(210797, 0, 12, 0, 5, 0, 100, 0, 0, 0, 0, 0, 1, 2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Oscuridad: grito al matar'),
(210797, 0, 13, 0, 6, 0, 100, 0, 0, 0, 0, 0, 1, 3, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Oscuridad: grito al morir');
