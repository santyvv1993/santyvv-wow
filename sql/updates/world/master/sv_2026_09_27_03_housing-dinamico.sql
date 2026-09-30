-- SV: housing (viviendas) — tablas del lado DINAMICO (barrio y rotaciones).
--
-- Por que separadas del esquema base: estas son las que cambian con el contenido. El barrio tiene
-- parcelas (114 en total, `NeighborhoodPlot`), un generador de nombres (39 combinaciones, el mismo que
-- produjo "Mortadelia"), iniciativas que rotan (17) y los niveles de casa reparten recompensas (12).
-- Con eso, agregar un barrio, una rotacion o una recompensa es INSERTAR FILAS, no recompilar.
--
-- Las columnas siguen al cliente (volcados con encabezado de wago para la build 69933); los campos que
-- el cliente todavia no nombra van con su nombre de campo crudo, para no inventar semantica.

CREATE TABLE `housing_neighborhood_plot` (
  `id`                 INT UNSIGNED NOT NULL COMMENT 'ID (NeighborhoodPlot.db2)',
  `neighborhood_map`   INT UNSIGNED NOT NULL COMMENT 'NeighborhoodMapID',
  `plot_index`         INT UNSIGNED NOT NULL DEFAULT 0,
  `name`               VARCHAR(96)  NOT NULL DEFAULT '',
  `cost`               INT UNSIGNED NOT NULL DEFAULT 0,
  `cornerstone_x`      FLOAT        NOT NULL DEFAULT 0 COMMENT 'donde va la piedra angular de la casa',
  `cornerstone_y`      FLOAT        NOT NULL DEFAULT 0,
  `cornerstone_z`      FLOAT        NOT NULL DEFAULT 0,
  `cornerstone_rot_x`  FLOAT        NOT NULL DEFAULT 0,
  `cornerstone_rot_y`  FLOAT        NOT NULL DEFAULT 0,
  `cornerstone_rot_z`  FLOAT        NOT NULL DEFAULT 0,
  `teleport_x`         FLOAT        NOT NULL DEFAULT 0 COMMENT 'a donde llega el jugador a esa parcela',
  `teleport_y`         FLOAT        NOT NULL DEFAULT 0,
  `teleport_z`         FLOAT        NOT NULL DEFAULT 0,
  `cornerstone_object` INT UNSIGNED NOT NULL DEFAULT 0,
  `plot_object`        INT UNSIGNED NOT NULL DEFAULT 0,
  `world_state`        INT UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `por_barrio` (`neighborhood_map`, `plot_index`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `housing_neighborhood_name` (
  `id`                INT UNSIGNED NOT NULL,
  `neighborhood_map`  INT UNSIGNED NOT NULL,
  `prefix`            VARCHAR(64)  NOT NULL DEFAULT '',
  `middle`            VARCHAR(64)  NOT NULL DEFAULT '',
  `suffix`            VARCHAR(64)  NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `por_barrio` (`neighborhood_map`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `housing_initiative` (
  `id`          INT UNSIGNED NOT NULL COMMENT 'NeighborhoodInitiative.db2',
  `name`        VARCHAR(96)  NOT NULL DEFAULT '',
  `description` TEXT         NULL,
  `flags`       INT UNSIGNED NOT NULL DEFAULT 0,
  `field_004`   INT          NOT NULL DEFAULT 0 COMMENT 'sin nombre en el cliente todavia',
  `field_005`   INT          NOT NULL DEFAULT 0,
  `field_006`   INT          NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `housing_level_reward` (
  `id`             INT UNSIGNED NOT NULL,
  `level_data_id`  INT UNSIGNED NOT NULL COMMENT 'HouseLevelData.ID (nivel de casa)',
  `name`           VARCHAR(96)  NOT NULL DEFAULT '',
  `description`    TEXT         NULL,
  `icon_file_id`   INT UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `por_nivel` (`level_data_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `housing_decor_subcategory` (
  `id`          INT UNSIGNED NOT NULL,
  `category`    INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'DecorCategory.ID',
  `name`        VARCHAR(96)  NOT NULL DEFAULT '',
  `order_index` INT UNSIGNED NOT NULL DEFAULT 0,
  `ui_atlas`    INT UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `por_categoria` (`category`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `housing_decor_x_subcategory` (
  `decor_id`       INT UNSIGNED NOT NULL,
  `subcategory_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`decor_id`, `subcategory_id`),
  KEY `por_subcategoria` (`subcategory_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `housing_decor_dye_slot` (
  `id`             INT UNSIGNED NOT NULL,
  `decor_id`       INT UNSIGNED NOT NULL,
  `dye_category`   INT UNSIGNED NOT NULL DEFAULT 0,
  `order_index`    INT UNSIGNED NOT NULL DEFAULT 0,
  `channel`        INT UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `por_decoracion` (`decor_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Recompensas retroactivas: "si ya tenias este logro/mision, te corresponde esta decoracion".
-- Es la fuente que el propio cliente declara para 245 decoraciones — la base del reparto por logros.
CREATE TABLE `housing_decor_retro_reward` (
  `id`             INT UNSIGNED NOT NULL,
  `decor_id`       INT UNSIGNED NOT NULL,
  `achievement_id` INT UNSIGNED NOT NULL DEFAULT 0,
  `quest_id`       INT UNSIGNED NOT NULL DEFAULT 0,
  `field_002`      INT          NOT NULL DEFAULT 0,
  `field_005`      INT          NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `por_decoracion` (`decor_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `housing_decor_retro_criteria` (
  `id`          INT UNSIGNED NOT NULL,
  `reward_id`   INT UNSIGNED NOT NULL COMMENT 'housing_decor_retro_reward.id',
  `achievement_id` INT UNSIGNED NOT NULL DEFAULT 0,
  `quest_id`    INT UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `por_recompensa` (`reward_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
