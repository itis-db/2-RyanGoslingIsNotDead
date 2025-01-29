WITH RECURSIVE author_generator AS (
    SELECT 1 AS id,
           'FirstName1' AS first_name,
           'LastName1' AS last_name,
           '1970-01-01'::date AS date_of_birth,
           NULL::date AS date_of_death,
           'Biography for Author 1' AS biography
    UNION ALL
    SELECT id + 1,
           'FirstName' || (id + 1),
           'LastName' || (id + 1),
           ('1970-01-01'::date + (id + 1) * interval '1 day')::date,
           NULL::date,
           'Biography for Author ' || (id + 1)
    FROM author_generator
    WHERE id < 500
)
INSERT INTO author (id, first_name, last_name, date_of_birth, date_of_death, biography)
SELECT id, first_name, last_name, date_of_birth, date_of_death, biography
FROM author_generator;
WITH RECURSIVE genre_generator AS (
    SELECT 1 AS id,
           'Genre1' AS name,
           'Description for Genre 1' AS description
    UNION ALL
    SELECT id + 1,
           'Genre' || (id + 1),
           'Description for Genre ' || (id + 1)
    FROM genre_generator
    WHERE id < 500
)
INSERT INTO genre (id, name, description)
SELECT id, name, description
FROM genre_generator;
WITH RECURSIVE publisher_generator AS (
    SELECT 1 AS id,
           'Publisher1' AS name,
           'Address 1' AS adress,
           '1234567890' AS phone_number,
           'publisher1@example.com' AS email
    UNION ALL
    SELECT id + 1,
           'Publisher' || (id + 1),
           'Address ' || (id + 1),
           '123456' || LPAD(id::text, 4, '0'),
           'publisher' || (id + 1) || '@example.com'
    FROM publisher_generator
    WHERE id < 500
)
INSERT INTO publisher (id, name, adress, phone_number, email)
SELECT id, name, adress, phone_number, email
FROM publisher_generator;
WITH RECURSIVE book_generator AS (
    SELECT 1 AS id,
           'BookTitle1' AS title,
           2000 AS publication_year,
           'Description for Book 1' AS description,
           1 AS genre_id,
           1 AS publisher_id
    UNION ALL
    SELECT id + 1,
           'BookTitle' || (id + 1),
           2000 + (id % 20),
           'Description for Book ' || (id + 1),
           (id % 500) + 1,
           (id % 500) + 1
    FROM book_generator
    WHERE id < 500
)
INSERT INTO book (id, title, publication_year, description, genre_id, publisher_id)
SELECT id, title, publication_year, description, genre_id, publisher_id
FROM book_generator;
WITH RECURSIVE book_author_generator AS (
    SELECT 1 AS book_id, 1 AS author_id
    UNION ALL
    SELECT book_id + 1,
           (author_id % 500) + 1
    FROM book_author_generator
    WHERE book_id < 500
)
INSERT INTO book_author (book_id, author_id)
SELECT book_id, author_id
FROM book_author_generator;
WITH RECURSIVE book_copy_generator AS (
    SELECT 1 AS id,
           'New' AS condition,
           'Location 1' AS location,
           '2024-01-01'::date AS acquisition_date,
           10.00 AS purchase_price,
           1 AS book_id
    UNION ALL
    SELECT id + 1,
           'Condition ' || (id % 3),
           'Location ' || (id % 10),
           ('2024-01-01'::date + (id * interval '1 day'))::date,
           10.00 + (id % 100) * 0.5,
           (id % 500) + 1
    FROM book_copy_generator
    WHERE id < 500
)
INSERT INTO book_copy (id, condition, location, acquisition_date, purchase_price, book_id)
SELECT id, condition, location, acquisition_date, purchase_price, book_id
FROM book_copy_generator;
WITH RECURSIVE user_generator AS (
    SELECT 1 AS id,
           'FirstName1' AS first_name,
           'LastName1' AS last_name,
           'user1@example.com' AS email,
           '1234567890' AS phone,
           '1980-01-01'::date AS date_of_birth,
           'password1' AS password
    UNION ALL
    SELECT id + 1,
           'FirstName' || (id + 1),
           'LastName' || (id + 1),
           'user' || (id + 1) || '@example.com',
           '123456' || LPAD(id::text, 4, '0'),
           ('1980-01-01'::date + (id * interval '1 day'))::date,
           'password' || (id + 1)
    FROM user_generator
    WHERE id < 500
)
INSERT INTO "user" (id, first_name, last_name, email, phone, date_of_birth, password)
SELECT id, first_name, last_name, email, phone, date_of_birth, password
FROM user_generator;

WITH RECURSIVE order_generator AS (
    SELECT 1 AS id,
           NOW() AS order_date,
           'Pending' AS status,
           100.00 AS total_cost,
           1 AS user_id,
           1 AS book_copy_id
    UNION ALL
    SELECT id + 1,
           NOW() + (id * interval '1 hour'),
           CASE WHEN (id % 3) = 0 THEN 'Shipped' ELSE 'Pending' END,
           100.00 + (id % 50),
           (user_id % 500) + 1,
           (book_copy_id % 500) + 1
    FROM order_generator
    WHERE id < 500
)
INSERT INTO "order" (id, order_date, status, total_cost, user_id, book_copy_id)
SELECT id, order_date, status, total_cost, user_id, book_copy_id
FROM order_generator;

