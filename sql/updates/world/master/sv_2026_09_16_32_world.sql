-- ============================================================================
--  Vuelo dinamico (skyriding) - segunda tanda: zonas con regla propia y calibracion
-- ============================================================================
--
--  Por que existe:
--   1. Las reglas de vuelo por ZONA no estaban: se volaba igual en cualquier lado. Ahora
--      `vuelo_zona` dice, por zona, si se vuela normal (`todo`), solo con vuelo estatico
--      (`estable`) o directamente no se vuela (`nada`, la montura queda de tierra). La regla
--      se mira al montar y al cambiar de zona (gancho OnUpdateZone), y una fila puesta en una
--      zona padre alcanza a todas sus hijas.
--   2. La CALIBRACION de los impulsos, medida en la primera prueba en vivo: `Ascenso al cielo`
--      traia su propio parametro en el cliente (`SpellEffect.EffectBasePoints = 452.0`) y
--      estabamos en 6 (el ascenso "no tenia fuerza"); `Aceleracion giratoria` tiene parte del
--      movimiento del lado del cliente (aura 395) y nuestros 60 se sumaban encima ("muy fuerte").
--   3. `volar_con_cualquier_montura`: por defecto 0 = solo vuela la montura cuya capacidad
--      declara `MOUNT_CAPABILITY_FLAG_FLYING` (asi un caballo no sale volando). Se pone en 1 para
--      probar con cualquier montura.
--
--  Idempotente: se puede correr dos veces sin romper nada.
-- ============================================================================

CREATE TABLE IF NOT EXISTS `vuelo_zona` (
  `area_id` INT UNSIGNED NOT NULL COMMENT 'AreaTable.Id (sirve la zona o cualquiera de sus padres)',
  `permite` ENUM('todo','estable','nada') NOT NULL COMMENT 'que deja hacer el vuelo en esa zona',
  `nota`    VARCHAR(255) NOT NULL,
  PRIMARY KEY (`area_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Vuelo dinamico: reglas de vuelo por zona (sin fila = vuelo normal)';

-- Sin filas a proposito: en todas las zonas se vuela normal. El comando `.vuelo zona <personaje>
-- todo|estable|nada` llena esta tabla (y la deja viva al instante). Ejemplos de lo que se puede
-- declarar cuando haga falta: una mazmorra o una arena con `nada`, o una zona vieja donde la
-- inercia del cliente se sienta rara con `estable`.

INSERT INTO `vuelo_config` (`clave`, `valor`, `nota`) VALUES
  ('volar_con_cualquier_montura', '0', '1 = vuela cualquier montura aunque su capacidad no declare vuelo (para probar)')
ON DUPLICATE KEY UPDATE `nota` = VALUES(`nota`);

-- Calibracion de los impulsos (ver P10): ascenso 45 = el parametro del cliente (452) / 10;
-- giro 12 = el cliente ya empuja por su cuenta; avance 14 queda igual.
INSERT INTO `vuelo_impulso` (`hechizo`, `tipo`, `velocidad`, `nota`) VALUES
  (372610,  'ascenso', 45.0, 'Ascenso al cielo'),
  (376744,  'ascenso', 45.0, 'Ascenso al cielo (copia de la barra)'),
  (386451,  'ascenso', 45.0, 'Ascenso al cielo (copia de la barra)'),
  (1227916, 'ascenso', 45.0, 'Ascenso al cielo (copia de la barra)'),
  (374763,  'ascenso', 45.0, 'Levantar vuelo'),
  (384752,  'ascenso', 45.0, 'Levantar vuelo (copia de la barra)'),
  (404191,  'ascenso', 45.0, 'Levantar vuelo (copia de la barra)'),
  (1227919, 'ascenso', 45.0, 'Levantar vuelo (copia de la barra)'),
  (361584,  'giro',    12.0, 'Aceleracion giratoria (el cliente ya empuja: no sumar de mas)'),
  (442180,  'giro',    12.0, 'Aceleracion giratoria (el cliente ya empuja: no sumar de mas)')
ON DUPLICATE KEY UPDATE `tipo` = VALUES(`tipo`), `velocidad` = VALUES(`velocidad`), `nota` = VALUES(`nota`);
