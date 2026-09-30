-- Limpieza de filas huerfanas de campos de batalla: el cliente 12.1 (build 69814)
-- ya no tiene el "Ring of Valor" (mapa 618). El core lo delata en el arranque con dos errores:
--
--   BattlegroundMgr::LoadBattlegroundScriptTemplate: bad mapid 618! Map doesn't exist or is not
--       a battleground/arena!                                   <- fila de `battleground_scripts`
--   Battleground ID 11 could not be found in BattlemasterList.dbc. The battleground was not
--       created.                                                <- fila de `battleground_template`
--
-- Son la misma cosa: el BG 11 (Ring of Valor) vive en el mapa 618, y ese mapa no está en los datos
-- del cliente (ni en Map.db2 como campo de batalla). La fila no se puede jugar nunca, así que se
-- retira en vez de dejarla tirando un error en cada arranque.
--
-- Migración nuestra (no viene de la TDB): va en `world` porque las dos tablas son de la world DB.
-- Idempotente: borrar filas que ya no están no hace nada.

DELETE FROM `battleground_scripts` WHERE `MapId` = 618;

DELETE FROM `battleground_template` WHERE `id` = 11;
