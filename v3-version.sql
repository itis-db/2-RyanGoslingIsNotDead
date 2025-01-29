create table author (
	id serial primary key,
	first_name varchar(100) not null,
	last_name varchar(100) not null,
	date_of_birth date,
	date_of_death date,
	biography text
);
create table genre (
	id serial primary key,
	name varchar(255) unique not null,
	description text
);
create table publisher (
	id serial primary key,
	name varchar(100) unique not null,
	adress varchar(255),
	phone_number varchar(20),
	email varchar(255)
);
create table book (
	id serial primary key,
	title varchar(255) not null,
	publication_year integer,
	description text,
	genre_id integer references genre(id),
	publisher_id integer references publisher(id)
);
create table book_author (
	book_id integer references book(id),
	author_id integer references author(id),
	primary key (book_id, author_id)
);
create table book_copy (
	id serial primary key,
	condition text,
	location varchar(255),
	acquisition_date date,
	purchase_price decimal(10, 2),
	book_id integer references book(id)
);
create table "user" (
	id serial primary key,
	first_name varchar(100) not null,
	last_name varchar(100) not null,
	email varchar(255),
	phone varchar(20),
	date_of_birth date,
	password varchar(255)
);
create table "order" (
	id serial primary key,
	order_date timestamp default,
	status varchar(255),
	total_cost decimal(10, 2),
	user_id integer references "user"(id),
	book_copy_id integer references book_copy(id)
);
--v2.sql
ALTER TABLE "user" ADD COLUMN date_time timestamp DEFAULT current_timestamp;
ALTER TABLE "user" ADD CONSTRAINT unique_email UNIQUE (email);
ALTER TABLE "order" ADD COLUMN n integer DEFAULT 0;
ALTER TABLE "order" ALTER COLUMN n TYPE NUMERIC(10, 2) USING n::numeric(10, 2);
ALTER TABLE book ALTER COLUMN description TYPE varchar(100) USING description::varchar(100);
--rollback
ALTER TABLE "user" DROP COLUMN date_time;
ALTER TABLE "user" DROP CONSTRAINT unique_email;
ALTER TABLE "order" DROP COLUMN n;
ALTER TABLE book ALTER COLUMN description TYPE text USING description::text;
