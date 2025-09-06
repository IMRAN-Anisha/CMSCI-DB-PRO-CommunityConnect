PRAGMA foreign_keys = OFF;

-- Drop tables in correct order
DROP TABLE IF EXISTS EventRequirements;
DROP TABLE IF EXISTS VolunteerEvents;
DROP TABLE IF EXISTS Notifications;
DROP TABLE IF EXISTS VolunteerProfile;
DROP TABLE IF EXISTS VolunteerSkills;
DROP TABLE IF EXISTS Skill;
DROP TABLE IF EXISTS Events;
DROP TABLE IF EXISTS Companies;
DROP TABLE IF EXISTS Volunteer;
DROP TABLE IF EXISTS Users;

PRAGMA foreign_keys = ON;

--------------------------------------------------
-- USERS
--------------------------------------------------
CREATE TABLE Users (
    UserID INTEGER PRIMARY KEY AUTOINCREMENT,
    Email TEXT NOT NULL UNIQUE,
    Username TEXT NOT NULL UNIQUE,
    Password TEXT NOT NULL,
    Role TEXT NOT NULL
);

INSERT INTO Users (Email, Username, Password, Role) VALUES
('alice@example.com', 'alice', 'hashed_pw1', 'Volunteer'),
('bob@example.com', 'bob', 'hashed_pw2', 'Volunteer'),
('carol@example.com', 'carol', 'hashed_pw3', 'Company'),
('dave@example.com', 'dave', 'hashed_pw4', 'Company'),
('eve@example.com', 'eve', 'hashed_pw5', 'Admin');

--------------------------------------------------
-- VOLUNTEERS
--------------------------------------------------
CREATE TABLE Volunteer (
    VolunteerID INTEGER PRIMARY KEY AUTOINCREMENT,
    FirstName TEXT NOT NULL,
    LastName TEXT NOT NULL,
    DOB DATE NOT NULL,
    PhoneNumber TEXT NOT NULL,
    Address TEXT NOT NULL,
    UserID INTEGER NOT NULL,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);

INSERT INTO Volunteer (FirstName, LastName, DOB, PhoneNumber, Address, UserID) VALUES
('Alice', 'Johnson', '2000-05-12', '0401000001', '123 Main St', 1),
('Bob', 'Smith', '1999-07-23', '0401000002', '45 River Rd', 2),
('Clara', 'Brown', '2001-02-10', '0401000003', '67 Oak Ave', 1),
('Daniel', 'White', '1998-11-03', '0401000004', '89 Pine St', 2),
('Ella', 'Green', '2002-09-15', '0401000005', '12 Willow Ln', 1);

--------------------------------------------------
-- SKILL
--------------------------------------------------
CREATE TABLE Skill (
    SkillID INTEGER PRIMARY KEY AUTOINCREMENT,
    Communication BOOLEAN DEFAULT FALSE,
    Teamwork BOOLEAN DEFAULT FALSE,
    Leadership BOOLEAN DEFAULT FALSE,
    ProblemSolving BOOLEAN DEFAULT FALSE,
    TimeManagement BOOLEAN DEFAULT FALSE,
    Organisation BOOLEAN DEFAULT FALSE,
    Fundraising BOOLEAN DEFAULT FALSE,
    EventPlanning BOOLEAN DEFAULT FALSE,
    MediaManage BOOLEAN DEFAULT FALSE,
    PublicSpeaking BOOLEAN DEFAULT FALSE,
    Marketing BOOLEAN DEFAULT FALSE,
    FirstAid BOOLEAN DEFAULT FALSE,
    Childcare BOOLEAN DEFAULT FALSE,
    DisabilitySupport BOOLEAN DEFAULT FALSE,
    Multilingual BOOLEAN DEFAULT FALSE,
    Translation BOOLEAN DEFAULT FALSE,
    ITSupport BOOLEAN DEFAULT FALSE,
    Photography BOOLEAN DEFAULT FALSE,
    AnimalCare BOOLEAN DEFAULT FALSE
);

