# Banco de cuenta (oro del banco de tropa)

Estado: implementado, aplicado y probado en el servidor.

**El problema.** El cliente dibuja el "banco de tropa" con el campo `AccountBankCoinage` de
`ActivePlayerData`, y TrinityCore no lo cargaba ni lo guardaba en ninguna parte. Además
`CMSG_ACCOUNT_BANK_DEPOSIT_MONEY` y `CMSG_ACCOUNT_BANK_WITHDRAW_MONEY` estaban declarados como
`STATUS_UNHANDLED` con `Handle_NULL`: el cliente mandaba el pedido y no pasaba nada.

**Qué hace este cambio**

- Atiende los dos pedidos: validación del banquero (`CanUseBank`), del monto, y del oro disponible.
- Persiste el oro del banco en una tabla propia (`character_account_bank`, una fila por personaje):
  se escribe en cada movimiento y se carga al entrar al mundo.
- Medición: el formato del pedido (guid del banquero + `uint64` de cobre) y el de la respuesta (el
  servidor actualiza `Coinage` y `AccountBankCoinage` del jugador en el mismo `SMSG_UPDATE_OBJECT`)
  se validaron contra una respuesta real del cliente del 27-sep-2026; sin la persistencia, el oro
  depositado desaparecía al relogear.

Archivos: `src/server/game/Handlers/BankHandler.cpp`,
`src/server/game/Server/Packets/BankPackets.*`, `src/server/game/Entities/Player/Player.*`.
SQL: `sql/updates/characters/master/sv_2026_09_27_07_characters.sql`.
