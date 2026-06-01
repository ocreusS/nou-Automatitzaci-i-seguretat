-- Vista simple per al personal de recepció

CREATE OR REPLACE VIEW vista_recepcio AS
SELECT
    f.title AS titol,
    i.inventory_id,
    CASE
        WHEN r.rental_id IS NULL THEN 'Disponible'
        ELSE 'Llogada'
    END AS estat
FROM inventory i
JOIN film f ON f.film_id = i.film_id
LEFT JOIN rental r
    ON r.inventory_id = i.inventory_id
    AND r.return_date IS NULL;

GRANT SELECT ON vista_recepcio TO grup_recepcio;
GRANT SELECT ON vista_recepcio TO grup_gerencia;
