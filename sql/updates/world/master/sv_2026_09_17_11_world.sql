-- O5 del inventario de arranque: tablas de botin que el core reporta como inutiles.
-- Detalle y cifras en docs/INVENTARIO-ERRORES-ARRANQUE.md (§6, ola O3) y docs/PENDIENTES.md (P5).
--
-- POR QUE LOS IDS VIENEN DEL LOG Y NO DE UNA CONSULTA NUESTRA (leccion medida el 17-sep-2026):
-- la condicion del core es "el id no esta referenciado", pero las referencias las arma en C++
-- y contra los DB2 del cliente (GameObjectData, item flags, ItemDisenchantLoot). Un SQL
-- aproximado con lo que SI esta en MySQL da MUCHISIMO mas: para `gameobject_loot_template`
-- mi consulta marcaba 1.214 entradas cuando el core reporta 113 (10x) — o sea que 1.100 tablas
-- de botin que el core SI usa habrian desaparecido. Cuando la fuente de las referencias no
-- esta en MySQL, la lista de ids sale del propio log (que es el veredicto del core), y se
-- cuenta igual: el numero de filas borradas tiene que dar el numero de lineas del levante.
--
-- Idempotente: una segunda corrida no borra nada.

-- ---------------------------------------------------------------------------
-- Table `gameobject_loot_template` · 113 entradas sin ninguna referencia
--    Familia: "Table 'gameobject_loot_template' Entry N isn't gameobject entry and not referenced from loot, and thus useless."
--    El core arma el conjunto de ids USADOS (el core marca como usados los Data1 de los tipos 3/25/50 (cofre, pozo de pesca, nodo)) y lo que queda sin usar lo reporta.
--    Los ids de abajo son los que el propio core reporta en el ultimo levante (no una
--    reconstruccion nuestra: ver la nota de abajo), y ninguno aparece en un contexto de
--    botin en los scripts (`git grep -w <id> src/server/scripts` + filtro de la palabra loot).
DELETE FROM `gameobject_loot_template` WHERE `Entry` IN (
    167, 938, 1420, 1421, 1423, 1424, 1594, 1689, 1730, 1731, 1732, 1733, 1734, 2292, 2416, 2417,
    2418, 2483, 2628, 2629, 3881, 4165, 4766, 4964, 6142, 6151, 6152, 6312, 6313, 8759, 9239, 9240,
    9241, 9242, 9597, 10101, 10102, 12260, 13945, 13946, 13947, 13948, 13949, 13970, 15000, 16332, 16577, 16719,
    17378, 18111, 18112, 18113, 18115, 18116, 18117, 18118, 18119, 18359, 18361, 18363, 21762, 22098, 22906, 24093,
    24124, 24154, 24155, 24156, 24224, 24225, 24226, 24227, 25089, 25093, 25192, 25193, 26094, 26097, 26956, 26959,
    26963, 26974, 27061, 27068, 27069, 27073, 27356, 27826, 28088, 28096, 28491, 28492, 28493, 28494, 28495, 28521,
    28522, 28523, 28524, 28525, 28526, 28682, 28683, 40346, 41213, 180510, 180512, 195665, 195666, 195667, 195668, 195672,
    244447
);

-- ---------------------------------------------------------------------------
-- Table `creature_loot_template` · 42 entradas sin ninguna referencia
--    Familia: "Table 'creature_loot_template' Entry N isn't creature entry and not referenced from loot, and thus useless."
--    El core arma el conjunto de ids USADOS (los LootID por dificultad de `creature_template_difficulty`) y lo que queda sin usar lo reporta.
--    Los ids de abajo son los que el propio core reporta en el ultimo levante (no una
--    reconstruccion nuestra: ver la nota de abajo), y ninguno aparece en un contexto de
--    botin en los scripts (`git grep -w <id> src/server/scripts` + filtro de la palabra loot).
DELETE FROM `creature_loot_template` WHERE `Entry` IN (
    520, 808, 3870, 17536, 23980, 30892, 31125, 32353, 33993, 34015, 35013, 37070, 37073, 37112, 37507, 38433,
    42938, 47132, 47136, 47137, 47138, 47140, 47141, 47143, 47145, 47146, 74351, 74353, 74363, 74380, 74382, 74980,
    74983, 75058, 75135, 75285, 75286, 76036, 76037, 76038, 76039, 77232
);

