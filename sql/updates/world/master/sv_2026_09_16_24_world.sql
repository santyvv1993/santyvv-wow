-- =====================================================================
-- 2026_09_16_24_world.sql
-- Puertas de los 4 calabozos de The War Within de la temporada mitica.
-- =====================================================================
-- Origen: docs/investigacion/entradas-calabozos-tww.sql (informe:
-- docs/investigacion/entradas-calabozos-tww.md). Ya estaba aplicado a mano el
-- 16-sep-2026; se trae al repo para que un rebuild desde cero lo reproduzca y el
-- updater lo registre. Los INSERT van como INSERT IGNORE a proposito (re-ejecutar
-- es no-op) porque las filas ya estan aplicadas.
--
-- Mecanismo (verificado en el codigo por el agente padre): areatrigger DEL SERVIDOR
--   areatrigger_template            Id 910001..910004, Flags=1 (IsServerSide)
--   areatrigger_template_actions    ActionType=2 (TELEPORT) -> ActionParam = world_safe_locs.ID
--                                   (AreaTriggerDataStore.cpp:94 valida el punto seguro al cargar)
--   areatrigger_create_properties   Id 920001..920004, Shape=4 (cilindro) radio 6 / alto 40 / zOffset -20
--   areatrigger                     SpawnId 930001..930004 en el mapa 2601 (Khaz Algar)
-- Posiciones de las puertas: POI de mision del cliente (world.quest_poi / quest_poi_points).
-- Caveat: Khaz Algar tiene dos capas (2601 "Khaz Algar" y 2552 "superficie"); si al
-- caminar no dispara, hay que duplicar los 4 triggers en 2552.
-- =====================================================================

