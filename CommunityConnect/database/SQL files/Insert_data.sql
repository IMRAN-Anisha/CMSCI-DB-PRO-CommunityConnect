-- Users
INSERT INTO users VALUES 
(1, 'alice@example.com', 'alice123', 'pass1', 'Volunteer and student'),
(2, 'bob@example.com', 'bob99', 'pass2', 'Corporate manager'),
(3, 'carol@example.com', 'carol88', 'pass3', 'Animal lover and activist'),
(4, 'dave@example.com', 'dave22', 'pass4', 'Photographer and traveller'),
(5, 'eve@example.com', 'eve77', 'pass5', 'Event coordinator');

-- Volunteers
INSERT INTO volunteer VALUES
(1, 'Alice', 'Smith', '2001-05-12', '0411111111', '123 Perth St', 1, 1),
(2, 'John', 'Doe', '1999-08-22', '0422222222', '456 Sydney Rd', 2, 2),
(3, 'Sara', 'Lee', '2002-03-15', '0433333333', '789 Brisbane Ave', 3, 3),
(4, 'Mike', 'Brown', '2000-10-05', '0444444444', '321 Adelaide Blvd', 4, 4),
(5, 'Emma', 'Davis', '2001-12-01', '0455555555', '654 Melbourne Dr', 5, 5);

-- Companies
INSERT INTO companies VALUES
(1, 'Tech4Good', 'info@tech4good.com', '0891111111', 'Perth', 'www.tech4good.com', 'Sam Green', 2),
(2, 'CareWell', 'contact@carewell.com', '0892222222', 'Sydney', 'www.carewell.com', 'Linda White', 3),
(3, 'EcoFuture', 'hello@ecofuture.com', '0893333333', 'Melbourne', 'www.ecofuture.com', 'James Black', 4),
(4, 'EduPlus', 'support@eduplus.com', '0894444444', 'Brisbane', 'www.eduplus.com', 'Sophia Grey', 5),
(5, 'HealthAid', 'team@healthaid.com', '0895555555', 'Adelaide', 'www.healthaid.com', 'Tom King', 1);

-- Events
INSERT INTO events VALUES
(1, 'Charity Run', '2025-09-15', '3 hours', '08:00', '11:00', 'Kings Park', 10.0, 'Sam Green', 1),
(2, 'Tree Planting', '2025-09-20', '4 hours', '09:00', '13:00', 'City Gardens', 0.0, 'Linda White', 2),
(3, 'Coding Workshop', '2025-09-25', '2 hours', '14:00', '16:00', 'Tech Hub', 5.0, 'James Black', 3),
(4, 'Food Drive', '2025-10-01', '6 hours', '10:00', '16:00', 'Community Centre', 0.0, 'Sophia Grey', 4),
(5, 'Blood Donation', '2025-10-05', '5 hours', '09:00', '14:00', 'Hospital Hall', 0.0, 'Tom King', 5);

-- VolunteerProfile
INSERT INTO volunteerprofile VALUES
(1, 1, 'Helper', 1, 'First Aid', 'Weekends', 'Reliable'),
(2, 2, 'Team Lead', 3, 'Leadership', 'Weekdays', 'Strong leader'),
(3, 3, 'Support Staff', 2, 'Child Care', 'Flexible', 'Kind'),
(4, 4, 'Coordinator', 4, 'Event Planning', 'Weekends', 'Organised'),
(5, 5, 'Assistant', 1, 'IT Support', 'Weekdays', 'Fast learner');

-- Skills
INSERT INTO skill VALUES
(1,1,1,0,1,1,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0),
(2,1,1,1,1,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0),
(3,1,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0),
(4,0,1,1,0,1,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1),
(5,1,1,0,1,0,1,0,0,0,0,0,1,0,1,0,0,1,0,0,0);

-- Notifications
INSERT INTO notifications VALUES
(1, 1, 1, 'Reminder for event', 'Charity Run', '2025-09-10 09:00'),
(2, 2, 2, 'You are registered', 'Tree Planting', '2025-09-15 12:00'),
(3, 3, 3, 'Event postponed', 'Coding Workshop', '2025-09-18 14:00'),
(4, 4, 4, 'New details added', 'Food Drive', '2025-09-25 10:00'),
(5, 5, 5, 'Thank you for joining', 'Blood Donation', '2025-10-01 11:00');

-- EventRequirement
INSERT INTO eventrequirement VALUES
(1, 1, 10, 1, 'Large'),
(2, 2, 5, 2, 'Medium'),
(3, 3, 15, 3, 'Large'),
(4, 4, 8, 4, 'Medium'),
(5, 5, 12, 5, 'Large');

-- VolunteerEvents
INSERT INTO volunteerevents VALUES
(1, 1, 1, 'Registered'),
(2, 2, 2, 'Confirmed'),
(3, 3, 3, 'Pending'),
(4, 4, 4, 'Attended'),
(5, 5, 5, 'Cancelled');