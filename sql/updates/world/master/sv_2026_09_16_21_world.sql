-- ============================================================================
-- Miticas+: el jefe final de las ocho estancias (el cierre por jefes, completo)
-- ============================================================================
-- La migracion 18 dejo `mitica_estancia.jefe_final` como un solo INT y declaro unicamente Atal'Dazar
-- (Yazma, el unico dato con prueba en vivo). Aca se agregan las siete que faltaban y la columna pasa a
-- ser una LISTA de entries separados por espacio, porque hay encuentros finales de mas de una criatura
-- (Kyrakka y Erkhart en los Estanques de Vida Rubi, La Oscuridad en la Grieta Llama Oscura).
--
-- DE DONDE SALE CADA JEFE (no esta inventado)
--   El cliente trae el Diario de encuentros en `DungeonEncounter.db2`, con MapID y OrderIndex. Leyendolo
--   con herramientas/db2.py (el layout lo genera herramientas/db2-layouts.py de las cabeceras del core,
--   asi que esta tabla SI se puede leer; el bloqueo que se habia anotado era solo de WorldSafeLocs, y
--   resulto que esa informacion vive en MySQL, en world.world_safe_locs):
--       .venv/Scripts/python.exe herramientas/db2.py --tabla DungeonEncounter
--   Ordenando por OrderIndex con signo (int32), el ULTIMO es el jefe final, y asi sale en las ocho:
--       1456 Ojo de Azshara          -> Cólera de Azshara           (4000)
--       1763 Atal'Dazar              -> Yazma                      (3000)  <- el unico dato ya probado en vivo
--       1762 Reposo de los Reyes     -> Rey Dazar                  (2000)
--       2521 Estanques de Vida Rubi  -> Kyrakka y Erkhart          (1000)
--       2649 Priorato                -> Prioresa Catarrezo         (1000)
--       2669 Ciudad de los Hilos     -> Izo, la Gran Fusionadora   (1000)
--       2660 Ara-Kara                -> Ki'katal, la Cosechadora   (2000)
--       2651 Grieta Llama Oscura     -> La Oscuridad               (7000)
--   La regla se valido contra tres fuentes independientes, no solo contra si misma: la prueba en vivo
--   (Yazma cierra la corrida de Atal'Dazar), y las tapas de la wiki de Warcraft para los Estanques de
--   Vida Rubi ("End boss: Kyrakka and Erkhart Stormvein"), el Priorato ("End boss: Prioress Murrpray")
--   y la Ciudad de los Hilos ("End boss: Izo, the Grand Splicer"). En los cuatro casos el OrderIndex
--   mas alto coincide con el jefe final que declara la wiki.
--
-- A QUE CRIATURA CORRESPONDE (entries de creature_template, nombre de la TDB en ingles)
--     Cólera de Azshara = Wrath of Azshara 96028        Rey Dazar = King Dazar 136160
--     Kyrakka 199790 · Erkhart Stormvein 199791         Prioress Murrpray 207940
--     Izo, the Grand Splicer 216658                     Ki'katal the Harvester 215407
--     La Oscuridad = The Darkness 208747 y 210797
--
-- OJO: DOS DE LOS OCHO NO ESTAN SPAWNEADOS (deuda de datos, no de codigo). Medido contra world.creature:
--   - 96028 (Cólera de Azshara, mapa 1456): no hay ningun spawn.
--   - 208747 y 210797 (La Oscuridad, mapa 2651): tampoco.
--   - 199791 (Erkhart, mapa 2521): tampoco (el encuentro de Kyrakka quedo a medias en la TDB).
-- Se declaran igual (es el dato correcto) y el motor avisa en el log al arrancar la corrida que ese
-- jefe no esta vivo, en vez de dejar la corrida abierta sin explicacion. Cuando esos spawns existan,
-- el cierre por jefes empieza a funcionar sin tocar una linea de codigo. Las otras cinco estancias
-- (1762, 1763, 2521, 2649, 2660, 2669) ya cierran solas.
-- ============================================================================

ALTER TABLE `mitica_estancia`
    MODIFY COLUMN `jefe_final` VARCHAR(64) NOT NULL DEFAULT ''
    COMMENT 'entries del jefe que cierra la corrida, separados por espacio (vacio = regla general: ningun jefe vivo)';

UPDATE `mitica_estancia` SET `jefe_final` = '96028'           WHERE `cm_id` = 197;   -- Ojo de Azshara
UPDATE `mitica_estancia` SET `jefe_final` = '122968'          WHERE `cm_id` = 244;   -- Atal'Dazar (Yazma)
UPDATE `mitica_estancia` SET `jefe_final` = '136160'          WHERE `cm_id` = 249;   -- Reposo de los Reyes
UPDATE `mitica_estancia` SET `jefe_final` = '199790 199791'   WHERE `cm_id` = 399;   -- Estanques de Vida Rubi
UPDATE `mitica_estancia` SET `jefe_final` = '207940'          WHERE `cm_id` = 499;   -- Priorato de la Llama Sagrada
UPDATE `mitica_estancia` SET `jefe_final` = '216658'          WHERE `cm_id` = 502;   -- Ciudad de los Hilos
UPDATE `mitica_estancia` SET `jefe_final` = '215407'          WHERE `cm_id` = 503;   -- Ara-Kara
UPDATE `mitica_estancia` SET `jefe_final` = '208747 210797'   WHERE `cm_id` = 504;   -- Grieta Llama Oscura
