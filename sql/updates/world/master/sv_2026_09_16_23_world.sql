-- =====================================================================
-- 2026_09_16_23_world.sql
-- Jefes de la temporada mítica: quitarles las banderas que los dejan
-- INATACABLES (por eso "no se puede pelear con el jefe", solo matarlo con .die).
-- =====================================================================
-- Medido, no supuesto:
--   * Unit::IsValidAttackTarget rechaza UNIT_FLAG_IMMUNE_TO_PC (0x00000100)
--     y UNIT_FLAG_UNINTERACTIBLE (0x02000000) -> el jugador NO puede iniciar
--     el ataque. UNIT_FLAG_IMMUNE_TO_NPC (0x00000200) hace lo propio con las
--     mascotas y los aliados NPC.
--   * Estas plantillas venían con esas banderas puestas. En retail ese es el
--     estado "previo al encuentro" y lo limpia el script del encuentro; en esta
--     base las 8 estancias tienen `ScriptName` y `AIName` VACÍOS, así que nadie
--     las limpia y el jefe queda inerte para siempre.
--   * Los spawns no pisan la bandera (world.creature.unit_flags = NULL en todos
--     los spawns de jefe), por eso el arreglo va en la plantilla.
--   * Referencia de cómo se ve un jefe que SÍ funciona en esta misma base: los
--     de Ojo de Azshara / Atal'Dazar / Reposo de los Reyes traen unit_flags = 64
--     (0x40) y ninguna de las banderas de arriba.
--
-- Alcance: TODOS los jefes de encuentro de las 8 estancias de la temporada
-- (lista medida en `DungeonEncounter.db2`), no solo los finales — si el jefe del
-- medio es inatacable, la estancia no se puede recorrer.
--
-- Efecto esperado: los jefes quedan atacables por el jugador (64 = valor normal
-- de jefe en esta base). NO se les agrega IA: siguen sin hechizos ni mecánicas,
-- eso es la ola de smart_scripts (docs/inventario/miticas/plan-scripts-por-estancia.md).
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1) Jefes FINALES declarados (los que cierran la corrida) — 8 estancias
--    Yazma 320 · King Dazar 33554496 (0x2000040) · Kyrakka 832 · Erkhart 262976
--    (stunned) · Prioresa 832 · Izo 832 · Ki'katal 64 (limpio) · Cólera 64 (limpio)
-- ---------------------------------------------------------------------
UPDATE `creature_template`
   SET `unit_flags` = `unit_flags` & ~0x00000100   -- IMMUNE_TO_PC
                              & ~0x00000200        -- IMMUNE_TO_NPC
                              & ~0x00040000        -- STUNNED
                              & ~0x02000000        -- UNINTERACTIBLE
 WHERE `entry` IN (
        122968,   -- Yazma                   (Atal'Dazar)
        136160,   -- King Dazar              (Reposo de los Reyes)
        199790,   -- Kyrakka                 (Estanques de Vida Rubí)
        199791,   -- Erkhart Stormvein       (Estanques de Vida Rubí)
        207940,   -- Prioress Murrpray       (Priorato de la Llama Sagrada)
        216658,   -- Izo, the Grand Splicer  (Ciudad de los Hilos)
        215407,   -- Ki'katal the Harvester  (Ara-Kara)
        96028     -- Wrath of Azshara        (Ojo de Azshara, sin spawn)
 );

-- ---------------------------------------------------------------------
-- 2) Jefes INTERMEDIOS que también estaban inatacables (misma causa)
--    Coaglamación 33555264 (0x2000340) · Nx 33554752 (0x2000140)
--    Barón Braunpyke 832 (0x340) · Viejo Barbacera 33554496 (0x2000040, sin spawn)
-- ---------------------------------------------------------------------
UPDATE `creature_template`
   SET `unit_flags` = `unit_flags` & ~0x00000100
                              & ~0x00000200
                              & ~0x00040000
                              & ~0x02000000
 WHERE `entry` IN (
        216320,   -- The Coaglamation         (Ciudad de los Hilos)
        216648,   -- Nx                       (Ciudad de los Hilos)
        207939,   -- Baron Braunpyke          (Priorato de la Llama Sagrada)
        210149    -- Ol' Waxbeard             (Grieta Llama Oscura, sin spawn)
 );

-- ---------------------------------------------------------------------
-- Verificación: ningún jefe de encuentro de la temporada debe conservar las
-- banderas que bloquean el ataque (esperado: los 4 campos en 0; unit_flags = 64
-- en todos menos "The Darkness" 210797, que ya venía en 0).
--   SELECT entry, name, unit_flags,
--          (unit_flags & 0x00000100) AS imm_pc, (unit_flags & 0x00000200) AS imm_npc,
--          (unit_flags & 0x00040000) AS stunned, (unit_flags & 0x02000000) AS uninter
--     FROM creature_template
--    WHERE entry IN (122968,136160,199790,199791,207940,216658,215407,96028,
--                    216320,216648,207939,210149, 91784,91789,91797,91808,
--                    122963,122965,122967,134993,135322,135470,188252,189232,
--                    207946,208743,208745,210797,215405,216619);
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- Reversión (volver al estado de la TDB):
--   UPDATE creature_template SET unit_flags = 320      WHERE entry = 122968;
--   UPDATE creature_template SET unit_flags = 33554496 WHERE entry IN (136160,210149);
--   UPDATE creature_template SET unit_flags = 832      WHERE entry IN (199790,207940,216658,207939);
--   UPDATE creature_template SET unit_flags = 262976   WHERE entry = 199791;
--   UPDATE creature_template SET unit_flags = 33555264 WHERE entry = 216320;
--   UPDATE creature_template SET unit_flags = 33554752 WHERE entry = 216648;
-- ---------------------------------------------------------------------
