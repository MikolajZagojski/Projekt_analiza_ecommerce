--- Zapytanie 1: Jaka jest średnia wartość zamówienia dla klientów w wieku 30-40 lat, z podziałem na państwa?
/* Najwyższa średnia dla klientów w wieku 30-40 lat występuje w Kolumbii, ale przez małą liczbę zamówień (tylko 5) ten wynik nie jest miarodajny.
Wśród krajów z dużą liczbą transakcji (powyżej 100) liderem jest Japonia, gdzie średnia wartość zamówienia wynosi 61,63 USD.*/

SELECT 
    u.country AS kraje,
    COUNT(*) AS ilosc_zamowien, 
    ROUND(AVG(oi.sale_price)::numeric,2) AS srednia_wartosc_koszyka -- ROUND przyjmuje numeric a AVG zwaca float
FROM users AS u 
JOIN order_items AS oi ON u.id = oi.user_id
WHERE (u.age BETWEEN  30 AND 40)  
GROUP BY u.country
ORDER BY srednia_wartosc_koszyka DESC;



--- Zapytanie 2: Które produkty są najczęściej zwracane przez klientów, z podziałem na kategorie produktów?

/* Produkty z kategorii  "Intimates" są najczęściej zwracane, 1246 razy. */
SELECT 
    p.category AS kategorie,
    COUNT(*) AS ilosc_zwrotow 
FROM order_items AS oi 
JOIN products AS p ON oi.product_id = p.id
WHERE oi.returned_at IS NOT NULL 
GROUP BY p.category
ORDER BY ilosc_zwrotow DESC;

--- Zapytanie 3: Ile procent zamówień zawiera produkty z kategorii "Intimates" w porównaniu do innych kategorii?
/* Produkty z kategori "Intimates" stanowią 10.00% wszystkich zamówień. */

SELECT 
    p.category AS Kategorie,
    COUNT(DISTINCT o.order_id) AS Liczba_zamowien,
    ROUND(
        COUNT(DISTINCT o.order_id) * 100.0 / (SELECT COUNT(DISTINCT order_id) FROM orders), 
        2
    ) AS Procent_zamowien
FROM orders AS o
JOIN order_items AS oi ON o.order_id = oi.order_id
JOIN products AS p ON oi.product_id = p.id
GROUP BY p.category
ORDER BY Procent_zamowien DESC;



--- Zapytanie 4: Ile zamówień zostało złożonych przez klientów, którzy dokonali co najmniej 4 zamówień w ciągu ostatniego roku?
/* Zamówień złożonych przez klientów, którzy dokonali co najmniej 4 zamówień w
 ciągu ostatniego roku: 4072 */
SELECT 
    SUM(liczba_zamowien_klienta) AS laczna_liczba_zamowien
FROM (
    SELECT 
        user_id, 
        COUNT(order_id) AS liczba_zamowien_klienta
    FROM orders
    WHERE created_at >= CURRENT_DATE - INTERVAL '1 year'
    GROUP BY user_id
    HAVING COUNT(order_id) >= 4
) AS lojalni_klienci;

--- Zapytanie 5: Które kategorie produktów są najczęściej zamawiane przez klientów powyżej 50 roku życia, z podziałem na płeć?
/*Najczęściej zamawiają produkty z kategori prywatnej z działu dla kobiet (4575),
    a najrzadziej z zestawów ubrań (72) z działu dla kobiet.*/
SELECT 
    p.category AS Kategorie,
    COUNT(CASE WHEN u.gender = 'F' THEN 1 END) AS Kobiety,
    COUNT(CASE WHEN u.gender = 'M' THEN 1 END) AS Mezczyzni,
    COUNT(*) AS Razem
FROM users AS u
JOIN orders AS o ON u.id = o.user_id
JOIN order_items AS oi ON o.order_id = oi.order_id 
JOIN products AS p ON oi.product_id = p.id
WHERE u.age > 50
GROUP BY p.category
ORDER BY COUNT(*) DESC;

