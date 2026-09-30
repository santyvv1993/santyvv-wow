-- sv_2026_09_18_04_world.sql
-- CORRECTIVA del lote 03: limpia lo que el arranque del 18-sep-2026 reporto en DBErrors.log
-- (de 160.390 lineas de base a 165.042 tras aplicar el 03; este archivo apunta a volver a la base).
-- Cada bloque es idempotente y esta justificado por una linea concreta del log.
--
-- Resumen:
-- UNIT_FLAG_ALLOWED calculado del header: 0x02002300 (descartado: 0xFDFFDCFF)
-- A. phase_name nuevas: 120
-- B. unit_flags normalizados: 3204 filas
-- C. gameobject.phaseGroup puestos a 0: 141
-- C. creature.PhaseId puestos a 0: 608
-- C. gameobject.PhaseId puestos a 0: 63
-- D. terreno/rotacion de objetos normalizados: 865 filas con terreno distinto de 0
-- F. filas de guion invalidas borradas: 6 (entradas [181494, 182168, 184269])
-- G. spawns de objeto borrados por falta de plantilla: 29 (entradas [375102, 376123, 376551, 376560, 376565, 376793, 377317, 377367])
--
-- AVISOS:
--  (ninguno)

-- ===== A. fases que faltaban en phase_name =====
DELETE FROM `phase_name` WHERE `ID` IN (45699,45700,45701,45702,45703,45704,45705,45706,45707,45708,45709,45710,45711,45712,45713,45714,45715,45716,45717,45718,45719,45720,45721,45722,45723,45724,45725,45726,45727,45728,45729,45730,45731,45732,45733,45734,45735,45736,45737,45844,45845,45846,45847,45848,45849,45851,45852,46111,46112,46113,46114,46115,46116,46117,46118,46119,46120,46122,46123,46124,46125,46126,46127,46128,46129,46130,46131,46132,46134,46135,46136,46137,46138,46139,46140,46141,46142,46143,46144,46145,46146,46147,46148,46149,46150,46151,46152,46153,46154,46155,46156,46157,46158,46160,46161,46162,46163,46164,46165,46166,46167,46168,46169,46171,46172,46173,46174,46175,46176,46177,46178,46179,46727,46728,46729,46730,46731,46732,46733,46734);

