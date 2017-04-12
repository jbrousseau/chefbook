begin;

--------------------------------------------
--
-- schemas
--
--------------------------------------------
create schema chefbook;
create schema chefbook_admin;

--------------------------------------------
--
-- extensions
--
--------------------------------------------
create extension if not exists "pgcrypto";


--------------------------------------------
--
-- roles
--
--------------------------------------------
create role chefbook_postgraphql login password 'CHANGE_THAT_IN_PRODUCTION;';

create role chefbook_anonymous;
grant chefbook_anonymous to chefbook_postgraphql;

create role chefbook_person;
grant chefbook_person to chefbook_postgraphql;


grant usage on schema chefbook to chefbook_anonymous, chefbook_person;

--------------------------------------------
--
-- generic functions
--
--------------------------------------------
create function chefbook_admin.set_updated_at() returns trigger as $$
begin
  new.updated_at := current_timestamp;
  return new;
end;
$$ language plpgsql;



commit;

