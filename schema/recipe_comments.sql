begin;

--------------------------------------------
--
-- tables
--
--------------------------------------------

create table chefbook.recipe_comment (
  id               serial primary key,
  author_id        integer not null references chefbook.person(id),
  headline         text not null check (char_length(headline) < 280),
  body             text,
  recipe_id        integer not null references chefbook.recipe(id),
  lang_id          integer not null references chefbook.lang(id),
  reply_id         integer references chefbook.recipe_comment(id),
  created_at       timestamp default now()
);

comment on table chefbook.recipe_comment is 'A comment of a recipe written by a user.';
comment on column chefbook.recipe_comment.id is 'The primary key for the comment.';
comment on column chefbook.recipe_comment.headline is 'The title written by the user.';
comment on column chefbook.recipe_comment.author_id is 'The id of the author user.';
comment on column chefbook.recipe_comment.body is 'The main body text of our post.';
comment on column chefbook.recipe_comment.recipe_id is 'The foreign key of the recipe of the comment.';
comment on column chefbook.recipe_comment.lang_id is 'The language of the comment.';
comment on column chefbook.recipe_comment.reply_id is 'The comment reply id (foreign key).';
comment on column chefbook.recipe_comment.created_at is 'The time this post was created.';


alter table chefbook.recipe_comment add column updated_at timestamp default now();

--------------------------------------------
--
-- functions
--
--------------------------------------------


--------------------------------------------
create function chefbook.recipe_comment_summary(
  recipe_comment chefbook.recipe_comment,
  length int default 50,
  omission text default '…'
) returns text as $$
  select case
    when recipe_comment.body is null then null
    else substr(recipe_comment.body, 0, length) || omission
  end
$$ language sql stable;

comment on function chefbook.recipe_comment_summary(chefbook.recipe_comment, int, text) is 'A truncated version of the body for summaries.';

--------------------------------------------
create function chefbook.person_latest_recipe_comment(person chefbook.person) returns chefbook.recipe_comment as $$
  select recipe_comment.*
  from chefbook.recipe_comment as recipe_comment
  where recipe_comment.author_id = person.id
  order by created_at desc
  limit 1
$$ language sql stable;

comment on function chefbook.person_latest_recipe_comment(person chefbook.person) is 'Get’s the latest comment written by the person.';

--------------------------------------------
create function chefbook.search_recipe_comments(search text) returns setof chefbook.recipe_comment as $$
  select recipe_comment.*
  from chefbook.recipe_comment as recipe_comment
  where recipe_comment.headline ilike ('%' || search || '%') or recipe_comment.body ilike ('%' || search || '%')
$$ language sql stable;

comment on function chefbook.search_recipe_comments(text) is 'Returns comments containing a given search term.';



--------------------------------------------
--
-- triggers
--
--------------------------------------------
create trigger recipe_comment_updated_at before update
  on chefbook.recipe_comment
  for each row
  execute procedure chefbook_admin.set_updated_at();



--------------------------------------------
--
-- grant
--
--------------------------------------------

grant execute on function chefbook.recipe_comment_summary(chefbook.recipe_comment, integer, text) to chefbook_anonymous, chefbook_person;
grant execute on function chefbook.person_latest_recipe_comment(chefbook.person) to chefbook_anonymous, chefbook_person;
grant execute on function chefbook.search_recipe_comments(text) to chefbook_anonymous, chefbook_person;


grant select on table chefbook.recipe_comment to chefbook_anonymous, chefbook_person;
grant insert, update, delete on table chefbook.recipe_comment to chefbook_person;
grant usage on sequence chefbook.recipe_comment_id_seq to chefbook_person;

alter table chefbook.recipe_comment enable row level security;

create policy select_recipe_comment on chefbook.recipe_comment for select
  using (true);
 
create policy insert_recipe_comment on chefbook.recipe_comment for insert to chefbook_person
  with check (author_id = current_setting('jwt.claims.person_id')::integer);

create policy update_recipe_comment on chefbook.recipe_comment for update to chefbook_person
  using (author_id = current_setting('jwt.claims.person_id')::integer);

create policy delete_recipe_comment on chefbook.recipe_comment for delete to chefbook_person
  using (author_id = current_setting('jwt.claims.person_id')::integer);
  
  
commit;


