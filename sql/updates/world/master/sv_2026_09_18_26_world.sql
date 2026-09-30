-- SV migracion sv_2026_09_18_26_world.sql
-- Rangos de cantidad invalidos en las listas de botin (MinCount/MaxCount). Idempotente.
--
-- A. gameobject_loot_template: 12 filas con rango de cantidad normalizado

UPDATE `gameobject_loot_template` SET `MinCount` = IF(`MinCount` < 1, 1, `MinCount`), `MaxCount` = IF(`MaxCount` < `MinCount`, `MinCount`, `MaxCount`) WHERE (`Entry`, `Item`) IN ((251052, 121407), (252668, 140176), (252668, 141854), (252671, 140176), (252674, 140176), (252680, 141852), (252683, 140176), (252683, 141852), (252683, 141854), (252684, 138786), (252686, 141852), (252686, 141854));
