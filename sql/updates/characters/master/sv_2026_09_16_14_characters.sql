-- ============================================================================
-- mitica_corrida: la piedra que hay que devolver
-- ============================================================================
-- La piedra angular se CONSUME al arrancar la corrida (como en retail) y vuelve al cerrar. Si el
-- mundo se reinicia en medio, la corrida queda 'interrumpida' y la piedra tiene que volver igual:
-- esta columna dice si ya se devolvio. Al entrar al mundo, miticas_custom.cpp devuelve la piedra de
-- las corridas del lider con piedra_devuelta = 0 (asi un reinicio no se come la piedra de nadie).
--
-- Las corridas que ya existian quedan con 0 = "hay que devolverla". Es lo correcto: las que estan
-- abiertas se van a marcar 'interrumpida' al arrancar el mundo, y las que ya cerraron antes de este
-- cambio devolvian la piedra de otra forma (no la consumian).
-- ============================================================================

ALTER TABLE `mitica_corrida`
    ADD COLUMN `piedra_devuelta` TINYINT UNSIGNED NOT NULL DEFAULT 0
    COMMENT '1 = la piedra de esta corrida ya volvio al inventario del lider' AFTER `medalla`;
