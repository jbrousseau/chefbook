begin;

--------------------------------------------
--
-- tables
--
--------------------------------------------

create table chefbook.recipe_category (
  id           serial primary key,
  label        text not null check (char_length(label) < 280),
  lang_id      integer not null references chefbook.lang(id)
);

comment on table chefbook.recipe_category is 'A recipe category.';
comment on column chefbook.recipe_category.id is 'The primary key for the recipe category.';
comment on column chefbook.recipe_category.label is 'The label of the recipe category.';
comment on column chefbook.recipe_category.lang_id is 'lang of the label.';

--------------------------------------------
create table chefbook.recipe (
  id               serial primary key,
  author_id        integer not null references chefbook.person(id),
  title            text not null check (char_length(title) < 280),
  cook_time        integer not null,
  setup_time       integer not null,
  like_count       integer not null default 0,
  score            integer not null default 0,
  category_id      integer not null references chefbook.recipe_category(id),
  created_at       timestamp default now()
);

comment on table chefbook.recipe is 'A recipe written by a user.';
comment on column chefbook.recipe.id is 'The primary key for the recipe.';
comment on column chefbook.recipe.title is 'The title of the recipe written by the user.';
comment on column chefbook.recipe.cook_time is 'Cook time of recipe in minutes.';
comment on column chefbook.recipe.title is 'Setup time of recipe in minutes.';
comment on column chefbook.recipe.like_count is 'number of like of this recipe.';
comment on column chefbook.recipe.score is 'Score of this recipe.';
comment on column chefbook.recipe.author_id is 'The id of the author user.';
comment on column chefbook.recipe.category_id is 'The category id of the recipe.';
comment on column chefbook.recipe.created_at is 'The time this recipe was created.';

alter table chefbook.recipe add column updated_at timestamp default now();

--------------------------------------------
--
-- functions
--
--------------------------------------------


--------------------------------------------
create function chefbook.search_recipe(search text) returns setof chefbook.recipe as $$
  select recipe.*
  from chefbook.recipe as recipe
  where recipe.title ilike ('%' || search || '%')
$$ language sql stable;

comment on function chefbook.search_recipe(text) is 'Returns recipes containing a given search term.';


--------------------------------------------
--
-- triggers
--
--------------------------------------------
create trigger recipe_updated_at before update
  on chefbook.recipe
  for each row
  execute procedure chefbook_admin.set_updated_at();


--------------------------------------------
--
-- grant
--
--------------------------------------------

grant execute on function chefbook.search_recipe(text) to chefbook_anonymous, chefbook_person;


grant select on table chefbook.recipe to chefbook_anonymous, chefbook_person;

grant select on table chefbook.recipe_category to chefbook_anonymous, chefbook_person;

grant insert, update, delete on table chefbook.recipe to chefbook_person;
grant usage on sequence chefbook.recipe_id_seq to chefbook_person;

alter table chefbook.recipe enable row level security;

create policy select_recipe on chefbook.recipe for select
  using (true);
 
create policy insert_recipe on chefbook.recipe for insert to chefbook_person
  with check (author_id = current_setting('jwt.claims.person_id')::integer);

create policy update_recipe on chefbook.recipe for update to chefbook_person
  using (author_id = current_setting('jwt.claims.person_id')::integer);

create policy delete_recipe on chefbook.recipe for delete to chefbook_person
  using (author_id = current_setting('jwt.claims.person_id')::integer);

commit;