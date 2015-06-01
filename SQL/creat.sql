BEGIN TRANSACTION;

CREATE TABLE TUSER(
	login CHAR(7) PRIMARY KEY,
	firstName VARCHAR(20),
	lastName VARCHAR(20),
	aPassword CHAR(8) NOT NULL
	--creator CHAR(7) REFERENCES TUSER(login) /*NOT NULL???*/
);

CREATE TABLE DROIT_USER(
	login CHAR(7) REFERENCES TUSER(login),
	droit VARCHAR(20),
	PRIMARY KEY(login, droit),
	CHECK (droit IN ('administrateur', 'auteur', 'lecteur', 'editeur', 'moderateur'))
);

CREATE TABLE ARTICLE(
	id INTEGER PRIMARY KEY,
	title VARCHAR(100) NOT NULL UNIQUE,
	nbBloc INTEGER NOT NULL,
	honor INTEGER,
	aDate DATE NOT NULL,
	author CHAR(7) NOT NULL REFERENCES TUSER(login),
	statut VARCHAR(20) NOT NULL,
	justification TEXT,
	CHECK (statut IN ('en_relecture', 'en_redaction', 'soumis', 'supprime', 'rejete', 'a_reviser', 'valide', 'publie')),
	CHECK (nbBloc >=0),
	CHECK (honor IN (1,0))
);

CREATE TABLE HISTORIQUE_ARTICLE(
	art INTEGER REFERENCES ARTICLE(id),
	aDate TIMESTAMP,
	login CHAR(7) REFERENCES TUSER(login) NOT NULL,
	aAction VARCHAR(10) NOT NULL,
	PRIMARY KEY(art, aDate),
	CHECK (aAction IN('creer', 'supprimer', 'soumettre', 'recuperer', 'corriger', 'associer_statut', 'mot_cle', 'honorer', 'deshonorer', 'lier_article', 'lier_rubrique', 'publier'))
);

CREATE TABLE TIE_ARTICLE(
	firstArticle INTEGER REFERENCES ARTICLE(id),
	secondArticle INTEGER REFERENCES ARTICLE(id),
	CHECK(firstArticle!=secondArticle),
	UNIQUE(firstArticle,secondArticle), --(1,2) et (2,1) sont pareils
	PRIMARY KEY(firstArticle, secondArticle)
);

CREATE TABLE TAGS(
	art INTEGER REFERENCES ARTICLE(id),
	word VARCHAR(100),
	PRIMARY KEY(art,word)
);

CREATE TABLE RUBRIQUE(
	title VARCHAR(50) PRIMARY KEY,
	mother VARCHAR(50) REFERENCES RUBRIQUE(title),
	creator CHAR(7) REFERENCES TUSER(login) NOT NULL,
	aDate TIMESTAMP NOT NULL
);

CREATE TABLE RUBRIQUE_ARTICLE(
	rub VARCHAR(50) REFERENCES RUBRIQUE(title),
	art INTEGER REFERENCES ARTICLE(id),
	PRIMARY KEY(rub, art)
);

CREATE TABLE BLOC(
	art INTEGER REFERENCES ARTICLE(id),
	aOrder INTEGER,
	title VARCHAR(50) NOT NULL,
	texte TEXT,
	image_uml VARCHAR(200),
	CHECK((texte NOT NULL) OR (image_uml NOT NULL) ),
	PRIMARY KEY(art, aOrder)
);

CREATE TABLE NOTE(
	login CHAR(7) REFERENCES TUSER(login),
	art INTEGER REFERENCES ARTICLE(id),
	note INTEGER NOT NULL,
	PRIMARY KEY(login, art),
	CHECK((note>0) AND (note<=10))
);

CREATE TABLE COMMENTAIRE(
	id INTEGER PRIMARY KEY,
	art INTEGER REFERENCES ARTICLE(id) NOT NULL,
	aDate TIMESTAMP NOT NULL,
	creator CHAR(7) REFERENCES TUSER(login) NOT NULL,
	texte TEXT NOT NULL,
	statut VARCHAR(10),
	CHECK (statut IN ('visible', 'masque', 'supprime', 'exergue')),
	UNIQUE(art, aDate)
);

CREATE TABLE HISTORIQUE_COMMENTAIRE(
	comm INTEGER REFERENCES COMMENTAIRE(id),
	aDate TIMESTAMP,
	login CHAR(7) REFERENCES TUSER(login) NOT NULL,
	aAction VARCHAR(10) NOT NULL,
	CHECK (aAction IN ('recuperer','masquer', 'supprimer', 'exergue')),
	PRIMARY KEY(comm, aDate)
);

CREATE TABLE PRECONISATION(
	art INTEGER REFERENCES ARTICLE(id),
	aDate TIMESTAMP,
	editor CHAR(7) NOT NULL REFERENCES TUSER(login),
	texte TEXT NOT NULL,
	PRIMARY KEY(art, aDate)	
);