-- fases referenciadas por los spawns importados (120 filas)
INSERT INTO `phase_name` (`ID`, `Name`) VALUES
(45699, 'Orwenya and Hald. in Har´athir'),
(45700, 'Hald. in VoD'),
(45701, 'Hald. in VoD#Flight'),
(45702, 'Council meeting'),
(45703, ' Hagar at the Den of Echoes'),
(45704, ' Hagar at the Den of Echoes#2'),
(45705, ' Hagar at the Den of Echoes#3'),
(45706, ' Hagar at the Den of Echoes#Echos'),
(45707, ' Hagar at the Den of Echoes#4'),
(45708, 'Observer Talos'),
(45709, ' Hagar at the Den of Echoes#5'),
(45710, ' Orweyna after Delve'),
(45711, ' Hagar after Delve'),
(45712, 'Orweyna in Har´mara'),
(45713, 'Traveling Flowers in Har´mara'),
(45714, 'followed Orweyna in Har´mara'),
(45715, 'Culling the Spread in Har´mara'),
(45716, 'Bitterbloom in Har´mara'),
(45717, 'Eonka in Har´mara (Upstairs)'),
(45718, 'Orweyna and Har Returned to the Den.'),
(45719, 'Harmara Battle'),
(45720, 'After Harmara Battle'),
(45721, 'Welcome tour with O'),
(45722, 'Orweyna and Ama. at Valley of Dust'),
(45723, 'Orweyna at Valley of Dust'),
(45724, 'Alndust placed at Valley of Dust'),
(45725, 'Wards at Valley of Dust'),
(45726, 'Orweyna and Ama. at Valley of Dust#2'),
(45727, 'Orweyna and Ama. at Valley of Dust#2BOSS'),
(45728, 'Orweyna and Ama. at Valley of Dust#3'),
(45729, ' 3 Wards around the Rift of Aln'),
(45730, 'Orweyna and Ama. at Valley of Dust#4'),
(45731, 'Orweyna and Ama. at Valley of Dust#4Boss'),
(45732, 'Orweyna in Haralnor'),
(45733, 'Orweyna in Haralnor#2'),
(45734, 'Orweyna in Haralnor#3'),
(45735, 'Orweyna in Haralnor#4'),
(45736, 'Orweyna in Den after Haralnor'),
(45737, 'Orweyna in Den after Haralnor#2'),
(45844, 'Haranir Intro: Rootsabove all'),
(45845, 'Haranir Intro: Orw#1'),
(45846, 'Haranir Intro: Resc#1'),
(45847, 'Haranir Intro: Orw#2'),
(45848, 'Haranir Intro: VisionConcl#1'),
(45849, 'Haranir Intro: VisionConcl#2'),
(45851, 'Haranir Intro: After Visions'),
(45852, 'Haranir Intro: Portals'),
(46111, 'Orw after seeing Gazelow'),
(46112, 'Orw after resc Gazelow'),
(46113, 'caught gazlowe'),
(46114, 'Orweyna and Gazlowe around the Cradle and the Den'),
(46115, 'Orweyna and Gazlowe around the Cradle and the Den#2'),
(46116, 'Kamari#1'),
(46117, 'Kamari#2'),
(46118, 'KuriQuest'),
(46119, 'KuriQuest#Beast'),
(46120, 'KuriQuest#After Beast'),
(46122, 'Missing company of rutaani and haranir'),
(46123, 'Neyleia at company of rutaani and haranir'),
(46124, 'Ney´leia near the northeastern cave in Fungal Cleft.'),
(46125, 'Gathering Glowshrooms in Fungal Cleft.'),
(46126, 'Su´meera near Blooming Lattice#1'),
(46127, 'Su´meera near Blooming Lattice#2'),
(46128, 'Su´meera near Blooming Lattice#3'),
(46129, 'Su´meera near Blooming Lattice#Final'),
(46130, 'Su´meera near Blooming Lattice#AfterFinal'),
(46131, 'A Game of Silence and Shadow'),
(46132, 'A Game of Silence and Shadow#GAME'),
(46134, 'After the Games (Lost one)'),
(46135, 'After attacking brds#Boss'),
(46136, 'After attacking brds'),
(46137, 'After attacking brds#afterBoss'),
(46138, 'Sporeglider Bloomterror'),
(46139, 'Yurelen#1'),
(46140, 'Yurelen#2'),
(46141, 'Ghikal#1'),
(46142, 'Ghikal#2'),
(46143, 'Blooming Corpse'),
(46144, 'Growths of Fruiting Mycelium'),
(46145, 'Zombified Guardian'),
(46146, 'ZHagar at Harmarar'),
(46147, 'ZHagar at Shrine'),
(46148, 'Roots under fire'),
(46149, 'On Hunt'),
(46150, 'A Hunters Prey'),
(46151, 'The Stroke of Storms'),
(46152, 'After The Stroke of Storms'),
(46153, 'before The Stroke of Storms'),
(46154, 'after after The Stroke of Storms'),
(46155, 'Budlings before the marked areas'),
(46156, 'Budlings after the marked areas'),
(46157, 'Hannan#1'),
(46158, 'Hannan#2'),
(46160, 'Hannan#RKQ'),
(46161, 'Spar with your teammates.'),
(46162, 'After Spar with your teammates.'),
(46163, 'before Spar with your teammates.'),
(46164, 'Speak to each of your teammates to choose a name.'),
(46165, 'First fights in the ring'),
(46166, 'To the Ring'),
(46167, 'Tuktuk scared'),
(46168, 'Mushrooming Courage'),
(46169, 'Mushrooming Resilience'),
(46171, 'Defeat the Glow Guard'),
(46172, ' Enliahn before the cliffside above the Rift of Aln.'),
(46173, ' Enliahn on the cliffside above the Rift of Aln.'),
(46174, ' En´liahn to discover the ritual site within the Rift of Aln'),
(46175, ' En´liahn after discover the ritual site within the Rift of Aln'),
(46176, ' Titems within the Rift of Aln'),
(46177, 'The Final Rite'),
(46178, 'After The Final Rite'),
(46179, 'After After The Final Rite'),
(46727, '12.0.7: Hub in Den'),
(46728, '12.0.7: Hub in Den#2'),
(46729, '12.0.7: After Hub in Den'),
(46730, '12.0.7: After Hub in Den#2'),
(46731, '12.0.7: After Hub in Den#3'),
(46732, '12.0.7: After Hub in Den#4'),
(46733, '12.0.7: After Hub in Den#4ULATEK'),
(46734, '12.0.7: After Hub in Den#Poral');


