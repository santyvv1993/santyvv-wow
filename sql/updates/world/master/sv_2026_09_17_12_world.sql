-- O5, segunda pasada: la cascada que dejo la migracion sv_2026_09_17_11_world.sql.
-- Detalle en docs/PENDIENTES.md (P5) y docs/INVENTARIO-ERRORES-ARRANQUE.md (§6).
--
-- POR QUE HAY SEGUNDA PASADA (leccion medida): borrar una tabla de botin no es aislado.
--   1) El grafo de referencias es transitivo: `reference_loot_template` entrada X puede estar
--      citada SOLO por la tabla que se borro, y al borrarla X queda huerfana. Paso aca: 4 -> 25.
--   2) Las `conditions` apuntan a la tabla de botin: al borrarla, sus condiciones quedan
--      colgando. Paso aca: 0 -> 10 lineas (SourceType 1 Creature Loot y 4 GameObject Loot).
-- Neto del levante anterior: -176 familias cerradas -1 linea de bonus +25 referencias +10
-- condiciones = **-142**, que es exactamente lo que midio el levante. El numero reconcilia.
--
-- Se itera hasta que el levante deje de moverse (esta es la 2a pasada).
-- Idempotente: una segunda corrida no borra nada.

-- ---------------------------------------------------------------------------
-- 1) `reference_loot_template` que quedaron sin nadie que las cite · 25 entradas
--    Familia: "Table 'reference_loot_template' Entry N isn't reference id and not referenced
--    from loot, and thus useless." (eran 4; las otras 21 aparecieron al borrar la migracion 11)
DELETE FROM `reference_loot_template` WHERE `Entry` IN (
    12000, 12003, 12005, 12007, 12023, 12028, 34146, 34174, 34175, 34204, 34206, 34208, 34209, 34210, 34276, 34277,
    34285, 34286, 34289, 34290, 34339, 34346, 34361, 34367, 35048
);

-- ---------------------------------------------------------------------------
-- 2) `conditions` que apuntan a una tabla de botin que ya no existe · 10 filas
--    Familia: "[Condition SourceType: (Creature Loot|GameObject Loot), SourceGroup: N ...]
--    SourceGroup N does not exist in ...". La condicion del SQL es la general (por tipo de
--    fuente de botin), no la lista de ids: da exactamente las 10 que el core reporta y ademas
--    cubre cualquier borrado futuro. Los SourceType 1..12 son los de botin (ConditionMgr.h:157+).
DELETE c FROM `conditions` c
 WHERE (c.`SourceTypeOrReferenceId` = 1  AND NOT EXISTS (SELECT 1 FROM `creature_loot_template`      t WHERE t.`Entry` = c.`SourceGroup`))
    OR (c.`SourceTypeOrReferenceId` = 2  AND NOT EXISTS (SELECT 1 FROM `disenchant_loot_template`    t WHERE t.`Entry` = c.`SourceGroup`))
    OR (c.`SourceTypeOrReferenceId` = 4  AND NOT EXISTS (SELECT 1 FROM `gameobject_loot_template`    t WHERE t.`Entry` = c.`SourceGroup`))
    OR (c.`SourceTypeOrReferenceId` = 5  AND NOT EXISTS (SELECT 1 FROM `item_loot_template`          t WHERE t.`Entry` = c.`SourceGroup`))
    OR (c.`SourceTypeOrReferenceId` = 7  AND NOT EXISTS (SELECT 1 FROM `milling_loot_template`       t WHERE t.`Entry` = c.`SourceGroup`))
    OR (c.`SourceTypeOrReferenceId` = 8  AND NOT EXISTS (SELECT 1 FROM `pickpocketing_loot_template` t WHERE t.`Entry` = c.`SourceGroup`))
    OR (c.`SourceTypeOrReferenceId` = 10 AND NOT EXISTS (SELECT 1 FROM `reference_loot_template`     t WHERE t.`Entry` = c.`SourceGroup`))
    OR (c.`SourceTypeOrReferenceId` = 11 AND NOT EXISTS (SELECT 1 FROM `skinning_loot_template`      t WHERE t.`Entry` = c.`SourceGroup`));
