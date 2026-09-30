-- SV migracion sv_2026_09_19_10_world.sql
-- Vuelo dinamico: la capacidad que le mandamos al cliente pasa de 4 a 11.
--
-- POR QUE (medido el 19-sep-2026, captura del oficial con ymir + DB2 del cliente):
--  * La captura trajo los 14 parametros que el servidor manda al activar el vuelo
--    (`SMSG_MOVE_SET_ADV_FLYING_*`) con sus valores: MaxVel 65, AirFriction 1.5,
--    AddImpulseMaxSpeed 100, OverMaxDeceleration 7, LaunchSpeedCoefficient 0.4,
--    banking 140/270 grados, pitch abajo 180/320, pitch arriba 180/280, giro lento 45-65.
--  * El cliente NO recibe esos numeros del servidor: los lee de `FlightCapability.db2` por
--    ID; el servidor solo manda el ID (campo de update `FlightCapabilityID`). O sea que la
--    unica forma de que nuestro vuelo se sienta igual es mandar el ID correcto.
--  * Comparado contra las 14 filas del DB2, la **11** es la unica que coincide en los 17
--    valores que el cliente recibe; la **4** (que teniamos puesta) declara MaxVel 55,
--    banking 75/150, impulso max 85, friction 1.0 y desaceleracion 5 — de ahi que el vuelo
--    se sintiera corto.
--  * La fila 11 es justo la que usan las capacidades de montura 494, 506, 510 y 530
--    (`MountCapability.db2`), y la 494 es la dinamica que exige saber 376777.
--  * Reproceso: `herramientas/vuelo-capacidades.py` (compara la captura contra el DB2) y el
--    detalle en `docs/ANALISIS-SNIFF-2026-09-19.md`.
-- filas a cambiar: 1
UPDATE `vuelo_config`
   SET `valor` = '11',
       `nota` = 'FlightCapabilityID que se manda al montar (11 = la de retail: MaxVel 65, banking 140-270, impulso max 100, friction 1.5; medido 19-sep-2026 contra FlightCapability.db2; la 4 traia MaxVel 55 y banking 75/150)'
 WHERE `clave` = 'cap_vuelo_dinamico';
