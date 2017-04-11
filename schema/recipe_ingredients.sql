begin;

--------------------------------------------
--
-- tables
--
--------------------------------------------


create table chefbook.recipe_ingredient (
  id               serial primary key,
  ingredient_id    integer not null references chefbook.ingredient(id),
  recipe_id        integer not null references chefbook.recipe(id),
  quantity         float not null
);


comment on table chefbook.recipe_ingredient is 'ingredient in a recipe';
comment on column chefbook.recipe_ingredient.recipe_id is 'The foreign key for the recipe.';
comment on column chefbook.recipe_ingredient.quantity is 'The ingredient quantity.';


--------------------------------------------
create table chefbook.tag_ingredient (
  id               serial primary key,
  author_id        integer not null references chefbook.person(id),
  ref_id           integer references chefbook.recipe_ingredient(id),
  created_at       timestamp default now()
);

comment on table chefbook.tag_ingredient is 'a modification tag';
comment on column chefbook.tag_ingredient.id is 'The primary key for the tag.';
comment on column chefbook.tag_ingredient.author_id is 'The author of the tag.';
comment on column chefbook.tag_ingredient.ref_id is 'The reference ingredient of the tag modification.';
comment on column chefbook.tag_ingredient.created_at is 'when the tag was created.';


alter table chefbook.recipe_ingredient add column tag_id integer references chefbook.tag_ingredient(id);
comment on column chefbook.recipe_ingredient.tag_id is 'The modification tag.';

--------------------------------------------
--
-- grant
--
--------------------------------------------

grant select on table chefbook.recipe_ingredient to chefbook_anonymous, chefbook_person;
grant insert, update, delete on table chefbook.recipe_ingredient to chefbook_person;
grant usage on sequence chefbook.recipe_ingredient_id_seq to chefbook_person;

alter table chefbook.recipe_ingredient enable row level security;

create policy select_recipe_ingredient on chefbook.recipe_ingredient for select
  using (true);
 
create policy insert_recipe_ingredient on chefbook.recipe_ingredient for insert to chefbook_person
  with check (exists(select 1 from chefbook.recipe rec where rec.id=recipe_id and rec.author_id=current_setting('jwt.claims.person_id')::integer) );

create policy update_recipe_ingredient on chefbook.recipe_ingredient for update to chefbook_person
  using (exists(select 1 from chefbook.recipe rec where rec.id=recipe_id and rec.author_id=current_setting('jwt.claims.person_id')::integer) );

create policy delete_recipe_ingredient on chefbook.recipe_ingredient for delete to chefbook_person
  using (exists(select 1 from chefbook.recipe rec where rec.id=recipe_id and rec.author_id=current_setting('jwt.claims.person_id')::integer) );

commit;