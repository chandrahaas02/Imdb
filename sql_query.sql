CREATE TABLE names
(
    nconst  TEXT  PRIMARY KEY,
    primaryName TEXT,
    birthYear INTEGER,
    deathYear INTEGER,
    primaryProfession TEXT[],
    KnownForTitles TEXT[]
);

COPY names
FROM '/home/haas/imdb/names.tsv' 
DELIMITER E'\t'
CSV HEADER;

CREATE TABLE titleakas
(
    titleId TEXT,
    ordering INTEGER,
    title TEXT,
    region TEXT,
    language TEXT,
    types TEXT[],
    attributes TEXT[],
    isOriginalTitle BOOL
);

COPY titleakas
FROM '/home/haas/imdb/title_akas.tsv' 
DELIMITER E'\t'
CSV HEADER;


CREATE TABLE title
(
    tconst TEXT PRIMARY KEY,
    titleType TEXT,
    primaryTitle TEXT,
    originalTitle TEXT,
    isAdult BOOL,
    startYear INTEGER,
    endYear INTEGER,
    runtimeMinutes INTEGER,
    genres TEXT[]
);

COPY title
FROM '/home/haas/imdb/titlebasics.tsv' 
DELIMITER E'\t'
CSV HEADER;

CREATE TABLE crew
(
    tconst TEXT,
    directors TEXT[],
    writers TEXT[]
);

COPY crew
FROM '/home/haas/imdb/crew.tsv' 
DELIMITER E'\t'
CSV HEADER;


CREATE TABLE epsiode
(
    tconst TEXT,
    parentTconst TEXT,
	seasonNumber integer,
	episodeNumber integer
);

COPY epsiode
FROM '/home/haas/imdb/title.episode.tsv' 
DELIMITER E'\t'
CSV HEADER;


CREATE TABLE principal
(
    tconst TEXT,
    ordering INTEGER,
    nconst TEXT,
    category TEXT,
    job TEXT,
    characters TEXT
);

COPY principal
FROM '/home/haas/imdb/title.principals.tsv' 
DELIMITER E'\t'
CSV HEADER;

CREATE TABLE ratings
(
    tconst TEXT,
    averageRating FLOAT(1),
    numVotes INTEGER
)

COPY principal
FROM '/home/haas/imdb/title.ratings.tsv' 
DELIMITER E'\t'
CSV HEADER;

/*  The files here are preporcess as the postgress 
accepts the array elements only it there is {}
so the data here is preprocessed accordingly  */

/* The only table which has changes accorings to our 
ER diagram is crew as it contains both directors and writters in
same table but we have different tables */

CREATE TABLE Directors AS
SELECT  tconst ,directors FROM crew ;

CREATE TABLE Writers AS
SELECT  tconst ,writers FROM crew ;

DROP TABLE crew;




