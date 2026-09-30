-- ============================================================================
--  Texto del NPC de salida (el dialogo y la opcion del gossip)
-- ============================================================================
--  Los textos visibles de un gossip en este core salen de `hotfixes.broadcast_text`
--  (la base `world` solo guarda los IDs). Se crea uno propio con id 900244, el mismo
--  que referencian `npc_text` y `gossip_menu_option` de la migracion 39 del world.
-- ============================================================================

INSERT INTO `broadcast_text` (`ID`, `Text`, `Text1`, `LanguageID`, `ConditionID`, `EmotesID`, `Flags`, `ChatBubbleDurationMs`, `VoiceOverPriorityID`, `SoundKitID1`, `SoundKitID2`, `EmoteID1`, `EmoteID2`, `EmoteID3`, `EmoteDelay1`, `EmoteDelay2`, `EmoteDelay3`, `VerifiedBuild`) VALUES
(900244, 'Ya esta hecho: la expedicion termino. Si quieres, te saco de la estancia.', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 69497)
ON DUPLICATE KEY UPDATE `Text` = VALUES(`Text`);
