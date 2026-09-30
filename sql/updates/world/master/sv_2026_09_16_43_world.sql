-- ============================================================================
--  Fase 3 (parte 1): los afijos que son un multiplicador, con efecto real
-- ============================================================================
--  Que habia: `mitica_afijo` ya tenia los 50 afijos del cliente y el motor ya elegia QUE afijos entran
--  en cada nivel (`mitica_afijo_nivel`), pero **ninguno hacia nada**: la columna `implementacion` decia
--  `estatico` y `parametros` estaba vacia, asi que la corrida se jugaba con los afijos anunciados en el
--  HUD y sin ningun efecto.
--
--  Que hace esta migracion: le da numeros a los dos afijos de escalado y deja el resto dicho como lo que
--  es (`sin_implementar`), para que el log del arranque diga la verdad:
--     "afijos cargados: 50 declarados, N activos con efecto".
--
--  Convencion de `parametros` (la lee MythicPlusMgr al escalar la instancia):
--     objetivo=jefes|basura;vida=N;dano=N     (N = porcentaje; se multiplica SOBRE la curva de nivel)
--  Un afijo sin `parametros` NO se aplica: el motor no adivina.
--
--  OJO con los numeros: son NUESTROS (aproximacion al espiritu de retail), no un valor oficial. Viven en
--  la base justamente para ajustarlos sin recompilar, igual que `mitica_nivel`.
-- ============================================================================

-- Tiránico: los JEFES aguantan mas y pegan mas.
UPDATE `mitica_afijo`
   SET `implementacion` = 'estatico',
       `parametros` = 'objetivo=jefes;vida=40;dano=15',
       `activo` = 1
 WHERE `afijo_id` = 9;

-- Reforzado (Fortified): la CHUSMA aguanta mas y pega mas; el jefe queda como esta.
UPDATE `mitica_afijo`
   SET `implementacion` = 'estatico',
       `parametros` = 'objetivo=basura;vida=20;dano=30',
       `activo` = 1
 WHERE `afijo_id` = 10;

-- Los otros dos que la temporada anuncia (Pacto de Xal'atath: Ascendiente y Guia de Lindormi) siguen
-- activos -- el cliente los muestra -- pero su efecto NO esta implementado y ahora lo dice la tabla.
UPDATE `mitica_afijo`
   SET `implementacion` = 'sin_implementar',
       `parametros` = ''
 WHERE `afijo_id` IN (148, 165) AND `implementacion` = 'estatico';
