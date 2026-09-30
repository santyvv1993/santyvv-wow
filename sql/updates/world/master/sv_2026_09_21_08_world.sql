-- SV migracion sv_2026_09_21_08_world.sql
--
-- Escalado por estancia (Fase 2 de docs/DISENO-DUNGEONS-ESCALABLES.md): crea la PERILLA.
--
-- Por que una tabla y no codigo: el modo de cada estancia y su banda son decisiones de contenido
-- (que juega a nivel 50, que sube al grupo, que queda como el cliente lo declara). Se corrigen con
-- un UPDATE, sin recompilar, que es la regla que venimos usando para todo lo que es dato.
--
-- La lee `Trinity::Instancias::EscaladoMgr` (src/server/game/Instancias/) al arrancar el mundo, y la
-- aplica cuando la criatura entra al mapa (Creature::SelectLevel), no solo al arrancar una corrida:
-- asi tambien quedan escaladas las oleadas, las invocadas y los jefes que se suman a mitad.
--
-- Modos:
--   cliente : no se toca nada. DEFECTO. Es el comportamiento medido del oficial (el rango sale del
--             ContentTuning del mapa/dificultad y el delta del dato de la criatura).
--   rango   : la estancia juega en la banda [nivel_min, nivel_max]; el rotulo pasa a ser
--             clamp(nivelDelJugador, min, max) + delta.
--   grupo   : el contenido sube al nivel del miembro mas alto del grupo presente.
-- difficulty 65535 = cualquier dificultad del mapa (la regla exacta tiene prioridad sobre esta).
--
-- SIN FILA NO PASA NADA: el sistema es transparente por defecto.

CREATE TABLE IF NOT EXISTS `instancia_escalado` (
  `map` int unsigned NOT NULL,
  `difficulty` smallint unsigned NOT NULL DEFAULT 65535,
  `modo` varchar(12) NOT NULL DEFAULT 'cliente',
  `nivel_min` tinyint unsigned NOT NULL DEFAULT 0,
  `nivel_max` tinyint unsigned NOT NULL DEFAULT 0,
  `nota` varchar(190) NOT NULL DEFAULT '',
  PRIMARY KEY (`map`,`difficulty`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  COMMENT='Escalado por estancia (F2): modo cliente|rango|grupo por mapa y dificultad';

-- 1) Miticas+: al nivel del grupo. Ya lo hacia la corrida al arrancar; declararlo aca hace que valga
--    tambien para lo que aparece despues (que era el limite conocido de la Fase 1).
--    Va con "cualquier dificultad" a proposito: nuestro sistema de miticas+ no cambia la dificultad
--    de la instancia (comprobado: no hay SetSpawnMode en el camino de miticas), asi que atarlo a la
--    dificultad 8 no dispararia nunca.
INSERT INTO `instancia_escalado` (`map`, `difficulty`, `modo`, `nota`)
SELECT `map_id`, 65535, 'grupo', CONCAT('Miticas+: el contenido sube al nivel del grupo (', `nombre`, ')')
FROM `mitica_estancia`
ON DUPLICATE KEY UPDATE `modo` = VALUES(`modo`), `nota` = VALUES(`nota`);

-- 2) Cronoviaje de Cataclysm: se deja en 'cliente' A PROPOSITO y queda escrito por que. Medido en vivo
--    el 21-sep-2026 (358 MB): el mapa declara el rango (10, 90) y el oficial rota jefes +2 (Rom'ogg,
--    Raz, Corla, Karsh, Beauty, Obsidius / Lady Naz'jar, Ulthok, Ghur'sha / Barim, Lockmaw, Husam,
--    Siamat), notables +1 y chusma 0. No hay nada que sobreescribir: es lo que ya hace el cliente.
INSERT INTO `instancia_escalado` (`map`, `difficulty`, `modo`, `nota`) VALUES
  (643, 24, 'cliente', 'Cronoviaje Cataclysm: el cliente ya hace clamp(nivel,10,90)+delta (medido 21-sep)'),
  (645, 24, 'cliente', 'Cronoviaje Cataclysm: idem; los 6 jefes a +2 medidos con nombre'),
  (755, 24, 'cliente', 'Cronoviaje Cataclysm: idem; mecanicas de guion en -2')
ON DUPLICATE KEY UPDATE `nota` = VALUES(`nota`);

-- 3) El ejemplo del pedido, puesto de verdad: "en el mundo funciona normal, en la mazmorra un nivel
--    50". Cavernas Roca Negra (645) en dificultad NORMAL (1) juega en banda 50-50: un personaje de
--    nivel 90 la ve a 50. No toca la dificultad de cronoviaje (24), que sigue como la mide el cliente.
INSERT INTO `instancia_escalado` (`map`, `difficulty`, `modo`, `nivel_min`, `nivel_max`, `nota`) VALUES
  (645, 1, 'rango', 50, 50, 'Ejemplo del pedido: la mazmorra normal juega a nivel 50 (banda 50-50)')
ON DUPLICATE KEY UPDATE `modo` = VALUES(`modo`), `nivel_min` = VALUES(`nivel_min`),
  `nivel_max` = VALUES(`nivel_max`), `nota` = VALUES(`nota`);
