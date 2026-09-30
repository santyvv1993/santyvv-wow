-- O3 del inventario de arranque: huerfanos grandes que el core ya ignora.
-- Detalle y cifras en docs/INVENTARIO-ERRORES-ARRANQUE.md (§6, ola O3) y docs/PENDIENTES.md (P5).
-- Las tres condiciones estan escritas igual que en el core (ObjectMgr / PoolMgr), no por parecido
-- del texto del mensaje; el conteo del SQL coincide linea a linea con las quejas del ultimo levante.
-- Idempotente: una segunda corrida no borra nada.

-- ---------------------------------------------------------------------------
-- 1) Pools vacios · familia "Pool Id N is empty" (1.801 lineas / 1.801 pools)
--    Condicion del core (PoolMgr::IsEmpty, PoolMgr.cpp:816): el pool no esta vacio si tiene
--    miembros directos (pool_members.type 0 = criatura, 1 = gameobject) O si algun hijo
--    (type 2, spawnId = pool hijo, poolSpawnId = pool madre) no esta vacio. Recursivo hacia arriba.
--    La condicion del SQL da exactamente los mismos 1.801 ids que el log.
DROP TEMPORARY TABLE IF EXISTS tmp_pool_vacio;
CREATE TEMPORARY TABLE tmp_pool_vacio (entry INT UNSIGNED NOT NULL PRIMARY KEY) ENGINE = MEMORY;
REPLACE INTO tmp_pool_vacio (entry)
WITH RECURSIVE
    hijo AS (SELECT spawnId AS child, poolSpawnId AS parent FROM pool_members WHERE type = 2),
    directo AS (SELECT poolSpawnId AS pool FROM pool_members WHERE type IN (0, 1) GROUP BY poolSpawnId),
    no_vacio AS (SELECT pool FROM directo
                 UNION DISTINCT
                 SELECT h.parent FROM hijo h JOIN no_vacio nv ON nv.pool = h.child)
SELECT pt.entry FROM pool_template pt LEFT JOIN no_vacio r ON r.pool = pt.entry WHERE r.pool IS NULL;

-- un pool vacio no puede tener vinculos: si la madre sigue existiendo, el vinculo queda colgando
DELETE pm FROM pool_members pm JOIN tmp_pool_vacio v ON pm.type = 2 AND (pm.spawnId = v.entry OR pm.poolSpawnId = v.entry);
DELETE gep FROM game_event_pool gep JOIN tmp_pool_vacio v ON gep.pool_entry = v.entry;
DELETE pt FROM pool_template pt JOIN tmp_pool_vacio v ON pt.entry = v.entry;
DROP TEMPORARY TABLE tmp_pool_vacio;

-- ---------------------------------------------------------------------------
-- 2) Chismes de menus que no existen · familia "creature_template_gossip ... menu id N"
--    (836 lineas sobre 7.111 filas). Condicion del core (ObjectMgr::LoadCreatureTemplateGossip:503):
--    el menu no esta en la tienda porque gossip_menu no tiene esa fila, o porque su TextID no se
--    cargo en LoadNPCText (id 0, o suma de probabilidades 0: las opciones sin BroadcastTextID y las
--    que apuntan a un BroadcastText que el cliente ya no trae se descartan antes de sumar).
--    Replica exacta: 830 filas / 791 menus de los 836/796 del log; los 5 menus de diferencia son
--    los que el core descarta por BroadcastText y no por TextID (anotado en el doc del inventario).
DELETE cg FROM creature_template_gossip cg
WHERE NOT EXISTS (
    SELECT 1 FROM gossip_menu g JOIN npc_text t ON t.ID = g.TextID
    WHERE g.MenuID = cg.MenuID
      AND (   (t.Probability0 > 0 AND t.BroadcastTextID0 <> 0)
           OR (t.Probability1 > 0 AND t.BroadcastTextID1 <> 0)
           OR (t.Probability2 > 0 AND t.BroadcastTextID2 <> 0)
           OR (t.Probability3 > 0 AND t.BroadcastTextID3 <> 0)
           OR (t.Probability4 > 0 AND t.BroadcastTextID4 <> 0)
           OR (t.Probability5 > 0 AND t.BroadcastTextID5 <> 0)
           OR (t.Probability6 > 0 AND t.BroadcastTextID6 <> 0)
           OR (t.Probability7 > 0 AND t.BroadcastTextID7 <> 0))
);

-- ---------------------------------------------------------------------------
-- 3) Vinculos de pool muertos · familias "`pool_creature` pool id (N) is not in `pool_template`"
--    (21 lineas) y "`pool_gameobject` has a non existing gameobject spawn" (3 lineas).
--    Ojo con el nombre: el core sigue llamando `pool_creature`/`pool_gameobject` a lo que hoy lee de
--    `pool_members` (type 0 y 1). Borrar la fila que el core saltea no cambia nada del juego: esa
--    criatura/objeto no queda en ningun pool ni antes ni despues.
DELETE pm FROM pool_members pm
WHERE pm.type IN (0, 1) AND pm.poolSpawnId NOT IN (SELECT entry FROM pool_template);
DELETE pm FROM pool_members pm
WHERE pm.type = 1 AND NOT EXISTS (SELECT 1 FROM gameobject g WHERE g.guid = pm.spawnId);

-- ---------------------------------------------------------------------------
-- 4) Moneda retirada del cliente · familia "creature_quest_currency has nonexistent currency"
--    (4.995 lineas). La unica moneda que el core rechaza es la 3252 (medido line a line sobre el
--    ultimo levante): el cliente 12.1 ya no la trae en CurrencyTypes.db2, asi que las 4.995 filas
--    que la usan se descartan al cargar. Que la tabla quede con las 185 monedas validas.
DELETE FROM creature_quest_currency WHERE CurrencyId = 3252;
