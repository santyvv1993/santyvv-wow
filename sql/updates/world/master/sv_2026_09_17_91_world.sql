-- ============================================================================
--  Salida de los 4 calabozos de TWW de la temporada
--  (+ los puntos de llegada corregidos y el punto de salida del guia)
-- ============================================================================
--  ESTADO MEDIDO ANTES DE TOCAR NADA (17-sep-2026):
--   * Los cuatro calabozos viejos de la temporada YA tienen su trigger de salida
--     en la TDB (server-side, accion TELEPORT), con destino afuera:
--       1456 Ojo de Azshara -> safe loc 5114  (mapa 1220)
--       1762 Reposo de los Reyes -> 100057    (mapa 1642)
--       1763 Atal'Dazar -> 100055             (mapa 1642)
--       2521 Estanques de Vida Rubi -> 100031 (mapa 2444)
--     Funcionan con lo que hay: NO se tocan.
--   * Los cuatro de TWW (2649, 2651, 2660, 2669) no tienen NINGUN trigger de salida
--     (los unicos triggers dentro de esos mapas son de encuentro y de conversacion).
--     Se les agrega con el MISMO mecanismo de la entrada (migracion 24) y con la
--     geometria del par que la propia TDB usa en El Corvento (2648):
--         entrada 2552 (2800.1, -2190.2, 266.8) / destino de salida 100066 (2800.1, -2215.1)
--     = 25 yd entre los dos.
--
--  POR QUE DOS POSICIONES SEPARADAS Y NO UNA:
--    el trigger se dispara por PROXIMIDAD (cilindro de radio 6). Si el destino de la
--    salida cae dentro del trigger de ENTRADA, el jugador sale y vuelve a entrar en
--    bucle; y si el trigger de salida queda donde la entrada deja al jugador, el que
--    acaba de entrar lo pisa y lo devuelven afuera al instante. De ahi los dos
--    minimos: destino a >=25 yd de la puerta, trigger a >=13 yd de la llegada.
--
--  POSICIONES ELEGIDAS CON EL NAVMESH, no a ojo (herramientas/diagnostico/puntos-salida.py
--  y grilla-navmesh.py): piso a 1.5 yd o menos, entorno con piso (que no sea un islote)
--  y las distancias minimas de arriba.
--
--  ADEMAS, dos puntos de llegada que la medicion dejo mal:
--    * 9000002 (Ara-Kara): quedaba 4.1 yd SOBRE el piso -> baja a 205.4 (piso medido 205.27).
--    * 9000003 (Ciudad de los Hilos): el punto caia FUERA de la malla del calabozo (los
--      poligonos mas cercanos en planta estan a -388 y -333, o sea la superficie; el
--      calabozo esta a -1337) -> se mueve 8 yd al norte, al piso medido (-1337.2).
--
--  Y `mitica_estancia.salida_punto`: hoy solo lo tenia Atal'Dazar, asi que el guia de la
--  expedicion (900244) respondia "esta estancia no tiene punto de salida configurado" en
--  las otras siete. Se llena para las ocho, con el destino de la TDB donde ya existe y
--  con los puntos nuevos de esta migracion donde no.
--
--  Entra en efecto: los triggers y las posiciones al arrancar el mundo (los spawns de
--  areatrigger se cargan al inicio: `Loaded N areatrigger spawns`), y `salida_punto` con
--  `.reload` del modulo de miticas o al reiniciar.
-- ============================================================================

-- ---------------------------------------------------------------------------
-- 1) Los dos puntos de llegada corregidos
-- ---------------------------------------------------------------------------
UPDATE `world_safe_locs` SET `LocZ` = 205.4                       WHERE `ID` = 9000002;
UPDATE `world_safe_locs` SET `LocY` = -746.2, `LocZ` = -1337.2    WHERE `ID` = 9000003;

-- ---------------------------------------------------------------------------
-- 2) Los destinos de salida (afuera, en el mapa del mundo 2601)
--    Distancias a la puerta de cada calabozo: 37 / 36 / 29 / 30 yd.
-- ---------------------------------------------------------------------------
DELETE FROM `world_safe_locs` WHERE `ID` BETWEEN 9000011 AND 9000014;
INSERT INTO `world_safe_locs` (`ID`, `MapID`, `LocX`, `LocY`, `LocZ`, `Facing`, `TransportSpawnId`, `Comment`) VALUES
(9000011, 2601,  2221.0,   997.0,  218.0,    0, NULL, 'TWW - Priorato de la Llama Sagrada (2649) - salida (37 yd de la puerta)'),
(9000012, 2601,  2803.0, -3617.0,  371.0,    0, NULL, 'TWW - Grieta Llama Oscura (2651) - salida (36 yd de la puerta)'),
(9000013, 2601, -2166.0,  -916.0, -1349.0,   0, NULL, 'TWW - Ara-Kara (2660) - salida (29 yd de la puerta)'),
(9000014, 2601, -1650.0,  -740.0, -1332.9,   0, NULL, 'TWW - Ciudad de los Hilos (2669) - salida (30 yd de la puerta)');

