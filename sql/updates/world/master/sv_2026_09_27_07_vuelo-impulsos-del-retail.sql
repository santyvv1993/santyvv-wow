-- Vuelo dinamico: los impulsos como los manda el oficial (medido el 27-sep-2026)
--
-- Fuente: dump_12.1.0.69875_2026-09-21_17-06-40 (sesion de vuelo del 21-sep, retail), 437 paquetes
-- SMSG_MOVE_ADD_IMPULSE decodificados uno por uno. Detalle y metodo en
-- docs/sistemas/vuelo/VUELO-DINAMICO-IMPULSOS-DEL-RETAIL.md y herramientas/vuelo-impulsos.py.
--
-- Lo medido por habilidad:
--   Ascenso al cielo = 45 hacia arriba (fase 1) y, 0.71 s despues, un tren de 5-6 empujes de 5.0
--     cada ~102 ms hacia donde vuela el draco (fase 2, dura ~0.43 s). Las 55 rafagas de la sesion
--     cuelgan todas de un 45.
--   Impulso de avance = 18   (veniamos mandando 35)
--   Aceleracion giratoria = 60 (= 31.9, -49.0, -13.4)   (veniamos mandando 35)
--
-- Los tres valores ya estaban en la tabla desde la calibracion a mano del 16-sep sin fuente; esta
-- migracion los deja con la medida del oficial y agrega el tren (fase 2), que no existia.

-- 1) las tres familias de impulsos, con lo medido
UPDATE vuelo_impulso SET velocidad = 45.0,
    nota = 'Ascenso al cielo: empujon vertical (retail 45)'
    WHERE tipo = 'ascenso';

UPDATE vuelo_impulso SET velocidad = 18.0,
    nota = 'Impulso de avance: horizontal (retail 18)'
    WHERE tipo = 'avance';

UPDATE vuelo_impulso SET velocidad = 60.0,
    nota = 'Aceleracion giratoria: mas fuerte que el avance (retail 60)'
    WHERE tipo = 'giro';

-- 2) el tren del ascenso (fase 2) y el recorte del techo aero del modo.
--    0 empujes = sin tren (para volver al comportamiento viejo sin recompilar).
INSERT INTO vuelo_config (clave, valor, nota) VALUES
  ('tren_ascenso_empujes', '6',
   'Fase 2 del ascenso: cuantos empujes suaves manda despues del 45 (retail: 5-6). 0 = sin tren'),
  ('tren_ascenso_retraso_ms', '700',
   'Fase 2: cuanto espera desde el 45 hasta el primer empuje (retail: 0.61-0.89 s)'),
  ('tren_ascenso_intervalo_ms', '100',
   'Fase 2: cada cuanto va un empuje del tren (retail: 102 ms)'),
  ('tren_ascenso_velocidad', '5.0',
   'Fase 2: fuerza de cada empuje del tren (retail: 5.0)'),
  ('factor_velocidad_max', '0.85',
   'Recorte de MaxVel con el modo dinamico: 65 x 0.85 = 55.25 (retail lo manda 60 veces por sesion)'),
  ('factor_impulso_max', '0.85',
   'Recorte de AddImpulseMaxSpeed con el modo dinamico: 100 x 0.85 = 85 (retail)')
ON DUPLICATE KEY UPDATE valor = VALUES(valor), nota = VALUES(nota);
