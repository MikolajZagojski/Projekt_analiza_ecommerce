# Analiza zachowań konsumenckich i efektywności sprzedaży w sektorze e-commerce

Kompleksowa analiza danych transakcyjnych z platformy e-commerce. Projekt łączy wykorzystanie relacyjnej bazy danych **PostgreSQL** do składowania i wstępnego przetwarzania danych z zaawansowaną eksploracją i wizualizacją przy użyciu **Pythona** w środowisku **Jupyter Notebook**.

---

## Spis treści

1. [O projekcie](#o-projekcie)
2. [Pytania badawcze](#pytania-badawcze)
3. [Źródło danych](#źródło-danych)
4. [Stack technologiczny](#stack-technologiczny)
5. [Struktura repozytorium](#struktura-repozytorium)
6. [Etapy i realizacja](#etapy-i-realizacja)
7. [Jak uruchomić projekt](#jak-uruchomić-projekt)

---

## 1. O projekcie

Głównym celem projektu jest identyfikacja kluczowych wzorców zachowań konsumenckich, analiza procesów zakupowych oraz ocena rentowności produktów. Projekt demonstruje umiejętność łączenia zapytań SQL z zaawansowaną analizą w bibliotece Pandas.

---

## 2. Pytania badawcze

1. **Różnice geograficzne:** Czy istnieją wyraźne różnice w średniej wartości koszyka między poszczególnymi krajami?
2. **Demografia a wartość zamówienia:** Czy płeć klienta różnicuje wartość zamówień i jak ten trend zmienia się w czasie?
3. **Ryzyko finansowe (Zwroty):** Które kategorie produktów generują największe ryzyko finansowe z tytułu zwrotów?

---

## 3. Źródło danych

Dane pochodzą z publicznego zbioru **TheLook eCommerce** (Google BigQuery).

Wykorzystane tabele:

* `users` - dane demograficzne i lokalizacyjne klientów (wiek, płeć, kraj itp.).
* `products` - katalog produktów z cenami detalicznymi i kosztami.
* `orders` - nagłówki zamówień i ich statusy.
* `order_items` - pozycje poszczególnych zamówień.

---

## 4. Stack technologiczny
* **Baza danych:** PostgreSQL
* **Języki programowania:** Python 3.x, SQL
* **Główne biblioteki Pythona:** * `pandas`, `numpy` (przetwarzanie danych)
  * `matplotlib`, `seaborn` (wizualizacja danych)
  * `sqlalchemy`, `python-dotenv` (połączenie z bazą danych)
* **Środowisko:** Jupyter Notebook, Windows Subsystem for Linux (WSL 2 / Ubuntu)

---

## 5. Struktura repozytorium

* `projekt.ipynb` — Główna analiza EDA i wizualizacje w Pythonie
* `ecommerce_queries.sql` — Zbiór zapytań SQL
* `.gitignore` — Wyklucza pliki danych i `.env`
* `requirements.txt` — Lista zależności

---

##  6. Etapy i realizacja

1. **Konfiguracja środowiska i bazy danych:**
   * Uruchomienie lokalnego serwera PostgreSQL na WSL.
   * Utworzenie bazy danych w PostgreSQL oraz zdefiniowanie struktury tabel wraz z nadaniem odpowiednich typów zmiennych ([Schema Definition](https://drawsql.app/teams/projekt-ecommerce/diagrams/projekt-ecommerce/embed))
   * Automatyczny import danych z plików `.csv` do bazy przy pomocy skryptu Python (`sqlalchemy`).

2. **Czyszczenie danych (Data Cleaning):**
   * Identyfikacja braków danych we wszystkich tabelach.
   * Celowe pozostawienie braków w kolumnach takich jak `returned_at` czy `shipped_at`, które odzwierciedlają naturalny stan zamówienia.
   * Usunięcie niekompletnych rekordów w tabeli `products` (brak nazwy/marki) dla zachowania spójności.

3. **Analiza Exploracyjna (EDA) i Wizualizacja:**
   * Tworzenie zapytań SQL i odczyt wyników bezpośrednio do `pandas.DataFrame`.
   * Przekrojowe wizualizacje trendów przy użyciu pakietu `seaborn`.

4. **Zaawansowane analizy SQL (`ecommerce_queries.sql`):**
   * Wykonanie złożonych zapytań agregujących bezpośrednio w silniku bazy danych w celu weryfikacji hipotez biznesowych.

---


## 7. Jak uruchomić projekt

### 1. Sklonuj repozytorium

```bash
git clone https://github.com/TwojUzytkownik/nazwa-repozytorium.git
cd nazwa-repozytorium
```

### 2. Skonfiguruj środowisko wirtualne

```bash
python -m venv venv

# Windows
venv\Scripts\activate

# Linux / MacOS
source venv/bin/activate
```

### 3. Zainstaluj zależności

```bash
pip install -r requirements.txt
```

### 4. Skonfiguruj plik `.env`

Utwórz plik `.env` w katalogu głównym projektu:

```
DB_USER=twoja_nazwa_użytkownika
DB_PASS=twoje_hasło
DB_HOST=localhost
DB_PORT=5432
DB_NAME=nazwa_twojej_bazy
```
### 5. Przygotowanie bazy danych
 1. Uruchom swój serwer PostgreSQL.

 2. Utwórz nową, pustą bazę danych o nazwie analiza_ecommerce.

 3. *KLUCZOWY KROK:* Otwórz plik schema.sql w swoim narzędziu do baz danych (np. pgAdmin, DBeaver lub terminal) i uruchom go jako pierwszy. To on stworzy strukturę tabel, nada typy danych i ustawi relacje (klucze obce).

 4. Jeśli korzystasz z CSV, umieść pliki w katalogu projektu:

* `users.csv`
* `products.csv`
* `orders.csv`
* `order_items.csv`

### 6. Uruchom analizę

```bash
jupyter notebook projekt.ipynb
```

---

## Uwagi

* Dane nie są dołączone do repozytorium (ze względu na rozmiar)
* Projekt ma charakter edukacyjny i demonstracyjny
