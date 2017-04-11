begin;

--------------------------------------------
--
-- tables
--
--------------------------------------------

create table chefbook.lang (
  id               serial primary key,
  label            text not null check (char_length(label) < 280)
);

comment on table chefbook.lang is 'A language.';
comment on column chefbook.lang.label is 'The label of the language.';

--------------------------------------------
--
-- grant
--
--------------------------------------------

grant select on table chefbook.lang to chefbook_anonymous, chefbook_person;


commit;