begin;

drop schema if exists chefbook, chefbook_admin cascade;
drop role if exists chefbook_postgraphql, chefbook_anonymous, chefbook_person;

commit;
