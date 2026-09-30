-- ============================================================================
--  NPC de salida de la estancia (lo que aparece al cerrar la corrida)
-- ============================================================================
--  Pedido: "el npc que se presenta al final y nos da la opcion de salir de la estancia".
--
--  Piezas (todas dato, salvo el manejador del gossip que vive en
--  scripts/Custom/miticas_custom.cpp con el nombre de script `npc_mitica_salida`):
--   1. creature_template 900244 (clonado de 132969, que ya funciona) con ese ScriptName.
--   2. su modelo (creature_template_model).
--   3. el menu de gossip (gossip_menu + gossip_menu_option) y el dialogo (npc_text).
--      El texto visible sale de `hotfixes.broadcast_text` 900244 (migracion del otro lado).
--   4. el punto de salida por estancia: se toma del PROPIO trigger de salida del cliente
--      (`areatrigger_template_actions`: el AT 82 de Atal'Dazar es ActionType 2 = TELEPORT con
--      ActionParam 100055 = `world_safe_locs.ID` 100055 -> mapa 1642, -848.42 2028.05 726.19,
--      "8.x Dungeon - Atal Dazar - Exit"). O sea: el destino no lo inventamos, es el que el
--      cliente usa para sacarte de la mazmorra.
-- ============================================================================

INSERT INTO `creature_template` (`entry`, `KillCredit1`, `KillCredit2`, `name`, `femaleName`, `subname`, `TitleAlt`, `IconName`, `RequiredExpansion`, `VignetteID`, `faction`, `npcflag`, `speed_walk`, `speed_run`, `scale`, `Classification`, `dmgschool`, `BaseAttackTime`, `RangeAttackTime`, `BaseVariance`, `RangeVariance`, `unit_class`, `unit_flags`, `unit_flags2`, `unit_flags3`, `family`, `trainer_class`, `type`, `VehicleId`, `AIName`, `MovementType`, `ExperienceModifier`, `RacialLeader`, `movementId`, `WidgetSetID`, `WidgetSetUnitConditionID`, `RegenHealth`, `CreatureImmunitiesId`, `flags_extra`, `ScriptName`, `StringId`, `VerifiedBuild`) VALUES
(900244, 0, 0, 'Guia de la Expedicion', '', 'Te saca de la estancia', NULL, NULL, 0, 0, 35, 0, 1.0, 1.14286, 1.0, 0, 0, 2000, 2000, 1.0, 1.0, 8, 768, 2048, 0, 0, 0, 7, 0, '', 0, 1.0, 0, 0, 0, 0, 1, 0, 0, 'npc_mitica_salida', NULL, 69497);

INSERT INTO `creature_template_model` (`CreatureID`, `Idx`, `CreatureDisplayID`, `DisplayScale`, `Probability`, `VerifiedBuild`) VALUES
(900244, 0, 68512, 1, 1, 69497);

-- El menu que atiende nuestro manejador (el texto visible viene del broadcast text 900244)
INSERT INTO `npc_text` (`ID`, `Probability0`, `BroadcastTextID0`, `VerifiedBuild`) VALUES
(900244, 1, 900244, 69497);

INSERT INTO `gossip_menu` (`MenuID`, `TextID`, `VerifiedBuild`) VALUES
(900244, 900244, 69497);

INSERT INTO `gossip_menu_option` (`MenuID`, `GossipOptionID`, `OptionID`, `OptionNpc`, `OptionText`, `OptionBroadcastTextID`, `Language`, `Flags`, `ActionMenuID`, `ActionPoiID`, `GossipNpcOptionID`, `BoxCoded`, `BoxMoney`, `BoxText`, `BoxBroadcastTextID`, `SpellID`, `OverrideIconID`, `VerifiedBuild`) VALUES
(900244, 0, 0, 0, 'Llevame fuera de la estancia', 900244, 0, 0, 0, 0, NULL, 0, 0, NULL, 0, NULL, NULL, 69497);

-- Punto de salida por estancia (lo usa el NPC) y el NPC que aparece al cerrar
ALTER TABLE `mitica_estancia`
  ADD COLUMN `salida_npc` int unsigned NOT NULL DEFAULT 0
      COMMENT 'entry del NPC que aparece al cerrar la corrida para sacar al grupo de la estancia' AFTER `camino_quitar`,
  ADD COLUMN `salida_punto` varchar(64) NOT NULL DEFAULT ''
      COMMENT 'destino de la salida: "mapa x y z o" (se toma de areatrigger_template_actions/world_safe_locs)' AFTER `salida_npc`;

UPDATE `mitica_estancia`
   SET `salida_npc` = 900244,
       `salida_punto` = '1642 -848.42 2028.05 726.19 0'
 WHERE `cm_id` = 244;
