-- Trigger per controlar que un client no pugui llogar si té problemes pendents

CREATE TABLE IF NOT EXISTS deutes_client (
    customer_id INTEGER PRIMARY KEY REFERENCES customer(customer_id),
    import NUMERIC(6,2) NOT NULL DEFAULT 0,
    pagat BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE OR REPLACE FUNCTION comprova_client_abans_lloguer()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM deutes_client
        WHERE customer_id = NEW.customer_id
          AND pagat = FALSE
          AND import > 0
    ) THEN
        RAISE EXCEPTION 'El client % té deutes pendents i no pot fer un nou lloguer', NEW.customer_id;
    END IF;

    IF EXISTS (
        SELECT 1
        FROM rental
        WHERE customer_id = NEW.customer_id
          AND return_date IS NULL
          AND rental_date < NOW() - INTERVAL '30 days'
    ) THEN
        RAISE EXCEPTION 'El client % té un lloguer antic sense retornar', NEW.customer_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_comprova_client_abans_lloguer ON rental;

CREATE TRIGGER trg_comprova_client_abans_lloguer
BEFORE INSERT ON rental
FOR EACH ROW
EXECUTE FUNCTION comprova_client_abans_lloguer();

GRANT SELECT, INSERT, UPDATE, DELETE ON deutes_client TO grup_gerencia;
GRANT SELECT ON deutes_client TO grup_recepcio;
