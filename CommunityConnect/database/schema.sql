-- ===============================
-- Users table
-- ===============================
CREATE TABLE Users (
    UserID INTEGER PRIMARY KEY AUTOINCREMENT,
    Email TEXT NOT NULL UNIQUE,
    UserName TEXT NOT NULL,
    Password TEXT NOT NULL,
    Role TEXT CHECK (Role IN ('Volunteer', 'CompanyRep', 'Admin'))
);

-- ===============================
-- Volunteer table
-- ===============================
CREATE TABLE Volunteer (
    VolunteerID INTEGER PRIMARY KEY AUTOINCREMENT,
    FirstName TEXT NOT NULL,
    LastName TEXT NOT NULL,
    DOB DATE NOT NULL,
    PhoneNumber TEXT,
    Address TEXT,
    UserID INTEGER,
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- ===============================
-- Company table
-- ===============================
CREATE TABLE Company (
    CompanyID INTEGER PRIMARY KEY AUTOINCREMENT,
    CompanyName TEXT NOT NULL,
    CompanyEmail TEXT NOT NULL UNIQUE,
    CompanyPhone TEXT,
    CompanyLocation TEXT,
    CompanyWebsite TEXT,
    CompanyCEO TEXT,
    UserID INTEGER,
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- ===============================
-- Event table
-- ===============================
CREATE TABLE Event (
    EventID INTEGER PRIMARY KEY AUTOINCREMENT,
    EventName TEXT NOT NULL,
    EventDate DATE NOT NULL,
    EventDuration TEXT,
    EventStartTime TIME,
    EventEndTime TIME,
    OrganisationID INTEGER NOT NULL,
    EventLocation TEXT,
    EventFee REAL,
    EventManager TEXT,
    EventMaxTickets INTEGER,
    FOREIGN KEY (OrganisationID) REFERENCES Company(CompanyID)
);

-- ===============================
-- VolunteerProfile table
-- ===============================
CREATE TABLE Volunteer_Profile (
    VolunteerProfileID INTEGER PRIMARY KEY AUTOINCREMENT,
    VolunteerID INTEGER NOT NULL,
    Bio TEXT,
    YearsOfExperience INTEGER,
    Certificates TEXT,
    Availability TEXT,
    Endorsements TEXT,
    FOREIGN KEY (VolunteerID) REFERENCES Volunteer(VolunteerID)
);

-- ===============================
-- Skills table
-- ===============================
CREATE TABLE Skill (
    SkillID INTEGER PRIMARY KEY AUTOINCREMENT,
    SkillName TEXT NOT NULL UNIQUE
);

-- Junction table: Volunteer_Skills (M:N)
CREATE TABLE Volunteer_Skills (
    VolunteerID INTEGER,
    SkillID INTEGER,
    PRIMARY KEY (VolunteerID, SkillID),
    FOREIGN KEY (VolunteerID) REFERENCES Volunteer(VolunteerID) ON DELETE CASCADE,
    FOREIGN KEY (SkillID) REFERENCES Skill(SkillID) ON DELETE CASCADE
);

-- ===============================
-- Notifications table
-- ===============================
CREATE TABLE Notifications (
    NotificationID INTEGER PRIMARY KEY AUTOINCREMENT,
    VolunteerID INTEGER,
    EventID INTEGER,
    MessageTitle TEXT NOT NULL,
    Message TEXT NOT NULL,
    SentTime DATETIME DEFAULT CURRENT_TIMESTAMP,
    ReadStatus BOOLEAN DEFAULT 0,
    PriorityLevel TEXT DEFAULT 'Low',
    FOREIGN KEY (VolunteerID) REFERENCES Volunteer(VolunteerID) ON DELETE CASCADE,
    FOREIGN KEY (EventID) REFERENCES Event(EventID) ON DELETE CASCADE
);

-- ===============================
-- Volunteer_Events junction table (Volunteers ↔ Events M:N)
-- ===============================
CREATE TABLE Volunteer_Events (
    VolunteerID INTEGER,
    EventID INTEGER,
    SignUpDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (VolunteerID, EventID),
    FOREIGN KEY (VolunteerID) REFERENCES Volunteer(VolunteerID) ON DELETE CASCADE,
    FOREIGN KEY (EventID) REFERENCES Event(EventID) ON DELETE CASCADE
);
