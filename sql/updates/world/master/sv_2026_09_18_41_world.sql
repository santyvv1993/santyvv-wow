-- SV migracion sv_2026_09_18_41_world.sql
-- Limpieza: npc_text que el core saltea siempre (sin ningun BroadcastTextID). Idempotente.
--
-- npc_text sin texto del cliente borrados: 664 (referenciados por un menu vivo: 0)

DELETE FROM `npc_text` WHERE (`BroadcastTextID0` + `BroadcastTextID1` + `BroadcastTextID2` + `BroadcastTextID3` + `BroadcastTextID4` + `BroadcastTextID5` + `BroadcastTextID6` + `BroadcastTextID7`) = 0;
