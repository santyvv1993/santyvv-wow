-- SV: housing (viviendas) — esquema base.
--
-- Por que existe: el sistema de viviendas de 12.1 (barrio, casa, decoraciones, habitaciones, planos)
-- no esta implementado en TrinityCore (151 opcodes declarados y sin manejar). Estas tablas son el
-- lado NUESTRO del sistema: el estado del jugador. El catalogo (que decoraciones existen, que cuartos,
-- que temas) ya lo tiene el cliente en sus .db2, asi que no se copia: se referencia por id.
--
-- Modelo decodificado de la captura del 27-sep-2026 (ver docs/investigacion/HOUSING.md):
--   * un mueble viaja como `Housing/Decor` con HouseGUID (vacio si no esta puesto), PlacementStatus,
--     SourceType, SourceValue y HasDyeSlots  -> `housing_decor_storage` / `housing_decor_placement`
--   * la casa trae Level, Favor, InitiativeFavor y su barrio            -> `housing_house`
--   * el barrio tiene GUID propio (`Housing/Neighborhood`, NeighborhoodMapID) y su iniciativa
--                                                                       -> `housing_neighborhood`
--   * ROOM_ADD / SET_LAYOUT_EDIT_MODE / COMPONENT_THEME / MATERIALS / CEILING_TYPE -> `housing_room`
--   * BLUEPRINT_GET/CHECK/EXPORT: el plano viaja entero                -> `housing_blueprint`
--
-- Diseno "de datos, no de codigo" (pedido explicito): todo lo que varia por barrio, casa o evento
-- vive en filas, no en constantes del core; asi se pueden agregar barrios/catalogo/rotaciones sin
-- recompilar. Los ids son los del cliente, para no inventar un mapeo.

