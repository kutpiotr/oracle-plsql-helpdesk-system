# Oracle PL/SQL Helpdesk System

## Cel projektu

Projekt przedstawia system obsługi zgłoszeń helpdesk oparty o bazę danych Oracle oraz logikę biznesową zaimplementowaną w PL/SQL.  
System umożliwia tworzenie zgłoszeń, przypisywanie ich do agentów, zmianę statusów, dodawanie komentarzy oraz rejestrowanie historii zmian.

## Zakres projektu

System umożliwia:
- zarządzanie użytkownikami i rolami,
- tworzenie zgłoszeń helpdesk,
- przypisywanie zgłoszeń do agentów,
- zmianę statusów zgłoszeń,
- zamykanie zgłoszeń,
- dodawanie komentarzy,
- zapisywanie historii zmian statusów,
- generowanie podstawowych widoków raportowych.

## Role użytkowników

W systemie występują następujące role:
- `USER` – użytkownik zgłaszający problem,
- `AGENT` – osoba obsługująca zgłoszenia,
- `ADMIN` – administrator systemu.

## Statusy zgłoszeń

System obsługuje następujące statusy zgłoszeń:
- `NEW`
- `IN_PROGRESS`
- `RESOLVED`
- `CLOSED`

## Priorytety zgłoszeń

System obsługuje następujące priorytety:
- `LOW`
- `MEDIUM`
- `HIGH`

## Reguły biznesowe

1. Każdy użytkownik może utworzyć zgłoszenie.
2. Nowe zgłoszenie otrzymuje status `NEW`.
3. Zgłoszenie może zostać przypisane tylko do użytkownika z rolą `AGENT`.
4. Tylko przypisany agent albo administrator może zmienić status zgłoszenia.
5. Status zgłoszenia może zmieniać się zgodnie z ustalonym przebiegiem procesu.
6. Zgłoszenie może zostać zamknięte tylko wtedy, gdy wcześniej uzyskało status `RESOLVED`.
7. Każda zmiana statusu zgłoszenia musi zostać zapisana w historii.
8. Do zgłoszenia można dodawać komentarze.
9. Nie można utworzyć zgłoszenia bez tytułu i opisu.
10. Każdy użytkownik musi mieć przypisaną dokładnie jedną rolę.

## Przepływ statusów

Dozwolone przejścia statusów:
- `NEW` → `IN_PROGRESS`
- `IN_PROGRESS` → `RESOLVED`
- `RESOLVED` → `CLOSED`
- `RESOLVED` → `IN_PROGRESS`

## Model danych

Projekt wykorzystuje relacyjny model danych oparty o następujące tabele:

- `roles` – role użytkowników systemu,
- `users` – użytkownicy systemu,
- `tickets` – zgłoszenia helpdesk,
- `ticket_comments` – komentarze do zgłoszeń,
- `ticket_status_history` – historia zmian statusów zgłoszeń.

### Relacje

- każdy użytkownik posiada jedną rolę,
- każde zgłoszenie jest tworzone przez użytkownika,
- zgłoszenie może być przypisane do agenta,
- każde zgłoszenie może posiadać wiele komentarzy,
- każda zmiana statusu zgłoszenia jest zapisywana w historii.

### Główne atrybuty

Tabela `tickets` przechowuje m.in.:
- tytuł zgłoszenia,
- opis zgłoszenia,
- autora zgłoszenia,
- przypisanego agenta,
- status,
- priorytet,
- daty utworzenia, aktualizacji i zamknięcia.

Tabela `ticket_status_history` przechowuje:
- poprzedni status,
- nowy status,
- użytkownika wykonującego zmianę,
- datę zmiany.

## Dane testowe

Projekt zawiera przykładowe dane w pliku `seed.sql`, które umożliwiają szybkie przetestowanie funkcjonalności systemu.

Dane obejmują:
- role użytkowników,
- użytkowników systemu,
- przykładowe zgłoszenia,
- komentarze,
- historię zmian statusów.