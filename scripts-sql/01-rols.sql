-- Creació de rols de grup i usuaris per a Pagila

DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'grup_gerencia') THEN
        CREATE ROLE grup_gerencia NOLOGIN;
    END IF;

    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'grup_recepcio') THEN
        CREATE ROLE grup_recepcio NOLOGIN;
    END IF;

    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'manager_user') THEN
        CREATE ROLE manager_user LOGIN PASSWORD 'Manager123!';
    END IF;

    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'staff_user') THEN
        CREATE ROLE staff_user LOGIN PASSWORD 'Staff123!';
    END IF;
END
$$;

GRANT grup_gerencia TO manager_user;
GRANT grup_recepcio TO staff_user;
