-- ============================================================================
--  Texto del cofre de recompensa (el dialogo del gossip)
-- ============================================================================
--  Los textos visibles de un gossip salen de `hotfixes.broadcast_text` (la base `world` solo guarda
--  los ids). Id 900245, el mismo que referencian `npc_text` y el `Data2` del gameobject 252064 de la
--  migracion 40 del world. El manejador entrega el botin sin abrir ventana, asi que este texto es el
--  respaldo que veria el cliente si alguien pidiera el menu.
-- ============================================================================

INSERT INTO `broadcast_text` (`ID`, `Text`, `Text1`, `LanguageID`, `ConditionID`, `EmotesID`, `Flags`, `ChatBubbleDurationMs`, `VoiceOverPriorityID`, `SoundKitID1`, `SoundKitID2`, `EmoteID1`, `EmoteID2`, `EmoteID3`, `EmoteDelay1`, `EmoteDelay2`, `EmoteDelay3`, `VerifiedBuild`) VALUES
(900245, 'El cofre de la expedicion. Tu recompensa esta adentro.', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 69497)
ON DUPLICATE KEY UPDATE `Text` = VALUES(`Text`);
