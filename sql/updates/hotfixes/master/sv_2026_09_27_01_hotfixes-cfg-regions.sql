-- SV: saca las filas basura de `cfg_regions` que metio el import del cache (build 69933).
--
-- El cliente se caia al conectar con:
--   ERROR #134 Duplicate 'unique key' 78 found for ID 1093 in table Cfg_Regions
-- Causa: el import decodifico Cfg_Regions con un layout equivocado y escribio 5 filas con
-- RegionID=78 y VerifiedBuild=0. Las buenas (VerifiedBuild=69497, RegionID 5/45/85/195/196) quedan.
DELETE FROM `cfg_regions` WHERE `VerifiedBuild` = 0 AND `RegionID` = 78;
