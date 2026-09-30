-- Spawns de gameobject con el cuaternion de rotacion en cero (todas las componentes 0 = no unitario).
-- Familia del arranque: 4 lineas "Table `gameobject` has gameobject (GUID: N Entry: N) with invalid
-- rotation quaternion (non-unit), defaulting to orientation on Z axis only" en el levante anterior y
-- 10 en el de las 11:29 — las 6 nuevas salen de los objetos de la Isla del Exilio que agrego la
-- migracion 2026_09_16_05 (GUID 11801031..11801036, entradas 339865 y 351476, mapa 2175): se
-- insertaron con rotation0..3 = 0.
--
-- Que hace el core con ellas: ObjectMgr.cpp:2697-2701 las detecta y las reemplaza en memoria por
-- QuaternionData::fromEulerAnglesZYX(orientacion, 0, 0) — o sea (0, 0, sen(a/2), cos(a/2)) sobre el
-- eje Z, con a = gameobject.orientation. Esta migracion escribe ESE MISMO valor en la base: el juego
-- queda igual que hoy y el aviso deja de aparecer en cada arranque.
--
-- La formula esta validada contra las 85.419 filas que ya la cumplen en la tabla (rotation2/3 =
-- +-sen/+-cos del angulo, con los dos signos: una rotacion de angulo a se puede escribir como
-- (sen(a/2), cos(a/2)) o su negada). Con orientacion 0 la formula da (0, 1), que tambien es unitario.
UPDATE gameobject
SET rotation2 = SIN(orientation / 2), rotation3 = COS(orientation / 2)
WHERE rotation0 = 0 AND rotation1 = 0 AND rotation2 = 0 AND rotation3 = 0;
