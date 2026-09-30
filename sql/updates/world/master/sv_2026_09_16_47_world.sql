-- ============================================================================
--  Dos correcciones de contenido (TDB 12.x) halladas por un fork moderno:
--  AlgalonCore (MShkolenko/AlgalonCore, GPL-2, TrinityCore pinneado en 11.2.7),
--  migraciones sql/updates/world/master/2026_09_03_00 y 2026_09_12_00.
--  Se verifico PRIMERO que el defecto existe en nuestra base antes de copiarlo.
-- ============================================================================
--
--  1) Quest 55660 "Time Trials" — se ofrece a nivel 1.
--
--  El core reparte solo las misiones con QUEST_FLAGS_EX_AUTO_PUSH (FlagsEx =
--  0x04000000, ver src/server/game/Quests/QuestDef.h:278): Player::PushQuests()
--  las entrega al entrar al mundo, al subir de nivel y en CADA cambio de area.
--  Medido en nuestra base: 55660 tiene FlagsEx 0x06000080 -> el bit esta puesto
--  y NO tiene ninguna condicion de oferta, asi que un personaje de nivel 1-2
--  recibe una semanal de nivel maximo en cuanto cambia de zona.
--  (Alcance: hay 67 misiones con ese bit y NINGUNA con filtro de nivel; se deja
--  anotado para revisarlas una por una, aca se corrige la que esta documentada.)
--
--  El arreglo no necesita codigo: CanTakeQuest() consulta las condiciones de
--  origen 19 (oferta de mision) y PushQuests() pasa por ahi, asi que una
--  condicion de tipo 27 (nivel) frena el reparto en la fuente. Se usa el tope
--  de ESTE servidor (MaxPlayerLevel = 90 en bin/worldserver.conf), no el 80 del
--  fork del que sale la receta.
--
--  2) Quest 63447 "Fear No Evil" (variante de monje) — no se puede completar.
--
--  La condicion del spellclick de la criatura 50047 -> hechizo 93072 listaba
--  ocho misiones (28806-28813 y 29082) pero NO la 63447, aunque la 63447 existe
--  en esta base con su objetivo sobre 50047 (18 apariciones). Un monje con la
--  63447 hace clic y el core lo rechaza por condicion: ni hechizo ni credito.
--  Medido en AlgalonCore en vivo: 22 clics en cuatro minutos, cero creditos.
-- ============================================================================

-- 1) Time Trials: ofrecerla solo a nivel maximo
DELETE FROM `conditions`
 WHERE `SourceTypeOrReferenceId` = 19 AND `SourceEntry` = 55660 AND `ConditionTypeOrReference` = 27;

INSERT INTO `conditions`
  (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`,
   `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`,
   `ConditionValue3`, `ConditionStringValue1`, `NegativeCondition`, `ErrorType`, `ErrorTextId`,
   `ScriptName`, `Comment`)
VALUES
  (19, 0, 55660, 0, 0, 27, 0, 90, 3, 0, '', 0, 0, 0, '',
   'Quest 55660 Time Trials is auto-pushed on every area change - offer it only at max level (90)');

-- 2) Fear No Evil: la variante de monje tambien puede hacer clic en el herido
DELETE FROM `conditions`
 WHERE `SourceTypeOrReferenceId` = 18 AND `SourceGroup` = 50047 AND `SourceEntry` = 93072
   AND `ConditionValue1` = 63447;

INSERT INTO `conditions`
  (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`,
   `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`,
   `ConditionValue3`, `ConditionStringValue1`, `NegativeCondition`, `ErrorType`, `ErrorTextId`,
   `ScriptName`, `Comment`)
VALUES
  (18, 50047, 93072, 0, 8, 9, 0, 63447, 0, 0, '', 0, 0, 0, '',
   'Requires Fear No Evil quest active for spellclick');
