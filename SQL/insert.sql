BEGIN TRANSACTION;

INSERT INTO TUSER (login, firstname, lastname, aPassword, droit) VALUES ('nf17001','Taha','ARBAOUI','12345678','administrateur');
INSERT INTO TUSER (login, firstname, lastname, aPassword, droit) VALUES ('nf17002','Celia','TOULZA','12345678','editeur');
INSERT INTO TUSER (login, firstname, lastname, aPassword, droit) VALUES ('nf17003','Alexandre','THOUVENIN','12345678','auteur');
INSERT INTO TUSER (login, firstname, lastname, aPassword, droit) VALUES ('nf17004','Baptiste','MONTANGE','12345678','editeur');
INSERT INTO TUSER (login, firstname, lastname, aPassword, droit) VALUES ('nf17005','Simei','YIN','12345678','moderateur');
INSERT INTO TUSER (login, firstname, lastname, aPassword, droit) VALUES ('nf17006','aaa','AAA','12345678','editeur');
INSERT INTO TUSER (login, firstname, lastname, aPassword, droit) VALUES ('nf17007','bbb','BBB','12345678','auteur');
INSERT INTO TUSER (login, firstname, lastname, aPassword, droit) VALUES ('nf17008','ccc','CCC','12345678','moderateur');
INSERT INTO TUSER (login, firstname, lastname, aPassword, droit) VALUES ('nf17009','ddd','DDD','12345678','administrateur');
INSERT INTO TUSER (login, firstname, lastname, aPassword, droit) VALUES ('nf17010','eee','EEE','12345678','auteur');
INSERT INTO TUSER (login, firstname, lastname, aPassword, droit) VALUES ('testLog','test','TEST','12345678','administrateur');

INSERT INTO RUBRIQUE (title, mother, creator, aDate) VALUES ('CULTURE', NULL, 'nf17001', '2015-05-24 18:40:00'); 
INSERT INTO RUBRIQUE (title, mother, creator, aDate) VALUES ('CINEMA', 'CULTURE', 'nf17001', '2015-05-24 18:45:00'); 
INSERT INTO RUBRIQUE (title, mother, creator, aDate) VALUES ('ACTEUR', 'CULTURE', 'nf17001', '2015-05-24 18:50:00'); 
INSERT INTO RUBRIQUE (title, mother, creator, aDate) VALUES ('FESTIVAL DE CANNES', 'CINEMA', 'nf17001', '2015-05-24 18:50:00'); 
INSERT INTO RUBRIQUE (title, mother, creator, aDate) VALUES ('MUSIQUE', 'CULTURE', 'nf17001', '2015-05-24 18:45:00'); 

INSERT INTO RUBRIQUE (title, mother, creator, aDate) VALUES ('ECONOMIQUE', NULL, 'nf17001', '2015-05-24 18:40:00'); 
INSERT INTO RUBRIQUE (title, mother, creator, aDate) VALUES ('HIGH TECH', 'ECONOMIQUE', 'nf17001', '2015-05-24 18:40:00'); 


