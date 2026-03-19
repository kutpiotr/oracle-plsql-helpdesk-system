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
) AS BEGIN NULL;
END change_status;
PROCEDURE close_ticket(
    p_ticket_id IN NUMBER,
    p_closed_by IN NUMBER
) AS BEGIN NULL;
END close_ticket;
PROCEDURE add_comment(
    p_ticket_id IN NUMBER,
    p_author_id IN NUMBER,
    p_comment_text IN CLOB
) AS BEGIN NULL;
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