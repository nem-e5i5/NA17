BEGIN TRANSACTION;

CREATE TABLE TUSER(
	login VARCHAR(30) PRIMARY KEY,
	firstName VARCHAR(20),
	lastName VARCHAR(20),
	aPassword VARCHAR(100) NOT NULL,
	droit VARCHAR(20) NOT NULL,
	CHECK (droit IN ('administrateur', 'editeur', 'auteur', 'lecteur', 'moderateur'))
);


CREATE TABLE ARTICLE(
	id INTEGER PRIMARY KEY,
	title VARCHAR(100) NOT NULL UNIQUE,
	nbBloc INTEGER NOT NULL,
	honor INTEGER,
	aDate DATE NOT NULL,
	author VARCHAR(30) NOT NULL REFERENCES TUSER(login),
	statut VARCHAR(20) NOT NULL,
	modi VARCHAR(30) REFERENCES TUSER(login),
	justification TEXT,
	CHECK (statut IN ('en_relecture', 'en_redaction', 'soumis', 'supprime', 'rejete', 'a_reviser', 'valide', 'publie')),
	CHECK (nbBloc >=0),
	CHECK (honor IN (1,0))
);

CREATE TABLE HISTORIQUE_ARTICLE(
	id INTEGER PRIMARY KEY,
	art INTEGER REFERENCES ARTICLE(id) NOT NULL,
	aDate TIMESTAMP NOT NULL,
	login VARCHAR(30) REFERENCES TUSER(login) NOT NULL,
	aAction VARCHAR(20) NOT NULL,
	CHECK (aAction IN('creer', 'supprimer', 'soumettre', 'recuperer', 'corriger', 'associer_statut', 'mot_cle', 'honorer', 'deshonorer', 'lier_article', 'lier_rubrique', 'publier', 'valider'))
);

CREATE TABLE TIE_ARTICLE(
	firstArticle INTEGER REFERENCES ARTICLE(id),
	secondArticle INTEGER REFERENCES ARTICLE(id),
	modi VARCHAR(30) REFERENCES TUSER(login),
	CHECK(firstArticle!=secondArticle),
	UNIQUE(secondArticle,firstArticle), --(1,2) et (2,1) sont pareils
	PRIMARY KEY(firstArticle, secondArticle)
);

CREATE TABLE TAGS(
	art INTEGER REFERENCES ARTICLE(id),
	word VARCHAR(100),
	modi VARCHAR(30) REFERENCES TUSER(login),
	PRIMARY KEY(art,word)
);

CREATE TABLE RUBRIQUE(
	title VARCHAR(50) PRIMARY KEY,
	mother VARCHAR(50) REFERENCES RUBRIQUE(title),
	creator VARCHAR(30) REFERENCES TUSER(login) NOT NULL,
	aDate TIMESTAMP NOT NULL
);

CREATE TABLE RUBRIQUE_ARTICLE(
	rub VARCHAR(50) REFERENCES RUBRIQUE(title),
	art INTEGER REFERENCES ARTICLE(id),
	modi VARCHAR(30) REFERENCES TUSER(login),
	PRIMARY KEY(rub, art)
);

CREATE TABLE BLOC(
	art INTEGER REFERENCES ARTICLE(id),
	aOrder INTEGER,
	type CHAR(1) NOT NULL,
	title VARCHAR(200) NOT NULL,
	texte TEXT,
	image_uml VARCHAR(200),
	modi VARCHAR(30) REFERENCES TUSER(login),
	CHECK((texte IS NOT NULL) OR (image_uml IS NOT NULL) ),
	CHECK (type IN ('T', 'I')),
	PRIMARY KEY(art, aOrder)
);

CREATE TABLE COMMENTAIRE(
	id INTEGER PRIMARY KEY,
	art INTEGER REFERENCES ARTICLE(id) NOT NULL,
	aDate TIMESTAMP NOT NULL,
	creator VARCHAR(30) REFERENCES TUSER(login) NOT NULL,
	texte TEXT NOT NULL,
	statut VARCHAR(20) NOT NULL,
	modi VARCHAR(30) REFERENCES TUSER(login),
	CHECK (statut IN ('visible', 'masque', 'supprime', 'exergue'))
);

