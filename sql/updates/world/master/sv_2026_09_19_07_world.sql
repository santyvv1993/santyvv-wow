-- Correctiva del lote de plantillas de criatura (sv_2026_09_19_06)
--
-- El lote cerro 328 avisos de objetivos de mision pero introdujo 1.501 lineas en 9 familias
-- (el ruido de una importacion ES la lista de tareas). Cada bloque esta justificado con su linea
-- y con lo que el core hace con ese dato.

-- 1. El `LootID` de las filas de dificultad importadas apunta a listas de botin de la FUENTE que
--    aca no existen (1.135 avisos `used by Creature`). Son marcas de credito: sin botin -> 0.
UPDATE `creature_template_difficulty` SET `LootID` = 0, `PickPocketLootID` = 0, `SkinLootID` = 0
WHERE `Entry` IN (68782,68783,123564,124365,127372,127668,130339,130340,130402,130456,131183,131295,131570,131647,131648,131649,131822,132054,132202,132320,132652,133169,133483,133598,133749,150161,152150,188433,188645,188646,188647,188654,188657,188684,188685,189358,189612,189788,190178,190179,190261,190338,190637,190638,190639,190640,190764,192932,193297,193624,194889,194891,194918,195122,196360,196546,196660,196759,196760,196761,197082,197083,197084,197154,197155,197156,197158,197159,197172,197184,198397,200462,200551,200809,201293,201387,201395,201446,201447,201448,201541,201594,201600,201639,201649,201650,201651,201678,201679,201680,201693,201701,201708,201709,201710,201711,201781,201834,202860,202861,202862,202863,202868,202869,203033,203044,203062,203318,203790,204019,204042,204082,204455,204767,204980,205033,205038,205039,205372,205539,205897,205898,205899,205900,205901,205902,205903,205915,206003,206031,206036,206897,206963,207108,207123,207370,207521,207678,207689,207793,207951,207953,207954,207958,208000,208007,208008,208009,208010,208011,208012,208149,208629,208684,208824,208826,208827,208828,208829,208891,208917,208922,208954,208955,208960,208961,208969,208972,209060,209119,209120,209158,209584,209585,209670,209672,209673,209756,209814,209839,209857,211388,217521,217631,217632,217633,217790,218001,218046,218687,219768,219772,219773,219774,219783,219808,219809,219828,219848,220110,220111,220112,220113,220114,220251,220317,220331,220441,220587,220686,220779,220795,220965,220969,221027,221048,221162,221649,221660,221936,221955,221968,221991,221993,222984,222990,222997,223039,223223,223224,223225,223249,223761,224003,224968,227070,227526,227619,227620,227704,227783,227847,227848,228165,228166,228167,228168,228181,228205,228219,228291,228292,228311,228357,228358,228806,228890,229054,229055,229056,229081,229313,229479,229502,229503,229504,229510,230064,230222,230343,230344,230523,231969,231995,232081,232151,232249,233375,233386,233395,233534,234007,234008,234009,234052,234077,234280,234456,234457,234458,234468,234789,234790,234791,234797,235229,238150,238389,239943,242210,243188,247158,249378,249451,249452,249463,249486,252123,9100174)
  AND (`LootID` <> 0 OR `PickPocketLootID` <> 0 OR `SkinLootID` <> 0);

-- 2. Las plantillas sin fila en `creature_template_model` (258 nuevas + 50 que ya estaban): el core
--    avisa y la criatura no se dibuja. Se les pone el display **11686**, que es la convencion de esta
--    base para criaturas invisibles/utilitarias (13.288 plantillas lo usan: generadores de evento,
--    marcadores, barreras) y el que la propia fuente usa en sus filas con modelo.
--    Por REGLA (toda plantilla sin modelo), asi que la segunda pasada no inserta nada.
INSERT INTO `creature_template_model` (`CreatureID`, `Idx`, `CreatureDisplayID`, `DisplayScale`, `Probability`, `VerifiedBuild`)
SELECT ct.`entry`, 0, 11686, 1, 1, 0 FROM `creature_template` ct
LEFT JOIN `creature_template_model` m ON m.`CreatureID` = ct.`entry` WHERE m.`CreatureID` IS NULL;

