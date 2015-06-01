-------------------------------------------------ADMINISTRATEUR-------------------------------------------------

--CREATION D'UN COMPTE
INSERT INTO TUSER (login, firstname, lastname, aPassword) VALUES ('$newLogin','$newFirstName','$newLastName','$newPassword');

--On utilisera des checkbox pour renvoyer des "droit"?
--Si coché, on insère
INSERT INTO DROIT_USER (login, droit) VALUES ('$newLogin','administrateur');
INSERT INTO DROIT_USER (login, droit) VALUES ('$newLogin','auteur');
INSERT INTO DROIT_USER (login, droit) VALUES ('$newLogin','editeur');
INSERT INTO DROIT_USER (login, droit) VALUES ('$newLogin','moderateur');
INSERT INTO DROIT_USER (login, droit) VALUES ('$newLogin','lecteur');

-------------------------------------------------AUTEUR-------------------------------------------------------------

--CREATION D'UN ARTICLE--

INSERT INTO ARTICLE (id, title, nbBloc, honor, aDate, author, statut) VALUES (idauto_art.nextval, '$newTitle', 0, 0, current_date, '$currentLogin', 'en_redaction'); --nextval???


--AJOUTER DES BLOCS--
--SI BLOC DE TEXT
INSERT INTO BLOC (art, aOrder, title, texte, image_uml) VALUES ('$currentArt', fOrdreBloc($currentArt), '$titleBloc', '$nexText' , NULL);
--SI BLOC D'IMAGE
INSERT INTO BLOC (art, aOrder, title, texte, image_uml) VALUES ('$currentArt', fOrdreBloc($currentArt), '$titleBloc', NULL, '$newUml')


--VOIR SES ARTICLES EN COURS DE REDACTION--
SELECT id, title, aDate, statut
FROM ARTICLE
WHERE author='$currentLogin' AND (statut='en_redaction' OR statut='supprime')
ORDER BY aDate;


--SUPPRIMER UN ARTICLE--
UPDATE ARTICLE SET statut='supprime' WHERE id='$currentArt';

--RECUPERER UN ARTICLE SUPPRIME--
UPDATE ARTICLE SET statut='en_redaction' WHERE id='$currentArt' AND statut='supprime';

--SOUMETTRE UN ARTICLE--
UPDATE ARTICLE SET statut='soumis' WHERE id='$currentArt' AND statut='en_redaction';



-------------------------------------------------EDITEUR----------------------------------------------------------

--VOIR ENSEMBLE DES ARTICLE, PAR AUTEUR, PAR DATE, PAR STATUT

----PAR AUTEUR
------ la liste des auteurs
SELECT A.author, U.firstName, U.lastname, COUNT(*) AS nbArticles
FROM ARTICLE A, TUSER U
WHERE A.author=U.login
GROUP BY A.author, U.firstName, U.lastname
ORDER BY A.author;

------la liste des articles de l'auteur choisi
SELECT id, title, honor, aDate, statut
FROM ARTICLE
WHERE id = '$authorVoulu'
ORDER BY aDate;


----PAR DATE
------ la liste des dates
SELECT aDate, COUNT(*) AS nbArticles
FROM ARTICLE
GROUP BY aDate
ORDER BY aDate;

------la liste des articles de le la date choisi
SELECT id, title, honor, aDate, statut
FROM ARTICLE
WHERE aDate = '$dateVoulu'
ORDER BY aDate;


----PAR STATUT
------ la liste des statuts
SELECT statut, COUNT(*) AS nbArticles
FROM ARTICLE
GROUP BY statut
ORDER BY statut;

------la liste des articles de du statut choisi
SELECT id, title, honor, aDate, statut
FROM ARTICLE
WHERE statut = '$statutVoulu'
ORDER BY aDate;

--ACCEDER AUX ARTICLES ET LES CORRIGER
--visualiser l'article
----l'information de l'article(title, author, date, statut)
SELECT A.title, U.firstName, U.lastname, A.aDate, A.statut, A.honor
FROM ARTICLE A, TUSER U
WHERE A.id='$currentArt' AND A.author=U.login;

----afficher des blocs par ordre
SELECT art, aOrder, title, texte, image_uml
FROM BLOC
WHERE art='$currentArt' 
ORDER BY oOrder;

----afficher la justification si rejete
SELECT justification
FROM ARTICLE
WHERE id='$currentArt' AND statut='rejete';

----afficher les preconisation si a_reviser
SELECT aDate, editor, texte
FROM PRECONISATION
WHERE art='$currentArt'
ORDER BY aDate;



--corriger l'article/bloc
UPDATE BLOC SET texte ='$newText' WHERE art='$currentArt' AND aOrder='$currentOrder';


--ASSOCIER UN STATUT A CHAQUE ARTICLE
--checkbox?
UPDATE ARTICLE SET statut='en_redaction' WHERE id='$currentArt';
UPDATE ARTICLE SET statut='en_relecture' WHERE id='$currentArt';

