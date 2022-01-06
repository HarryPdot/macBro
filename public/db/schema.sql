CREATE DATABASE macBro;
\c macbro

create table macro (
    id serial primary key,
    name text,
    calorie integer,
    protein integer,
    carbs integer,
    fat integer
);

insert into macro (name, calorie, protein, carbs, fat) values ('creamy tuna and pasta','228', '28', '23', '3');

create table users (
    id serial primary key,
    email text,
    password_digest text
);

insert into users(email, password_digest) values ('', '');