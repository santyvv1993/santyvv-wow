-- ============================================================================
--  Camino central de las estancias: que se abra cuando mueren los jefes
-- ============================================================================
--  Pedido de Santiago (16-sep, jugando la +2 de Atal'Dazar): "intentemos que
--  funcione como retail" -> el paso al jefe final se abre cuando mueren los jefes
--  principales, y `.mitica destrabar` queda como ULTIMA accion si algo falla.
--
--  Medido antes de tocar nada (Atal'Dazar, mapa 1763):
--   * La escalera del camino central es `Doodad_8DU_CityofGold_WaterfallStairs001`
--     (entrada 278422, spawn 7000156, x -847.8 y 2415.9 z 678.2) y es un GO tipo 0
--     (puerta) con TODOS sus datos en 0: nace cerrada y no hay nadie que la abra.
--   * El guion de la instancia solo maneja las 4 puertas de Vol'kaal.
--   * La "cinematica" que se recuerda es el MOVIMIENTO de esa escalera: abrir la
--     puerta dispara la animacion propia del objeto (no es una pelicula, no hace
--     falta SendMovieStart ni ningun DB2 Movie).
--
--  Como funciona ahora (MythicPlusMgr::AbrirCaminoCentral): el motor ya vigila la
--  instancia cada 5 s, asi que cuando no queda vivo ninguno de los entries de
--  `camino_jefes` (y se los vio vivos antes: una instancia recien cargada no cuenta),
--  abre `camino_go` con el mismo camino que un jugador (`UseDoorOrButton`) y avisa al
--  grupo. El vigilante automatico NO toca ese objeto; el comando manual si.
-- ============================================================================

ALTER TABLE `mitica_estancia`
  ADD COLUMN `camino_jefes` varchar(64) NOT NULL DEFAULT ''
      COMMENT 'entries de los jefes que abren el camino al jefe final, separados por coma' AFTER `jefe_final`,
  ADD COLUMN `camino_go` int unsigned NOT NULL DEFAULT 0
      COMMENT 'spawnId del gameobject de paso (escalera/reja) que se abre al morir camino_jefes' AFTER `camino_jefes`;

-- Atal'Dazar: los 3 jefes de encuentro (Rezan 122963, Vol'kaal 122965, Alun'za 122967) abren la
-- escalera del centro (spawn 7000156). Yazma (122968) queda afuera: es el jefe final, el que cierra.
UPDATE `mitica_estancia`
   SET `camino_jefes` = '122963,122965,122967',
       `camino_go`    = 7000156
 WHERE `cm_id` = 244;

INSERT INTO `mitica_config` (`clave`, `valor`, `descripcion`) VALUES
('camino_central', '1',
 'abrir el paso al jefe final cuando mueren los jefes de camino_jefes (como retail; 0 = solo el comando manual)'),
('aviso_camino', 'Las escaleras se mueven: el camino al jefe final quedo abierto.',
 'texto que recibe el grupo cuando se abre el camino central')
ON DUPLICATE KEY UPDATE `valor` = VALUES(`valor`), `descripcion` = VALUES(`descripcion`);
