-- ============================================================================
--  Vuelo dinamico (skyriding) propio - configuracion del sistema
-- ============================================================================
--
--  Por que existe: el core ya trae la mitad del vuelo dinamico (los 13 paquetes
--  SMSG_MOVE_SET_ADV_FLYING_*, el campo FlightCapabilityID y los flags de vuelo),
--  pero NO trae quien lo encienda ni el aura que el CLIENTE exige.
--
--  La pieza que costo encontrar (medida en SpellAuraRestrictions.db2 del cliente):
--  hay 23 filas con CasterAuraSpell = 372773 (Vigor) que gatean 372608 "Impulso de
--  avance", 372610 "Ascenso al cielo", 361584 "Aceleracion giratoria" y el widget de
--  la barra de vigor (423624). Sin esa aura el cliente rechaza el casteo con
--  "todavia no aprendido" ANTES de mandar un paquete: en el log del servidor no se ve
--  nada. Y el core deja el modo ESTABLE puesto en cada login (Player::_LoadAuras hace
--  AddAura(404468)), que es justo lo que exigen las capacidades de montura de vuelo
--  estatico (MountCapability 455/456/457 con ReqSpellAuraID = 404468). Resultado: el
--  servidor vuela "estable" y la capacidad dinamica (494, FlightCapabilityID 11)
--  nunca se elige porque exige saber 376777 "Cielonautica basica" y no estar en ese
--  modo.
--
--  Quien lo implementa: src/server/game/VueloDinamico/ (motor y reglas) y
--  src/server/scripts/Custom/vuelo_dinamico_custom.cpp (habitos del juego y comandos:
--  `.vuelo estado | recargar | ensenar <pj> | modo <pj> [cielonautica|estable]`).
--
--  Nada de esto esta quemado en el codigo: cambiar un hechizo, un nivel, una velocidad
--  o el modo por defecto es un INSERT en estas tablas.
--
--  Idempotente: se puede correr dos veces sin romper nada.
-- ============================================================================