--- Zapytanie 6: Z jakiego niemieckiego miasta pochodzą klienci, którzy złożyli zamówienia o wartości powyżej 100 USD?
/* Najwięcej zamówień o wartości powyżej 100 USD złożono z miasta Berlin
 (78), a następnie z Hamburga (58). */
SELECT 
    u.city AS Miasta,
    COUNT(*) AS Ilosc_zamowien
FROM users AS u
JOIN orders AS o ON u.id = o.user_id
JOIN (
    SELECT 
        order_id,
        SUM(sale_price) AS total_value
    FROM order_items
    GROUP BY order_id
) AS oi_sum ON o.order_id = oi_sum.order_id
WHERE u.country = 'Germany'
AND oi_sum.total_value > 100
GROUP BY u.city
ORDER BY Ilosc_zamowien DESC;

--- Zapytanie 7: Jaka jest średnia wartość zamówień przez klientów w wieku poniżej 25 lat, z podziałem na płeć?
/* Średnia wartość zamówień przez klientów w wieku poniżej 25 lat wynosi 
80,16 USD dla kobiet i 90,73 USD dla mężczyzn. */
SELECT
    CASE
        WHEN u.gender = 'M' THEN 'Mezczyzni'
        WHEN u.gender = 'F' THEN 'Kobiety'
        ELSE 'Inna plec'
    END AS Plec,
    ROUND(AVG(oi.total_value)::numeric, 2) AS Srednia_wartosc_zamowienia
FROM users AS u
JOIN orders AS o ON u.id = o.user_id
JOIN (
    SELECT
        order_id,
        SUM(sale_price) AS total_value
    FROM order_items
    GROUP BY order_id
) AS oi ON o.order_id = oi.order_id
WHERE u.age < 25
GROUP BY u.gender
ORDER BY Plec;


--- Zapytanie 8: Które dni tygodnia są najbardziej popularne do składania zamówień przez klientów z USA?
/* Najwięcej zamówień przez klientów z USA składanych jest
 w środę (4154), a następnie w czwartek (4142). */
SELECT 
    TO_CHAR(o.created_at, 'Day') AS Dzien_tygodnia,
    COUNT(*) AS Ilosc_zamowien
FROM orders AS o
JOIN users AS u ON o.user_id = u.id
WHERE u.country = 'United States'
GROUP BY Dzien_tygodnia
ORDER BY Ilosc_zamowien DESC;

--- Zapytanie 9: Jaka jest łączna wartość zamówień dla klientów z Wielkiej Brytanii, z podziałem na kategorie produktów?

SELECT 
    p.category AS Kategorie,
    SUM(oi.sale_price) AS Laczna_wartosc_zamowien
FROM orders AS o
JOIN order_items AS oi ON o.order_id = oi.order_id
JOIN products AS p ON oi.product_id = p.id
JOIN users AS u ON o.user_id = u.id
WHERE u.country = 'United Kingdom'
GROUP BY p.category
ORDER BY Laczna_wartosc_zamowien DESC;


--- Zapytanie 10: Jakie produkty są najczęściej zwracane przez klientów, którzy dokonali zakupu w 2025 roku?
/* Najczęsciej zwracanym produktem jest "Barracuda Men's Brief Swimsuit" z kategorii "Swim", który
został zwrotny 4 razy */
SELECT 
    p.name AS nazwa_produktu,
    p.category AS kategoria_produktu,
    COUNT(*) AS ilosc_zwrotow
FROM order_items AS oi
JOIN products AS p ON oi.product_id = p.id
WHERE oi.returned_at IS NOT NULL
AND oi.created_at::date >= '2025-01-01'
AND oi.created_at::date < '2026-01-01'
GROUP BY p.name, p.category
ORDER BY ilosc_zwrotow DESC;






