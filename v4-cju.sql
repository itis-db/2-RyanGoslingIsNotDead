with cte as (
             select * from author
             where (extract(day from date_of_birth) between 1 and 15) and extract(year from date_of_birth) = 1970 and (extract(month from date_of_birth) between 1 and 6)
             order by date_of_birth)
select cte.first_name, cte.last_name, cte.date_of_birth, b.title
        from cte
join book_author as ba on cte.id = ba.author_id
join book as b on ba.book_id = b.id
union all
select u.first_name, u.last_name, u.date_of_birth, null as title from "user" as u
where (extract(day from date_of_birth) between 1 and 15) and (extract(month from date_of_birth) between 1 and 6);
