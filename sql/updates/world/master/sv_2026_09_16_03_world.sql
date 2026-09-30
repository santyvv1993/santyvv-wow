-- Botin de los nodos de recoleccion (y cofres/pozos) que el cliente pide y la TDB no trae.
--
-- El core lo delata en cada arranque (5.790 lineas del ultimo levante):
--
--   Table 'gameobject_loot_template' Entry N does not exist but it is used by Gameobject M
--       (LootMgr.cpp:239 desde ReportNonExistingId en :1196; para un nodo de recoleccion se pide en
--        GameObject.cpp:3481 y para un pozo de pesca en :3254, ambos via GetLootId())
--
-- OJO CON EL CONTEO: el campo `Data1` de `gameobject_template` solo ES un id de botin en los tipos
-- 3 (cofre), 25 (pozo de pesca) y 50 (nodo de recoleccion) -- lo dice GetLootId()
-- (GameObjectData.h:1139). Contando bien el hueco son 7.273 plantillas, no 40.202. De las que tienen
-- aparicion real quedan 32 entradas / 1.250 apariciones, y el grueso son vetas y hierbas que al
-- recolectarse no daban NADA: Titanium Vein (505 apariciones), Obsidium (116), Small Thorium (104),
-- Silver Vein (97), Elementium (91), Icecap (84), Heartblossom (60), Stormvine (41), Mana Thistle
-- (37), Twilight Jasmine (26), Whiptail (21), Algaefin Rockfish School (21)...
--
-- DE DONDE SALE EL CONTENIDO (no se invento): de la base de la MISMA EXPANSION del nodo, que es
-- publica y usa los mismos ids de cliente:
--   * TDB 335.26091 (WotLK): Silver Vein, Small Thorium Vein, Titanium Vein, Icecap, Mana Thistle
--   * TDB 442.26081 (Cata) : Obsidium y Elementium (y sus vetas ricas), Pyrite, Stormvine,
--                            Heartblossom, Twilight Jasmine, Whiptail
--   * hermano moderno      : cuando el mismo nodo tiene OTRA entrada que si tiene botin en la TDB
--                            actual (Silver Vein go 105569, Small Thorium go 176643, Cache of
--                            Storms, los cofres de la Cruzada Argentea, Obsidium go 203278) se copia
--                            esa, que trae los valores ya ajustados de hoy.
--
-- LA EQUIVALENCIA QUEDO VALIDADA por tres lados:
--   1) nodos que ya funcionaban: Iron Deposit en la TDB 335 (loot 1505) y en la actual (loot 51297)
--      tiene los MISMOS 6 items con las MISMAS probabilidades; solo cambia el numero de la tabla.
--      Igual Mithril (1742 vs 51300), Truesilver (5045 vs 51299) y Saronita (24155 vs 51308).
--   2) el mapeo de columnas se reproduce exacto: las 3 filas viejas de Small Thorium (9597) dan
--      (0,10620,100,2,3) (0,12365,100,1,5) (1,12900,15,1,1), identicas a las de la TDB actual.
--   3) el contenido coincide con lo que documenta la wiki para cada nodo (Titanium Vein: mineral de
--      titanio + gemas + cristalizados).
--
-- MAPEO ENTRE ERAS: en la TDB 335 la tabla tiene (Entry, Item, Reference, Chance...) donde
-- `Reference` es el ID de una tabla de `reference_loot_template` (0 = item normal). Hoy eso se
-- escribe (Entry, ItemType, Item, Chance...) con ItemType = 1 y el id de la referencia en `Item`.
-- Los items normales van con ItemType = 0. (Antes se habia interpretado `Reference` como un booleano
-- y eso reventaba la carga con "Out of range value for column 'ItemType'".)
--
-- QUEDA SIN FUENTE (2 apariciones o menos; no vale la pena inventarles el botin): Cache of the
-- Broodmother, Stolen Skyhorn Goods, Riverbud, Rising Glory, Nightshade, Laestrite Deposit, Mature
-- Highland Milkweed, Ripe Cuppressa, Irradiated Mycobloom y Algaefin Rockfish School (esta ultima
-- tiene 21 apariciones y no aparece en ninguna de las dos bases de la era: queda anotada).
--
-- Migracion nuestra (no viene de la TDB). Idempotente: borra y reinserta SOLO estos ids de botin,
-- que hoy no tienen ninguna fila.

DELETE FROM `gameobject_loot_template` WHERE `Entry` IN (26951,27432,27433,27434,27435,27519,51295,51298,51310,51311,51312,51313,51314,51452,51498,51504,51516,51517,51518,51519);