CREATE TABLE IF NOT EXISTS `vuelo_config` (
  `clave` VARCHAR(48)  NOT NULL,
  `valor` VARCHAR(96)  NOT NULL,
  `nota`  VARCHAR(255) NOT NULL,
  PRIMARY KEY (`clave`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Vuelo dinamico: numeros y textos (nada quemado en el codigo)';

-- Que hechizos aprende solo el personaje y desde que nivel (world.vuelo_habilidad)
CREATE TABLE IF NOT EXISTS `vuelo_habilidad` (
  `hechizo`      INT UNSIGNED     NOT NULL,
  `nivel_minimo` TINYINT UNSIGNED NOT NULL DEFAULT 10,
  `nota`         VARCHAR(255)     NOT NULL,
  PRIMARY KEY (`hechizo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Vuelo dinamico: habilidades que el servidor ensena solo';

-- Equitacion exigida para que la montura vuele. VACIA = no se exige nada (servidor de
-- pruebas). Para exigirla, insertar los hechizos de equitacion que traiga el build
-- (buscarlos con `.lookup spell Equitacion`); alcanza con tener UNO.
CREATE TABLE IF NOT EXISTS `vuelo_requisito` (
  `hechizo` INT UNSIGNED NOT NULL,
  `nota`    VARCHAR(255) NOT NULL,
  PRIMARY KEY (`hechizo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Vuelo dinamico: equitacion exigida (vacia = sin requisito)';

-- Como empuja cada habilidad activa: `ascenso` = hacia arriba, `avance` = hacia donde
-- mira el draco (con su inclinacion), `giro` = igual que avance pero mas fuerte.
CREATE TABLE IF NOT EXISTS `vuelo_impulso` (
  `hechizo`   INT UNSIGNED              NOT NULL,
  `tipo`      ENUM('ascenso','avance','giro') NOT NULL,
  `velocidad` FLOAT                     NOT NULL,
  `nota`      VARCHAR(255)              NOT NULL,
  PRIMARY KEY (`hechizo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Vuelo dinamico: empujon de cada habilidad activa';

-- ----------------------------------------------------------------------------
-- los numeros y los textos
-- ----------------------------------------------------------------------------
INSERT INTO `vuelo_config` (`clave`, `valor`, `nota`) VALUES
  ('habilitado',          '1',             '0 apaga todo el sistema sin recompilar'),
  ('modo_por_defecto',    'cielonautica',  'estilo al entrar al mundo: cielonautica o estable'),
  ('nivel_minimo',        '10',             'desde que nivel se ensenan las habilidades'),
  ('aura_vigor',          '372773',         'VIGOR: sin esta aura el cliente no deja castear las habilidades activas'),
  ('aura_cielonautica',   '404464',         'Estilo de vuelo: Cielonautica'),
  ('aura_estable',        '404468',         'Estilo de vuelo: Estable (la que el core fuerza en cada login)'),
  ('cap_vuelo_dinamico',  '1',              'FlightCapabilityID que se le manda al cliente al montar (1 = Ascenso al cielo)')
ON DUPLICATE KEY UPDATE `nota` = VALUES(`nota`);

-- ----------------------------------------------------------------------------
-- las habilidades que el servidor ensena solo
-- ----------------------------------------------------------------------------
INSERT INTO `vuelo_habilidad` (`hechizo`, `nivel_minimo`, `nota`) VALUES
  (376777, 10, 'Cielonautica basica: la exige ReqSpellKnownID de la capacidad de montura dinamica'),
  (372610, 10, 'Ascenso al cielo (habilidad activa)'),
  (374763, 10, 'Levantar vuelo (habilidad activa)'),
  (372608, 10, 'Impulso de avance (habilidad activa)'),
  (361584, 10, 'Aceleracion giratoria (habilidad activa)'),
  (404471, 10, 'Cambiar estilo de vuelo (cielonautica <-> estable)')
ON DUPLICATE KEY UPDATE `nivel_minimo` = VALUES(`nivel_minimo`), `nota` = VALUES(`nota`);

-- ----------------------------------------------------------------------------
-- los impulsos (Ascenso al cielo / Levantar vuelo / Impulso de avance / Aceleracion giratoria)
-- ----------------------------------------------------------------------------
INSERT INTO `vuelo_impulso` (`hechizo`, `tipo`, `velocidad`, `nota`) VALUES
  (372610,  'ascenso', 6.0,  'Ascenso al cielo'),
  (376744,  'ascenso', 6.0,  'Ascenso al cielo (copia de la barra)'),
  (386451,  'ascenso', 6.0,  'Ascenso al cielo (copia de la barra)'),
  (1227916, 'ascenso', 6.0,  'Ascenso al cielo (copia de la barra)'),
  (374763,  'ascenso', 6.0,  'Levantar vuelo'),
  (384752,  'ascenso', 6.0,  'Levantar vuelo (copia de la barra)'),
  (404191,  'ascenso', 6.0,  'Levantar vuelo (copia de la barra)'),
  (1227919, 'ascenso', 6.0,  'Levantar vuelo (copia de la barra)'),
  (372608,  'avance',  14.0, 'Impulso de avance'),
  (376743,  'avance',  14.0, 'Impulso de avance (copia de la barra)'),
  (386449,  'avance',  14.0, 'Impulso de avance (copia de la barra)'),
  (1227914, 'avance',  14.0, 'Impulso de avance (copia de la barra)'),
  (361584,  'giro',    60.0, 'Aceleracion giratoria'),
  (442180,  'giro',    60.0, 'Aceleracion giratoria (copia de la barra)')
ON DUPLICATE KEY UPDATE `tipo` = VALUES(`tipo`), `velocidad` = VALUES(`velocidad`), `nota` = VALUES(`nota`);

-- ----------------------------------------------------------------------------
-- los enganches de C++ (spell_script_names)
-- ----------------------------------------------------------------------------
-- "Cambiar estilo de vuelo" trae varias copias en este build del cliente (la barra la
-- maneja el cliente), asi que el script se registra para todas.
DELETE FROM `spell_script_names` WHERE `ScriptName` IN ('spell_alternar_estilo_vuelo', 'spell_impulso_vuelo');

INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
  (404471,  'spell_alternar_estilo_vuelo'),
  (436854,  'spell_alternar_estilo_vuelo'),
  (459987,  'spell_alternar_estilo_vuelo'),
  (459988,  'spell_alternar_estilo_vuelo'),
  (460002,  'spell_alternar_estilo_vuelo'),
  (372610,  'spell_impulso_vuelo'),
  (376744,  'spell_impulso_vuelo'),
  (386451,  'spell_impulso_vuelo'),
  (1227916, 'spell_impulso_vuelo'),
  (374763,  'spell_impulso_vuelo'),
  (384752,  'spell_impulso_vuelo'),
  (404191,  'spell_impulso_vuelo'),
  (1227919, 'spell_impulso_vuelo'),
  (372608,  'spell_impulso_vuelo'),
  (376743,  'spell_impulso_vuelo'),
  (386449,  'spell_impulso_vuelo'),
  (1227914, 'spell_impulso_vuelo'),
  (361584,  'spell_impulso_vuelo'),
  (442180,  'spell_impulso_vuelo');

-- ----------------------------------------------------------------------------
-- que el Vigor y las dos auras de estilo NO se guarden en el personaje
-- ----------------------------------------------------------------------------
-- El estilo de vuelo se decide al entrar al mundo (Player::_LoadAuras ya mete el modo
-- estable del core), asi que guardarlas solo ensucia character_aura con estados viejos.
-- SPELL_ATTR0_CU_AURA_CANNOT_BE_SAVED = 0x01000000 = 16777216 (SpellInfo.h).
INSERT INTO `spell_custom_attr` (`entry`, `attributes`) VALUES
  (372773, 16777216),
  (404464, 16777216),
  (404468, 16777216)
ON DUPLICATE KEY UPDATE `attributes` = VALUES(`attributes`);
