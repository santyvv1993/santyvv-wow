-- ============================================================================
-- Configuracion dinamica de la temporada de miticas+ (nada quemado en el codigo)
-- ============================================================================
-- Regla del proyecto: si un numero o un texto se puede querer cambiar algun dia, vive en una tabla.
-- El codigo solo interpreta. Estas dos tablas son la unica fuente de la "forma" del sistema.
--
--   mitica_temporada  que temporada esta viva y cuando
--   mitica_config     los numeros y los textos (con placeholders {estancia} {nivel} {oro} ...)
-- ============================================================================

CREATE TABLE IF NOT EXISTS `mitica_temporada` (
  `id`       INT UNSIGNED NOT NULL,
  `nombre`   VARCHAR(120) NOT NULL,
  `desde`    DATE NOT NULL,
  `hasta`    DATE NULL DEFAULT NULL COMMENT 'NULL = abierta',
  `activa`   TINYINT UNSIGNED NOT NULL DEFAULT 0,
  `notas`    VARCHAR(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `idx_activa` (`activa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Temporadas de mitica+ (la activa manda)';

CREATE TABLE IF NOT EXISTS `mitica_config` (
  `clave`       VARCHAR(64) NOT NULL,
  `valor`       VARCHAR(255) NOT NULL,
  `descripcion` VARCHAR(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`clave`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Configuracion de mitica+ (numeros y textos, sin recompilar)';

INSERT INTO `mitica_temporada` (`id`, `nombre`, `desde`, `hasta`, `activa`, `notas`) VALUES
 (1, 'Temporada 1 - La base', '2026-09-16', NULL, 1,
     '8 estancias elegidas por contenido real y cobertura de mmaps; niveles 2-10')
ON DUPLICATE KEY UPDATE `nombre` = VALUES(`nombre`), `activa` = VALUES(`activa`), `notas` = VALUES(`notas`);

INSERT INTO `mitica_config` (`clave`, `valor`, `descripcion`) VALUES
 ('piedra_item',                   '180653', 'item de la piedra angular (el unico par Reagent/Keystone que el core reconoce)')
,('afijos_max',                    '4',      'cuantos afijos puede declarar la piedra (modificadores 19-22 del cliente)')
,('cofre_go_defecto',              '252064', 'cofre del final si la estancia no declara uno')
,('ilvl_techo_defecto',            '318',    'techo de nivel de objeto si la estancia no declara uno')
,('m0_requerida',                  '1',      '1 = para pedir piedra al NPC hay que haber hecho una Mitica 0 esta semana')
,('devolver_piedra_al_interrumpir','1',      '1 = si el mundo se reinicia o la corrida se cae, la piedra vuelve')
,('piedra_sube_con_oro',           '1',      '1 = terminar en tiempo de oro sube la piedra de nivel')
,('aviso_arranque',                'Mitica+ | {estancia} | nivel {nivel}', 'mensaje al arrancar la corrida')
,('aviso_tiempos',                 'Tiempo para oro: {oro} min - plata {plata} min - bronce {bronce} min', 'mensaje con los tiempos de medalla')
,('aviso_fuerzas',                 'Fuerzas completas: el jefe final esta habilitado', 'mensaje al llegar a las fuerzas objetivo')
,('aviso_muerte',                  'Muerte {muertes} del grupo', 'mensaje en cada muerte')
,('aviso_cierre',                  'Mitica+ terminada en {tiempo} - medalla {medalla}', 'mensaje al cerrar la corrida')
,('aviso_piedra_subida',           'Tu piedra subio a nivel {nivel} ({estancia})', 'mensaje al mejorar la piedra')
ON DUPLICATE KEY UPDATE `valor` = VALUES(`valor`), `descripcion` = VALUES(`descripcion`);
