begin;

--------------------------------------------
--
-- tables
--
--------------------------------------------

create table chefbook.recipe_step (
  id               serial primary key,
  recipe_id        integer not null references chefbook.recipe(id),
  body             text not null check (char_length(body) < 400)
);


comment on table chefbook.recipe_step is 'step of a recipe';
comment on column chefbook.recipe_step.id is 'The primary key of the step.';
comment on column chefbook.recipe_step.recipe_id is 'The foreign key of the recipe.';
comment on column chefbook.recipe_step.body is 'The step description of the recipe.';

--------------------------------------------
create table chefbook.tag_step (
  id               serial primary key,
  author_id        integer not null references chefbook.person(id),
  ref_id           integer references chefbook.recipe_step(id),
  created_at       timestamp default now()
);



comment on table chefbook.tag_step is 'a modification tag';
comment on column chefbook.tag_step.id is 'The primary key for the tag.';
comment on column chefbook.tag_step.author_id is 'The author of the tag.';
comment on column chefbook.tag_step.ref_id is 'The reference step of the tag.';
comment on column chefbook.tag_step.created_at is 'when the tag was created.';

alter table chefbook.recipe_step add column tag_id integer references chefbook.tag_ingredient(id);
comment on column chefbook.recipe_step.tag_id is 'The modification tag.';

--------------------------------------------
--
-- grant
--
--------------------------------------------

grant select on table chefbook.recipe_step to chefbook_anonymous, chefbook_person;
grant insert, update, delete on table chefbook.recipe_step to chefbook_person;
grant usage on sequence chefbook.recipe_step_id_seq to chefbook_person;

alter table chefbook.recipe_step enable row level security;

create policy select_recipe_step on chefbook.recipe_step for select
  using (true);
 
create policy insert_recipe_step on chefbook.recipe_step for insert to chefbook_person
  with check (exists(select 1 from chefbook.recipe rec where rec.id=recipe_id and rec.author_id=current_setting('jwt.claims.person_id')::integer) );

create policy update_recipe_step on chefbook.recipe_step for update to chefbook_person
  using (exists(select 1 from chefbook.recipe rec where rec.id=recipe_id and rec.author_id=current_setting('jwt.claims.person_id')::integer) );

create policy delete_recipe_step on chefbook.recipe_step for delete to chefbook_person
  using (exists(select 1 from chefbook.recipe rec where rec.id=recipe_id and rec.author_id=current_setting('jwt.claims.person_id')::integer) );

commit;