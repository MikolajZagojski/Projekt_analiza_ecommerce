--- Zapytanie 1: Jaka jest średnia wartość zamówienia dla klientów w wieku 30-40 lat, z podziałem na państwa?

SELECT 
    u.country AS kraje,
    COUNT(*) AS ilosc_zamowien, 
    ROUND(AVG(oi.sale_price)::numeric,2) AS srednia_wartosc_koszyka -- ROUND przyjmuje numeric a AVG zwaca float
FROM users AS u 
JOIN order_items AS oi ON u.id = oi.user_id
WHERE (u.age BETWEEN  30 AND 40)  
GROUP BY u.country
ORDER BY srednia_wartosc_koszyka DESC;

/* Najwyższa średnia dla klientów w wieku 30-40 lat występuje w Kolumbii, ale przez małą liczbę zamówień (tylko 5) ten wynik nie jest miarodajny.
Wśród krajów z dużą liczbą transakcji (powyżej 100) liderem jest Japonia, gdzie średnia wartość zamówienia wynosi 61,63 USD.*/

--- Zapytanie 2: Które produkty są najczęściej zwracane przez klientów, z podziałem na kategorie produktów?

SELECT 
    p.category AS kategorie,
    COUNT(*) AS ilosc_zwrotow 
FROM order_items AS oi 
JOIN products AS p ON oi.product_id = p.id
WHERE oi.returned_at IS NOT NULL 
GROUP BY p.category
ORDER BY ilosc_zwrotow DESC;

/* Produkty z kategorii  "Intimates" są najczęściej zwracane, 1246 razy. */

--- Zapytanie 3: Ile procent zamówień zawiera produkty z kategorii "Intimates" w porównaniu do innych kategorii?

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
/* Produkty z kategori "Intimates" stanowią 10.00% wszystkich zamówień. */


--- Zapytanie 4: Ile zamówień zostało złożonych przez klientów, którzy dokonali co najmniej 5 zamówień w ciągu ostatniego roku?
SELECT 
    user_id, 
    COUNT(order_id) AS liczba_zamowien
FROM orders
WHERE created_at::timestamp >= CURRENT_DATE - INTERVAL '1 year'
GROUP BY user_id
HAVING COUNT(order_id) > 3;

--- Zapytanie 5: Które kategorie produktów są najczęściej zamawiane przez klientów powyżej 50 roku życia, z podziałem na płeć?
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

--- Najczęściej zamawiają produkty z kategori prywatnej z działu dla kobiet (4575) a najrzadziej z zestawów ubrań (72) z działu dla kobiet.


--- Zapytanie 6: Z jakiego niemieckiego miasta pochodzą klienci, którzy złożyli zamówienia o wartości powyżej 100 USD?

--- Zapytanie 7: Jaka jest średnia liczba produktów zamawianych przez klientów w wieku poniżej 25 lat, z podziałem na płeć?

--- Zapytanie 8: Które dni tygodnia są najbardziej popularne do składania zamówień przez klientów z USA?

--- Zapytanie 9: Jaka jest łączna wartość zamówień dla klientów z Kanady, z podziałem na kategorie produktów?
9
--- Zapytanie 10: Jakie produkty są najczęściej zwracane przez klientów, którzy dokonali zakupu w 2025 roku?