-- ---------------------------------------------------------------------------
-- 3) Las plantillas (IsCustom=1, Flags=1 = IsServerSide: el cliente no las ve)
--    y su accion de teletransporte (ActionType=2) al punto seguro de arriba.
-- ---------------------------------------------------------------------------
DELETE FROM `areatrigger_template_actions` WHERE `AreaTriggerId` BETWEEN 910005 AND 910008;
DELETE FROM `areatrigger_template`         WHERE `Id`             BETWEEN 910005 AND 910008;

INSERT INTO `areatrigger_template` (`Id`, `IsCustom`, `Flags`, `ActionSetId`, `ActionSetFlags`, `VerifiedBuild`) VALUES
(910005, 1, 1, 0, 0, 0),
(910006, 1, 1, 0, 0, 0),
(910007, 1, 1, 0, 0, 0),
(910008, 1, 1, 0, 0, 0);

INSERT INTO `areatrigger_template_actions` (`AreaTriggerId`, `IsCustom`, `ActionType`, `ActionParam`, `TargetType`) VALUES
(910005, 1, 2, 9000011, 5),
(910006, 1, 2, 9000012, 5),
(910007, 1, 2, 9000013, 5),
(910008, 1, 2, 9000014, 5);

-- ---------------------------------------------------------------------------
-- 4) Las formas, identicas a las nuestras de la entrada (920001): cilindro Shape=4,
--    radio 6 / alto 40 / zOffset -20 (cubre +/-20 yd en Z). Sin curvas, sin
--    movimiento y TimeToTargetScale=0: lo que exige AreaTriggerDataStore al cargar.
-- ---------------------------------------------------------------------------
DELETE FROM `areatrigger_create_properties` WHERE `Id` BETWEEN 920005 AND 920008;

INSERT INTO `areatrigger_create_properties`
(`Id`, `IsCustom`, `AreaTriggerId`, `IsAreatriggerCustom`, `Flags`, `MoveCurveId`, `ScaleCurveId`,
 `MorphCurveId`, `FacingCurveId`, `AnimId`, `AnimKitId`, `DecalPropertiesId`, `SpellForVisuals`,
 `PositionalSoundKitId`, `TimeToTargetScale`, `Speed`, `SpeedIsTime`, `Shape`,
 `ShapeData0`, `ShapeData1`, `ShapeData2`, `ShapeData3`, `ShapeData4`, `ShapeData5`, `ShapeData6`, `ShapeData7`,
 `Roll`, `Pitch`, `Yaw`, `TargetRoll`, `TargetPitch`, `TargetYaw`, `ScriptName`, `VerifiedBuild`) VALUES
(920005, 1, 910005, 1, 0, 0, 0, 0, 0, -1, 0, 0, NULL, 0, 0, 1, 0, 4,  6,  6, 40, 40, -20, -20, 0, 0, 0, 0, 0, NULL, NULL, NULL, '', 0),
(920006, 1, 910006, 1, 0, 0, 0, 0, 0, -1, 0, 0, NULL, 0, 0, 1, 0, 4,  6,  6, 40, 40, -20, -20, 0, 0, 0, 0, 0, NULL, NULL, NULL, '', 0),
(920007, 1, 910007, 1, 0, 0, 0, 0, 0, -1, 0, 0, NULL, 0, 0, 1, 0, 4,  6,  6, 40, 40, -20, -20, 0, 0, 0, 0, 0, NULL, NULL, NULL, '', 0),
(920008, 1, 910008, 1, 0, 0, 0, 0, 0, -1, 0, 0, NULL, 0, 0, 1, 0, 4,  6,  6, 40, 40, -20, -20, 0, 0, 0, 0, 0, NULL, NULL, NULL, '', 0);

