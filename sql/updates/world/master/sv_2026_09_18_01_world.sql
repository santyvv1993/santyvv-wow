-- Arranque de raza/clase: Dracthyr/evocador: el War Creche (misiones 64864, 64863, 64865, 64866)
-- Generado por herramientas/arranque-propuesta.py desde plan-dracthyr-creche.json
-- Mapa 2570 · zona 13769 · 14 spawns · 7 relaciones
--
-- Idempotente: DELETE de la clave exacta antes de cada INSERT.

-- AVISOS:
--   * 182702: el piso elegido (238.28) queda a 102.2 yd del vecino (136.075)

-- --- spawns ---
DELETE FROM `creature` WHERE `guid` IN (9100000,9100001,9100002,9100003,9100004,9100005,9100006,9100007,9100008,9100009,9100010,9100011,9100012,9100013);
INSERT INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`wander_distance`,`currentwaypoint`,`curHealthPct`,`MovementType`,`npcflag`,`unit_flags`,`unit_flags2`,`unit_flags3`,`ScriptName`,`StringId`,`VerifiedBuild`) VALUES
( 9100000,181056,2570,0,0,'0',0,0,0,-1,0,0,5813.0000,-2912.0000,207.3800,0.0000,120,0.00,0,NULL,0,NULL,NULL,NULL,NULL,'',NULL,0 ), -- 181056 Scalecommander Azurathel · Scalecommander Azurathel (despierto) - cierra 64864 y da 64865. POI entrega de 64864 (5813/-2912) [z: navmesh 207.38 (vecino a 11.8 yd en 207.5) [pisos: 207.38/442.52]]
( 9100001,182069,2570,0,0,'0',0,0,0,-1,0,0,5815.0000,-2916.0000,206.0000,0.0000,120,0.00,0,NULL,0,NULL,NULL,NULL,NULL,'',NULL,0 ), -- 182069 Dervishian · Dervishian (despierto) - da y cierra 64863 'Arcane Guardians'. POI dador de 64863 con Z real (206) [z: plan]
( 9100002,181680,2570,0,0,'0',0,0,0,-1,0,0,5779.0000,-3039.0000,210.0000,0.0000,120,0.00,0,NULL,0,NULL,NULL,NULL,NULL,'',NULL,0 ), -- 181680 Tethalash · Tethalash - objetivo de 64864 ('Tethalash awakened'). POI con Z real (210) [z: plan]
( 9100003,183380,2570,0,0,'0',0,0,0,-1,0,0,5803.0000,-2907.0000,207.3600,0.0000,120,0.00,0,NULL,0,NULL,NULL,NULL,NULL,'',NULL,0 ), -- 183380 Scalecommander Azurathel · Scalecommander Azurathel congelado - objetivo de 64864 ('Azurathel awakened'). POI 5803/-2907 [z: navmesh 207.36 (vecino a 10.5 yd en 207.4) [pisos: 207.36]]
( 9100004,181712,2570,0,0,'0',0,0,0,-1,0,0,5811.0000,-3075.0000,211.8200,0.0000,120,0.00,0,NULL,0,NULL,NULL,NULL,NULL,'',NULL,0 ), -- 181712 Talon Kethahn · Talon Kethahn - objetivo 'Kethahn found' (hablar). POI 5811/-3075. Necesita el SmartAI de abajo [z: navmesh 211.82 (vecino a 9.2 yd en 213.3) [pisos: 211.82/293.21]]
( 9100005,181594,2570,0,0,'0',0,0,0,-1,0,0,5986.0000,-3061.0000,201.0000,0.0000,120,0.00,0,NULL,0,NULL,NULL,NULL,NULL,'',NULL,0 ), -- 181594 Scalecommander Azurathel · Scalecommander Azurathel - cierra 64865 y da 64866. POI con Z real (201) [z: plan]
( 9100006,182168,2570,0,0,'0',0,0,0,-1,0,0,6137.0000,-3230.0000,133.0000,0.0000,120,0.00,0,NULL,0,NULL,NULL,NULL,NULL,'',NULL,0 ), -- 182168 Scalecommander Azurathel · Scalecommander Azurathel - cierra 64866 en el Caldero. POI entrega de 64866 con Z real (133) [z: plan]
( 9100007,182702,2570,0,0,'0',0,0,0,-1,0,0,5943.0000,-3172.0000,126.3100,0.0000,120,0.00,0,NULL,0,NULL,NULL,NULL,NULL,'',NULL,0 ), -- 182702 Dracthyr Talon · Dracthyr Talon 1/8 - objetivo de 64866 (curar 5). POI del objetivo [z: navmesh 126.31 (vecino a 41.7 yd en 124.1) [pisos: 12.16/87.35/126.31]]
( 9100008,182702,2570,0,0,'0',0,0,0,-1,0,0,5953.0000,-3137.0000,123.9600,0.0000,120,0.00,0,NULL,0,NULL,NULL,NULL,NULL,'',NULL,0 ), -- 182702 Dracthyr Talon · Dracthyr Talon 2/8 [z: navmesh 123.96 (vecino a 9.4 yd en 124.1) [pisos: 12.16/123.96/126.63]]
( 9100009,182702,2570,0,0,'0',0,0,0,-1,0,0,5969.0000,-3114.0000,125.2000,0.0000,120,0.00,0,NULL,0,NULL,NULL,NULL,NULL,'',NULL,0 ), -- 182702 Dracthyr Talon · Dracthyr Talon 3/8 [z: navmesh 125.2 (vecino a 22.0 yd en 124.1) [pisos: 125.2/178.04]]
( 9100010,182702,2570,0,0,'0',0,0,0,-1,0,0,6022.0000,-3055.0000,129.3300,0.0000,120,0.00,0,NULL,0,NULL,NULL,NULL,NULL,'',NULL,0 ), -- 182702 Dracthyr Talon · Dracthyr Talon 4/8 [z: navmesh 129.33 (vecino a 8.3 yd en 128.8) [pisos: 129.33]]
( 9100011,182702,2570,0,0,'0',0,0,0,-1,0,0,6063.0000,-3030.0000,218.6700,0.0000,120,0.00,0,NULL,0,NULL,NULL,NULL,NULL,'',NULL,0 ), -- 182702 Dracthyr Talon · Dracthyr Talon 5/8 [z: navmesh 218.67 (vecino a 40.0 yd en 204.1) [pisos: 154.95/218.67/248.74]]
( 9100012,182702,2570,0,0,'0',0,0,0,-1,0,0,6114.0000,-3030.0000,238.2800,0.0000,120,0.00,0,NULL,0,NULL,NULL,NULL,NULL,'',NULL,0 ), -- 182702 Dracthyr Talon · Dracthyr Talon 6/8 [z: navmesh 238.28 (vecino a 40.0 yd en 136.1) [pisos: 238.28/248.7]]
( 9100013,182702,2570,0,0,'0',0,0,0,-1,0,0,6149.0000,-3068.0000,135.9100,0.0000,120,0.00,0,NULL,0,NULL,NULL,NULL,NULL,'',NULL,0 ); -- 182702 Dracthyr Talon · Dracthyr Talon 7/8 [z: navmesh 135.91 (vecino a 42.1 yd en 136.1) [pisos: 135.91/204.65/425.45]]