INSERT INTO ARTICLE (id, title, nbBloc, honor, aDate, author, statut) VALUES (1, 'Festival de Cannes : Jacques Audiard, Vincent Lindon, Emmanuelle Bercot… et les autres vainqueurs',0 , 0, '2015-05-25', 'nf17003', 'en_redaction');
INSERT INTO BLOC (art, aOrder, title, texte, image_uml) VALUES (1, fOrdreBloc(1), 'Intro','Vincent Lindon meilleur acteur, Emmanuelle Bercot co-meilleure actrice, Dheepan, de Jacques Audiard et sa Palme d''or… les artistes français ont été particulièrement distingués lors de ce 68e Festival de Cannes. Découvrez le palmarès de l''édition 2015, présidée par les frères Joel et Ethan Coen.',NULL);
INSERT INTO BLOC (art, aOrder, title, texte, image_uml) VALUES (1, fOrdreBloc(1), 'La Palme d''or','C''est pour Jacques Audiard et son film Dheepan, un thriller politique réussi sur l''exil de Tamouls en banlieue parisienne. « Recevoir un prix de la part des frères Coen c''est quelque chose d''assez exceptionnel », a déclaré le réalisateur de 63 ans, très ému, ajoutant qu''il « pensait à (son) père », le scénariste et dialoguiste Michel Audiard.', NULL);
INSERT INTO BLOC (art, aOrder, title, texte, image_uml) VALUES (1, fOrdreBloc(1), 'La Palme d''or', NULL, '/image/1.1.jpg');
INSERT INTO BLOC (art, aOrder, title, texte, image_uml) VALUES (1, fOrdreBloc(1), 'Le prix d''interprétation féminine','Ex-aequo pour Rooney Mara et Emmanuelle Bercot. L''Américaine pour son rôle dans Carol, de Todd Haynes, la Française pour Mon roi, de Maïwenn, dont elle a salué « le sens aigu et l''anticonformisme ».',NULL);
INSERT INTO BLOC (art, aOrder, title, texte, image_uml) VALUES (1, fOrdreBloc(1), 'Le prix d''interprétation féminine', NULL, '/image/1.2.jpg');
INSERT INTO BLOC (art, aOrder, title, texte, image_uml) VALUES (1, fOrdreBloc(1), 'Le prix d''interprétation masculine','Pour Vincent Lindon et sa performance dans La Loi du marché, de Stéphane Brizé. L''acteur est paru très ému avec « ce premier prix qu''il reçoit dans sa vie ». « Je dédie ce prix aux citoyens laissés pour compte » , a-t-il notamment ajouté, référence au rôle de chômeur qu''il joue dans le film de Brizé.', NULL);
INSERT INTO BLOC(art, aOrder, title, texte, image_uml) VALUES (1, fOrdreBloc(1), 'Le prix d''interprétation masculine', NULL, '/image/1.3.jpg');


INSERT INTO RUBRIQUE_ARTICLE (rub, art, modi) VALUES ('FESTIVAL DE CANNES',1,'nf17004');
INSERT INTO TAGS (art, word, modi) VALUES (1,'palme dor', 'nf17004');
INSERT INTO TAGS (art, word, modi) VALUES (1,'cannes', 'nf17006');
INSERT INTO TAGS (art, word, modi) VALUES (1,'prix', 'nf17002');
INSERT INTO TAGS (art, word, modi) VALUES (1,'2015', 'nf17006');


INSERT INTO ARTICLE (id, title, nbBloc, honor, aDate, author, statut) VALUES (2, 'Avec Vincent Lindon, au pied des marches', 0, 0, '2015-05-25', 'nf17010', 'en_redaction');

INSERT INTO BLOC (art, aOrder, title, texte, image_uml) VALUES (2, fOrdreBloc(2), 'Intro','Il ne tient pas en place. Dans quelques heures, ce sera la montée des marches, les photographes qui hurleront son prénom, « Vincent ! Par là ! », et, sait-on jamais, un accueil favorable de la critique internationale. Cash avec le journaliste venu l’interroger : « La rumeur est bonne, non ? Et les critiques américains, ils vont aimer ? » Vincent Lindon est à Cannes. Sélection officielle. Il est Thierry dans La Loi du marché. Impressionnant en chômeur confronté à un dilemme moral. En piste pour le Prix d’interprétation masculine.', NULL);
INSERT INTO BLOC (art, aOrder, title, texte, image_uml) VALUES (2, fOrdreBloc(2), 'Lui', NULL, '/image/2.1.jpg');
INSERT INTO BLOC (art, aOrder, title, texte, image_uml) VALUES (2, fOrdreBloc(2), 'Lui','Rien à voir avec ces acteurs qui disent détester « la promo cannoise », ces interviews données à la chaîne, trois jours durant, à des journalistes venus du monde entier. « Moi, j’adore ça. J’aimerais que ça dure six mois. » Six mois à expliquer combien ce film a marqué sa vie. « Quand Frémaux a téléphoné pour dire qu’on était en compétition, j’étais comme un fou. Après, j’ai fait un nervous breakdown ! Dire que la planète entière va voir ce film ! »', NULL);

INSERT INTO RUBRIQUE_ARTICLE (rub, art, modi) VALUES ('ACTEUR',2,'nf17004');
INSERT INTO TAGS (art, word, modi) VALUES (2,'lindon','nf17004');
INSERT INTO TAGS (art, word, modi) VALUES (2,'vincent','nf17004');
INSERT INTO TAGS (art, word, modi) VALUES (2,'cannes','nf17004');
INSERT INTO TAGS (art, word, modi) VALUES (2,'palme dor','nf17004');


