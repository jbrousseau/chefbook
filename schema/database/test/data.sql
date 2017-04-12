begin;

insert into chefbook.lang (id, label) values
  (1, 'fr'),
  (2, 'en');

insert into chefbook.person (id, first_name, last_name, about, lang_id, created_at) values
  (1, 'Sara', 'Powell', null, 1, '2015-07-03T14:11:30Z'),
  (2, 'Andrea', 'Fox', null, 1, '1999-04-04T21:21:42Z'),
  (3, 'Stephen', 'Banks', null, 1, '2003-12-09T04:39:10Z'),
  (4, 'Kathy', null, null, 1, '2001-11-03T15:37:15Z'),
  (5, 'Kenneth', 'Williams', null, 1, '2002-08-16T19:03:47Z'),
  (6, 'Ann', 'Peterson', null, 1, '2013-09-24T15:05:29Z'),
  (7, 'Gloria', 'Lee', 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo.', 1, '2007-04-23T12:56:09Z'),
  (8, 'Douglas', null, null, 1, '2008-07-10T21:49:16Z'),
  (9, 'Jeffrey', 'Palmer', null, 1, '2000-07-28T22:33:20Z'),
  (10, 'Robert', 'Fisher', 'Suspendisse potenti. Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', 1, '2000-06-12T09:11:56Z');

alter sequence chefbook.person_id_seq restart with 11;

insert into chefbook_admin.person_account (person_id, email, password_hash) values
  (1, 'spowell0@noaa.gov', '$2a$06$.Ryt.S6xCN./QmTx3r9Meu/nsk.4Ypfuj.o9qIqv4p3iipCWY45Bi'), -- Password: 'iFbWWlc'
  (2, 'afox1@npr.org', '$2a$06$FS4C7kwDs6tSrrjh0TITLuQ/pAjUHuCH0TBukHC.2m5n.Z1HxApRO'), -- Password: 'fjHtKk2FxCh0'
  (3, 'sbanks2@blog.com', '$2a$06$i7AoCg3pbAOmf8J2w/lGpukUfDuRdfyUrR/mN7I0x.AYZb3Ak6DYS'), -- Password: '3RLdPN9'
  (4, 'kaustin3@nyu.edu', '$2a$06$YJJ.vNqGcrKcX4ZtPl1nG.crDhCCoA6t5tWXkAokvprG4nytdWNli'), -- Password: 'jQZ8mYjUNH'
  (5, 'kwilliams4@paypal.com', '$2a$06$Mx2dB7Y1yfL7WhCg0JHNLetBeIgsOqxRbKBOPc1Kv66lYEfbPghzi'), -- Password: '3Uostu'
  (6, 'apeterson5@webnode.com', '$2a$06$wCdceaTUqf9fxp/j6hswk.pWp9aY7N2HMQeNKb2TJZMUm.i8IZ.3G'), -- Password: 'u2TZDkfHSm'
  (7, 'glee6@arizona.edu', '$2a$06$WQiZeChX8yUR14DAshXKd.W6cwz0tsvf49IaNhmM65FkFJVr8GEgW'), -- Password: 'VEHWMCcfuMJ'
  (8, 'drodriguez7@mashable.com', '$2a$06$8Wa.RA33V4MrCIKQ1rAJIu7HMJSLjTZLcZY1zrlU4fZrJOIVFtvQS'), -- Password: 'TEYkGd'
  (9, 'jpalmer8@washingtonpost.com', '$2a$06$q3H4ngUMZ9ADz3utyzGRX.6pWrzmPurqEjKtm7qzbYJrmSEYrsYvu'), -- Password: 'yYh7KDQ2'
  (10, 'rfisher9@nytimes.com', '$2a$06$lvLbqB8u.BVnqa8Zmy5E0.1LgSyKJkBnRYztVu3gO.hE6kCIsx2YK'); -- Password: 'tAVD3Yvi2'
  
  
insert into chefbook.ingredient (id, label, lang_id) values
  (1, 'oeuf', 1),
  (2, 'litre de lait', 1),
  (3, 'gramme de farine', 1);
  
alter sequence chefbook.ingredient_id_seq restart with 4;

insert into chefbook.recipe_category (id, label, lang_id) values
  (1, 'Entrée', 1),
  (2, 'Plat principal', 1),
  (3, 'Dessert', 1);
    
insert into chefbook.recipe (id, author_id, title, cook_time, setup_time, like_count, score, category_id, created_at) values
  (1, 1, 'Recette de pate à crêpe', 4, 10, 5, 3, 2, '2013-09-24T15:05:29Z'),
  (2, 1, 'Tomate farcie', 4, 10, 5, 3, 2, '2013-09-24T15:05:29Z');

alter sequence chefbook.recipe_id_seq restart with 3;

insert into chefbook.recipe_comment (id, author_id, headline, body, recipe_id, lang_id, reply_id, created_at) values
  (1, 1, 'Ameliorated optimal emulation', E'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.\n\nCurabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.\n\nPhasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.\n\nProin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.\n\nDuis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.\n\nDonec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.\n\nDuis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.\n\nIn sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.\n\nSuspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.\n\nMaecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.\n\nCurabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.\n\nInteger tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.\n\nPraesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.\n\nMorbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.\n\nFusce consequat. Nulla nisl. Nunc nisl.', 1, 1, null, '2011-06-01T09:27:57Z'),
  (2, 6, 'Open-source non-volatile protocol', E'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.\n\nNulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.\n\nCras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.\n\nQuisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.\n\nPhasellus in felis. Donec semper sapien a libero. Nam dui.\n\nProin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.', 2, 1, null, '2001-02-18T16:35:03Z'),
  (3, 1, 'Decentralized tangible circuit', E'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.\n\nNullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.\n\nMorbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.\n\nFusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.\n\nSed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.\n\nPellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.\n\nCum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.\n\nEtiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.\n\nPraesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.\n\nCras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', 1, 2, null, '2006-10-08T01:42:03Z');
insert into chefbook.recipe_comment (id, author_id, headline, body, recipe_id, lang_id, reply_id, created_at) values
  (4, 1, 'tatat', E'qsdfqsdfqsdf qsdf dqsf qsdf qfs dq dfqsf qsdf qsdf qdsqf ae ipsum. ', 1, 2, 3, '2006-10-08T01:42:03Z');

alter sequence chefbook.recipe_comment_id_seq restart with 31;

commit;
