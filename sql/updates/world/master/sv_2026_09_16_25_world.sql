-- =====================================================================
-- 2026_09_16_25_world.sql
-- NPC con relación de misión pero sin el flag de dador (el core lo avisa).
-- =====================================================================
-- Contexto: el parche de contenido de Azj-Kahet (16-sep) agregó relaciones de
-- misión para estos NPC. El core las carga igual, pero al arrancar avisa:
--   `creature_queststarter/ender` has creature entry (N) for quest N, but npcflag
--   does not include UNIT_NPC_FLAG_QUESTGIVER        (ObjectMgr.cpp:8586 y :8600)
-- Son 5 filas (4 de dador + 1 de entregador) para 4 entries con npcflag = 0 y SIN
-- spawn en ningún mapa todavía: la relación es inerte hoy (no hay NPC con quien
-- hablar), pero el flag la deja utilizable el día que se spawneen, y saca el aviso
-- del arranque. Medido: la familia pasó de 0 a 5 líneas en el levante del 16-sep 18:11
-- y estas 5 filas son su origen exacto.
-- =====================================================================

UPDATE `creature_template`
   SET `npcflag` = `npcflag` | 2      -- UNIT_NPC_FLAG_QUESTGIVER
 WHERE `entry` IN (
        215637,   -- Y'tekhi           (da 79233)
        219357,   -- Orator Tx'itk     (da 80203)
        220690,   -- Klaskin           (da 80502)
        223944    -- Alleria Windrunner (da 79224, cierra 79244)
 );

-- Verificación: ninguna relación de misión debe quedar sin el flag.
--   SELECT COUNT(*) FROM creature_queststarter cs JOIN creature_template ct ON ct.entry = cs.id
--    WHERE (ct.npcflag & 2) = 0;      -- esperado 0
--   SELECT COUNT(*) FROM creature_questender  ce JOIN creature_template ct ON ct.entry = ce.id
--    WHERE (ct.npcflag & 2) = 0;      -- esperado 0

-- Reversión:
--   UPDATE creature_template SET npcflag = npcflag & ~2 WHERE entry IN (215637,219357,220690,223944);
