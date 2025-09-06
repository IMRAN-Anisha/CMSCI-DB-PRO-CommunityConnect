-- 1. Count volunteers per skill
SELECT 
    S.SkillID,
    COUNT(V.VolunteerID) AS TotalVolunteers
FROM volunteer V
INNER JOIN skill S ON V.VolunteerSkills = S.SkillID
GROUP BY S.SkillID;

-- 2. Total volunteers per event
SELECT 
    E.EventID,
    E.EventName,
    COUNT(VE.VolunteerID) AS TotalVolunteers
FROM events E
INNER JOIN volunteerevents VE ON E.EventID = VE.EventID
GROUP BY E.EventID, E.EventName;

-- 3. Average experience per skill
SELECT 
    S.SkillID,
    AVG(VP.YearsOfExperience) AS AvgExperience
FROM volunteer V
INNER JOIN volunteerprofile VP ON V.VolunteerID = VP.VolunteerID
INNER JOIN skill S ON V.VolunteerSkills = S.SkillID
GROUP BY S.SkillID;

-- 4. Minimum and maximum experience per skill
SELECT 
    S.SkillID,
    MIN(VP.YearsOfExperience) AS MinExperience,
    MAX(VP.YearsOfExperience) AS MaxExperience
FROM volunteer V
INNER JOIN volunteerprofile VP ON V.VolunteerID = VP.VolunteerID
INNER JOIN skill S ON V.VolunteerSkills = S.SkillID
GROUP BY S.SkillID;

-- 5. Total events and sum of fees per company
SELECT 
    C.CompanyID,
    C.CompanyName,
    COUNT(E.EventID) AS TotalEvents,
    SUM(E.EventFee) AS TotalFeesCollected
FROM companies C
INNER JOIN events E ON C.CompanyID = E.CompanyID
GROUP BY C.CompanyID, C.CompanyName;

-- 6. Combined statistics grouped by skill
SELECT
    S.SkillID,
    COUNT(DISTINCT V.VolunteerID) AS TotalVolunteers,
    AVG(VP.YearsOfExperience) AS AvgExperience,
    MIN(VP.YearsOfExperience) AS MinExperience,
    MAX(VP.YearsOfExperience) AS MaxExperience
FROM volunteer V
INNER JOIN volunteerprofile VP ON V.VolunteerID = VP.VolunteerID
INNER JOIN skill S ON V.VolunteerSkills = S.SkillID
GROUP BY S.SkillID;
