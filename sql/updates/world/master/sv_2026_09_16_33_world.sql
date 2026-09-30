-- ============================================================================
--  Atal'Dazar: el trash Dazar'ai deja de estar enraizado (SESSILE) - solo dato
-- ============================================================================
--  Medido en vivo el 16-sep (Santiago, corriendo la +2): dos criaturas con agro
--  y quietas (Dazar'ai Honor Guard 127799 y Dazar'ai Juggernaut 122971) mientras
--  un esqueleto de la MISMA posicion (Reanimated Honor Guard 127757) le llego a
--  pegar. El log de movimiento (canal `movement.motionmaster` + `maps.mmaps`)
--  mostro el discrimen exacto:
--
--     127799 / 122971 -> recibieron la orden MoveChase y pidieron camino CERO veces
--     127757          -> 206 pedidos de camino, todos tipo NORMAL
--
--  Por que: el bit 0x100 de `creature_template_difficulty.StaticFlags1` es
--  CREATURE_STATIC_FLAG_SESSILE ("creature is permanently rooted in place",
--  CreatureData.h:47). Al spawnear, Creature::UpdateSessileMovementFlags()
--  (Creature.cpp:2998) hace SetControlled(true, UNIT_STATE_ROOT) + quita la
--  gravedad, y la persecucion muere en la PRIMERA linea de
--  ChaseMovementGenerator::DoUpdate (linea 104: HasUnitState(UNIT_STATE_NOT_MOVE)),
--  que es muda: el bicho ve al jugador, entra en combate y nunca se mueve.
--  La unica diferencia de datos entre el esqueleto que camina y estos es ese bit:
--     127757 StaticFlags1 = 268435456 (0x10000000 CAN_SWIM)      -> sin sessile
--     127799 StaticFlags1 = 268435712 (0x10000000 | 0x100 sessile)-> enraizado
--
--  Decision (Santiago, 16-sep): el trash que debe perseguir suelta el bit; lo que
--  es adorno lo conserva (Reanimation Totem 127315, Tiki Mask 129985, Shadowflame
--  131289: tienen sessile + floating y ahi es correcto).
--
--  Alcance: 6 entradas, 58 spawns, todas en el mapa 1763 (Atal'Dazar). Ninguna de
--  estas entradas se usa en otro mapa.
--
--  Como se ve: la tabla de dificultad se lee UNA vez al arrancar el world
--  (`.reload creature_template` no la toca), asi que hace falta reinicio, y el
--  efecto aparece en las criaturas que spawnean despues (instancia nueva).
--
--  Idempotente: `& ~256` deja el bit en 0 y volver a correrlo no cambia nada.
--  Respaldo del antes: herramientas/diagnostico/respaldos/2026-09-16-sessile-ataldazar-antes.sql
-- ============================================================================

UPDATE `creature_template_difficulty`
   SET `StaticFlags1` = `StaticFlags1` & ~0x100
 WHERE `Entry` IN (
        122971,  -- Dazar'ai Juggernaut
        122972,  -- Dazar'ai Augur   (sessile solo en dificultad 23; en normal/heroico no)
        122973,  -- Dazar'ai Confessor (sessile solo en dificultad 23)
        122984,  -- Dazar'ai Colossus
        127799,  -- Dazar'ai Honor Guard
        127352   -- Risen Honor Guard
 );
