-- SV: le da DESTINO al hechizo del portal del barrio.
--
-- El portal existe y esta puesto en el mundo: objeto 543407 "Portal to Founder's Point" (tipo 22 =
-- spellcaster, o sea lanza un hechizo), en el mapa 0, guid 10001986, coordenadas (-9078, 908, 68),
-- la torre de portales de Ventormenta. Castea el hechizo 1235595.
--
-- Faltaba la fila del destino: sin ella el hechizo no tiene a donde llevar al jugador y al usarlo no
-- pasa nada (el core: "Loaded 0 spell target coordinates" / el hechizo se lanza al vacio).
-- Destino = el punto de llegada del barrio 1 (Founder's Point, Alianza), que ya tenemos en
-- `housing_neighborhood`: mapa 2735, (3807.76, -160.427, 194.111).
-- Las dos filas ya estaban puestas a mano, asi que la migracion va IGNORE para que el updater
-- pueda aplicarla sin morir con "Duplicate entry" (esa falla dejaba el mundo sin arrancar y
-- frenaba TODAS las migraciones siguientes del world: la del 27-sep de poblacion y la del vuelo).
INSERT IGNORE INTO `spell_target_position` (`ID`,`EffectIndex`,`OrderIndex`,`MapID`,`PositionX`,`PositionY`,`PositionZ`,`Orientation`,`VerifiedBuild`) VALUES
(1235595, 0, 0, 2735, 3807.76, -160.427, 194.111, NULL, 0),
-- Igual para el portal de la Horda: 543406 "Portal to Razorwind Shores" castea 1235590.
-- Destino = punto de llegada del barrio 2 (Razorwind Shores), mapa 2736.
(1235590, 0, 0, 2736, 2053.6, 175.468, 175.12, NULL, 0);
