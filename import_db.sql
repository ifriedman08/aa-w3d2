DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(20) NOT NULL,
  lname VARCHAR(20) NOT NULL
);

DROP TABLE IF EXISTS questions;

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(25),
  body TEXT,
  user_id SMALLINT NOT NULL
);

DROP TABLE IF EXISTS question_follows;

CREATE TABLE question_follows(
  id INTEGER PRIMARY KEY,
  question_id SMALLINT NOT NULL,
  user_id SMALLINT NOT NULL
);

DROP TABLE IF EXISTS replies;

CREATE TABLE replies(
  id INTEGER PRIMARY KEY,
  question_id SMALLINT NOT NULL,
  parent_reply_id SMALLINT,
  user_id SMALLINT NOT NULL,
  body TEXT NOT NULL
);

DROP TABLE IF EXISTS question_likes;

CREATE TABLE question_likes(
  id INTEGER PRIMARY KEY,
  question_id SMALLINT NOT NULL,
  user_id SMALLINT NOT NULL
);

INSERT INTO users (fname, lname)
VALUES ( 'Jon', 'Snow');
INSERT INTO users (fname, lname)
VALUES ( 'Ned', 'Stark');
INSERT INTO users (fname, lname)
VALUES ( 'Kat', 'Tully');

INSERT INTO questions (title, body, user_id)
VALUES ( 'Where are the dragons?', 'They should be here by now.', 2);
INSERT INTO questions (title, body, user_id)
VALUES ( "Who is John's mom?", "Shouldn't they tell us?", 1);
INSERT INTO replies (question_id, parent_reply_id, user_id, body)
VALUES ( 1, NULL, 3, "Why would you ask about dragons?");
INSERT INTO replies (question_id, parent_reply_id, user_id, body)
VALUES ( 1, 1, 2, "I'm not sure about this.");

INSERT INTO questions (title, body, user_id)
VALUES ( 'Lame question3', '...', 3);
INSERT INTO questions (title, body, user_id)
VALUES ( 'Lame question4', '...', 3);
INSERT INTO questions (title, body, user_id)
VALUES ( 'Lame question5', '...', 3);


INSERT INTO question_likes (question_id,  user_id)
VALUES (3, 3);
INSERT INTO question_likes (question_id,  user_id)
VALUES (3, 2);

INSERT INTO question_likes (question_id,  user_id)
VALUES (2, 1);
INSERT INTO question_likes (question_id,  user_id)
VALUES (2, 2);
INSERT INTO question_likes (question_id,  user_id)
VALUES (2, 3);

INSERT INTO question_likes (question_id,  user_id)
VALUES (1, 3);

INSERT INTO question_follows (question_id, user_id)
VALUES(2,3);
INSERT INTO question_follows (question_id, user_id)
VALUES(1,1);
INSERT INTO question_follows (question_id, user_id)
VALUES(1,2);
INSERT INTO question_follows (question_id, user_id)
VALUES(1,3);