CREATE TABLE `housing_neighborhood` (
  `id`          INT UNSIGNED   NOT NULL COMMENT 'NeighborhoodMapID del cliente',
  `name`        VARCHAR(64)    NOT NULL DEFAULT '' COMMENT 'nombre del barrio (en retail lo elige el jugador)',
  `map`         INT UNSIGNED   NOT NULL COMMENT 'mapa donde vive el barrio (retail: 2735)',
  `position_x`  FLOAT          NOT NULL DEFAULT 0,
  `position_y`  FLOAT          NOT NULL DEFAULT 0,
  `position_z`  FLOAT          NOT NULL DEFAULT 0,
  `max_houses`  INT UNSIGNED   NOT NULL DEFAULT 50,
  `initiative`  INT UNSIGNED   NOT NULL DEFAULT 0 COMMENT 'NeighborhoodInitiative.db2 en curso',
  `created_at`  TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `housing_house` (
  `id`               BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `neighborhood`     INT UNSIGNED    NOT NULL,
  `owner_guid`       BIGINT UNSIGNED NOT NULL COMMENT 'personaje dueno',
  `owner_account`    INT UNSIGNED    NOT NULL COMMENT 'cuenta BNet (el oficial manda su GUID)',
  `plot`             INT UNSIGNED    NOT NULL DEFAULT 0,
  `level`            TINYINT UNSIGNED NOT NULL DEFAULT 1,
  `favor`            INT UNSIGNED    NOT NULL DEFAULT 0,
  `initiative_favor` INT UNSIGNED    NOT NULL DEFAULT 0,
  `exterior_locked`  TINYINT(1)      NOT NULL DEFAULT 0,
  `position_x`       FLOAT           NOT NULL DEFAULT 0,
  `position_y`       FLOAT           NOT NULL DEFAULT 0,
  `position_z`       FLOAT           NOT NULL DEFAULT 0,
  `orientation`      FLOAT           NOT NULL DEFAULT 0,
  `created_at`       TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `por_personaje` (`owner_guid`),
  KEY `por_barrio` (`neighborhood`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `housing_decor_storage` (
  `guid`             BIGINT UNSIGNED NOT NULL COMMENT 'guid de la instancia (tipo Housing/Decor)',
  `house`            BIGINT UNSIGNED NOT NULL,
  `decor_id`         INT UNSIGNED    NOT NULL COMMENT 'DecorID del catalogo del cliente',
  `quantity`         INT UNSIGNED    NOT NULL DEFAULT 1,
  `source_type`      TINYINT UNSIGNED NOT NULL DEFAULT 0,
  `source_value`     VARCHAR(64)     NOT NULL DEFAULT '',
  `has_dye_slots`    TINYINT(1)      NOT NULL DEFAULT 0,
  `placement_status` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '0 = guardada, 1 = colocada',
  `acquired_at`      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`guid`),
  KEY `por_casa` (`house`),
  KEY `por_decoracion` (`decor_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `housing_decor_placement` (
  `guid`        BIGINT UNSIGNED NOT NULL,
  `room`        BIGINT UNSIGNED NOT NULL DEFAULT 0,
  `position_x`  FLOAT           NOT NULL DEFAULT 0,
  `position_y`  FLOAT           NOT NULL DEFAULT 0,
  `position_z`  FLOAT           NOT NULL DEFAULT 0,
  `orientation` FLOAT           NOT NULL DEFAULT 0,
  `scale`       FLOAT           NOT NULL DEFAULT 1,
  `dye_slots`   VARCHAR(96)     NOT NULL DEFAULT '' COMMENT 'ranuras de tenido aplicadas',
  PRIMARY KEY (`guid`),
  KEY `por_cuarto` (`room`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `housing_room` (
  `id`           BIGINT UNSIGNED NOT NULL COMMENT 'guid del cuarto (tipo Housing/RoomComponent)',
  `house`        BIGINT UNSIGNED NOT NULL,
  `room_type`    INT UNSIGNED    NOT NULL DEFAULT 0 COMMENT 'HouseRoom.db2',
  `layout`       INT UNSIGNED    NOT NULL DEFAULT 0,
  `theme`        INT UNSIGNED    NOT NULL DEFAULT 0 COMMENT 'HouseTheme.db2',
  `materials`    VARCHAR(128)    NOT NULL DEFAULT '' COMMENT 'componente:material, separados por coma',
  `ceiling_type` INT UNSIGNED    NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `por_casa` (`house`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `housing_blueprint` (
  `id`            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `owner_account` INT UNSIGNED    NOT NULL,
  `name`          VARCHAR(64)     NOT NULL DEFAULT '',
  `checked`       TINYINT(1)      NOT NULL DEFAULT 0,
  `contents`      MEDIUMBLOB      NULL COMMENT 'el plano tal como lo manda/recibe el cliente',
  `created_at`    TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `por_cuenta` (`owner_account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Copia local del catalogo del cliente. No hace falta para que el cliente dibuje (el ya lo tiene),
-- pero SI para todo lo que decide el servidor: que recompensa suelta que decoracion, que se puede
-- comprar y a que precio, y las rotaciones diarias (el mismo problema que los pedidos y los mecenas).
CREATE TABLE `housing_decor_catalog` (
  `decor_id`        INT UNSIGNED NOT NULL COMMENT 'ID (HouseDecor.db2)',
  `name`            VARCHAR(96)  NOT NULL DEFAULT '',
  `gameobject_id`   INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'el objeto que se coloca en el mundo',
  `item_id`         INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'el item que la otorga',
  `type`            INT UNSIGNED NOT NULL DEFAULT 0,
  `model_type`      INT UNSIGNED NOT NULL DEFAULT 0,
  `flags`           INT UNSIGNED NOT NULL DEFAULT 0,
  `weight_cost`     INT UNSIGNED NOT NULL DEFAULT 0,
  `item_context`    INT UNSIGNED NOT NULL DEFAULT 0,
  `initial_scale`   FLOAT        NOT NULL DEFAULT 1,
  `first_time_xp`   INT UNSIGNED NOT NULL DEFAULT 0,
  `starting_quantity` INT UNSIGNED NOT NULL DEFAULT 0,
  `order_index`     INT UNSIGNED NOT NULL DEFAULT 0,
  `ui_model_scene`  INT UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`decor_id`),
  KEY `por_objeto` (`gameobject_id`),
  KEY `por_item` (`item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `housing_decor_category` (
  `id`            INT UNSIGNED NOT NULL COMMENT 'DecorCategory.db2',
  `name`          VARCHAR(96)  NOT NULL DEFAULT '',
  `order_index`   INT UNSIGNED NOT NULL DEFAULT 0,
  `ui_atlas`      INT UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- De donde sale cada decoracion. Es la parte VARIABLE: varias fuentes por decoracion, con peso y
-- ventana de vigencia, para no tocar codigo cuando cambie la rotacion.
CREATE TABLE `housing_decor_source` (
  `decor_id`   INT UNSIGNED  NOT NULL,
  `source`     ENUM('quest','achievement','vendor','profession','order','event','initial') NOT NULL,
  `reference`  INT UNSIGNED  NOT NULL DEFAULT 0 COMMENT 'id de la mision, logro, vendedor o pedido',
  `quantity`   INT UNSIGNED  NOT NULL DEFAULT 1,
  `weight`     INT UNSIGNED  NOT NULL DEFAULT 1 COMMENT 'si hay varias fuentes, con que frecuencia',
  `valid_from` DATE          NULL COMMENT 'NULL = siempre',
  `valid_to`   DATE          NULL,
  PRIMARY KEY (`decor_id`, `source`, `reference`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `housing_level` (
  `level`           TINYINT UNSIGNED NOT NULL,
  `required_favor`  INT UNSIGNED     NOT NULL DEFAULT 0,
  `max_rooms`       INT UNSIGNED     NOT NULL DEFAULT 1,
  `max_decor`       INT UNSIGNED     NOT NULL DEFAULT 0,
  PRIMARY KEY (`level`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
