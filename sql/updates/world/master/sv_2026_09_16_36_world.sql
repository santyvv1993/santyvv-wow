-- ============================================================================
--  Camino central: los ids van separados por ESPACIOS (no por comas)
-- ============================================================================
--  Medido en vivo (Santiago, run 4): los 3 jefes muertos y las fuerzas al 100 %, y la
--  escalera del centro seguia cerrada. La causa estaba en este dato:
--
--    `Mgr::ListaDeIds` (MythicPlusMgr.cpp:66) separa por ESPACIOS y exige que cada token
--    parsee ENTERO:
--        for (std::string_view parte : Trinity::Tokenize(texto, ' ', false))
--            auto [fin, error] = std::from_chars(...);
--            if (error == std::errc() && fin == parte.data() + parte.size() && valor) ...
--    Asi que '122963,122965,122967' es UN token, no parsea y la lista queda **vacia**:
--    la regla hacia `if (jefes.empty()) return false;` y no abria nada, sin ningun error.
--
--  Se dejan las dos cosas: aca el valor con espacios (la convencion que ya usa `jefe_final`)
--  y en el codigo un `ListaDeIds` que tambien acepta comas, para que un separador de mas no
--  vuelva a apagar una regla en silencio.
-- ============================================================================

UPDATE `mitica_estancia`
   SET `camino_jefes` = '122963 122965 122967'
 WHERE `cm_id` = 244;
