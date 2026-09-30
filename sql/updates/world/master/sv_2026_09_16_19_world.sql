-- ============================================================================
-- Cementerios de calabozo: morir adentro te devuelve a la ENTRADA
-- ============================================================================
-- El problema (visto en vivo el 16-sep): al morir dentro de Atal'Dazar el jugador fue al cementerio
-- de Paramos de Poniente, en el mundo abierto. No es un problema de instanciado: es que NINGUNA zona
-- de calabozo tenia cementerio asociado, asi que el core cae al cementerio por defecto
-- (ObjectMgr::GetClosestGraveyard -> GetDefaultGraveyard(team) y deja en el log
-- "Table `graveyard_zone` incomplete: Zone 9028 Team 469 does not have a linked graveyard.").
--
-- QUE HABIA Y QUE FALTABA
--   world_safe_locs YA trae la entrada de cuatro calabozos de la temporada (las pone la TDB):
--     1456 Ojo de Azshara          -> 5100    (-3914.34, 4540.62, 86.58)   "7.0 Naga Dungeon - Entrance Target"
--     1762 Reposo de los Reyes     -> 100056  (-945.114, 2544.25, 833.052) "8.x Dungeon - KingsRest - Entrance"
--     1763 Atal'Dazar              -> 100054  (-848.363, 2082.47, 725.146) "8.x Dungeon - Atal Dazar - Entrance"
--     2521 Estanques de Vida Rubi  -> 100030  (1386.2, -169.719, 131)      "10.x Dungeon - Ruby Life Pools - Entrance"
--   Lo que faltaba era el MAPEO zona -> cementerio (`graveyard_zone`), que es una tabla de una linea.
--
-- DE DONDE SALEN LAS ZONAS: de `world.creature.zoneId` de cada calabozo (las criaturas se generaron
-- con los mismos datos de area que usa sTerrainMgr.GetZoneId al buscar el cementerio), y la de
-- Atal'Dazar la confirma el propio log del servidor (9028). Medido:
--     1456 -> 8040     1763 -> 9028     1762 -> 9526     2521 -> 14063
--     2649 -> 14954    2669 -> 14979    2660 -> 15093    2651 -> 14882
--
-- FALTA (anotado): los otros cuatro calabozos de la temporada (2649 Priorato, 2669 Ciudad de los
-- Hilos, 2660 Ara-Kara, 2651 Grieta Llama Oscura) no tienen NINGUN punto seguro en su propio mapa
-- --la TDB solo trae cementerios del mapa del mundo (p.ej. "Hallowfall - Priory ... GY" en el 2601)--
-- asi que para ellos hay que crear el `world_safe_locs` de la entrada primero. Es el mismo dato que
-- falta para las puertas (`areatrigger_teleport`): las coordenadas de entrada de esos calabozos.
-- ============================================================================

INSERT INTO `graveyard_zone` (`ID`, `GhostZone`, `Comment`) VALUES
 (5100,   8040,  'Ojo de Azshara - entrada (config del proyecto)'),
 (100056, 9526,  'Reposo de los Reyes - entrada (config del proyecto)'),
 (100054, 9028,  'AtalDazar - entrada (config del proyecto)'),
 (100030, 14063, 'Estanques de Vida Rubi - entrada (config del proyecto)')
ON DUPLICATE KEY UPDATE `Comment` = VALUES(`Comment`);
