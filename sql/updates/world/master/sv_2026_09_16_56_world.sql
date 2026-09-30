-- ============================================================================
--  RP de Atal'Dazar: textos de los jefes que YA tienen guion del core
-- ============================================================================
--  Medido antes de escribir: `creature_text` tiene **0 filas** para los 25 jefes de la temporada, y en las
--  8 estancias enteras apenas 9 criaturas / 71 filas. O sea: el RP estaba ausente del todo.
--
--  POR QUE ESTA MIGRACION ES SOLO DATO (no hay C++ ni compilacion):
--    Los tres jefes de Atal'Dazar que NO son Yazma ya traen su guion en el core
--    (src/server/scripts/Zandalar/AtalDazar/boss_rezan.cpp, boss_volkaal.cpp, boss_priestess_alun_za.cpp)
--    y esos guiones **ya llaman a las frases**: 17 llamadas `Talk(SAY_...)`. Lo unico que faltaba era el
--    texto. Los GroupID de abajo salen del enum de cada guion, no de una suposicion:
--      Rezan     (122963): 0 SAY_REANIMATED_RAPTOR_WARNING · 1 SAY_REANIMATED_RAPTOR_SUMMONER ·
--                          2 SAY_TERRIFYING_VISAGE · 3 SAY_PURSUIT
--      Vol'kaal  (122965): 0 SAY_AGGRO · 1 SAY_DECAY · 2 SAY_DIED · 3 SAY_SLAY
--      Alun'za   (122967): 0 SAY_AGGRO · 1 SAY_GILDED_CLAWS_WARNING · 2 SAY_GILDED_CLAWS ·
--                          3 SAY_TRANSFUSION_WARNING · 4 SAY_TRANSFUSION · 5 SAY_SLAY · 6 SAY_WIPE
--
--  DE DONDE SALE EL TEXTO (y aqui hay una limitacion que conviene saber):
--    La wiki NO tiene las frases de pelea de estos jefes: la seccion Dialogue de la pagina de Yazma es un
--    `{{Stub-section}}` (vacia) y las de Rezan/Vol'kaal/Alun'za traen solo el gossip y el "on-click", no
--    las lineas del encuentro. Lo que si existe en el cliente son los `BroadcastText` (10.670 filas, con
--    texto en espanol), pero NO son localizables por nombre: las frases de un jefe no dicen su nombre.
--    Por eso estas lineas son **redaccion nuestra, en espanol**, respetando el registro zandalari de la
--    epoca (Dazar'alor) y el momento exacto de cada grupo segun el guion del core. No se presentan como
--    "las frases de retail": son las nuestras.
--
--  `Type = 14` es grito (CHAT_MSG_MONSTER_YELL), igual que el texto real que ya trae la base para otro
--  jefe de la temporada (King Deepbeard 91797). `Probability = 100` para que se oiga siempre.
-- ============================================================================

DELETE FROM `creature_text` WHERE `CreatureID` IN (122963, 122965, 122967);

INSERT INTO `creature_text` (`CreatureID`, `GroupID`, `ID`, `Text`, `Type`, `Language`, `Probability`, `Emote`, `Duration`, `Sound`, `BroadcastTextId`, `TextRange`, `comment`) VALUES

-- ── Rezan (122963) — el dios-rey devorador de los Zandalari ──────────────────────────────────────
(122963, 0, 0, '¡Mis crías ya huelen vuestra sangre!', 14, 0, 100, 0, 0, 0, 0, 0, 'Rezan: aviso de raptores reanimados'),
(122963, 1, 0, '¡Levántate y sirve a tu rey!', 14, 0, 100, 0, 0, 0, 0, 0, 'Rezan: invoca un raptor reanimado'),
(122963, 2, 0, '¡Contemplad mi verdadero rostro!', 14, 0, 100, 0, 0, 0, 0, 0, 'Rezan: visaje aterrador'),
(122963, 3, 0, '¡No hay dónde esconderse!', 14, 0, 100, 0, 0, 0, 0, 0, 'Rezan: persigue a un jugador'),

-- ── Vol'kaal (122965) — el loa serpiente que se alimenta de la fe ─────────────────────────────────
(122965, 0, 0, '¡Vol''kaal os devorará enteros!', 14, 0, 100, 0, 0, 0, 0, 0, 'Vol''kaal: entra en combate'),
(122965, 1, 0, '¡La putrefacción os consume!', 14, 0, 100, 0, 0, 0, 0, 0, 'Vol''kaal: descomposición'),
(122965, 2, 0, 'Vol''kaal... no... cae...', 14, 0, 100, 0, 0, 0, 0, 0, 'Vol''kaal: muere'),
(122965, 3, 0, '¡Aplastado como un insecto!', 14, 0, 100, 0, 0, 0, 0, 0, 'Vol''kaal: mata a un jugador'),

-- ── Sacerdotisa Alun'za (122967) — la que cambia sangre por poder ─────────────────────────────────
(122967, 0, 0, '¡Nadie roba la sangre de Alun''za!', 14, 0, 100, 0, 0, 0, 0, 0, 'Alun''za: entra en combate'),
(122967, 1, 0, '¡Cuidado! ¡Las garras doradas!', 14, 0, 100, 0, 0, 0, 0, 0, 'Alun''za: aviso de garras doradas'),
(122967, 2, 0, '¡Desgarrad sus cuerpos!', 14, 0, 100, 0, 0, 0, 0, 0, 'Alun''za: garras doradas'),
(122967, 3, 0, '¡Se acerca la transfusión!', 14, 0, 100, 0, 0, 0, 0, 0, 'Alun''za: aviso de transfusión'),
(122967, 4, 0, '¡Vuestra sangre me pertenece!', 14, 0, 100, 0, 0, 0, 0, 0, 'Alun''za: transfusión'),
(122967, 5, 0, '¡Su sangre alimenta al loa!', 14, 0, 100, 0, 0, 0, 0, 0, 'Alun''za: mata a un jugador'),
(122967, 6, 0, '¡Nadie escapa de Alun''za!', 14, 0, 100, 0, 0, 0, 0, 0, 'Alun''za: el grupo entero muere');
