SELECT 
    V.VolunteerID,
    V.FirstName || ' ' || V.LastName AS FullName,
    (strftime('%Y', 'now') - strftime('%Y', V.DOB)) -
    (strftime('%m-%d', 'now') < strftime('%m-%d', V.DOB)) AS Age,
    V.PhoneNumber,
    VP.YearsOfExperience,
    VP.Certificates,
    VP.Availability
FROM volunteer V
JOIN volunteerprofile VP ON V.VolunteerID = VP.VolunteerID
JOIN volunteerevents VE ON V.VolunteerID = VE.VolunteerID
WHERE VE.EventID = ?
