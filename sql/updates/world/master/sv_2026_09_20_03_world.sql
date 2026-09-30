-- Los `spell_script_names` que atan un guion que el core NO tiene.
--
-- MEDIDO (no heredado): se extrajeron los nombres de guion del arbol del core por las DOS formas de
-- registrarlos — clases `class spell_x : public SpellScript` / `struct spell_x ...` (la forma nueva,
-- donde el nombre es el de la clase) y los literales `"spell_x"` de la forma vieja — y se cruzaron
-- contra `world.spell_script_names`. Resultado: de **2909 nombres / 4091 filas** atadas en la base,
-- solo **4 filas** nombran algo que el core no tiene (el informe viejo decia 58/59: contaba solo los
-- literales y se perdia las clases).
--
-- Por que importa: el core descarta la fila al cargar ("Table spell_script_names references a
-- non-existing script name") — o sea que el hechizo pierde su parte especial SIN que nadie se entere.
--
-- Las 4, una por una:
--   * 96538 `spell_arena_dalaran_sewers_pipe_flush_knockback_search` ->  **se re-apunta**: el guion
--     existe con otro nombre. `scripts/Battlegrounds/DalaranSewers/arena_dalaran_sewers.cpp:259` dice
--     literalmente `// 96538 - Pipe Flush Knockback Search Effect` sobre la clase
--     `spell_arena_dalaran_sewers_pipe_flush_knockback_search_trigger`. El core nombra sus clases con
--     el sufijo `_trigger`, la fila vieja venia sin el.
--   * 296843 `spell_gear_repaired_aura_q55194`, 59665 `spell_warr_vigilance_redirect_threat` y la fila
--     con **spell_id = -85113** (`spell_warl_aftermath`, un id de hechizo NEGATIVO: dato roto de
--     origen) **no tienen guion en el core con ningun nombre parecido**: la fila no hace nada hoy.
--     Se borran (borrar una fila muerta no cambia el juego: el core ya la ignoraba). Lo que NO se
--     recupera con esto es el comportamiento que esas tres filas pedian — eso es autoría, y si algun
--     dia se quiere, el camino es escribir el guion, no devolver la fila.
--
-- Idempotente: el UPDATE y los DELETE se pueden correr dos veces sin efecto.

UPDATE `spell_script_names` SET `ScriptName` = 'spell_arena_dalaran_sewers_pipe_flush_knockback_search_trigger'
 WHERE `spell_id` = 96538 AND `ScriptName` = 'spell_arena_dalaran_sewers_pipe_flush_knockback_search';

DELETE FROM `spell_script_names` WHERE `spell_id` = 296843 AND `ScriptName` = 'spell_gear_repaired_aura_q55194';
DELETE FROM `spell_script_names` WHERE `spell_id` = 59665  AND `ScriptName` = 'spell_warr_vigilance_redirect_threat';
DELETE FROM `spell_script_names` WHERE `spell_id` = -85113 AND `ScriptName` = 'spell_warl_aftermath';

-- Verificacion sugerida (la hace `herramientas/guiones-muertos.py`):
--   SELECT COUNT(*) FROM spell_script_names WHERE script_name NOT IN (...los del core...);  -- debe dar 0
