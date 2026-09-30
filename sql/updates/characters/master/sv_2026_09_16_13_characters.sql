-- ============================================================================
-- Sistema de miticas+ propio - ESTADO POR PERSONAJE (complementa mitica_piedra)
-- La corrida vive en la BASE, no solo en memoria: si el mundo se reinicia, al arrancar
-- se cierran las corridas abiertas como 'interrumpida' y se devuelve la piedra.
-- ============================================================================

CREATE TABLE IF NOT EXISTS `mitica_corrida` (
  `corrida_id`   BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `cm_id`        INT UNSIGNED NOT NULL,
  `map_id`       INT UNSIGNED NOT NULL,
  `nivel`        INT UNSIGNED NOT NULL,
  `afijos`       VARCHAR(64) NOT NULL DEFAULT '',
  `instancia`    INT UNSIGNED NOT NULL DEFAULT 0,
  `lider`        INT UNSIGNED NOT NULL COMMENT 'guid del personaje que arranco',
  `miembros`     VARCHAR(255) NOT NULL DEFAULT '' COMMENT 'guids separados por espacio',
  `inicio`       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fin`          TIMESTAMP NULL DEFAULT NULL,
  `tiempo_seg`   INT UNSIGNED NOT NULL DEFAULT 0,
  `muertes`      INT UNSIGNED NOT NULL DEFAULT 0,
  `fuerzas`      DECIMAL(5,2) NOT NULL DEFAULT 0,
  `estado`       ENUM('en_curso','completada','fuera_de_tiempo','abandonada','interrumpida','prueba')
                 NOT NULL DEFAULT 'en_curso',
  `medalla`      ENUM('ninguna','bronce','plata','oro') NOT NULL DEFAULT 'ninguna',
  PRIMARY KEY (`corrida_id`),
  KEY `idx_estado` (`estado`),
  KEY `idx_instancia` (`instancia`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Corridas de mitica+ (en curso y cerradas)';

-- Prueba semanal de Mitica 0: es la puerta para que el NPC de consorcio entregue la piedra.
CREATE TABLE IF NOT EXISTS `mitica_m0_semana` (
  `personaje`    INT UNSIGNED NOT NULL,
  `cm_id`        INT UNSIGNED NOT NULL,
  `semana`       VARCHAR(10) NOT NULL COMMENT 'AAAA-WW en hora local',
  `completada`   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`personaje`, `cm_id`, `semana`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Mitica 0 completadas por semana (requisito de la piedra en el NPC)';
