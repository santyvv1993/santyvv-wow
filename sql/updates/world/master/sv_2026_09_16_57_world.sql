-- ============================================================================
--  RP de Atal'Dazar: Yazma (122968) — cierra la estancia
-- ============================================================================
--  Igual que los otros tres jefes de la estancia, esto es SOLO DATO: el SmartAI de Yazma (nuestro, 21
--  filas) YA tiene las acciones de hablar, lo unico que faltaba era el texto. Verificado antes de
--  escribir, leyendo sus filas de `smart_scripts`:
--      id 22 (AGGRO)  -> SMART_ACTION_TALK (1), param1 = grupo 1
--      id 51 (link desde Soulrend 249924) -> grupo 2   (aviso del ataque a la raid)
--      id 35 (KILL)   -> grupo 3
--      id 32 (DEATH)  -> grupo 4
--      id 38 (EVADE)  -> grupo 5
--  El grupo 0 de Yazma no lo usa el guion, asi que no se escribe (un texto sin quien lo diga es ruido).
--
--  Texto: redaccion nuestra en espanol, como en la migracion 56 y por la misma razon (la wiki no tiene
--  las frases de pelea y los `BroadcastText` del cliente no son localizables por criatura). Yazma es la
--  suma sacerdotisa de Shadra: el registro es de arana/veneno y de desprecio a los mortales.
-- ============================================================================

DELETE FROM `creature_text` WHERE `CreatureID` = 122968;

INSERT INTO `creature_text` (`CreatureID`, `GroupID`, `ID`, `Text`, `Type`, `Language`, `Probability`, `Emote`, `Duration`, `Sound`, `BroadcastTextId`, `TextRange`, `comment`) VALUES
(122968, 1, 0, '¡Nadie entra al santuario de Shadra!', 14, 0, 100, 0, 0, 0, 0, 0, 'Yazma: entra en combate'),
(122968, 2, 0, '¡Vuestras almas ya estan en mi telarana!', 14, 0, 100, 0, 0, 0, 0, 0, 'Yazma: aviso de Soulrend/Desgarre de alma'),
(122968, 3, 0, '¡Otra alma para la reina!', 14, 0, 100, 0, 0, 0, 0, 0, 'Yazma: mata a un jugador'),
(122968, 4, 0, 'Shadra... no me... abandones...', 14, 0, 100, 0, 0, 0, 0, 0, 'Yazma: muere'),
(122968, 5, 0, 'Venid... la reina os espera.', 14, 0, 100, 0, 0, 0, 0, 0, 'Yazma: evade (vuelve a su puesto)');
