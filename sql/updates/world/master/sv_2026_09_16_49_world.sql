-- ============================================================================
--  Encuentro: Ciudad de los Hilos (mapa 2669) — tanda 3 (4 jefes)
-- ============================================================================
--  Medido antes: ninguno de los 4 tenia ScriptName, AIName ni filas de smart_scripts.
--
--  HALLAZGO (el mismo de la tanda anterior, otra vez): **Vx (216649) tiene `unit_flags` = 33554752**
--  (0x2000040 | 0x100 = `UNINTERACTIBLE` + `IMMUNE_TO_PC`): **no se la puede atacar**. Nx y Vx son
--  "Colmillos de la reina", **una pelea de dos**: con Vx inatacable se pelea a medias. Se limpia a 64.
--  Orador Krix'vizk (216619) NO entra: ya trae IA del core.
--
--  DE DONDE SALEN LOS HECHIZOS (diario del cliente + Wowhead; procedimiento de la skill):
--    JournalInstance 1274 (mapa 2669) -> JournalEncounter 2595 (Colmillos de la reina = Nx/Vx),
--    2600 (La Coaglamacion) y 2596 (Izo, la Gran Fusionadora).
--    Nx   439621 Shade Slash (cono al objetivo + sombra que lo repite) · 439692 Duskbringer (dano a
--         toda la raid y explosion a los que quedan cerca) · 439522 Synergic Step (al llegar a 100 de
--         energia cruzan la arena a los golpes; aca va por tiempo, por la trampa del evento de energia).
--    Vx   440468 Rime Dagger (puñalada helada al objetivo: el que apila "Freezing Blood") ·
--         440218 Ice Sickles (dagas heladas en linea a varios jugadores) · 440107 Knife Throw (cuchillo
--         a un jugador al azar).
--    Coaglamacion  461842 Oozing Smash (golpe al objetivo + 30% menos curacion) · 438620 Blood Surge
--         (rugido de area + charco de sangre negra) · 437533 Dark Pulse (al llegar a 100 de energia:
--         dano a toda la raid; va por tiempo).
--    Izo  439341 Splice (hebras experimentales a todos) · 439401 Shifting Anomalies (esferas que pegan
--         y empujan) · 438860 Umbral Weave (telaranas sombrias a todos) · 437700 Tremor Slam (se
--         transforma en Lord nerubiano y golpea el piso) · 439646 Process of Elimination (las esferas
--         contra un jugador).
--
--  NO se implementa: "Twin Fangs" (439518, Nx y Vx comparten el 100% del dano) es un vinculo pasivo
--  entre dos criaturas y SmartAI no tiene esa accion; los hechizos del Escarabajo de Izo (450042/
--  450047/450055) son de una invocacion, no del jefe.
-- ============================================================================

-- 1) Vx deja de ser inatacable (es la mitad de una pelea de dos).
UPDATE `creature_template`
   SET `unit_flags` = 64
 WHERE `entry` = 216649
   AND (`unit_flags` & 0x2000000) <> 0;

-- 2) La IA de los cuatro.
UPDATE `creature_template`
   SET `AIName` = 'SmartAI', `ScriptName` = ''
 WHERE `entry` IN (216648, 216649, 216320, 216658);

DELETE FROM `smart_scripts` WHERE `source_type` = 0 AND `entryorguid` IN (216648, 216649, 216320, 216658);

INSERT INTO `smart_scripts`
(`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`,
 `event_param1`, `event_param2`, `event_param3`, `event_param4`,
 `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`,
 `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES

-- ── Nx (216648) ──────────────────────────────────────────────────────────────────────────────────
(216648, 0, 0, 0, 25, 0, 100, 0, 0, 0, 0, 0, 48, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Nx: al aparecer, activar la IA'),
(216648, 0, 1, 0, 0, 0, 100, 0, 5000, 8000, 14000, 18000, 11, 439621, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 'Nx: Shade Slash al objetivo actual'),
(216648, 0, 2, 0, 0, 0, 100, 0, 15000, 18000, 30000, 36000, 11, 439692, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Nx: Duskbringer (raid)'),
(216648, 0, 3, 0, 0, 0, 100, 0, 25000, 30000, 35000, 45000, 11, 439522, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Nx: Synergic Step (cruzan la arena)'),

-- ── Vx (216649) ──────────────────────────────────────────────────────────────────────────────────
(216649, 0, 0, 0, 25, 0, 100, 0, 0, 0, 0, 0, 48, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Vx: al aparecer, activar la IA'),
(216649, 0, 1, 0, 0, 0, 100, 0, 6000, 9000, 16000, 20000, 11, 440468, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 'Vx: Rime Dagger al objetivo actual (apila Freezing Blood)'),
(216649, 0, 2, 0, 0, 0, 100, 0, 12000, 15000, 24000, 28000, 11, 440218, 0, 0, 0, 0, 0, 5, 0, 1, 0, 0, 0, 0, 0, 'Vx: Ice Sickles a un jugador al azar'),
(216649, 0, 3, 0, 0, 0, 100, 0, 9000, 12000, 18000, 22000, 11, 440107, 0, 0, 0, 0, 0, 5, 0, 1, 0, 0, 0, 0, 0, 'Vx: Knife Throw a un jugador al azar'),

-- ── La Coaglamacion (216320) ─────────────────────────────────────────────────────────────────────
(216320, 0, 0, 0, 25, 0, 100, 0, 0, 0, 0, 0, 48, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Coaglamacion: al aparecer, activar la IA'),
(216320, 0, 1, 0, 0, 0, 100, 0, 6000, 9000, 15000, 19000, 11, 461842, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 'Coaglamacion: Oozing Smash al objetivo actual'),
(216320, 0, 2, 0, 0, 0, 100, 0, 14000, 17000, 26000, 32000, 11, 438620, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Coaglamacion: Blood Surge (area + charco)'),
(216320, 0, 3, 0, 0, 0, 100, 0, 30000, 35000, 40000, 48000, 11, 437533, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Coaglamacion: Dark Pulse (raid)'),

-- ── Izo, la Gran Fusionadora (216658) — jefe final ───────────────────────────────────────────────
(216658, 0, 0, 0, 25, 0, 100, 0, 0, 0, 0, 0, 48, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Izo: al aparecer, activar la IA'),
(216658, 0, 1, 0, 0, 0, 100, 0, 5000, 8000, 20000, 25000, 11, 439341, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Izo: Splice (hebras a todos)'),
(216658, 0, 2, 0, 0, 0, 100, 0, 12000, 15000, 26000, 32000, 11, 439401, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Izo: Shifting Anomalies (esferas)'),
(216658, 0, 3, 0, 0, 0, 100, 0, 20000, 24000, 34000, 40000, 11, 438860, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Izo: Umbral Weave (telaranas sombrias)'),
(216658, 0, 4, 0, 0, 0, 100, 0, 28000, 32000, 45000, 55000, 11, 437700, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Izo: Tremor Slam (forma de Lord nerubiano)'),
(216658, 0, 5, 0, 0, 0, 100, 0, 35000, 40000, 50000, 60000, 11, 439646, 0, 0, 0, 0, 0, 5, 0, 1, 0, 0, 0, 0, 0, 'Izo: Process of Elimination a un jugador al azar');
