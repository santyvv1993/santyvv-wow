-- ============================================================================
--  Encuentro: Priorato de la Llama Sagrada (mapa 2649) — tanda 4 (3 jefes)
-- ============================================================================
--  Medido antes: ninguno de los 3 tenia ScriptName, AIName ni filas de smart_scripts. Los tres estan
--  atacables (`unit_flags = 64`): aca NO aparece la bandera del `UNINTERACTIBLE`.
--
--  PENDIENTE 13 VERIFICADO Y CERRADO: la "Prioresa duplicada" ya no existe. La consulta de todos los
--  spawns del entry 207940 en la base devuelve **una sola fila** (guid 10001270, mapa 2649). El segundo
--  spawn (10001106) que estaba anotado ya no esta: no hay nada que limpiar.
--
--  DE DONDE SALEN LOS HECHIZOS (diario del cliente + Wowhead; procedimiento de la skill):
--    JournalInstance 1267 (mapa 2649) -> JournalEncounter 2571 (Capitan Dailcry), 2570 (Baron Braunpyke)
--    y 2573 (Prioresa Murrpray).
--    Dailcry    424414 Pierce Armor (corte al objetivo que lo hace sangrar 7 s) · 424419 Battle Cry
--               (golpe a toda la raid que ademas inspira a sus guardias) · 1238779 Earthshattering Spear
--               (lanza que parte el piso). No se implementan los hechizos de sus GUARDIAS (Taener,
--               Shaynemail, Elaena: son otras criaturas) ni los vinculos pasivos ("Bound by Fate" 448385,
--               "Strength in Numbers" 424628), que SmartAI no puede expresar.
--    Braunpyke  422969 Vindictive Wrath (se potencia: +100% dano fisico) · 423015 Castigator's Shield
--               (escudo que rebota en varios jugadores) · 423051 Burning Light (estallido a la raid +
--               dano cada 2 s por 12 s) · 423062 Hammer of Purity (martillo en el piso de un jugador).
--    Murrpray   423536 Holy Smite (castigo al objetivo) · 423539 Inner Fire (se potencia: +50% dano
--               sagrado y dana a todos) · 425544 The Sacred Flame (rayo canalizado de la Llama) ·
--               451606 Holy Flame (rayo al piso de un jugador) · 423588 Barrier of Light (al 50% de
--               vida se escuda: se implementa con el evento de PORCENTAJE DE VIDA y una sola vez).
-- ============================================================================

UPDATE `creature_template`
   SET `AIName` = 'SmartAI', `ScriptName` = ''
 WHERE `entry` IN (207946, 207939, 207940);

DELETE FROM `smart_scripts` WHERE `source_type` = 0 AND `entryorguid` IN (207946, 207939, 207940);

INSERT INTO `smart_scripts`
(`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`,
 `event_param1`, `event_param2`, `event_param3`, `event_param4`,
 `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`,
 `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES

-- ── Capitan Dailcry (207946) ─────────────────────────────────────────────────────────────────────
(207946, 0, 0, 0, 25, 0, 100, 0, 0, 0, 0, 0, 48, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Dailcry: al aparecer, activar la IA'),
(207946, 0, 1, 0, 0, 0, 100, 0, 5000, 8000, 12000, 16000, 11, 424414, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 'Dailcry: Pierce Armor al objetivo actual'),
(207946, 0, 2, 0, 0, 0, 100, 0, 12000, 15000, 22000, 26000, 11, 424419, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Dailcry: Battle Cry (raid)'),
(207946, 0, 3, 0, 0, 0, 100, 0, 20000, 25000, 30000, 36000, 11, 1238779, 0, 0, 0, 0, 0, 5, 0, 1, 0, 0, 0, 0, 0, 'Dailcry: Earthshattering Spear a un jugador al azar'),

-- ── Baron Braunpyke (207939) ─────────────────────────────────────────────────────────────────────
(207939, 0, 0, 0, 25, 0, 100, 0, 0, 0, 0, 0, 48, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Braunpyke: al aparecer, activar la IA'),
(207939, 0, 1, 0, 0, 0, 100, 0, 8000, 11000, 45000, 55000, 11, 422969, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Braunpyke: Vindictive Wrath (se potencia)'),
(207939, 0, 2, 0, 0, 0, 100, 0, 5000, 8000, 16000, 20000, 11, 423015, 0, 0, 0, 0, 0, 5, 0, 1, 0, 0, 0, 0, 0, 'Braunpyke: Castigator\'s Shield a un jugador al azar'),
(207939, 0, 3, 0, 0, 0, 100, 0, 14000, 17000, 28000, 34000, 11, 423051, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Braunpyke: Burning Light (raid + dano por 12 s)'),
(207939, 0, 4, 0, 0, 0, 100, 0, 11000, 14000, 22000, 26000, 11, 423062, 0, 0, 0, 0, 0, 5, 0, 1, 0, 0, 0, 0, 0, 'Braunpyke: Hammer of Purity a un jugador al azar'),

-- ── Prioresa Murrpray (207940) — jefe final ──────────────────────────────────────────────────────
(207940, 0, 0, 0, 25, 0, 100, 0, 0, 0, 0, 0, 48, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Murrpray: al aparecer, activar la IA'),
(207940, 0, 1, 0, 0, 0, 100, 0, 4000, 7000, 10000, 14000, 11, 423536, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 'Murrpray: Holy Smite al objetivo actual'),
(207940, 0, 2, 0, 0, 0, 100, 0, 12000, 15000, 30000, 36000, 11, 423539, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Murrpray: Inner Fire (se potencia y dana a todos)'),
(207940, 0, 3, 0, 0, 0, 100, 0, 20000, 24000, 35000, 42000, 11, 425544, 0, 0, 0, 0, 0, 5, 0, 1, 0, 0, 0, 0, 0, 'Murrpray: The Sacred Flame (rayo canalizado)'),
(207940, 0, 4, 0, 0, 0, 100, 0, 16000, 19000, 26000, 30000, 11, 451606, 0, 0, 0, 0, 0, 5, 0, 1, 0, 0, 0, 0, 0, 'Murrpray: Holy Flame a un jugador al azar'),
-- El escudo: al bajar del 50% de vida, una sola vez (evento de porcentaje de VIDA; el de mana es el que
-- lee POWER_MANA a la fuerza y por eso no se usa).
(207940, 0, 5, 0, 2, 0, 100, 1, 0, 50, 0, 0, 11, 423588, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Murrpray: Barrier of Light al 50% de vida');
