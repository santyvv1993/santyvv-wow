-- ============================================================================
--  Juguete "Percha de ohuna" (item 194885, hechizo 376664): que el NPC invocado
--  sirva de BUZON de verdad.
-- ============================================================================
--  Medido en vivo: el juguete SI invoca la criatura 197329 ("Ohuna Perch",
--  modelo 109512), o sea que el lado del hechizo funciona; lo que falta es la
--  funcion de buzon: su plantilla trae npcflag = 0.
--
--  Quien gatea el buzon es el core, no el cliente:
--      MailHandler.cpp:55
--      if (!_player->GetNPCIfCanInteractWith(guid, UNIT_NPC_FLAG_MAILBOX, UNIT_NPC_FLAG_2_NONE))
--  o sea: si el NPC no tiene UNIT_NPC_FLAG_MAILBOX (0x04000000, UnitDefines.h:346),
--  el servidor rechaza el pedido de correo y el cliente nunca lo abre.
--
--  Los valores se copian de los NPC-buzon que YA funcionan en esta base por el mismo
--  camino (132969 "Katy Stampwhistle", que es el otro juguete-buzon del juego):
--      npcflag = 67108865 (mailbox | gossip) -> aca alcanza con mailbox (0x04000000)
--      faction = 35 (amistosa)
--      unit_flags = 768 (IMMUNE_TO_PC | IMMUNE_TO_NPC: no se puede atacar)
-- ============================================================================

UPDATE `creature_template`
   SET `npcflag`   = (`npcflag` | 0x04000000),
       `faction`   = 35,
       `unit_flags` = 768
 WHERE `entry` = 197329;
