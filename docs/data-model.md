# Model danych

## Opis

Projekt wykorzystuje relacyjny model danych dla systemu obsługi zgłoszeń helpdesk.
Struktura została zaprojektowana w sposób umożliwiający implementację logiki biznesowej w PL/SQL oraz zapewnienie integralności danych.

---

## Tabele

### roles

Przechowuje role użytkowników systemu.

* role_id (PK)
* role_name (UNIQUE, NOT NULL)

Przykładowe wartości:

* USER
* AGENT
* ADMIN

---

### users

Przechowuje użytkowników systemu.

* user_id (PK)
* full_name (NOT NULL)
* email (UNIQUE, NOT NULL)
* role_id (FK → roles.role_id, NOT NULL)
* created_at (NOT NULL)

---

### tickets

Główna tabela przechowująca zgłoszenia helpdesk.

* ticket_id (PK)
* title (NOT NULL)
* description (NOT NULL)
* created_by (FK → users.user_id, NOT NULL)
* assigned_to (FK → users.user_id, NULL)
* status (NOT NULL)
* priority (NOT NULL)
* created_at (NOT NULL)
* updated_at (NOT NULL)
* closed_at (NULL)

Dozwolone wartości status:

* NEW
* IN_PROGRESS
* RESOLVED
* CLOSED

Dozwolone wartości priority:

* LOW
* MEDIUM
* HIGH

---

### ticket_comments

Przechowuje komentarze do zgłoszeń.

* comment_id (PK)
* ticket_id (FK → tickets.ticket_id, NOT NULL)
* author_id (FK → users.user_id, NOT NULL)
* comment_text (NOT NULL)
* created_at (NOT NULL)

---

### ticket_status_history

Przechowuje historię zmian statusów zgłoszeń.

* history_id (PK)
* ticket_id (FK → tickets.ticket_id, NOT NULL)
* old_status
* new_status (NOT NULL)
* changed_by (FK → users.user_id, NOT NULL)
* changed_at (NOT NULL)

---

## Relacje

* roles 1 → N users
* users 1 → N tickets (created_by)
* users 1 → N tickets (assigned_to)
* tickets 1 → N ticket_comments
* users 1 → N ticket_comments
* tickets 1 → N ticket_status_history
* users 1 → N ticket_status_history

---

## Klucze główne (PK)

* roles.role_id
* users.user_id
* tickets.ticket_id
* ticket_comments.comment_id
* ticket_status_history.history_id

---
# Model danych

## Opis

Projekt wykorzystuje relacyjny model danych dla systemu obsługi zgłoszeń helpdesk.
Struktura została zaprojektowana w sposób umożliwiający implementację logiki biznesowej w PL/SQL oraz zapewnienie integralności danych.

---

## Tabele

### roles

Przechowuje role użytkowników systemu.

* role_id (PK)
* role_name (UNIQUE, NOT NULL)

Przykładowe wartości:

* USER
* AGENT
* ADMIN

---

### users

Przechowuje użytkowników systemu.

* user_id (PK)
* full_name (NOT NULL)
* email (UNIQUE, NOT NULL)
* role_id (FK → roles.role_id, NOT NULL)
* created_at (NOT NULL)

---

### tickets

Główna tabela przechowująca zgłoszenia helpdesk.

* ticket_id (PK)
* title (NOT NULL)
* description (NOT NULL)
* created_by (FK → users.user_id, NOT NULL)
* assigned_to (FK → users.user_id, NULL)
* status (NOT NULL)
* priority (NOT NULL)
* created_at (NOT NULL)
* updated_at (NOT NULL)
* closed_at (NULL)

Dozwolone wartości status:

* NEW
* IN_PROGRESS
* RESOLVED
* CLOSED

Dozwolone wartości priority:

* LOW
* MEDIUM
* HIGH

---

### ticket_comments

Przechowuje komentarze do zgłoszeń.

* comment_id (PK)
* ticket_id (FK → tickets.ticket_id, NOT NULL)
* author_id (FK → users.user_id, NOT NULL)
* comment_text (NOT NULL)
* created_at (NOT NULL)

---

### ticket_status_history

Przechowuje historię zmian statusów zgłoszeń.

* history_id (PK)
* ticket_id (FK → tickets.ticket_id, NOT NULL)
* old_status
* new_status (NOT NULL)
* changed_by (FK → users.user_id, NOT NULL)
* changed_at (NOT NULL)

---

## Relacje

* roles 1 → N users
* users 1 → N tickets (created_by)
* users 1 → N tickets (assigned_to)
* tickets 1 → N ticket_comments
* users 1 → N ticket_comments
* tickets 1 → N ticket_status_history
* users 1 → N ticket_status_history

---

## Klucze główne (PK)

* roles.role_id
* users.user_id
* tickets.ticket_id
* ticket_comments.comment_id
* ticket_status_history.history_id

---

## Klucze obce (FK)

* users.role_id → roles.role_id
* tickets.created_by → users.user_id
* tickets.assigned_to → users.user_id
* ticket_comments.ticket_id → tickets.ticket_id
* ticket_comments.author_id → users.user_id
* ticket_status_history.ticket_id → tickets.ticket_id
* ticket_status_history.changed_by → users.user_id

---

## Ograniczenia (constraints)

### users

* email UNIQUE
* full_name NOT NULL
* email NOT NULL
* role_id NOT NULL

### tickets

* title NOT NULL
* description NOT NULL
* created_by NOT NULL
* status NOT NULL
* priority NOT NULL
* created_at NOT NULL

### ticket_comments

* comment_text NOT NULL

---

## Uwagi projektowe

* Logika biznesowa (tworzenie zgłoszeń, zmiana statusów, przypisania) będzie zaimplementowana w pakietach PL/SQL.
* Historia zmian statusów będzie zapisywana automatycznie (trigger lub procedura).
* Model został uproszczony (status i priority jako CHECK zamiast osobnych tabel), aby skupić się na logice PL/SQL.

---

* users.role_id → roles.role_id
* tickets.created_by → users.user_id
* tickets.assigned_to → users.user_id
* ticket_comments.ticket_id → tickets.ticket_id
* ticket_comments.author_id → users.user_id
* ticket_status_history.ticket_id → tickets.ticket_id
* ticket_status_history.changed_by → users.user_id

---

## Ograniczenia (constraints)

### users

* email UNIQUE
* full_name NOT NULL
* email NOT NULL
* role_id NOT NULL

### tickets

* title NOT NULL
* description NOT NULL
* created_by NOT NULL
* status NOT NULL
* priority NOT NULL
* created_at NOT NULL

### ticket_comments

* comment_text NOT NULL

---

## Uwagi projektowe

* Logika biznesowa (tworzenie zgłoszeń, zmiana statusów, przypisania) będzie zaimplementowana w pakietach PL/SQL.
* Historia zmian statusów będzie zapisywana automatycznie (trigger lub procedura).
* Model został uproszczony (status i priority jako CHECK zamiast osobnych tabel), aby skupić się na logice PL/SQL.

---
