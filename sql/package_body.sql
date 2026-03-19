CREATE OR REPLACE PACKAGE BODY ticket_management_pkg AS PROCEDURE create_ticket(
        p_title IN VARCHAR2,
        p_description IN CLOB,
        p_created_by IN NUMBER,
        p_priority IN VARCHAR2
    ) AS v_user_count NUMBER;
BEGIN IF p_title IS NULL
OR TRIM(p_title) = '' THEN RAISE_APPLICATION_ERROR(-20001, 'Ticket title cannot be empty.');
END IF;
IF p_description IS NULL
OR DBMS_LOB.GETLENGTH(p_description) = 0 THEN RAISE_APPLICATION_ERROR(-20002, 'Ticket description cannot be empty.');
END IF;
IF p_priority NOT IN ('LOW', 'MEDIUM', 'HIGH') THEN RAISE_APPLICATION_ERROR(-20003, 'Invalid ticket priority.');
END IF;
SELECT COUNT(*) INTO v_user_count
FROM users
WHERE user_id = p_created_by;
IF v_user_count = 0 THEN RAISE_APPLICATION_ERROR(-20004, 'Creating user does not exist.');
END IF;
INSERT INTO tickets (
        title,
        description,
        created_by,
        assigned_to,
        status,
        priority,
        created_at,
        updated_at,
        closed_at
    )
VALUES (
        p_title,
        p_description,
        p_created_by,
        NULL,
        'NEW',
        p_priority,
        SYSDATE,
        SYSDATE,
        NULL
    );
END create_ticket;
PROCEDURE assign_ticket(p_ticket_id IN NUMBER, p_agent_id IN NUMBER) AS v_ticket_count NUMBER;
v_agent_count NUMBER;
BEGIN
SELECT COUNT(*) INTO v_ticket_count
FROM tickets
WHERE ticket_id = p_ticket_id;
IF v_ticket_count = 0 THEN RAISE_APPLICATION_ERROR(-20005, 'Ticket does not exist.');
END IF;
SELECT COUNT(*) INTO v_agent_count
FROM users u
    JOIN roles r ON u.role_id = r.role_id
WHERE u.user_id = p_agent_id
    AND r.role_name = 'AGENT';
IF v_agent_count = 0 THEN RAISE_APPLICATION_ERROR(
    -20006,
    'Assigned user is not an agent or does not exist.'
);
END IF;
UPDATE tickets
SET assigned_to = p_agent_id,
    updated_at = SYSDATE
WHERE ticket_id = p_ticket_id;
END assign_ticket;

PROCEDURE change_status(
p_ticket_id IN NUMBER,
p_new_status IN VARCHAR2,
p_changed_by IN NUMBER
) AS
v_current_status VARCHAR2(20);
v_ticket_count NUMBER;
v_user_count NUMBER;
BEGIN
-- sprawdzenie ticketu
SELECT COUNT(*)
INTO v_ticket_count
FROM tickets
WHERE ticket_id = p_ticket_id;

IF v_ticket_count = 0 THEN
RAISE_APPLICATION_ERROR(-20007, 'Ticket does not exist.');
END IF;

-- sprawdzenie użytkownika
SELECT COUNT(*)
INTO v_user_count
FROM users
WHERE user_id = p_changed_by;

IF v_user_count = 0 THEN
RAISE_APPLICATION_ERROR(-20008, 'User does not exist.');
END IF;

-- pobranie aktualnego statusu
SELECT status
INTO v_current_status
FROM tickets
WHERE ticket_id = p_ticket_id;

-- walidacja statusu docelowego
IF p_new_status NOT IN ('NEW', 'IN_PROGRESS', 'RESOLVED', 'CLOSED') THEN
RAISE_APPLICATION_ERROR(-20009, 'Invalid status.');
END IF;

-- walidacja przejść statusów
IF v_current_status = 'NEW' AND p_new_status != 'IN_PROGRESS' THEN
RAISE_APPLICATION_ERROR(-20010, 'Invalid status transition.');
END IF;

