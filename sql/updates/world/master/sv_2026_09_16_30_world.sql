-- ============================================================================
--  Atal'Dazar: que las PALANCAS abran sus rejas (dato puro, sin compilar)
-- ============================================================================
--  Medido en vivo el 16-sep (Santiago, corriendo la +2): al lado de la palanca la
--  reja no abria. Los datos dicen por que:
--
--  * Las palancas son goobers (gameobject_template.type = 10), entradas 288477 y
--    288478, y TODOS sus mecanismos estan en cero:
--        data10 spell      = 0   (no lanza nada)
--        data12 linkedTrap = 0   (no dispara ninguna trampa/reja)
--        data19 gossipID   = 0   (no tiene menu de gossip)
--        ScriptName = ''  AIName = ''   (no tiene guion ni IA)
--      Lo unico que traen es data2 eventID = 63723, que dispara el evento de juego
--      63723 y no lo maneja nadie.
--  * Las rejas Gate001..Gate004 (entradas 288202..288205, spawns 7000147..7000150)
--    tienen TODOS sus datos en cero: data0 startOpen = 0 -> nacen cerradas y no hay
--    quien las abra. El guion de la instancia solo maneja las 4 de Vol'kaal
--    (GO_VOLKAAL_DOOR_1..4 = entradas 292399..292402 = Gate005..Gate008).
--
--  Por que esta receta funciona (verificado en el codigo del core):
--  * GameObject::Use() llama a AI()->OnGossipHello(playerUser) en CADA uso de
--    cualquier objeto (GameObject.cpp:2638), asi que el evento 64 de SmartAI
--    (SMART_EVENT_GOSSIP_HELLO) se dispara al usar la palanca, sin necesitar gossip.
--  * La accion 118 (SMART_ACTION_GO_SET_GO_STATE, SmartScriptMgr.h:576) acepta
--    gameobjects como origen y el target 14 (SMART_TARGET_GAMEOBJECT_GUID,
--    SmartScriptMgr.h:1325) apunta a una reja concreta por spawn guid + entrada.
--  * El estado 1 = GO_STATE_ACTIVE = puerta abierta (lo mismo que hace el jugador
--    con la mano y lo mismo que usa la red de seguridad de miticas).
--
--  Correspondencia por cercania (medida): palanca de x -966 (spawn 7000152) ->
--  Gate001/Gate002 (x -956); palanca de x -729.3 (spawn 7000153) -> Gate003/Gate004
--  (x -739.6).
-- ============================================================================

UPDATE `gameobject_template` SET `AIName` = 'SmartAI' WHERE `entry` IN (288477, 288478);

DELETE FROM `smart_scripts` WHERE `entryorguid` IN (288477, 288478) AND `source_type` = 1;

INSERT INTO `smart_scripts`
    (`entryorguid`, `source_type`, `id`, `link`, `Difficulties`,
     `event_type`, `event_phase_mask`, `event_chance`, `event_flags`,
     `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param_string`,
     `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`,
     `action_param6`, `action_param7`, `action_param_string`,
     `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_param_string`,
     `target_x`, `target_y`, `target_z`, `target_o`, `comment`)
VALUES
(288478, 1, 0, 0, '', 64, 0, 100, 0, 0, 0, 0, 0, 0, '', 118, 1, 0, 0, 0, 0, 0, 0, '', 14, 7000148, 288204, 0, 0, '', 0, 0, 0, 0,
 'Palanca antigua (oeste): abre Gate001 al usarla'),
(288478, 1, 1, 0, '', 64, 0, 100, 0, 0, 0, 0, 0, 0, '', 118, 1, 0, 0, 0, 0, 0, 0, '', 14, 7000149, 288205, 0, 0, '', 0, 0, 0, 0,
 'Palanca antigua (oeste): abre Gate002 al usarla'),
(288477, 1, 0, 0, '', 64, 0, 100, 0, 0, 0, 0, 0, 0, '', 118, 1, 0, 0, 0, 0, 0, 0, '', 14, 7000147, 288202, 0, 0, '', 0, 0, 0, 0,
 'Palanca antigua (este): abre Gate003 al usarla'),
(288477, 1, 1, 0, '', 64, 0, 100, 0, 0, 0, 0, 0, 0, '', 118, 1, 0, 0, 0, 0, 0, 0, '', 14, 7000150, 288203, 0, 0, '', 0, 0, 0, 0,
 'Palanca antigua (este): abre Gate004 al usarla');
