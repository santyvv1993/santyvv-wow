-- SV: declara la dificultad de los mapas del BARRIO (housing) para que el core acepte sus habitantes.
--
-- PROBLEMA: el cliente NO trae ninguna fila para los mapas de barrio en `MapDifficulty.db2`
-- (1.908 filas y ninguna de los mapas 2735, 2736, 2783 ni 2640). El core arma con eso la lista de
-- dificultades validas de cada mapa, asi que cualquier spawn de esos mapas cae en
--   "has unsupported difficulty 0 for map (Id: 2735)"   (ObjectMgr.cpp, ParseSpawnDifficulties)
-- y se descarta: el barrio queda vacio.
--
-- ARREGLO: declaramos la fila desde nuestro lado, en la tabla de hotfixes (el core la lee como fila
-- propia cuando VerifiedBuild > 0). Dificultad 0 = la normal.
-- Las 4 filas ya estaban puestas a mano (verificado: mismo MapID/DifficultyID/VerifiedBuild), asi que
-- la migracion va IGNORE para que el updater pueda aplicar el archivo sin morir con "Duplicate entry":
-- esa falla abortaba el levante del mundo entero (el updater no sigue con el resto de la base).
INSERT IGNORE INTO `map_difficulty` (`Message`,`ID`,`DifficultyID`,`LockID`,`ResetInterval`,`MaxPlayers`,`ItemContext`,`ItemContextPickerID`,`Flags`,`ContentTuningID`,`WorldStateExpressionID`,`MapID`,`VerifiedBuild`) VALUES
(NULL, 9000001, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2735, 69933),
(NULL, 9000002, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2736, 69933),
(NULL, 9000003, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2783, 69933),
(NULL, 9000004, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2640, 69933);
