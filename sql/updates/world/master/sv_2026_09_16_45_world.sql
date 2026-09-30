-- ============================================================================
--  Encuentro: Anub'zekt (Ara-Kara 2660) — tanda 1 de guiones de jefe
-- ============================================================================
--  Estado medido antes: 215405 "Anub'zekt" no tenia ScriptName ni AIName y cero filas de smart_scripts
--  (la pelea era "el bicho te pega y muere"). Ahora usa SmartAI con las mecanicas del encuentro.
--
--  DE DONDE SALEN LOS HECHIZOS (nunca inventados; procedimiento de la skill wow-encuentro-smartai):
--    1. Diario del cliente: JournalInstance 1271 (mapa 2660) -> JournalEncounter 2584 "Anub'zekt"
--       -> JournalEncounterSection Type=2 (todos con DifficultyMask 63 = todas las dificultades).
--    2. Confirmados uno por uno en Wowhead (nether.wowhead.com/tooltip/spell/<id>):
--       433425  Impale          Cono de puas hacia su objetivo actual + empuje.
--       433677  Burrow Charge   Se entierra y atraviesa a un jugador al azar, empuja y emerge al final.
--       433740  Infestation     Le tira un enjambre a un jugador al azar (dano cada 0.5 s por 5 s);
--                               al caerse se convierte en el "Ceaseless Swarm".
--       433766  Eye of the Swarm  Al llegar a 100 de energia llena la arena de enjambre.
--    442210  Silken Restraints  ES DE LA CHUSMA (Bloodstained Webmage), no del jefe: no va.
--
--  Decisiones explicitas:
--    · "Eye of the Swarm" se dispara por TIEMPO (~60 s) y no por energia: el evento de energia de SmartAI
--      lee POWER_MANA a la fuerza (misma trampa que costo caro en Yazma), asi que no se usa.
--    · Sin RP/frases por ahora: la mecanica primero. El texto se agrega cuando se revise en vivo.
--    · Es idempotente por construccion (DELETE + INSERT del mismo entryorguid).
-- ============================================================================

UPDATE `creature_template`
   SET `AIName` = 'SmartAI', `ScriptName` = ''
 WHERE `entry` = 215405;

DELETE FROM `smart_scripts` WHERE `entryorguid` = 215405 AND `source_type` = 0;

INSERT INTO `smart_scripts`
(`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`,
 `event_param1`, `event_param2`, `event_param3`, `event_param4`,
 `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`,
 `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
-- Se activa al aparecer: sin esto los eventos de tick no corren hasta que alguien se acerca (regla 2 de la skill).
(215405, 0, 0, 0, 25, 0, 100, 0, 0, 0, 0, 0, 48, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Anubzekt: al aparecer, activar la IA'),
-- Impale: al objetivo actual (el tanque), cada 14-18 s.
(215405, 0, 1, 0, 0, 0, 100, 0, 5000, 8000, 14000, 18000, 11, 433425, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 'Anubzekt: Impale al objetivo actual'),
-- Burrow Charge: a un jugador al azar, cada 18-22 s.
(215405, 0, 2, 0, 0, 0, 100, 0, 12000, 15000, 18000, 22000, 11, 433677, 0, 0, 0, 0, 0, 5, 0, 1, 0, 0, 0, 0, 0, 'Anubzekt: Burrow Charge a un jugador al azar'),
-- Infestation: el enjambre que despues camina solo, cada 20-25 s.
(215405, 0, 3, 0, 0, 0, 100, 0, 9000, 11000, 20000, 25000, 11, 433740, 0, 0, 0, 0, 0, 5, 0, 1, 0, 0, 0, 0, 0, 'Anubzekt: Infestation a un jugador al azar'),
-- Eye of the Swarm: la fase de enjambre, cada ~60 s (ver decision arriba).
(215405, 0, 4, 0, 0, 0, 100, 0, 55000, 60000, 60000, 65000, 11, 433766, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Anubzekt: Eye of the Swarm cada ~60 s');
