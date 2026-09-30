# Míticas+

Sistema propio de calabozos míticos para el servidor personal. No es candidato a upstream.

- Piedra de llave con nivel; la run se arma con `mitica_config` (niveles, límites, recompensas).
- Puntaje por carrera: `base + nivel*12 + bono_medalla - muertes*3`.
- Red de camino/teletransporte propia para el recorrido de la run, de modo que un mecanismo
  trabado (puerta, palanca, muro destructible) no pueda dejar la corrida sin salida.
- Seguimiento del progreso del grupo y de las muertes del grupo completo.

Archivos: `src/server/game/MythicPlus/`, `src/server/scripts/Custom/miticas_custom.cpp`,
`src/server/game/Handlers/ChallengeModeHandler.cpp`.
Tablas: `mitica_config`, `mitica_*` (ver `sql/updates/`).
