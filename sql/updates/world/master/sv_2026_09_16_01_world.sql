-- Criaturas con relacion de mision pero sin el flag de dador/receptor de misiones.
--
-- El core lo delata en cada arranque (1.820 + 217 lineas en el ultimo levante):
--
--   Table `creature_questender` has creature entry (270) for quest 377, but npcflag does not
--       include UNIT_NPC_FLAG_QUESTGIVER                              <- ObjectMgr.cpp:8600
--   Table `creature_queststarter` has creature entry (N) for quest N, but npcflag does not
--       include UNIT_NPC_FLAG_QUESTGIVER                              <- ObjectMgr.cpp:8586
--
-- La fila de la relacion ya dice la intencion (esa criatura da/cierra esa mision) y NINGUNA de las
-- filas apunta a una mision inexistente (comprobado: 0 de 2.037), asi que lo que falta es el flag:
-- sin el, el NPC no interactua y la mision queda imposible de entregar. Se agrega el flag en vez de
-- borrar la relacion.
--
-- Alcance medido en esta base: 2.037 relaciones sobre 1.095 plantillas (187 de ellas con spawn).
-- UNIT_NPC_FLAG_QUESTGIVER = 0x00000002.
--
-- Migracion nuestra (no viene de la TDB). Idempotente: al re-ejecutarla no queda ninguna fila
-- por actualizar (el WHERE exige que el flag falte).

UPDATE `creature_template` ct
JOIN (
    SELECT DISTINCT `id` FROM `creature_questender`
    UNION
    SELECT DISTINCT `id` FROM `creature_queststarter`
) rel ON rel.`id` = ct.`entry`
SET ct.`npcflag` = ct.`npcflag` | 2
WHERE (ct.`npcflag` & 2) = 0;
