ALTER TABLE author ALTER COLUMN date_of_birth SET NOT NULL;
ALTER TABLE book ALTER COLUMN publication_year SET NOT NULL;
ALTER TABLE book ADD UNIQUE (title);
ALTER TABLE "order" ALTER COLUMN order_date SET NOT NULL;
ALTER TABLE "user" ALTER COLUMN email SET NOT NULL;
ALTER TABLE "user" ADD UNIQUE (email);
ALTER TABLE book_copy ALTER COLUMN location SET NOT NULL;
ALTER TABLE book_copy ALTER COLUMN acquisition_date SET NOT NULL;




--control work
ALTER TABLE book ADD COLUMN genre_name VARCHAR(255) UNIQUE ;
UPDATE book SET genre_name = (SELECT name FROM genre AS g WHERE g.id = book.genre_id);
ALTER TABLE book DROP COLUMN genre_id;

ALTER TABLE genre DROP COLUMN id;
ALTER TABLE genre ADD PRIMARY KEY (name);

ALTER TABLE book ADD CONSTRAINT genre_fkey FOREIGN KEY (genre_name) REFERENCES genre(name);



ALTER TABLE book ADD COLUMN publisher_name VARCHAR(100) UNIQUE;
UPDATE book SET publisher_name = (SELECT name FROM publisher AS p WHERE p.id = book.publisher_id);
ALTER TABLE book DROP COLUMN publisher_id;

ALTER TABLE publisher DROP COLUMN id;
ALTER TABLE publisher ADD PRIMARY KEY (name);

ALTER TABLE book ADD CONSTRAINT publisher_fkey FOREIGN KEY (publisher_name) REFERENCES publisher(name);



ALTER TABLE book_author ADD COLUMN book_title VARCHAR(255) UNIQUE;
UPDATE book_author SET book_title = (SELECT title FROM book AS b WHERE b.id = book_author.book_id);
ALTER TABLE book_author DROP COLUMN book_id;

ALTER TABLE book_copy ADD COLUMN book_title VARCHAR(255) UNIQUE;
UPDATE book_copy SET book_title = (SELECT title FROM book AS b WHERE b.id = book_copy.book_id);
ALTER TABLE book_copy DROP COLUMN book_id;

ALTER TABLE book DROP COLUMN id;
ALTER TABLE book ADD PRIMARY KEY (title);

ALTER TABLE book_author ADD CONSTRAINT book_fkey FOREIGN KEY (book_title) REFERENCES book(title);
ALTER TABLE book_copy ADD CONSTRAINT book_fkey FOREIGN KEY (book_title) REFERENCES book(title);



ALTER TABLE "Order" ADD COLUMN book_copy_location VARCHAR(255);
ALTER TABLE "Order" ADD COLUMN book_title VARCHAR(255) UNIQUE;
UPDATE "Order" SET book_copy_location = (SELECT location FROM book_copy AS b_c WHERE b_c.id = "Order".book_copy_id);
UPDATE "Order" SET book_title = (SELECT book_title FROM book_copy AS b_c WHERE b_c.id = "Order".book_copy_id);
ALTER TABLE "Order" DROP COLUMN book_copy_id;

ALTER TABLE book_copy DROP COLUMN id;
ALTER TABLE book_copy ADD PRIMARY KEY (location, book_title);

ALTER TABLE "Order" ADD CONSTRAINT book_copy_fkey FOREIGN KEY (book_copy_location, book_title) REFERENCES bookcopy(location, book_title);



ALTER TABLE book_author ADD COLUMN author_first_name VARCHAR(100);
ALTER TABLE book_author ADD COLUMN author_last_name VARCHAR(100);
ALTER TABLE book_author ADD COLUMN author_date_of_birth DATE;

UPDATE book_author SET author_first_name = (SELECT first_name FROM author AS a WHERE a.id = book_author.author_id);
UPDATE book_author SET author_last_name = (SELECT last_name FROM author AS a WHERE a.id = book_author.author_id);
UPDATE book_author SET author_date_of_birth = (SELECT date_of_birth FROM author AS a WHERE a.id = book_author.author_id);

ALTER TABLE book_author DROP COLUMN author_id;

ALTER TABLE author DROP COLUMN id;
ALTER TABLE author ADD PRIMARY KEY (first_name, last_name, date_of_birth);

ALTER TABLE book_author ADD CONSTRAINT author_fkey FOREIGN KEY (author_first_name, author_last_name, author_date_of_birth) REFERENCES author(first_name, last_name, date_of_birth);



ALTER TABLE "order" ADD COLUMN user_email VARCHAR(255) UNIQUE;
UPDATE "order" SET user_email = (SELECT email FROM "user" AS u WHERE u.id = "order".user_id);
ALTER TABLE "order" DROP COLUMN user_id;

ALTER TABLE "user" DROP COLUMN id;
ALTER TABLE "user" ADD PRIMARY KEY (email);

