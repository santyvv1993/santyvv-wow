-- SV: corrige la dificultad de los 56 objetos que la captura del 26-sep sumo en el mapa 1762.
--
-- Que paso: el generador de spawns de OBJETOS escribia spawnDifficulties '0' cuando el mapa no
-- estaba en su lista a mano (`generar-spawns-objetos.py`). El mapa 1762 declara 2,8,23,24
-- (MapDifficulty.db2), asi que el cargador tiro cada fila con
--   `Table `gameobject` has gameobject (GUID: N) has unsupported difficulty 0 for map (Id: 1762).`
-- La perdida fue MUDA para el reporte de la migracion: los guids SI quedaron en la tabla (se
-- verificaron por guid contra la base) y el unico rastro esta en `logs/DBErrors.log`.
--
-- El generador ya lee el volcado del cliente (`datos/volcados/MapDifficulty.csv`) y OMITE la fila
-- cuando el mapa no declara ninguna dificultad (barrios e interiores de casa), en vez de escribir '0'.
-- Esta migracion corrige lo ya insertado: la banda 3323831266..3323831321 son exactamente los 56
-- objetos de ese mapa.

UPDATE `gameobject` SET `spawnDifficulties` = '2,8,23,24'
 WHERE `guid` BETWEEN 3323831266 AND 3323831321 AND `map` = 1762;
