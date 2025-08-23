-- 1. Volunteers
ALTER TABLE Volunteers RENAME TO Volunteers_old;

CREATE TABLE Volunteers (
    VolunteerID INTEGER PRIMARY KEY NOT NULL UNIQUE,
    FirstName TEXT NOT NULL,
    LastName TEXT NOT NULL,
    DOB DATE NOT NULL,
    PhoneNumber TEXT NOT NULL,
    Address TEXT NOT NULL,
    UserID INTEGER NOT NULL,
    FOREIGN KEY(UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);

INSERT INTO Volunteers (VolunteerID, FirstName, LastName, DOB, PhoneNumber, Address, UserID)
SELECT VolunteerID, FirstName, LastName, DOB, PhoneNumber, Address, UserID FROM Volunteers_old;

DROP TABLE Volunteers_old;

-- 2. Companies
ALTER TABLE Companies RENAME TO Companies_old;

CREATE TABLE Companies (
    CompanyID INTEGER PRIMARY KEY NOT NULL UNIQUE,
    CompanyName TEXT NOT NULL,
    CompanyEmail TEXT NOT NULL UNIQUE,
    CompanyPhone TEXT NOT NULL,
    CompanyLocation TEXT NOT NULL,
    CompanyWebsite TEXT NOT NULL,
    CompanyCEO TEXT NOT NULL,
    UserID INTEGER NOT NULL,
    FOREIGN KEY(UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);

INSERT INTO Companies (CompanyID, CompanyName, CompanyEmail, CompanyPhone, CompanyLocation, CompanyWebsite, CompanyCEO, UserID)
SELECT CompanyID, CompanyName, CompanyEmail, CompanyPhone, CompanyLocation, CompanyWebsite, CompanyCEO, UserID FROM Companies_old;

DROP TABLE Companies_old;

-- 3. VolunteerProfile
ALTER TABLE VolunteerProfile RENAME TO VolunteerProfile_old;

CREATE TABLE VolunteerProfile (
    VolunteerProfileID INTEGER PRIMARY KEY NOT NULL UNIQUE,
    VolunteerID INTEGER NOT NULL,
    Bio TEXT,
    YearsOfExperience INTEGER,
    Certificates TEXT,
    Availability TEXT,
    Endorsements TEXT,
    FOREIGN KEY(VolunteerID) REFERENCES Volunteers(VolunteerID) ON DELETE CASCADE
);

INSERT INTO VolunteerProfile (VolunteerProfileID, VolunteerID, Bio, YearsOfExperience, Certificates, Availability, Endorsements)
SELECT VolunteerProfileID, VolunteerID, Bio, YearsOfExperience, Certificates, Availability, Endorsements FROM VolunteerProfile_old;

DROP TABLE VolunteerProfile_old;

-- 4. Notifications
ALTER TABLE Notifications RENAME TO Notifications_old;

CREATE TABLE Notifications (
    NotificationID INTEGER PRIMARY KEY NOT NULL UNIQUE,
    VolunteerID INTEGER NOT NULL,
    EventID INTEGER,
    Message TEXT NOT NULL,
    MessageTitle TEXT DEFAULT 'Notification: Alert',
    SentTime DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(VolunteerID) REFERENCES Volunteers(VolunteerID) ON DELETE CASCADE,
    FOREIGN KEY(EventID) REFERENCES Events(EventID) ON DELETE CASCADE
);

INSERT INTO Notifications (NotificationID, VolunteerID, EventID, Message, MessageTitle, SentTime)
SELECT NotificationID, VolunteerID, EventID, Message, MessageTitle, SentTime FROM Notifications_old;

DROP TABLE Notifications_old;

-- 5. VolunteerEvents (with CHECK)
ALTER TABLE VolunteerEvents RENAME TO VolunteerEvents_old;

CREATE TABLE VolunteerEvents (
    VolunteerEventID INTEGER PRIMARY KEY NOT NULL UNIQUE,
    VolunteerID INTEGER NOT NULL,
    EventID INTEGER NOT NULL,
    Status TEXT DEFAULT 'Pending' CHECK(Status IN ('Pending','Confirmed','Cancelled')),
    FOREIGN KEY(VolunteerID) REFERENCES Volunteers(VolunteerID) ON DELETE CASCADE,
    FOREIGN KEY(EventID) REFERENCES Events(EventID) ON DELETE CASCADE
);

INSERT INTO VolunteerEvents (VolunteerEventID, VolunteerID, EventID, Status)
SELECT VolunteerEventID, VolunteerID, EventID, Status FROM VolunteerEvents_old;

DROP TABLE VolunteerEvents_old;

-- 6. EventRequirements
ALTER TABLE EventRequirements RENAME TO EventRequirements_old;

CREATE TABLE EventRequirements (
    EventReqID INTEGER PRIMARY KEY NOT NULL UNIQUE,
    SkillID INTEGER NOT NULL,
    N0_OfPeopleRequired INTEGER NOT NULL,
    EventID INTEGER NOT NULL,
    EventSize INTEGER NOT NULL,
    FOREIGN KEY(SkillID) REFERENCES Skill(SkillID) ON DELETE CASCADE,
    FOREIGN KEY(EventID) REFERENCES Events(EventID) ON DELETE CASCADE
);

INSERT INTO EventRequirements (EventReqID, SkillID, N0_OfPeopleRequired, EventID, EventSize)
SELECT EventReqID, SkillID, N0_OfPeopleRequired, EventID, EventSize FROM EventRequirements_old;

DROP TABLE EventRequirements_old;

-- 7. Events
ALTER TABLE Events RENAME TO Events_old;

CREATE TABLE Events (
    EventID INTEGER PRIMARY KEY NOT NULL UNIQUE,
    EventName TEXT NOT NULL,
    EventDate DATE NOT NULL,
    EventDuration INTEGER NOT NULL,
    EventStartTime TIME NOT NULL,
    EventEndTime TIME NOT NULL,
    CompanyID INTEGER NOT NULL,
    EventLocation TEXT NOT NULL,
    EventFee REAL DEFAULT 0,
    EventManager INTEGER,
    FOREIGN KEY(CompanyID) REFERENCES Companies(CompanyID) ON DELETE CASCADE,
    FOREIGN KEY(EventManager) REFERENCES Users(UserID) ON DELETE CASCADE
);

INSERT INTO Events (EventID, EventName, EventDate, EventDuration, EventStartTime, EventEndTime, CompanyID, EventLocation, EventFee, EventManager)
SELECT EventID, EventName, EventDate, EventDuration, EventStartTime, EventEndTime, CompanyID, EventLocation, EventFee, EventManager FROM Events_old;

DROP TABLE Events_old;
