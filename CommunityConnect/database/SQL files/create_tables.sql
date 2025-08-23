-- ---------------- Users ----------------
CREATE TABLE Users (
    UserID INTEGER PRIMARY KEY NOT NULL UNIQUE,
    Email TEXT NOT NULL UNIQUE,
    Username TEXT NOT NULL UNIQUE,
    Password TEXT NOT NULL,
    Role TEXT NOT NULL
);

-- ---------------- Volunteers ----------------
CREATE TABLE Volunteers (
    VolunteerID INTEGER PRIMARY KEY NOT NULL UNIQUE,
    FirstName TEXT NOT NULL,
    LastName TEXT NOT NULL,
    DOB DATE NOT NULL,
    PhoneNumber TEXT NOT NULL,
    Address TEXT NOT NULL,
    UserID INTEGER NOT NULL,
    FOREIGN KEY(UserID) REFERENCES Users(UserID)
);

-- ---------------- Companies ----------------
CREATE TABLE Companies (
    CompanyID INTEGER PRIMARY KEY NOT NULL UNIQUE,
    CompanyName TEXT NOT NULL,
    CompanyEmail TEXT NOT NULL UNIQUE,
    CompanyPhone TEXT NOT NULL,
    CompanyLocation TEXT NOT NULL,
    CompanyWebsite TEXT NOT NULL,
    CompanyCEO TEXT NOT NULL,
    UserID INTEGER NOT NULL,
    FOREIGN KEY(UserID) REFERENCES Users(UserID)
);

-- ---------------- Events ----------------
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
    FOREIGN KEY(CompanyID) REFERENCES Companies(CompanyID),
    FOREIGN KEY(EventManager) REFERENCES Users(UserID)
);

-- ---------------- Skill ----------------
CREATE TABLE Skill (
    SkillID INTEGER PRIMARY KEY NOT NULL UNIQUE,
    Communication BOOLEAN DEFAULT 0,
    Teamwork BOOLEAN DEFAULT 0,
    Leadership BOOLEAN DEFAULT 0,
    ProblemSolving BOOLEAN DEFAULT 0,
    TimeManagement BOOLEAN DEFAULT 0,
    Organisation BOOLEAN DEFAULT 0,
    Fundraising BOOLEAN DEFAULT 0,
    EventPlanning BOOLEAN DEFAULT 0,
    MediaManage BOOLEAN DEFAULT 0,
    PublicSpeaking BOOLEAN DEFAULT 0,
    Marketing BOOLEAN DEFAULT 0,
    FirstAid BOOLEAN DEFAULT 0,
    Childcare BOOLEAN DEFAULT 0,
    DisabilitySupport BOOLEAN DEFAULT 0,
    Multilingual BOOLEAN DEFAULT 0,
    Translation BOOLEAN DEFAULT 0,
    ITSupport BOOLEAN DEFAULT 0,
    Photography BOOLEAN DEFAULT 0,
    AnimalCare BOOLEAN DEFAULT 0
);

-- ---------------- VolunteerProfile ----------------
CREATE TABLE VolunteerProfile (
    VolunteerProfileID INTEGER PRIMARY KEY NOT NULL UNIQUE,
    VolunteerID INTEGER NOT NULL,
    Bio TEXT,
    YearsOfExperience INTEGER,
    Certificates TEXT,
    Availability TEXT,
    Endorsements TEXT,
    FOREIGN KEY(VolunteerID) REFERENCES Volunteers(VolunteerID)
);

-- ---------------- Notifications ----------------
CREATE TABLE Notifications (
    NotificationID INTEGER PRIMARY KEY NOT NULL UNIQUE,
    VolunteerID INTEGER NOT NULL,
    EventID INTEGER,
    Message TEXT NOT NULL,
    MessageTitle TEXT DEFAULT 'Notification: Alert',
    SentTime DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(VolunteerID) REFERENCES Volunteers(VolunteerID),
    FOREIGN KEY(EventID) REFERENCES Events(EventID)
);

-- ---------------- VolunteerEvents ----------------
CREATE TABLE VolunteerEvents (
    VolunteerEventID INTEGER PRIMARY KEY NOT NULL UNIQUE,
    VolunteerID INTEGER NOT NULL,
    EventID INTEGER NOT NULL,
    Status TEXT DEFAULT 'Pending',
    FOREIGN KEY(VolunteerID) REFERENCES Volunteers(VolunteerID),
    FOREIGN KEY(EventID) REFERENCES Events(EventID)
);

-- ---------------- EventRequirements ----------------
CREATE TABLE EventRequirements (
    EventReqID INTEGER PRIMARY KEY NOT NULL UNIQUE,
    SkillID INTEGER NOT NULL,
    N0_OfPeopleRequired INTEGER NOT NULL,
    EventID INTEGER NOT NULL,
    EventSize INTEGER NOT NULL,
    FOREIGN KEY(SkillID) REFERENCES Skill(SkillID),
    FOREIGN KEY(EventID) REFERENCES Events(EventID)
);
