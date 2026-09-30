-- ============================================================================
--  Las palancas de Atal'Dazar: el AIName correcto es SmartGameObjectAI
-- ============================================================================
--  La migracion 30 le puso `AIName = 'SmartAI'` a los goobers 288477/288478 y NO
--  alcanza: el cargador de SmartAI exige el nombre exacto del AI de OBJETO.
--  Medido en el log del servidor (DBErrors.log, reload del 20:02 y arranque del 20:48):
--
--    SmartAIMgr::LoadSmartAIFromDB: GameObject entry (288477) is not using
--    SmartGameObjectAI, skipped loading.
--
--  Es la validacion de SmartScriptMgr.cpp:129-133:
--      if (gameObjectInfo->AIName != "SmartGameObjectAI") { ...; continue; }
--
--  Y la propia TDB lo confirma: de todos los objetos con IA de datos,
--      SmartGameObjectAI = 504 filas
--      SmartAI           = 2 filas   <- eran justo estas dos palancas, mi error
--
--  De paso se limpia `data22 conditionID1 = 76784`: es una condicion de jugador del
--  cliente que puede hacer que la palanca pida "interaccion condicional" antes de
--  dejar usarla. Ninguna palanca necesita eso para abrir una reja propia, asi que se
--  deja en 0 (se puede restaurar si algun dia se quiere el gate original).
--
--  OJO: el AIName vive en la plantilla del objeto y el mundo lo cachea al arrancar:
--  NO existe `.reload gameobject_template` (solo del locale, del loot y de los quest
--  starter/ender), asi que este cambio entra con el proximo reinicio.
-- ============================================================================

UPDATE `gameobject_template`
   SET `AIName` = 'SmartGameObjectAI',
       `data22` = 0
 WHERE `entry` IN (288477, 288478);
