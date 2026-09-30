-- ============================================================================
-- Armador de paquetes dirigido por tabla
-- ============================================================================
-- El formato de los SMSG de mitica+ (arranque, muertes, cierre) NO esta documentado y no existe en
-- el core: se reconstruye probando contra el cliente. Para que cada intento sea un INSERT y no una
-- recompilacion, los paquetes se arman desde estas dos tablas:
--
--   mitica_paquete        QUE paquete (y si esta prendido)
--   mitica_paquete_campo  los campos, en orden, con su tipo y su valor
--
-- Placeholders disponibles en `valor` (se resuelven desde la corrida en curso):
--   {{cm_id}} {{map_id}} {{nivel}} {{instancia}} {{temporada}} {{grupo}} {{muertes}} {{segundos}}
--   {{t_seg_oro}} {{t_seg_plata}} {{t_seg_bronce}} {{t_ms_bronce}} {{ilvl_max}} {{afijos}}
--   {{mapa_dificultad}}
-- Tipos: u8 u16 u32 i32 u64 f32 cadena array_u32
-- Cada envio queda en el log con su contenido en hex (logger scripts.miticas).
-- ============================================================================

CREATE TABLE IF NOT EXISTS `mitica_paquete` (
  `opcode`      VARCHAR(64) NOT NULL,
  `activo`      TINYINT UNSIGNED NOT NULL DEFAULT 1,
  `descripcion` VARCHAR(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`opcode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Paquetes de mitica+ que el servidor manda';

CREATE TABLE IF NOT EXISTS `mitica_paquete_campo` (
  `opcode` VARCHAR(64) NOT NULL,
  `orden`  INT UNSIGNED NOT NULL,
  `tipo`   ENUM('u8','u16','u32','i32','u64','f32','cadena','array_u32') NOT NULL,
  `valor`  VARCHAR(128) NOT NULL DEFAULT '',
  `nota`   VARCHAR(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`opcode`, `orden`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Campos de cada paquete (formato en reconstruccion)';

INSERT INTO `mitica_paquete` (`opcode`, `activo`, `descripcion`) VALUES
 ('SMSG_CHALLENGE_MODE_START', 1, 'arranque del HUD de mitica+ (formato en reconstruccion)'),
 ('SMSG_CHALLENGE_MODE_UPDATE_DEATH_COUNT', 1, 'contador de muertes del grupo'),
 ('SMSG_CHALLENGE_MODE_COMPLETE', 1, 'cierre de la corrida')
ON DUPLICATE KEY UPDATE `descripcion` = VALUES(`descripcion`);

-- PRIMER INTENTO del arranque: hipotesis, no verdad. Se verifica mirando que dibuja el cliente.
INSERT INTO `mitica_paquete_campo` (`opcode`, `orden`, `tipo`, `valor`, `nota`) VALUES
 ('SMSG_CHALLENGE_MODE_START', 0, 'u32',       '{{cm_id}}',      'id de MapChallengeMode (244 = AtalDazar)'),
 ('SMSG_CHALLENGE_MODE_START', 1, 'u32',       '{{map_id}}',     'mapa de la mazmorra'),
 ('SMSG_CHALLENGE_MODE_START', 2, 'u32',       '{{nivel}}',      'nivel de la piedra'),
 ('SMSG_CHALLENGE_MODE_START', 3, 'u32',       '{{t_ms_bronce}}','tiempo limite (ms)'),
 ('SMSG_CHALLENGE_MODE_START', 4, 'array_u32', '{{afijos}}',     'afijos: cantidad + ids'),
 ('SMSG_CHALLENGE_MODE_UPDATE_DEATH_COUNT', 0, 'u32', '{{muertes}}', 'muertes acumuladas'),
 ('SMSG_CHALLENGE_MODE_COMPLETE', 0, 'u32', '{{cm_id}}',    'estancia'),
 ('SMSG_CHALLENGE_MODE_COMPLETE', 1, 'u32', '{{segundos}}', 'tiempo total'),
 ('SMSG_CHALLENGE_MODE_COMPLETE', 2, 'u32', '{{nivel}}',    'nivel de la piedra')
ON DUPLICATE KEY UPDATE `tipo` = VALUES(`tipo`), `valor` = VALUES(`valor`), `nota` = VALUES(`nota`);
