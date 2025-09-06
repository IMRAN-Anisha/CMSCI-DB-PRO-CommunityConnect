SELECT 
    V.VolunteerID, 
    V.FirstName, 
    V.LastName, 
    VP.Bio, 
    VP.YearsOfExperience,
    S.SkillID
FROM volunteer V
INNER JOIN volunteerprofile VP ON V.VolunteerID = VP.VolunteerID
INNER JOIN skill S ON V.VolunteerSkills = S.SkillID;

SELECT 
    V.VolunteerID, 
    V.FirstName, 
    V.LastName, 
    VP.Bio, 
    VP.YearsOfExperience,
    S.SkillID,
    E.EventName,
    E.EventDate
FROM volunteer V
INNER JOIN volunteerprofile VP ON V.VolunteerID = VP.VolunteerID
INNER JOIN skill S ON V.VolunteerSkills = S.SkillID
INNER JOIN volunteerevents VE ON V.VolunteerID = VE.VolunteerID
INNER JOIN events E ON VE.EventID = E.EventID;
