# Testy manualne

## Zakres testów

Przeprowadzono testy manualne dla głównych procedur pakietu `ticket_management_pkg`.

## Testowane operacje

- tworzenie zgłoszenia,
- przypisywanie zgłoszenia do agenta,
- zmiana statusu zgłoszenia,
- zamykanie zgłoszenia,
- dodawanie komentarza,
- odczyt liczby otwartych zgłoszeń.

## Przykładowe scenariusze

### 1. Utworzenie poprawnego zgłoszenia
Oczekiwany wynik:
- zgłoszenie zostaje zapisane,
- status ustawiony na `NEW`.

### 2. Próba utworzenia zgłoszenia bez tytułu
Oczekiwany wynik:
- zwrócenie błędu aplikacyjnego.

### 3. Przypisanie zgłoszenia do użytkownika z rolą `AGENT`
Oczekiwany wynik:
- zgłoszenie zostaje przypisane.

### 4. Próba przypisania zgłoszenia do zwykłego użytkownika
Oczekiwany wynik:
- zwrócenie błędu aplikacyjnego.

### 5. Zmiana statusu zgodnie z workflow
Oczekiwany wynik:
- status zostaje zaktualizowany,
- historia zmian zostaje zapisana.

### 6. Próba niedozwolonej zmiany statusu
Oczekiwany wynik:
- zwrócenie błędu aplikacyjnego.