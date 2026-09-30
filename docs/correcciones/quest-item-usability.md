# `SMSG_QUEST_ITEM_USABILITY_RESPONSE`

Estado: formato reversado y verificado; implementado en el core.

**El problema.** El cliente pregunta si cada objeto de la ventana de misión sirve para la misión que
está ofreciendo (`CMSG_QUERY_QUEST_ITEM_USABILITY`). En una sesión de 5 h 40 m el cliente lo pidió
**32.677 veces** y el core no contestaba nunca (`Handle_NULL`): la ventana no podía marcar los
objetos útiles. Del lado de las herramientas, el paquete tampoco se sabe leer (se imprime como
volcado hexadecimal).

**Qué se hizo**

- Reverso del formato de la respuesta y verificación del consumo exacto de bytes contra 74 respuestas
  reales del cliente: la lectura cierra con cero bytes sobrantes en las 74.
- Handler en el core que responde por los objetos consultados, con la marca de apto/no apto.

Archivos: `src/server/game/Handlers/QuestHandler.cpp`,
`src/server/game/Server/Packets/QuestPackets.*` (`CMSG_QUERY_QUEST_ITEM_USABILITY` y
`SMSG_QUEST_ITEM_USABILITY_RESPONSE`, ambos hoy `STATUS_UNHANDLED` en upstream).
