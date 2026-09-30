-- ============================================================================
--  HUD de la mitica+: formato de los paquetes (fase 2, reconstruido con fuentes)
-- ============================================================================
--  Nuestro armador arma el paquete desde estas tablas. La version vieja (hipotesis de los cores 7.x)
--  tenia 28 bytes y un orden de campos distinto: el cliente dibujaba el panel de cierre con los numeros
--  corridos (mostro "se acabo el tiempo" con una medalla de plata y un tiempo de 1376 s).
--  Este formato sale de docs/investigacion/hud-challenge-mode.md (reconstruccion con fuentes del parser
--  y del Lua del cliente, verificado contra el opcode del build 12.1.0.69814).
--
--  Lo que va ADEMAS de esta migracion, y es codigo (no dato):
--   1. el temporizador del jugador (`ActivePlayerData.ChallengeModeData`, bit 134): el cliente lo lee de
--      ahi, no del paquete. Se marca al arrancar y se quita al cerrar (MythicPlusMgr.cpp).
--   2. el marcador {{segundos_ms}} (la duracion del cierre va en milisegundos).
--
--  Para apagar SOLO el paquete de cierre (si el formato nuevo se comporta raro en pantalla) alcanza:
--    UPDATE mitica_paquete SET activo = 0 WHERE opcode = 'SMSG_CHALLENGE_MODE_COMPLETE';
-- ============================================================================

-- ============================================================================
--  hud-paquete-propuesta.sql
--  Propuesta de formato para los paquetes del HUD de miticas+ (cliente 12.1.0.69814)
--
--  QUE ES: el formato de SMSG_CHALLENGE_MODE_START / UPDATE_DEATH_COUNT / COMPLETE
--          se arma desde la base (world.mitica_paquete + world.mitica_paquete_campo),
--          asi que este archivo cambia el formato SIN recompilar. Las fuentes de cada
--          campo y el porque estan en docs/investigacion/hud-challenge-mode.md.
--
--  OJO CON LAS LLAVES: los marcadores en esta base van con DOBLE llave ({{cm_id}},
--  {{afijos}}), porque ResolverValor() hace valor.substr(2, size - 4) y el literal se
--  decide con valor[0] != '{'. Verificado con HEX(valor) = 7B7B...7D7D.
--  Un marcador con una sola llave NO se resuelve: se manda el texto crudo y strtoul lo
--  convierte en 0.
--
--  COMO SE APLICA (lo aplica el agente, no este archivo):
--      (la aplicacion la hace la herramienta del repo con sus propias credenciales)
--      (comando de aplicacion omitido a proposito)
--
--  COMO SE MIDE (sin adivinar):
--      1) Al arrancar una corrida el Server.log tiene que decir:
--         "paquete SMSG_CHALLENGE_MODE_START (37 bytes) enviado a <pj> [80]"
--         (37 bytes y, con el bit encendido, el control [80])
--      2) Mirar el cliente: barra de tiempo arriba, contador de muertes, fuerzas.
--
--  ALCANCE REAL DE ESTE ARCHIVO: el armador del core solo sabe traducir TRES nombres
--  de opcode (MythicPlusMgr.cpp, funcion OpcodeDeNombre: START, UPDATE_DEATH_COUNT,
--  COMPLETE). Cualquier otro SMSG_* de miticas+ (RESET, MYTHIC_PLUS_SEASON_DATA,
--  MYTHIC_PLUS_CURRENT_AFFIXES, SET_LEAVER_PENALTY_TIMER) NO se puede encender por SQL:
--  necesita una linea de codigo y compilar. Ver el informe, seccion 6.
--
--  TIPOS QUE SOPORTA EL ARMADOR: u8 u16 u32 i32 u64 f32 cadena array_u32.
--  No soporta: bits empaquetados (se mandan como u8 al final), bloques repetidos
--  (listas de jugadores), ni aritmetica en el valor.
--
--  ROLLBACK: al final del archivo esta el bloque para volver a la hipotesis anterior.
-- ============================================================================

USE `world`;

-- ---------------------------------------------------------------------------
-- 1) Limpieza (mitica_paquete_campo no tiene FK: se limpia primero por claridad)
-- ---------------------------------------------------------------------------
DELETE FROM `mitica_paquete_campo`
 WHERE `opcode` IN ('SMSG_CHALLENGE_MODE_START',
                    'SMSG_CHALLENGE_MODE_UPDATE_DEATH_COUNT',
                    'SMSG_CHALLENGE_MODE_COMPLETE');

