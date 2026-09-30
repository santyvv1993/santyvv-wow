-- SV migracion sv_2026_09_18_14_world.sql
-- Saneamiento de TODO lo importado (cualquier lote): las reglas del motor aplicadas parejo.
-- Idempotente.
--
-- mascaras: {'unit_flags': '0x2002300', 'unit_flags2': '0x4000022', 'unit_flags3': '0x0'} (ok)
-- fases del cliente: 38 (Phase.db2 del cliente)
-- 2. curHealthPct a NULL: 2
-- 3. modelid a 0: 52
-- 5. unit_flags2 enmascarado: 1
-- 6. equipos traidos: 13 | sin fuente (a 0): 0
-- 7. PhaseId neutralizada (fase que el cliente no tiene): 132 criaturas

UPDATE `creature` SET `curHealthPct` = NULL WHERE `guid` >= 3100000000 AND `curHealthPct` IS NOT NULL;
UPDATE `creature` SET `modelid` = 0 WHERE `guid` >= 3100000000 AND `modelid` <> 0;
UPDATE `creature` SET `unit_flags2` = `unit_flags2` & 67108898 WHERE `guid` >= 3100000000 AND (`unit_flags2` & ~67108898) <> 0;
DELETE FROM `creature_equip_template` WHERE `CreatureID`=191583 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(191583, 1, 155543, 0, 0, 0, 0, 0, 0, 0, 0, 47213);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=191584 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(191584, 1, 192154, 0, 0, 0, 0, 0, 0, 0, 0, 47213);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=192827 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(192827, 1, 192155, 0, 0, 0, 0, 0, 0, 0, 0, 47213);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=192826 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(192826, 1, 192909, 0, 0, 0, 0, 0, 0, 0, 0, 47213);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=190274 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(190274, 1, 192519, 0, 0, 0, 0, 0, 0, 0, 0, 47213);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=188819 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(188819, 1, 191687, 0, 0, 0, 0, 0, 0, 0, 0, 47213);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=184375 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(184375, 1, 191694, 0, 0, 0, 0, 0, 0, 0, 0, 47213);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=184420 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(184420, 1, 192519, 0, 0, 0, 0, 0, 0, 0, 0, 47213);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=190480 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(190480, 1, 191687, 0, 0, 0, 0, 0, 0, 0, 0, 47213);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=192273 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(192273, 1, 193632, 0, 0, 0, 0, 0, 0, 0, 0, 47213);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=192221 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(192221, 1, 193632, 0, 0, 0, 0, 0, 0, 0, 0, 47213);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=192308 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(192308, 1, 192519, 0, 0, 0, 0, 0, 0, 0, 0, 47213);
DELETE FROM `creature_equip_template` WHERE `CreatureID`=192310 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(192310, 1, 191694, 0, 0, 0, 0, 0, 0, 0, 0, 47213);
UPDATE `creature` SET `PhaseId` = 0 WHERE `guid` >= 3100000000 AND `PhaseId` <> 0 AND `PhaseId` NOT IN (50, 52, 101, 169, 173, 225, 556, 579, 949, 1001, 2275, 2392, 2407, 2532, 2620, 2629, 3261, 3423, 3703, 3987, 4702, 8293, 8683, 13198, 14393, 14505, 15382, 15592, 16429, 17506, 24417, 25295, 25460, 26077, 26619, 27437, 28416, 28585);
