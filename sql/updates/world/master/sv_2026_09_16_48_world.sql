-- ============================================================================
--  Encuentro: Reposo de los Reyes (mapa 1762) — tanda 2 (5 jefes)
-- ============================================================================
--  NUMERACION: esta migracion iba a ser la 47, pero el otro hilo de trabajo del repo la creo primero.
--  Se corre a la 48 para no pisarla (mismo dia, mismo directorio).
--
--  Medido antes: ninguno de los 5 tenia ScriptName, AIName ni filas de smart_scripts.
--
--  HALLAZGO ADICIONAL (medido): **Zanazal el Sabio (135472) y Kula la Carnicera (135475) tienen
--  `unit_flags` = 33554496 (0x2000040 = `UNIT_FLAG_UNINTERACTIBLE`)**: no se los puede atacar. Son dos de
--  los tres jefes del **Consejo de las tribus**, asi que la pelea estaba rota de raiz (a Zanazal y Kula
--  no se les podia pegar). Es exactamente la bandera que ya se limpio en los jefes finales (migracion 23)
--  y que a estos se les paso. Se limpia igual: 64 = 0x40.
--
--  DE DONDE SALEN LOS HECHIZOS (diario del cliente + Wowhead; procedimiento de la skill):
--    JournalInstance 1041 (mapa 1762) -> JournalEncounter 2171 (Mchimba), 2170 (Consejo: Aka'ali,
--    Zanazal y Kula en UNA pelea) y 2172 (Dazar, el primer rey = Rey Dazar).
--    Mchimba   267618 Drain Fluids (drena a un jugador al azar) · 267639 Burn Corruption (llamas a un
--              jugador + charco) · 267763 Wretched Discharge (enfermedad a toda la raid, 12 s)
--              1312146 Awakening Slam (golpe de area a toda la raid).
--    Aka'ali   266951 Barrel Through (carga a un jugador, dano repartido).
--    Zanazal   1305810 Arc Lightning (rayo que salta entre jugadores) · 267273 Poison Nova (area a la
--              raid) · 267257 Disruption (interrumpe a todos 4 s) · 267060 Call of the Elements.
--    Kula      266206 Whirling Axes (remolino a 10 yardas + empuje) · 266231 Severing Axe (hacha a un
--              jugador) · 266237 Debilitating Backhand (al objetivo actual + defensas rotas).
--    Rey Dazar 1303115 Aerial Smash (salto a un jugador) · 1303267 Gilded Destruction (area a la raid)
--              · 268586 Blade Combo (golpes crecientes al objetivo) · 1303372 Searing Gold (ola frontal).
--
--  NO se implementa en esta tanda (y se dice por que):
--    · "Entomb"/"Open Coffin" de Mchimba y "Lucre's Call" de la serpiente dorada dependen de los
--      SARCOFAGOS del escenario (gameobjects con hechizo propio): van en una tanda aparte, con el
--      mapeo de cada sarcofago medido.
--    · La serpiente dorada (135322) ya trae IA del core: no se toca.
--    · T'zala y Rezan (los otros dos actores del encuentro final) no estan spawneados: se revisa aparte.
-- ============================================================================

-- 1) Los dos jefes inatacables del Consejo: fuera `UNINTERACTIBLE` (y de paso los otros flags que bloquean).
UPDATE `creature_template`
   SET `unit_flags` = 64
 WHERE `entry` IN (135472, 135475)
   AND (`unit_flags` & 0x2000000) <> 0;

-- 2) La IA de cada uno.
UPDATE `creature_template`
   SET `AIName` = 'SmartAI', `ScriptName` = ''
 WHERE `entry` IN (134993, 135470, 135472, 135475, 136160);

DELETE FROM `smart_scripts` WHERE `source_type` = 0 AND `entryorguid` IN (134993, 135470, 135472, 135475, 136160);

