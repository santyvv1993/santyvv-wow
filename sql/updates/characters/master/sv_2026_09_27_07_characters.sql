-- ============================================================================
-- character_account_bank: el oro del banco de cuenta (el "banco de tropa" del cliente)
-- ============================================================================
-- El campo AccountBankCoinage (ActivePlayerData) lo dibuja el cliente pero TrinityCore no lo
-- carga ni lo guarda: sin esta tabla, depositar oro lo hacia desaparecer al relogear.
-- Una fila por personaje; se escribe en cada movimiento (Player::SetAccountBankMoney) y se lee
-- al entrar (Player::LoadAccountBankMoney).
--
-- Verificado contra la captura del oficial del 27-sep-2026: al depositar, el servidor del oficial
-- actualiza Coinage y AccountBankCoinage del jugador en el mismo SMSG_UPDATE_OBJECT.
-- ============================================================================

CREATE TABLE IF NOT EXISTS `character_account_bank` (
    `guid`  INT UNSIGNED NOT NULL COMMENT 'guid del personaje (characters.characters.guid)',
    `money` BIGINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'cobre guardado en el banco de cuenta',
    PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Oro del banco de cuenta (campo AccountBankCoinage que el core no persiste)';
