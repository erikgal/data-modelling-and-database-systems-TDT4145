
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `mail` varchar(30) NOT NULL,
  `password` varchar(30) NOT NULL,
  `userID` varchar(30) NOT NULL,
  `type` varchar(30) NOT NULL,
  `name` varchar(30) NOT NULL,
  PRIMARY KEY (`userID`)
);


DROP TABLE IF EXISTS `active`;
CREATE TABLE `active` (
  `date` date NOT NULL,
  `userID` varchar(30) NOT NULL,
  `dailyCount` int DEFAULT NULL,
  PRIMARY KEY (`date`,`userID`),
  KEY `act_fk` (`userID`),
  CONSTRAINT `act_fk` FOREIGN KEY (`userID`) REFERENCES `user` (`userID`) ON DELETE CASCADE ON UPDATE CASCADE
);


DROP TABLE IF EXISTS `courseforum`;
CREATE TABLE `courseforum` (
  `courseCode` varchar(30) NOT NULL,
  `courseName` varchar(30) DEFAULT NULL,
  `term` varchar(30) NOT NULL,
  `adminID` varchar(30) NOT NULL,
  PRIMARY KEY (`courseCode`,`term`)
);


DROP TABLE IF EXISTS `userincourse`;
CREATE TABLE `userincourse` (
  `userID` varchar(30) NOT NULL,
  `courseCode` varchar(30) NOT NULL,
  `term` varchar(30) NOT NULL,
  `permissionType` varchar(30) NOT NULL,
  PRIMARY KEY (`userID`,`courseCode`,`term`),
  KEY `uic_FK2` (`courseCode`,`term`),
  CONSTRAINT `uic_FK1` FOREIGN KEY (`userID`) REFERENCES `user` (`userID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `uic_FK2` FOREIGN KEY (`courseCode`, `term`) REFERENCES `courseforum` (`courseCode`, `term`) ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TABLE IF EXISTS `folder`;
CREATE TABLE `folder` (
  `folderID` varchar(30) NOT NULL,
  `allowAnonymity` tinyint(1) NOT NULL,
  `courseCode` varchar(30) NOT NULL,
  `term` varchar(30) NOT NULL,
  PRIMARY KEY (`folderID`),
  KEY `fol_FK1` (`courseCode`,`term`),
  CONSTRAINT `fol_FK1` FOREIGN KEY (`courseCode`, `term`) REFERENCES `courseforum` (`courseCode`, `term`) ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TABLE IF EXISTS `subfolder`;
CREATE TABLE `subfolder` (
  `subfolderID` varchar(30) NOT NULL,
  `allowAnonymity` tinyint(1) NOT NULL,
  `folderID` varchar(30) NOT NULL,
  `subfolderNamel` varchar(30) NOT NULL,
  PRIMARY KEY (`subfolderID`),
  KEY `subfol_FK1` (`folderID`) /*!80000 INVISIBLE */,
  CONSTRAINT `subfol_FK1` FOREIGN KEY (`folderID`) REFERENCES `folder` (`folderID`) ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TABLE IF EXISTS `thread`;
CREATE TABLE `thread` (
  `threadID` varchar(30) NOT NULL,
  `name` varchar(30) NOT NULL,
  `title` varchar(300) NOT NULL,
  `description` varchar(500) NOT NULL,
  `tag` varchar(30) DEFAULT NULL,
  `likes` int DEFAULT NULL,
  `colorCode` varchar(30) DEFAULT NULL,
  `folderID` varchar(30) DEFAULT NULL,
  `subfolderID` varchar(30) DEFAULT NULL,
  `createdBy` varchar(30) NOT NULL,
  PRIMARY KEY (`threadID`),
  KEY `tuser_FK3_idx` (`createdBy`),
  KEY `tfol_FK1` (`folderID`),
  KEY `tfol_FK2` (`subfolderID`),
  CONSTRAINT `tfol_FK1` FOREIGN KEY (`folderID`) REFERENCES `folder` (`folderID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `tfol_FK2` FOREIGN KEY (`subfolderID`) REFERENCES `subfolder` (`subfolderID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `tuser_FK3` FOREIGN KEY (`createdBy`) REFERENCES `user` (`userID`) ON DELETE CASCADE ON UPDATE CASCADE
);


DROP TABLE IF EXISTS `reply`;
CREATE TABLE `reply` (
  `replyID` varchar(30) NOT NULL,
  `text` varchar(500) NOT NULL,
  `name` varchar(30) NOT NULL,
  `likes` int DEFAULT NULL,
  `threadID` varchar(30) NOT NULL,
  `createdBy` varchar(30) NOT NULL,
  `referencedThreadID` varchar(30) NOT NULL,
  PRIMARY KEY (`replyID`),
  KEY `rep_FK1` (`threadID`),
  KEY `cr_FK2_idx` (`createdBy`),
  KEY `ref_FK3_idx` (`referencedThreadID`),
  CONSTRAINT `cr_FK2` FOREIGN KEY (`createdBy`) REFERENCES `user` (`userID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ref_FK3` FOREIGN KEY (`referencedThreadID`) REFERENCES `thread` (`threadID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `rep_FK1` FOREIGN KEY (`threadID`) REFERENCES `thread` (`threadID`) ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TABLE IF EXISTS `threadviewedliked`;
CREATE TABLE `threadviewedliked` (
  `userID` varchar(30) NOT NULL,
  `threadID` varchar(30) NOT NULL,
  `viewed` tinyint NOT NULL,
  `liked` tinyint NOT NULL,
  PRIMARY KEY (`userID`,`threadID`),
  KEY `tusr_FK2` (`threadID`),
  CONSTRAINT `tusr_FK1` FOREIGN KEY (`userID`) REFERENCES `user` (`userID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `tusr_FK2` FOREIGN KEY (`threadID`) REFERENCES `thread` (`threadID`) ON DELETE CASCADE ON UPDATE CASCADE
);


DROP TABLE IF EXISTS `replyliked`;
CREATE TABLE `replyliked` (
  `userID` varchar(30) NOT NULL,
  `replyID` varchar(30) NOT NULL,
  `liked` tinyint NOT NULL,
  PRIMARY KEY (`userID`,`replyID`),
  KEY `rusr_FK2` (`replyID`),
  CONSTRAINT `rusr_FK1` FOREIGN KEY (`userID`) REFERENCES `user` (`userID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `rusr_FK2` FOREIGN KEY (`replyID`) REFERENCES `reply` (`replyID`) ON DELETE CASCADE ON UPDATE CASCADE
);




