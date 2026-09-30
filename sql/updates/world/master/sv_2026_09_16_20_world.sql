-- ============================================================================
-- Cementerios de calabozo (segunda parte): Grieta Llama Oscura, Ara-Kara y Ciudad de los Hilos
-- ============================================================================
-- La primera parte (2026_09_16_19) mapeo los cuatro calabozos cuya entrada YA estaba en
-- world_safe_locs. Los otros cuatro no tenian ningun punto seguro en su propio mapa, asi que hay que
-- crear el punto de la entrada antes de mapearlo.
--
-- DE DONDE SALE LA POSICION DE LA ENTRADA (y por que es dato y no invencion)
--   Los calabozos traen un gameobject "Instance Portal" (el portal de salida) spawnneado en su mapa:
--       select g.map, gt.name, g.position_x, g.position_y, g.position_z from gameobject g
--       join gameobject_template gt on gt.entry = g.id where gt.name = 'Instance Portal' and g.map = <mapa>;
--   Ese portal esta EN LA ENTRADA, y se comprobo contra los cuatro calabozos cuya entrada ya conoce
--   world_safe_locs (distancia 3D entre el portal y el punto seguro oficial de la TDB):
--       1456 Ojo de Azshara         portal (-3925.5, 4549.1, 91.9) vs 5100    -> 15 yd
--       1762 Reposo de los Reyes    portal (-945.8, 2522.8, 835.4)  vs 100056 -> 21 yd
--       1763 Atal'Dazar             portal (-849.1, 2044.2, 729.7)  vs 100054 -> 38 yd
--       2521 Estanques de Vida Rubi portal (1365.9, -157.4, 140.8)  vs 100030 -> 24 yd
--   El portal es un punto valido para reaparecer: es la entrada misma (en retail se reaparece al
--   lado del portal de la instancia).
--
--   Ciudad de los Hilos (2669) no tiene portal spawnneado, pero si una piedra de encuentro dentro del
--   mapa (los calabozos modernos incluyen el patio de la entrada en su propio mapa, y la piedra de
--   encuentro se coloca delante de la entrada): (-1618.4, -754.2, -1337.5). Es el unico marcador de
--   entrada que hay en ese mapa. PENDIENTE de confirmar en vivo.
--
--   El Priorato de la Llama Sagrada (2649) no tiene portal ni piedra de encuentro en su mapa: se
--   queda SIN cementerio hasta tener una fuente para su entrada (es el mismo dato que falta para su
--   puerta de entrada).
--
-- ORIENTACION: sale del cuaternion del portal ((0,0,sen(a/2),cos(a/2)), la misma convencion que usa
-- QuaternionData::fromEulerAnglesZYX): 2*asin(z) en grados -> 315.369 para 2651 y 53.128 para 2660.
-- La piedra de encuentro no declara rotacion util: facing 0.
--
-- ZONAS (medidas en world.creature.zoneId, el dato con el que el core busca el cementerio):
--     2651 -> 14882     2660 -> 15093     2669 -> 14979
--
-- IDS: 9000001-9000003 estan FUERA del rango de la TDB (maximo 100206) y no chocan con nada. No
-- importa que el cliente no conozca estos ids: SMSG_DEATH_RELEASE_LOC solo lleva mapa y posicion
-- (Server/Packets/MiscPackets.h: DeathReleaseLoc = MapID + XYZ), no el id del cementerio.
-- ============================================================================

INSERT INTO `world_safe_locs` (`ID`, `MapID`, `LocX`, `LocY`, `LocZ`, `Facing`, `TransportSpawnId`, `Comment`) VALUES
 (9000001, 2651, 239.8,    75.9,    94.7,    315.369, NULL, 'Grieta Llama Oscura - entrada (portal de instancia)'),
 (9000002, 2660, -406.1,   259,     209.5,   53.128,  NULL, 'Ara-Kara - entrada (portal de instancia)'),
 (9000003, 2669, -1618.4,  -754.2,  -1337.5, 0,       NULL, 'Ciudad de los Hilos - entrada (piedra de encuentro)')
ON DUPLICATE KEY UPDATE `Comment` = VALUES(`Comment`);

INSERT INTO `graveyard_zone` (`ID`, `GhostZone`, `Comment`) VALUES
 (9000001, 14882, 'Grieta Llama Oscura - entrada (config del proyecto)'),
 (9000002, 15093, 'Ara-Kara - entrada (config del proyecto)'),
 (9000003, 14979, 'Ciudad de los Hilos - entrada (config del proyecto)')
ON DUPLICATE KEY UPDATE `Comment` = VALUES(`Comment`);