-- ============================================================================
-- Entradas de los calabozos modernos de la temporada (TWW): las 4 puertas
-- ============================================================================
-- PROPÓSITO: que un jugador entre CAMINANDO a Ciudad de los Hilos (2669),
-- Priorato de la Llama Sagrada (2649), Ara-Kara (2660) y Grieta Llama Oscura
-- (2651), sin `.go xyz`.
--
-- MECANISMO (medido en este core, ver docs/investigacion/entradas-calabozos-tww.md):
--   El cliente de este build NO avisa nada en esas puertas: su AreaTrigger.db2
--   (3.663 filas, 217 mapas, máximo mapa 2444) no tiene NI UN trigger en 2601,
--   2597 ni en los mapas de los calabozos, y world.areatrigger_teleport no tiene
--   ninguna fila que apunte a un mapa >= 2000. El camino clásico
--   (CMSG_AREA_TRIGGER -> HandleAreaTriggerOpcode -> areatrigger_teleport,
--   MiscHandler.cpp:479/489/597) no tiene nada que escuchar y queda descartado.
--   Lo que sí funciona -y usa la propia TDB para las puertas de BfA en Zuldazar-
--   es un AREATRIGGER DEL SERVIDOR: una fila en world.areatrigger (+ plantilla y
--   create_properties) que crea un objeto AreaTrigger en el mapa; el cliente no
--   lo ve (AreaTrigger::IsNeverVisibleFor, AreaTrigger.cpp:1772) y el servidor
--   detecta la entrada él mismo (AreaTrigger::Update -> UpdateTargetList ->
--   HandleUnitEnter -> DoActions, AreaTrigger.cpp:378/685/1010/1271). Con
--   ActionType = 2 (AREATRIGGER_ACTION_TELEPORT) la acción hace
--   player->TeleportTo(safeLoc->Loc) con el id de world_safe_locs que se le pase.
--
--   Ciclo de vida de una fila: no se toca el cliente, no se toca C++.
--
-- FAMILIA DE REFERENCIA (ya en la base, la copié tal cual):
--   areatrigger            SpawnId=82 CPId=68 MapId=1642 SpawnDifficulties=0
--                          (-848.366, 2044.26, 726.122) "8.x Dungeon - Atal Dazar - Entrance"
--   areatrigger_template        Id=81 IsCustom=1 Flags=1 (IsServerSide)
--   areatrigger_template_actions AreaTriggerId=81 ActionType=2 ActionParam=100054 TargetType=5
--   areatrigger_create_properties Id=68 AreaTriggerId=81 IsAreatriggerCustom=1 Shape=1 (Box 3x6)
--   world_safe_locs             ID=100054 MapID=1763 (-848.363, 2082.47, 725.146)
--
-- POR QUÉ CILINDRO (Shape=4) Y NO ESFERA/CAJA:
--   SearchUnitInSphere filtra en 3D (SearchUnits(..., true)); SearchUnitInCylinder
--   (AreaTrigger.cpp:862) filtra en 2D y después usa un G3D::Cylinder local, o sea
--   radio horizontal + banda vertical (height/zOffset). Con radio 6, alto 40 y
--   zOffset -20 el trigger cubre +/-20 yd en Z: absorbe el error de altura que
--   puedan tener las posiciones y el desnivel de la puerta sin poner dos triggers.
--
-- RESTRICCIONES DEL CARGADOR QUE HAY QUE CUMPLIR (o la fila se cae sin ruido):
--   * AreaTriggerDataStore::LoadAreaTriggerSpawns (AreaTriggerDataStore.cpp:398+):
--     el create_properties referenciado por un spawn debe tener Flags=0, todas las
--     curvas en 0, TimeToTargetScale=0 y ningún movimiento (spline/orbit).
--   * ObjectMgr::ParseSpawnDifficulties (ObjectMgr.cpp:2091): la dificultad del
--     spawn tiene que existir en MapDifficulty para ese mapa. Medido leyendo
--     MapDifficulty.db2 del cliente con herramientas/db2.py: mapa 2601 -> [0]
--     (por eso '0', igual que las filas de BfA en 1642 -> [0]). Los mapas de los
--     calabozos ya traen [1, 2, 8, 23, 205] (+216 en 2649): no hay que agregar nada
--     para que la instancia se cree en Normal, Mítica o Mítica+.
--   * areatrigger_template_actions con ActionType=2 valida que ActionParam exista
--     en world_safe_locs AL CARGAR -> primero el punto, después la acción.
--
-- POSICIONES (fuente y error, ver el informe):
--   PUERTAS (mapa del mundo 2601): POI de misión del cliente en la TDB
--   (world.quest_poi_points), con TRES copias independientes por calabozo
--   (las semanales "Worldsoul: <calabozo>" + la misión de calabozo):
--     2649 (2222,953,218) (2211,966,218) (2213,959,218) (2202,973,0) (2212,969,0) (2210,971,0) -> +-9 yd
--     2651 (2799,-3651,371) (2793,-3655,371) (2805,-3652,371) (2803,-3656,0)                 -> +-5 yd
--     2660 (-2151,-940,-1349) (-2151,-940,-1349) (-2148,-940,-1349)                           -> +-2 yd
--     2669 (-1624,-745,-1333) (-1621,-753,-1333) (-1621,-757,-1333)                           -> +-6 yd
--     El contraste con la wiki (warcraft.wiki.gg, "Getting there") queda a 75-200 yd
--     porque la wiki publica el ÁREA, no la puerta; se comprobó que el resto es de la
--     fuente calibrando el mapa contra 19 NPC del 2601 (afín, error mediano 3,5 yd en
--     Hallowfall y 1,5 yd en Azj-Kahet). Para Ciudad de los Hilos hay además una
--     confirmación independiente: la piedra de encuentro del propio mapa está a 6 yd.
--   LLEGADA (mapas de los calabozos): gameobject "Instance Portal" / "Meeting Stone"
--     del mapa (ya usado por la migración 20 de cementerios) salvo el Priorato, que no
--     tiene ninguno de los dos: se usa el GO `Bench` del patio de entrada, que es el
--     MISMO punto que el cementerio de Blizzard "Hallowfall - Priory of the Sacred Flame
--     - GY" (2852.36, 1194.05, 515.206 -> 6 yd). Incertidumbre +-60 yd: PENDIENTE DE
--     CONFIRMAR EN VIVO con `.go xyz 2851.6 1200.3 515.2 2649`.
--
-- IDS: 910001-910004 (areatrigger_template), 920001-920004 (create_properties),
--   930001-930004 (spawns) y 9000004 (world_safe_locs) están libres HOY
--   (máximos actuales: template 41022, create_properties 39560, spawn 292,
--   safe locs 9000003).
--
-- NO APLICADO: esta migración se entrega sin correr (consigna). Verificación
--   al final del archivo.
-- VALIDADO (estático, sin tocar la base viva): los 6 INSERT tienen nombres de
--   columna que existen en el esquema vivo y la misma cantidad de valores por
--   fila que columnas (1, 1, 4, 4, 4 y 4 filas), y todos los ids usados están
--   libres hoy (910001-4, 920001-4, 930001-4, 9000004: 0 filas).
-- ============================================================================


