-- ============================================================================
-- flight_capability fila 1: los angulos vuelven a GRADOS (como los declara el DB2)
-- ============================================================================
-- La migracion 41 cargo la fila 1 con los valores del CABLE de retail, que viajan en
-- RADIANES (2.443460941314697265 / 4.712388992309570312). Pero la tabla es un espejo del
-- DB2 del cliente, y el DB2 guarda esos mismos angulos en GRADOS (140 / 270).
--
-- Las dos unidades convivian en la tabla: la fila 11 (la que usa `vuelo_config.cap_vuelo_dinamico`,
-- cargada del DB2 por herramientas/vuelo-capacidades.py) tenia 140/270, y esta fila 1 tenia
-- 2.44/4.71. El core manda al cliente lo que haya en la tabla, y el cliente recibe RADIANES
-- (retail manda 2.443460941314697265), asi que la fila 11 lo hacia girar 57,3 veces mas rapido.
--
-- Arreglo en dos mitades:
--   * core (Unit.cpp, UpdateAdvFlyingSpeed): convierte los tres angulares a radianes al calcular
--     el valor, asi que cualquier fila del DB2 sirve tal como viene (en grados).
--   * datos (esta migracion): la fila 1 queda en GRADOS, igual que el DB2 y que la fila 11.
-- El umbral de giro (45 .. 65) no se toca: retail lo manda crudo, sin convertir.
-- ============================================================================

INSERT INTO `flight_capability`
    (`ID`, `AirFriction`, `MaxVel`, `Unknown1000_2`, `DoubleJumpVelMod`, `LiftCoefficient`,
     `GlideStartMinHeight`, `AddImpulseMaxSpeed`, `BankingRateMin`, `BankingRateMax`,
     `PitchingRateDownMin`, `PitchingRateDownMax`, `PitchingRateUpMin`, `PitchingRateUpMax`,
     `TurnVelocityThresholdMin`, `TurnVelocityThresholdMax`, `SurfaceFriction`,
     `OverMaxDeceleration`, `Unknown1000_17`, `Unknown1000_18`, `Unknown1000_19`,
     `Unknown1000_20`, `Unknown1000_21`, `LaunchSpeedCoefficient`,
     `VigorRegenMaxVelCoefficient`, `SpellID`, `VerifiedBuild`)
VALUES
    (1, 1.5, 65, 0, 5, 0.07,
     7.5, 100, 140, 270,
     180, 320, 180, 280,
     45, 65, 2.75,
     7, 0, 0, 0,
     0, 0, 0.400000005960464477,
     0, 0, 0)
ON DUPLICATE KEY UPDATE
    `AirFriction` = VALUES(`AirFriction`), `MaxVel` = VALUES(`MaxVel`),
    `DoubleJumpVelMod` = VALUES(`DoubleJumpVelMod`), `LiftCoefficient` = VALUES(`LiftCoefficient`),
    `GlideStartMinHeight` = VALUES(`GlideStartMinHeight`),
    `AddImpulseMaxSpeed` = VALUES(`AddImpulseMaxSpeed`),
    `BankingRateMin` = VALUES(`BankingRateMin`), `BankingRateMax` = VALUES(`BankingRateMax`),
    `PitchingRateDownMin` = VALUES(`PitchingRateDownMin`),
    `PitchingRateDownMax` = VALUES(`PitchingRateDownMax`),
    `PitchingRateUpMin` = VALUES(`PitchingRateUpMin`),
    `PitchingRateUpMax` = VALUES(`PitchingRateUpMax`),
    `TurnVelocityThresholdMin` = VALUES(`TurnVelocityThresholdMin`),
    `TurnVelocityThresholdMax` = VALUES(`TurnVelocityThresholdMax`),
    `SurfaceFriction` = VALUES(`SurfaceFriction`),
    `OverMaxDeceleration` = VALUES(`OverMaxDeceleration`),
    `LaunchSpeedCoefficient` = VALUES(`LaunchSpeedCoefficient`);
