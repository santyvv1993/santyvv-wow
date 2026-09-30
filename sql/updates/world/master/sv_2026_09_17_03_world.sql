-- ============================================================================
--  El receptaculo de piedras del Priorato de la Llama Sagrada (2649)
-- ============================================================================
-- SALIO DEL FLUJO DE HABILITACION (herramientas/diagnostico/habilitacion-estancias.py): de las 8
-- estancias de la temporada, 6 estaban completas y el Priorato era la unica con el receptaculo
-- faltante. Al escribir la migracion 22 se lo dejo afuera a proposito, con este motivo:
--
--     "El **Priorato (2649)** queda sin pedestal: no tiene ni portal ni piedra de encuentro en su
--      mapa, y no se inventa una posicion (mismo dato que le falta a su cementerio y a su puerta)."
--
-- Ese motivo YA NO ES CIERTO: la posicion de entrada del Priorato esta medida desde la migracion 24
-- (el trigger del servidor que hace entrar caminando), es el punto seguro 9000004 - (2851.6, 1200.3,
-- 515.2) - que ya usa el cementerio de la estancia (migracion 20) y que se verifico contra el navmesh
-- (piso a -0.27 yd, medido). O sea: no es una posicion inventada, es la entrada misma, y es el mismo
-- criterio con el que se pusieron los otros seis pedestales ("la misma que se resolvio para los
-- cementerios: la entrada del calabozo, que es donde retail pone el pedestal").
--
-- QUE ES: `GAMEOBJECT_TYPE_KEYSTONE_RECEPTACLE` (tipo 49) "Font of Power" 246779 - el objeto con el
-- que el cliente arranca la mitica+ (es el que hace que el cliente mande CMSG_START_CHALLENGE_MODE).
--
-- DIFICULTAD: `23` (Mitica), igual que los otros seis y que el de Atal'Dazar, que es el unico probado
-- en vivo. La TDB usa en 2649 el conjunto `1,2,8,23`, asi que la 23 es valida para el mapa.
--
-- GUID: 11802007, el siguiente libre del rango propio del proyecto (los otros seis son 11802001-06
-- y la migracion 22 dejo libre 11802007-11802010).
--
-- CARGA: los spawns de gameobject se leen al arrancar el mundo -> entra en el proximo reinicio.
-- Verificacion: `Loaded N gameobjects` sube en 1 y no aparece ninguna linea nueva en DBErrors.log.
-- ============================================================================

DELETE FROM `gameobject` WHERE `guid` = 11802007;

INSERT INTO `gameobject`
    (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`, `phaseUseFlags`, `PhaseId`, `PhaseGroup`,
     `terrainSwapMap`, `position_x`, `position_y`, `position_z`, `orientation`,
     `rotation0`, `rotation1`, `rotation2`, `rotation3`,
     `spawntimesecs`, `animprogress`, `state`, `ScriptName`, `StringId`, `VerifiedBuild`)
VALUES
 (11802007, 246779, 2649, 14954, 14954, '23', 0, 0, 0, -1, 2851.6, 1200.3, 515.2, 0, 0, 0, 0, 1, 7200, 255, 1, '', NULL, 0);
