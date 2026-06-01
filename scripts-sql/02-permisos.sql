-- Permisos bàsics per als rols de grup

REVOKE ALL ON SCHEMA public FROM PUBLIC;

GRANT CONNECT ON DATABASE pagila TO grup_gerencia, grup_recepcio;
GRANT USAGE ON SCHEMA public TO grup_gerencia, grup_recepcio;

-- Gerència pot consultar i modificar taules importants
GRANT SELECT, INSERT, UPDATE, DELETE ON film TO grup_gerencia;
GRANT SELECT, INSERT, UPDATE, DELETE ON inventory TO grup_gerencia;
GRANT SELECT, INSERT, UPDATE, DELETE ON rental TO grup_gerencia;
GRANT SELECT, INSERT, UPDATE, DELETE ON customer TO grup_gerencia;

-- Recepció només té els permisos necessaris per consultar i gestionar lloguers
GRANT SELECT ON film TO grup_recepcio;
GRANT SELECT ON inventory TO grup_recepcio;
GRANT SELECT ON rental TO grup_recepcio;
GRANT SELECT ON customer TO grup_recepcio;

GRANT INSERT ON rental TO grup_recepcio;
GRANT UPDATE(return_date) ON rental TO grup_recepcio;

GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO grup_gerencia;
GRANT USAGE, SELECT ON SEQUENCE rental_rental_id_seq TO grup_recepcio;