-- ===== B. unit_flags: se descartan los bits que el core rechaza =====
-- (el core igual los borraba al cargar: esto solo evita 3204 lineas en DBErrors.log)
UPDATE `creature` SET `unit_flags` = `unit_flags` & 33563392
 WHERE `guid` BETWEEN 3100000001 AND 3100009999 AND `unit_flags` IS NOT NULL AND (`unit_flags` & ~33563392) <> 0;

UPDATE `gameobject` SET `phaseGroup` = 0 WHERE `guid` BETWEEN 305000001 AND 305000999 AND `phaseGroup` > 0 AND `phaseGroup` NOT IN (SELECT `ID` FROM `phase_name`);

UPDATE `creature` SET `PhaseId` = 0 WHERE `guid` BETWEEN 3100000001 AND 3100009999 AND `PhaseId` > 0 AND `PhaseId` NOT IN (SELECT `ID` FROM `phase_name`);

UPDATE `gameobject` SET `PhaseId` = 0 WHERE `guid` BETWEEN 305000001 AND 305000999 AND `PhaseId` > 0 AND `PhaseId` NOT IN (SELECT `ID` FROM `phase_name`);

-- ===== D. terreno y rotaciones de los objetos importados =====
-- el paquete trae terrainSwapMap negativo y rotation0..3 fuera de rango: el core
-- descartaba la rotacion y SALTEA el objeto. La orientacion del paquete si es valida,
-- asi que el cuaternion se deriva de ella (yaw: x=0, y=0, z=sin(o/2), w=cos(o/2)).
UPDATE `gameobject` SET `terrainSwapMap` = 0
 WHERE `guid` BETWEEN 305000001 AND 305000999 AND `terrainSwapMap` <> 0;

UPDATE `gameobject`
   SET `rotation0` = 0,
       `rotation1` = 0,
       `rotation2` = SIN(`orientation` / 2),
       `rotation3` = COS(`orientation` / 2)
 WHERE `guid` BETWEEN 305000001 AND 305000999
   AND (ABS(`rotation0`) > 1 OR ABS(`rotation1`) > 1 OR ABS(`rotation2`) > 1 OR ABS(`rotation3`) > 1);

-- ===== F. guiones que este core no acepta =====
-- el paquete usa eventos enlazados (id 10000/10001 con link) que SmartScriptMgr rechaza:
-- generaban un error por arranque y el par entero no se cargaba. Se borran las filas del par;
-- el resto del guion de esas entradas (que si carga) queda intacto.
DELETE FROM `smart_scripts` WHERE (`entryorguid`, `id`) IN ((181494,10000),(181494,10001),(182168,10000),(182168,10001),(184269,10000),(184269,10001));

-- ===== G. objetos sin plantilla (ni aca ni en el paquete) =====
-- no pueden aparecer: el core los saltea con "non existing gameobject entry".
-- Se borran sus spawns; si algun dia se importa el `hotfixes.sql` del paquete se pueden reponer.
DELETE FROM `gameobject` WHERE `guid` IN (305000119,305000120,305000121,305000122,305000123,305000124,305000125,305000126,305000127,305000128,305000129,305000139,305000140,305000142,305000148,305000149,305000150,305000152,305000164,305000268,305000278,305000279,305000280,305000282,305000283,305000284,305000333,305000334,305000335);
