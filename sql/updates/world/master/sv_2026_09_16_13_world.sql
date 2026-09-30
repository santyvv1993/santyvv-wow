-- ============================================================================
-- Sistema de miticas+ propio - ESQUEMA Y SEMILLA (generado por
-- herramientas/miticas-generar-sql.py a partir de los datos medidos del cliente).
-- Temporada propia 1 · niveles 2-10 · cofre 252064
-- ============================================================================

-- Una fila = una mitica. Agregar una estancia es un INSERT aca, nunca recompilar.
CREATE TABLE IF NOT EXISTS `mitica_estancia` (
  `cm_id`        INT UNSIGNED NOT NULL COMMENT 'MapChallengeModeID del cliente',
  `map_id`       INT UNSIGNED NOT NULL COMMENT 'MapID (la mazmorra)',
  `nombre`       VARCHAR(120) NOT NULL,
  `temporada`    INT UNSIGNED NOT NULL DEFAULT 1,
  `activa`       TINYINT UNSIGNED NOT NULL DEFAULT 1,
  `nivel_min`    INT UNSIGNED NOT NULL DEFAULT 2,
  `nivel_rec`    INT UNSIGNED NOT NULL DEFAULT 5,
  `nivel_max`    INT UNSIGNED NOT NULL DEFAULT 10,
  `tiempo_oro`   INT UNSIGNED NOT NULL COMMENT 'segundos (CriteriaCount3 del cliente)',
  `tiempo_plata` INT UNSIGNED NOT NULL,
  `tiempo_bronce` INT UNSIGNED NOT NULL,
  `fuerzas_min`  INT UNSIGNED NOT NULL DEFAULT 100 COMMENT '% de fuerzas para habilitar al jefe final',
  `cofre_go`     INT UNSIGNED NOT NULL DEFAULT 252064 COMMENT 'GameObject del cofre (tipo 51)',
  `ilvl_techo`   INT UNSIGNED NOT NULL DEFAULT 318,
  `notas`        VARCHAR(255) NOT NULL DEFAULT '' COMMENT 'estado del contenido/mmaps (medido)',
  PRIMARY KEY (`cm_id`),
  KEY `idx_temporada` (`temporada`, `activa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Estancias de mitica+ habilitadas (parametrizable)';

-- La curva de dificultad. ES la palanca: cambiar aca no rompe nada.
CREATE TABLE IF NOT EXISTS `mitica_nivel` (
  `nivel`           INT UNSIGNED NOT NULL,
  `vida_pct`        DECIMAL(6,2) NOT NULL DEFAULT 100 COMMENT '% de vida de los enemigos',
  `dano_pct`        DECIMAL(6,2) NOT NULL DEFAULT 100,
  `jefe_vida_pct`   DECIMAL(6,2) NOT NULL DEFAULT 100 COMMENT 'lo que agrega Tirantico',
  `jefe_dano_pct`   DECIMAL(6,2) NOT NULL DEFAULT 100,
  `fuerzas_objetivo` INT UNSIGNED NOT NULL DEFAULT 100,
  `ilvl_min`        INT UNSIGNED NOT NULL COMMENT 'nivel de objeto minimo del botin (del cliente)',
  `ilvl_max`        INT UNSIGNED NOT NULL,
  `muertes_medalla` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '0 = la medalla no depende de las muertes',
  PRIMARY KEY (`nivel`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Escalado por nivel de piedra (parametrizable)';

-- Catalogo de afijos: el cliente da nombre y descripcion, la mecanica la ponemos nosotros.
CREATE TABLE IF NOT EXISTS `mitica_afijo` (
  `afijo_id`       INT UNSIGNED NOT NULL COMMENT 'KeystoneAffix.ID del cliente',
  `nombre`         VARCHAR(120) NOT NULL,
  `implementacion` ENUM('estatico','aura','script','sin_implementar') NOT NULL DEFAULT 'sin_implementar',
  `spell_id`       INT UNSIGNED NOT NULL DEFAULT 0,
  `parametros`     VARCHAR(255) NOT NULL DEFAULT '' COMMENT 'JSON: valores por nivel, a quien aplica',
  `activo`         TINYINT UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`afijo_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Afijos de mitica+ (clasificados por como se implementan)';

-- Desde que nivel entra cada afijo (importado del cliente).
CREATE TABLE IF NOT EXISTS `mitica_afijo_nivel` (
  `afijo_id`    INT UNSIGNED NOT NULL,
  `desde_nivel` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`afijo_id`, `desde_nivel`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Calendario de afijos por nivel (del cliente)';

-- Cuanta fuerza vale cada enemigo (sin esto no hay barra de fuerzas).
CREATE TABLE IF NOT EXISTS `mitica_fuerzas` (
  `cm_id`  INT UNSIGNED NOT NULL,
  `entry`  INT UNSIGNED NOT NULL,
  `pct`    DECIMAL(5,2) NOT NULL COMMENT '% de fuerzas que aporta al morir',
  PRIMARY KEY (`cm_id`, `entry`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Fuerzas enemigas por criatura (lo no listado usa la regla por clasificacion)';

-- ---- semilla: las 8 estancias de la temporada propia ----
INSERT INTO `mitica_estancia`
 (`cm_id`,`map_id`,`nombre`,`temporada`,`activa`,`nivel_min`,`nivel_rec`,`nivel_max`,`tiempo_oro`,`tiempo_plata`,`tiempo_bronce`,`fuerzas_min`,`cofre_go`,`ilvl_techo`,`notas`) VALUES
 (502, 2669, 'Ciudad de los Hilos', 1, 1, 2, 5, 10, 1260, 1680, 2100, 100, 252064, 318, '864 criaturas en la base; mmaps completos'),
 (197, 1456, 'Ojo de Azshara', 1, 1, 2, 5, 10, 1260, 1680, 2100, 100, 252064, 318, '622 criaturas en la base; mmaps completos'),
 (503, 2660, 'Ara-Kara, Ciudad de los Ecos', 1, 1, 2, 5, 10, 1080, 1440, 1800, 100, 252064, 318, '408 criaturas en la base; 4 tiles sin navmesh'),
 (499, 2649, 'Priorato de la Llama Sagrada', 1, 1, 2, 5, 10, 1170, 1560, 1950, 100, 252064, 318, '357 criaturas en la base; mmaps completos'),
 (399, 2521, 'Estanques de Vida Rubi', 1, 1, 2, 5, 10, 1008, 1344, 1680, 100, 252064, 318, '306 criaturas en la base; mmaps completos'),
 (504, 2651, 'Grieta Llama Oscura', 1, 1, 2, 5, 10, 1116, 1488, 1860, 100, 252064, 318, '277 criaturas en la base; 1 tiles sin navmesh'),
 (244, 1763, 'Atal''Dazar', 1, 1, 2, 5, 10, 1080, 1440, 1800, 100, 252064, 318, '218 criaturas en la base; mmaps completos'),
 (249, 1762, 'Reposo de los Reyes', 1, 1, 2, 5, 10, 1188, 1584, 1980, 100, 252064, 318, '212 criaturas en la base; mmaps completos')
ON DUPLICATE KEY UPDATE `nombre`=VALUES(`nombre`), `nivel_min`=VALUES(`nivel_min`), `nivel_rec`=VALUES(`nivel_rec`), `nivel_max`=VALUES(`nivel_max`), `tiempo_oro`=VALUES(`tiempo_oro`), `tiempo_plata`=VALUES(`tiempo_plata`), `tiempo_bronce`=VALUES(`tiempo_bronce`), `notas`=VALUES(`notas`);

-- ---- semilla: curva de niveles (el nivel de objeto sale de la tabla del cliente) ----
INSERT INTO `mitica_nivel`
 (`nivel`,`vida_pct`,`dano_pct`,`jefe_vida_pct`,`jefe_dano_pct`,`fuerzas_objetivo`,`ilvl_min`,`ilvl_max`,`muertes_medalla`) VALUES
 (2, 100.00, 100.00, 115.00, 115.00, 100, 305, 305, 0),
 (3, 108.00, 108.00, 115.00, 115.00, 100, 305, 305, 0),
 (4, 116.00, 116.00, 115.00, 115.00, 100, 308, 308, 0),
 (5, 124.00, 124.00, 115.00, 115.00, 100, 308, 308, 0),
 (6, 132.00, 132.00, 115.00, 115.00, 100, 311, 311, 0),
 (7, 140.00, 140.00, 115.00, 115.00, 100, 315, 315, 0),
 (8, 148.00, 148.00, 115.00, 115.00, 100, 315, 315, 0),
 (9, 156.00, 156.00, 115.00, 115.00, 100, 315, 315, 0),
 (10, 164.00, 164.00, 115.00, 115.00, 100, 318, 318, 0)
ON DUPLICATE KEY UPDATE `vida_pct`=VALUES(`vida_pct`), `dano_pct`=VALUES(`dano_pct`), `jefe_vida_pct`=VALUES(`jefe_vida_pct`), `jefe_dano_pct`=VALUES(`jefe_dano_pct`), `ilvl_min`=VALUES(`ilvl_min`), `ilvl_max`=VALUES(`ilvl_max`);

-- ---- semilla: catalogo de afijos del cliente (el MVP deja activos solo los estaticos) ----
INSERT INTO `mitica_afijo` (`afijo_id`,`nombre`,`implementacion`,`activo`) VALUES
 (1, 'Rebosante', 'sin_implementar', 0),
 (2, 'Asustadizo', 'sin_implementar', 0),
 (3, 'Volcánico', 'sin_implementar', 0),
 (4, 'Necrótico', 'sin_implementar', 0),
 (5, 'Prolífico', 'sin_implementar', 0),
 (6, 'Enfurecido', 'sin_implementar', 0),
 (7, 'Reforzando', 'sin_implementar', 0),
 (8, 'Sanguina', 'sin_implementar', 0),
 (9, 'Tiránico', 'estatico', 1),
 (10, 'Reforzado', 'estatico', 1),
 (11, 'Llameante', 'sin_implementar', 0),
 (12, 'Grave', 'sin_implementar', 0),
 (13, 'Explosivo', 'sin_implementar', 0),
 (14, 'Tembloroso', 'sin_implementar', 0),
 (16, 'Infestado', 'sin_implementar', 0),
 (117, 'Abundante', 'sin_implementar', 0),
 (119, 'Cautivador', 'sin_implementar', 0),
 (120, 'Despierto', 'sin_implementar', 0),
 (121, 'Orgulloso', 'sin_implementar', 0),
 (122, 'Inspirador', 'sin_implementar', 0),
 (123, 'Rencoroso', 'sin_implementar', 0),
 (124, 'Tormentoso', 'sin_implementar', 0),
 (128, 'Atormentado', 'sin_implementar', 0),
 (129, 'Infernal', 'sin_implementar', 0),
 (130, 'Encriptado', 'sin_implementar', 0),
 (131, 'Velado', 'sin_implementar', 0),
 (132, 'Atronador', 'sin_implementar', 0),
 (133, 'Concentrado', 'sin_implementar', 0),
 (134, 'Estrangulación', 'sin_implementar', 0),
 (135, 'Aflicción', 'sin_implementar', 0),
 (136, 'Incorpóreo', 'sin_implementar', 0),
 (137, 'Con escudo', 'sin_implementar', 0),
 (144, 'Espinoso', 'sin_implementar', 0),
 (145, 'Insensato', 'sin_implementar', 0),
 (146, 'Armonizado', 'sin_implementar', 0),
 (147, 'Astucia de Xal''atath', 'sin_implementar', 0),
 (148, 'Pacto de Xal''atath: Ascendiente', 'estatico', 1),
 (152, 'Riesgo de contendiente', 'sin_implementar', 0),
 (153, 'Pacto de Xal''atath: Frenético', 'sin_implementar', 0),
 (158, 'Pacto de Xal''atath: Unida al Vacío', 'sin_implementar', 0),
 (159, 'Pacto de Xal''atath: Olvido', 'sin_implementar', 0),
 (160, 'Pacto de Xal''atath: Devorar', 'sin_implementar', 0),
 (162, 'Pacto de Xal''atath: Púlsar', 'sin_implementar', 0),
 (165, 'Guía de Lindormi', 'estatico', 1),
 (166, 'Prueba de Eternus: Arenas del tiempo', 'sin_implementar', 0),
 (167, 'Prueba de Eternus: Ocaso del Infinito', 'sin_implementar', 0),
 (168, 'Prueba de Eternus: Portales del tiempo manifestados', 'sin_implementar', 0),
 (169, 'Prueba de Eternus: Reflejos crepusculares', 'sin_implementar', 0),
 (170, 'Fortificado con tiranía', 'sin_implementar', 0),
 (178, '', 'sin_implementar', 0)
ON DUPLICATE KEY UPDATE `nombre`=VALUES(`nombre`);

-- ---- semilla: calendario de afijos por nivel (medido del cliente) ----
INSERT IGNORE INTO `mitica_afijo_nivel` (`afijo_id`,`desde_nivel`) VALUES
 (2, 0),
 (3, 0),
 (5, 0),
 (6, 0),
 (7, 0),
 (8, 0),
 (9, 0),
 (10, 0),
 (11, 0),
 (13, 0),
 (14, 0),
 (165, 0),
 (166, 0),
 (167, 0),
 (168, 0),
 (169, 0),
 (3, 1),
 (4, 1),
 (6, 1),
 (7, 1),
 (8, 1),
 (9, 1),
 (10, 1),
 (11, 1),
 (12, 1),
 (13, 1),
 (14, 1),
 (122, 1),
 (123, 1),
 (124, 1),
 (3, 2),
 (6, 2),
 (7, 2),
 (8, 2),
 (11, 2),
 (121, 2),
 (123, 2),
 (124, 2),
 (128, 2),
 (130, 2),
 (131, 2),
 (132, 2),
 (134, 2),
 (135, 2),
 (136, 2),
 (9, 10),
 (10, 10),
 (148, 10),
 (158, 10),
 (159, 10),
 (160, 10),
 (9, 15),
 (10, 15),
 (148, 15),
 (152, 15),
 (158, 15),
 (160, 15),
 (162, 15),
 (147, 25),
 (147, 30)
;
