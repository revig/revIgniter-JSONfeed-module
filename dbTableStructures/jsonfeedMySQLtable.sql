#-- ----------------------------
#-- MySQL table definitions for news
#-- ----------------------------
CREATE TABLE `news` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(128) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `body` text CHARACTER SET utf8 COLLATE utf8_unicode_ci,
  `postdate` datetime DEFAULT NULL,
  `postmodified` datetime DEFAULT NULL,
  `authorname` varchar(64) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `postvisible` enum('0','1') CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;




#-- ----------------------------
#-- MySQL table definitions for authors
#-- ----------------------------
CREATE TABLE `authors` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(64) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `url` varchar(128) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `avatar` varchar(128) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;




#-- ----------------------------
#-- MySQL table definitions for news_authors
#-- ----------------------------
CREATE TABLE `news_authors` (
  `news_id` int(11) unsigned NOT NULL,
  `authors_id` int(11) unsigned NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;