DELETE FROM `mitica_paquete`
 WHERE `opcode` IN ('SMSG_CHALLENGE_MODE_START',
                    'SMSG_CHALLENGE_MODE_UPDATE_DEATH_COUNT',
                    'SMSG_CHALLENGE_MODE_COMPLETE');

INSERT INTO `mitica_paquete` (`opcode`, `activo`, `descripcion`) VALUES
('SMSG_CHALLENGE_MODE_START', 1,
 'arranque del HUD: MapID, ChallengeID, nivel, 4 afijos, muertes, 0 jugadores, 1 bit (37 bytes)'),
('SMSG_CHALLENGE_MODE_UPDATE_DEATH_COUNT', 1,
 'contador de muertes: un solo i32'),
('SMSG_CHALLENGE_MODE_COMPLETE', 1,
 'cierre: MythicPlusRun + puntaje + 4 bits (fase 2: estructura reconstruida, no verificada en vivo)');

-- ---------------------------------------------------------------------------
-- 2) SMSG_CHALLENGE_MODE_START  -- el que hace aparecer el HUD
--
--    Orden segun el parser de retail vigente (WowPacketParser
--    WowPacketParserModule.V10_0_0_46181/Parsers/ChallengeModeHandler.cs):
--      u32 MapID | u32 ChallengeID | i32 ChallengeLevel |
--      u32 AffixID x4 (siempre 4)  | i32 DeathCount | u32 playerCount |
--      bit WasActiveKeystoneCharged | playerCount x EncounterStartPlayerInfo
--
--    36 bytes fijos + 1 byte de bits (1 bit) = 37 bytes.
--    El byte de bits va ULTIMO y un bit encendido se escribe 0x80 = 128.
--
--    TRUCO en el orden 3: el unico afijo dinamico que el resolutor sabe dar es
--    {{afijos}} (devuelve los ids separados por espacio: "9 10 ") y strtoul corta
--    en el espacio -> entra el PRIMER afijo de la corrida. Para el 2do, 3ro y 4to
--    hacen falta claves nuevas (afijo_2..afijo_4 con doble llave) = compilar.
-- ---------------------------------------------------------------------------
INSERT INTO `mitica_paquete_campo` (`opcode`, `orden`, `tipo`, `valor`, `nota`) VALUES
('SMSG_CHALLENGE_MODE_START', 0, 'u32', '{{map_id}}', 'MapID del mapa del calabozo (AtalDazar 1763). Antes iba el cm_id aca: iba cambiado'),
('SMSG_CHALLENGE_MODE_START', 1, 'u32', '{{cm_id}}',  'ChallengeID de MapChallengeMode.db2 (AtalDazar 244)'),
('SMSG_CHALLENGE_MODE_START', 2, 'i32', '{{nivel}}',  'ChallengeLevel (nivel de la piedra)'),
('SMSG_CHALLENGE_MODE_START', 3, 'u32', '{{afijos}}', 'AffixID[0]: primer afijo real de la corrida; 0 si no hay'),
('SMSG_CHALLENGE_MODE_START', 4, 'u32', '0',          'AffixID[1]: sin clave por afijo todavia -> 0'),
('SMSG_CHALLENGE_MODE_START', 5, 'u32', '0',          'AffixID[2]: idem'),
('SMSG_CHALLENGE_MODE_START', 6, 'u32', '0',          'AffixID[3]: idem (el cliente lee SIEMPRE 4)'),
('SMSG_CHALLENGE_MODE_START', 7, 'i32', '{{muertes}}','DeathCount al arrancar (0)'),
('SMSG_CHALLENGE_MODE_START', 8, 'u32', '0',          'playerCount: 0 = no se manda lista de jugadores (el armador no sabe repetir bloques). NO poner {{grupo}}'),
('SMSG_CHALLENGE_MODE_START', 9, 'u8',  '128',        'bit WasActiveKeystoneCharged (1 bit empaquetado; encendido = 0x80). Probar 0 si el cliente se queja');