INSERT INTO Skill (Communication, Teamwork, Leadership, ProblemSolving, ITSupport) VALUES
(1,1,0,1,1),
(1,1,1,0,0),
(0,1,1,1,0),
(1,0,0,1,1),
(1,1,1,1,1);

--------------------------------------------------
-- VOLUNTEERSKILLS
--------------------------------------------------
CREATE TABLE VolunteerSkills (
    VolunteerSkillID INTEGER PRIMARY KEY AUTOINCREMENT,
    VolunteerID INTEGER NOT NULL,
    SkillID INTEGER NOT NULL,
    FOREIGN KEY (VolunteerID) REFERENCES Volunteer(VolunteerID) ON DELETE CASCADE,
    FOREIGN KEY (SkillID) REFERENCES Skill(SkillID) ON DELETE CASCADE
);

INSERT INTO VolunteerSkills (VolunteerID, SkillID) VALUES
(1, 1), 
(2, 2),
(3, 1), 
(4, 3), 
(5, 2);

--------------------------------------------------
-- COMPANIES
--------------------------------------------------
CREATE TABLE Companies (
    CompanyID INTEGER PRIMARY KEY AUTOINCREMENT,
    CompanyName TEXT NOT NULL,
    CompanyEmail TEXT NOT NULL UNIQUE,
    CompanyPhone TEXT NOT NULL,
    CompanyLocation TEXT NOT NULL,
    CompanyWebsite TEXT,
    CompanyCEO TEXT,
    UserID INTEGER NOT NULL,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);

INSERT INTO Companies (CompanyName, CompanyEmail, CompanyPhone, CompanyLocation, CompanyWebsite, CompanyCEO, UserID) VALUES
('Helping Hands', 'contact@helpinghands.org', '0891111111', 'Perth', 'www.helpinghands.org', 'Sarah Lee', 3),
('Green Earth', 'info@greenearth.com', '0892222222', 'Sydney', 'www.greenearth.com', 'Tom Hill', 4),
('Future Minds', 'support@futureminds.edu', '0893333333', 'Melbourne', 'www.futureminds.edu', 'Linda Scott', 3),
('Animal Care', 'hello@animalcare.org', '0894444444', 'Adelaide', 'www.animalcare.org', 'James King', 4),
('Food Bank', 'team@foodbank.org', '0895555555', 'Brisbane', 'www.foodbank.org', 'Emma Turner', 3);

--------------------------------------------------
-- EVENTS
--------------------------------------------------
CREATE TABLE Events (
    EventID INTEGER PRIMARY KEY AUTOINCREMENT,
    EventName TEXT NOT NULL,
    EventDate DATE NOT NULL,
    EventDuration INTEGER NOT NULL,
    EventStartTime TIME NOT NULL,
    EventEndTime TIME NOT NULL,
    CompanyID INTEGER NOT NULL,
    EventLocation TEXT NOT NULL,
    EventFee REAL DEFAULT 0,
    EventManager INTEGER,
    FOREIGN KEY (CompanyID) REFERENCES Companies(CompanyID),
    FOREIGN KEY (EventManager) REFERENCES Users(UserID)
);

INSERT INTO Events (EventName, EventDate, EventDuration, EventStartTime, EventEndTime, CompanyID, EventLocation, EventFee, EventManager) VALUES
('Tree Planting', '2025-09-20', 180, '09:00', '12:00', 1, 'Kings Park, Perth', 0, 3),
('Beach Cleanup', '2025-09-22', 240, '08:00', '12:00', 2, 'Bondi Beach, Sydney', 0, 4),
('STEM Workshop', '2025-09-25', 120, '10:00', '12:00', 3, 'Tech Hub, Melbourne', 10, 3),
('Animal Shelter Day', '2025-09-27', 300, '09:00', '14:00', 4, 'City Shelter, Adelaide', 0, 4),
('Food Drive', '2025-09-30', 360, '08:00', '14:00', 5, 'Central Market, Brisbane', 0, 3);

