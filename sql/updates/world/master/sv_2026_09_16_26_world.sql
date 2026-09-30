-- =====================================================================
-- 2026_09_16_26_world.sql
-- Red de seguridad del recorrido: los numeros y el texto del vigilante.
-- =====================================================================
-- Con esto la red de seguridad NO tiene nada quemado: los tres numeros (cuando se considera
-- que el lider "no se mueve", que tan cerca de la reja tiene que estar, y que tan cerca del
-- camino tiene que caer un objeto para contarlo como traba) y el aviso se cambian con SQL.
--
-- Lo usa:
--   `Mgr::VigilarRecorrido`        -> recorrido_vigilar, recorrido_quieto_seg, recorrido_radio_yd
--   `Mgr::DiagnosticoRecorrido`    -> traba_radio_yd
--   comando `.mitica traba`/`.mitica destrabar` (el aviso, al abrir una reja trabada)
-- =====================================================================

INSERT INTO `mitica_config` (`clave`, `valor`, `descripcion`) VALUES
    ('recorrido_vigilar',    '1',  'red de seguridad del recorrido: si el lider se queda parado al lado de una reja cerrada, abrirla (1 = si)'),
    ('recorrido_quieto_seg', '20', 'segundos que el lider tiene que estar sin moverse para que el vigilante mire si hay una reja trabada al lado'),
    ('recorrido_radio_yd',   '10', 'distancia (yardas) a la que el vigilante considera que la reja cerrada es "la que te esta trabando"'),
    ('traba_radio_yd',       '6',  'distancia (yardas) a la que un objeto cerrado cuenta como que cae SOBRE el camino en el diagnostico'),
    ('aviso_destrabado',     'El paso estaba trabado: se abrio solo para que la corrida siga', 'aviso al grupo cuando el vigilante abre una reja')
ON DUPLICATE KEY UPDATE `valor` = `valor`;   -- si ya existe, se deja lo que hay (no pisa ajustes)

-- Verificación:
--   SELECT clave, valor FROM mitica_config WHERE clave LIKE 'recorrido%' OR clave IN ('traba_radio_yd','aviso_destrabado');

-- Reversión: borrar las 5 filas (el codigo vuelve a sus valores por defecto)
--   DELETE FROM mitica_config WHERE clave IN ('recorrido_vigilar','recorrido_quieto_seg','recorrido_radio_yd','traba_radio_yd','aviso_destrabado');
