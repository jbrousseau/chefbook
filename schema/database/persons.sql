begin;

--------------------------------------------
--
-- tables
--
--------------------------------------------
create table chefbook.person (
  id               serial primary key,
  first_name       text not null check (char_length(first_name) < 80),
  last_name        text check (char_length(last_name) < 80),
  about            text,
  lang_id          integer not null references chefbook.lang(id) default 1,
  created_at       timestamp default now()

);

comment on table chefbook.person is 'A user of the chefBook.';
comment on column chefbook.person.id is 'The primary unique identifier for the person.';
comment on column chefbook.person.first_name is 'The person’s first name.';
comment on column chefbook.person.last_name is 'The person’s last name.';
comment on column chefbook.person.about is 'A short description about the user, written by the user.';
comment on column chefbook.person.lang_id is 'The language of the user.';
comment on column chefbook.person.created_at is 'The time this person was created.';


alter table chefbook.person add column updated_at timestamp default now();

--------------------------------------------
create table chefbook_admin.person_account (
  person_id        integer primary key references chefbook.person(id) on delete cascade,
  email            text not null unique check (email ~* '^.+@.+\..+$'),
  password_hash    text not null
);

comment on table chefbook_admin.person_account is 'Private information about a person’s account.';
comment on column chefbook_admin.person_account.person_id is 'The id of the person associated with this account.';
comment on column chefbook_admin.person_account.email is 'The email address of the person.';
comment on column chefbook_admin.person_account.password_hash is 'An opaque hash of the person’s password.';


--------------------------------------------
--
-- functions
--
--------------------------------------------

create function chefbook.person_full_name(person chefbook.person) returns text as $$
  select person.first_name || ' ' || person.last_name
$$ language sql stable;

comment on function chefbook.person_full_name(chefbook.person) is 'A person’s full name which is a concatenation of their first and last name.';


--------------------------------------------
create function chefbook.register_person(
  first_name text,
  last_name text,
  email text,
  password text
) returns chefbook.person as $$
declare
  person chefbook.person;
begin
  insert into chefbook.person (first_name, last_name) values
    (first_name, last_name)
    returning * into person;

  insert into chefbook_admin.person_account (person_id, email, password_hash) values
    (person.id, email, crypt(password, gen_salt('bf')));

  return person;
end;
$$ language plpgsql strict security definer;

comment on function chefbook.register_person(text, text, text, text) is 'Registers a single user and creates an account in our forum.';



--------------------------------------------
--
-- triggers
--
--------------------------------------------
create trigger person_updated_at before update
  on chefbook.person
  for each row
  execute procedure chefbook_admin.set_updated_at();


--------------------------------------------
--
-- grant
--
--------------------------------------------

grant select on table chefbook.person to chefbook_anonymous, chefbook_person;
grant update, delete on table chefbook.person to chefbook_person;


grant execute on function chefbook.person_full_name(chefbook.person) to chefbook_anonymous, chefbook_person;
grant execute on function chefbook.register_person(text, text, text, text) to chefbook_anonymous;

alter table chefbook.person enable row level security;


create policy select_person on chefbook.person for select
  using (true);

create policy update_person on chefbook.person for update to chefbook_person
  using (id = current_setting('jwt.claims.person_id')::integer);

create policy delete_person on chefbook.person for delete to chefbook_person
  using (id = current_setting('jwt.claims.person_id')::integer);




commit;
