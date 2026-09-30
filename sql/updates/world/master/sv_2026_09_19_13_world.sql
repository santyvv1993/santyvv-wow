-- SV migracion sv_2026_09_19_13_world.sql
-- Las pocimas "misteriosas" NO son botin de criatura: salen de la BOLSA misteriosa.
--
-- POR QUE (investigado el 19-sep-2026, despues de ver 3 pocimas en la captura del oficial):
--  * La captura mostro 235838, 235816 y 236870 saliendo de Gork the Basher (156676) y del
--    Darkmaul Centurion (156825), y en casa no estaban. Pero tampoco estan en la fuente de
--    referencia (`ref_lw`), y la razon no es un hueco de datos: **no son botin de criatura**.
--  * Las paginas publicas (warcraft.wiki.gg) dicen que son el contenido de la
--    [Pristine Mysterious Satchel] (`235054`) y de la [Weathered Mysterious Satchel] (`235052`),
--    que reparte el evento "Winds of Mysterious Fortune" al matar o completar misiones en las
--    Islas Dragon y Khaz Algar por debajo de nivel 80.
--  * En la captura se ve exactamente eso: las pocimas entran por `SMSG_ITEM_PUSH_RESULT` +
--    `SMSG_DISPLAY_TOAST` (empujadas a la mochila), no por un saqueo manual del cadaver.
--  * Las probabilidades publicadas (Wowhead, 49.684 aperturas de la bolsa impecable) son:
--      Revivification 16,25 % · Celerity 15,99 % · Tenacity 15,76 % · Swiftstrike 15,20 %
--      Frostbound 4,55 % · Conflagration 4,35 % · Systemshock 4,30 % · Tremorshards 4,27 %
--    (la Description del juego dice "contiene UNA de las siguientes pocimas", asi que van en un
--    mismo grupo: se normalizan a pesos que suman 100).
--  * La bolsa "desgastada" (235052) NO trae pocimas (su lista es de cosmetica y utiles).
--
-- ALCANCE: se declaran SOLO las pocimas, que es lo que la captura pidio. El resto del contenido
-- (piezas del conjunto Misterioso, utiles y cosmeticos) queda pendiente: su modelo es de varios
-- grupos ("una pocima + una pieza + un util") y no esta cerrado con fuente firme.
-- La bolsa solo cae con el evento, que nuestro servidor no implementa todavia: esta tabla deja el
-- contenido listo para ese dia (hoy es inerte, no cambia nada en el juego).
-- filas a insertar: 8
INSERT INTO `item_loot_template` (`Entry`, `ItemType`, `Item`, `Chance`, `QuestRequired`, `LootMode`, `GroupId`, `MinCount`, `MaxCount`, `Comment`) VALUES
(235054, 0, 235843, 20.14, 0, 1, 1, 1, 1, 'Potion of Mysterious Revivification - 16,25% de 49.684 aperturas (Wowhead)'),
(235054, 0, 235803, 19.82, 0, 1, 1, 1, 1, 'Potion of Mysterious Celerity - 15,99% (Wowhead)'),
(235054, 0, 235838, 19.53, 0, 1, 1, 1, 1, 'Potion of Mysterious Tenacity - 15,76% (Wowhead; vista en la captura)'),
(235054, 0, 235816, 18.84, 0, 1, 1, 1, 1, 'Potion of Mysterious Swiftstrike - 15,20% (Wowhead; vista en la captura)'),
(235054, 0, 236857,  5.64, 0, 1, 1, 1, 1, 'Potion of Mysterious Frostbound - 4,55% (Wowhead)'),
(235054, 0, 236854,  5.40, 0, 1, 1, 1, 1, 'Potion of Mysterious Conflagration - 4,35% (Wowhead)'),
(235054, 0, 236856,  5.33, 0, 1, 1, 1, 1, 'Potion of Mysterious Systemshock - 4,30% (Wowhead)'),
(235054, 0, 236870,  5.29, 0, 1, 1, 1, 1, 'Potion of Mysterious Tremorshards - 4,27% (Wowhead; vista en la captura)');
