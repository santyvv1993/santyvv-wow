-- ============================================================================
--  Encuentro: Estanques de Vida Rubí (mapa 2521) — tanda 6 (4 criaturas, 3 peleas)
-- ============================================================================
--  Medido antes: ninguna de las 4 tenia ScriptName, AIName ni filas de smart_scripts, y todas estan
--  atacables (`unit_flags = 64`). Se incluye a **Erkhart Sangre Tormentosa (199791)**: es la otra mitad de
--  la pelea final ("Kyrakka y Erkhart") y tambien quedo sin IA cuando se lo spawneo.
--
--  DE DONDE SALEN LOS HECHIZOS (diario del cliente + Wowhead):
--    JournalInstance 1202 (mapa 2521) -> encuentros 2488 (Melidrussa), 2485 (Kokia) y
--    2503 (Kyrakka y Erkhart).
--    Melidrussa  372808 Frigid Shard (esquirla al objetivo) · 372851 Chillstorm (tormenta en el piso de
--                un jugador, que tira hacia el ojo) · 396044 Hailburst (ola de escarcha + bombas) ·
--                373046 Awaken Whelps (invoca crias; el hechizo del cliente hace la invocacion).
--    Kokia       372107 Molten Boulder (roca fundida en el piso) · 372858 Searing Blows (4 golpes que
--                aplican heridas que se apilan) · 372863 Ritual of Blazebinding (invoca la Tormenta de
--                Fuego; por tiempo, porque el evento de energia es el que lee POWER_MANA).
--    Kyrakka     381525 Roaring Firebreath (aliento en cono) · 381862 Inferno Spit (escupitajo que deja
--                fuego) · 384773 Flaming Embers (brasas en el piso).
--    Erkhart     381512 Stormslam (golpe que sube el dano de naturaleza recibido) · 381516 Interrupting
--                Cloudburst (interrumpe a todos 2 s) · 381517 Winds of Change (huracan que empuja).
-- ============================================================================

UPDATE `creature_template`
   SET `AIName` = 'SmartAI', `ScriptName` = ''
 WHERE `entry` IN (188252, 189232, 199790, 199791);

DELETE FROM `smart_scripts` WHERE `source_type` = 0 AND `entryorguid` IN (188252, 189232, 199790, 199791);

INSERT INTO `smart_scripts`
(`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`,
 `event_param1`, `event_param2`, `event_param3`, `event_param4`,
 `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`,
 `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES

-- ── Melidrussa Tejescarcha (188252) ──────────────────────────────────────────────────────────────
(188252, 0, 0, 0, 25, 0, 100, 0, 0, 0, 0, 0, 48, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Melidrussa: al aparecer, activar la IA'),
(188252, 0, 1, 0, 0, 0, 100, 0, 5000, 8000, 12000, 16000, 11, 372808, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 'Melidrussa: Frigid Shard al objetivo actual'),
(188252, 0, 2, 0, 0, 0, 100, 0, 10000, 13000, 20000, 25000, 11, 372851, 0, 0, 0, 0, 0, 5, 0, 1, 0, 0, 0, 0, 0, 'Melidrussa: Chillstorm a un jugador al azar'),
(188252, 0, 3, 0, 0, 0, 100, 0, 16000, 20000, 28000, 34000, 11, 396044, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Melidrussa: Hailburst (ola + bombas)'),
(188252, 0, 4, 0, 0, 0, 100, 0, 22000, 26000, 45000, 55000, 11, 373046, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Melidrussa: Awaken Whelps (invoca crias)'),

-- ── Kokia Pezuña Ardiente (189232) ───────────────────────────────────────────────────────────────
(189232, 0, 0, 0, 25, 0, 100, 0, 0, 0, 0, 0, 48, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Kokia: al aparecer, activar la IA'),
(189232, 0, 1, 0, 0, 0, 100, 0, 6000, 9000, 14000, 18000, 11, 372107, 0, 0, 0, 0, 0, 5, 0, 1, 0, 0, 0, 0, 0, 'Kokia: Molten Boulder a un jugador al azar'),
(189232, 0, 2, 0, 0, 0, 100, 0, 9000, 12000, 16000, 20000, 11, 372858, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 'Kokia: Searing Blows al objetivo actual'),
(189232, 0, 3, 0, 0, 0, 100, 0, 20000, 24000, 40000, 48000, 11, 372863, 0, 0, 0, 0, 0, 5, 0, 1, 0, 0, 0, 0, 0, 'Kokia: Ritual of Blazebinding (tormenta de fuego)'),

-- ── Kyrakka (199790) — mitad de la pelea final ───────────────────────────────────────────────────
(199790, 0, 0, 0, 25, 0, 100, 0, 0, 0, 0, 0, 48, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Kyrakka: al aparecer, activar la IA'),
(199790, 0, 1, 0, 0, 0, 100, 0, 5000, 8000, 14000, 18000, 11, 381525, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 'Kyrakka: Roaring Firebreath (cono)'),
(199790, 0, 2, 0, 0, 0, 100, 0, 10000, 13000, 18000, 22000, 11, 381862, 0, 0, 0, 0, 0, 5, 0, 1, 0, 0, 0, 0, 0, 'Kyrakka: Inferno Spit a un jugador al azar'),
(199790, 0, 3, 0, 0, 0, 100, 0, 8000, 11000, 22000, 28000, 11, 384773, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Kyrakka: Flaming Embers (brasas en el piso)'),

-- ── Erkhart Sangre Tormentosa (199791) — la otra mitad ───────────────────────────────────────────
(199791, 0, 0, 0, 25, 0, 100, 0, 0, 0, 0, 0, 48, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Erkhart: al aparecer, activar la IA'),
(199791, 0, 1, 0, 0, 0, 100, 0, 6000, 9000, 15000, 19000, 11, 381512, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 'Erkhart: Stormslam al objetivo actual'),
(199791, 0, 2, 0, 0, 0, 100, 0, 14000, 17000, 26000, 32000, 11, 381516, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Erkhart: Interrupting Cloudburst (interrumpe a todos)'),
(199791, 0, 3, 0, 0, 0, 100, 0, 11000, 14000, 24000, 30000, 11, 381517, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Erkhart: Winds of Change (huracan que empuja)');
