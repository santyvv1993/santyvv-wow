-- SV migracion sv_2026_09_18_09_world.sql
-- Correctiva final del lote de zonas de arranque (07/08): relaciones de misiones que no tenemos,
-- bandera de dador/entregador y equipment_id invalido. Idempotente.
--
-- D'. creature_queststarter: 12 relaciones de misiones inexistentes fuera
-- D'. creature_questender: 11 relaciones de misiones inexistentes fuera
-- F'. npcflag | 2 en 14 plantillas
-- G. equipment_id inexistente puesto a 0: 2 filas (equipos [1])

DELETE FROM `creature_queststarter` WHERE (`id`, `quest`) IN ((34668, 2452001), (36452, 90416), (36606, 90417), (36743, 90418), (37106, 2452001), (53566, 9047100), (56013, 3098701), (56662, 90419), (57721, 3098701), (154327, 9100219), (156651, 9047200), (166906, 9047300));
DELETE FROM `creature_questender` WHERE (`id`, `quest`) IN ((34668, 2452001), (36606, 90416), (36743, 90417), (36743, 90418), (53566, 9047100), (56012, 90419), (154327, 9047200), (154327, 9047300), (154327, 9100219), (156280, 5820801), (166996, 9047300));
UPDATE `creature_template` SET `npcflag` = `npcflag` | 2 WHERE `entry` IN (34865, 36287, 36288, 36289, 43749, 44388, 55999, 56622, 57720, 57721, 60770, 65493, 156804, 156943);
UPDATE `creature` SET `equipment_id` = 0 WHERE `guid` IN (3186000075, 3186000076);