-- ----------------------------------------------------------------------------
-- 1. El punto de llegada que falta: entrada interna del Priorato (mapa 2649)
-- ----------------------------------------------------------------------------
-- Las otras tres ya existen (9000001 Grieta Llama Oscura, 9000002 Ara-Kara,
-- 9000003 Ciudad de los Hilos), puestas por 2026_09_16_20_world.sql.
INSERT IGNORE INTO `world_safe_locs`
    (`ID`, `MapID`, `LocX`, `LocY`, `LocZ`, `Facing`, `TransportSpawnId`, `Comment`) VALUES
    (9000004, 2649, 2851.6, 1200.3, 515.2, 0, NULL,
     'Priorato de la Llama Sagrada - entrada (GO Bench del patio; +-60 yd, confirmar en vivo)')
ON DUPLICATE KEY UPDATE `Comment` = VALUES(`Comment`);

-- El cementerio del Priorato: sin esto, morir adentro devuelve al cementerio por
-- defecto del mundo (el core avisa "Table graveyard_zone incomplete: Zone 14954 ...").
-- 14954 = zona del mapa 2649, medida en world.creature.zoneId (misma migración 19/20).
INSERT IGNORE INTO `graveyard_zone` (`ID`, `GhostZone`, `Comment`) VALUES
    (9000004, 14954, 'Priorato de la Llama Sagrada - entrada (config del proyecto)')
ON DUPLICATE KEY UPDATE `Comment` = VALUES(`Comment`);


-- ----------------------------------------------------------------------------
-- 2. Plantillas de los triggers de entrada (una por calabozo)
-- ----------------------------------------------------------------------------
-- Flags = 1 -> AreaTriggerFlag::IsServerSide (AreaTrigger.h:111): el trigger vive
-- sólo del lado del servidor y NO se le manda al cliente (IsNeverVisibleFor).
INSERT IGNORE INTO `areatrigger_template`
    (`Id`, `IsCustom`, `Flags`, `ActionSetId`, `ActionSetFlags`, `VerifiedBuild`) VALUES
    (910001, 1, 1, 0, 0, 0),   -- 2649 Priorato
    (910002, 1, 1, 0, 0, 0),   -- 2651 Grieta Llama Oscura
    (910003, 1, 1, 0, 0, 0),   -- 2660 Ara-Kara
    (910004, 1, 1, 0, 0, 0)    -- 2669 Ciudad de los Hilos
ON DUPLICATE KEY UPDATE `Flags` = VALUES(`Flags`);