IF v_current_status = 'IN_PROGRESS' AND p_new_status != 'RESOLVED' THEN
RAISE_APPLICATION_ERROR(-20011, 'Invalid status transition.');
END IF;

IF v_current_status = 'RESOLVED' AND p_new_status NOT IN ('CLOSED', 'IN_PROGRESS') THEN
RAISE_APPLICATION_ERROR(-20012, 'Invalid status transition.');
END IF;

IF v_current_status = 'CLOSED' THEN
RAISE_APPLICATION_ERROR(-20013, 'Cannot change status of closed ticket.');
END IF;

-- zapis historii
INSERT INTO ticket_status_history (
ticket_id,
old_status,
new_status,
changed_by,
changed_at
)
VALUES (
p_ticket_id,
v_current_status,
p_new_status,
p_changed_by,
SYSDATE
);

-- aktualizacja ticketu
UPDATE tickets
SET status = p_new_status,
updated_at = SYSDATE,
closed_at = CASE WHEN p_new_status = 'CLOSED' THEN SYSDATE ELSE closed_at END
WHERE ticket_id = p_ticket_id;

END change_status;


PROCEDURE close_ticket(
p_ticket_id IN NUMBER,
p_closed_by IN NUMBER
) AS
v_ticket_count NUMBER;
v_user_count NUMBER;
v_current_status VARCHAR2(20);
BEGIN
SELECT COUNT(*)
INTO v_ticket_count
FROM tickets
WHERE ticket_id = p_ticket_id;

IF v_ticket_count = 0 THEN
RAISE_APPLICATION_ERROR(-20014, 'Ticket does not exist.');
END IF;

SELECT COUNT(*)
INTO v_user_count
FROM users
WHERE user_id = p_closed_by;

IF v_user_count = 0 THEN
RAISE_APPLICATION_ERROR(-20015, 'User does not exist.');
END IF;

SELECT status
INTO v_current_status
FROM tickets
WHERE ticket_id = p_ticket_id;

IF v_current_status != 'RESOLVED' THEN
RAISE_APPLICATION_ERROR(-20016, 'Only resolved tickets can be closed.');
END IF;

INSERT INTO ticket_status_history (
ticket_id,
old_status,
new_status,
changed_by,
changed_at
)
VALUES (
p_ticket_id,
v_current_status,
'CLOSED',
p_closed_by,
SYSDATE
);

UPDATE tickets
SET status = 'CLOSED',
updated_at = SYSDATE,
closed_at = SYSDATE
WHERE ticket_id = p_ticket_id;

END close_ticket;

PROCEDURE add_comment(
p_ticket_id IN NUMBER,
p_author_id IN NUMBER,
p_comment_text IN CLOB
) AS
v_ticket_count NUMBER;
v_user_count NUMBER;
BEGIN
SELECT COUNT(*)
INTO v_ticket_count
FROM tickets
WHERE ticket_id = p_ticket_id;

IF v_ticket_count = 0 THEN
RAISE_APPLICATION_ERROR(-20017, 'Ticket does not exist.');
END IF;

SELECT COUNT(*)
INTO v_user_count
FROM users
WHERE user_id = p_author_id;

IF v_user_count = 0 THEN
RAISE_APPLICATION_ERROR(-20018, 'User does not exist.');
END IF;

IF p_comment_text IS NULL OR DBMS_LOB.GETLENGTH(p_comment_text) = 0 THEN
RAISE_APPLICATION_ERROR(-20019, 'Comment cannot be empty.');
END IF;

INSERT INTO ticket_comments (
ticket_id,
author_id,
comment_text,
created_at
)
VALUES (
p_ticket_id,
p_author_id,
p_comment_text,
SYSDATE
);

UPDATE tickets
SET updated_at = SYSDATE
WHERE ticket_id = p_ticket_id;

END add_comment;

FUNCTION get_open_tickets_count RETURN NUMBER AS v_count NUMBER;
BEGIN
SELECT COUNT(*) INTO v_count
FROM tickets
WHERE status IN ('NEW', 'IN_PROGRESS', 'RESOLVED');
RETURN v_count;
END get_open_tickets_count;
END ticket_management_pkg;
/