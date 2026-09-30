-- =====================================================================
-- Miticas+ : nivel del contenido
-- ---------------------------------------------------------------------
-- Las mazmorras de expansiones viejas traen sus criaturas en el nivel de
-- esa expansion (Atal'Dazar, BfA = 50), asi que una corrida con personajes
-- del nivel actual se sentiria trivial. Antes de aplicar la curva del nivel
-- de piedra, el motor sube cada criatura al nivel del miembro mas alto del
-- grupo y le pide al core que recalcule vida, dano, mana y armadura.
-- =====================================================================

INSERT INTO `mitica_config` (`clave`, `valor`, `descripcion`) VALUES
('subir_nivel_grupo', '1', 'Subir las criaturas al nivel del grupo antes de escalar por nivel de piedra (1 = si, 0 = no)')
ON DUPLICATE KEY UPDATE `descripcion` = VALUES(`descripcion`);
