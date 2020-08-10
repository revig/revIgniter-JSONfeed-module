-- ----------------------------
-- Postgre table definitions for news
-- ----------------------------
CREATE TABLE "news" (
  "id" SERIAL NOT NULL,
  "title" varchar(128) DEFAULT NULL,
  "body" text,
  "postdate" timestamp DEFAULT NULL,
  "postvisible" int4 DEFAULT '0',
  "postmodified" timestamp DEFAULT NULL,
  "authorname" varchar(64) DEFAULT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "check_id" CHECK(id >= 0)
);




-- ----------------------------
-- Postgre table definitions for authors
-- ----------------------------
CREATE TABLE "authors" (
  "id" SERIAL NOT NULL,
  "name" varchar(64) DEFAULT NULL,
  "url" varchar(128) DEFAULT NULL,
  "avatar" varchar(128) DEFAULT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "check_id" CHECK(id >= 0)
);



-- ----------------------------
-- Postgre table definitions for news_authors
-- ----------------------------
CREATE TABLE "news_authors" (
  "news_id" int NOT NULL,
  "authors_id" int NOT NULL,
  CONSTRAINT "Foreign_NewsID" FOREIGN KEY ("news_id") REFERENCES "news" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT "Foreign_AuthorsID" FOREIGN KEY ("authors_id") REFERENCES "authors" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);