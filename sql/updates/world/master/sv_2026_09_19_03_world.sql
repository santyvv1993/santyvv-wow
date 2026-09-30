-- Banderas de unidad que el core no acepta: se limpian en el DATO (no en memoria)
--
-- Qué pasa hoy: el core valida `unit_flags`, `unit_flags2` y `unit_flags3` de cada plantilla de criatura
-- contra la lista de bits permitidos del propio header (`UnitDefines.h` -> `UNIT_FLAG*_DISALLOWED`) y,
-- cuando encuentra bits que no acepta, los **borra en memoria** y lo avisa en cada arranque
-- (`ObjectMgr.cpp:1125-1140` para `creature_template` y `ObjectMgr.cpp:2334` para los spawns de `creature`).
-- Medido en el log del 19-sep-2026: **23.214 avisos** por `creature_template` (4.151 de `unit_flags`,
-- 12.640 de `unit_flags2`, 6.423 de `unit_flags3`) y **733** por spawns (528 + 205), que en total eran el
-- **28% del log**. El efecto en el juego es **ninguno**: el core ya los estaba borrando, esto solo deja el
-- dato como el core lo usa y saca el ruido.
--
-- De dónde salen las máscaras (NO son números copiados a mano): se calculan leyendo el header del core,
-- `UNIT_FLAG*_ALLOWED = 0xFFFFFFFF & ~UNIT_FLAG*_DISALLOWED`
-- (`fuente/trinitycore/src/server/game/Entities/Unit/UnitDefines.h`):
--   UnitFlags  ALLOWED = 0x02002340 (33563456)
--   UnitFlags2 ALLOWED = 0x04034823 (67323939)
--   UnitFlags3 ALLOWED = 0x014DE0B6 (21881014)
--
-- La condición de cada UPDATE es exactamente la del core (`valor & ~máscara <> 0`), así que la segunda
-- pasada no cambia nada (idempotente). En `creature` las tres columnas son NULL-ables y el NULL se conserva:
-- `NULL & n` es NULL, y el `WHERE` exige `IS NOT NULL`.

UPDATE `creature_template` SET
  `unit_flags`  = `unit_flags`  & 33563456,
  `unit_flags2` = `unit_flags2` & 67323939,
  `unit_flags3` = `unit_flags3` & 21881014
WHERE (`unit_flags`  & ~33563456) <> 0
   OR (`unit_flags2` & ~67323939) <> 0
   OR (`unit_flags3` & ~21881014) <> 0;

UPDATE `creature` SET
  `unit_flags`  = `unit_flags`  & 33563456,
  `unit_flags2` = `unit_flags2` & 67323939,
  `unit_flags3` = `unit_flags3` & 21881014
WHERE (`unit_flags`  IS NOT NULL AND (`unit_flags`  & ~33563456) <> 0)
   OR (`unit_flags2` IS NOT NULL AND (`unit_flags2` & ~67323939) <> 0)
   OR (`unit_flags3` IS NOT NULL AND (`unit_flags3` & ~21881014) <> 0);
