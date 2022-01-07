CREATE DATABASE macBro;
\c macbro

create table macro (
    id serial primary key,
    name text,
    calorie integer,
    protein integer,
    carbs integer,
    fat integer,
    dish_img text,
    recipe text,
    user_id integer
);

insert into macro (name, calorie, protein, carbs, fat) values ('creamy tuna and pasta','228', '28', '23', '3');
insert into macro (name, calorie, protein, carbs, fat, dish_img, recipe) values ('Pasta With Tuna','420', '24', '57', '10','https://placekitten.com/640/360', 'http://www.foodista.com/recipe/K6QWSKQM/pasta-with-tuna');

create table users (
    id serial primary key,
    email text,
    password_digest text
);

insert into users(email, password_digest) values ('test@ga.co', 'test');

alter table macro add user_id integer; 