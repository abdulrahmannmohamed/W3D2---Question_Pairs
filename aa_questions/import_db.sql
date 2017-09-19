DROP TABLE users;
DROP TABLE questions;
DROP TABLE question_follows;
DROP TABLE question_likes;
DROP TABLE replies;


CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname TEXT NOT NULL,
  lname TEXT NOT NULL
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  author_id INTEGER NOT NULL,

  FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE replies(
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL  ,
  parent_reply_id INTEGER,
  user_id INTEGER NOT NULL,
  body TEXT NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (parent_reply_id) REFERENCES replies(id)
);

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);


INSERT INTO
  users (fname, lname)
VALUES
  ('Abdul', 'Mohamed'),
  ('Glenn', 'Tigas'),
  ('Barack', 'Obama');

INSERT INTO
  questions (title, body, author_id)
VALUES
  ('Why?', 'WHy is the sky blue?', (SELECT id FROM users WHERE fname = 'Glenn')),
  ('Whyyy?', 'WHyyyyy is the sky blue?', (SELECT id FROM users WHERE fname = 'Glenn')),
  ('Chicken', 'Why did the chicken cross the road?', (SELECT id FROM users WHERE fname = 'Abdul')),
  ('Why2?', 'WHy is the sky blue?', (SELECT id FROM users WHERE fname = 'Barack'));

INSERT INTO
  question_follows (question_id, user_id)
VALUES
  ((SELECT id FROM questions WHERE title = 'Why?'), (SELECT id FROM users WHERE fname = 'Abdul')),
  ((SELECT id FROM questions WHERE title = 'Why?'), (SELECT id FROM users WHERE fname = 'Barack')),
  ((SELECT id FROM questions WHERE title = 'Chicken'), (SELECT id FROM users WHERE fname = 'Glenn'));


INSERT INTO
  replies (question_id, parent_reply_id, user_id, body)
VALUES
  ((SELECT id FROM questions WHERE title = 'Why?'), NULL, (SELECT id FROM users WHERE fname = 'Abdul'), 'Wow'),
  ((SELECT id FROM questions WHERE title = 'Why?'), 1, (SELECT id FROM users WHERE fname = 'Abdul'), 'Cool'),
  ((SELECT id FROM questions WHERE title = 'Why?'), 2, (SELECT id FROM users WHERE fname = 'Glenn'), ' :)');

INSERT INTO
  question_likes (question_id, user_id)
VALUES
  ((SELECT id FROM questions WHERE title = 'Why?'), (SELECT id FROM users WHERE fname = 'Abdul')),
  ((SELECT id FROM questions WHERE title = 'Chicken'), (SELECT id FROM users WHERE fname = 'Glenn')),
  ((SELECT id FROM questions WHERE title = 'Why?'), (SELECT id FROM users WHERE fname = 'Barack'));
