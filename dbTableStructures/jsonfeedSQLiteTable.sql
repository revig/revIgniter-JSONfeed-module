-- ----------------------------
-- SQLite table structure for news
-- ----------------------------
DROP TABLE IF EXISTS "news";
CREATE TABLE news (
  id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  title TEXT(128,0) DEFAULT NULL,
  body TEXT,
  postdate TEXT(24,0) DEFAULT NULL,
  postvisible INTEGER(1,0) DEFAULT 0,
  postmodified TEXT(24,0) DEFAULT NULL,
  authorname TEXT(64,0) DEFAULT NULL
);