-- --- relaciones de mision (dador / entregador) ---
DELETE FROM `creature_queststarter` WHERE `id` IN (181056,181594,182069);
INSERT INTO `creature_queststarter` (`id`,`quest`) VALUES
(181056,64865),
(182069,64863),
(181594,64866);

DELETE FROM `creature_questender` WHERE `id` IN (181056,181594,182069,182168);
INSERT INTO `creature_questender` (`id`,`quest`) VALUES
(181056,64864),
(182069,64863),
(181594,64865),
(182168,64866);

-- --- flag de dador (sin el flag el NPC no interactua) ---
UPDATE `creature_template` SET `npcflag` = `npcflag` | 2 WHERE `entry` IN (181056,181594,182069,182168);

-- --- SQL propio del plan (SmartAI, auras, etc.) ---
-- 181712 Talon Kethahn: el objetivo 'Kethahn found' de 64864 es de tipo TALKTO y el core solo lo acredita
-- por SmartAI (SMART_ACTION_CREDIT_QUEST_OBJECTIVE_TALK_TO = 153; la llamada directa en NPCHandler esta
-- comentada). Para poder interactuar necesita el flag GOSSIP (0x1). El patron (evento 64 -> accion 153 con
-- target 7) es el de la propia TDB: entry 55054 'General Nazgrim - On gossip hello - Credit quest objective TalkTo'.
UPDATE `creature_template` SET `npcflag` = `npcflag` | 1, `AIName` = 'SmartAI' WHERE `entry` = 181712;

DELETE FROM `smart_scripts` WHERE `entryorguid` = 181712 AND `source_type` = 0;

INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`Difficulties`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`action_param7`,`action_param_string`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_param_string`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(181712,0,0,0,'',64,0,100,0,0,0,0,0,0,'',153,0,0,0,0,0,0,0,NULL,7,0,0,0,0,NULL,0,0,0,0,'Talon Kethahn - al hablar - acredita el objetivo TALKTO de 64864 (Kethahn found)');

-- Verificacion sugerida:
--   SELECT c.guid,c.id,ct.name,c.position_x,c.position_y,c.position_z FROM creature c
--     JOIN creature_template ct ON ct.entry=c.id WHERE c.guid BETWEEN 9100000 AND 9100013;
