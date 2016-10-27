-- Display all head office --
SELECT org.Name 
FROM [Kiwi-UAT].[dbo].[Org] org
WHERE TypeId = 3;

-- Display all master franchises --
SELECT org.Name 
FROM [Kiwi-UAT].[dbo].[Org] org
WHERE TypeId = 4;

-- Display all franchises --
SELECT org.Name 
FROM [Kiwi-UAT].[dbo].[Org] org
WHERE TypeId = 5;

-- Display all sites --
SELECT org.Name 
FROM [Kiwi-UAT].[dbo].[Org] org
WHERE TypeId = 6;

-- Display site details which your user belongs to "intern@" --
SELECT *
FROM [Kiwi-UAT].[dbo].[Org] o
INNER JOIN [Kiwi-UAT].[dbo].[SiteGroup] sg on sg.SiteId = o.Id
WHERE sg.CreatedBy LIKE 'intern%';

-- Display all sites which your user have access --
SELECT o.Name
FROM dbo.Org o
INNER JOIN [Kiwi-UAT].[dbo].[UserOrgAccess] ou on o.Id = ou.OrgId
INNER JOIN [Kiwi-UAT].[dbo].[User] u on ou.UserId = u.Id
WHERE ou.IsActive = 1
GROUP BY o.Name;

-- Display all staff details -- 
SELECT CONCAT(c.FirstName, ' ', c.MiddleName, ' ', c.LastName) AS 'Full Name', l.Description AS Role, c.Mobile, CONCAT('Landline: ', c.Landline, ' Office: ', c.Office) AS 'Emergency contact details'
FROM [Kiwi-UAT].[dbo].[User] u
INNER JOIN [Kiwi-UAT].[dbo].[Contact] c on u.ContactId = c.Id
INNER JOIN [Kiwi-UAT].[dbo].[Lookup] l on u.RoleId = l.Id
INNER JOIN [Kiwi-UAT].[dbo].[Org_User] ou on u.Id = ou.UserId
INNER JOIN [Kiwi-UAT].[dbo].[Org] o on ou.OrgId = o.Id
WHERE o.Name LIKE 'Vindya' AND l.Description NOT IN ('Parent') AND l.EntityName LIKE ('UserRole') AND ou.IsActive = 1
ORDER BY c.FirstName;

-- display all parents details --
SELECT CONCAT(c.FirstName, ' ', c.MiddleName, ' ', c.LastName) AS 'Full Name', u.Username, c.Email, c.Mobile, CONCAT(c.StreetNum, ' ', c.Address, ', ', c.Suburb, ', ', c.Postcode, ', ', c.City, ', ', c.Country) AS Address
FROM [Kiwi-UAT].[dbo].[Contact] c
INNER JOIN [Kiwi-UAT].[dbo].[User] u on u.ContactId = c.Id
INNER JOIN [Kiwi-UAT].[dbo].[Lookup] l on u.RoleId = l.Id
INNER JOIN [Kiwi-UAT].[dbo].[Org_User] ou on u.Id = ou.UserId
INNER JOIN [Kiwi-UAT].[dbo].[Org] o on ou.OrgId = o.Id
WHERE l.Id = 9 AND o.Name LIKE 'Vindya' AND ou.IsActive = 1
ORDER BY c.FirstName;

--Display parent name and number of child --
SELECT CONCAT(c.FirstName, ' ', c.MiddleName, ' ', c.LastName) AS 'Parent Name', u.Username, COUNT(uc.ChildId) AS 'Number of Child'
FROM [Kiwi-UAT].[dbo].[User] u
INNER JOIN [Kiwi-UAT].[dbo].[Contact] c on u.ContactId = c.Id
INNER JOIN [Kiwi-UAT].[dbo].[Lookup] l on u.RoleId = l.Id
LEFT JOIN [Kiwi-UAT].[dbo].[User_Child] uc on uc.UserId = u.Id
INNER JOIN [Kiwi-UAT].[dbo].[Org_User] ou on u.Id = ou.UserId
INNER JOIN [Kiwi-UAT].[dbo].[Org] o on ou.OrgId = o.Id
WHERE l.EntityName LIKE 'UserRole' AND l.Description LIKE 'Parent' AND o.Name LIKE 'Vindya' AND ou.IsActive = 1
GROUP BY c.FirstName, c.MiddleName, c.LastName, u.Username
ORDER BY c.LastName;

