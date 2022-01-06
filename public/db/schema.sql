CREATE DATABASE macBro;

create table macBro (
    id serial primary key,

)

insert into macBro () values ('','');

create table users (
    id serial primary key,
    email text,
    password_digest text
);

insert into users(email, password_digest) values ('', '');