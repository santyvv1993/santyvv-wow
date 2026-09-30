-- SV migracion sv_2026_09_18_25_world.sql
-- Correctiva del frente de botin y de la tanda 8 (claves del propio log). Idempotente.
--
-- A. gameobject_loot_template: 12 filas con MinCount 0 -> 1
-- B. ScriptName 'go_army_training_chests' limpiado en 2 plantillas de objeto
-- B. ScriptName 'go_art_devourer' limpiado en 1 plantillas de objeto
-- B. ScriptName 'go_art_earthwarder' limpiado en 1 plantillas de objeto
-- B. ScriptName 'go_art_silverhand' limpiado en 1 plantillas de objeto
-- B. ScriptName 'go_art_warswords' limpiado en 1 plantillas de objeto
-- B. ScriptName 'go_broken_sword_250364' limpiado en 1 plantillas de objeto
-- B. ScriptName 'go_devourer_misc' limpiado en 3 plantillas de objeto
-- B. ScriptName 'go_mystic_bonfire' limpiado en 1 plantillas de objeto
-- B. ScriptName 'go_prison_runestone' limpiado en 1 plantillas de objeto
-- C. entradas de objeto que siguen sin lista de botin (no esta en ninguna fuente): 1136

UPDATE `gameobject_loot_template` SET `MinCount` = 1 WHERE (`Entry`, `Item`) IN ((251052, 121407), (252668, 140176), (252668, 141854), (252671, 140176), (252674, 140176), (252680, 141852), (252683, 140176), (252683, 141852), (252683, 141854), (252684, 138786), (252686, 141852), (252686, 141854)) AND (`MinCount` IS NULL OR `MinCount` = 0);
UPDATE `gameobject_template` SET `ScriptName` = '' WHERE `ScriptName` = 'go_army_training_chests';
UPDATE `gameobject_template` SET `ScriptName` = '' WHERE `ScriptName` = 'go_art_devourer';
UPDATE `gameobject_template` SET `ScriptName` = '' WHERE `ScriptName` = 'go_art_earthwarder';
UPDATE `gameobject_template` SET `ScriptName` = '' WHERE `ScriptName` = 'go_art_silverhand';
UPDATE `gameobject_template` SET `ScriptName` = '' WHERE `ScriptName` = 'go_art_warswords';
UPDATE `gameobject_template` SET `ScriptName` = '' WHERE `ScriptName` = 'go_broken_sword_250364';
UPDATE `gameobject_template` SET `ScriptName` = '' WHERE `ScriptName` = 'go_devourer_misc';
UPDATE `gameobject_template` SET `ScriptName` = '' WHERE `ScriptName` = 'go_mystic_bonfire';
UPDATE `gameobject_template` SET `ScriptName` = '' WHERE `ScriptName` = 'go_prison_runestone';
