# Warband (banda de guerra)

Sistema propio de soporte del "warband" del cliente, más una capa de mentoría. No es candidato a
upstream como sistema; el arreglo de los paquetes de grupo de escuadra sí replica el comportamiento
del cliente.

- Grupos de escuadra de la banda de guerra: `WarbandGroupMgr` guarda y sirve la composición de cada
  grupo, que el cliente pide al abrir la pantalla.
- Mentoría: un jugador veterano acompaña a uno nuevo y ambos reciben el efecto correspondiente
  (`src/server/scripts/Custom/mentoria_warband_custom.cpp`).

Archivos: `src/server/game/Entities/Account/WarbandGroupMgr.*`,
`src/server/scripts/Custom/mentoria_warband_custom.cpp`,
`src/server/game/Server/Packets/CharacterPackets.*`.
