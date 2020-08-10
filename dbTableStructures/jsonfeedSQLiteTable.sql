-- ----------------------------
-- SQLite table definitions for news
-- ----------------------------
CREATE TABLE news (
  id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  title TEXT(128,0) DEFAULT NULL,
  body TEXT,
  postdate TEXT(24,0) DEFAULT NULL,
  postvisible INTEGER(1,0) DEFAULT 0,
  postmodified TEXT(24,0) DEFAULT NULL,
  authorname TEXT(64,0) DEFAULT NULL
);




-- ----------------------------
-- SQLite table definitions for authors
-- ----------------------------
CREATE TABLE "authors" (
  "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  "name" TEXT(64) DEFAULT NULL,
  "url" TEXT(128) DEFAULT NULL,
  "avatar" TEXT(128) DEFAULT NULL
);




-- ----------------------------
-- SQLite table definitions for news_authors
-- ----------------------------
CREATE TABLE "news_authors" (
  "news_id" INTEGER NOT NULL,
  "authors_id" INTEGER NOT NULL,
  CONSTRAINT "Foreign_NewsID" FOREIGN KEY ("news_id") REFERENCES "news" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT "Foreign_AuthorsID" FOREIGN KEY ("authors_id") REFERENCES "authors" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);