-- ----------------------------------------------------------------------------
-- 3. La acción: TELEPORT (ActionType=2) al punto de llegada dentro del calabozo
-- ----------------------------------------------------------------------------
-- ActionParam = world_safe_locs.ID. TargetType=5 = AREATRIGGER_ACTION_USER_CASTER
-- (para un spawn estático ni se evalúa: DoActions usa caster = unit).
INSERT IGNORE INTO `areatrigger_template_actions`
    (`AreaTriggerId`, `IsCustom`, `ActionType`, `ActionParam`, `TargetType`) VALUES
    (910001, 1, 2, 9000004, 5),   -- 2649 -> Priorato (punto nuevo)
    (910002, 1, 2, 9000001, 5),   -- 2651 -> Grieta Llama Oscura
    (910003, 1, 2, 9000002, 5),   -- 2660 -> Ara-Kara
    (910004, 1, 2, 9000003, 5)    -- 2669 -> Ciudad de los Hilos
ON DUPLICATE KEY UPDATE
    `ActionType` = VALUES(`ActionType`), `ActionParam` = VALUES(`ActionParam`),
    `TargetType` = VALUES(`TargetType`);


-- ----------------------------------------------------------------------------
-- 4. Forma de cada trigger: cilindro radio 6, alto 40, zOffset -20 (cubre +/-20 yd en Z)
-- ----------------------------------------------------------------------------
-- Shape=4 (AreaTriggerShapeType::Cylinder, DBCEnums.h:195).
-- ShapeData0/1 = radio (actual/objetivo), 2/3 = alto, 4/5 = desplazamiento en Z.
-- Todo lo demás en 0 / -1 porque el cargador de spawns los exige en cero.
INSERT IGNORE INTO `areatrigger_create_properties`
    (`Id`, `IsCustom`, `AreaTriggerId`, `IsAreatriggerCustom`, `Flags`,
     `MoveCurveId`, `ScaleCurveId`, `MorphCurveId`, `FacingCurveId`, `AnimId`, `AnimKitId`,
     `DecalPropertiesId`, `SpellForVisuals`, `PositionalSoundKitId`, `TimeToTargetScale`,
     `Speed`, `SpeedIsTime`, `Shape`,
     `ShapeData0`, `ShapeData1`, `ShapeData2`, `ShapeData3`, `ShapeData4`, `ShapeData5`,
     `ShapeData6`, `ShapeData7`, `ScriptName`, `VerifiedBuild`) VALUES
    (920001, 1, 910001, 1, 0, 0, 0, 0, 0, -1, 0, 0, NULL, 0, 0, 1, 0, 4, 6, 6, 40, 40, -20, -20, 0, 0, '', 0),
    (920002, 1, 910002, 1, 0, 0, 0, 0, 0, -1, 0, 0, NULL, 0, 0, 1, 0, 4, 6, 6, 40, 40, -20, -20, 0, 0, '', 0),
    (920003, 1, 910003, 1, 0, 0, 0, 0, 0, -1, 0, 0, NULL, 0, 0, 1, 0, 4, 6, 6, 40, 40, -20, -20, 0, 0, '', 0),
    (920004, 1, 910004, 1, 0, 0, 0, 0, 0, -1, 0, 0, NULL, 0, 0, 1, 0, 4, 6, 6, 40, 40, -20, -20, 0, 0, '', 0)
ON DUPLICATE KEY UPDATE `Shape` = VALUES(`Shape`);


