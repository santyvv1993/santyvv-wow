-- ============================================================================
--  Encuentro: Ki'katal la Cosechadora (Ara-Kara 2660) — jefe final, tanda 1
-- ============================================================================
--  Medido antes: 215407 sin ScriptName, sin AIName y cero filas de smart_scripts.
--
--  DE DONDE SALEN LOS HECHIZOS (procedimiento de la skill wow-encuentro-smartai):
--    Diario del cliente: JournalInstance 1271 (mapa 2660) -> JournalEncounter 2585.
--    Confirmados en Wowhead (nether.wowhead.com/tooltip/spell/<id>):
--      432227  Venom Volley         Bala de veneno a TODA la raid: -30% velocidad, dano inmediato
--                                   y dano cada 2 s. Puede repetirse cada 10 s.
--      432130  Erupting Webs        Erupciones de telarana que pegan y aturden 3 s.
--      432117  Cosmic Singularity   Canaliza 7 s y arrastra a todos los jugadores; al terminar, los
--                                   que quedan a menos de 10 yardas reciben dano enorme y salen volando.
--      461487  Cultivated Poisons   Inyecta un veneno en 3 jugadores (dano cada 1 s por 8 s); al caerse
--                                   erupciona en oleadas.
--      432031  Grasping Blood       Es de los CHARCOS de Sangre Negra del piso (el jugador que los pisa
--                                   queda enraizado), no del jefe: no se implementa sin los charcos.
--      432119  Faded                Es la consecuencia de la Singularidad: la aplica el propio hechizo.
--
--  Decisiones explicitas:
--    · Los hechizos de area de la raid (Venom Volley, Cosmic Singularity) se castean sobre el PROPIO jefe:
--      el alcance real lo pone el hechizo del cliente, que es quien manda (misma logica que con los
--      efectos de invocacion de Anub'zekt).
--    · "Cultivated Poisons" dice 3 jugadores: se castea una vez a un jugador al azar y el hechizo del
--      cliente reparte las tres aplicaciones.
--    · Sin RP por ahora (mecanica primero, igual que Anub'zekt).
-- ============================================================================

UPDATE `creature_template`
   SET `AIName` = 'SmartAI', `ScriptName` = ''
 WHERE `entry` = 215407;

DELETE FROM `smart_scripts` WHERE `entryorguid` = 215407 AND `source_type` = 0;

INSERT INTO `smart_scripts`
(`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`,
 `event_param1`, `event_param2`, `event_param3`, `event_param4`,
 `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`,
 `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
-- Al aparecer, activar la IA (sin esto los eventos de tick no corren hasta que alguien se acerca).
(215407, 0, 0, 0, 25, 0, 100, 0, 0, 0, 0, 0, 48, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Kikatal: al aparecer, activar la IA'),
-- Venom Volley: la bala de veneno a la raid, cada 20-25 s (el hechizo trae su propio alcance).
(215407, 0, 1, 0, 0, 0, 100, 0, 6000, 9000, 20000, 25000, 11, 432227, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Kikatal: Venom Volley (raid)'),
-- Erupting Webs: telaranas al azar, cada 16-20 s.
(215407, 0, 2, 0, 0, 0, 100, 0, 8000, 11000, 16000, 20000, 11, 432130, 0, 0, 0, 0, 0, 5, 0, 1, 0, 0, 0, 0, 0, 'Kikatal: Erupting Webs a un jugador al azar'),
-- Cultivated Poisons: el veneno de 3 jugadores (el hechizo del cliente reparte las tres aplicaciones).
(215407, 0, 3, 0, 0, 0, 100, 0, 12000, 15000, 25000, 30000, 11, 461487, 0, 0, 0, 0, 0, 5, 0, 1, 0, 0, 0, 0, 0, 'Kikatal: Cultivated Poisons a un jugador al azar'),
-- Cosmic Singularity: el arrastre a todos con la explosion de los 10 yardas, cada ~50 s.
(215407, 0, 4, 0, 0, 0, 100, 0, 30000, 35000, 45000, 55000, 11, 432117, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Kikatal: Cosmic Singularity (arrastra a la raid)');
