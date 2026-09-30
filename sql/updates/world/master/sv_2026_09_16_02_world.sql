-- Puntos de interes (POI) de misiones retiradas: filas huerfanas de `quest_poi` / `quest_poi_points`.
--
-- El core lo delata en cada arranque con dos mensajes distintos (5.635 + 60 lineas):
--
--   `quest_poi` quest id (29549) Idx1 (0) does not exist in `quest_template`   <- ObjectMgr.cpp:8390
--   Table quest_poi references unknown quest points for quest N POI id M       <- ObjectMgr.cpp:8404
--
-- El primero son POI de misiones que ya no existen en `quest_template` (la TDB conserva la huella de
-- contenido retirado). El segundo son POI que no tienen ni un punto en `quest_poi_points`, o sea que
-- no pueden dibujar nada en el mapa. Los dos casos son filas que no se usan nunca: se retiran.
--
-- Alcance medido en esta base: 2.430 misiones retiradas (5.635 filas de `quest_poi`), 12.731 puntos
-- huerfanos en `quest_poi_points` y el resto de los POI sin puntos.
--
-- Migracion nuestra (no viene de la TDB). Idempotente: los DELETE solo tocan filas huerfanas.

-- 1) POI de misiones que ya no existen.
DELETE p FROM `quest_poi` p
LEFT JOIN `quest_template` q ON q.`ID` = p.`QuestID`
WHERE q.`ID` IS NULL;

-- 2) POI que quedaron sin ningun punto (el core los reporta aparte).
DELETE p FROM `quest_poi` p
LEFT JOIN `quest_poi_points` pp ON pp.`QuestID` = p.`QuestID` AND pp.`Idx1` = p.`Idx1`
WHERE pp.`QuestID` IS NULL;

-- 3) Puntos de misiones que ya no existen.
DELETE pp FROM `quest_poi_points` pp
LEFT JOIN `quest_template` q ON q.`ID` = pp.`QuestID`
WHERE q.`ID` IS NULL;

-- 4) Puntos que quedaron sin su POI.
DELETE pp FROM `quest_poi_points` pp
LEFT JOIN `quest_poi` p ON p.`QuestID` = pp.`QuestID` AND p.`Idx1` = pp.`Idx1`
WHERE p.`QuestID` IS NULL;
