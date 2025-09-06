-- -----------------------------
-- 1. Drop all tables if they exist
-- -----------------------------
DROP TABLE IF EXISTS volunteerevents;
DROP TABLE IF EXISTS eventrequirement;
DROP TABLE IF EXISTS notifications;
DROP TABLE IF EXISTS volunteerprofile;
DROP TABLE IF EXISTS events;
DROP TABLE IF EXISTS companies;
DROP TABLE IF EXISTS volunteer;
DROP TABLE IF EXISTS skill;
DROP TABLE IF EXISTS users;

-- -----------------------------
-- 2. Recreate tables
-- -----------------------------
CREATE TABLE users (
    UserID INTEGER PRIMARY KEY,
    Email TEXT NOT NULL UNIQUE,
    Username TEXT NOT NULL,
    Password TEXT NOT NULL,
    Role TEXT NOT NULL
);

CREATE TABLE volunteer (
    VolunteerID INTEGER PRIMARY KEY,
    FirstName TEXT NOT NULL,
    LastName TEXT NOT NULL,
    DOB DATE NOT NULL,
    PhoneNumber TEXT NOT NULL,
    Address TEXT NOT NULL,
    UserID INTEGER NOT NULL,
    FOREIGN KEY (UserID) REFERENCES users(UserID) ON DELETE CASCADE
);

CREATE TABLE volunteerprofile (
    VolunteerProfileID INTEGER PRIMARY KEY,
    VolunteerID INTEGER NOT NULL,
    Bio TEXT NOT NULL,
    YearsOfExperience INTEGER NOT NULL,
    Certificates TEXT NOT NULL,
    Availability TEXT NOT NULL,
    Endorsements TEXT NOT NULL,
    profile_image_url TEXT NOT NULL,
    FOREIGN KEY (VolunteerID) REFERENCES volunteer(VolunteerID) ON DELETE CASCADE
);

CREATE TABLE companies (
    CompanyID INTEGER PRIMARY KEY,
    CompanyName TEXT NOT NULL,
    CompanyEmail TEXT NOT NULL,
    CompanyPhone TEXT NOT NULL,
    CompanyLocation TEXT NOT NULL,
    CompanyWebsite TEXT NOT NULL,
    CompanyCEO TEXT NOT NULL,
    UserID INTEGER NOT NULL,
    FOREIGN KEY (UserID) REFERENCES users(UserID) ON DELETE CASCADE
);

CREATE TABLE skill (
    SkillID INTEGER PRIMARY KEY,
    Communication BOOLEAN NOT NULL,
    Teamwork BOOLEAN NOT NULL,
    Leadership BOOLEAN NOT NULL,
    ProblemSolving BOOLEAN NOT NULL,
    TimeManagement BOOLEAN NOT NULL,
    Organisation BOOLEAN NOT NULL,
    Fundraising BOOLEAN NOT NULL,
    EventPlanning BOOLEAN NOT NULL,
    MediaManagement BOOLEAN NOT NULL,
    PublicSpeaking BOOLEAN NOT NULL,
    Marketing BOOLEAN NOT NULL,
    FirstAid BOOLEAN NOT NULL,
    ChildCare BOOLEAN NOT NULL,
    DisabilitySupport BOOLEAN NOT NULL,
    AgedCare BOOLEAN NOT NULL,
    Multilingual BOOLEAN NOT NULL,
    Translation BOOLEAN NOT NULL,
    ITSupport BOOLEAN NOT NULL,
    Photography BOOLEAN NOT NULL,
    AnimalCare BOOLEAN NOT NULL
);

CREATE TABLE events (
    EventID INTEGER PRIMARY KEY,
    EventName TEXT NOT NULL,
    EventDate DATE NOT NULL,
    EventDuration TEXT NOT NULL,
    EventStartTime TEXT NOT NULL,
    EventEndTime TEXT NOT NULL,
    EventLocation TEXT NOT NULL,
    EventFee REAL NOT NULL,
    EventManager TEXT NOT NULL,
    CompanyID INTEGER NOT NULL,
    FOREIGN KEY (CompanyID) REFERENCES companies(CompanyID) ON DELETE CASCADE
);

CREATE TABLE notifications (
    NotificationID INTEGER PRIMARY KEY,
    VolunteerID INTEGER NOT NULL,
    EventID INTEGER NOT NULL,
    Message TEXT NOT NULL,
    MessageTitle TEXT NOT NULL,
    SentTime TEXT NOT NULL,
    FOREIGN KEY (VolunteerID) REFERENCES volunteer(VolunteerID) ON DELETE CASCADE,
    FOREIGN KEY (EventID) REFERENCES events(EventID) ON DELETE CASCADE
);

CREATE TABLE eventrequirement (
    EventReqID INTEGER PRIMARY KEY,
    SkillID INTEGER NOT NULL,
    NoOfPeopleReq INTEGER NOT NULL,
    EventID INTEGER NOT NULL,
    EventSize TEXT NOT NULL,
    FOREIGN KEY (SkillID) REFERENCES skill(SkillID) ON DELETE CASCADE,
    FOREIGN KEY (EventID) REFERENCES events(EventID) ON DELETE CASCADE
);

CREATE TABLE volunteerevents (
    VolunteerEventID INTEGER PRIMARY KEY,
    VolunteerID INTEGER NOT NULL,
    EventID INTEGER NOT NULL,
    Status TEXT NOT NULL,
    FOREIGN KEY (VolunteerID) REFERENCES volunteer(VolunteerID) ON DELETE CASCADE,
    FOREIGN KEY (EventID) REFERENCES events(EventID) ON DELETE CASCADE
);

-- -----------------------------
-- 3. Insert 5 sample rows in each table
-- -----------------------------

