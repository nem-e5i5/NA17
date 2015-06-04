
-----------------------------PAGE D'ACCEUIL & PAGE DE LISTE-----------------------------------------------------------------

-----------------LA LIST DES ARTICLES----------------------

--LA LISTE DE TOUS LES ARTICLES
SELECT A.id, A.title, A.honor, A.aDate, A.author, U.firstname, U.lastname, A.statut--Il faut vérifier que le statut='pubilie' pour les lecteur!!!
FROM ARTICLE A, TUSER U
WHERE A.author=U.login
ORDER BY A.aDate;




--PAR RUBRIQUES ET/OU SOUS-RUBRIQUE
----Rubriques qui n'ont pas de mère
SELECT title
FROM RUBRIQUE
WHERE mother IS NULL;

----Selon une Rubrique choisi, les titres de ses sous-rubriques
SELECT title
FROM RUBRIQUE
WHERE mother='$currentRub';

----la liste des articles par rubriques/sous-rubriques()
SELECT A.id, A.title, A.honor, A.aDate, A.author, U.firstname, U.lastname, A.statut--Il faut vérifier que le statut='pubilie' pour les lecteur!!!
FROM ARTICLE A, RUBRIQUE_ARTICLE RA, TUSER U
WHERE A.id=RA.art AND RA.rub='$currentRub' AND A.author=U.login
ORDER BY A.aDate;




