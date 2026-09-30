-- ============================================================================
--  Los dos jefes finales de Estanques de Vida Rubi, donde dice el diario del
--  cliente — y el jefe final del Ojo de Azshara, en el piso
-- ============================================================================
--  De donde sale la posicion de Kyrakka y Erkhart: del diario del PROPIO cliente
--  (no de la wiki), que es fuente de primera mano y ademas describe la pelea.
--    JournalEncounter 2503 "Kyrakka y Erkhart Sangre Tormentosa" (mapa 2521),
--    seccion "Resumen":
--      "Kyrakka comienza la batalla EN EL AIRE, exhalando llamas y escupiendo
--       fuego desde los alrededores del Mirador Rubi, mientras que Erkhart
--       intercepta a los jugadores DIRECTAMENTE. Cuando cualquiera de ellos
--       tiene 50% de la salud, Kyrakka aterriza ..."
--    Leido con `herramientas/diagnostico/diario-encuentro.py 2503`.
--
--  Lo medido antes de tocar nada (herramientas/diagnostico/jefes-navmesh.py,
--  17-sep-2026): de los 29 spawns de jefe de las 8 estancias, **24 tienen piso de
--  navegacion debajo** (delta <= 3 yd). Los que no:
--    · Kyrakka  199790 (spawn 9001490) en (1864.12, 14.52, 332.15): el piso mas
--      cercano esta a +225 yd (107.04) y la plataforma de la arena (313) queda a
--      ~60 yd al oeste: esta VOLANDO. El diario dice que empieza en el aire, o sea
--      que la POSICION ES CORRECTA; lo que faltaba es que vuele.
--    · Erkhart  199791 (spawn 9004026) en (1858.12, 14.52, 332.15): spawn NUESTRO
--      (migracion 21) al que se le copio la z de Kyrakka por no tener fuente
--      propia. El diario dice que el intercepta a los jugadores EN EL PISO, asi que
--      esa altura es de ella por herencia. La plataforma con malla mas cercana
--      esta en (1806, 8), con el piso en 313.03 yd (delta -0.03).
--    · Colera de Azshara 96028 (mapa 1456): ver mas abajo.
--  Lo que NO se toca (y por que) queda anotado al final del archivo.
--
--  Entra en efecto: el movimiento (hover) al recrear la criatura — se puede tomar
--  en caliente con `.reload creature_movement_override` — y las POSICIONES en el
--  proximo arranque del mundo (los spawns se cargan al arrancar; no hay comando de
--  recarga de spawns).
-- ============================================================================

-- ---------------------------------------------------------------------------
-- 1) Kyrakka: que vuele (empieza la pelea en el aire, segun el diario)
--    Mismo idioma que los jefes voladores que ya funcionan en esta base
--    (Val'kyr Battle-maiden 28534, Eydis Darkbane 34496, Spirit Healer 29259...):
--    `HoverInitiallyEnabled = 1`, que el core aplica al crear la criatura
--    (`Creature::Create` -> `SetHover(GetMovementTemplate().IsHoverInitiallyEnabled())`).
--    Va en `creature_movement_override` (clave: el SPAWN) porque es la tabla que el
--    cargador recorre; la de plantilla queda como respaldo del mismo entry.
-- ---------------------------------------------------------------------------
DELETE FROM `creature_movement_override` WHERE `SpawnId` = 9001490;
INSERT INTO `creature_movement_override` (`SpawnId`, `HoverInitiallyEnabled`, `Chase`, `Random`) VALUES
(9001490, 1, NULL, NULL);

DELETE FROM `creature_template_movement` WHERE `CreatureId` = 199790;
INSERT INTO `creature_template_movement` (`CreatureId`, `HoverInitiallyEnabled`, `Chase`, `Random`) VALUES
(199790, 1, NULL, NULL);

-- ---------------------------------------------------------------------------
-- 2) Erkhart: al piso de la arena (el diario dice que el pelea en el piso)
--    (1806, 8, 313.0): piso de navegacion medido 313.03 (delta -0.03), 58 yd al
--    oeste de donde vuela Kyrakka y dentro de la plataforma donde esta la chusma
--    de la zona final (Storm Warrior / Primal Thundercloud en z ~312.5).
--    Orientacion: la misma que tenia (copiada de Kyrakka); es cosmetica.
-- ---------------------------------------------------------------------------
UPDATE `creature`
   SET `position_x` = 1806.0, `position_y` = 8.0, `position_z` = 313.0
 WHERE `guid` = 9004026 AND `id` = 199791;

-- ---------------------------------------------------------------------------
-- 3) Colera de Azshara 96028 (mapa 1456): estaba 4.8 yd POR DEBAJO del piso
--    El spawn es nuestro (`docs/investigacion/jefes-finales-faltantes.sql`) y su z
--    salio de "el spawn mas cercano que ya existe" (97713 Lightning Stalker, a
--    17.8 yd), no de una fuente del jefe. Medido ahora: el piso de navegacion en su
--    (x, y) esta en 1.24 y el esta en -3.6. El POI de su propia mision (38286,
--    ObjectiveIndex = 2) dice z 0..2: coincide con el piso, no con el spawn vecino.
--    Se lo sube al piso (1.24).
-- ---------------------------------------------------------------------------
UPDATE `creature`
   SET `position_z` = 1.24
 WHERE `guid` = 6005486 AND `id` = 96028;

-- ============================================================================
--  LO QUE NO SE TOCO (medido, para que una auditoria futura no lo lea como olvido)
--    · 91789 Lady Hatecoil (Ojo de Azshara, spawn de la TDB): esta 14.5 yd sobre
--      una playa plana — la malla en 200x200 yd alrededor no pasa de 6 yd de alto y
--      no hay ninguna estructura debajo. No se mueve un spawn de la TDB sin una
--      medicion en vivo (o del nivel del agua de esa zona, que hoy no sabemos leer)
--      porque puede estar flotando sobre el agua a proposito. **Prueba en vivo.**
--    · 188252 Melidrussa Tejescarcha: +3.59 yd, dentro de la tolerancia de 3 yd (es
--      un draco: un poco por encima del piso es lo esperado).
--    · 199790 Kyrakka: la POSICION no se toca (el diario confirma que empieza en el
--      aire). El techo del encuentro — que aterrice al 50% de salud — no esta
--      implementado y queda como limite declarado del guion.
-- ============================================================================
