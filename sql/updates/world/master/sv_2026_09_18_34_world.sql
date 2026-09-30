-- SV migracion sv_2026_09_18_34_world.sql
-- Vendedores: lo que la fuente vende y en casa falta (fuente: ref_lw). Idempotente.
-- OJO: migracion de UNA SOLA PASADA. Sus INSERT no llevan DELETE previo, asi que re-aplicarla
-- falla con Duplicate entry (lo detecto la 2a pasada del validador, despues de aplicarla). El estado
-- ya quedo aplicado; si hiciera falta re-ejecutarla, borrar primero por (entry, item, ExtendedCost, type).

--
-- filas: 0 | items inexistentes en el cliente: 255 | ranuras repetidas: 0 | ya vendidos: 118224
-- plantillas con la bandera de vendedor puesta: 0

