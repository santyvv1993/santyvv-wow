-- ============================================================================
-- Claves de config para el escalado, las fuerzas y el cierre (nada quemado)
-- ============================================================================

INSERT INTO `mitica_config` (`clave`, `valor`, `descripcion`) VALUES
 ('fuerzas_normal',      '1', 'fuerzas que aporta una criatura normal al morir (%)')
,('fuerzas_elite',       '2', 'fuerzas de una criatura elite (%)')
,('fuerzas_rareelite',   '3', 'fuerzas de una criatura elite rara (%)')
,('fuerzas_rare',        '2', 'fuerzas de una criatura rara (%)')
,('jefe_final_cierra',   '1', '1 = matar al jefe de la mazmorra cierra la corrida (medalla + cierre)')
,('worldstate_fuerzas',  '0', 'id del worldstate de fuerzas del HUD (0 = no mandarlo todavia)')
,('worldstate_muertes',  '0', 'id del worldstate del contador de muertes (0 = no mandarlo)')
,('escalado_vida',       '1', '1 = aplicar vida_pct/dano_pct de mitica_nivel a las criaturas de la corrida')
ON DUPLICATE KEY UPDATE `valor` = VALUES(`valor`), `descripcion` = VALUES(`descripcion`);
