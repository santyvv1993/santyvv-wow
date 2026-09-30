-- ============================================================================
--  Red de seguridad del recorrido: lo que faltaba declarar por estancia (B3)
-- ============================================================================
-- Origen: el check B3 del flujo de habilitacion (herramientas/diagnostico/habilitacion-estancias.py)
-- y la medicion de herramientas/diagnostico/camino-central.py -> docs/inventario/miticas/camino-central.md.
--
-- QUE PUEDE ABRIR EL MOTOR (MythicPlusMgr), y quien puede que:
--   1. El VIGILANTE (VigilarRecorrido): si el lider queda quieto 20 s, abre la puerta (tipo 0) o el
--      muro destructible (tipo 33) cerrado que tenga a <=10 yd. Es automatico, pero SOLO toca esos
--      dos tipos de objeto.
--   2. El CAMINO CENTRAL (AbrirCaminoCentral): cuando ya no queda vivo ninguno de los jefes de
--      `camino_jefes`, abre `camino_go` y despenza las paredes de `camino_quitar`.
--   3. `.mitica destrabar` (manual): abre TODAS las puertas y muros cerrados de la instancia y
--      despenza las paredes declaradas. Es la via de escape garantizada.
--   4. Las PAREDES DE COLISION (gameobjects genericos tipo 5, como el "Collision Wall" de
--      Atal'Dazar) **no las toca ninguna de las tres anteriores salvo que esten declaradas**. Son la
--      unica clase de objeto que puede trabar una corrida sin que nada la salve, y es exactamente lo
--      que le paso a Santiago en vivo (la escalera abierta y una pared invisible delante).
--
-- MEDIDO (17-sep-2026) sobre las 8 estancias de la temporada:
--   * Paredes de colision (tipo 5 con nombre de pared/barrera): **1763 tiene 2** ("Collision Wall"
--     7000143 y 7000160) y **2521 tiene 1** ("Fire Wall (Smoke)" 9000118, a 20 yd de Kokia, en el
--     paso hacia el jefe final). Las otras seis no tienen ninguna.
--   * Puerta del jefe final identificable con la evidencia que tenemos **solo en 1762** (Reposo de
--     los Reyes): "Kings' Rest - Boss 4 - Dazar Gate" (spawn 7000307), cerrada, a 7,1 yd de la recta
--     Kula -> Rey Dazar y 12 yd del jefe final. En las otras, los candidatos son puertas de paso
--     tempranas (la "Ruby Door" de 2521 esta a 355 yd del jefe) o barreras del propio encuentro (el
--     Priorato tiene "10FX_Generic_Fire_Barrier" sobre la propia Prioresa), asi que NO se declaran:
--     declarar una puerta como `camino_go` la saca de la lista del vigilante mientras queden jefes de
--     `camino_jefes` vivos, o sea que una declaracion equivocada empeora la red.
--   * 1456 (Ojo de Azshara) no necesita nada: sus 2 puertas estan en el `doorData` del script del
--     propio core (`instance_eye_of_azshara`), que las abre al morir los jefes.
--   * 1763 (Atal'Dazar) ya tenia su camino declarado (es la referencia); solo le faltaba la segunda
--     pared.
--
-- CARGA: `mitica_estancia` se lee al arrancar el mundo, asi que esto entra en el proximo reinicio.
-- Verificacion: el check B3 del flujo queda en OK para las 8 y no aparece ninguna linea nueva en
-- DBErrors.log.
-- ============================================================================

-- 1763 Atal'Dazar: la segunda pared de colision (la primera, 7000160, ya estaba declarada por la
-- migracion 38). La 7000143 esta en el otro paso del mismo calabozo.
UPDATE `mitica_estancia` SET `camino_quitar` = '7000160 7000143' WHERE `cm_id` = 244;

-- 2521 Estanques de Vida Rubi: la pared de fuego del paso hacia el jefe final.
UPDATE `mitica_estancia` SET `camino_quitar` = '9000118' WHERE `cm_id` = 399;

-- 1762 Reposo de los Reyes: la puerta del jefe final y los cuatro jefes que la abren (el quinto es
-- Rey Dazar 136160, el jefe final: no va en la lista, el es el que cierra la corrida).
UPDATE `mitica_estancia`
   SET `camino_jefes` = '134993 135470 135472 135475',
       `camino_go`    = 7000307
 WHERE `cm_id` = 249;
