-- ===========================================================================
-- flight_capability (fila 11 = la que usa `vuelo_config.cap_vuelo_dinamico`):
-- el perfil del VUELO DINAMICO medido en retail, no el del vuelo normal.
-- ===========================================================================
-- POR QUE
--
-- La migracion 41 dejo la fila 11 con el perfil que el sniff del 20-sep-2026 mostro
-- con MaxVel 65 / AddImpulseMaxSpeed 100. El sniff del 21-sep-2026 (752.603 lineas de
-- vuelo real) muestra que retail manda DOS perfiles distintos y los alterna 60 veces
-- por sesion, siempre pegado a los cambios de modo:
--
--   SMSG_MOVE_SET_CAN_ADV_FLY    (vuelo dinamico ACTIVO)  -> MaxVel 55.25 / impulso 85
--        mismo instante: Speed 29.39999771118164062  (420% de vuelo)
--   SMSG_MOVE_UNSET_CAN_ADV_FLY  (vuelo normal / a pie)   -> MaxVel 65    / impulso 100
--        mismo instante: Speed 7.700000286102294921 (110%)
--
-- O sea: el 55.25/85 es el perfil del modo dinamico y el 65/100 es el del vuelo normal.
-- Nuestro servidor mandaba SIEMPRE 65/100 (el del vuelo normal) con el modo dinamico
-- encendido, asi que los dos limites iban 1,176 veces mas altos que en retail
-- (65 / 55.25 = 100 / 85 = 1,176). Esa es la diferencia que se siente al volar.
--
-- El 65/100 se queda en la fila 1 (el respaldo que usa FlightCapabilityID 0), que es
-- justamente el perfil que retail manda cuando el modo dinamico esta apagado.
--
-- REVERSIBLE: volver atras es correr este UPDATE al reves (65 / 100).
-- ===========================================================================

UPDATE `flight_capability`
SET `MaxVel` = 55.25,
    `AddImpulseMaxSpeed` = 85
WHERE `ID` = 11;
