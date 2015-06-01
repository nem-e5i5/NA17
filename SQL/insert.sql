BEGIN TRANSACTION;

INSERT INTO TUSER (login, firstname, lastname, aPassword) VALUES ('nf17001','Taha','ARBAOUI','12345678');
INSERT INTO TUSER (login, firstname, lastname, aPassword) VALUES ('nf17002','Celia','TOULZA','12345678');
INSERT INTO TUSER (login, firstname, lastname, aPassword) VALUES ('nf17003','Alexandre','THOUVENIN','12345678');
INSERT INTO TUSER (login, firstname, lastname, aPassword) VALUES ('nf17004','Baptiste','MONTANGE','12345678');
INSERT INTO TUSER (login, firstname, lastname, aPassword) VALUES ('nf17005','Simei','YIN','12345678');
INSERT INTO TUSER (login, firstname, lastname, aPassword) VALUES ('nf17006','aaa','AAA','12345678');
INSERT INTO TUSER (login, firstname, lastname, aPassword) VALUES ('nf17007','bbb','BBB','12345678');
INSERT INTO TUSER (login, firstname, lastname, aPassword) VALUES ('nf17008','ccc','CCC','12345678');
INSERT INTO TUSER (login, firstname, lastname, aPassword) VALUES ('nf17009','ddd','DDD','12345678');
INSERT INTO TUSER (login, firstname, lastname, aPassword) VALUES ('nf17010','eee','EEE','12345678');

INSERT INTO DROIT_USER (login, droit) VALUES ('nf17001','administrateur');
INSERT INTO DROIT_USER (login, droit) VALUES ('nf17001','auteur');
INSERT INTO DROIT_USER (login, droit) VALUES ('nf17001','editeur');
INSERT INTO DROIT_USER (login, droit) VALUES ('nf17001','moderateur');
INSERT INTO DROIT_USER (login, droit) VALUES ('nf17001','lecteur');


INSERT INTO DROIT_USER (login, droit) VALUES ('nf17002','auteur');
INSERT INTO DROIT_USER (login, droit) VALUES ('nf17002','lecteur');
INSERT INTO DROIT_USER (login, droit) VALUES ('nf17003','editeur');
INSERT INTO DROIT_USER (login, droit) VALUES ('nf17003','lecteur');
INSERT INTO DROIT_USER (login, droit) VALUES ('nf17004','moderateur');
INSERT INTO DROIT_USER (login, droit) VALUES ('nf17004','lecteur');
INSERT INTO DROIT_USER (login, droit) VALUES ('nf17005','auteur');
INSERT INTO DROIT_USER (login, droit) VALUES ('nf17005','administrateur');
INSERT INTO DROIT_USER (login, droit) VALUES ('nf17006','editeur');
INSERT INTO DROIT_USER (login, droit) VALUES ('nf17007','moderateur');
INSERT INTO DROIT_USER (login, droit) VALUES ('nf17007','lecteur');
INSERT INTO DROIT_USER (login, droit) VALUES ('nf17008','auteur');
INSERT INTO DROIT_USER (login, droit) VALUES ('nf17008','moderateur');
INSERT INTO DROIT_USER (login, droit) VALUES ('nf17009','lecteur');
INSERT INTO DROIT_USER (login, droit) VALUES ('nf17010','moderateur');

INSERT INTO RUBRIQUE (title, mother, creator, aDate) VALUES ('CULTURE', NULL, 'nf17001', '2015-05-24 18:40:00'); 
INSERT INTO RUBRIQUE (title, mother, creator, aDate) VALUES ('CINEMA', 'CULTURE', 'nf17001', '2015-05-24 18:45:00'); 
INSERT INTO RUBRIQUE (title, mother, creator, aDate) VALUES ('ACTEUR', 'CULTURE', 'nf17001', '2015-05-24 18:50:00'); 



