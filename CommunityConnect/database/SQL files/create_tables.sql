CREATE TABLE users (
    UserID INTEGER PRIMARY KEY,
    Email TEXT NOT NULL,
    Username TEXT NOT NULL,
    Password TEXT NOT NULL,
    Role TEXT NOT NULL
);

CREATE TABLE volunteer (
    VolunteerID INTEGER PRIMARY KEY,
    FirstName TEXT NOT NULL,
    LastName TEXT NOT NULL,
    DOB DATE,
    PhoneNumber TEXT,
    Address TEXT,
    VolunteerSkills INTEGER,
    UserID INTEGER,
    FOREIGN KEY (UserID) REFERENCES users(UserID)
);

CREATE TABLE companies (
    CompanyID INTEGER PRIMARY KEY,
    CompanyName TEXT NOT NULL,
    CompanyEmail TEXT,
    CompanyPhone TEXT,
    CompanyLocation TEXT,
    CompanyWebsite TEXT,
    CompanyCEO TEXT,
    UserID INTEGER,
    FOREIGN KEY (UserID) REFERENCES users(UserID)
);

CREATE TABLE events (
    EventID INTEGER PRIMARY KEY,
    EventName TEXT NOT NULL,
    EventDate DATE,
    EventDuration TEXT,
    EventStartTime TEXT,
    EventEndTime TEXT,
    EventLocation TEXT,
    EventFee REAL,
    EventManager TEXT,
    CompanyID INTEGER,
    FOREIGN KEY (CompanyID) REFERENCES companies(CompanyID)
);

CREATE TABLE volunteerprofile (
    VolunteerProfileID INTEGER PRIMARY KEY,
    VolunteerID INTEGER,
    Bio TEXT,
    YearsOfExperience INTEGER,
    Certificates TEXT,
    Availability TEXT,
    Endorsements TEXT,
    FOREIGN KEY (VolunteerID) REFERENCES volunteer(VolunteerID)
);

CREATE TABLE skill (
    SkillID INTEGER PRIMARY KEY,
    Communication INTEGER,
    Teamwork INTEGER,
    Leadership INTEGER,
    ProblemSolving INTEGER,
    TimeManagement INTEGER,
    Organisation INTEGER,
    Fundraising INTEGER,
    EventPlanning INTEGER,
    MediaManagement INTEGER,
    PublicSpeaking INTEGER,
    Marketing INTEGER,
    FirstAid INTEGER,
    ChildCare INTEGER,
    DisabilitySupport INTEGER,
    AgedCare INTEGER,
    Multilingual INTEGER,
    Translation INTEGER,
    ITSupport INTEGER,
    Photography INTEGER,
    AnimalCare INTEGER
);

CREATE TABLE notifications (
    NotificationID INTEGER PRIMARY KEY,
    VolunteerID INTEGER,
    EventID INTEGER,
    Message TEXT,
    MessageTitle TEXT,
    SentTime TEXT,
    FOREIGN KEY (VolunteerID) REFERENCES volunteer(VolunteerID),
    FOREIGN KEY (EventID) REFERENCES events(EventID)
);

CREATE TABLE eventrequirement (
    EventReqID INTEGER PRIMARY KEY,
    SkillID INTEGER,
    NoOfPeopleReq INTEGER,
    EventID INTEGER,
    EventSize TEXT,
    FOREIGN KEY (SkillID) REFERENCES skill(SkillID),
    FOREIGN KEY (EventID) REFERENCES events(EventID)
);

CREATE TABLE volunteerevents (
    VolunteerEventID INTEGER PRIMARY KEY,
    VolunteerID INTEGER,
    EventID INTEGER,
    Status TEXT,
    FOREIGN KEY (VolunteerID) REFERENCES volunteer(VolunteerID),
    FOREIGN KEY (EventID) REFERENCES events(EventID)
);