--------------------------------------------------
-- VOLUNTEERPROFILE
--------------------------------------------------
CREATE TABLE VolunteerProfile (
    VolunteerProfileID INTEGER PRIMARY KEY AUTOINCREMENT,
    VolunteerID INTEGER NOT NULL,
    Bio TEXT,
    YearsOfExperience INTEGER,
    Certificates TEXT,
    Availability TEXT,
    Endorsements TEXT,
    Profile_Image_URL TEXT,
    FOREIGN KEY (VolunteerID) REFERENCES Volunteer(VolunteerID) ON DELETE CASCADE
);

INSERT INTO VolunteerProfile (VolunteerID, Bio, YearsOfExperience, Certificates, Availability, Endorsements, Profile_Image_URL) VALUES
(1, 'Passionate about the environment', 2, 'First Aid', 'Weekends', 'Great teamwork', '/static/images/profiles/alice.png'),
(2, 'Experienced in fundraising', 3, 'Childcare Cert', 'Weekdays', 'Reliable and punctual', '/static/images/profiles/bob.png'),
(3, 'Loves working with kids', 1, 'Working with Children Check', 'Evenings', 'Very energetic', '/static/images/profiles/clara.png'),
(4, 'Background in logistics', 4, 'Leadership Cert', 'Weekdays/Weekends', 'Excellent planner', '/static/images/profiles/daniel.png'),
(5, 'First aid certified, loves animals', 2, 'First Aid, Animal Care', 'Flexible', 'Highly recommended', '/static/images/profiles/ella.png');

--------------------------------------------------
-- NOTIFICATIONS
--------------------------------------------------
CREATE TABLE Notifications (
    NotificationID INTEGER PRIMARY KEY AUTOINCREMENT,
    VolunteerID INTEGER NOT NULL,
    EventID INTEGER,
    Message TEXT NOT NULL,
    MessageTitle TEXT DEFAULT 'Notification: Alert',
    SentTime DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (VolunteerID) REFERENCES Volunteer(VolunteerID),
    FOREIGN KEY (EventID) REFERENCES Events(EventID)
);

INSERT INTO Notifications (VolunteerID, EventID, Message) VALUES
(1, 1, 'Reminder: Tree Planting this weekend'),
(2, 2, 'You are registered for Beach Cleanup'),
(3, 3, 'New event: STEM Workshop available'),
(4, 4, 'Shift update for Animal Shelter Day'),
(5, 5, 'Food Drive volunteer spots confirmed');

--------------------------------------------------
-- VOLUNTEEREVENTS
--------------------------------------------------
CREATE TABLE VolunteerEvents (
    VolunteerEventID INTEGER PRIMARY KEY AUTOINCREMENT,
    VolunteerID INTEGER NOT NULL,
    EventID INTEGER NOT NULL,
    Status TEXT DEFAULT 'Pending',
    FOREIGN KEY (VolunteerID) REFERENCES Volunteer(VolunteerID),
    FOREIGN KEY (EventID) REFERENCES Events(EventID)
);

INSERT INTO VolunteerEvents (VolunteerID, EventID, Status) VALUES
(1,1,'Confirmed'),
(2,2,'Pending'),
(3,3,'Confirmed'),
(4,4,'Cancelled'),
(5,5,'Pending');

--------------------------------------------------
-- EVENTREQUIREMENTS
--------------------------------------------------
CREATE TABLE EventRequirements (
    EventReqID INTEGER PRIMARY KEY AUTOINCREMENT,
    SkillID INTEGER NOT NULL,
    NoOfPeopleRequired INTEGER NOT NULL,
    EventID INTEGER NOT NULL,
    EventSize INTEGER NOT NULL,
    FOREIGN KEY (SkillID) REFERENCES Skill(SkillID),
    FOREIGN KEY (EventID) REFERENCES Events(EventID)
);

INSERT INTO EventRequirements (SkillID, NoOfPeopleRequired, EventID, EventSize) VALUES
(1, 5, 1, 20),
(2, 3, 2, 15),
(3, 2, 3, 10),
(4, 4, 4, 25),
(5, 6, 5, 30);
