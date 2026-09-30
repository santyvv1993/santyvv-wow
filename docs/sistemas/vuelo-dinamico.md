# Vuelo dinámico (skyriding)

Sistema propio: vuelo controlado por el jugador, en vez del vuelo "fijo" del core. No es candidato
a upstream.

- El cliente exige el aura de **Vigor** para lanzar las habilidades activas de vuelo: el core la
  aplica y mantiene el modo de vuelo en cada login.
- Los impulsos de movimiento se aplican desde el core (`Player::AddMoveImpulse`) y se replican a los
  clientes cercanos.
- Modo estable forzado al entrar al mundo, para que un relog no deje al jugador en un estado mixto.

Archivos: `src/server/game/VueloDinamico/`, `src/server/scripts/Custom/vuelo_dinamico_custom.cpp`,
`src/server/game/Server/Packets/MovementPackets.*`.
Tablas: `world.vuelo_*`.