INSERT INTO ARTICLE (id, title, honor, aDate, author, statut) VALUES (1, 'Festival de Cannes : Jacques Audiard, Vincent Lindon, Emmanuelle Bercot… et les autres vainqueurs', 0, '2015-05-25', 'nf17002', 'en_redaction');
INSERT INTO BLOC (art, aOrder, title, texte, image_uml) VALUES (1, 1, 'Intro','Vincent Lindon meilleur acteur, Emmanuelle Bercot co-meilleure actrice, Dheepan, de Jacques Audiard et sa Palme d''or… les artistes français ont été particulièrement distingués lors de ce 68e Festival de Cannes. Découvrez le palmarès de l''édition 2015, présidée par les frères Joel et Ethan Coen.',NULL);
INSERT INTO BLOC (art, aOrder, title, texte, image_uml) VALUES (1, 2, 'La Palme d''or','C''est pour Jacques Audiard et son film Dheepan, un thriller politique réussi sur l''exil de Tamouls en banlieue parisienne. « Recevoir un prix de la part des frères Coen c''est quelque chose d''assez exceptionnel », a déclaré le réalisateur de 63 ans, très ému, ajoutant qu''il « pensait à (son) père », le scénariste et dialoguiste Michel Audiard.', NULL);
INSERT INTO BLOC (art, aOrder, title, texte, image_uml) VALUES (1, 3, 'La Palme d''or', NULL, '/image/1.1.jpg');
INSERT INTO BLOC (art, aOrder, title, texte, image_uml) VALUES (1, 4, 'Le prix d''interprétation féminine','Ex-aequo pour Rooney Mara et Emmanuelle Bercot. L''Américaine pour son rôle dans Carol, de Todd Haynes, la Française pour Mon roi, de Maïwenn, dont elle a salué « le sens aigu et l''anticonformisme ».',NULL);
INSERT INTO BLOC (art, aOrder, title, texte, image_uml) VALUES (1, 5, 'Le prix d''interprétation féminine', NULL, '/image/1.2.jpg');
INSERT INTO BLOC (art, aOrder, title, texte, image_uml) VALUES (1, 6, 'Le prix d''interprétation masculine','Pour Vincent Lindon et sa performance dans La Loi du marché, de Stéphane Brizé. L''acteur est paru très ému avec « ce premier prix qu''il reçoit dans sa vie ». « Je dédie ce prix aux citoyens laissés pour compte » , a-t-il notamment ajouté, référence au rôle de chômeur qu''il joue dans le film de Brizé.', NULL);
INSERT INTO BLOC(art, aOrder, title, texte, image_uml) VALUES (1, 7, 'Le prix d''interprétation masculine', NULL, '/image/1.3.jpg');


INSERT INTO RUBRIQUE_ARTICLE (rub, art) VALUES ('CINEMA',1);


INSERT INTO ARTICLE (id, title, honor, aDate, author, statut) VALUES (2, 'Avec Vincent Lindon, au pied des marches', 0, '2015-05-25', 'nf17002', 'en_redaction');

INSERT INTO BLOC (art, aOrder, title, texte, image_uml) VALUES (2, 1, 'Intro','Il ne tient pas en place. Dans quelques heures, ce sera la montée des marches, les photographes qui hurleront son prénom, « Vincent ! Par là ! », et, sait-on jamais, un accueil favorable de la critique internationale. Cash avec le journaliste venu l’interroger : « La rumeur est bonne, non ? Et les critiques américains, ils vont aimer ? » Vincent Lindon est à Cannes. Sélection officielle. Il est Thierry dans La Loi du marché. Impressionnant en chômeur confronté à un dilemme moral. En piste pour le Prix d’interprétation masculine.', NULL);
INSERT INTO BLOC (art, aOrder, title, texte, image_uml) VALUES (2, 2, 'Lui', NULL, '/image/2.1.jpg');
INSERT INTO BLOC (art, aOrder, title, texte, image_uml) VALUES (2, 3, 'Lui','Rien à voir avec ces acteurs qui disent détester « la promo cannoise », ces interviews données à la chaîne, trois jours durant, à des journalistes venus du monde entier. « Moi, j’adore ça. J’aimerais que ça dure six mois. » Six mois à expliquer combien ce film a marqué sa vie. « Quand Frémaux a téléphoné pour dire qu’on était en compétition, j’étais comme un fou. Après, j’ai fait un nervous breakdown ! Dire que la planète entière va voir ce film ! »', NULL);


--Si les titres sont egaux, on insère un image dessus le texte et selon l'ordre?

INSERT INTO RUBRIQUE_ARTICLE (rub, art) VALUES ('ACTEUR',2);

INSERT INTO TIE_ARTICLE (firstArticle, secondArticle) VALUES (1,2);

INSERT INTO COMMENTAIRE(id, art, aDate, creator, texte, statut) VALUES (1, 1, '2015-05-25 11:28:00', 'nf17009', 'Très bien.', 'visible');
INSERT INTO COMMENTAIRE(id, art, aDate, creator, texte, statut) VALUES (2, 1, '2015-05-28 14:33:00', 'nf17004', 'J''aime bien cet article.', 'visible');
INSERT INTO COMMENTAIRE(id, art, aDate, creator, texte, statut) VALUES (3, 2, '2015-05-30 05:11:00', 'nf17007', 'Très bien.', 'visible');

INSERT INTO NOTE (login, art, note) VALUES ('nf17009', 1, 7);
INSERT INTO NOTE (login, art, note) VALUES ('nf17004', 1, 6);



COMMIT;
