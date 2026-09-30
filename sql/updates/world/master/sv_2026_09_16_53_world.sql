-- ============================================================================
--  Encuentro: Grieta Llama Oscura (mapa 2651) — tanda 7 (3 de 4 jefes)
-- ============================================================================
--  Esta estancia es distinta a las anteriores: los jefes NO tenian spawn. Medido ahora:
--    · Ol' Waxbeard (210153)  -> SI esta spawneado (601.8, 30.6, 87.1). Solo le faltaba IA.
--    · The Darkness (210797)  -> SI esta spawneado (393.3, -420.5, 72.0). Solo le faltaba IA.
--      (208747, el otro actor del mismo encuentro, se dejo sin spawnear a proposito y el cierre de la
--       corrida no lo necesita: el `jefe_final` de la estancia se satisface con el 210797.)
--    · The Candle King (208745) -> ya tenia IA del core: no se toca.
--    · **Blazikon (208743) -> NO tiene spawn y su posicion NO esta en ninguna fuente que tengamos.**
--      Se probo la via Wowhead (`nether.wowhead.com/tooltip/npc/208743`): el campo `map.coords` viene
--      VACIO para los NPC de mazmorra de TWW, asi que no hay con que calibrar (con los otros tres jefes
--      tampoco: los tres devolvieron vacio). **No se inventa la posicion**: un jefe dentro de una pared
--      es peor que un jefe ausente. Queda pendiente de 10 segundos en vivo:
--          entrar a Grieta Llama Oscura, pararse donde va Blazikon y escribir  .npc add 208743
--      (eso crea el spawn permanente en la base, en la posicion real donde estas parado).
--
--  DE DONDE SALEN LOS HECHIZOS (diario del cliente + Wowhead):
--    JournalInstance 1210 (mapa 2651) -> encuentros 2569 (Ol' Waxbeard), 2559 (Blazikon) y
--    2561 (The Darkness).
--    Waxbeard   422245 Rock Buster (rompe armadura al objetivo: +25% dano fisico recibido) ·
--               422150 Reckless Charge (carga al jugador mas lejano, empuja) ·
--               422162 Luring Candleflame (vela a un jugador: los obreros lo fijan) ·
--               422270 Cave-In (piedras sobre cada jugador).
--    Blazikon   421638 Wicklighter Barrage (torrente de fuego en el piso) · 425394 Dousing Breath
--               (viento que apaga las velas) · 423099 Enkindling Inferno (las vuelve a encender y
--               castiga a los que estan en la linea) · 424223 Incite Flames (las velas encendidas
--               escupen brasas).
--    Darkness   427011 Shadowblast (explosion a los 6 s en un jugador) · 427100 Umbral Slash (garra en
--               linea hacia la luz de la vela) · 427157 Call Darkspawn (invoca esbirros) ·
--               428266 Eternal Darkness (oleadas de sombra).
-- ============================================================================

UPDATE `creature_template`
   SET `AIName` = 'SmartAI', `ScriptName` = ''
 WHERE `entry` IN (210153, 208743, 210797);

DELETE FROM `smart_scripts` WHERE `source_type` = 0 AND `entryorguid` IN (210153, 208743, 210797);

INSERT INTO `smart_scripts`
(`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`,
 `event_param1`, `event_param2`, `event_param3`, `event_param4`,
 `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`,
 `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES

-- ── Ol' Waxbeard (210153) ────────────────────────────────────────────────────────────────────────
(210153, 0, 0, 0, 25, 0, 100, 0, 0, 0, 0, 0, 48, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Waxbeard: al aparecer, activar la IA'),
(210153, 0, 1, 0, 0, 0, 100, 0, 5000, 8000, 12000, 16000, 11, 422245, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 'Waxbeard: Rock Buster al objetivo actual'),
(210153, 0, 2, 0, 0, 0, 100, 0, 15000, 18000, 26000, 32000, 11, 422150, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Waxbeard: Reckless Charge (carga al mas lejano)'),
(210153, 0, 3, 0, 0, 0, 100, 0, 10000, 13000, 20000, 25000, 11, 422162, 0, 0, 0, 0, 0, 5, 0, 1, 0, 0, 0, 0, 0, 'Waxbeard: Luring Candleflame a un jugador al azar'),
(210153, 0, 4, 0, 0, 0, 100, 0, 18000, 22000, 30000, 36000, 11, 422270, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Waxbeard: Cave-In (piedras)'),

-- ── Blazikon (208743) — SIN SPAWN: el guion queda listo para cuando se agregue ───────────────────
(208743, 0, 0, 0, 25, 0, 100, 0, 0, 0, 0, 0, 48, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Blazikon: al aparecer, activar la IA'),
(208743, 0, 1, 0, 0, 0, 100, 0, 5000, 8000, 14000, 18000, 11, 421638, 0, 0, 0, 0, 0, 5, 0, 1, 0, 0, 0, 0, 0, 'Blazikon: Wicklighter Barrage a un jugador al azar'),
(208743, 0, 2, 0, 0, 0, 100, 0, 12000, 15000, 24000, 30000, 11, 425394, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Blazikon: Dousing Breath (apaga las velas)'),
(208743, 0, 3, 0, 0, 0, 100, 0, 18000, 22000, 32000, 38000, 11, 423099, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Blazikon: Enkindling Inferno (las reenciende)'),
(208743, 0, 4, 0, 0, 0, 100, 0, 9000, 12000, 20000, 26000, 11, 424223, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Blazikon: Incite Flames (brasas de las velas)'),

-- ── The Darkness (210797) — jefe final ───────────────────────────────────────────────────────────
(210797, 0, 0, 0, 25, 0, 100, 0, 0, 0, 0, 0, 48, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Darkness: al aparecer, activar la IA'),
(210797, 0, 1, 0, 0, 0, 100, 0, 6000, 9000, 18000, 22000, 11, 427011, 0, 0, 0, 0, 0, 5, 0, 1, 0, 0, 0, 0, 0, 'Darkness: Shadowblast a un jugador al azar'),
(210797, 0, 2, 0, 0, 0, 100, 0, 12000, 15000, 22000, 28000, 11, 427100, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Darkness: Umbral Slash (linea hacia la luz)'),
(210797, 0, 3, 0, 0, 0, 100, 0, 20000, 24000, 40000, 48000, 11, 427157, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Darkness: Call Darkspawn (invoca esbirros)'),
(210797, 0, 4, 0, 0, 0, 100, 0, 30000, 35000, 50000, 60000, 11, 428266, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Darkness: Eternal Darkness (oleadas)');