INSERT INTO ARTICLE (id, title, nbBloc, honor, aDate, author, statut) VALUES (3, '« Ex Machina » : la gynoïde est l’avenir de l’homme', 0, 0, '2015-06-02', 'nf17007', 'en_redaction');
INSERT INTO BLOC (art, aOrder, title, texte, image_uml) VALUES (3, fOrdreBloc(3), 'L''actrice Alicia Vikander dans le rôle d''Ava', NULL, '/image/3.1.jpg');
INSERT INTO BLOC (art, aOrder, title, texte, image_uml) VALUES (3, fOrdreBloc(3), 'Une variante fascinante du vaudeville',' A la racine de l’arbre généalogique d’Ava, on trouve un monstre sorti de l’imaginaire d’une femme. Ava – comme son nom le laisse présager – a l’aspect d’une femme. Le monstre était fait d’un assemblage de pièces de cadavres, réunies par le docteur Victor Frankenstein. Deux siècles plus tard, pour créer Ava, Nathan Bateman – ingénieur – a réuni les composants les plus sophistiqués.', NULL);
INSERT INTO BLOC (art, aOrder, title, texte, image_uml) VALUES (3, fOrdreBloc(3), 'Info','Ce moment est connu en jargon scientifique-fictif sous le nom de « singularité ». A cet instant, une « intelligence artificielle forte » (le second adjectif la distinguant de celle d’un aspirateur sans pilote ou d’une machine à laver à senseurs) surpassera l’esprit humain. Selon les calculs d’Alex Garland, on n’en est plus très loin. Son film commence au quartier général d’une multinationale du Net qui a construit sa fortune sur le Blue Book, le plus malin des moteurs de recherche. Là, un programmeur nommé Caleb (Domnhall Gleeson) apprend qu’il a remporté un concours d’entreprise qui lui permettra de rencontrer Nathan Bateman, le fondateur de l’entreprise, qui – encore adolescent – a écrit l’algorithme à l’origine de sa fortune.', NULL);


INSERT INTO RUBRIQUE_ARTICLE (rub, art, modi) VALUES ('CINEMA',3,'nf17006');
INSERT INTO TAGS (art, word, modi) VALUES (3,'machina','nf17006');
INSERT INTO TAGS (art, word, modi) VALUES (3,'ex','nf17006');
INSERT INTO TAGS (art, word, modi) VALUES (3,'alicia','nf17006');
INSERT INTO TAGS (art, word, modi) VALUES (3,'vikander','nf17006');
INSERT INTO TAGS (art, word, modi) VALUES (3,'ava','nf17006');
INSERT INTO TAGS (art, word, modi) VALUES (3,'futur','nf17006');


INSERT INTO ARTICLE (id, title, nbBloc, honor, aDate, author, statut) VALUES (4, 'Les pirouettes du temps', 0, 0, '2015-06-02', 'nf17007', 'en_redaction');
INSERT INTO BLOC (art, aOrder, title, texte, image_uml) VALUES (4, fOrdreBloc(4), 'Info',' Un lent ballet d’Homo smartphonicus ondule, téléphones portables en main, sur une houle sonore mariant chant ­tibétain et Early Morning ­Melody, de Meredith Monk. Puis se transforme en groupe d’oiseleurs imprimant dans l’air des sismographies de chants d’oiseaux : les expériences de musique interactive lancées avec le Collective Sound Checks ­seront au programme de la vaste journée portes ouvertes du Festival ManiFeste, journée qui se déroulera le 6 juin, de 15 heures à 21 heures.', NULL);
INSERT INTO BLOC (art, aOrder, title, texte, image_uml) VALUES (4, fOrdreBloc(4), 'image extraite du spectacle « Il se trouve que les oreilles n’ont pas de paupières », de Benjamin Dupé, programmé à Montreuil du 18 au 20 juin', NULL, '/image/4.1.jpg');
INSERT INTO BLOC (art, aOrder, title, texte, image_uml) VALUES (4, fOrdreBloc(4), 'Relégué aux oubliettes',' Relégué aux oubliettes, le temps où l’Ircam (Institut de recherche et coordination acoustique/musique) mitonnait dans les sous-sols de la place Igor-Stravinsky des logiciels complexes pour compositeurs érudits. Depuis quelque trois décennies, la synthèse vocale, pierre de touche de la geste ircamienne, s’est répandue comme une traînée de poudre dans les dessins animés, jeux vidéo, cinéma ou la création contemporaine. Tout s’est accéléré en 2001 avec la création de K, de Philippe Manoury, à l’Opéra de ­Paris.', NULL);


