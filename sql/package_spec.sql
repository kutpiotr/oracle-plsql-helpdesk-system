CREATE OR REPLACE PACKAGE ticket_management_pkg AS

PROCEDURE create_ticket(
p_title IN VARCHAR2,
p_description IN CLOB,
p_created_by IN NUMBER,
p_priority IN VARCHAR2
);

PROCEDURE assign_ticket(
p_ticket_id IN NUMBER,
p_agent_id IN NUMBER
);

PROCEDURE change_status(
p_ticket_id IN NUMBER,
p_new_status IN VARCHAR2,
p_changed_by IN NUMBER
);

PROCEDURE close_ticket(
p_ticket_id IN NUMBER,
p_closed_by IN NUMBER
);

PROCEDURE add_comment(
p_ticket_id IN NUMBER,
p_author_id IN NUMBER,
p_comment_text IN CLOB
);

FUNCTION get_open_tickets_count
RETURN NUMBER;

END ticket_management_pkg;
/