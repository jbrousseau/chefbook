begin;

--------------------------------------------
--
-- tables
--
--------------------------------------------

create table chefbook.ingredient (
  id               serial primary key,
  label            text check (char_length(label) < 80),
  lang_id          integer not null references chefbook.lang(id)
);

comment on table chefbook.ingredient is 'ingredient in a recipe';
comment on column chefbook.ingredient.id is 'The primary key for the ingredient.';
comment on column chefbook.ingredient.label is 'The ingredient label.';
comment on column chefbook.ingredient.lang_id is 'The ingredient language.';

--------------------------------------------
--
-- grant
--
--------------------------------------------

grant select on table chefbook.ingredient to chefbook_anonymous, chefbook_person;
grant usage on sequence chefbook.ingredient_id_seq to chefbook_person;

commit;