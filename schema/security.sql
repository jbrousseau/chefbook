begin;

--------------------------------------------
--
-- tables
--
--------------------------------------------


--------------------------------------------
--
-- types
--
--------------------------------------------

create type chefbook.jwt_token as (
  role text,
  person_id integer
);


--------------------------------------------
--
-- functions
--
--------------------------------------------

create function chefbook.authenticate(
  email text,
  password text
) returns chefbook.jwt_token as $$
declare
  account chefbook_admin.person_account;
begin
  select a.* into account
  from chefbook_admin.person_account as a
  where a.email = $1;

  if account.password_hash = crypt(password, account.password_hash) then
    return ('chefbook_person', account.person_id)::chefbook.jwt_token;
  else
    return null;
  end if;
end;
$$ language plpgsql strict security definer;

comment on function chefbook.authenticate(text, text) is 'Creates a JWT token that will securely identify a person and give them certain permissions.';

--------------------------------------------
create function chefbook.current_person() returns chefbook.person as $$
  select *
  from chefbook.person
  where id = current_setting('jwt.claims.person_id')::integer
$$ language sql stable;

comment on function chefbook.current_person() is 'Gets the person who was identified by our JWT.';


--------------------------------------------
--
-- grant
--
--------------------------------------------

grant execute on function chefbook.authenticate(text, text) to chefbook_anonymous, chefbook_person;
grant execute on function chefbook.current_person() to chefbook_anonymous, chefbook_person;


commit;