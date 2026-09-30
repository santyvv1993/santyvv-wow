-- ============================================================================
--  Obsequios por correo con el CONTEXTO de dificultad (nivel de objeto real)
-- ============================================================================
--  Por que existe: el nivel de objeto que dibuja el cliente NO es el del DB2
--  (ItemSparse.ItemLevel: el botin del Abismo Venenoso tiene 219 de base), sino ese
--  mas los bonus de la dificultad. Quien los aplica es el core, a partir del
--  ItemContext: `.send items` crea los items con ItemContext::NONE (salen a 219),
--  mientras que con Raid_Normal la guia de aventura muestra 302.
--
--  El comando `.mitica obsequio <personaje> <conjunto>` (miticas_custom.cpp) lee
--  estas dos tablas, crea cada item con Item::CreateItem(id, cantidad, contexto)
--  -- el mismo camino que usa el botin -- y lo manda por correo, en tandas de 16
--  (MAX_MAIL_ITEMS). El nivel de objeto calculado queda en el log (scripts.miticas).
--
--  Contextos validos (ItemContext, DBCEnums.h): NONE, Dungeon_Normal, Dungeon_Heroic,
--  Dungeon_Mythic, Raid_Normal, Raid_Raid_Finder, Raid_Heroic, Raid_Mythic,
--  Quest_Reward, Vendor, Timewalking, MythicPlus_End_of_Run.
-- ============================================================================

CREATE TABLE IF NOT EXISTS `mitica_obsequio` (
  `conjunto` VARCHAR(32)  NOT NULL,
  `contexto` VARCHAR(32)  NOT NULL,
  `asunto`   VARCHAR(96)  NOT NULL,
  `cuerpo`   VARCHAR(512) NOT NULL,
  PRIMARY KEY (`conjunto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `mitica_obsequio_item` (
  `conjunto` VARCHAR(32)  NOT NULL,
  `item_id`  INT UNSIGNED NOT NULL,
  `cantidad` INT UNSIGNED NOT NULL DEFAULT 1,
  `etiqueta` VARCHAR(64)  NOT NULL DEFAULT '',
  PRIMARY KEY (`conjunto`, `item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- El conjunto del Abismo Venenoso para paladin, sacado del diario del cliente
-- (JournalInstance 1320 = mapa 3004): las 5 piezas del conjunto de clase
-- "Radiancia de la llama consagrada" (271463-271468) mas el botin de la raid para
-- las ranuras que el conjunto de clase no cubre. Todos los ids salen de filtrar los
-- 118 items del diario por AllowableClass (bit 2 = paladin) y ranura.
INSERT INTO `mitica_obsequio` (`conjunto`, `contexto`, `asunto`, `cuerpo`) VALUES
('abismo-venenoso', 'Raid_Normal',
 'El Abismo Venenoso: conjunto completo',
 'Las cinco piezas del conjunto de clase Radiancia de la llama consagrada, mas cintura, pies, munecas, capa, cuello, dos anillos, dos abalorios, un arma de dos manos y el escudo, todo del botin del Abismo Venenoso. El nivel de objeto lo calcula el servidor segun la dificultad de la raid.')
ON DUPLICATE KEY UPDATE `contexto` = VALUES(`contexto`), `asunto` = VALUES(`asunto`), `cuerpo` = VALUES(`cuerpo`);

INSERT INTO `mitica_obsequio_item` (`conjunto`, `item_id`, `cantidad`, `etiqueta`) VALUES
('abismo-venenoso', 271465, 1, 'conjunto de clase: cabeza'),
('abismo-venenoso', 271463, 1, 'conjunto de clase: hombros'),
('abismo-venenoso', 271468, 1, 'conjunto de clase: pecho'),
('abismo-venenoso', 271464, 1, 'conjunto de clase: piernas'),
('abismo-venenoso', 271466, 1, 'conjunto de clase: manos'),
('abismo-venenoso', 268216, 1, 'cintura'),
('abismo-venenoso', 268218, 1, 'pies'),
('abismo-venenoso', 268228, 1, 'munecas'),
('abismo-venenoso', 268248, 1, 'capa'),
('abismo-venenoso', 268250, 1, 'cuello'),
('abismo-venenoso', 268249, 1, 'anillo'),
('abismo-venenoso', 268252, 1, 'anillo'),
('abismo-venenoso', 270160, 1, 'abalorio'),
('abismo-venenoso', 270161, 1, 'abalorio'),
('abismo-venenoso', 268213, 1, 'arma de dos manos (conjunto Mordedura de Zul''jan)'),
('abismo-venenoso', 268196, 1, 'escudo')
ON DUPLICATE KEY UPDATE `etiqueta` = VALUES(`etiqueta`), `cantidad` = VALUES(`cantidad`);