CREATE TABLE HISTORIQUE_COMMENTAIRE(
	id INTEGER PRIMARY KEY,
	comm INTEGER REFERENCES COMMENTAIRE(id) NOT NULL,
	aDate TIMESTAMP NOT NULL,
	login VARCHAR(30) REFERENCES TUSER(login) NOT NULL,
	aAction VARCHAR(20) NOT NULL,
	CHECK (aAction IN ('recuperer','masquer', 'supprimer', 'exergue'))
);

CREATE TABLE PRECONISATION(
	art INTEGER REFERENCES ARTICLE(id),
	aDate TIMESTAMP,
	editor VARCHAR(30) NOT NULL REFERENCES TUSER(login),
	texte TEXT NOT NULL,
	PRIMARY KEY(art, editor)	
);




--------------------------------------SEQUENCES----------------------------------------------------------------


--Identité des articles
CREATE SEQUENCE idauto_art
INCREMENT BY 1
NO MAXVALUE
START WITH 8
NO CYCLE;


--Identité des commentaires
CREATE SEQUENCE idauto_comm
INCREMENT BY 1
NO MAXVALUE
START WITH 18
NO CYCLE;

--Identité des historiques des articles
CREATE SEQUENCE idauto_his_art
INCREMENT BY 1
NO MAXVALUE
START WITH 1
NO CYCLE;

--Identité des historiques des commentaires
CREATE SEQUENCE idauto_his_comm
INCREMENT BY 1
NO MAXVALUE
START WITH 1
NO CYCLE;



--------------------------------------FUNCTION ET TRIGGERS------------------------------------------------------




--GERER L'HISTORIQUE D'ARTICLE-----------------------------------------------------------------------------

--------L'HISTORIQUE DE CREATION OU CHANGEMENT DE STAUT D'ARTICLE
CREATE OR REPLACE FUNCTION process_tr_historique_article1() RETURNS TRIGGER AS $tr_historique_article1$
    DECLARE 
	act VARCHAR(20);
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
            IF (OLD.statut!=NEW.statut) THEN
				IF (OLD.statut='supprime' AND NEW.statut!='supprime') THEN
					act:='recuperer';
				ELSIF (NEW.statut='soumis') THEN
					act:='soumettre';
				ELSIF (NEW.statut='supprime') THEN
					act:='supprimer';
				ELSIF (NEW.statut='publie') THEN
					act:='publier';
				ELSIF (NEW.statut='valide') THEN
					act:='valider';
				ELSE
					act:='associer_statut';
				END IF;
				INSERT INTO HISTORIQUE_ARTICLE(id, art, aDate, login, aAction ) VALUES (nextval('idauto_his_art'), NEW.id ,current_timestamp,NEW.modi,act);
			END IF;
			
			IF (OLD.honor!=NEW.honor) THEN
				IF (NEW.honor=1) THEN
					act:='honorer';
				ELSE
					act:='deshonorer';
				END IF;
			INSERT INTO HISTORIQUE_ARTICLE(id, art, aDate, login, aAction ) VALUES (nextval('idauto_his_art'), NEW.id ,current_timestamp, NEW.modi,act);
			END IF;
			
        ELSIF (TG_OP = 'INSERT') THEN
            INSERT INTO HISTORIQUE_ARTICLE(id, art, aDate, login, aAction ) VALUES (nextval('idauto_his_art'), NEW.id ,current_timestamp,NEW.author,'creer');
        END IF;
        RETURN NULL; -- result is ignored since this is an AFTER trigger
    END;
$tr_historique_article1$ LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER tr_historique_article1
AFTER INSERT OR UPDATE 
ON ARTICLE
FOR EACH ROW 
EXECUTE PROCEDURE process_tr_historique_article1();


--------L'HISTORIQUE DE CREATION DE LIEN ENTRE DEUX ARTICLES
CREATE OR REPLACE FUNCTION process_tr_historique_article2() RETURNS TRIGGER AS $tr_historique_article2$
    BEGIN
		INSERT INTO HISTORIQUE_ARTICLE(id, art, aDate, login, aAction ) VALUES (nextval('idauto_his_art'), NEW.firstArticle ,current_timestamp,NEW.modi,'lier_article');
		INSERT INTO HISTORIQUE_ARTICLE(id, art, aDate, login, aAction ) VALUES (nextval('idauto_his_art'), NEW.secondArticle ,current_timestamp,NEW.modi,'lier_article');
		RETURN NULL;
    END;
$tr_historique_article2$ LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER tr_historique_article2
AFTER INSERT 
ON TIE_ARTICLE
FOR EACH ROW 
EXECUTE PROCEDURE process_tr_historique_article2();