COMMIT;








--------------------------------------SEQUENCES----------------------------------------------------------------
BEGIN TRANSACTION;

--Identité des articles
CREATE SEQUENCE idauto_art
INCREMENT BY 1
NO MAXVALUE
START WITH 4
NO CYCLE;


--Identité des commentaires
CREATE SEQUENCE idauto_comm
INCREMENT BY 1
NO MAXVALUE
START WITH 4
NO CYCLE;

COMMIT;





--------------------------------------FUNCTION ET TRIGGERS------------------------------------------------------
BEGIN TRANSACTION;



--GERER L'HISTORIQUE D'ARTICLE-----------------------------------------------------------------------------

--------L'HISTORIQUE DE CREATION OU CHANGEMENT DE STAUT D'ARTICLE
CREATE OR REPLACE FUNCTION process_tr_historique_article1() RETURNS TRIGGER AS $tr_historique_article1$
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
            IF (OLD.statut!=NEW.statut) THEN
				IF (OLD.statut='supprime' AND NEW.statut!='supprime') THEN
					INSERT INTO HISTORIQUE_ARTICLE(art, aDate, login, aAction ) VALUES (NEW.id ,current_timestamp,'$currentLogin','recuperer');
				ELSIF (NEW.statut='soumis') THEN
					INSERT INTO HISTORIQUE_ARTICLE(art, aDate, login, aAction ) VALUES (NEW.id ,current_timestamp,'$currentLogin','soumettre');
				ELSIF (NEW.statut='supprime') THEN
					INSERT INTO HISTORIQUE_ARTICLE(art, aDate, login, aAction ) VALUES (NEW.id ,current_timestamp,'$currentLogin','supprimer');
				ELSIF (NEW.statut='publie') THEN
					INSERT INTO HISTORIQUE_ARTICLE(art, aDate, login, aAction ) VALUES (NEW.id ,current_timestamp,'$currentLogin','publier');
				ELSE
					INSERT INTO HISTORIQUE_ARTICLE(art, aDate, login, aAction ) VALUES (NEW.id ,current_timestamp,'$currentLogin','associer_statut');
				END IF;
			END IF;
			
			IF (OLD.honor!=NEW.honor) THEN
				IF (NEW.honor=1) THEN
					INSERT INTO HISTORIQUE_ARTICLE(art, aDate, login, aAction ) VALUES (NEW.id ,current_timestamp,'$currentLogin','honorer');
				ELSE
					INSERT INTO HISTORIQUE_ARTICLE(art, aDate, login, aAction ) VALUES (NEW.id ,current_timestamp,'$currentLogin','deshonorer');
				END IF;
			END IF;
			
        ELSIF (TG_OP = 'INSERT') THEN
            INSERT INTO HISTORIQUE_ARTICLE(art, aDate, login, aAction ) VALUES (NEW.id ,current_timestamp,NEW.author,'creer');
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
		INSERT INTO HISTORIQUE_ARTICLE(art, aDate, login, aAction ) VALUES (NEW.firstArticle ,current_timestamp,'$currentLogin','lier_article');
		INSERT INTO HISTORIQUE_ARTICLE(art, aDate, login, aAction ) VALUES (NEW.secondArticle ,current_timestamp,'$currentLogin','lier_article');
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
		INSERT INTO HISTORIQUE_ARTICLE(art, aDate, login, aAction ) VALUES (NEW.art ,current_timestamp,'$currentLogin','mot_cle');
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
		INSERT INTO HISTORIQUE_ARTICLE(art, aDate, login, aAction ) VALUES (NEW.art ,current_timestamp,'$currentLogin','corriger');
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
		INSERT INTO HISTORIQUE_ARTICLE(art, aDate, login, aAction ) VALUES (NEW.art ,current_timestamp,'$currentLogin','lier_rubrique');
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
    BEGIN
		IF (OLD.statut!=NEW.statut) THEN
			IF(NEW.statut='supprime')THEN
				INSERT INTO Historique_Commentaire(comm, aDate, login, aAction ) VALUES (NEW.id ,current_timestamp,'$currentLogin','supprimer');
			ELSIF(NEW.statut='visible')THEN
				INSERT INTO Historique_Commentaire(comm, aDate, login, aAction ) VALUES (NEW.id ,current_timestamp,'$currentLogin','recuperer');
			ELSIF(NEW.statut='exergue')THEN
				INSERT INTO Historique_Commentaire(comm, aDate, login, aAction ) VALUES (NEW.id ,current_timestamp,'$currentLogin','exergue');
			ELSIF(NEW.statut='masque')THEN
				INSERT INTO Historique_Commentaire(comm, aDate, login, aAction ) VALUES (NEW.id ,current_timestamp,'$currentLogin','masquer');
			END IF;	
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
CREATE OR REPLACE FUNCTION fOrdreBloc (idArt INTEGER) RETURN INTEGER AS $$
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
