-- ============================================================================
--  Yazma: las rejas estaban al reves (el guion las cerraba al morir)
-- ============================================================================
--  Medido en vivo (Santiago, run 4): las rejas del recinto de Yazma se cerraron al
--  entrar en combate y NUNCA se volvieron a abrir.
--
--  La causa: los valores de `SMART_ACTION_GO_SET_GO_STATE` (accion 118) son el estado
--  crudo del objeto, y en el core
--      GO_STATE_ACTIVE = 0   <- puerta ABIERTA (SharedDefines.h:3277, "closed door open")
--      GO_STATE_READY  = 1   <- puerta CERRADA
--  La accion lo pasa tal cual (SmartScript.cpp:1957: SetGoState((GOState)param1)).
--
--  Mis filas de Yazma estaban invertidas:
--      RESET  (id 3, 4)  -> 1 = CERRADA  (debia dejarlas abiertas en reposo)
--      AGGRO  (id 20,21) -> 0 = ABIERTA  (debia sellar el recinto)
--      DEATH  (id 30,31) -> 1 = CERRADA  (debia abrirlas al morir)   <-- el bug que se vio
--
--  Se corrigen los seis valores y ademas el estado de NACIMIENTO de las dos rejas en el
--  mundo (gameobject.state): como el diseño dice "en reposo el recinto no esta sellado",
--  nacen abiertas (0). Lo mismo aplica a la reja que ya estaba arreglada por el destrabar.
-- ============================================================================

UPDATE `smart_scripts` SET `action_param1` = 0
 WHERE `entryorguid` = 122968 AND `source_type` = 0 AND `id` IN (3, 4);   -- RESET: abrir

UPDATE `smart_scripts` SET `action_param1` = 1
 WHERE `entryorguid` = 122968 AND `source_type` = 0 AND `id` IN (20, 21);  -- AGGRO: cerrar

UPDATE `smart_scripts` SET `action_param1` = 0
 WHERE `entryorguid` = 122968 AND `source_type` = 0 AND `id` IN (30, 31);  -- DEATH: abrir

-- Las dos rejas del recinto nacen abiertas (spawns 7000161 = Gate010, 7000162 = Gate009)
UPDATE `gameobject` SET `state` = 0 WHERE `guid` IN (7000161, 7000162);
