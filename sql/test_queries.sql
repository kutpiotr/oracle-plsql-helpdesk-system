-- =====================================
-- TEST 1: create_ticket - poprawny przypadek
-- =====================================
BEGIN
ticket_management_pkg.create_ticket(
p_title => 'Test ticket',
p_description => 'Test description',
p_created_by => 1,
p_priority => 'LOW'
);
END;
/
SELECT ticket_id, title, status, priority
FROM tickets
WHERE title = 'Test ticket';

-- =====================================
-- TEST 2: create_ticket - pusty tytul
-- =====================================
BEGIN
ticket_management_pkg.create_ticket(
p_title => '',
p_description => 'Invalid ticket',
p_created_by => 1,
p_priority => 'LOW'
);
END;
/

-- =====================================
-- TEST 3: assign_ticket - poprawny przypadek
-- =====================================
BEGIN
ticket_management_pkg.assign_ticket(
p_ticket_id => 1,
p_agent_id => 4
);
END;
/
SELECT ticket_id, assigned_to
FROM tickets
WHERE ticket_id = 1;

-- =====================================
-- TEST 4: assign_ticket - przypisanie do zwyklego usera
-- =====================================
BEGIN
ticket_management_pkg.assign_ticket(
p_ticket_id => 1,
p_agent_id => 1
);
END;
/

-- =====================================
-- TEST 5: change_status - poprawny przypadek
-- =====================================
BEGIN
ticket_management_pkg.change_status(
p_ticket_id => 1,
p_new_status => 'IN_PROGRESS',
p_changed_by => 4
);
END;
/
SELECT ticket_id, status
FROM tickets
WHERE ticket_id = 1;

-- =====================================
-- TEST 6: change_status - niepoprawne przejscie
-- =====================================
BEGIN
ticket_management_pkg.change_status(
p_ticket_id => 1,
p_new_status => 'CLOSED',
p_changed_by => 4
);
END;
/

-- =====================================
-- TEST 7: close_ticket - poprawny przypadek
-- =====================================
BEGIN
ticket_management_pkg.close_ticket(
p_ticket_id => 3,
p_closed_by => 3
);
END;
/
SELECT ticket_id, status, closed_at
FROM tickets
WHERE ticket_id = 3;

-- =====================================
-- TEST 8: add_comment - poprawny przypadek
-- =====================================
BEGIN
ticket_management_pkg.add_comment(
p_ticket_id => 2,
p_author_id => 5,
p_comment_text => 'Dodany komentarz testowy'
);
END;
/
SELECT comment_id, ticket_id, author_id, comment_text
FROM ticket_comments
WHERE ticket_id = 2
ORDER BY comment_id;

-- =====================================
-- TEST 9: get_open_tickets_count
-- =====================================
SELECT ticket_management_pkg.get_open_tickets_count AS open_tickets
FROM dual;