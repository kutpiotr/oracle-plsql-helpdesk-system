# Oracle PL/SQL Helpdesk System

## Opis projektu

Projekt przedstawia system obsługi zgłoszeń helpdesk oparty o bazę danych Oracle oraz logikę biznesową zaimplementowaną w PL/SQL.
System został zaprojektowany w podejściu **database-centric**, gdzie kluczowa logika aplikacyjna realizowana jest po stronie bazy danych.

---

## Cel projektu

Celem projektu było:

* zaprojektowanie relacyjnego modelu danych,
* implementacja logiki biznesowej w PL/SQL,
* zapewnienie spójności danych poprzez walidacje i ograniczenia,
* przygotowanie podstawowych mechanizmów raportowania.

---

## Zakres projektu

System umożliwia:

* zarządzanie użytkownikami i rolami,
* tworzenie zgłoszeń helpdesk,
* przypisywanie zgłoszeń do agentów,
* zmianę statusów zgłoszeń zgodnie z workflow,
* zamykanie zgłoszeń,
* dodawanie komentarzy,
* zapisywanie historii zmian statusów,
* generowanie widoków raportowych.

---

## Technologie

Projekt został zrealizowany z wykorzystaniem:

* Oracle Database XE
* Oracle PL/SQL
* SQL
* Oracle SQL Developer
* Git

---

## Role użytkowników

W systemie występują następujące role:

* `USER` – użytkownik zgłaszający problem,
* `AGENT` – osoba obsługująca zgłoszenia,
* `ADMIN` – administrator systemu.

---

## Statusy zgłoszeń

System obsługuje następujące statusy:

* `NEW`
* `IN_PROGRESS`
* `RESOLVED`
* `CLOSED`

---

## Priorytety zgłoszeń

System obsługuje następujące priorytety:

* `LOW`
* `MEDIUM`
* `HIGH`

---

## Reguły biznesowe

1. Każdy użytkownik może utworzyć zgłoszenie.
2. Nowe zgłoszenie otrzymuje status `NEW`.
3. Zgłoszenie może zostać przypisane tylko do użytkownika z rolą `AGENT`.
4. Tylko przypisany agent lub administrator może zmienić status zgłoszenia.
5. Status zgłoszenia zmienia się zgodnie z ustalonym workflow.
6. Zgłoszenie może zostać zamknięte tylko po osiągnięciu statusu `RESOLVED`.
7. Każda zmiana statusu jest zapisywana w historii.
8. Do zgłoszenia można dodawać komentarze.
9. Zgłoszenie musi posiadać tytuł i opis.
10. Każdy użytkownik posiada dokładnie jedną rolę.

---

## Przepływ statusów

Dozwolone przejścia:

* `NEW` → `IN_PROGRESS`
* `IN_PROGRESS` → `RESOLVED`
* `RESOLVED` → `CLOSED`
* `RESOLVED` → `IN_PROGRESS`

---

## Model danych

Projekt wykorzystuje relacyjny model danych oparty o tabele:

* `roles`
* `users`
* `tickets`
* `ticket_comments`
* `ticket_status_history`

![Data Model](docs/ERD.png)

### Relacje

* użytkownik posiada jedną rolę,
* zgłoszenie jest tworzone przez użytkownika,
* zgłoszenie może być przypisane do agenta,
* zgłoszenie może mieć wiele komentarzy,
* każda zmiana statusu jest zapisywana w historii.

### Kluczowe informacje

Tabela `tickets` zawiera m.in.:

* tytuł i opis zgłoszenia,
* autora zgłoszenia,
* przypisanego agenta,
* status i priorytet,
* daty utworzenia, aktualizacji i zamknięcia.

Tabela `ticket_status_history` przechowuje:

* poprzedni i nowy status,
* użytkownika wykonującego zmianę,
* datę zmiany.

---

## Dane testowe

Projekt zawiera przykładowe dane (`seed.sql`), które umożliwiają szybkie przetestowanie systemu.

Dane obejmują:

* role użytkowników,
* użytkowników,
* zgłoszenia,
* komentarze,
* historię zmian.

---

## Logika biznesowa w PL/SQL

Główna logika systemu została zaimplementowana w pakiecie:

`ticket_management_pkg`

Pakiet zawiera:

* `create_ticket` – tworzenie zgłoszeń
* `assign_ticket` – przypisywanie zgłoszeń do agentów
* `change_status` – zmiana statusów zgodnie z workflow
* `close_ticket` – zamykanie zgłoszeń
* `add_comment` – dodawanie komentarzy
* `get_open_tickets_count` – liczba otwartych zgłoszeń

Walidacje biznesowe realizowane są przy użyciu `RAISE_APPLICATION_ERROR`.

---

## Przykładowe wywołania procedur

### Tworzenie zgłoszenia

```sql
BEGIN
ticket_management_pkg.create_ticket(
p_title => 'Problem z logowaniem',
p_description => 'Nie mogę się zalogować do systemu',
p_created_by => 1,
p_priority => 'HIGH'
);
END;
/
```

### Przypisanie zgłoszenia

```sql
BEGIN
ticket_management_pkg.assign_ticket(
p_ticket_id => 1,
p_agent_id => 4
);
END;
/
```

### Zmiana statusu

```sql
BEGIN
ticket_management_pkg.change_status(
p_ticket_id => 1,
p_new_status => 'IN_PROGRESS',
p_changed_by => 4
);
END;
/
```

### Zamknięcie zgłoszenia

```sql
BEGIN
ticket_management_pkg.close_ticket(
p_ticket_id => 3,
p_closed_by => 3
);
END;
/
```

### Dodanie komentarza

```sql
BEGIN
ticket_management_pkg.add_comment(
p_ticket_id => 1,
p_author_id => 4,
p_comment_text => 'Rozpoczęto analizę problemu'
);
END;
/
```

### Liczba otwartych zgłoszeń

```sql
SELECT ticket_management_pkg.get_open_tickets_count
FROM dual;
```

---
## Widoki raportowe

Projekt zawiera widoki wspierające analizę danych:

* `vw_open_tickets` – lista otwartych zgłoszeń
* `vw_tickets_by_status` – liczba zgłoszeń według statusu
* `vw_tickets_by_agent` – liczba zgłoszeń przypisanych do agentów
* `vw_ticket_comments_count` – liczba komentarzy dla zgłoszeń


---

## Przykładowe wyniki

### Otwarte zgłoszenia
![Open Tickets](docs/vw_open_tickets.png)

### Liczba zgłoszeń według statusu
![Tickets by Status](docs/vw_tickets_by_status.png)

---
## Jak uruchomić projekt

1. Uruchom `schema.sql`
2. Uruchom `seed.sql`
3. Uruchom `package_spec.sql`
4. Uruchom `package_body.sql`
5. Uruchom `views.sql`
6. (opcjonalnie) uruchom `test_queries.sql`

---

## Testy

Projekt zawiera:

* `sql/test_queries.sql` – zapytania testowe
* `tests/manual_tests.md` – scenariusze testowe

Testy obejmują:

* tworzenie zgłoszeń,
* walidację błędnych danych,
* przypisywanie zgłoszeń,
* zmianę statusów,
* zamykanie zgłoszeń,
* dodawanie komentarzy.

---

## Możliwości rozwoju

Projekt może zostać rozszerzony o:

* bardziej zaawansowane zarządzanie uprawnieniami,
* dodatkowe raporty i analizy,
* automatyczne testy PL/SQL,
* integrację z backendem (API),
* interfejs użytkownika.

## Autor

Piotr Kut student kierunku Inżynieria i analiza danych
