-- ============================================================================
--  Fase 3 (parte 2): puntaje de la corrida
-- ============================================================================
--  `mitica_corrida` no guardaba puntaje. Se agrega la columna y el motor la llena al cerrar la corrida
--  con una formula NUESTRA (retail usa la suya, mas compleja):
--
--     puntos = base + nivel_de_piedra x por_nivel + bono_de_medalla - muertes x por_muerte
--
--  Las constantes viven en `world.mitica_config` (ver la migracion del world del mismo numero), asi que
--  se ajustan sin recompilar. La formula esta escrita en `Mgr::CalcularPuntos`.
-- ============================================================================

ALTER TABLE `mitica_corrida`
  ADD COLUMN `puntos` int unsigned NOT NULL DEFAULT 0 COMMENT 'puntaje de la corrida (formula propia)' AFTER `medalla`;
