CREATE TABLE IF NOT EXISTS SOURCES (
url TEXT PRIMARY KEY
);

CREATE TABLE IF NOT EXISTS ALBUMS (
album TEXT PRIMARY KEY,
adddate DATE
);

CREATE TABLE IF NOT EXISTS TAGS (
tag TEXT PRIMARY KEY
);

CREATE TABLE IF NOT EXISTS IMAGES (
url TEXT PRIMARY KEY,
source TEXT NOT NULL,
title TEXT NOT NULL,
rate INTEGER NOT NULL,
fav INTEGER NOT NULL,
color TEXT,
adddate DATE,
date DATE,
place DATE,
format TEXT,

FOREIGN KEY(source) REFERENCES SOURCES(url)
);

CREATE TABLE IF NOT EXISTS IMAGES_TAGS (
tag TEXT NOT NULL,
url TEXT NOT NULL,
PRIMARY KEY (tag, url),
FOREIGN KEY(tag) REFERENCES TAGS(tag),
FOREIGN KEY(url) REFERENCES IMAGES(url)
);

CREATE TABLE IF NOT EXISTS IMAGES_ALBUMS (
album TEXT NOT NULL,
url TEXT NOT NULL,
adddate DATE,
PRIMARY KEY (album, url),
FOREIGN KEY(album) REFERENCES ALBUMS(album),
FOREIGN KEY(url) REFERENCES IMAGES(url)
);

CREATE TABLE IF NOT EXISTS IMAGES_NOTES (
note TEXT NOT NULL,
url TEXT NOT NULL,

PRIMARY KEY (note, url),
FOREIGN KEY(url) REFERENCES IMAGES(url)
);

CREATE TABLE IF NOT EXISTS ALBUMS_TAGS (
tag TEXT NOT NULL,
album TEXT NOT NULL,

PRIMARY KEY (tag, album),
FOREIGN KEY(tag) REFERENCES TAGS(tag),
FOREIGN KEY(album) REFERENCES ALBUMS(album)
);

CREATE TABLE IF NOT EXISTS ALBUMS_NOTES (
note TEXT NOT NULL,
album TEXT NOT NULL,

PRIMARY KEY (note, album),
FOREIGN KEY(album) REFERENCES ALBUMS(album)
);

INSERT INTO ALBUMS VALUES ("Favs", CURRENT_TIME);
INSERT INTO ALBUMS VALUES ("Recent", CURRENT_TIME);
COMMIT;
