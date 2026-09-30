-- ============================================================================
--  Encuentro: Ojo de Azshara (mapa 1456) — tanda 5 (4 jefes)
-- ============================================================================
--  Medido antes: ninguno de los 4 tenia ScriptName, AIName ni filas de smart_scripts, y los cuatro estan
--  atacables (`unit_flags = 64`). Se incluye a **Colera de Azshara (96028)**, el jefe final declarado de
--  la estancia: se spawnneo despues (con la migracion de jefes finales faltantes) y quedo sin IA, asi que
--  aparecia en el diario pero peleaba como un muñeco. Rey Barbahonda (193013) NO entra: ya trae IA del core.
--
--  DE DONDE SALEN LOS HECHIZOS (diario del cliente + Wowhead):
--    JournalInstance 716 (mapa 1456) -> encuentros 1480 (Parjesh), 1490 (Lady Odio Espiral),
--    1479 (Serpentrix) y 1492 (Colera de Azshara).
--    Parjesh    191977 Impaling Spear (lanza que desgarra y aturde 12 s) · 192131 Throw Spear (lanza a
--               un jugador al azar + sangrado 9 s) · 192135 Bellowing Roar (dano a todos) ·
--               192072 Call Reinforcements (invoca esbirros: lo hace el hechizo del cliente) ·
--               197064 Enrage (AL 30% DE VIDA: +30% de celeridad, una sola vez).
--    Hatecoil   193611 Focused Lightning (rayo a todos los jugadores) · 193597 Static Nova (electrifica
--               el agua) · 193682 Beckon Storm (invoca globulos) · 193698 Curse of the Witch.
--    Serpentrix 192050 Poison Spit (escupitajo a un jugador al azar) · 191855 Toxic Wound (herida que va
--               dejando charcos) · 191873 Submerge (AL 66% Y AL 33%: se sumerge y emerge invocando dos
--               crias; van dos filas, una por umbral, cada una de una sola vez).
--    Colera     192619 Massive Deluge (cono enorme que empuja) · 192675 Mystic Tornado (un tornado por
--               jugador) · 191797 Violent Winds (viento periodico de la cala).
-- ============================================================================

UPDATE `creature_template`
   SET `AIName` = 'SmartAI', `ScriptName` = ''
 WHERE `entry` IN (91784, 91789, 91808, 96028);

DELETE FROM `smart_scripts` WHERE `source_type` = 0 AND `entryorguid` IN (91784, 91789, 91808, 96028);

INSERT INTO `smart_scripts`
(`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`,
 `event_param1`, `event_param2`, `event_param3`, `event_param4`,
 `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`,
 `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES

-- ── Señor de la Guerra Parjesh (91784) ───────────────────────────────────────────────────────────
(91784, 0, 0, 0, 25, 0, 100, 0, 0, 0, 0, 0, 48, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Parjesh: al aparecer, activar la IA'),
(91784, 0, 1, 0, 0, 0, 100, 0, 6000, 9000, 15000, 19000, 11, 191977, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 'Parjesh: Impaling Spear al objetivo actual'),
(91784, 0, 2, 0, 0, 0, 100, 0, 10000, 13000, 18000, 22000, 11, 192131, 0, 0, 0, 0, 0, 5, 0, 1, 0, 0, 0, 0, 0, 'Parjesh: Throw Spear a un jugador al azar'),
(91784, 0, 3, 0, 0, 0, 100, 0, 14000, 17000, 26000, 32000, 11, 192135, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Parjesh: Bellowing Roar (todos)'),
(91784, 0, 4, 0, 0, 0, 100, 0, 20000, 24000, 45000, 55000, 11, 192072, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Parjesh: Call Reinforcements (invoca esbirros)'),
-- Enrage al 30% de vida, una sola vez (evento de porcentaje de VIDA: p1 minimo, p2 maximo).
(91784, 0, 5, 0, 2, 0, 100, 1, 0, 30, 0, 0, 11, 197064, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Parjesh: Enrage al 30% de vida'),

-- ── Lady Odio Espiral (91789) ────────────────────────────────────────────────────────────────────
(91789, 0, 0, 0, 25, 0, 100, 0, 0, 0, 0, 0, 48, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Hatecoil: al aparecer, activar la IA'),
(91789, 0, 1, 0, 0, 0, 100, 0, 5000, 8000, 14000, 18000, 11, 193611, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Hatecoil: Focused Lightning (a todos)'),
(91789, 0, 2, 0, 0, 0, 100, 0, 12000, 15000, 24000, 30000, 11, 193597, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Hatecoil: Static Nova (electrifica el agua)'),
(91789, 0, 3, 0, 0, 0, 100, 0, 18000, 22000, 35000, 42000, 11, 193682, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Hatecoil: Beckon Storm (invoca globulos)'),
(91789, 0, 4, 0, 0, 0, 100, 0, 9000, 12000, 20000, 26000, 11, 193698, 0, 0, 0, 0, 0, 5, 0, 1, 0, 0, 0, 0, 0, 'Hatecoil: Curse of the Witch a un jugador al azar'),

-- ── Serpentrix (91808) ───────────────────────────────────────────────────────────────────────────
(91808, 0, 0, 0, 25, 0, 100, 0, 0, 0, 0, 0, 48, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Serpentrix: al aparecer, activar la IA'),
(91808, 0, 1, 0, 0, 0, 100, 0, 4000, 7000, 10000, 14000, 11, 192050, 0, 0, 0, 0, 0, 5, 0, 1, 0, 0, 0, 0, 0, 'Serpentrix: Poison Spit a un jugador al azar'),
(91808, 0, 2, 0, 0, 0, 100, 0, 12000, 15000, 22000, 28000, 11, 191855, 0, 0, 0, 0, 0, 5, 0, 1, 0, 0, 0, 0, 0, 'Serpentrix: Toxic Wound a un jugador al azar'),
-- Las dos inmersiones del diario: al 66% y al 33% de vida, cada una UNA vez (dos filas independientes).
(91808, 0, 3, 0, 2, 0, 100, 1, 55, 66, 0, 0, 11, 191873, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Serpentrix: Submerge al 66% de vida'),
(91808, 0, 4, 0, 2, 0, 100, 1, 0, 33, 0, 0, 11, 191873, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Serpentrix: Submerge al 33% de vida'),

-- ── Colera de Azshara (96028) — jefe final ───────────────────────────────────────────────────────
(96028, 0, 0, 0, 25, 0, 100, 0, 0, 0, 0, 0, 48, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Colera: al aparecer, activar la IA'),
(96028, 0, 1, 0, 0, 0, 100, 0, 6000, 9000, 20000, 25000, 11, 192619, 0, 0, 0, 0, 0, 5, 0, 1, 0, 0, 0, 0, 0, 'Colera: Massive Deluge a un jugador al azar'),
(96028, 0, 2, 0, 0, 0, 100, 0, 12000, 15000, 24000, 30000, 11, 192675, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Colera: Mystic Tornado (tornados por jugador)'),
(96028, 0, 3, 0, 0, 0, 100, 0, 4000, 6000, 30000, 36000, 11, 191797, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Colera: Violent Winds (viento de la cala)');
