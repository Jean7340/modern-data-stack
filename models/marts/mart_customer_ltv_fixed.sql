-- mart_customer_ltv (fixed)
-- Bug in previous version: total_spent / total_rentals in the raw table are
-- per-rental values (total_spent == film_revenue on every row), so
-- MAX(total_spent) returned the customer's single most expensive rental,
-- not their lifetime value. Aggregate with SUM instead.

SELECT
    customer_id,
    first_name,
    last_name,
    SUM(film_rental_count) AS total_rentals,
    SUM(film_revenue) AS customer_ltv,
    COUNT(DISTINCT film_id) AS films_watched,
    COUNT(DISTINCT category_name) AS categories_watched,
    ROUND(SUM(film_revenue) / NULLIF(SUM(film_rental_count), 0), 2) AS avg_spend_per_rental
FROM {{ ref('stg_customer_film_analytics') }}
GROUP BY
    customer_id,
    first_name,
    last_name