INSERT INTO `smart_scripts`
(`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`,
 `event_param1`, `event_param2`, `event_param3`, `event_param4`,
 `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`,
 `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES

-- ── Mchimba el Embalsamador (134993) ──────────────────────────────────────────────────────────────
(134993, 0, 0, 0, 25, 0, 100, 0, 0, 0, 0, 0, 48, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Mchimba: al aparecer, activar la IA'),
(134993, 0, 1, 0, 0, 0, 100, 0, 5000, 8000, 18000, 22000, 11, 267618, 0, 0, 0, 0, 0, 5, 0, 1, 0, 0, 0, 0, 0, 'Mchimba: Drain Fluids a un jugador al azar'),
(134993, 0, 2, 0, 0, 0, 100, 0, 9000, 12000, 20000, 25000, 11, 267639, 0, 0, 0, 0, 0, 5, 0, 1, 0, 0, 0, 0, 0, 'Mchimba: Burn Corruption a un jugador al azar'),
(134993, 0, 3, 0, 0, 0, 100, 0, 15000, 18000, 30000, 35000, 11, 267763, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Mchimba: Wretched Discharge (raid)'),
(134993, 0, 4, 0, 0, 0, 100, 0, 25000, 30000, 40000, 45000, 11, 1312146, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Mchimba: Awakening Slam (raid)'),

-- ── Aka'ali la Conquistadora (135470) ────────────────────────────────────────────────────────────
(135470, 0, 0, 0, 25, 0, 100, 0, 0, 0, 0, 0, 48, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Akaali: al aparecer, activar la IA'),
(135470, 0, 1, 0, 0, 0, 100, 0, 10000, 12000, 22000, 26000, 11, 266951, 0, 0, 0, 0, 0, 5, 0, 1, 0, 0, 0, 0, 0, 'Akaali: Barrel Through a un jugador al azar'),

-- ── Zanazal el Sabio (135472) ────────────────────────────────────────────────────────────────────
(135472, 0, 0, 0, 25, 0, 100, 0, 0, 0, 0, 0, 48, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Zanazal: al aparecer, activar la IA'),
(135472, 0, 1, 0, 0, 0, 100, 0, 4000, 7000, 12000, 16000, 11, 1305810, 0, 0, 0, 0, 0, 5, 0, 1, 0, 0, 0, 0, 0, 'Zanazal: Arc Lightning a un jugador al azar'),
(135472, 0, 2, 0, 0, 0, 100, 0, 12000, 15000, 25000, 30000, 11, 267273, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Zanazal: Poison Nova (raid)'),
(135472, 0, 3, 0, 0, 0, 100, 0, 18000, 22000, 30000, 35000, 11, 267257, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Zanazal: Disruption (interrumpe a todos)'),
(135472, 0, 4, 0, 0, 0, 100, 0, 8000, 10000, 45000, 55000, 11, 267060, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Zanazal: Call of the Elements (totems)'),

-- ── Kula la Carnicera (135475) ───────────────────────────────────────────────────────────────────
(135475, 0, 0, 0, 25, 0, 100, 0, 0, 0, 0, 0, 48, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Kula: al aparecer, activar la IA'),
(135475, 0, 1, 0, 0, 0, 100, 0, 6000, 9000, 15000, 19000, 11, 266231, 0, 0, 0, 0, 0, 5, 0, 1, 0, 0, 0, 0, 0, 'Kula: Severing Axe a un jugador al azar'),
(135475, 0, 2, 0, 0, 0, 100, 0, 11000, 14000, 20000, 25000, 11, 266206, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Kula: Whirling Axes (remolino)'),
(135475, 0, 3, 0, 0, 0, 100, 0, 16000, 20000, 26000, 32000, 11, 266237, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 'Kula: Debilitating Backhand al objetivo actual'),

-- ── Rey Dazar (136160) ───────────────────────────────────────────────────────────────────────────
(136160, 0, 0, 0, 25, 0, 100, 0, 0, 0, 0, 0, 48, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Rey Dazar: al aparecer, activar la IA'),
(136160, 0, 1, 0, 0, 0, 100, 0, 5000, 8000, 12000, 16000, 11, 268586, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 'Rey Dazar: Blade Combo al objetivo actual'),
(136160, 0, 2, 0, 0, 0, 100, 0, 10000, 13000, 20000, 25000, 11, 1303115, 0, 0, 0, 0, 0, 5, 0, 1, 0, 0, 0, 0, 0, 'Rey Dazar: Aerial Smash a un jugador al azar'),
(136160, 0, 3, 0, 0, 0, 100, 0, 20000, 24000, 32000, 40000, 11, 1303267, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Rey Dazar: Gilded Destruction (raid)'),
(136160, 0, 4, 0, 0, 0, 100, 0, 15000, 18000, 28000, 34000, 11, 1303372, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Rey Dazar: Searing Gold (ola frontal)');
