-- ============================================================================
--  Fase 3 (parte 2): las constantes del puntaje y el puntaje en el panel de cierre
-- ============================================================================
--  1. Las constantes de la formula (ver `Mgr::CalcularPuntos` y la migracion de characters):
--
--        puntos = base + nivel_de_piedra x por_nivel + bono_de_medalla - muertes x por_muerte
--
--     Valores NUESTROS, elegidos para que una corrida corta de nivel 2 con medalla de plata ronde los
--     50-60 puntos (retail da ~60-70 en +2). Se cambian aca, sin recompilar.
--  2. El aviso del chat de cierre: se le agrega el puntaje (CONCAT, asi no depende del texto que tenga).
--  3. El panel de cierre del cliente: el campo `RunScore` del paquete pasa de 0 al puntaje real.
-- ============================================================================

INSERT INTO `mitica_config` (`clave`, `valor`) VALUES
('puntos_base', '25'),
('puntos_por_nivel', '12'),
('puntos_oro', '15'),
('puntos_plata', '8'),
('puntos_bronce', '0'),
('puntos_por_muerte', '3')
ON DUPLICATE KEY UPDATE `valor` = VALUES(`valor`);

-- El aviso de cierre ya existe: se le suma el puntaje una sola vez.
UPDATE `mitica_config`
   SET `valor` = CONCAT(`valor`, ' · {puntos} puntos')
 WHERE `clave` = 'aviso_cierre'
   AND `valor` NOT LIKE '%{puntos}%';

-- El campo RunScore del paquete de cierre (orden 11, f32) deja de ser 0. Se limita por `orden` porque
-- el orden 13 (NewDungeonScore) tambien es f32 y vale 0: sin el filtro se pisarian los dos.
UPDATE `mitica_paquete_campo`
   SET `valor` = '{{puntos}}',
       `nota` = 'puntaje de la corrida (formula propia, ver Mgr::CalcularPuntos)'
 WHERE `opcode` = 'SMSG_CHALLENGE_MODE_COMPLETE'
   AND `orden` = 11
   AND `tipo` = 'f32'
   AND `valor` = '0';
