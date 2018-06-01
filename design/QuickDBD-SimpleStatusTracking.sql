-- Exported from QuickDBD: https://www.quickdatatabasediagrams.com/
-- Link to schema: https://app.quickdatabasediagrams.com/#/schema/A0-Fcqnp802Uo6StXjwGNA
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.


-- A person who will report status
CREATE TABLE `Person` (
    `PersonID` int  NOT NULL ,
    `Email` string  NOT NULL ,
    `Password` varchar(25)  NOT NULL ,
    `FirstName` string  NOT NULL ,
    `LastName` string  NOT NULL ,
    `Manager` int  NULL ,
    PRIMARY KEY (
        `PersonID`
    )
);

-- a single status report for a fixed time perior
CREATE TABLE `StatusUpdate` (
    `StatusID` int  NOT NULL ,
    `PersonID` int  NOT NULL ,
    `BeginDate` date  NOT NULL ,
    `EndDate` date  NOT NULL ,
    PRIMARY KEY (
        `StatusID`
    )
);

-- line items in a status report
CREATE TABLE `StatusUpdateDetail` (
    `StatusUpdateDetailID` int  NOT NULL ,
    `StatusUpdateID` int  NOT NULL ,
    -- Update Type ID is FK to UpdateTypes, which are things like "Accomplished this week", "Blockers", etc
    `UpdateTypeID` int  NOT NULL ,
    `UpdateText` text  NOT NULL ,
    `IsCompleted` boolean  NOT NULL ,
    PRIMARY KEY (
        `StatusUpdateDetailID`
    )
);

-- Categories for status update details, for example "Planned", "Problem", "Progressed"
CREATE TABLE `UpdateTypes` (
    `UpdateTypeID` int  NOT NULL ,
    `Name` varchar(50)  NOT NULL ,
    PRIMARY KEY (
        `UpdateTypeID`
    ),
    CONSTRAINT `uc_UpdateTypes_Name` UNIQUE (
        `Name`
    )
);

-- Smart Tags, tags that can be attached to a status detail and carry additional information
CREATE TABLE `SmartTags` (
    `SmartTagID` int  NOT NULL ,
    `SmartTag` varchar(25)  NOT NULL ,
    `Description` text  NOT NULL ,
    `URL` varchar(255)  NOT NULL ,
    PRIMARY KEY (
        `SmartTagID`
    )
);

-- maps a many smart tags to many status update details
CREATE TABLE `SmartTagsUpdateDetails` (
    `SmartTagID` int  NOT NULL ,
    `StatusUpdateDetailID` int  NOT NULL 
);

ALTER TABLE `Person` ADD CONSTRAINT `fk_Person_Manager` FOREIGN KEY(`Manager`)
REFERENCES `Person` (`PersonID`);

ALTER TABLE `StatusUpdate` ADD CONSTRAINT `fk_StatusUpdate_PersonID` FOREIGN KEY(`PersonID`)
REFERENCES `Person` (`PersonID`);

ALTER TABLE `StatusUpdateDetail` ADD CONSTRAINT `fk_StatusUpdateDetail_StatusUpdateID` FOREIGN KEY(`StatusUpdateID`)
REFERENCES `StatusUpdate` (`StatusID`);

ALTER TABLE `StatusUpdateDetail` ADD CONSTRAINT `fk_StatusUpdateDetail_UpdateTypeID` FOREIGN KEY(`UpdateTypeID`)
REFERENCES `UpdateTypes` (`UpdateTypeID`);

ALTER TABLE `SmartTagsUpdateDetails` ADD CONSTRAINT `fk_SmartTagsUpdateDetails_SmartTagID` FOREIGN KEY(`SmartTagID`)
REFERENCES `SmartTags` (`SmartTagID`);

ALTER TABLE `SmartTagsUpdateDetails` ADD CONSTRAINT `fk_SmartTagsUpdateDetails_StatusUpdateDetailID` FOREIGN KEY(`StatusUpdateDetailID`)
REFERENCES `StatusUpdateDetail` (`StatusUpdateDetailID`);

CREATE INDEX `idx_Person_Email`
ON `Person` (`Email`);

