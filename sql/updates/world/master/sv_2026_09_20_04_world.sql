-- Tutoria de escuadra (Warband Mentorship): los numeros y los textos del sistema, en datos.
--
-- QUE HACE: cada personaje de nivel maximo de la cuenta de battle.net le da +5 % de experiencia a los
-- personajes que todavia no estan al maximo, con un tope de +25 %. El codigo vive en
-- `src/server/scripts/Custom/mentoria_warband_custom.cpp` (mod propio: el core no tiene nada de esto y
-- no hace falta parchearlo — el gancho `PlayerScript::OnGiveXP` ya existe).
--
-- El conteo de personajes de nivel maximo sale de `characters.characters` filtrando por las cuentas de
-- juego de la cuenta (`auth.account.battlenet_account`). Nada de esto se inventa: los porcentajes y el
-- tope son los de retail (5 % por personaje, tope 25 %).
--
-- Idempotente: crea la tabla si falta y borra sus claves antes de insertarlas.

CREATE TABLE IF NOT EXISTS `mentoria_warband` (
  `clave`      varchar(64)  NOT NULL,
  `valor`      varchar(255) NOT NULL,
  `comentario` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`clave`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DELETE FROM `mentoria_warband` WHERE `clave` IN ('activo','pct_por_personaje','pct_max','segundos_cache','texto_aviso');

INSERT INTO `mentoria_warband` (`clave`, `valor`, `comentario`) VALUES
('activo',             '1',  'prender/apagar el sistema entero (1/0)'),
('pct_por_personaje',  '5',  'bono de experiencia por cada personaje de nivel maximo de la cuenta (retail: 5)'),
('pct_max',            '25', 'tope del bono acumulado (retail: 25)'),
('segundos_cache',     '300','cuanto dura el conteo en memoria antes de volver a consultar la base'),
('texto_aviso',        'Tutoria de escuadra: +{pct}% de experiencia ({n} personajes al maximo).', 'aviso al entrar; {pct} y {n} se reemplazan');

-- Verificacion sugerida:
--   SELECT clave, valor FROM world.mentoria_warband;   -- 5 filas
--   (en el juego) .mentoria estado