ALTER TABLE "order" ADD CONSTRAINT user_fkey FOREIGN KEY (user_email) REFERENCES "user"(email);



ALTER TABLE "order" DROP COLUMN id;
ALTER TABLE "order" ADD PRIMARY KEY (order_date, user_email, book_title);








--rollback
ALTER TABLE genre ADD COLUMN id SERIAL;

ALTER TABLE book ADD COLUMN genre_id INTEGER;
UPDATE book SET genre_id = (SELECT id FROM genre AS g WHERE g.name = book.genre_name);
ALTER TABLE book DROP COLUMN genre_name;

ALTER TABLE genre DROP CONSTRAINT genre_pkey;
ALTER TABLE genre ADD PRIMARY KEY (id);

ALTER TABLE book ADD CONSTRAINT genre_fkey FOREIGN KEY (genre_id) REFERENCES genre(id);



ALTER TABLE publisher ADD COLUMN id SERIAL;

ALTER TABLE book ADD COLUMN publisher_id INTEGER;
UPDATE book SET publisher_id = (SELECT id FROM publisher AS p WHERE p.name = book.publisher_name);
ALTER TABLE book DROP COLUMN publisher_name;

ALTER TABLE publisher DROP CONSTRAINT publisher_pkey;
ALTER TABLE publisher ADD PRIMARY KEY (id);

ALTER TABLE book ADD CONSTRAINT publisher_fkey FOREIGN KEY (publisher_id) REFERENCES publisher(id);


ALTER TABLE book_copy ADD COLUMN id SERIAL;

ALTER TABLE "order" ADD COLUMN book_copy_id INTEGER;
UPDATE "order" SET book_copy_id = (SELECT id FROM book_copy AS b_c WHERE b_c.location = "order".book_copy_location AND b_c.book_title = "order".book_title);
ALTER TABLE "order" DROP COLUMN book_copy_location;
ALTER TABLE "order" DROP COLUMN book_title;

ALTER TABLE book_copy DROP CONSTRAINT book_copy_pkey;
ALTER TABLE book_copy ADD PRIMARY KEY (id);

ALTER TABLE "order" ADD CONSTRAINT book_copy_fkey FOREIGN KEY (book_copy_id) REFERENCES book_copy(id);



ALTER TABLE book ADD COLUMN id SERIAL;

ALTER TABLE book_author ADD COLUMN book_id INTEGER;
UPDATE book_author SET book_id = (SELECT id FROM book AS b WHERE b.title = book_author.book_title);
ALTER TABLE book_author DROP COLUMN book_title;

ALTER TABLE book_copy ADD COLUMN book_id INTEGER;
UPDATE book_copy SET book_id = (SELECT id FROM book AS b WHERE b.title = book_copy.book_title);
ALTER TABLE book_copy DROP COLUMN book_title;

ALTER TABLE book DROP CONSTRAINT book_pkey;
ALTER TABLE book ADD PRIMARY KEY (id);

ALTER TABLE book_author ADD CONSTRAINT book_fkey FOREIGN KEY (book_id) REFERENCES book(id);
ALTER TABLE book_copy ADD CONSTRAINT book_fkey FOREIGN KEY (book_id) REFERENCES book(id);



ALTER TABLE author ADD COLUMN id SERIAL;

ALTER TABLE book_author ADD COLUMN author_id INTEGER;
UPDATE book_author SET author_id = (SELECT id FROM author AS a WHERE a.first_name = book_author.author_first_name and a.last_name = book_author.author_last_name and a.date_of_birth = book_author.author_date_of_birth);
ALTER TABLE book_author DROP COLUMN author_first_name;
ALTER TABLE book_author DROP COLUMN author_last_name;
ALTER TABLE book_author DROP COLUMN author_date_of_birth;

ALTER TABLE author DROP CONSTRAINT author_pkey;
ALTER TABLE author ADD PRIMARY KEY (id);

ALTER TABLE book_author ADD CONSTRAINT author_fkey FOREIGN KEY (author_id) REFERENCES author(id);



ALTER TABLE "user" ADD COLUMN id SERIAL;

ALTER TABLE "order" ADD COLUMN user_id INTEGER;
UPDATE "order" SET user_id = (SELECT id FROM "user" AS u WHERE u.email = "order".user_email);
ALTER TABLE "order" DROP COLUMN user_email;

ALTER TABLE "user" DROP CONSTRAINT "user_pkey";
ALTER TABLE "user" ADD PRIMARY KEY (id);

ALTER TABLE "order" ADD CONSTRAINT user_fkey FOREIGN KEY (user_id) REFERENCES "user"(id);


ALTER TABLE "order" ADD COLUMN id SERIAL;

ALTER TABLE "order" DROP CONSTRAINT "order_pkey";
ALTER TABLE "order" ADD PRIMARY KEY (id);