-- 3. Faccion 0 en 6 plantillas importadas: a 35, que es lo que el core ya hacia
--    en memoria (misma regla que la migracion `_01`).
UPDATE `creature_template` SET `faction` = 35 WHERE `entry` IN (127372,203318,207108,211388,220587,238389) AND `faction` = 0;

-- 4. `unit_class` 0 en 5 plantillas: a 1 (UNIT_CLASS_WARRIOR), igual que el core.
UPDATE `creature_template` SET `unit_class` = 1 WHERE `entry` IN (127372,131822,133169,207108,220587) AND (`unit_class` = 0 OR `unit_class` > 10);

-- 5. Banderas de unidad no permitidas en 1 plantilla(s): mascara del header (misma regla que `_03`).
UPDATE `creature_template` SET `unit_flags` = `unit_flags` & ~33563456
WHERE `entry` IN (9100174) AND (`unit_flags` & ~33563456) <> `unit_flags`;

-- 6. Filas de IA que el core DESCARTA (161): su `target_param` apunta a una criatura que no
--    tenemos, o usan un `event_type`/`React State` que el core no conoce. Como el core las
--    saltea, se borran: dejarlas es ruido en cada arranque.
DELETE FROM `smart_scripts` WHERE `entryorguid` = 33072 AND `source_type` = 0 AND `id` = 102;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 33131 AND `source_type` = 0 AND `id` = 101;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 33132 AND `source_type` = 0 AND `id` = 101;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 33133 AND `source_type` = 0 AND `id` = 101;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 40221 AND `source_type` = 0 AND `id` = 0;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 41531 AND `source_type` = 0 AND `id` = 101;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 41531 AND `source_type` = 0 AND `id` = 102;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 41666 AND `source_type` = 0 AND `id` = 101;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 41669 AND `source_type` = 0 AND `id` = 101;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 42638 AND `source_type` = 0 AND `id` = 101;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 45197 AND `source_type` = 0 AND `id` = 100;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 45651 AND `source_type` = 0 AND `id` = 101;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 45682 AND `source_type` = 0 AND `id` = 101;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 45874 AND `source_type` = 0 AND `id` = 101;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 49143 AND `source_type` = 0 AND `id` = 101;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 75164 AND `source_type` = 0 AND `id` = 101;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 76484 AND `source_type` = 0 AND `id` = 101;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 77901 AND `source_type` = 0 AND `id` = 101;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 79774 AND `source_type` = 0 AND `id` = 101;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 80807 AND `source_type` = 0 AND `id` = 101;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 83615 AND `source_type` = 0 AND `id` = 101;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 85805 AND `source_type` = 0 AND `id` = 102;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 90993 AND `source_type` = 0 AND `id` = 101;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 92458 AND `source_type` = 0 AND `id` = 101;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 92458 AND `source_type` = 0 AND `id` = 102;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 92458 AND `source_type` = 0 AND `id` = 103;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 94398 AND `source_type` = 0 AND `id` = 101;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 94398 AND `source_type` = 0 AND `id` = 102;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 94429 AND `source_type` = 0 AND `id` = 103;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 95002 AND `source_type` = 0 AND `id` = 102;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 97140 AND `source_type` = 0 AND `id` = 108;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 107376 AND `source_type` = 0 AND `id` = 101;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 116302 AND `source_type` = 0 AND `id` = 103;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 122465 AND `source_type` = 0 AND `id` = 102;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 122701 AND `source_type` = 0 AND `id` = 101;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 124569 AND `source_type` = 0 AND `id` = 2;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 126670 AND `source_type` = 0 AND `id` = 2;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 126700 AND `source_type` = 0 AND `id` = 2;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 130367 AND `source_type` = 0 AND `id` = 0;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 130901 AND `source_type` = 0 AND `id` = 105;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 133167 AND `source_type` = 0 AND `id` = 101;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 133243 AND `source_type` = 0 AND `id` = 0;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 136355 AND `source_type` = 0 AND `id` = 100;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 136356 AND `source_type` = 0 AND `id` = 100;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 136357 AND `source_type` = 0 AND `id` = 100;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 136359 AND `source_type` = 0 AND `id` = 100;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 136360 AND `source_type` = 0 AND `id` = 100;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 136367 AND `source_type` = 0 AND `id` = 100;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 136368 AND `source_type` = 0 AND `id` = 100;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 136369 AND `source_type` = 0 AND `id` = 100;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 136370 AND `source_type` = 0 AND `id` = 100;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 136371 AND `source_type` = 0 AND `id` = 100;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 136372 AND `source_type` = 0 AND `id` = 100;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 142818 AND `source_type` = 0 AND `id` = 100;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 144152 AND `source_type` = 0 AND `id` = 105;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 144384 AND `source_type` = 0 AND `id` = 102;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 144859 AND `source_type` = 0 AND `id` = 100;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 146778 AND `source_type` = 0 AND `id` = 101;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 146842 AND `source_type` = 0 AND `id` = 101;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 147717 AND `source_type` = 0 AND `id` = 101;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 149023 AND `source_type` = 0 AND `id` = 101;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 149024 AND `source_type` = 0 AND `id` = 101;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 150897 AND `source_type` = 0 AND `id` = 101;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 150897 AND `source_type` = 0 AND `id` = 102;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 151162 AND `source_type` = 0 AND `id` = 101;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 152594 AND `source_type` = 0 AND `id` = 100;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 155707 AND `source_type` = 0 AND `id` = 101;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 155707 AND `source_type` = 0 AND `id` = 102;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 159813 AND `source_type` = 0 AND `id` = 101;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 159821 AND `source_type` = 0 AND `id` = 101;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 161909 AND `source_type` = 0 AND `id` = 102;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 161909 AND `source_type` = 0 AND `id` = 104;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 161909 AND `source_type` = 0 AND `id` = 105;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 161909 AND `source_type` = 0 AND `id` = 106;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 162804 AND `source_type` = 0 AND `id` = 104;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 164079 AND `source_type` = 0 AND `id` = 108;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 164336 AND `source_type` = 0 AND `id` = 100;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 164537 AND `source_type` = 0 AND `id` = 102;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 165702 AND `source_type` = 0 AND `id` = 101;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 166887 AND `source_type` = 0 AND `id` = 100;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 166887 AND `source_type` = 0 AND `id` = 102;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 167634 AND `source_type` = 0 AND `id` = 100;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 167745 AND `source_type` = 0 AND `id` = 105;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 170257 AND `source_type` = 0 AND `id` = 100;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 171979 AND `source_type` = 0 AND `id` = 100;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 172605 AND `source_type` = 0 AND `id` = 102;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 174179 AND `source_type` = 0 AND `id` = 101;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 174179 AND `source_type` = 0 AND `id` = 102;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 178425 AND `source_type` = 0 AND `id` = 101;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 180520 AND `source_type` = 0 AND `id` = 2;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 180520 AND `source_type` = 0 AND `id` = 100;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 180523 AND `source_type` = 0 AND `id` = 2;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 180523 AND `source_type` = 0 AND `id` = 100;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 180525 AND `source_type` = 0 AND `id` = 2;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 186378 AND `source_type` = 0 AND `id` = 100;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 188019 AND `source_type` = 0 AND `id` = 100;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 188247 AND `source_type` = 0 AND `id` = 101;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 190015 AND `source_type` = 0 AND `id` = 100;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 190543 AND `source_type` = 0 AND `id` = 102;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 193456 AND `source_type` = 0 AND `id` = 105;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 193987 AND `source_type` = 0 AND `id` = 102;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 193988 AND `source_type` = 0 AND `id` = 102;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 193991 AND `source_type` = 0 AND `id` = 102;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 193995 AND `source_type` = 0 AND `id` = 102;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 198595 AND `source_type` = 0 AND `id` = 102;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 198605 AND `source_type` = 0 AND `id` = 102;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 198907 AND `source_type` = 0 AND `id` = 100;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 199772 AND `source_type` = 0 AND `id` = 101;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 200787 AND `source_type` = 0 AND `id` = 101;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 202277 AND `source_type` = 0 AND `id` = 105;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 203461 AND `source_type` = 1 AND `id` = 101;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 203461 AND `source_type` = 1 AND `id` = 102;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 208506 AND `source_type` = 0 AND `id` = 104;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 216566 AND `source_type` = 0 AND `id` = 101;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 217088 AND `source_type` = 0 AND `id` = 102;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 218912 AND `source_type` = 0 AND `id` = 100;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 222439 AND `source_type` = 0 AND `id` = 101;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 222474 AND `source_type` = 0 AND `id` = 101;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 222481 AND `source_type` = 0 AND `id` = 101;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 223003 AND `source_type` = 0 AND `id` = 101;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 223004 AND `source_type` = 0 AND `id` = 101;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 223012 AND `source_type` = 0 AND `id` = 101;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 223021 AND `source_type` = 0 AND `id` = 101;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 223024 AND `source_type` = 0 AND `id` = 101;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 223025 AND `source_type` = 0 AND `id` = 101;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 223982 AND `source_type` = 0 AND `id` = 101;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 228566 AND `source_type` = 0 AND `id` = 102;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 230320 AND `source_type` = 0 AND `id` = 101;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 230757 AND `source_type` = 0 AND `id` = 102;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 230760 AND `source_type` = 0 AND `id` = 101;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 233878 AND `source_type` = 0 AND `id` = 101;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 244698 AND `source_type` = 0 AND `id` = 101;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 244701 AND `source_type` = 0 AND `id` = 101;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 246537 AND `source_type` = 0 AND `id` = 101;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 251943 AND `source_type` = 0 AND `id` = 101;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 252283 AND `source_type` = 0 AND `id` = 101;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 253055 AND `source_type` = 0 AND `id` = 101;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 254142 AND `source_type` = 0 AND `id` = 101;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 254799 AND `source_type` = 0 AND `id` = 101;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 900208 AND `source_type` = 0 AND `id` = 101;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 900283 AND `source_type` = 0 AND `id` = 2;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 900284 AND `source_type` = 0 AND `id` = 2;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 900285 AND `source_type` = 0 AND `id` = 2;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 9000010 AND `source_type` = 0 AND `id` = 0;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 9000012 AND `source_type` = 0 AND `id` = 0;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 9000014 AND `source_type` = 0 AND `id` = 0;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 9000031 AND `source_type` = 0 AND `id` = 0;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 9000035 AND `source_type` = 0 AND `id` = 0;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 9000038 AND `source_type` = 0 AND `id` = 0;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 9000092 AND `source_type` = 0 AND `id` = 2;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 9000092 AND `source_type` = 0 AND `id` = 3;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 9000092 AND `source_type` = 0 AND `id` = 4;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 9000092 AND `source_type` = 0 AND `id` = 5;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 9000092 AND `source_type` = 0 AND `id` = 6;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 9000092 AND `source_type` = 0 AND `id` = 7;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 9100174 AND `source_type` = 0 AND `id` = 0;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 9100174 AND `source_type` = 0 AND `id` = 3;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 9100541 AND `source_type` = 0 AND `id` = 100;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 9100542 AND `source_type` = 0 AND `id` = 100;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 9100560 AND `source_type` = 0 AND `id` = 101;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 9100734 AND `source_type` = 0 AND `id` = 101;

