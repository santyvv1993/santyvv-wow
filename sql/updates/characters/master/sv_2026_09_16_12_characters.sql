-- ============================================================================
-- mitica_piedra: datos que el core NO persiste de una piedra angular mitica
-- ============================================================================
-- El item de la piedra (180653) no alcanza: para que el cliente sepa de que
-- mazmorra y de que nivel es, el servidor manda MODIFICADORES de item
-- (17 = mapa de desafio, 18 = nivel, 19..22 = afijos) que TrinityCore no guarda.
-- Esta tabla es la fuente de verdad; src/server/scripts/Custom/miticas_custom.cpp
-- los reaplica al entrar el personaje.
--
-- cm_id = id de MapChallengeMode del cliente (NO es el map id: Atal'Dazar = 244).
-- Ver docs/inventario/miticas/estancias-miticas.csv y listas-bonus-piedra.csv.
-- ============================================================================

CREATE TABLE IF NOT EXISTS `mitica_piedra` (
    `item_guid`   BIGINT UNSIGNED NOT NULL COMMENT 'guid del item en characters.item_instance',
    `personaje`   INT UNSIGNED    NOT NULL COMMENT 'guid del personaje que la lleva (characters.characters.guid)',
    `cm_id`       INT UNSIGNED    NOT NULL COMMENT 'MapChallengeModeID: de que mazmorra es la piedra',
    `nivel`       TINYINT UNSIGNED NOT NULL DEFAULT 2 COMMENT 'nivel de la piedra (el que escala vida/dano/recompensa)',
    `afijos`      VARCHAR(64)     NOT NULL DEFAULT '' COMMENT 'ids de afijo separados por espacio (hasta 4)',
    `creada`      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`item_guid`),
    KEY `idx_personaje` (`personaje`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Piedras angulares miticas (modificadores que el core no persiste)';