-- ---------------------------------------------------------------------------
-- 5) Los triggers DENTRO de cada calabozo, a >=13 yd de donde la entrada deja al
--    jugador (distancias: 19 / 13 / 27 / 16 yd) y con dificultades '1,2,8,23', la
--    misma lista que usan los triggers de la TDB en esos mapas (2651, 2669).
-- ---------------------------------------------------------------------------
DELETE FROM `areatrigger` WHERE `SpawnId` BETWEEN 930005 AND 930008;

INSERT INTO `areatrigger`
(`SpawnId`, `AreaTriggerCreatePropertiesId`, `IsCustom`, `MapId`, `SpawnDifficulties`,
 `PosX`, `PosY`, `PosZ`, `Orientation`, `PhaseUseFlags`, `PhaseId`, `PhaseGroup`, `ScriptName`, `Comment`, `VerifiedBuild`) VALUES
(930005, 920005, 1, 2649, '1,2,8,23',  2857.6,  1218.3,  515.26, 0, 0, 0, 0, '', 'TWW 11.x Dungeon - Priory of the Sacred Flame (2649) - Exit', 0),
(930006, 920006, 1, 2651, '1,2,8,23',   231.8,    85.9,   95.89, 0, 0, 0, 0, '', 'TWW 11.x Dungeon - Darkflame Cleft (2651) - Exit', 0),
(930007, 920007, 1, 2660, '1,2,8,23',  -398.1,   285.0,  205.41, 0, 0, 0, 0, '', 'TWW 11.x Dungeon - Ara-Kara, City of Echoes (2660) - Exit', 0),
(930008, 920008, 1, 2669, '1,2,8,23', -1618.4,  -730.2, -1337.2,  0, 0, 0, 0, '', 'TWW 11.x Dungeon - City of Threads (2669) - Exit', 0);

-- ---------------------------------------------------------------------------
-- 6) El punto de salida de las 8 estancias (lo usa el guia de la expedicion)
--    Formato: 'mapa x y z orientacion' (MythicPlusMgr::PuntoDeSalida, sscanf de 5).
-- ---------------------------------------------------------------------------
UPDATE `mitica_estancia` SET `salida_npc` = 900244, `salida_punto` = '1642 -848.42 2028.05 726.19 0'   WHERE `cm_id` = 244;  -- Atal'Dazar (ya estaba: se reafirma)
UPDATE `mitica_estancia` SET `salida_npc` = 900244, `salida_punto` = '1220 0.8 5783 4.2 0'            WHERE `cm_id` = 197;  -- Ojo de Azshara (destino de la TDB 5114)
UPDATE `mitica_estancia` SET `salida_npc` = 900244, `salida_punto` = '1642 -848.2 2515.9 730.2 0'      WHERE `cm_id` = 249;  -- Reposo de los Reyes (TDB 100057)
UPDATE `mitica_estancia` SET `salida_npc` = 900244, `salida_punto` = '2444 1341.3 -132.2 137.4 0'      WHERE `cm_id` = 399;  -- Estanques de Vida Rubi (TDB 100031)
UPDATE `mitica_estancia` SET `salida_npc` = 900244, `salida_punto` = '2601 2221 997 218 0'            WHERE `cm_id` = 499;  -- Priorato (nuevo)
UPDATE `mitica_estancia` SET `salida_npc` = 900244, `salida_punto` = '2601 -1650 -740 -1332.9 0'      WHERE `cm_id` = 502;  -- Ciudad de los Hilos (nuevo)
UPDATE `mitica_estancia` SET `salida_npc` = 900244, `salida_punto` = '2601 -2166 -916 -1349 0'        WHERE `cm_id` = 503;  -- Ara-Kara (nuevo)
UPDATE `mitica_estancia` SET `salida_npc` = 900244, `salida_punto` = '2601 2803 -3617 371 0'          WHERE `cm_id` = 504;  -- Grieta Llama Oscura (nuevo)

-- ============================================================================
--  LO QUE FALTA (prueba en vivo, T36)
--    Entrar al Priorato caminando desde la puerta del 2601 (o `.go xyz 2213 961 218 2601`)
--    y ver que (a) la entrada te deja en (2851.6, 1200.3, 515.2) sin caerte, y
--    (b) caminando ~19 yd hacia (2857.6, 1218.3) te saca afuera a (2221, 997, 218),
--    fuera del alcance del trigger de entrada (que esta a 37 yd). Repetir en las otras
--    tres. Si en alguna el jugador rebota, el ajuste es correr el destino de la salida.
-- ============================================================================
