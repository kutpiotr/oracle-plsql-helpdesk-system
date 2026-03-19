CREATE OR REPLACE VIEW vw_open_tickets AS
SELECT
t.ticket_id,
t.title,
t.status,
t.priority,
u.full_name AS created_by_name,
a.full_name AS assigned_agent_name,
t.created_at,
t.updated_at
FROM tickets t
JOIN users u ON t.created_by = u.user_id
LEFT JOIN users a ON t.assigned_to = a.user_id
WHERE t.status IN ('NEW', 'IN_PROGRESS', 'RESOLVED');

CREATE OR REPLACE VIEW vw_tickets_by_status AS
SELECT
status,
COUNT(*) AS ticket_count
FROM tickets
GROUP BY status;

CREATE OR REPLACE VIEW vw_tickets_by_agent AS
SELECT
u.user_id AS agent_id,
u.full_name AS agent_name,
COUNT(t.ticket_id) AS assigned_tickets_count
FROM users u
JOIN roles r ON u.role_id = r.role_id
LEFT JOIN tickets t ON u.user_id = t.assigned_to
WHERE r.role_name = 'AGENT'
GROUP BY u.user_id, u.full_name;

CREATE OR REPLACE VIEW vw_ticket_comments_count AS
SELECT
t.ticket_id,
t.title,
COUNT(c.comment_id) AS comments_count
FROM tickets t
LEFT JOIN ticket_comments c ON t.ticket_id = c.ticket_id
GROUP BY t.ticket_id, t.title;