-- ---------------------------------------------------------------------------
-- Table `pickpocketing_loot_template` · 5 entradas sin ninguna referencia
--    Familia: "Table 'pickpocketing_loot_template' Entry N isn't creature pickpocket lootid and not referenced from loot, and thus useless."
--    El core arma el conjunto de ids USADOS (los PickPocketLootID por dificultad) y lo que queda sin usar lo reporta.
--    Los ids de abajo son los que el propio core reporta en el ultimo levante (no una
--    reconstruccion nuestra: ver la nota de abajo), y ninguno aparece en un contexto de
--    botin en los scripts (`git grep -w <id> src/server/scripts` + filtro de la palabra loot).
DELETE FROM `pickpocketing_loot_template` WHERE `Entry` IN (
    22128, 22261, 22262, 22263, 23386
);

-- ---------------------------------------------------------------------------
-- Table `skinning_loot_template` · 3 entradas sin ninguna referencia
--    Familia: "Table 'skinning_loot_template' Entry N isn't creature skinning id and not referenced from loot, and thus useless."
--    El core arma el conjunto de ids USADOS (los SkinLootID por dificultad) y lo que queda sin usar lo reporta.
--    Los ids de abajo son los que el propio core reporta en el ultimo levante (no una
--    reconstruccion nuestra: ver la nota de abajo), y ninguno aparece en un contexto de
--    botin en los scripts (`git grep -w <id> src/server/scripts` + filtro de la palabra loot).
DELETE FROM `skinning_loot_template` WHERE `Entry` IN (
    10116, 12723, 17952
);

-- ---------------------------------------------------------------------------
-- Table `reference_loot_template` · 4 entradas sin ninguna referencia
--    Familia: "Table 'reference_loot_template' Entry N isn't reference id and not referenced from loot, and thus useless."
--    El core arma el conjunto de ids USADOS (las referencias que citan las demas tablas de botin) y lo que queda sin usar lo reporta.
--    Los ids de abajo son los que el propio core reporta en el ultimo levante (no una
--    reconstruccion nuestra: ver la nota de abajo), y ninguno aparece en un contexto de
--    botin en los scripts (`git grep -w <id> src/server/scripts` + filtro de la palabra loot).
DELETE FROM `reference_loot_template` WHERE `Entry` IN (
    14500, 34032, 34359, 44011
);

-- ---------------------------------------------------------------------------
-- Table `disenchant_loot_template` · 4 entradas sin ninguna referencia
--    Familia: "Table 'disenchant_loot_template' Entry N isn't item disenchant id and not referenced from loot, and thus useless."
--    El core arma el conjunto de ids USADOS (el `ItemDisenchantLoot` del cliente (DB2)) y lo que queda sin usar lo reporta.
--    Los ids de abajo son los que el propio core reporta en el ultimo levante (no una
--    reconstruccion nuestra: ver la nota de abajo), y ninguno aparece en un contexto de
--    botin en los scripts (`git grep -w <id> src/server/scripts` + filtro de la palabra loot).
DELETE FROM `disenchant_loot_template` WHERE `Entry` IN (
    32, 52, 56, 57
);

-- ---------------------------------------------------------------------------
-- Table `item_loot_template` · 3 entradas sin ninguna referencia
--    Familia: "Table 'item_loot_template' Entry N isn't item entry and not referenced from loot, and thus useless."
--    El core arma el conjunto de ids USADOS (los items con flag HAS_LOOT del cliente (DB2)) y lo que queda sin usar lo reporta.
--    Los ids de abajo son los que el propio core reporta en el ultimo levante (no una
--    reconstruccion nuestra: ver la nota de abajo), y ninguno aparece en un contexto de
--    botin en los scripts (`git grep -w <id> src/server/scripts` + filtro de la palabra loot).
DELETE FROM `item_loot_template` WHERE `Entry` IN (
    45072, 54218, 236953
);

-- ---------------------------------------------------------------------------
-- Table `milling_loot_template` · 2 entradas sin ninguna referencia
--    Familia: "Table 'milling_loot_template' Entry N isn't item entry (herb) and not referenced from loot, and thus useless."
--    El core arma el conjunto de ids USADOS (las hierbas del cliente (DB2)) y lo que queda sin usar lo reporta.
--    Los ids de abajo son los que el propio core reporta en el ultimo levante (no una
--    reconstruccion nuestra: ver la nota de abajo), y ninguno aparece en un contexto de
--    botin en los scripts (`git grep -w <id> src/server/scripts` + filtro de la palabra loot).
DELETE FROM `milling_loot_template` WHERE `Entry` IN (
    8836, 39969
);
