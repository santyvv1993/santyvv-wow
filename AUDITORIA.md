# Auditoría de publicación

Regla: **acá entra solo lo nuestro y solo lo cerrado**. Antes de cada subida corre la puerta:

```bash
herramientas/verificar-publicacion.sh
```

Si la puerta falla, no se sube: primero se limpia.

## Qué se publica

1. **Código propio** (`parches/`): los sistemas y las correcciones que escribimos en el fork privado.
2. **SQL propio** (`sql/updates/`): esquema de nuestras tablas y correcciones de datos, con la
   medición en el encabezado de cada archivo.
3. **Datos pesados** (`sql/datos/`): solo el manifiesto con nombre, tamaño y `sha256`; los volcados
   van como adjuntos de un Release del propio repo (misma visibilidad, pero el clon no arrastra
   cientos de MB).
4. **Documentación** (`docs/`): qué hace cada sistema y cada corrección, en lenguaje llano.

## Qué NUNCA se publica

| Categoría | Ejemplos | Por qué |
|---|---|---|
| Credenciales | contraseñas de MySQL, tokens, claves de API, `worldserver.conf` real | seguridad nuestra |
| Datos personales | correos, IDs de Discord, rutas `C:\Users\...`, IPs, dominios internos | identidad |
| Base de personajes | volcados de `characters` / `account`, nombres de jugadores | datos de terceros |
| Capturas del cliente | `.pkt`, `.pcap`, volcados crudos de sniff | método y cuenta |
| Ficheros del cliente | `.db2`, `.dbc`, `.mpq`, texturas/modelos, extracciones CASC | material de Blizzard |

## Cómo audita la puerta

- **Rutas**: rechaza extensiones prohibidas (arriba) y cualquier `.conf` real.
- **Tamaño**: rechaza archivos de más de 10 MB (van a Releases).
- **Contenido**: busca credenciales, tokens, correos, rutas windows/`C:/Users`, IP privada,
  identificadores de Discord, rutas internas de nuestra máquina y `INSERT` sobre tablas de cuentas o
  personajes. Muestra la línea exacta para poder limpiarla.
- **Origen**: cada parche se verifica con `git apply --check` contra el commit base, para que no se
  publique algo que no aplica.

## Regla de admisión

- Entra lo que está **implementado, aplicado y probado** (con su medición antes/después).
- Lo que está pendiente, a medio hacer o esperando prueba en vivo **no entra**, aunque el código
  esté escrito.
- Los sistemas propios se marcan como tales: no se presentan como si fueran de retail.
