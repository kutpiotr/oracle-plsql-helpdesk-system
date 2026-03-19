CREATE TABLE roles (
role_id NUMBER PRIMARY KEY,
role_name VARCHAR2(50) NOT NULL UNIQUE
);

CREATE TABLE users (
user_id NUMBER PRIMARY KEY,
full_name VARCHAR2(100) NOT NULL,
email VARCHAR2(100) NOT NULL UNIQUE,
role_id NUMBER NOT NULL,
created_at DATE DEFAULT SYSDATE NOT NULL,
CONSTRAINT fk_users_role FOREIGN KEY (role_id) REFERENCES roles(role_id)
);

CREATE TABLE tickets (
ticket_id NUMBER PRIMARY KEY,
title VARCHAR2(200) NOT NULL,
description CLOB NOT NULL,
created_by NUMBER NOT NULL,
assigned_to NUMBER NULL,
status VARCHAR2(20) NOT NULL,
priority VARCHAR2(20) NOT NULL,
created_at DATE DEFAULT SYSDATE NOT NULL,
updated_at DATE DEFAULT SYSDATE NOT NULL,
closed_at DATE NULL,
CONSTRAINT fk_tickets_created_by FOREIGN KEY (created_by) REFERENCES users(user_id),
CONSTRAINT fk_tickets_assigned_to FOREIGN KEY (assigned_to) REFERENCES users(user_id),
CONSTRAINT chk_tickets_status CHECK (status IN ('NEW', 'IN_PROGRESS', 'RESOLVED', 'CLOSED')),
CONSTRAINT chk_tickets_priority CHECK (priority IN ('LOW', 'MEDIUM', 'HIGH'))
);

CREATE TABLE ticket_comments (
comment_id NUMBER PRIMARY KEY,
ticket_id NUMBER NOT NULL,
author_id NUMBER NOT NULL,
comment_text CLOB NOT NULL,
created_at DATE DEFAULT SYSDATE NOT NULL,
CONSTRAINT fk_comments_ticket FOREIGN KEY (ticket_id) REFERENCES tickets(ticket_id),
CONSTRAINT fk_comments_author FOREIGN KEY (author_id) REFERENCES users(user_id)
);

CREATE TABLE ticket_status_history (
history_id NUMBER PRIMARY KEY,
ticket_id NUMBER NOT NULL,
old_status VARCHAR2(20),
new_status VARCHAR2(20) NOT NULL,
changed_by NUMBER NOT NULL,
changed_at DATE DEFAULT SYSDATE NOT NULL,
CONSTRAINT fk_history_ticket FOREIGN KEY (ticket_id) REFERENCES tickets(ticket_id),
CONSTRAINT fk_history_changed_by FOREIGN KEY (changed_by) REFERENCES users(user_id),
CONSTRAINT chk_history_old_status CHECK (old_status IN ('NEW', 'IN_PROGRESS', 'RESOLVED', 'CLOSED') OR old_status IS NULL),
CONSTRAINT chk_history_new_status CHECK (new_status IN ('NEW', 'IN_PROGRESS', 'RESOLVED', 'CLOSED'))
);

CREATE SEQUENCE seq_roles START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_users START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_tickets START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_ticket_comments START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_ticket_status_history START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER trg_roles_bi
BEFORE INSERT ON roles
FOR EACH ROW
BEGIN
IF :NEW.role_id IS NULL THEN
:NEW.role_id := seq_roles.NEXTVAL;
END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_users_bi
BEFORE INSERT ON users
FOR EACH ROW
BEGIN
IF :NEW.user_id IS NULL THEN
:NEW.user_id := seq_users.NEXTVAL;
END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_tickets_bi
BEFORE INSERT ON tickets
FOR EACH ROW
BEGIN
IF :NEW.ticket_id IS NULL THEN
:NEW.ticket_id := seq_tickets.NEXTVAL;
END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_ticket_comments_bi
BEFORE INSERT ON ticket_comments
FOR EACH ROW
BEGIN
IF :NEW.comment_id IS NULL THEN
:NEW.comment_id := seq_ticket_comments.NEXTVAL;
END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_ticket_status_history_bi
BEFORE INSERT ON ticket_status_history
FOR EACH ROW
BEGIN
IF :NEW.history_id IS NULL THEN
:NEW.history_id := seq_ticket_status_history.NEXTVAL;
END IF;
END;
/