-- ----------------------------------------------------------------------------
-- 5. Los spawns: uno por puerta, en el mapa del mundo (2601 Khaz Algar)
-- ----------------------------------------------------------------------------
-- SpawnDifficulties = '0' porque el mapa 2601 sólo tiene la dificultad 0 en
-- MapDifficulty (igual que las puertas de BfA en 1642). Cualquier otro valor lo
-- rechaza el cargador con "has unsupported difficulty N for map (Id: 2601)".
-- Orientation no influye: el cilindro es simétrico respecto de su eje Z.
INSERT IGNORE INTO `areatrigger`
    (`SpawnId`, `AreaTriggerCreatePropertiesId`, `IsCustom`, `MapId`, `SpawnDifficulties`,
     `PosX`, `PosY`, `PosZ`, `Orientation`, `PhaseUseFlags`, `PhaseId`, `PhaseGroup`,
     `ScriptName`, `Comment`, `VerifiedBuild`) VALUES
    (930001, 920001, 1, 2601, '0', 2213.0,  961.0,   218.0, 0, 0, 0, 0, '',
     'TWW 11.x Dungeon - Priory of the Sacred Flame (2649) - Entrance', 0),
    (930002, 920002, 1, 2601, '0', 2799.0, -3653.0,  371.0, 0, 0, 0, 0, '',
     'TWW 11.x Dungeon - Darkflame Cleft (2651) - Entrance', 0),
    (930003, 920003, 1, 2601, '0', -2150.0, -940.0, -1349.0, 0, 0, 0, 0, '',
     'TWW 11.x Dungeon - Ara-Kara, City of Echoes (2660) - Entrance', 0),
    (930004, 920004, 1, 2601, '0', -1622.0, -752.0, -1333.0, 0, 0, 0, 0, '',
     'TWW 11.x Dungeon - City of Threads (2669) - Entrance', 0)
ON DUPLICATE KEY UPDATE
    `PosX` = VALUES(`PosX`), `PosY` = VALUES(`PosY`), `PosZ` = VALUES(`PosZ`),
    `SpawnDifficulties` = VALUES(`SpawnDifficulties`), `Comment` = VALUES(`Comment`);


-- ============================================================================
-- VERIFICACIÓN (a ojo, antes y después de arrancar el mundo)
-- ============================================================================
-- a) Las 4 puertas quedan armadas y completas (debe dar 4 filas, todas con 'OK'):
--   SELECT a.SpawnId, a.MapId, a.PosX, a.PosY, a.PosZ, t.Flags, cp.Shape,
--          cp.ShapeData0, cp.ShapeData2, cp.ShapeData4, ta.ActionType, ta.ActionParam,
--          sl.MapID AS mapa_destino, sl.LocX, sl.LocY, sl.LocZ,
--          CASE WHEN t.Flags = 1 AND cp.Shape = 4 AND ta.ActionType = 2
--                    AND sl.ID IS NOT NULL THEN 'OK'
               -- ELSE 'REVISAR' END AS estado
--   FROM world.areatrigger a
--   JOIN world.areatrigger_create_properties cp ON cp.Id = a.AreaTriggerCreatePropertiesId AND cp.IsCustom = a.IsCustom
--   JOIN world.areatrigger_template t ON t.Id = cp.AreaTriggerId AND t.IsCustom = cp.IsAreatriggerCustom
--   JOIN world.areatrigger_template_actions ta ON ta.AreaTriggerId = t.Id AND ta.IsCustom = t.IsCustom
--   LEFT JOIN world.world_safe_locs sl ON sl.ID = ta.ActionParam
--   WHERE a.SpawnId BETWEEN 930001 AND 930004;
--
-- b) Después de arrancar el mundo, el log NO debe traer ninguna de estas familias
--    (sql.sql): "Table `areatrigger` has areatrigger (GUID: 93000N) that is not
--    spawned in any difficulty", "... has unsupported difficulty", "references
--    invalid AreaTrigger ...", "has listed AreaTriggerCreatePropertiesId ... with
--    non - zero flags/curve values/time to target values", "has invalid entry for
--    AreaTriggerId ... not a valid world safe loc entry".
--    Y en Server.log debe aparecer el contador de siempre:
--    ">> Loaded N areatrigger spawns in N ms" con N = 291 (el de hoy) + 4.
--
-- c) En vivo: pararse en la puerta (por ejemplo `.go xyz 2213 961 218 2601` en
--    Mereldar) y caminar hacia adentro: tiene que fundir y aparecer dentro del
--    calabozo. Si no dispara, mover la fila de `world.areatrigger` (la X/Y es lo
--    único fino: el cilindro ya tolera +/-20 yd en Z).
--
-- d) Cementerio: morir dentro del Priorato debe devolver a 9000004 y no al
--    cementerio por defecto del mundo.
-- ============================================================================
