-- ============================================================================
--  Fuerzas: los jefes intermedios no aportan % (como en retail)
-- ============================================================================
--  MEDIDO, no supuesto. `MythicPlusMgr.cpp` tiene la regla escrita en su propio comentario:
--
--      // El jefe final declarado no aporta fuerzas (en retail los jefes no cuentan para el % de fuerzas).
--      // OJO: NO se puede confiar en IsDungeonBoss() para esto: la TDB no marca como jefe a NINGUNA
--      // criatura de estas mazmorras (flags_extra = 0 en las 3.264 spawneadas de las 8 estancias).
--
--  O sea: la intencion es que NINGUN jefe aporte, pero la implementacion solo cubre al **jefe final**
--  (el que declara `mitica_estancia.jefe_final`) y todo lo demas cae en `fuerzas_normal = 1`.
--  Resultado medido: los **24 jefes intermedios** de la temporada aportaban 1% cada uno — entre 2% y 5%
--  de mas por corrida, y peor: el %, que en retail mide SOLO la chusma, dependia de cuantos jefes tuviera
--  la estancia.
--
--  `mitica_fuerzas` existe justo para esto (su propio comentario: "lo no listado usa la regla por
--  clasificacion"), y el motor la consulta EN CADA MUERTE (`SELECT pct FROM mitica_fuerzas WHERE entry =`),
--  asi que esta migracion **no necesita reinicio**: aplica en vivo.
--
--  Criterio de la lista (no se invento ninguno): las criaturas que el codigo del core ya trata como jefes
--  (`ScriptName = 'boss_*'`) mas las que se midieron y scriptearon como jefe de encuentro en las tandas 1-7.
--  Quedan FUERA a proposito la chusma con guion (`npc_kings_rest_*`: Minion of Zul, Umbral Warrior,
--  Shadow-Borne Champion, Risen Hexer, Animated Guardian): esa SI aporta fuerzas, es chusma.
--  Los jefes finales tampoco van aca: ya los cubre `jefe_final`.
-- ============================================================================

CREATE TABLE IF NOT EXISTS `mitica_fuerzas` (
  `cm_id` int unsigned NOT NULL,
  `entry` int unsigned NOT NULL,
  `pct`   decimal(5,2) NOT NULL COMMENT '% de fuerzas que aporta al morir',
  PRIMARY KEY (`cm_id`, `entry`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Fuerzas enemigas por criatura (lo no listado usa la regla por clasificacion)';

DELETE FROM `mitica_fuerzas` WHERE `entry` IN (
  91784, 91789, 91797, 91808,              -- Ojo de Azshara (cm 197)
  134993, 135322, 135470, 135472, 135475,  -- Reposo de los Reyes (cm 249)
  122963, 122965, 122967,                  -- Atal'Dazar (cm 244)
  188252, 189232,                          -- Estanques de Vida Rubi (cm 399)
  207939, 207946,                          -- Priorato (cm 499)
  208745, 210153, 208743,                  -- Grieta Llama Oscura (cm 504)
  215405,                                  -- Ara-Kara (cm 503)
  216320, 216619, 216648, 216649           -- Ciudad de los Hilos (cm 502)
);

INSERT INTO `mitica_fuerzas` (`cm_id`, `entry`, `pct`) VALUES
  -- Ojo de Azshara
  (197, 91784, 0.00), (197, 91789, 0.00), (197, 91797, 0.00), (197, 91808, 0.00),
  -- Reposo de los Reyes
  (249, 134993, 0.00), (249, 135322, 0.00), (249, 135470, 0.00), (249, 135472, 0.00), (249, 135475, 0.00),
  -- Atal'Dazar
  (244, 122963, 0.00), (244, 122965, 0.00), (244, 122967, 0.00),
  -- Estanques de Vida Rubi
  (399, 188252, 0.00), (399, 189232, 0.00),
  -- Priorato de la Llama Sagrada
  (499, 207939, 0.00), (499, 207946, 0.00),
  -- Grieta Llama Oscura (Blazikon 208743 entra igual: hoy no tiene spawn, y cuando lo tenga ya queda bien)
  (504, 208745, 0.00), (504, 210153, 0.00), (504, 208743, 0.00),
  -- Ara-Kara
  (503, 215405, 0.00),
  -- Ciudad de los Hilos
  (502, 216320, 0.00), (502, 216619, 0.00), (502, 216648, 0.00), (502, 216649, 0.00);
