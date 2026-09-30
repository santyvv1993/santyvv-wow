-- ============================================================================
--  Cofre de recompensa de la mitica+ (el que falta para que la corrida cierre como retail)
-- ============================================================================
--  Pedido: "lo del cofre y loot". El cofre YA existe en la TDB (252064 "Grand Challenger's Bounty")
--  pero es tipo 51 (GAMEOBJECT_TYPE_CHALLENGE_MODE_REWARD) y el core **no tiene logica para ese tipo**
--  ("Use()" cae en el default y no pasa nada al hacerle clic).
--
--  Como funciona ahora (todo dato + un manejador nuestro):
--   1. El clic del cliente sobre un objeto usable llega a `WorldSession::HandleGameobjectReportUse`
--      -> `go->AI()->OnReportUse(player)` (SpellHandler.cpp) y, si el objeto es un goober con gossip,
--      `GameObject::Use` -> `AI()->OnGossipHello(player)` (GameObject.cpp). El cofre pasa a **goober**
--      (tipo 10) para usar el camino YA PROBADO con las palancas de la estancia.
--   2. `ScriptName = go_cofre_mitica` (nuestro GameObjectAI en scripts/Custom/miticas_custom.cpp).
--   3. El botin por estancia es la tabla `mitica_cofre_item` (dato puro).
--   4. El motor crea el item con el contexto `MythicPlus_End_of_Run` Y EL NIVEL DE LA PIEDRA
--      (`ItemBonusMgr::GetBonusListsForItem(item, { contexto, nivelPiedra })`), que es lo que hace que
--      el objeto salga del nivel que corresponde y no "pelado".
--
--  De donde salen los 45 items: del DIARIO DEL PROPIO CLIENTE (DB2 JournalInstance 968 Atal'Dazar ->
--  JournalEncounter 2030/2036/2082/2083 -> JournalEncounterItem). La TDB de contenido moderno NO trae
--  botin para estas estancias (creature_template_difficulty.LootID = 0), asi que el diario es la fuente
--  real. Reproducible con D:/hermes/workspace/wow-cofre/pool_ataldazar.py.
-- ============================================================================

CREATE TABLE IF NOT EXISTS `mitica_cofre_item` (
  `cm_id` int unsigned NOT NULL COMMENT 'estancia (world.mitica_estancia.cm_id)',
  `item`  int unsigned NOT NULL COMMENT 'item del botin del cofre',
  PRIMARY KEY (`cm_id`, `item`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Botin del cofre de recompensa por estancia';

DELETE FROM `mitica_cofre_item` WHERE `cm_id` = 244;

INSERT INTO `mitica_cofre_item` (`cm_id`, `item`) VALUES
(244, 155860),
(244, 155861),
(244, 155866),
(244, 155868),
(244, 155869),
(244, 158303),
(244, 158304),
(244, 158306),
(244, 158308),
(244, 158309),
(244, 158313),
(244, 158315),
(244, 158317),
(244, 158319),
(244, 158320),
(244, 158321),
(244, 158322),
(244, 158323),
(244, 158347),
(244, 158348),
(244, 158375),
(244, 158711),
(244, 158712),
(244, 158713),
(244, 159233),
(244, 159358),
(244, 159445),
(244, 159458),
(244, 159610),
(244, 159632),
(244, 159841),
(244, 160212),
(244, 160214),
(244, 160269),
(244, 211401),
(244, 211402),
(244, 211403),
(244, 211404),
(244, 211405),
(244, 239068),
(244, 239069),
(244, 239070),
(244, 239071),
(244, 239072),
(244, 239073);


-- El cofre: de tipo 51 (sin logica en el core) a goober con gossip y nuestro manejador.
-- Data2 = el id del menu de gossip (la forma de un goober que responde al clic).
UPDATE `gameobject_template`
   SET `type` = 10,
       `Data0` = 0,
       `Data1` = 0,
       `Data2` = 900245,
       `AIName` = '',
       `ScriptName` = 'go_cofre_mitica'
 WHERE `entry` = 252064;

-- El menu del cofre existe como dato (aunque el manejador entregue el botin sin abrir ventana).
INSERT INTO `gossip_menu` (`MenuID`, `TextID`, `VerifiedBuild`) VALUES (900245, 900245, 69497)
  ON DUPLICATE KEY UPDATE `TextID` = VALUES(`TextID`);

INSERT INTO `npc_text` (`ID`, `Probability0`, `BroadcastTextID0`, `VerifiedBuild`) VALUES (900245, 1, 900245, 69497)
  ON DUPLICATE KEY UPDATE `BroadcastTextID0` = VALUES(`BroadcastTextID0`);

-- (el texto visible del dialogo va en la migracion de hotfixes)
