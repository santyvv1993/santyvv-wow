-- Warband: grupos de escuadra (los campamentos del char-select) y sus miembros.
--
-- Migracion nuestra (mod "warband"), no viene con la TDB ni con upstream.
-- Va en la base `auth` porque es data de CUENTA (battle.net), igual que
-- battlenet_account_warband_scenes (escenas) y battlenet_account_mounts (colecciones).
--
-- La forma la dicta el paquete CMSG_SETUP_WARBAND_GROUPS, no el gusto nuestro:
--   grupo  = { groupId, orderIndex, warbandSceneId, flags, contentSetId, name }
--   miembro= { guid, warbandScenePlacementId, type, contentSetId }
-- Ver mods/warband/REVISION-PLAN-WARBAND.md (referencias: PR #31378 y #31883).
--
-- Idempotente a proposito (IF NOT EXISTS): el Updater puede re-aplicarla sin dano.
-- OJO: existe una tabla provisional con el mismo nombre que se creo a mano con las
-- columnas (battlenetAccountId, position, guid, warbandSceneId, isFavourite). Esa forma
-- no es la del paquete y hay que retirarla ANTES de aplicar esto (una sola vez):
--   DROP TABLE IF EXISTS `battlenet_account_warband_groups`;

CREATE TABLE IF NOT EXISTS `battlenet_account_warband_groups` (
  `battlenetAccountId` int unsigned     NOT NULL                      COMMENT 'Cuenta battle.net (auth.battlenet_accounts.id)',
  `groupId`            bigint unsigned  NOT NULL                      COMMENT 'Id del grupo que manda el cliente (lo elige el cliente, se respeta)',
  `orderIndex`         tinyint unsigned NOT NULL DEFAULT 0            COMMENT 'Orden del grupo en la UI',
  `warbandSceneId`     int unsigned     NOT NULL DEFAULT 0            COMMENT 'Campamento/fondo elegido para el grupo',
  `flags`              int unsigned     NOT NULL DEFAULT 0            COMMENT 'enum WarbandGroupFlags { Collapsed = 1 }',
  `contentSetId`       int              NOT NULL DEFAULT 0,
  `name`               varchar(255)     NOT NULL DEFAULT ''           COMMENT 'Nombre visible del campamento',
  PRIMARY KEY (`battlenetAccountId`,`groupId`),
  CONSTRAINT `fk_battlenet_account_warband_groups__accountId`
    FOREIGN KEY (`battlenetAccountId`) REFERENCES `battlenet_accounts` (`id`)
    ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Grupos/campamentos del warband por cuenta battle.net';

CREATE TABLE IF NOT EXISTS `battlenet_account_warband_group_members` (
  `battlenetAccountId`      int unsigned    NOT NULL                   COMMENT 'Cuenta battle.net',
  `groupId`                 bigint unsigned NOT NULL                   COMMENT 'Grupo al que pertenece el personaje',
  `characterGuid`           bigint unsigned NOT NULL                   COMMENT 'Personaje (characters.characters.guid)',
  `warbandScenePlacementId` int unsigned    NOT NULL DEFAULT 0         COMMENT 'Ranura donde se para el personaje dentro del campamento',
  `type`                    int             NOT NULL DEFAULT 0         COMMENT '0 = personaje (con guid); otro valor = hueco/figura del cliente',
  `contentSetId`            int             NOT NULL DEFAULT 0,
  PRIMARY KEY (`battlenetAccountId`,`groupId`,`characterGuid`),
  KEY `idx_group` (`battlenetAccountId`,`groupId`),
  CONSTRAINT `fk_battlenet_account_warband_group_members__accountId`
    FOREIGN KEY (`battlenetAccountId`) REFERENCES `battlenet_accounts` (`id`)
    ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Personajes asignados a cada campamento del warband';