-- Child list with photo url --
SELECT chd.Name, CONCAT(c.FirstName, ' ', c.MiddleName, ' ', c.LastName) AS 'Parent Name', m.Url AS 'Photo URL'
FROM [Kiwi-UAT].[dbo].[Child] chd
INNER JOIN [Kiwi-UAT].[dbo].[User_Child] uc on uc.ChildId = chd.Id
INNER JOIN [Kiwi-UAT].[dbo].[User] u on uc.UserId = u.Id
INNER JOIN [Kiwi-UAT].[dbo].[Contact] c on u.ContactId = c.Id
INNER JOIN [Kiwi-UAT].[dbo].[Org_Child] oc on chd.Id = oc.ChildId
INNER JOIN [Kiwi-UAT].[dbo].[Org] o on oc.SiteId = o.Id
LEFT JOIN [Kiwi-UAT].[dbo].[Child_Media] cm on cm.ChildId = chd.Id
LEFT JOIN [Kiwi-UAT].[dbo].[Media] m on cm.MediaId = m.Id
WHERE (o.Name LIKE 'Vindya') AND (chd.IsActive = 1) AND oc.IsActive = 1
ORDER BY chd.Name;

-- Child list with authorized pickup --
SELECT chd.Id, chd.Name AS 'Child Name', CONCAT(c.FirstName, ' ', c.MiddleName, ' ', c.LastName) AS 'Parent Name'
FROM [Kiwi-UAT].[dbo].[Child] chd
LEFT JOIN [Kiwi-UAT].[dbo].[Child_Contact] cc on cc.ChildId = chd.Id
LEFT JOIN [Kiwi-UAT].[dbo].[Contact] c on cc.ContactId = c.Id
INNER JOIN [Kiwi-UAT].[dbo].[Org_Child] oc on chd.Id = oc.ChildId
INNER JOIN [Kiwi-UAT].[dbo].[Org] o on oc.SiteId = o.Id
WHERE o.Name LIKE 'Vindya' AND oc.IsActive = 1 AND chd.IsActive = 1
GROUP BY chd.Id, chd.Name, c.FirstName, c.MiddleName, c.LastName
ORDER BY chd.Name;

-- Child list with emergency contact --
SELECT chd.Id, chd.Name AS 'Child Name', CONCAT('Parent Name: ', c.FirstName, ' ', c.MiddleName, ' ', c.LastName, 'Mobile: ', c.Mobile, ' Landline: ', c.Landline, ' Office: ', c.Office) AS 'Emergency Contact 1', CONCAT('Parent Name: ', c2.FirstName, ' ', c2.MiddleName, ' ', c2.LastName, 'Mobile: ', c2.Mobile, ' Landline: ', c2.Landline, ' Office: ', c2.Office) AS 'Emergency Contact 2'
FROM [Kiwi-UAT].[dbo].[Child] chd
LEFT JOIN [Kiwi-UAT].[dbo].[Contact] c on chd.EmergencyContact1Id = c.Id
LEFT JOIN [Kiwi-UAT].[dbo].[Contact] c2 on chd.EmergencyContact2Id = c.Id
INNER JOIN [Kiwi-UAT].[dbo].[Org_Child] ou on chd.Id = ou.ChildId
INNER JOIN [Kiwi-UAT].[dbo].[Org] o on ou.SiteId = o.Id
WHERE o.Name LIKE 'Vindya' AND ou.IsActive = 1 AND chd.IsActive = 1
ORDER BY chd.Name;

--Child List with medical condition --
SELECT chd.Id, chd.Name AS 'Child Name', cond.Name AS 'Medical Condition', cc.Symptoms AS 'Symptoms', cc.TreatmentDesc AS 'Treatment'
FROM [Kiwi-UAT].[dbo].[Child] chd
LEFT JOIN [Kiwi-UAT].[dbo].[Child_Condition] cc ON chd.Id = cc.ChildId
LEFT JOIN [Kiwi-UAT].[dbo].[Condition] cond ON cc.ConditionId = cond.Id
INNER JOIN [Kiwi-UAT].[dbo].[Org_Child] oc on oc.ChildId = chd.Id
INNER JOIN [Kiwi-UAT].[dbo].[Org] o on oc.SiteId = o.Id
WHERE o.Name LIKE 'Vindya' AND chd.IsActive = 1 AND oc.IsActive = 1
ORDER BY chd.Name;