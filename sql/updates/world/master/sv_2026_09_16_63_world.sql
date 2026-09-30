-- ============================================================================
--  Blazikon (208743): el spawn que faltaba + su RP
-- ============================================================================
--  CONTEXTO: Blazikon era el UNICO jefe de la temporada sin spawn. Su guion ya estaba escrito y cargado
--  (migracion 53) pero la criatura no existia en el mapa 2651, asi que al entrar a Grieta Llama Oscura se
--  pasaba de Ol' Waxbeard directo a El Rey Vela.
--
--  DE DONDE SALE LA POSICION (no es intuicion, y tampoco es una fuente directa):
--    1. Santiago leyo en la pagina de Wowhead: 41.5, 41.2. Se confirmo leyendo la propia pagina:
--       `var g_mapperData = {"14882":[{"count":1,"coords":[[41.5,41.2]]}]}` (el API de tooltip que se habia
--       usado antes devuelve ese campo vacio para NPC de mazmorra de TWW: por eso se habia concluido, mal,
--       que la posicion no estaba publicada).
--    2. Con los TRES jefes de la mazmorra que si tienen spawn se armo la conversion %->mundo (afin completa,
--       porque el modelo sin rotacion falla con residuos de 200-310 yd: el mapa NO esta alineado):
--         The Darkness    wowhead (81.8, 74.8) <-> mundo ( 393.3, -420.5)
--         Ol' Waxbeard    wowhead (22.4, 20.4) <-> mundo ( 601.8,   30.6)
--         The Candle King wowhead (41.5, 86.6) <-> mundo ( 105.2, -153.7)
--       Ojo: los entries de Wowhead NO siempre son los nuestros (El Rey Vela es 208745 aca y 222096 alla;
--       Ol' Waxbeard 210153/210149). Se unio POR NOMBRE verificando el titulo de la pagina, y se comprobo
--       que el display coincide (114508 en ambos) antes de aceptar el par.
--    3. ADVERTENCIA HONESTA: con tres puntos la afin es exacta por construccion, o sea que **no tiene error
--       medible**. Se intento juntar un cuarto punto barriendo los 31 NPC con nombre de la mazmorra, pero
--       Wowhead corta por volumen (502 paginas seguidas -> 0 resultados, cuando con pocas consultas
--       respondia). Por eso la posicion se corrobora por otros dos caminos independientes:
--         · Geometria: cae entre Ol' Waxbeard (1er jefe) y El Rey Vela (3ro), que es el orden del diario.
--         · Los vecinos: a 11 yd hay un **Royal Wicklighter** y a 28 yd un **Blazing Fiend** — los
--           Wicklighter son los adds de Blazikon (su ataque se llama "Wicklighter Barrage") y el Fiend es
--           tema de fuego. Estan a z 56, y el jefe se pone a z 56: el mismo nivel que sus propios adds.
--       Si en el juego aparece fuera de lugar, se corrige en 10 segundos con `.npc move` sin tocar esto.
--
--  La z (56) se toma de esos vecinos: Wowhead no publica altura.
--  Forma de la fila: copiada de un spawn real de la misma mazmorra (The Darkness 210797, guid 10004291),
--  mismos zoneId/areaId/spawnDifficulties. El guid 10004292 es el siguiente de ese bloque.
-- ============================================================================

SET @tiene_208743 = (SELECT COUNT(*) FROM `creature` WHERE `map` = 2651 AND `id` = 208743);
-- El guid NO se escribe a mano: se toma el siguiente libre. Escribirlo fijo fallo en la primera pasada
-- (10004292 ya estaba ocupado y el INSERT IGNORE no inserto nada en silencio: el guard salvo la base, pero
-- el spawn no ocurria). Con MAX(guid)+1 no hay forma de chocar.
SET @nuevo_guid = (SELECT MAX(`guid`) + 1 FROM `creature`);

INSERT IGNORE INTO `creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`, `phaseUseFlags`,
                              `PhaseId`, `PhaseGroup`, `terrainSwapMap`, `modelid`, `equipment_id`,
                              `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`,
                              `wander_distance`, `currentwaypoint`, `curHealthPct`, `MovementType`, `npcflag`,
                              `unit_flags`, `unit_flags2`, `unit_flags3`, `ScriptName`, `StringId`, `VerifiedBuild`)
SELECT @nuevo_guid, 208743, 2651, 14882, 15023, '1,2,8,23', 0, 0, 0, -1, 0, 0,
       505.6, -117.1, 56.0, 0, 7200, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 56647
  FROM DUAL
 WHERE COALESCE(@tiene_208743, 0) = 0;

-- ── Su RP, con la misma receta append-only de las migraciones 58-62 ────────────────────────────────
DELETE FROM `smart_scripts` WHERE `source_type` = 0 AND `entryorguid` = 208743 AND `id` BETWEEN 10 AND 19;
DELETE FROM `creature_text` WHERE `CreatureID` = 208743;

INSERT INTO `creature_text` (`CreatureID`, `GroupID`, `ID`, `Text`, `Type`, `Language`, `Probability`, `Emote`, `Duration`, `Sound`, `BroadcastTextId`, `TextRange`, `comment`) VALUES
(208743, 0, 0, '¡Se acabaron vuestras velas!', 14, 0, 100, 0, 0, 0, 0, 0, 'Blazikon: entra en combate'),
(208743, 1, 0, '¡Que arda todo lo que tocáis!', 14, 0, 100, 0, 0, 0, 0, 0, 'Blazikon: aviso de apagado/encendido'),
(208743, 2, 0, '¡Una vela más para mi colección!', 14, 0, 100, 0, 0, 0, 0, 0, 'Blazikon: mata a un jugador'),
(208743, 3, 0, 'Mis velas... se... apagan...', 14, 0, 100, 0, 0, 0, 0, 0, 'Blazikon: muere');

INSERT INTO `smart_scripts`
(`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`,
 `event_param1`, `event_param2`, `event_param3`, `event_param4`,
 `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`,
 `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(208743, 0, 10, 0, 4, 0, 100, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Blazikon: grito al entrar en combate'),
(208743, 0, 11, 0, 2, 0, 100, 1, 0, 50, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Blazikon: aviso al bajar del 50%'),
(208743, 0, 12, 0, 5, 0, 100, 0, 0, 0, 0, 0, 1, 2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Blazikon: grito al matar'),
(208743, 0, 13, 0, 6, 0, 100, 0, 0, 0, 0, 0, 1, 3, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Blazikon: grito al morir');
