-- ============================================================================
--  mitica_config: la descripcion de `subir_nivel_grupo` dice tambien lo del rotulo
-- ============================================================================
--  La clave hace AHORA tres cosas en una (MythicPlusMgr::EscalarPorNivel): sube el
--  nivel del servidor (SetLevel + UpdateLevelDependantStats), mueve ScalingLevelDelta
--  para que el CLIENTE rotule ese mismo nivel (Creature::SetScaledDisplayLevel) y
--  recien despues aplica la curva de mitica_nivel. La descripcion vieja solo nombraba
--  la primera, que es justo la mitad que no se ve en pantalla.
--
--  Por que el rotulo necesita su propio paso: el cliente no dibuja UNIT_FIELD_LEVEL en
--  una criatura con ContentTuning; calcula el nivel con los campos de escalado, igual
--  que Creature::GetLevelForTarget -> clamp(nivelDelJugador, ScalingLevelMin,
--  ScalingLevelMax) + ScalingLevelDelta. El ContentTuning de una expansion vieja topa
--  en su propio nivel (Atal'Dazar 502 = min/max 50), asi que sin el delta el bicho
--  seguia leyendose 50 aunque el servidor lo tuviera en 90.
--
--  Solo dato (UPDATE idempotente): no hay que recompilar ni reiniciar.
-- ============================================================================

UPDATE `mitica_config`
   SET `descripcion` = 'Subir las criaturas al nivel del grupo antes de escalar por nivel de piedra, y rotular ese nivel en el cliente (delta de escalado) (1 = si, 0 = no)'
 WHERE `clave` = 'subir_nivel_grupo';
