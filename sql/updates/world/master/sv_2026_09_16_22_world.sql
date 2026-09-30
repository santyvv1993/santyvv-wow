-- ============================================================================
-- Miticas+ : el receptaculo de piedras en las estancias que no lo tenian
-- ============================================================================
-- POR QUE: para arrancar una mitica+ el cliente exige el flujo de la piedra en el receptaculo (GO tipo
-- 49, "Font of Power" 246779, `GAMEOBJECT_TYPE_KEYSTONE_RECEPTACLE`): es el objeto el que hace que el
-- cliente mande CMSG_START_CHALLENGE_MODE. Medido: de las 8 estancias de la temporada solo
-- **Atal'Dazar (1763)** tiene el receptaculo spawneado. Los otros cuatro spawns de la TDB son de
-- calabozos que no estan en la temporada (2515 Boveda Azur, 2526 Academia Algeth'ar, 2830 Ecodomo
-- Al'dani) mas el del kit de prueba en Villanorte (mapa 0). O sea que la temporada no se podia jugar
-- mas que en Atal'Dazar.
--
-- POSICION: la misma que ya se resolvio para los cementerios (la entrada del calabozo, que es donde
-- retail pone el pedestal), tomada de world_safe_locs o del marcador de entrada del propio mapa:
--     1456 Ojo de Azshara          (-3914.34, 4540.62, 86.5838)  safe loc 5100 "7.0 Naga Dungeon - Entrance Target"
--     1762 Reposo de los Reyes     (-945.114, 2544.25, 833.052)  safe loc 100056 "8.x Dungeon - KingsRest - Entrance"
--     2521 Estanques de Vida Rubi  (1386.2, -169.719, 131)       safe loc 100030 "10.x Dungeon - Ruby Life Pools - Entrance"
--     2651 Grieta Llama Oscura     (239.8, 75.9, 94.7)           portal de instancia del mapa
--     2660 Ara-Kara                (-406.1, 259, 209.5)          portal de instancia del mapa
--     2669 Ciudad de los Hilos     (-1618.4, -754.2, -1337.5)    piedra de encuentro del mapa (por confirmar)
--   El **Priorato (2649)** queda sin pedestal: no tiene ni portal ni piedra de encuentro en su mapa, y
--   no se inventa una posicion (mismo dato que le falta a su cementerio y a su puerta).
--
-- TRAMPA PAGADA (importante), en dos pasos:
--   1) El primer intento puso `spawnDifficulties = '0'` (que en otras tablas significa "todas las
--      dificultades") y **el core lo rechazo al cargar**:
--        Table `gameobject` has gameobject (GUID: 11802001) has unsupported difficulty 0 for map (Id: 1456).
--      En los mapas instanciados el valor tiene que ser una lista de dificultades que el mapa soporte.
--   2) El segundo intento copio la lista de la TDB en esos mapas (`1,2,8,23`) y **tambien fallo, pero
--      solo en Reposo de los Reyes**:
--        Table `gameobject` has gameobject (GUID: 11802002) has unsupported difficulty 1 for map (Id: 1762).
--      Porque `MapDifficulty` para ese mapa tiene **solo la 23** (`hotfixes.map_difficulty`: 1762 -> 23,
--      2521 -> 23): una sola dificultad invalida en la lista tira abajo la fila entera.
--   Valor final: **`23` (Mitica)** para los seis, igual que el de Atal'Dazar, que es el unico que estaba
--   probado en vivo. Es coherente con el uso: una mitica+ se juega en Mitica, y el personaje de prueba
--   tiene `dungeonDifficulty = 23`. Si algun dia se quiere el pedestal en mas dificultades, hay que
--   mirar antes que `MapDifficulty` tenga esas filas para el mapa.
--
-- GUID: 11802001-11802010, en el rango propio del proyecto (el maximo de la TDB es 11801046, el del kit
-- de prueba), sin chocar con ningun release futuro.
--
-- CARGA: los spawns de gameobject se leen al ARRANCAR el mundo, asi que esta migracion entra en el
-- proximo reinicio. Verificacion: `Loaded N gameobjects` tiene que subir en 6, y no puede quedar
-- ninguna linea `unsupported difficulty` en DBErrors.log.
-- ============================================================================

-- Idempotente: si ya existe, se reemplaza.
DELETE FROM `gameobject` WHERE `guid` BETWEEN 11802001 AND 11802010;

INSERT INTO `gameobject`
    (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`, `phaseUseFlags`, `PhaseId`, `PhaseGroup`,
     `terrainSwapMap`, `position_x`, `position_y`, `position_z`, `orientation`,
     `rotation0`, `rotation1`, `rotation2`, `rotation3`,
     `spawntimesecs`, `animprogress`, `state`, `ScriptName`, `StringId`, `VerifiedBuild`)
VALUES
 (11802001, 246779, 1456,  8040,  8040,  '23'      , 0, 0, 0, -1, -3914.34,  4540.62,   86.5838,  0, 0, 0, 0, 1, 7200, 255, 1, '', NULL, 0),
 (11802002, 246779, 1762,  9526,  9526,  '23'      , 0, 0, 0, -1,  -945.114, 2544.25,  833.052,  0, 0, 0, 0, 1, 7200, 255, 1, '', NULL, 0),
 (11802003, 246779, 2521, 14063, 14063,  '23'      , 0, 0, 0, -1,  1386.2,    -169.719, 131,      0, 0, 0, 0, 1, 7200, 255, 1, '', NULL, 0),
 (11802004, 246779, 2651, 14882, 14882,  '23'      , 0, 0, 0, -1,   239.8,      75.9,     94.7,    0, 0, 0, 0, 1, 7200, 255, 1, '', NULL, 0),
 (11802005, 246779, 2660, 15093, 15093,  '23'      , 0, 0, 0, -1,  -406.1,     259,      209.5,   0, 0, 0, 0, 1, 7200, 255, 1, '', NULL, 0),
 (11802006, 246779, 2669, 14979, 14979,  '23'      , 0, 0, 0, -1, -1618.4,    -754.2,  -1337.5,   0, 0, 0, 0, 1, 7200, 255, 1, '', NULL, 0);