INSERT INTO RUBRIQUE_ARTICLE (rub, art, modi) VALUES ('MUSIQUE',4,'nf17002');
INSERT INTO TAGS (art, word, modi) VALUES (4,'pirouettes','nf17002');
INSERT INTO TAGS (art, word, modi) VALUES (4,'spectacle','nf17002');
INSERT INTO TAGS (art, word, modi) VALUES (4,'manifeste','nf17002');
INSERT INTO TAGS (art, word, modi) VALUES (4,'temps','nf17002');


INSERT INTO ARTICLE (id, title, nbBloc, honor, aDate, author, statut) VALUES (5, 'Samsung lance le Galaxy S6, son arme anti-Apple', 0, 0, '2015-06-02', 'nf17003', 'en_redaction');
INSERT INTO BLOC (art, aOrder, title, texte, image_uml) VALUES (5, fOrdreBloc(5), 'La sortie des deux nouveaux modèles haut de gamme de téléphones de Samsung, le Galaxy S6 et sa version incurvée Edge, est prévue pour vendredi 10 avril', NULL, '/image/5.1.jpg');
INSERT INTO BLOC (art, aOrder, title, texte, image_uml) VALUES (5, fOrdreBloc(5), 'Le vent tournerait-il pour Samsung ?','Le vent tournerait-il pour Samsung ? Depuis la fin 2014, le bruit de fond autour du géant sud-coréen est plutôt négatif. Mais la commercialisation, vendredi 10 avril, de son nouveau smartphone, le Galaxy S6, et de sa version incurvée Edge pourrait inverser la tendance. Le vice-président de la branche mobile du conglomérat, Lee Sang-chul, a indiqué vendredi attendre « des ventes record » dans l’histoire du groupe. Ce qui place la barre au-delà des 70 millions de terminaux vendus, chiffre atteint par le Galaxy S4, commercialisé en 2013.', NULL);
INSERT INTO BLOC (art, aOrder, title, texte, image_uml) VALUES (5, fOrdreBloc(5), '20 millions de modèles commandés','Alors du côté de Suwon, le siège de la marque, au sud de Séoul, on n’hésite pas à écrire la chronique d’un succès annoncé. Début mars, un cadre dirigeant du groupe confiait anonymement au Korea Times que les opérateurs avaient précommandé 20 millions de ces deux nouveaux modèles haut de gamme. Un chiffre « record » selon cette source.
Derrière ces données, invérifiables, s’affiche une autre réalité. Celle d’un groupe qui souffre, comme en témoigne le recul de 23 % en 2014 du bénéfice net et la baisse de près de 10 % du chiffre d’affaires. Samsung – qui vend aussi de l’électroménager et des semi-conducteurs – n’avait pas enregistré de baisse de ses revenus depuis… 2005. « On est à un moment charnière pour Samsung », relève M. Husson.
Sur le marché des smartphones – activité qui représente plus de la moitié de son chiffre d’affaires et près de 58 % de son résultat opérationnel –, le groupe est pris en tenailles : avec d’un côté son grand rival Apple sur le segment des appareils les plus high-tech et les plus chers et, de l’autre, les fabricants chinois comme Xiaomi, Huawei ou Lenovo, en grande forme, sur les téléphones de moyenne et d’entrée de gamme.', NULL);
INSERT INTO BLOC (art, aOrder, title, texte, image_uml) VALUES (5, fOrdreBloc(5), 'Eviter un destin à la Nokia','Une équation complexe qui permet à certaines cassandres de prédire à Samsung un destin à la Nokia. Au quatrième trimestre 2014, le sud-coréen a perdu sa couronne de plus gros vendeur de smartphones, devancé par Apple, dont les ventes – 74,8 millions en trois mois – ont été dopées par le succès du tout nouvel iPhone 6. Si, en volume et sur l’ensemble de l’année 2014, Samsung demeure le premier fabricant mondial de mobiles avec plus de 307 millions d’unités (191 millions pour Apple et 81 millions pour Lenovo), le groupe n’en voit pas moins sa part de marché fondre. Entre 2013 et 2014, elle est passée de 30,9 % à 24,7 %, selon le cabinet Gartner.
Le lancement des deux Galaxy S6 (de 649 € à 1 049 €) est l’une des voies choisies par Samsung pour se sortir de cette nasse. « Le succès ou non de ces smartphones va permettre de tester l’appétence des consommateurs sur du haut de gamme griffé Samsung, appétence qui existe par exemple en Chine pour Apple », souligne Thomas Husson. Même si la commercialisation du Galaxy S6 risque d’être parasitée par la campagne de promotion engagée par la firme de Cuppertino pour son Apple Watch, le groupe coréen bénéficie d’une belle fenêtre de tir pour imposer ses produits. Son rival américain ne sortira pas de nouveau téléphone intelligent avant l’automne.
Doté d’un nouveau design, d’une batterie à l’autonomie améliorée et d’une caméra plus perfectionnée, le Galaxy S6 a des atouts pour répondre à l’iPhone 6. Dans ce combat face à Apple et aux constructeurs chinois, Samsung n’est pas désarmé. Son statut de leader lui permet de bénéficier d’économies d’échelle, de relations privilégiées avec les opérateurs et d’un formidable rouleau compresseur marketing. C’est ce pari que font certains analystes en relevant à la hausse leurs prévisions de bénéfices pour le groupe au deuxième trimestre.', NULL);
INSERT INTO BLOC (art, aOrder, title, texte, image_uml) VALUES (5, fOrdreBloc(5), 'Améliorer la rentabilité de l’activité des semi-conducteurs','
Afin d’enrayer sa chute, Samsung explore une autre voie que celle de l’innovation dans les smartphones. Numéro deux mondial de semi-conducteurs, le groupe entend améliorer sa rentabilité sur cette activité qui pèse plus de 30 % de son chiffre d’affaires. La firme a modernisé certaines de ses usines produisant des puces. Ce volontarisme connaît des premiers effets positifs : le bénéfice opérationnel de la division semi-conducteurs a bondi de 35,7 % sur un an au quatrième trimestre et le groupe a signé, selon Bloomberg, un contrat avec… Apple pour produire la principale puce de son futur modèle d’iPhone. Scellant au passage la réconciliation entre les deux groupes.
Ce questionnement se double aujourd’hui d’une incertitude quant à l’avenir de la gouvernance du chaebol. Lee Kun-hee, le président et fils du fondateur du groupe, est entre la vie et la mort. La question de savoir qui lui succédera parmi ses enfants n’a pas encore été tranchée. Une incertitude qui ne contribue pas à la sérénité du conglomérat.', NULL);


INSERT INTO RUBRIQUE_ARTICLE (rub, art, modi) VALUES ('HIGH TECH',5,'nf17002');
INSERT INTO TAGS (art, word, modi) VALUES (5,'samsung','nf17002');
INSERT INTO TAGS (art, word, modi) VALUES (5,'s6','nf17002');
INSERT INTO TAGS (art, word, modi) VALUES (5,'galaxy','nf17002');
INSERT INTO TAGS (art, word, modi) VALUES (5,'apple','nf17002');
INSERT INTO TAGS (art, word, modi) VALUES (5,'anti-apple','nf17002');


INSERT INTO ARTICLE (id, title, nbBloc, honor, aDate, author, statut) VALUES (6, 'Spéculations autour des ventes de l’Apple Watch', 0, 0, '2015-06-02', 'nf17003', 'en_redaction');
INSERT INTO BLOC (art, aOrder, title, texte, image_uml) VALUES (6, fOrdreBloc(6), 'Info','Deux mois se sont bientôt écoulés depuis le coup d’envoi des précommandes pour l’Apple Watch, et Apple n’a toujours pas communiqué officiellement sur les chiffres de ventes de sa montre connectée. Ce silence alimente évidemment les spéculations et pousse les analystes à échafauder toutes sortes de modèles pour tenter d’évaluer le succès rencontré – ou pas – par la firme de Cupertino (Californie).
Un jeu auquel vient de se livrer Trip Chowdhry du cabinet Global Equities Research, selon Barron’s. Se fondant sur des sondages menés auprès de développeurs ayant mis au point des applications pour l’Apple Watch.', NULL);
INSERT INTO BLOC (art, aOrder, title, texte, image_uml) VALUES (6, fOrdreBloc(6), 'Arrivée dans les Apple Store','Pour se rendre compte de la réalité ou non du succès de l’Apple Watch peut-être faut-il attendre que les modèles soient enfin commercialisés dans les Apple Store. Jusqu’à aujourd’hui, les ventes n’étaient réalisées que sur internet et dans quelques boutiques sélectionnées à travers le monde. En France, c’est le magasin parisien branché Colette qui a obtenu ce privilège.
Dans une vidéo interne, Angela Ahrendts, senior vice-présidente en charge des Apple Store, vient d’informer les salariés d’Apple qu’ils pourront prochainement vendre l’Apple Watch, leur indiquant même qu’en raison de la multiplicité des combinaisons possibles ils ne pourraient peut-être pas livrer aux clients la montre de leurs rêves.
Mme Ahrendts ne donne aucune date précise. Mais le patron d’Apple, Tim Cook, avait laissé entendre que cela pourrait être en juin.', NULL);


INSERT INTO RUBRIQUE_ARTICLE (rub, art, modi) VALUES ('HIGH TECH',6,'nf17006');
INSERT INTO TAGS (art, word, modi) VALUES (6,'apple','nf17006');
INSERT INTO TAGS (art, word, modi) VALUES (6,'watch','nf17006');
INSERT INTO TAGS (art, word, modi) VALUES (6,'futur','nf17006');



INSERT INTO ARTICLE (id, title, nbBloc, honor, aDate, author, statut) VALUES (7, 'La politique de François Hollande, ce futur antérieur', 0, 0, '2015-06-02', 'nf17007', 'en_redaction');
INSERT INTO BLOC (art, aOrder, title, texte, image_uml) VALUES (7, fOrdreBloc(7), 'François Hollande le 2 juin, à Paris', NULL, '/image/7.1.jpg');
INSERT INTO BLOC (art, aOrder, title, texte, image_uml) VALUES (7, fOrdreBloc(7), 'Info','François Hollande a du goût pour la métaphysique. Il déclarait récemment en Haïti : « On ne peut pas changer l’histoire, on peut changer l’avenir. » C’est une question pour les philosophes, qui ne peut laisser les économistes indifférents.
Dans notre conception ordinaire de l’avenir, l’idée qu’on puisse le changer est dépourvue de sens. De deux choses l’une, en effet. Ou bien l’on considère que l’avenir n’a pas de réalité au moment présent. La proposition « Il y aura un “Grexit” avant la fin de l’année 2015 » pas plus que la proposition contraire n’ont de valeur de vérité maintenant : elles ne sont ni vraies ni fausses. C’était la position d’un Grec illustre nommé Aristote. Dans ce cas, on ne peut changer ce qui n’a pas encore de réalité. Comme disent certains, l’avenir sera ce que nous en faisons, et cela est indéterminé comme notre liberté.
Ou bien l’on tient pour vraie maintenant soit la première proposition soit la seconde, ce qui ne veut pas dire que nous sachions ce qu’il en est. Dans ce cas, il n’y a rien que quiconque puisse faire entre aujourd’hui et le moment du « Grexit », s’il est vrai qu’il aura lieu, qui aurait pour conséquence qu’il n’ait pas lieu.', NULL);


INSERT INTO RUBRIQUE_ARTICLE (rub, art, modi) VALUES ('ECONOMIQUE',7,'nf17002');
INSERT INTO TAGS (art, word, modi) VALUES (7,'hollande','nf17002');
INSERT INTO TAGS (art, word, modi) VALUES (7,'futur','nf17002');
INSERT INTO TAGS (art, word, modi) VALUES (7,'politique','nf17002');


INSERT INTO TIE_ARTICLE (firstArticle, secondArticle, modi) VALUES (1,2,'nf17002');
INSERT INTO TIE_ARTICLE (firstArticle, secondArticle, modi) VALUES (1,3,'nf17002');
INSERT INTO TIE_ARTICLE (firstArticle, secondArticle, modi) VALUES (5,6,'nf17002');


INSERT INTO COMMENTAIRE(id, art, aDate, creator, texte, statut) VALUES (1, 1, '2015-05-25 11:28:00', 'nf17009', 'Très bien.', 'visible');
INSERT INTO COMMENTAIRE(id, art, aDate, creator, texte, statut) VALUES (2, 2, '2015-05-25 11:28:00', 'nf17005', 'Tant pis. tous les acteur/rice que j''aime rentrent avec ses mains vides. :(', 'visible');
INSERT INTO COMMENTAIRE(id, art, aDate, creator, texte, statut) VALUES (3, 2, '2015-05-28 14:33:00', 'nf17004', 'Il est tellement beau ! <333', 'visible');
INSERT INTO COMMENTAIRE(id, art, aDate, creator, texte, statut) VALUES (4, 2, '2015-05-30 05:11:00', 'nf17005', 'C''est nul.', 'visible');
INSERT INTO COMMENTAIRE(id, art, aDate, creator, texte, statut) VALUES (5, 3, '2015-05-30 05:11:00', 'nf17004', 'Une belle dangereuse. <3', 'visible');
INSERT INTO COMMENTAIRE(id, art, aDate, creator, texte, statut) VALUES (6, 3, '2015-05-30 05:11:00', 'nf17008', 'Très bien.', 'visible');
INSERT INTO COMMENTAIRE(id, art, aDate, creator, texte, statut) VALUES (7, 3, '2015-05-30 05:11:00', 'nf17010', 'Ca a l''air intéressant.', 'visible');
INSERT INTO COMMENTAIRE(id, art, aDate, creator, texte, statut) VALUES (8, 4, '2015-05-30 05:11:00', 'nf17007', 'Je vais y aller.', 'visible');
INSERT INTO COMMENTAIRE(id, art, aDate, creator, texte, statut) VALUES (9, 4, '2015-05-30 05:11:00', 'nf17006', 'Ils ont regagné ses places !', 'visible');
INSERT INTO COMMENTAIRE(id, art, aDate, creator, texte, statut) VALUES (10, 5, '2015-05-30 05:11:00', 'nf17002', 'NON !', 'visible');
INSERT INTO COMMENTAIRE(id, art, aDate, creator, texte, statut) VALUES (11, 5, '2015-05-30 05:11:00', 'nf17007', 'S6 est très cool !', 'visible');
INSERT INTO COMMENTAIRE(id, art, aDate, creator, texte, statut) VALUES (12, 5, '2015-05-30 05:11:00', 'nf17005', 'J''aime mieux Nokia toujours.', 'visible');
INSERT INTO COMMENTAIRE(id, art, aDate, creator, texte, statut) VALUES (13, 5, '2015-05-30 05:11:00', 'nf17008', 'Allez mourir ! Sumsung !', 'visible');
INSERT INTO COMMENTAIRE(id, art, aDate, creator, texte, statut) VALUES (14, 6, '2015-05-30 05:11:00', 'nf17008', 'Très bien.', 'visible');
INSERT INTO COMMENTAIRE(id, art, aDate, creator, texte, statut) VALUES (15, 6, '2015-05-30 05:11:00', 'nf17002', 'J''aime bien apple watch X)', 'visible');
INSERT INTO COMMENTAIRE(id, art, aDate, creator, texte, statut) VALUES (16, 7, '2015-05-30 05:11:00', 'nf17001', 'Aller! Champion !', 'visible');
INSERT INTO COMMENTAIRE(id, art, aDate, creator, texte, statut) VALUES (17, 7, '2015-05-30 05:11:00', 'nf17005', 'C''est qui sa copine maintenant ?', 'visible');

UPDATE COMMENTAIRE SET statut='masque', modi='nf17008' WHERE id = 2;
UPDATE COMMENTAIRE SET statut='masque', modi='nf17008' WHERE id = 13;

UPDATE ARTICLE SET statut='publie', modi='nf17002' WHERE id = 2;
UPDATE ARTICLE SET honor=1, modi='nf17002' WHERE id = 5;
UPDATE ARTICLE SET statut='supprime', modi='nf17002' WHERE id = 1;
UPDATE ARTICLE SET statut='en_redaction', modi='nf17002' WHERE id = 1;
UPDATE ARTICLE SET statut='soumis', modi='nf17002' WHERE id = 2;
UPDATE ARTICLE SET statut='valide', modi='nf17002' WHERE id = 1;

COMMIT;