-- Users
INSERT INTO users (Email, Username, Password, Role) VALUES
('alice@example.com', 'Alice Smith', 'pass1', 'volunteer'),
('bob@example.com', 'Bob Johnson', 'pass2', 'volunteer'),
('carol@example.com', 'Carol Lee', 'pass3', 'volunteer'),
('dave@example.com', 'Dave Kim', 'pass4', 'volunteer'),
('eve@example.com', 'Eve Clark', 'pass5', 'organisation');

-- Volunteers
INSERT INTO volunteer (FirstName, LastName, DOB, PhoneNumber, Address, UserID) VALUES
('Alice', 'Smith', '1995-01-01', '111111111', '123 Main St', 1),
('Bob', 'Johnson', '1993-05-12', '222222222', '456 Oak St', 2),
('Carol', 'Lee', '1998-07-20', '333333333', '789 Pine St', 3),
('Dave', 'Kim', '1990-03-15', '444444444', '101 Maple St', 4),
('Eve', 'Clark', '1992-09-30', '555555555', '202 Elm St', 5);

-- Volunteer Profiles
INSERT INTO volunteerprofile (VolunteerID, Bio, YearsOfExperience, Certificates, Availability, Endorsements, profile_image_url) VALUES
(1, 'Passionate about helping.', 2, 'CPR', 'Weekends', 'None', 'static/images/defaultProfileImage.png'),
(2, 'Animal lover.', 3, 'First Aid', 'Weekdays', 'None', 'static/images/defaultProfileImage.png'),
(3, 'Community volunteer.', 1, 'CPR', 'Weekends', 'None', 'static/images/defaultProfileImage.png'),
(4, 'Event organizer.', 4, 'CPR, First Aid', 'Evenings', 'None', 'static/images/defaultProfileImage.png'),
(5, 'Corporate volunteer.', 5, 'Leadership', 'Weekdays', 'None', 'static/images/defaultProfileImage.png');

-- Companies
INSERT INTO companies (CompanyName, CompanyEmail, CompanyPhone, CompanyLocation, CompanyWebsite, CompanyCEO, UserID) VALUES
('Helping Hands', 'contact@helpinghands.com', '987654321', 'City Center', 'www.helpinghands.com', 'CEO A', 5),
('Animal Care Org', 'info@animalcare.com', '123123123', 'Town Hall', 'www.animalcare.com', 'CEO B', 5),
('Green Earth', 'green@earth.com', '321321321', 'Park Ave', 'www.greenearth.com', 'CEO C', 5),
('Food Bank', 'food@bank.com', '456456456', 'Main Street', 'www.foodbank.com', 'CEO D', 5),
('Youth Volunteers', 'youth@volunteer.com', '789789789', 'Downtown', 'www.youthvolunteer.com', 'CEO E', 5);

-- Skills
INSERT INTO skill (Communication, Teamwork, Leadership, ProblemSolving, TimeManagement, Organisation, Fundraising, EventPlanning, MediaManagement, PublicSpeaking, Marketing, FirstAid, ChildCare, DisabilitySupport, AgedCare, Multilingual, Translation, ITSupport, Photography, AnimalCare) VALUES
(1,1,0,1,1,0,0,1,0,1,0,1,0,0,0,1,0,0,0,0),
(1,0,1,0,1,1,0,0,1,0,1,0,1,0,0,0,1,0,0,0),
(0,1,1,0,0,1,1,0,0,1,0,0,1,0,1,0,0,1,0,0),
(1,1,1,1,0,0,1,0,0,0,1,0,0,1,0,0,1,0,1,0),
(0,0,1,1,1,1,0,1,1,0,0,1,0,0,1,0,1,0,0,1);

-- Events
INSERT INTO events (EventName, EventDate, EventDuration, EventStartTime, EventEndTime, EventLocation, EventFee, EventManager, CompanyID) VALUES
('Beach Cleanup', '2025-09-10', '4 hours', '08:00', '12:00', 'Sunny Beach', 5.0, 'Manager A', 1),
('Tree Planting', '2025-09-15', '3 hours', '09:00', '12:00', 'Green Park', 10.5, 'Manager B', 2),
('Food Drive', '2025-10-01', '5 hours', '10:00', '15:00', 'Community Center', 11.0, 'Manager C', 3),
('Animal Shelter Help', '2025-10-05', '4 hours', '08:00', '12:00', 'Animal Shelter', 20.0, 'Manager D', 4),
('Youth Workshop', '2025-11-10', '6 hours', '09:00', '15:00', 'Town Hall', 6.0, 'Manager E', 5);

-- Notifications
INSERT INTO notifications (VolunteerID, EventID, Message, MessageTitle, SentTime) VALUES
(1,1,'Join our Beach Cleanup event!','Beach Cleanup','2025-09-01 10:00'),
(2,2,'Tree Planting this weekend!','Tree Planting','2025-09-05 11:00'),
(3,3,'Food Drive coming soon!','Food Drive','2025-09-20 09:00'),
(4,4,'Help at the Animal Shelter!','Animal Shelter Help','2025-10-01 14:00'),
(5,5,'Attend Youth Workshop!','Youth Workshop','2025-10-30 13:00');

-- Event Requirements
INSERT INTO eventrequirement (SkillID, NoOfPeopleReq, EventID, EventSize) VALUES
(1,5,1,'Small'),
(2,4,2,'Medium'),
(3,6,3,'Large'),
(4,3,4,'Medium'),
(5,2,5,'Small');

-- Volunteer Events
INSERT INTO volunteerevents (VolunteerID, EventID, Status) VALUES
(1,1,'Registered'),
(2,2,'Registered'),
(3,3,'Registered'),
(4,4,'Registered'),
(5,5,'Registered');
