-- SV migracion sv_2026_09_18_13_world.sql
-- Correctiva del lote de zonas modernas (12): state de objetos, equipos, mascaras de flags por
-- campo y listas de botin buscadas en TODAS las fuentes. Idempotente.
--
-- mascaras del core: {'unit_flags': '0x2002300', 'unit_flags2': '0x4000022', 'unit_flags3': '0x0'}
-- A. state normalizado a 1 (el objeto se saltaba): 685 filas ([11, 255])
-- C. unit_flags2 enmascarado: 25 filas
-- C. unit_flags3 enmascarado: 1 filas
-- B. equipos traidos de las fuentes: 69 | sin fuente (se ponen en 0): 14
-- D. creature_loot_template: 6 listas faltaban; traidas ninguna; sin fuente: 6 [219477, 9100131, 9100302, 9100322, 9100341, 10270000]
-- D. gameobject_loot_template: 90 listas faltaban; traidas ninguna; sin fuente: 90 [799, 110615, 110618, 110621, 110624, 110627, 110630, 110633, 110636, 111690, 111695, 112063]

UPDATE `gameobject` SET `state` = 1 WHERE `map` IN (2444, 2601, 2552, 2454, 2548) AND `guid` >= 3050000000 AND `state` NOT IN (0,1,2);
UPDATE `creature` SET `unit_flags2` = `unit_flags2` & 67108898 WHERE `map` IN (2444, 2601, 2552, 2454, 2548) AND `guid` >= 3100000000 AND (`unit_flags2` & ~67108898) <> 0;
UPDATE `creature` SET `unit_flags3` = `unit_flags3` & 0 WHERE `map` IN (2444, 2601, 2552, 2454, 2548) AND `guid` >= 3100000000 AND (`unit_flags3` & ~0) <> 0;
DELETE FROM `creature_equip_template` WHERE `CreatureID`=169428 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(169428, 1, 127651, 0, 0, 127651, 0, 0, 0, 0, 0, 51261);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=200051 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(200051, 1, 127142, 0, 0, 0, 0, 0, 0, 0, 0, 49444);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=199824 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(199824, 1, 125953, 0, 0, 192138, 0, 0, 0, 0, 0, 49444);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=199826 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(199826, 1, 202125, 0, 0, 0, 0, 0, 0, 0, 0, 49444);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=199827 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(199827, 1, 198049, 0, 0, 77245, 0, 0, 0, 0, 0, 49444);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=199828 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(199828, 1, 193772, 0, 0, 193772, 0, 0, 0, 0, 0, 49444);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=199839 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(199839, 1, 201976, 0, 0, 0, 0, 0, 0, 0, 0, 49444);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=199840 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(199840, 1, 195510, 0, 0, 195520, 0, 0, 0, 0, 0, 49444);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=199842 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(199842, 1, 190446, 0, 0, 190446, 0, 0, 0, 0, 0, 49444);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=199865 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(199865, 1, 190514, 0, 0, 0, 0, 0, 0, 0, 0, 49444);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=199866 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(199866, 1, 192105, 0, 0, 0, 0, 0, 0, 0, 0, 49444);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=199971 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(199971, 1, 202125, 0, 0, 0, 0, 0, 0, 0, 0, 49444);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=199972 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(199972, 1, 198049, 0, 0, 77245, 0, 0, 0, 0, 0, 49444);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=199980 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(199980, 1, 195518, 0, 0, 0, 0, 0, 0, 0, 0, 49444);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=199982 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(199982, 1, 163956, 0, 0, 0, 0, 0, 0, 0, 0, 49444);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=200057 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(200057, 1, 163003, 0, 0, 0, 0, 0, 0, 0, 0, 49444);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=200058 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(200058, 1, 107378, 0, 0, 107378, 0, 0, 0, 0, 0, 49444);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=200128 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(200128, 1, 163608, 0, 0, 0, 0, 0, 0, 0, 0, 49444);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=200135 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(200135, 1, 56912, 0, 0, 0, 0, 0, 0, 0, 0, 49444);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=200138 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(200138, 1, 192520, 0, 0, 0, 0, 0, 0, 0, 0, 49444);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=200168 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(200168, 1, 192517, 0, 0, 0, 0, 0, 0, 0, 0, 49444);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=200292 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(200292, 1, 9424, 0, 0, 9424, 0, 0, 0, 0, 0, 49444);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=200293 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(200293, 1, 93648, 0, 0, 0, 0, 0, 0, 0, 0, 49444);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=201024 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(201024, 1, 152426, 0, 0, 0, 0, 0, 0, 0, 0, 49444);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=201098 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(201098, 1, 18044, 0, 0, 0, 0, 0, 0, 0, 0, 49444);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=201103 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(201103, 1, 88535, 0, 0, 0, 0, 0, 0, 0, 0, 49444);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=201117 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(201117, 1, 71039, 0, 0, 0, 0, 0, 0, 0, 0, 49444);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=201268 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(201268, 1, 118801, 0, 0, 0, 0, 0, 0, 0, 0, 49444);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=201382 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(201382, 1, 118801, 0, 0, 0, 0, 0, 0, 0, 0, 49444);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=201383 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(201383, 1, 199823, 0, 0, 0, 0, 0, 0, 0, 0, 49444);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=201578 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(201578, 1, 118801, 0, 0, 0, 0, 0, 0, 0, 0, 49444);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=201646 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(201646, 1, 118801, 0, 0, 0, 0, 0, 0, 0, 0, 49444);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=201647 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(201647, 1, 199823, 0, 0, 0, 0, 0, 0, 0, 0, 49444);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=202451 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(202451, 1, 1539, 0, 0, 0, 0, 0, 0, 0, 0, 49444);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=202583 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(202583, 1, 18044, 0, 0, 0, 0, 0, 0, 0, 0, 49444);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=202675 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(202675, 1, 125953, 0, 0, 192138, 0, 0, 0, 0, 0, 49444);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=202743 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(202743, 1, 171194, 0, 0, 0, 0, 0, 0, 0, 0, 49444);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=202803 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(202803, 1, 125953, 0, 0, 192138, 0, 0, 0, 0, 0, 49444);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=202924 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(202924, 1, 62067, 0, 0, 0, 0, 0, 0, 0, 0, 49444);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=202934 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(202934, 1, 45123, 0, 0, 0, 0, 0, 0, 0, 0, 49444);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=203948 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(203948, 1, 192520, 0, 0, 0, 0, 0, 0, 0, 0, 49444);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=204013 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(204013, 1, 166996, 0, 0, 0, 0, 0, 0, 0, 0, 49444);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=204014 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(204014, 1, 166997, 0, 0, 0, 0, 0, 0, 0, 0, 49444);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=204015 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(204015, 1, 166998, 0, 0, 0, 0, 0, 0, 0, 0, 49444);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=204029 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(204029, 1, 191695, 0, 0, 0, 0, 0, 0, 0, 0, 49444);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=204056 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(204056, 1, 163608, 0, 0, 0, 0, 0, 0, 0, 0, 49444);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=204063 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(204063, 1, 163608, 0, 0, 0, 0, 0, 0, 0, 0, 49444);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=204072 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(204072, 1, 192520, 0, 0, 0, 0, 0, 0, 0, 0, 49444);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=204073 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(204073, 1, 56912, 0, 0, 0, 0, 0, 0, 0, 0, 49444);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=204078 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(204078, 1, 191695, 0, 0, 0, 0, 0, 0, 0, 0, 49444);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=204079 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(204079, 1, 191685, 0, 0, 200993, 0, 0, 0, 0, 0, 49444);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=204087 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(204087, 1, 107378, 0, 0, 107378, 0, 0, 0, 0, 0, 49444);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=204105 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(204105, 1, 192517, 0, 0, 0, 0, 0, 0, 0, 0, 49444);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=204106 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(204106, 1, 163608, 0, 0, 0, 0, 0, 0, 0, 0, 49444);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=204111 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(204111, 1, 163003, 0, 0, 0, 0, 0, 0, 0, 0, 49444);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=204242 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(204242, 1, 56912, 0, 0, 0, 0, 0, 0, 0, 0, 49444);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=204274 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(204274, 1, 107409, 0, 0, 0, 0, 0, 0, 0, 0, 49444);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=204968 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(204968, 1, 18044, 0, 0, 0, 0, 0, 0, 0, 0, 49444);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=204976 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(204976, 1, 44604, 0, 0, 0, 0, 0, 0, 0, 0, 49444);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=205226 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(205226, 1, 89897, 0, 0, 0, 0, 0, 0, 0, 0, 49444);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=205229 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(205229, 1, 94830, 0, 0, 0, 0, 0, 0, 0, 0, 49444);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=205230 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(205230, 1, 89897, 0, 0, 0, 0, 0, 0, 0, 0, 49444);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=205244 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(205244, 1, 109606, 0, 0, 0, 0, 0, 0, 0, 0, 49444);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=205245 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(205245, 1, 110241, 0, 0, 0, 0, 0, 0, 0, 0, 49444);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=207047 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(207047, 1, 57189, 0, 0, 0, 0, 0, 0, 0, 0, 52068);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=209874 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(209874, 1, 206597, 0, 0, 0, 0, 0, 0, 0, 0, 52068);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=209911 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(209911, 1, 208141, 0, 0, 0, 0, 0, 0, 0, 0, 52068);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=210793 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(210793, 1, 206587, 0, 0, 0, 0, 0, 0, 0, 0, 52068);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=210794 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(210794, 1, 206587, 0, 0, 0, 0, 0, 0, 0, 0, 52068);
UPDATE `creature` SET `equipment_id` = 0 WHERE `id` = 186241 AND `map` IN (2444, 2601, 2552, 2454, 2548) AND `guid` >= 3100000000 AND `equipment_id` IN (2, 3, 25, 127);
UPDATE `creature` SET `equipment_id` = 0 WHERE `id` = 187867 AND `map` IN (2444, 2601, 2552, 2454, 2548) AND `guid` >= 3100000000 AND `equipment_id` IN (3);
UPDATE `creature` SET `equipment_id` = 0 WHERE `id` = 188349 AND `map` IN (2444, 2601, 2552, 2454, 2548) AND `guid` >= 3100000000 AND `equipment_id` IN (26);
UPDATE `creature` SET `equipment_id` = 0 WHERE `id` = 188415 AND `map` IN (2444, 2601, 2552, 2454, 2548) AND `guid` >= 3100000000 AND `equipment_id` IN (3);
UPDATE `creature` SET `equipment_id` = 0 WHERE `id` = 188440 AND `map` IN (2444, 2601, 2552, 2454, 2548) AND `guid` >= 3100000000 AND `equipment_id` IN (3);
UPDATE `creature` SET `equipment_id` = 0 WHERE `id` = 190910 AND `map` IN (2444, 2601, 2552, 2454, 2548) AND `guid` >= 3100000000 AND `equipment_id` IN (3);
UPDATE `creature` SET `equipment_id` = 0 WHERE `id` = 193464 AND `map` IN (2444, 2601, 2552, 2454, 2548) AND `guid` >= 3100000000 AND `equipment_id` IN (27);
UPDATE `creature` SET `equipment_id` = 0 WHERE `id` = 195296 AND `map` IN (2444, 2601, 2552, 2454, 2548) AND `guid` >= 3100000000 AND `equipment_id` IN (-128);
UPDATE `creature` SET `equipment_id` = 0 WHERE `id` = 195324 AND `map` IN (2444, 2601, 2552, 2454, 2548) AND `guid` >= 3100000000 AND `equipment_id` IN (-128);
UPDATE `creature` SET `equipment_id` = 0 WHERE `id` = 198854 AND `map` IN (2444, 2601, 2552, 2454, 2548) AND `guid` >= 3100000000 AND `equipment_id` IN (3);
UPDATE `creature` SET `equipment_id` = 0 WHERE `id` = 218421 AND `map` IN (2444, 2601, 2552, 2454, 2548) AND `guid` >= 3100000000 AND `equipment_id` IN (1);
