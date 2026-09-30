-- Arranque de raza/clase: Dracthyr 2/2: el acopio de 64865 (Gear Up), Lapisagos y la salida de 64871
-- Generado por herramientas/arranque-propuesta.py desde plan-dracthyr-creche-2.json
-- Mapa 2570 · zona 13769 · 1 spawns · 0 relaciones
--
-- Idempotente: DELETE de la clave exacta antes de cada INSERT.

-- --- spawns ---
DELETE FROM `creature` WHERE `guid` IN (9100100);
INSERT INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`wander_distance`,`currentwaypoint`,`curHealthPct`,`MovementType`,`npcflag`,`unit_flags`,`unit_flags2`,`unit_flags3`,`ScriptName`,`StringId`,`VerifiedBuild`) VALUES
( 9100100,186854,2570,0,0,'0',0,0,0,-1,0,0,6322.0000,-3279.0000,190.0000,0.0000,120,0.00,0,NULL,0,NULL,NULL,NULL,NULL,'',NULL,0 ); -- 186854 Lapisagos · Lapisagos 'The Spellsworn' - jefe de 64871. POI del objetivo con Z real (190) [z: plan]

-- --- objetos ---
DELETE FROM `gameobject` WHERE `guid` IN (9100200,9100201,9100202);
INSERT INTO `gameobject` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`position_x`,`position_y`,`position_z`,`orientation`,`rotation0`,`rotation1`,`rotation2`,`rotation3`,`spawntimesecs`,`animprogress`,`state`,`ScriptName`,`StringId`,`VerifiedBuild`) VALUES
( 9100200,370527,2570,0,0,'0',0,0,0,-1,5920.0000,-3046.0000,201.0000,0.0000,0,0,0,1,300,255,1,'',NULL,0 ), -- 370527 Weapon Rack · Weapon Rack -> Stack of Weapons (187852), objetivo 0 de Gear Up. POI 5920/-3046/201 [z: plan]
( 9100201,370528,2570,0,0,'0',0,0,0,-1,6030.0000,-2984.0000,201.3200,0.0000,0,0,0,1,300,255,1,'',NULL,0 ), -- 370528 Crate of Warscale Armor · Crate of Warscale Armor -> Crate of Warscales (187853), objetivo 1. POI 6030/-2984 [z: navmesh 201.32 (vecino 200.7 a 5.6 yd)]
( 9100202,370526,2570,0,0,'0',0,0,0,-1,5953.0000,-2926.0000,200.6900,0.0000,0,0,0,1,300,255,1,'',NULL,0 ); -- 370526 Rations · Rations -> Decayed Rations (187855), objetivo 2. POI 5953/-2926 [z: navmesh 200.69 (vecino 200.7 a 2.7 yd)]

-- --- SQL propio del plan (SmartAI, auras, etc.) ---
-- Lapisagos nace amistoso (faction 0 -> el core pone 35) y no se lo podria atacar: se le da la faccion
-- de la chusma hostil de la propia zona (190 = la de Conjured Guardian y Ancient Construct).
UPDATE `creature_template` SET `faction` = 190 WHERE `entry` = 186854;

-- El botin de los tres objetos del acopio (Data1 = id de botin del cofre; la convencion de la TDB es el propio entry).
UPDATE `gameobject_template` SET `Data1` = `entry` WHERE `entry` IN (370526,370527,370528);

DELETE FROM `gameobject_loot_template` WHERE `Entry` IN (370526,370527,370528);

INSERT INTO `gameobject_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) VALUES
(370527,0,187852,100,1,1,0,1,1,'Weapon Rack - Stack of Weapons (objetivo de 64865)'),
(370528,0,187853,100,1,1,0,1,1,'Crate of Warscale Armor - Crate of Warscales (objetivo de 64865)'),
(370526,0,187855,100,1,1,0,1,1,'Rations - Decayed Rations (objetivo de 64865)');

-- La salida del War Creche: definicion + volumen (cilindro de 20 yd de radio y 12 de alto en el extremo
-- de la fuga, POI 6347/-3254/190) + aparicion. El entry del objeto es el Id de areatrigger_template
-- (AreaTrigger.cpp:170 SetEntry(GetTemplate()->Id.Id)), que es contra lo que compara el objetivo.
DELETE FROM `areatrigger_template` WHERE `Id`=24025 AND `IsCustom`=1;

INSERT INTO `areatrigger_template` (`Id`,`IsCustom`,`Flags`,`ActionSetId`,`ActionSetFlags`,`VerifiedBuild`) VALUES (24025,1,1,0,0,0);

DELETE FROM `areatrigger_create_properties` WHERE `Id`=24025 AND `IsCustom`=1;

INSERT INTO `areatrigger_create_properties` (`Id`,`IsCustom`,`AreaTriggerId`,`IsAreatriggerCustom`,`Flags`,`MoveCurveId`,`ScaleCurveId`,`MorphCurveId`,`FacingCurveId`,`AnimId`,`AnimKitId`,`DecalPropertiesId`,`SpellForVisuals`,`PositionalSoundKitId`,`TimeToTargetScale`,`Speed`,`SpeedIsTime`,`Shape`,`ShapeData0`,`ShapeData1`,`ShapeData2`,`ShapeData3`,`ShapeData4`,`ShapeData5`,`ShapeData6`,`ShapeData7`,`Roll`,`Pitch`,`Yaw`,`TargetRoll`,`TargetPitch`,`TargetYaw`,`ScriptName`,`VerifiedBuild`) VALUES
(24025,1,24025,1,0,0,0,0,0,-1,0,0,NULL,0,0,1,0,4,20,20,12,12,0,0,0,0,0,0,0,NULL,NULL,NULL,'',0);

DELETE FROM `areatrigger` WHERE `SpawnId`=9500000;

INSERT INTO `areatrigger` (`SpawnId`,`AreaTriggerCreatePropertiesId`,`IsCustom`,`MapId`,`SpawnDifficulties`,`PosX`,`PosY`,`PosZ`,`Orientation`,`PhaseUseFlags`,`PhaseId`,`PhaseGroup`,`ScriptName`,`Comment`,`VerifiedBuild`) VALUES
(9500000,24025,1,2570,'0',6347,-3254,190,0,0,0,0,'','Forbidden Reach - la salida del War Creche (objetivo Exit reached de la mision 64871)',0);

-- Verificacion sugerida:
--   SELECT c.guid,c.id,ct.name,c.position_x,c.position_y,c.position_z FROM creature c
--     JOIN creature_template ct ON ct.entry=c.id WHERE c.guid BETWEEN 9100100 AND 9100100;
