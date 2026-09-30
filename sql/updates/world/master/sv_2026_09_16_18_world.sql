-- ============================================================================
-- Miticas+ : el jefe que cierra la corrida (y el reloj que lo vigila)
-- ============================================================================
-- POR QUE:
--  (1) El gancho de TrinityCore (PlayerScript::OnCreatureKill) solo se dispara cuando la muerte se le
--      puede atribuir a un jugador. La prueba en vivo del 16-sep lo dejo claro: las fuerzas llegaron
--      al 100 %, Yazma murio con `.die` y la corrida quedo abierta ("se cierra escuchando la muerte
--      del jefe por el gancho del jugador" ya no alcanza).
--  (2) Y habia un segundo problema, medido contra la base: EN ESTOS CALABOZOS LA TDB NO MARCA NINGUN
--      JEFE. `creature_template.flags_extra & 1` (CREATURE_FLAG_EXTRA_DUNGEON_BOSS) da 0 en las 8
--      estancias de la temporada y en sus 3.264 criaturas spawneadas -- incluidos los jefes de
--      Atal'Dazar (Yazma 122968, Vol'kaal 122965, Alun'za 122967, Rezan 122963, todos flags_extra = 0):
--          select c.map, count(*), sum((ct.flags_extra & 1) <> 0) from creature c
--          join creature_template ct on ct.entry = c.id where c.map in (1456,1763,1762,2521,2649,2669,2660,2651) group by c.map;
--          -> 1456: 622/0   1763: 218/0   1762: 212/0   2521: 306/0   2649: 357/0   2669: 864/0   2660: 408/0   2651: 277/0
--      Asi que `IsDungeonBoss()` nunca daba verdadero en estas mazmorras: el "cierre por jefe" era
--      codigo muerto y el aviso "matar al jefe cierra la corrida" no se podia cumplir.
--
-- ARREGLO: el jefe final se DECLARA por estancia (`jefe_final` = entry de criatura). El motor mira la
-- instancia cada `vigilancia_seg` segundos (WorldScript::OnUpdate -> Mgr::Vigilar) y cierra la corrida
-- cuando ESE jefe ya no esta vivo, sin importar quien lo mato. Con jefe_final = 0 queda la regla
-- general ("ningun jefe marcado sigue vivo"), que hoy no sirve en estas mazmorras.
--
-- FALTA (anotado): declarar el jefe final de las otras 7 estancias. La fuente es el Diario de
-- encuentros del cliente (`JournalEncounter` DB2), que todavia no podemos leer: el mismo bloqueo que
-- WorldSafeLocs (herramientas/db2.py necesita el layout del core y el core no carga esa tabla).
-- ============================================================================

ALTER TABLE `mitica_estancia`
    ADD COLUMN `jefe_final` INT UNSIGNED NOT NULL DEFAULT 0
    COMMENT 'entry del jefe que cierra la corrida; 0 = la regla general (ningun jefe vivo)' AFTER `ilvl_techo`;

-- Atal'Dazar: el jefe final es Yazma (122968). Verificado en vivo el 16-sep (el cliente la mostro
-- como "Yazma" y el GUID de la criatura en la seleccion del GM fue 122968), y es la unica estancia de
-- la temporada con su cadena probada de punta a punta.
UPDATE `mitica_estancia` SET `jefe_final` = 122968 WHERE `cm_id` = 244;

INSERT INTO `mitica_config` (`clave`, `valor`, `descripcion`) VALUES
 ('cierre_por_jefes',    '1', '1 = la corrida cierra cuando el jefe final (o el ultimo jefe) ya no esta vivo'),
 ('vigilancia_seg',      '5', 'cada cuantos segundos se mira la instancia para cerrar la corrida'),
 ('devolver_piedra',     '1', '1 = la piedra consumida al arrancar vuelve al inventario al cerrar la corrida'),
 ('aviso_fuerzas_falta', 'Mitica+ | fuerzas completas, pero todavia queda algun jefe vivo: la corrida no cierra por eso',
                             'aviso cuando las fuerzas llegan al objetivo y la corrida sigue abierta'),
 ('aviso_piedra_de_vuelta', 'Mitica+ | tu piedra de {estancia} nivel {nivel} volvio al inventario',
                             'aviso al devolver la piedra despues de una corrida')
ON DUPLICATE KEY UPDATE `valor` = VALUES(`valor`), `descripcion` = VALUES(`descripcion`);