-- ---------------------------------------------------------------------------
-- 3) SMSG_CHALLENGE_MODE_UPDATE_DEATH_COUNT
--    Fuente: WPP V7_0_3_22248 ChallengeModeHandler.ChallengeModeUpdateDeathCount
--    (un solo int32 "NewDeathCount"; sin override posterior). AshamaneCore y
--    HavenCore escriben lo mismo.
-- ---------------------------------------------------------------------------
INSERT INTO `mitica_paquete_campo` (`opcode`, `orden`, `tipo`, `valor`, `nota`) VALUES
('SMSG_CHALLENGE_MODE_UPDATE_DEATH_COUNT', 0, 'i32', '{{muertes}}', 'muertes acumuladas de la corrida (unico campo, 4 bytes)');

-- ---------------------------------------------------------------------------
-- 4) SMSG_CHALLENGE_MODE_COMPLETE  -- FASE 2, estructura reconstruida y NO verificada en vivo
--    Fuente: WPP V9_0_1_36216/Parsers/MythicPlusHandler.cs (HandleChallengeMode
--    Completed910, aplica desde 9.1.0) + Substructures/MythicPlusHandler.cs
--    ReadMythicPlusRun (ese archivo tiene ramas para V12_1_0_69214: sigue vigente).
--
--      ReadMythicPlusRun: i32 MapChallengeModeID | u32 Level | i32 DurationMs |
--        u64 StartDate | u64 CompletionDate | i32 Season | u32 KeystoneAffixIDs x4 |
--        u32 MemberCount | f32 RunScore | i32 Unknown_1120 (11.2.0+) | miembros | bit Completed
--      despues: f32 NewDungeonScore | u32 MemberCount | bits IsPracticeRun,
--        IsAffixRecorded, IsMapRecord | miembros
--
--    SALVEDADES (no hay clave en ms ni en epoch de tiempo en el resolutor):
--      - orden 2 manda SEGUNDOS donde el cliente lee ms -> el tiempo va a salir
--        1000 veces mas chico. Para exactitud hace falta una clave nueva en ms
--        = compilar.
--      - ordenes 3 y 4 van en 0: la fecha de la corrida queda en 1970.
--    BITS: 4 bits en un solo byte (Completed + los 3 de estado). Completed = primer
--    bit -> encendido = 0x80 = 128. Con 0x00 el cliente lo toma como no completada.
-- ---------------------------------------------------------------------------
INSERT INTO `mitica_paquete_campo` (`opcode`, `orden`, `tipo`, `valor`, `nota`) VALUES
('SMSG_CHALLENGE_MODE_COMPLETE',  0, 'u32', '{{cm_id}}',     'MapChallengeModeID'),
('SMSG_CHALLENGE_MODE_COMPLETE',  1, 'u32', '{{nivel}}',     'Level'),
('SMSG_CHALLENGE_MODE_COMPLETE',  2, 'i32', '{{segundos_ms}}',  'DurationMs: el motor solo tiene segundos -> el tiempo sale 1000x chico'),
('SMSG_CHALLENGE_MODE_COMPLETE',  3, 'u64', '0',             'StartDate (epoch). Sin clave en el motor -> 1970'),
('SMSG_CHALLENGE_MODE_COMPLETE',  4, 'u64', '0',             'CompletionDate (epoch). Idem'),
('SMSG_CHALLENGE_MODE_COMPLETE',  5, 'i32', '{{temporada}}', 'Season'),
('SMSG_CHALLENGE_MODE_COMPLETE',  6, 'u32', '{{afijos}}',    'KeystoneAffixIDs[0]'),
('SMSG_CHALLENGE_MODE_COMPLETE',  7, 'u32', '0',             'KeystoneAffixIDs[1]'),
('SMSG_CHALLENGE_MODE_COMPLETE',  8, 'u32', '0',             'KeystoneAffixIDs[2]'),
('SMSG_CHALLENGE_MODE_COMPLETE',  9, 'u32', '0',             'KeystoneAffixIDs[3]'),
('SMSG_CHALLENGE_MODE_COMPLETE', 10, 'u32', '0',             'MemberCount del registro de corrida (0 = sin lista)'),
('SMSG_CHALLENGE_MODE_COMPLETE', 11, 'f32', '0',             'RunScore (puntaje de la corrida)'),
('SMSG_CHALLENGE_MODE_COMPLETE', 12, 'i32', '0',             'Unknown_1120 (existe desde 11.2.0)'),
('SMSG_CHALLENGE_MODE_COMPLETE', 13, 'f32', '0',             'NewDungeonScore (puntaje nuevo del calabozo)'),
('SMSG_CHALLENGE_MODE_COMPLETE', 14, 'u32', '0',             'MemberCount del COMPLETE (0 = sin lista de miembros)'),
('SMSG_CHALLENGE_MODE_COMPLETE', 15, 'u8',  '128',           'bits Completed, IsPracticeRun, IsAffixRecorded, IsMapRecord (0x80 = solo Completed)');

