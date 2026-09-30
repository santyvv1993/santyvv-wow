-- ============================================================================
--  Camino central: quitar los objetos de COLISION del paso (la "pared invisible")
-- ============================================================================
--  Medido en vivo (Santiago, run 4): la escalera ya estaba abierta y no podia pasar:
--  delante hay un GO **tipo 5 (generico)** llamado `Collision Wall`
--  (entrada 278820, spawn 7000160, en y 2389.8; la escalera esta en y 2415.9).
--
--  El `destrabar` y el vigilante solo tratan puertas (tipo 0) y muros destructibles,
--  a proposito: no abren cosas que no sean de paso. Una pared de colision es
--  generica, asi que quedaba afuera. Se declara por estancia y la regla del camino
--  central la DESPENSA (Delete) al abrir el paso; el comando manual hace lo mismo.
-- ============================================================================

ALTER TABLE `mitica_estancia`
  ADD COLUMN `camino_quitar` varchar(255) NOT NULL DEFAULT ''
      COMMENT 'spawnIds de gameobjects a despenzar (paredes de colision) al abrir el camino al jefe final, separados por espacio' AFTER `camino_go`;

UPDATE `mitica_estancia`
   SET `camino_quitar` = '7000160'
 WHERE `cm_id` = 244;
