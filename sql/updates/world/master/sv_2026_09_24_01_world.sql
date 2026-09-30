-- SV migracion sv_2026_09_24_01_world.sql
-- Fases que las condiciones YA declaraban y que nunca se declararon en `phase_area`.
--
-- SINTOMA: en cada arranque, logs/DBErrors.log traia 30 lineas como esta:
--   [Condition SourceType: (Phase), SourceGroup: 13807, SourceEntry: 7819, ConditionType: 47 (Quest state mask)]
--   Area 7819 does not have phase 13807.
--
-- POR QUE PASA: el core carga `phase_area` (que fases existen en que area) y a cada fase le cuelga
-- las condiciones del tipo 26 de `conditions` (cuando se aplica). Sin fila en `phase_area` la
-- condicion no tiene donde colgarse: el core la descarta y la loguea, asi que la fase nunca se
-- aplica en esa area y los NPC de esa fase no se le hacen visibles al jugador.
--
-- DE DONDE VIENEN ESAS CONDICIONES: de la migracion sv_2026_09_18_42_world.sql (paquete publico
-- LoreWalkerTDB, release RetailCoreTDP1207, cargado en la base de referencia `ref_lw`). Su filtro
-- "solo lo que apunta a algo que existe en casa" validaba la FASE y el AREA por separado; el par
-- (AreaId, PhaseId) nunca se verifico contra `phase_area`.
--
-- Y AQUI ESTA LO IMPORTANTE: de los 21 pares, 8 SI estaban declarados en el paquete y NO se
-- importaron (fase 6666 en areas 5150/5390/6292, 9033 en 14690, 14081 en 10534, 18890 en 10565,
-- 19930 en 7581, 19931 en 7502). O sea: el dato lo teniamos. Los otros 8 pares tampoco existen en
-- `ref_lw.phase_area` (1519/6666, 10424/13785, 10424/13794, 7486/13807, 7819/13807, 7741/19912,
-- 41/21015, 2562/21015) ni en `base_tdb` (660 filas): ahi la unica prueba de que la fase aplica en
-- esa area es la propia condicion, que es la otra mitad de la misma regla.
--
-- ORDEN DE LAS CLAVES (se presta a confusion): en `conditions` tipo 26, `SourceEntry` es el AreaId
-- y `SourceGroup` es el PhaseId.
--
-- BLOQUE A: declara en `phase_area` las 16 fases que faltaban (11 fases en 16 pares area/fase).
--   Fase verificada contra el Phase.db2 del cliente (datos/dbc/esMX/Phase.db2): los 11 IDs aparecen.
--   OJO: `phase_name` es solo una lista PARCIAL de nombres, no la lista de fases -- que una fase no
--   este ahi no significa que no exista (el core valida contra Phase.db2, no contra phase_name).
-- BLOQUE B: borra las condiciones (8 filas) de las fases 41053-41057. Esas fases venian del paquete
--   (que si las declara en la zona 13769) pero en NUESTRO cliente no aparecen por ningun lado:
--   0 apariciones del ID en Phase.db2 (los otros 11 IDs aparecen 1 vez cada uno), sin fila en
--   `phase_name`, y los spawns dracthyr ya se habian neutralizado en sv_2026_09_18_03_world.sql
--   (PhaseId=0). Sin fase_area esas condiciones no pueden aplicarse nunca, asi que borrarlas no
--   cambia el juego: solo quita los errores del arranque. Si algun dia se confirma que el cliente
--   conoce esas fases, se re-declaran en phase_area y las condiciones se vuelven a escribir.
--
-- Idempotente: cada bloque borra su clave exacta antes de insertar.
-- Lista obtenida de la viva: conditions tipo 26 cuya (AreaId, PhaseId) no existe en phase_area.
-- Verificado el 2026-09-24 contra world (127.0.0.1:3307) y validado en copia antes de aplicar.

-- ===== A: fases que faltaba declarar en su area (16 filas) =====
DELETE FROM `phase_area` WHERE
 (`AreaId`=1519  AND `PhaseId`=6666) OR
 (`AreaId`=5150  AND `PhaseId`=6666) OR
 (`AreaId`=5390  AND `PhaseId`=6666) OR
 (`AreaId`=6292  AND `PhaseId`=6666) OR
 (`AreaId`=14690 AND `PhaseId`=9033) OR
 (`AreaId`=10424 AND `PhaseId`=13785) OR
 (`AreaId`=10424 AND `PhaseId`=13794) OR
 (`AreaId`=7486  AND `PhaseId`=13807) OR
 (`AreaId`=7819  AND `PhaseId`=13807) OR
 (`AreaId`=10534 AND `PhaseId`=14081) OR
 (`AreaId`=10565 AND `PhaseId`=18890) OR
 (`AreaId`=7741  AND `PhaseId`=19912) OR
 (`AreaId`=7581  AND `PhaseId`=19930) OR
 (`AreaId`=7502  AND `PhaseId`=19931) OR
 (`AreaId`=41    AND `PhaseId`=21015) OR
 (`AreaId`=2562  AND `PhaseId`=21015);

INSERT INTO `phase_area` (`AreaId`, `PhaseId`, `Comment`) VALUES
(1519,  6666,  'Pre-Broken Shore Stormwind Habor'),
(5150,  6666,  'Pre-Broken Shore Stormwind Habor'),
(5390,  6666,  'Pre-Broken Shore Stormwind Habor'),
(6292,  6666,  'Pre-Broken Shore Stormwind Habor'),
(14690, 9033,  'Cosmetic - See freed Trevor, Travis, Kyle and Burke'),
(10424, 13785, 'Cosmetic - NPE - See Alliance crew at Darkmaul Plains'),
(10424, 13794, 'Cosmetic - 9.0 NPE - Alliance Populated Camp'),
(7486,  13807, 'Quest - Draconic Connections'),
(7819,  13807, 'Quest - Draconic Connections'),
(10534, 14081, 'Pelagos for Quest: A Soulbind in need'),
(10565, 18890, 'Cosmetic - See Shadowlands Season 4 Coin Vendors'),
(7741,  19912, 'Quest - Final Orders'),
(7581,  19930, 'Cosmetic - See Chef''s Hoard (lootable) at Ruby Feast'),
(7502,  19931, 'Cosmetic - See Chef''s Hoard (non-lootable) at Ruby Feast'),
(41,    21015, 'Cosmetic - See Shandris Feathermoon in Valdrakken'),
(2562,  21015, 'Cosmetic - See Shandris Feathermoon in Valdrakken');

-- ===== B: condiciones de fases que no existen en el cliente (8 filas) =====
DELETE FROM `conditions`
 WHERE `SourceTypeOrReferenceId`=26
   AND `SourceGroup` IN (41053,41054,41055,41056,41057)
   AND `SourceEntry`=13769;