-- ---------------------------------------------------------------------------
-- 5) Verificacion (lo que tiene que quedar en la base)
-- ---------------------------------------------------------------------------
SELECT p.`opcode`, p.`activo`, c.`orden`, c.`tipo`, c.`valor`
  FROM `mitica_paquete` p
  JOIN `mitica_paquete_campo` c ON c.`opcode` = p.`opcode`
 WHERE p.`opcode` LIKE 'SMSG_CHALLENGE_MODE%'
 ORDER BY p.`opcode`, c.`orden`;

-- Byte-count esperado de cada paquete (para comparar con el Server.log):
--   START    = 4+4+4 + 4*4 + 4 + 4 + 1 = 37 bytes
--   DEATH    = 4 bytes
--   COMPLETE = 4+4+4 + 8+8 + 4 + 4*4 + 4 + 4 + 4 + 4 + 4 + 1 = 69 bytes
--   (verificado con el modelo del armador contra las filas reales: START 37, DEATH 4, COMPLETE 69)

-- ---------------------------------------------------------------------------
-- 6) APAGAR UN PAQUETE SIN BORRAR EL FORMATO (util para aislar cual rompe)
--    Dejado como comentario a proposito:
-- UPDATE `mitica_paquete` SET `activo` = 0 WHERE `opcode` = 'SMSG_CHALLENGE_MODE_COMPLETE';
-- UPDATE `mitica_paquete` SET `activo` = 1 WHERE `opcode` = 'SMSG_CHALLENGE_MODE_START';
-- ---------------------------------------------------------------------------

-- ---------------------------------------------------------------------------
-- 7) ROLLBACK: la hipotesis anterior (28 bytes, cm_id/map_id cambiados, sin bits)
--    Dejado como comentario a proposito.
-- ---------------------------------------------------------------------------
-- DELETE FROM `mitica_paquete_campo` WHERE `opcode` LIKE 'SMSG_CHALLENGE_MODE%';
-- DELETE FROM `mitica_paquete` WHERE `opcode` LIKE 'SMSG_CHALLENGE_MODE%';
-- INSERT INTO `mitica_paquete` (`opcode`, `activo`, `descripcion`) VALUES
-- ('SMSG_CHALLENGE_MODE_COMPLETE', 1, 'cierre de la corrida'),
-- ('SMSG_CHALLENGE_MODE_START', 1, 'arranque del HUD de mitica+ (formato en reconstruccion)'),
-- ('SMSG_CHALLENGE_MODE_UPDATE_DEATH_COUNT', 1, 'contador de muertes del grupo');
-- INSERT INTO `mitica_paquete_campo` (`opcode`, `orden`, `tipo`, `valor`, `nota`) VALUES
-- ('SMSG_CHALLENGE_MODE_COMPLETE', 0, 'u32', '{{cm_id}}',     'estancia'),
-- ('SMSG_CHALLENGE_MODE_COMPLETE', 1, 'u32', '{{segundos_ms}}',  'tiempo total'),
-- ('SMSG_CHALLENGE_MODE_COMPLETE', 2, 'u32', '{{nivel}}',     'nivel de la piedra'),
-- ('SMSG_CHALLENGE_MODE_START', 0, 'u32', '{{cm_id}}',        'id de MapChallengeMode (244 = AtalDazar)'),
-- ('SMSG_CHALLENGE_MODE_START', 1, 'u32', '{{map_id}}',       'mapa de la mazmorra'),
-- ('SMSG_CHALLENGE_MODE_START', 2, 'u32', '{{nivel}}',        'nivel de la piedra'),
-- ('SMSG_CHALLENGE_MODE_START', 3, 'u32', '{{t_ms_bronce}}',  'tiempo limite (ms)'),
-- ('SMSG_CHALLENGE_MODE_START', 4, 'array_u32', '{{afijos}}',  'afijos: cantidad + ids'),
-- ('SMSG_CHALLENGE_MODE_UPDATE_DEATH_COUNT', 0, 'u32', '{{muertes}}', 'muertes acumuladas');
