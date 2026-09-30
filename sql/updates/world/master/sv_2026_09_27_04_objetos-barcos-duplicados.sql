-- SV: saca los BARCOS ESTATICOS duplicados del puerto de Ventormenta (27-sep-2026).
--
-- Se veian dos barcos uno sobre otro en el puerto. Causa: la poblacion importada de las capturas
-- trajo los barcos como objetos estaticos, pero los barcos del juego ya existen como TRANSPORTES
-- que se mueven (tabla `transports`: 190536 The Kraken, 294556 The Relentless, 375073 The Rugged Dragonscale).
--
-- De los barcos del puerto, 24 estaban en la banda importada (guid >= 3000000000) y 1 es de Blizzard
-- (esa se deja). Se borran las 24 copias quietas: el barco que se ve navegando es el transporte.
DELETE FROM `gameobject` WHERE `guid` >= 3000000000 AND `id` IN (210081, 269834, 292518, 900756, 322747);
