-- =========================
-- ROLES
-- =========================
INSERT INTO roles (role_name) VALUES ('USER');
INSERT INTO roles (role_name) VALUES ('AGENT');
INSERT INTO roles (role_name) VALUES ('ADMIN');

-- =========================
-- USERS
-- =========================
INSERT INTO users (full_name, email, role_id)
VALUES ('Jan Kowalski', 'jan@example.com', 1);

INSERT INTO users (full_name, email, role_id)
VALUES ('Anna Nowak', 'anna@example.com', 1);

INSERT INTO users (full_name, email, role_id)
VALUES ('Piotr Admin', 'admin@example.com', 3);

INSERT INTO users (full_name, email, role_id)
VALUES ('Katarzyna Agent', 'agent1@example.com', 2);

INSERT INTO users (full_name, email, role_id)
VALUES ('Marek Agent', 'agent2@example.com', 2);

-- =========================
-- TICKETS
-- =========================
INSERT INTO tickets (title, description, created_by, assigned_to, status, priority)
VALUES ('Problem z logowaniem', 'Nie mogę się zalogować do systemu', 1, 4, 'NEW', 'HIGH');

INSERT INTO tickets (title, description, created_by, assigned_to, status, priority)
VALUES ('Błąd aplikacji', 'Aplikacja się zawiesza przy starcie', 2, 5, 'IN_PROGRESS', 'MEDIUM');

INSERT INTO tickets (title, description, created_by, assigned_to, status, priority)
VALUES ('Reset hasła', 'Proszę o reset hasła', 1, 4, 'RESOLVED', 'LOW');

INSERT INTO tickets (title, description, created_by, assigned_to, status, priority)
VALUES ('Nie działa raport', 'Raport sprzedaży nie generuje się', 2, 5, 'CLOSED', 'HIGH');

-- =========================
-- COMMENTS
-- =========================
INSERT INTO ticket_comments (ticket_id, author_id, comment_text)
VALUES (1, 4, 'Sprawdzam problem');

INSERT INTO ticket_comments (ticket_id, author_id, comment_text)
VALUES (2, 5, 'Analizuję logi');

INSERT INTO ticket_comments (ticket_id, author_id, comment_text)
VALUES (3, 4, 'Hasło zostało zresetowane');

-- =========================
-- STATUS HISTORY
-- =========================
INSERT INTO ticket_status_history (ticket_id, old_status, new_status, changed_by)
VALUES (2, 'NEW', 'IN_PROGRESS', 5);

INSERT INTO ticket_status_history (ticket_id, old_status, new_status, changed_by)
VALUES (3, 'IN_PROGRESS', 'RESOLVED', 4);

INSERT INTO ticket_status_history (ticket_id, old_status, new_status, changed_by)
VALUES (4, 'RESOLVED', 'CLOSED', 5);

COMMIT;