INSERT INTO `gameobject_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) VALUES
(26951,0,45784,100,1,1,0,1,1,'Cache of Storms'),
(26951,0,45928,0,0,1,1,1,1,'Cache of Storms'),
(26951,0,45929,0,0,1,1,1,1,'Cache of Storms'),
(26951,0,45930,0,0,1,1,1,1,'Cache of Storms'),
(26951,0,45931,0,0,1,1,1,1,'Cache of Storms'),
(26951,0,45933,0,0,1,1,1,1,'Cache of Storms'),
(26951,1,12032,100,0,1,0,1,1,'Cache of Storms'),
(26951,1,34371,100,0,1,0,1,1,'Cache of Storms'),
(27432,0,47556,100,0,1,0,1,1,'Argent Crusade Tribute Chest'),
(27432,1,12002,100,0,1,0,1,4,'Argent Crusade Tribute Chest'),
(27432,1,34287,100,0,1,0,1,1,'Argent Crusade Tribute Chest'),
(27432,1,34288,100,0,1,0,1,1,'Argent Crusade Tribute Chest'),
(27432,1,34291,100,0,1,0,1,1,'Argent Crusade Tribute Chest'),
(27432,1,34292,100,0,1,0,1,1,'Argent Crusade Tribute Chest'),
(27432,1,34293,100,0,1,0,1,4,'Argent Crusade Tribute Chest'),
(27433,0,47556,100,0,1,0,1,1,'Argent Crusade Tribute Chest'),
(27433,1,12002,100,0,1,0,1,4,'Argent Crusade Tribute Chest'),
(27433,1,34287,100,0,1,0,1,1,'Argent Crusade Tribute Chest'),
(27433,1,34288,100,0,1,0,1,1,'Argent Crusade Tribute Chest'),
(27433,1,34291,100,0,1,0,1,1,'Argent Crusade Tribute Chest'),
(27433,1,34292,100,0,1,0,1,1,'Argent Crusade Tribute Chest'),
(27433,1,34293,100,0,1,0,1,4,'Argent Crusade Tribute Chest'),
(27434,0,47556,100,0,1,0,1,1,'Argent Crusade Tribute Chest'),
(27434,1,12002,100,0,1,0,1,4,'Argent Crusade Tribute Chest'),
(27434,1,34287,100,0,1,0,1,1,'Argent Crusade Tribute Chest'),
(27434,1,34288,100,0,1,0,1,1,'Argent Crusade Tribute Chest'),
(27434,1,34291,100,0,1,0,1,1,'Argent Crusade Tribute Chest'),
(27434,1,34292,100,0,1,0,1,1,'Argent Crusade Tribute Chest'),
(27434,1,34293,100,0,1,0,1,4,'Argent Crusade Tribute Chest'),
(27435,0,47556,100,0,1,0,1,1,'Argent Crusade Tribute Chest'),
(27435,1,12002,100,0,1,0,1,4,'Argent Crusade Tribute Chest'),
(27435,1,34287,100,0,1,0,1,1,'Argent Crusade Tribute Chest'),
(27435,1,34288,100,0,1,0,1,1,'Argent Crusade Tribute Chest'),
(27435,1,34291,100,0,1,0,1,1,'Argent Crusade Tribute Chest'),
(27435,1,34292,100,0,1,0,1,1,'Argent Crusade Tribute Chest'),
(27435,1,34293,100,0,1,0,1,4,'Argent Crusade Tribute Chest'),
(27519,0,47556,100,0,1,0,1,1,'Argent Crusade Tribute Chest'),
(27519,1,12002,100,0,1,0,1,4,'Argent Crusade Tribute Chest'),
(27519,1,34287,100,0,1,0,1,1,'Argent Crusade Tribute Chest'),
(27519,1,34288,100,0,1,0,1,1,'Argent Crusade Tribute Chest'),
(27519,1,34291,100,0,1,0,1,1,'Argent Crusade Tribute Chest'),
(27519,1,34292,100,0,1,0,1,1,'Argent Crusade Tribute Chest'),
(27519,1,34293,100,0,1,0,1,4,'Argent Crusade Tribute Chest'),
(51295,0,1206,5,0,1,1,1,1,'Silver Vein'),
(51295,0,1210,5,0,1,1,1,1,'Silver Vein'),
(51295,0,1705,5,0,1,1,1,1,'Silver Vein'),
(51295,0,2775,100,0,1,0,2,4,'Silver Vein'),
(51298,0,10620,100,0,1,0,1,8,'Small Thorium Vein'),
(51298,0,11513,50,0,1,0,1,1,'Small Thorium Vein'),
(51298,0,12365,100,0,1,0,1,10,'Small Thorium Vein'),
(51298,1,12900,15,0,1,0,1,1,'Small Thorium Vein'),
(51298,1,12900,15,0,1,0,1,1,'Ooze Covered Thorium Vein'),
(51298,0,10620,100,0,1,0,2,3,'Ooze Covered Thorium Vein'),
(51298,0,12365,100,0,1,0,1,5,'Ooze Covered Thorium Vein'),
(51298,0,10620,100,0,1,0,1,8,'Small Thorium Vein'),
(51298,0,11513,50,0,1,0,1,1,'Small Thorium Vein'),
(51298,0,12365,100,0,1,0,1,10,'Small Thorium Vein'),
(51298,1,12900,15,0,1,0,1,1,'Small Thorium Vein'),
(51310,0,52327,10,0,1,0,1,2,'Obsidium Deposit'),
(51310,0,52328,10,0,1,0,1,2,'Obsidium Deposit'),
(51310,0,53038,100,0,1,0,2,4,'Obsidium Deposit'),
(51310,1,12907,5,0,1,0,1,1,'Obsidium Deposit'),
(51310,1,12908,2,0,1,0,1,1,'Obsidium Deposit'),
(51311,1,12907,5,0,1,0,1,1,'Rich Obsidium Deposit'),
(51311,1,12908,2,0,1,0,1,1,'Rich Obsidium Deposit'),
(51311,0,52327,10,0,1,0,3,4,'Rich Obsidium Deposit'),
(51311,0,52328,10,0,1,0,3,4,'Rich Obsidium Deposit'),
(51311,0,53038,100,0,1,0,5,7,'Rich Obsidium Deposit'),
(51312,1,12907,5,0,1,0,1,1,'Elementium Vein'),
(51312,1,12908,2,0,1,0,1,1,'Elementium Vein'),
(51312,0,52185,100,0,1,0,2,4,'Elementium Vein'),
(51312,0,52325,10,0,1,0,1,2,'Elementium Vein'),
(51312,0,52326,10,0,1,0,1,2,'Elementium Vein'),
(51312,0,52327,10,0,1,0,1,2,'Elementium Vein'),
(51312,0,52328,2,0,1,0,1,2,'Elementium Vein'),
(51312,0,67282,0.05,0,1,0,1,1,'Elementium Vein'),
(51313,1,12907,5,0,1,0,1,1,'Rich Elementium Vein'),
(51313,1,12908,2,0,1,0,1,1,'Rich Elementium Vein'),
(51313,0,52185,100,0,1,0,5,7,'Rich Elementium Vein'),
(51313,0,52325,10,0,1,0,1,2,'Rich Elementium Vein'),
(51313,0,52326,10,0,1,0,1,2,'Rich Elementium Vein'),
(51313,0,52327,10,0,1,0,1,2,'Rich Elementium Vein'),
(51313,0,52328,2,0,1,0,1,2,'Rich Elementium Vein'),
(51313,0,67282,0.1,0,1,0,1,1,'Rich Elementium Vein'),
(51314,1,12907,5,0,1,0,1,1,'Pyrite Deposit'),
(51314,1,12908,2,0,1,0,1,1,'Pyrite Deposit'),
(51314,0,52183,100,0,1,0,2,4,'Pyrite Deposit'),
(51314,0,52325,10,0,1,0,1,2,'Pyrite Deposit'),
(51314,0,52328,10,0,1,0,1,2,'Pyrite Deposit'),
(51452,1,12905,25,0,1,0,1,1,'Titanium Vein'),
(51452,1,12906,5,0,1,0,1,1,'Titanium Vein'),
(51452,0,36910,100,0,1,0,2,4,'Titanium Vein'),
(51452,0,37700,50,0,1,0,3,6,'Titanium Vein'),
(51452,0,37701,50,0,1,0,3,6,'Titanium Vein'),
(51452,0,37702,50,0,1,0,3,6,'Titanium Vein'),
(51452,0,37705,50,0,1,0,3,6,'Titanium Vein'),
(51498,0,13467,100,0,1,0,1,3,'Icecap'),
(51504,0,22575,15,0,1,0,1,3,'Mana Thistle'),
(51504,0,22793,100,0,1,0,1,3,'Mana Thistle'),
(51504,0,22794,3,0,1,0,1,1,'Mana Thistle');

INSERT INTO `gameobject_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) VALUES
(51504,0,35229,25,1,1,0,1,1,'Mana Thistle'),
(51516,0,52329,25,0,1,0,1,4,'Stormvine'),
(51516,0,52984,100,0,1,0,2,4,'Stormvine'),
(51516,0,63122,10,0,1,0,1,1,'Stormvine'),
(51517,0,52329,25,0,1,0,1,4,'Heartblossom'),
(51517,0,52986,100,0,1,0,2,4,'Heartblossom'),
(51517,0,63122,10,0,1,0,1,1,'Heartblossom'),
(51518,0,52329,25,0,1,0,1,4,'Whiptail'),
(51518,0,52988,100,0,1,0,2,4,'Whiptail'),
(51518,0,63122,10,0,1,0,1,1,'Whiptail'),
(51519,0,52329,25,0,1,0,1,4,'Twilight Jasmine'),
(51519,0,52987,100,0,1,0,2,4,'Twilight Jasmine'),
(51519,0,63122,10,0,1,0,1,1,'Twilight Jasmine');