--------L'HISTORIQUE DE CREATION DE MOT CLE
CREATE OR REPLACE FUNCTION process_tr_historique_article3() RETURNS TRIGGER AS $tr_historique_article3$
    BEGIN
		INSERT INTO HISTORIQUE_ARTICLE(id, art, aDate, login, aAction ) VALUES (nextval('idauto_his_art'), NEW.art ,current_timestamp,NEW.modi,'mot_cle');
		RETURN NULL;
    END;
$tr_historique_article3$ LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER tr_historique_article3
AFTER INSERT 
ON TAGS
FOR EACH ROW 
EXECUTE PROCEDURE process_tr_historique_article3();


--------L'HISTORIQUE DE CORRECTION DE TEXTE D'ARTICLE
CREATE OR REPLACE FUNCTION process_tr_historique_article4() RETURNS TRIGGER AS $tr_historique_article4$
    BEGIN
		INSERT INTO HISTORIQUE_ARTICLE(id, art, aDate, login, aAction ) VALUES (nextval('idauto_his_art'), NEW.art ,current_timestamp,NEW.modi,'corriger');
		RETURN NULL; 
    END;
$tr_historique_article4$ LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER tr_historique_article4
AFTER UPDATE 
ON BLOC
FOR EACH ROW 
EXECUTE PROCEDURE process_tr_historique_article4();


--------L'HISTORIQUE DE LIAISON ENTRE RUBRIQUES ET ARTICLES
CREATE OR REPLACE FUNCTION process_tr_historique_article5() RETURNS TRIGGER AS $tr_historique_article5$
    BEGIN
		INSERT INTO HISTORIQUE_ARTICLE(id, art, aDate, login, aAction ) VALUES (nextval('idauto_his_art'), NEW.art ,current_timestamp,NEW.modi,'lier_rubrique');
		RETURN NULL; 
    END;
$tr_historique_article5$ LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER tr_historique_article5
AFTER INSERT 
ON RUBRIQUE_ARTICLE
FOR EACH ROW 
EXECUTE PROCEDURE process_tr_historique_article5();


--HISTORIQUE DES COMMENTAIRES--------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION process_tr_historique_commentaire() RETURNS TRIGGER AS $tr_historique_commentaire$
    DECLARE 
	act VARCHAR(20);
    BEGIN
		IF (OLD.statut!=NEW.statut) THEN
			IF(NEW.statut='supprime')THEN
				act:='supprimer';
			ELSIF(NEW.statut='visible')THEN
				act:='recuperer';
			ELSIF(NEW.statut='exergue')THEN
				act:='exergue';
			ELSIF(NEW.statut='masque')THEN
				act:='masquer';
			END IF;	
			INSERT INTO Historique_Commentaire(id, comm, aDate, login, aAction ) VALUES (nextval('idauto_his_comm'), NEW.id ,current_timestamp,NEW.modi,act);
		END IF;
        RETURN NULL; -- result is ignored since this is an AFTER trigger
    END;
$tr_historique_commentaire$ LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER tr_historique_commentaire
AFTER UPDATE 
ON COMMENTAIRE
FOR EACH ROW 
EXECUTE PROCEDURE process_tr_historique_commentaire();

--INSERER DES BLOCS--------------------------------------------------------------------------
--Retouner l'ordre du bloc automatiquement
CREATE OR REPLACE FUNCTION fOrdreBloc (idArt INTEGER) RETURNS INTEGER AS $$
DECLARE ord INTEGER;
BEGIN
	SELECT nbBloc INTO ord
	FROM ARTICLE
	WHERE id=idArt;--ou bien $1???  http://docs.postgresql.fr/8.3/sql-createfunction.html
	
	RETURN ord+1;
END;
$$ LANGUAGE plpgsql VOLATILE;


--Incrementer nbBloc dans ARTICLE
CREATE OR REPLACE FUNCTION incrementer_nbBloc() RETURNS TRIGGER AS $incrementer_nbBloc$
    BEGIN
		UPDATE ARTICLE SET nbBloc=nbBloc+1 WHERE id=NEW.art;
		RETURN NULL; 
    END;
$incrementer_nbBloc$ LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER incrementer_nbBloc
AFTER INSERT 
ON BLOC
FOR EACH ROW 
EXECUTE PROCEDURE incrementer_nbBloc();



COMMIT;
