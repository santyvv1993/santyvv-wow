-- ===========================================================================
-- flight_capability: los datos que TrinityCore NO publica
-- ===========================================================================
-- POR QUE EXISTE ESTA MIGRACION
--
-- El vuelo dinamico (skyriding) saca sus 17 parametros de la tabla DB2
-- `flight_capability` y se los manda al cliente con los SMSG_MOVE_SET_ADV_FLYING_*
-- (Unit::SetFlightCapabilityID -> UpdateAdvFlyingSpeed -> UpdateAdvFlyingSpeed).
--
-- TrinityCore no trae datos para esa tabla: en todo el arbol `sql/` hay DELETEs y
-- ni un solo INSERT. El dump 2026_02_18_00_hotfixes_enUS.sql la BORRA
-- (DELETE ... WHERE VerifiedBuild>0 AND VerifiedBuild<@BUILD) y no inserta nada, asi
-- que la tabla queda VACIA. Con el store vacio, Unit::SetFlightCapabilityID sale por:
--
--     if (flightCapabilityId && !sFlightCapabilityStore.HasRecord(flightCapabilityId))
--         return;                                        // Unit.cpp:9022
--
-- es decir: NO setea el campo FlightCapabilityID y NO manda ninguno de los 13
-- paquetes de ajuste. El cliente se queda volando con sus valores internos.
-- Sintomas reportados en vivo: el giro (teclas A/D) se desboca mientras se vuela
-- con el raton, y el aumento de velocidad no se mantiene (el impulso se frena).
--
-- LOS VALORES
-- Medidos del sniffer de retail (dump 12.1.0.69875, 20-sep-2026 20:48, mapa 0),
-- leyendo los paquetes SMSG_MOVE_SET_ADV_FLYING_* que el servidor de Blizzard manda.
-- El perfil completo medido es el de la fila ID 1 (el que usa `vuelo_config.cap_vuelo_dinamico`).
-- En el mismo sniff aparece un segundo perfil (MaxVel 55.25 / AddImpulseMaxSpeed 85)
-- que NO se reproduce aca porque solo se midieron esos dos campos: si algun dia hace
-- falta, se agrega como fila aparte con su propio FlightCapabilityID.
--
-- VerifiedBuild = 0 A PROPOSITO: los dumps de Blizzard borran
-- `WHERE VerifiedBuild>0 AND VerifiedBuild<@BUILD`, asi que las filas con build 0 son
-- las unicas que sobreviven a una re-aplicacion de esos dumps (y ya se verifico en este
-- servidor que el core carga y sirve filas con VerifiedBuild=0: las de cfg_regions eran
-- justamente de ese tipo). No cambiar a un build real: se perderia en el proximo dump.
--
-- Los campos que el core no manda al cliente (Unknown1000_*, VigorRegenMaxVelCoefficient,
-- SpellID) van en 0: no participan de los 13 SMSG y no se inventan valores.
-- ===========================================================================

DELETE FROM `flight_capability` WHERE `ID` = 1;

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
     7.5, 100, 2.443460941314697265, 4.712388992309570312,
     3.141592741012573242, 5.585053443908691406, 3.141592741012573242, 4.886921882629394531,
     45, 65, 2.75,
     7, 0, 0, 0,
     0, 0, 0.400000005960464477,
     0, 0, 0);
