-- ============================================================================
--  Paquetes que le dicen al cliente que la mitica+ esta ACTIVA
-- ============================================================================
--  Por que: de los paquetes de la familia de miticas, el armador solo conocia 3 nombres, y ademas
--  `SMSG_MYTHIC_PLUS_SEASON_DATA` / `_CURRENT_AFFIXES` estaban como `STATUS_UNHANDLED` en `Opcodes.cpp`
--  -- y el core **rechaza mandar** un opcode en ese estado (`Prevented sending disabled opcode`).
--  Sintoma tipico si falta: el cliente no muestra la UI de miticas+ aunque la corrida funcione.
--  Esta migracion es solo DATO (el formato); el nombre en el armador y el estado del opcode son codigo.
--
--  Formatos (fuente: docs/investigacion/hud-challenge-mode.md, seccion 6):
--   · SMSG_MYTHIC_PLUS_SEASON_DATA      = 1 bit `IsMythicPlusActive` (un byte, 0x80 = encendido).
--   · SMSG_MYTHIC_PLUS_CURRENT_AFFIXES  = u32 cantidad + cantidad x (i32 KeystoneAffixID, i32 RequiredSeason).
--     Se manda **un** afijo (el armador no sabe repetir bloques): el primero de la temporada.
-- ============================================================================

INSERT INTO `mitica_paquete` (`opcode`, `activo`, `descripcion`) VALUES
('SMSG_MYTHIC_PLUS_SEASON_DATA', 1, 'Le dice al cliente que la mitica+ esta activa (1 bit)'),
('SMSG_MYTHIC_PLUS_CURRENT_AFFIXES', 1, 'Los afijos de la temporada (se manda 1)')
ON DUPLICATE KEY UPDATE `activo` = VALUES(`activo`), `descripcion` = VALUES(`descripcion`);

DELETE FROM `mitica_paquete_campo` WHERE `opcode` IN ('SMSG_MYTHIC_PLUS_SEASON_DATA', 'SMSG_MYTHIC_PLUS_CURRENT_AFFIXES');

INSERT INTO `mitica_paquete_campo` (`opcode`, `orden`, `tipo`, `valor`, `nota`) VALUES
('SMSG_MYTHIC_PLUS_SEASON_DATA', 0, 'u8', '128', 'bit IsMythicPlusActive empaquetado: 0x80 = encendido');

INSERT INTO `mitica_paquete_campo` (`opcode`, `orden`, `tipo`, `valor`, `nota`) VALUES
('SMSG_MYTHIC_PLUS_CURRENT_AFFIXES', 0, 'u32', '1', 'cuantos afijos siguen (un bloque)'),
('SMSG_MYTHIC_PLUS_CURRENT_AFFIXES', 1, 'i32', '{{afijos}}', 'el primer afijo de la corrida (strtoul corta en el espacio)'),
('SMSG_MYTHIC_PLUS_CURRENT_AFFIXES', 2, 'i32', '{{temporada}}', 'temporada requerida por ese afijo');