--PAR MOTS CLES
----Tous les mots clés : ("datalist" de html sera bien pour le saisir https://developer.mozilla.org/en-US/docs/Web/HTML/Element/datalist)
SELECT word FROM TAGS;

----
SELECT A.id, A.title, U.firstName, U.lastname, A.aDate, A.honor, A.statut--CONDITION AVEC statut : Des lecteurs ET modérateurs ne peuvent que voir des articles 'publié' !!
FROM ARTICLE A, TUSER U, TAGS T
WHERE A.author=U.login AND T.art=A.id AND T.word = lower('$wordCherche');




--PAR L'HONNEUR
SELECT A.id, A.title, U.firstName, U.lastname, A.aDate, A.honor, A.statut----CONDITION AVEC statut : Des lecteurs ET modérateurs ne peuvent que voir des articles 'publié' !!
FROM ARTICLE A, TUSER U
WHERE A.author=U.login AND A.honor=1;




----PAR AUTEUR
------ la liste des auteurs
SELECT A.author, U.firstName, U.lastname, COUNT(*) AS nbArticles
FROM ARTICLE A, TUSER U
WHERE A.author=U.login
GROUP BY A.author, U.firstName, U.lastname
ORDER BY A.author;

------la liste des articles de l'auteur choisi
SELECT A.id, A.title, U.firstName, U.lastname, A.aDate, A.honor, A.statut----CONDITION AVEC statut : Des lecteurs ET modérateurs ne peuvent que voir des articles 'publié' !!
FROM ARTICLE A, TUSER U
WHERE A.author=U.login AND A.author='$authorVoulu';




----PAR DATE
------ la liste des dates
SELECT aDate, COUNT(*) AS nbArticles
FROM ARTICLE
GROUP BY aDate
ORDER BY aDate;

------la liste des articles de le la date choisi
SELECT A.id, A.title, U.firstName, U.lastname, A.aDate, A.honor, A.statut
FROM ARTICLE A, TUSER U
WHERE A.aDate = '$dateVoulu' AND A.author=U.login
ORDER BY aDate;




----PAR STATUT (Pour un author ou un éditeur)
------ la liste des statuts
SELECT statut, COUNT(*) AS nbArticles
FROM ARTICLE
GROUP BY statut
ORDER BY statut;

------la liste des articles de du statut choisi
SELECT A.id, A.title, U.firstName, U.lastname, A.aDate, A.honor, A.statut
FROM ARTICLE A, TUSER U
WHERE A.statut = '$statutVoulu' AND A.author=U.login
ORDER BY A.aDate;

--VOIR LES ARTICLES EN COURS DE REDACTION DE L'AUTEUR
SELECT A.id, A.title, U.firstName, U.lastname, A.aDate, A.honor, A.statut
FROM ARTICLE A, TUSER U
WHERE A.author='$currentLogin' AND (A.statut='en_redaction' OR A.statut='supprime') AND A.author=U.login
ORDER BY A.aDate; --L'author peut seulement modifier ses articles en rédaction



-----------------LIER DEUX ARTICLES (POUR UN EDIREUR)----------------------
INSERT INTO TIE_ARTICLE (firstArticle, secondArticle) VALUES ('$art1','$art2');




-----------------CREATION D'UN ARTICLE (POUR UN AUTEUR)--------------------------------
INSERT INTO ARTICLE (id, title, nbBloc, honor, aDate, author, statut) VALUES (nextval('idauto_art'), '$newTitle', 0, 0, current_date, '$currentLogin', 'en_redaction');





----------------------------------PAGE D'INSCRIPTION-------------------------------------------------------------------------------
--CREATION D'UN COMPTE
INSERT INTO TUSER (login, firstname, lastname, aPassword, droit) VALUES ('$newLogin','$newFirstName','$newLastName','$newPassword', 'lecteur');

















-------------------------PAGE POUR DONNER LE DROIT (ADMINISTRATEUR)-----------------------------------------------------------------
UPDATE TUSER SET droit = 'lecteur' WHERE login = '$currentLogin';
UPDATE TUSER SET droit = 'editeur' WHERE login = '$currentLogin';
UPDATE TUSER SET droit = 'auteur' WHERE login = '$currentLogin';
UPDATE TUSER SET droit = 'moderateur' WHERE login = '$currentLogin';
UPDATE TUSER SET droit = 'administrateur' WHERE login = '$currentLogin';


















------------------------------------------------------PAGE D'ARTICLE-----------------------------------------------------------------

--VISUALISER LES ARTICLES
SELECT A.title, U.firstName, U.lastname, A.aDate, A.honor, A.statut
FROM ARTICLE A, TUSER U
WHERE A.id='$currentArt' AND A.author=U.login;

----afficher des blocs par ordre
SELECT art, aOrder, title, texte, image_uml
FROM BLOC
WHERE art='$currentArt' 
ORDER BY aOrder;




--ACCEDER AUX ARTICLE LIES DEPUIS UN ARTICLE LU
--plus de travail au niveau de php
--les titres des articles associés
SELECT A.title, A.statut--CONDITION AVEC statut: Des lecteurs ET modérateurs ne peuvent que voir des articles 'publié'
FROM ARTICLE A
WHERE A.id IN
(SELECT firstArticle FROM TIE_ARTICLE T WHERE T.secondArticle='$currentArt'
UNION
SELECT secondArticle FROM TIE_ARTICLE T WHERE T.firstArticle='$currentArt');




--AJOUTER UN COMMENTAIRE A UN ARTICLE
INSERT INTO COMMENTAIRE(id, art, aDate, creator, texte, statut) VALUES(nextval('idauto_comm'), '$currentArt', current_timestamp ,'$currentLogin', '$newComm', 'visible');

--SUPPRIMER SES COMMENTAIRE
UPDATE COMMENTAIRE SET statut='supprime' WHERE id='$currentComm' AND creator='$currentLogin';

--LIRE DES COMMENTAIRES(NON MASQUE) DES AUTRES
--CONDITION pour lecteur : non masque : (statut = 'exergue' OR statut = 'visible') !!
--Des modérateurs peuvent voir tous les commantaires !!
SELECT aDate, creator, texte, statut
FROM COMMENTAIRE
WHERE art='$currentArt'
ORDER BY aDate;




----------------POUR UN MODERATEUR
UPDATE COMMENTAIRE SET statut='supprime' WHERE id='$currentComm';
UPDATE COMMENTAIRE SET statut='visible' WHERE id='$currentComm';
UPDATE COMMENTAIRE SET statut='exergue' WHERE id='$currentComm';
UPDATE COMMENTAIRE SET statut='masque' WHERE id='$currentComm';



---------------- POUR UN AUTEUR

--SUPPRIMER UN ARTICLE--
UPDATE ARTICLE SET statut='supprime' WHERE id='$currentArt';

--RECUPERER UN ARTICLE SUPPRIME--
UPDATE ARTICLE SET statut='en_redaction' WHERE id='$currentArt' AND statut='supprime';

--SOUMETTRE UN ARTICLE--
UPDATE ARTICLE SET statut='soumis' WHERE id='$currentArt' AND statut='en_redaction';


---------------- POUR UN EDITEUR

----afficher la justification si rejete
SELECT justification
FROM ARTICLE
WHERE id='$currentArt' AND statut='rejete';

----afficher les preconisation si a_reviser
SELECT aDate, editor, texte
FROM PRECONISATION
WHERE art='$currentArt'
ORDER BY aDate;


--ASSOCIER UN STATUT A CHAQUE ARTICLE
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




------------------------------------------------------PAGE DU BLOC-----------------------------------------------------------------
--corriger des blocs (EDITEUR)
UPDATE BLOC SET texte ='$newText' AND title = '$newText' WHERE art='$currentArt' AND aOrder='$currentOrder';

--insérer un bloc (AUTEUR)
--SI BLOC DE TEXT
INSERT INTO BLOC (art, aOrder, title, texte, image_uml) VALUES ('$currentArt', fOrdreBloc($currentArt), '$titleBloc', '$nexText' , NULL);
--SI BLOC D'IMAGE
INSERT INTO BLOC (art, aOrder, title, texte, image_uml) VALUES ('$currentArt', fOrdreBloc($currentArt), '$titleBloc', NULL, '$newUml');







------------------------------------------------------PAGE DU RUBRIQUE-----------------------------------------------------------------
--CREATION D'UN RUBRIQUE
INSERT INTO RUBRIQUE (title, mother, creator, aDate) VALUES ( '$newTitle', '$mother', '$currentLogin', current_timestamp);

--ASSOCIER DES ARTICLES A UNE RUBRIQUES
INSERT INTO RUBRIQUE_ARTICLE (rub, art) VALUES('$rubriqueVoulu','$currentArt');

--SELECTIONNER PARMI DES ARTICLES VALIDES CEUX QUI SONT PUBILIE SUR LE SITE
SELECT id, title, honor, aDate, author, statut
FROM ARTICLE
WHERE statut='valide';

UPDATE ARTICLE SET statut='publie' WHERE id='$currentArt';

--PROPOSER UNE CATEGORIE A L'HONNEUR
UPDATE ARTICLE SET honor=1 WHERE id='$currentArt';



