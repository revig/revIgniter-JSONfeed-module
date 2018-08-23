-- ----------------------------
-- Postgre table structure for news
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