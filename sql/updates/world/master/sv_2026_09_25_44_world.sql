-- ===========================================================================
-- vuelo dinamico: velocidad de vuelo del modo y el impulso de ascenso medidos
-- ===========================================================================
-- QUE SE APLICA (medido en el sniff de retail 12.1.0.69875, 21-sep-2026)
--
-- 1) vuelo_config.velocidad_dinamica = 4.2
--    Retail manda SMSG_MOVE_SET_FLIGHT_SPEED 29.39999771118164062 (= 420% de la base de
--    vuelo 7.0) en el MISMO instante en que activa el modo (SMSG_MOVE_SET_CAN_ADV_FLY) y
--    7.700000286102294921 (= 110%) cuando lo apaga; los dos van pegados a los cambios de
--    MAX_VEL (55.25/85 encendido, 65/100 apagado), 60 veces por sesion.
--    Nuestro servidor no mandaba esa velocidad nunca: el cliente quedaba con 7.0/7.7
--    mientras el tope del aero era 55.25, asi que la escala de velocidad quedaba corta y
--    el "sobrepasar velocidad" (la estela de viento al picar) no llegaba a dispararse.
--    TC trae la base de vuelo en 7.0: la tasa 4.2 produce 29.4 exactos.
--    Al salir del modo el modulo RESTAURA la tasa que traia la montura (no inventa una).
--
-- 2) vuelo_impulso.velocidad = 45.0 en las filas 'ascenso'
--    Retail manda el impulso de lanzamiento como vector [0.0, 0.0, 45.0] (45 hacia arriba)
--    en el mismo paquete en que entra el aura 392752 "Potenciacion de lanzamiento".
--    Nuestro modulo manda exactamente esa misma forma (Position(0, 0, velocidad)) pero con
--    22.0: el ascenso salia 2,05 veces mas debil que en retail.
--    NO se tocan 'avance' (35.0) ni 'giro' (35.0): en vuelo retail manda rafagas de ~5.0
--    hacia donde mira el draco (y hay impulsos de otras magnitudes atados a hechizos, p. ej.
--    19.29 con "Rafagas de Ohn'ahra"), pero esa rafaga de ~5 es el empuje continuo del aero,
--    no la habilidad de impuso: no hay medida comparable uno a uno.
--
-- REVERSIBLE: volver atras es borrar la clave (el codigo cae a 4.2 por defecto) y devolver
-- las filas de 'ascenso' a 22.0; o poner habilitado=0 en vuelo_config.
-- ===========================================================================

INSERT INTO `vuelo_config` (`clave`, `valor`, `nota`) VALUES
  ('velocidad_dinamica', '4.2', 'Tasa de velocidad de vuelo con el modo dinamico encendido. Retail manda 29.4 (420% de 7.0) al activarlo: 4.2 x 7.0 = 29.4. Medido 25-sep-2026')
ON DUPLICATE KEY UPDATE `valor` = VALUES(`valor`), `nota` = VALUES(`nota`);

UPDATE `vuelo_impulso` SET `velocidad` = 45.0 WHERE `tipo` = 'ascenso';
