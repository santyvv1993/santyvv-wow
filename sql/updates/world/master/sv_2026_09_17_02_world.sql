-- ============================================================================
--  Piedra de invocacion del hall de entrada de los 8 calabozos de la temporada
-- ============================================================================
--  QUE SE MIDIO (17-sep-2026), antes de tocar nada:
--   * De los 8 calabozos de la temporada, SOLO Ciudad de los Hilos (2669) tenia
--     piedra de invocacion. Los otros siete no tienen NINGUNA piedra (GO tipo 23)
--     en todo el mapa: ni adentro ni cerca de la puerta en el mapa del mundo.
--     (En 1220 Azsuna y 1642 Zuldazar, que son los afuera de Ojo de Azshara,
--     Atal'Dazar y Reposo de los Reyes, la TDB no tiene ninguna piedra tipo 23.)
--   * Las ENTRADAS si estaban todas activas: 4 nuestras en 2601 (migracion 24) y
--     4 de la TDB (1220 -> 1456 safe loc 5100, 1642 -> 1763 en 100054 y 1762 en
--     100056, 2444 -> 2521 en 100030). Los 8 destinos pisan malla de navegacion
--     (delta -0.44 / -0.23 / -0.21 / -0.27 / -0.27 / +0.00 / +0.13 / +2.00 yd).
--
--  COMO FUNCIONA LA PIEDRA EN ESTE CORE (GameObject::Use, case tipo 23):
--     se usa con un MIEMBRO DEL MISMO GRUPO APUNTADO y lanza el hechizo 59782
--     (Summoning Stone Effect). Antes chequea el nivel contra el ContentTuningId
--     de la PLANTILLA: si el nivel del jugador es menor que el MaxLevel del tuning,
--     no hace nada (ni error). Ojo con eso al elegir la plantilla: las piedras de
--     expansiones viejas quedan MUERTAS a nivel tope (una de BfA, tuning 1241,
--     tiene MaxLevel 120 y un personaje 90 no la puede usar).
--
--  PLANTILLA ELEGIDA: 453606 "Meeting Stone" (ContentTuningId 2974 = MinLevel 70 /
--     MaxLevel 80) -> es la que la propia TDB puso en Ciudad de los Hilos y funciona
--     a nivel 90 (90 < 80 es falso, no la bloquea). Se usa la misma para los 8, asi
--     que el gate de nivel queda identico en todas.
--
--  POSICION: en el hall de entrada, al lado del punto donde la entrada deja al
--     jugador (3 yd al este, que es donde hay piso en los 7 casos). Se eligio con el
--     navmesh (herramientas/diagnostico/puntos-salida.py): piso a <=1.2 yd del punto
--     elegido y a 3 yd de la llegada, para que el jugador no caiga ADENTRO del modelo
--     de la piedra (que tiene colision) y la vea al llegar.
--     Ciudad de los Hilos ya la tiene (guid 10000884); no se toca.
--
--  guids 9900001-9900007 (rango libre verificado: el mayor guid de gameobject hoy es
--  11802006, y 9800011-9800017 / 9800901-9800907 ya estan usados por calabazas).
--
--  DIFICULTADES: NO son las mismas en todos los mapas. Reposo de los Reyes (1762) NO
--  admite la dificultad 1 (el core lo dice: "has unsupported difficulty 1 for map (Id:
--  1762)"), y en 1456 la TDB agrega la 24 y en 2660 la 205. Se usa en cada mapa el
--  conjunto que la propia TDB usa ahi (medido: el mas comun entre sus spawns).
-- ============================================================================

DELETE FROM `gameobject` WHERE `guid` BETWEEN 9900001 AND 9900007;
INSERT INTO `gameobject` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`, `phaseUseFlags`, `PhaseId`, `PhaseGroup`, `terrainSwapMap`,
                          `position_x`, `position_y`, `position_z`, `orientation`, `rotation0`, `rotation1`, `rotation2`, `rotation3`,
                          `spawntimesecs`, `animprogress`, `state`, `ScriptName`, `StringId`, `VerifiedBuild`)
VALUES
(9900001, 453606, 1456, 8040, 8083, '1,2,8,23,24', 0, 0, 0, -1, -3911.3, 4540.6, 86.75, 0, 0, 0, 0, 1, 7200, 255, 1, '', NULL, 0),
(9900002, 453606, 1762, 9526, 9526, '2,8,23', 0, 0, 0, -1,  -942.1, 2544.2, 833.51, 0, 0, 0, 0, 1, 7200, 255, 1, '', NULL, 0),
(9900003, 453606, 1763, 9028, 9028, '1,2,23,8', 0, 0, 0, -1,  -845.4, 2082.5, 725.53, 0, 0, 0, 0, 1, 7200, 255, 1, '', NULL, 0),
(9900004, 453606, 2521, 14063, 14448, '1,2,8,23', 0, 0, 0, -1, 1389.2, -169.7, 131.00, 0, 0, 0, 0, 1, 7200, 255, 1, '', NULL, 0),
(9900005, 453606, 2649, 14954, 15460, '1,2,8,23', 0, 0, 0, -1, 2854.6, 1200.3, 515.62, 0, 0, 0, 0, 1, 7200, 255, 1, '', NULL, 0),
(9900006, 453606, 2651, 14882, 15019, '1,2,8,23', 0, 0, 0, -1,  242.8, 75.9, 92.44, 0, 0, 0, 0, 1, 7200, 255, 1, '', NULL, 0),
(9900007, 453606, 2660, 15093, 15156, '1,2,8,23,205', 0, 0, 0, -1, -403.1, 259.0, 205.47, 0, 0, 0, 0, 1, 7200, 255, 1, '', NULL, 0);
