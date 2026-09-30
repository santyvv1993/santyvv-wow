-- SV migracion sv_2026_09_18_55_world.sql
-- Regla completa de `npc_text`: probabilidad sin texto del cliente -> 0. Idempotente.
--
-- filas: 649

UPDATE `npc_text` SET `Probability0` = 0 WHERE `BroadcastTextID0` = 0 AND `Probability0` > 0;
UPDATE `npc_text` SET `Probability1` = 0 WHERE `BroadcastTextID1` = 0 AND `Probability1` > 0;
UPDATE `npc_text` SET `Probability2` = 0 WHERE `BroadcastTextID2` = 0 AND `Probability2` > 0;
UPDATE `npc_text` SET `Probability3` = 0 WHERE `BroadcastTextID3` = 0 AND `Probability3` > 0;
UPDATE `npc_text` SET `Probability4` = 0 WHERE `BroadcastTextID4` = 0 AND `Probability4` > 0;
