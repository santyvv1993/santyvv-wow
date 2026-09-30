# santyvv-wow

Nuestra versión del core de TrinityCore (`master`, cliente 12.1.x) publicada como **parches + SQL**:
este repo no copia el árbol de TrinityCore, solo contiene **lo que escribimos nosotros**.

Es una versión de **aprendizaje y pruebas**. Todo lo que entra acá está implementado, aplicado y
probado (con su medición); lo que está en revisión o sin probar no se publica.

Base: `TrinityCore/master` en `34cd48e6f9` (29-sep-2026).

## Cómo se arma

```bash
git clone https://github.com/TrinityCore/TrinityCore.git
cd TrinityCore && git checkout 34cd48e6f9
CORE=$PWD herramientas/aplicar.sh   # aplica parches/ en orden y copia sql/updates/
```

Después se compila como siempre (`cmake` + `make`, o `Build.bat` en Windows) y las migraciones
`sql/updates/**` las aplica el updater del core en el arranque.

## Qué contiene

| Carpeta | Qué es |
|---|---|
| `parches/` | el código propio, en parches aplicables uno por uno sobre upstream |
| `sql/updates/` | nuestras migraciones (esquema propio + correcciones de datos) |
| `sql/datos/` | manifiesto de los volcados de datos pesados (viven en Releases, con su sha256) |
| `herramientas/` | aplicar, auditar y regenerar este repo |
| `docs/` | descripción de cada sistema y de cada corrección |

## Sistemas propios

- **Míticas+**: piedras de llave, puntaje por carrera, red de teletransporte para la run.
- **Vuelo dinámico** (skyriding): vuelo controlado por el jugador, con el requisito de Vigor que
  exige el cliente y el modo de vuelo re-aplicado en cada login.
- **Warband**: grupos de escuadra de la banda de guerra y el sistema de mentoría.
- **Barrios**: esquema y contenido dinámico del sistema de barrios.

Ninguno de estos es candidato a upstream: son diseño nuestro, no replicación de retail.

## Correcciones que replican retail

Candidatas a reportarse en TrinityCore (todas con medición antes/después):

- Rotación de logs rota en Windows cuando `LogsDir` es absoluto (el log anterior se trunca en vez de
  respaldarse).
- Banco de cuenta: `CMSG_ACCOUNT_BANK_DEPOSIT_MONEY` / `WITHDRAW_MONEY` estaban sin atender, y
  `AccountBankCoinage` no se guardaba en ninguna parte (oro que desaparecía al relogear).
- Formato de `SMSG_QUEST_ITEM_USABILITY_RESPONSE` reversado contra el volcado del cliente.
- Correcciones de datos de la TDB: filas huérfanas, spawns de jefes sin spawn, botín inservible,
  relaciones de misión y dadores faltantes.

## Lo que este repo no publica

Nada interno: ni capturas, ni la base de personajes, ni configuraciones reales, ni credenciales, ni
rutas de nuestra máquina. Está listado en [`AUDITORIA.md`](AUDITORIA.md) y se comprueba con
`herramientas/verificar-publicacion.sh` antes de cada subida.

## Licencia

GPL-2.0, la misma del proyecto del que deriva (ver `LICENSE`). TrinityCore es de sus autores; este
repo solo aporta lo propio.