UPDATE ARTICLE SET statut='rejete' WHERE id='$currentArt';
--demande une justification si rejete
UPDATE ARTICLE SET justification='$newJustification' WHERE id='$currentArt';

UPDATE ARTICLE SET statut='a_reviser' WHERE id='$currentArt';
--demande une preconisation si a_reviser
INSERT INTO PRECONISATION (art, aDate, editor, texte) VALUES ('$currentArt', current_timestamp, '$currentLogin', 'newPreconisation');


--AJOUTER DES MOTS CLES
INSERT INTO TAGS (art, word) VALUES('$currentArt', '$newTag');


--CREATION D'UN RUBRIQUE
--On utilisera des checkbox pour renvoyer des "mère"?
--Si coché, on insère une mère ?
INSERT INTO RUBRIQUE (title, mother, creator, aDate) VALUES ( '$newTitle', '$mother', '$currentLogin', current_timestamp);

--ASSOCIER DES ARTICLES A UNE OU PLUSIEURS RUBRIQUES
INSERT INTO RUBRIQUE_ARTICLE (rub, art) VALUES('$rubriqueVoulu','$currentArt');

--SELECTIONNER PARMI DES ARTICLES VALIDES CEUX QUI SONT PUBILIE SUR LE SITE
SELECT id, title, honor, aDate, author, statut
FROM ARTICLE
WHERE statut='valide';

UPDATE ARTICLE SET statut='publie' WHERE id='$currentArt';

--PROPOSER UNE CATEGORIE A L'HONNEUR
UPDATE ARTICLE SET honor=1 WHERE id='$currentArt';

--LIER DEUX ARTICLES
INSERT INTO TIE_ARTICLE (firstArticle, secondArticle) VALUES ($art1,$art2);


-------------------------------------------------MODERATEUR----------------------------------------------------------

--On utilisera des liens pour renvoyer des fonctions?
UPDATE COMMENTAIRE SET statut='supprime' WHERE id='$currentComm';
UPDATE COMMENTAIRE SET statut='visible' WHERE id='$currentComm';
UPDATE COMMENTAIRE SET statut='exergue' WHERE id='$currentComm';
UPDATE COMMENTAIRE SET statut='masque' WHERE id='$currentComm';


-------------------------------------------------LECTEUR----------------------------------------------------------

--VISUALISER LES ARTICLES
----l'information de l'article(title, author, date), on n'affiche pas "statut" ici.
SELECT A.title, U.firstName, U.lastname, A.aDate, A.honor
FROM ARTICLE A, TUSER U
WHERE A.id='$currentArt' AND A.author=U.login;

----afficher des blocs par ordre
SELECT art, aOrder, title, texte, image_uml
FROM BLO
WHERE art='$currentArt' 
ORDER BY oOrder;


--ACCEDER AUX ARTICLES PAR RUBRIQUES ET/OU SOUS-RUBRIQUE
----Selon une Rubrique choisi, afficher les titres de ses sous-rubriques
SELECT title
FROM RUBRIQUE
WHERE mere='$currentRub';

----la liste des articles par rubriques/sous-rubriques
SELECT A.id, A.title, A.honor, A.aDate, A.author
FROM ARTICLE A, RUBRIQUE_ARTICLE RA
WHERE A.id=RA.art AND (RA.rub='$currentRub' OR RA.rub IN (SELECT title FROM RUBRIQUE WHERE mere='$currentRub'))
ORDER BY aDate;
--??? ça marche seulement pour des rubriques de 2 niveaux, on fait comment, pour affichier des articles des
--??? sous-briques d'un rubrique ? on cree la lien entre la rubrique et l'article quand cet article est lié 
--??? à son sous-rubrique ??? Ou bien on construire ces liens à la main ? 


--EFFECTUER UNE RECHERCHE PAR MOTS CLES


--ACCEDER A LA CATEGORIE A L'HONNEUR


--ACCEDER AUX ARTICLE LIES DEPUIS UN ARTICLE LU
--plus de travail au niveau de php
--les titres des articles associés


--ASSOCIER UN COMMENTAIRE A UN ARTICLE
INSERT INTO COMMENTAIRE(id, art, aDate, creator, texte, statut) VALUES(idauto_comm.nextval, '$currentArt', current_timestamp ,'$currentLogin', '$newComm', 'visible');


--SUPPRIMER SES COMMENTAIRE
UPDATE COMMENTAIRE SET statut='supprime' WHERE id='$currentComm' AND creator='$currentLogin';

--LIRE DES COMMENTAIRES(NON MASQUE) DES AUTRES
SELECT aDate, creator, texte, statut
FROM COMMENTAIRE
WHERE art='$currentArt' AND (statut = 'exergue' OR statut = 'visible')
ORDER BY aDate;
