 -- The only difference between these two queries is the condition --
 -- One query has "or User_Contact.ContactTypeID IS NULL" --
 -- and other query has "contact.FirstName IS NOT NULL" --

-- This Query Return 34 Rows -- 
select chd.Id, chd.Name, CONCAT(c.FirstName, ' ', c.MiddleName, ' ', c.LastName) AS 'Parent Name'
from [Kiwi-UAT].[dbo].[Child] chd 
inner join [Kiwi-UAT].[dbo].[User_Child] uchd on chd.Id = uchd.ChildId
inner join [Kiwi-UAT].[dbo].[User] u on uchd.UserId = u.Id
left join [Kiwi-UAT].[dbo].[User_Contact] uc on uc.UserId = u.Id
left join [Kiwi-UAT].[dbo].[Contact] c on uc.ContactId = c.Id
inner join [Kiwi-UAT].[dbo].[Org_Child] oc on uchd.ChildId = oc.ChildId
where oc.SiteId = 335 and oc.IsActive = 1 and chd.IsActive = 1 and uc.ContactTypeId IN (11, 12) and c.FirstName IS NOT NULL
order by chd.Name;


-- This Query Return 240 Rows --
select chd.Id, chd.Name, CONCAT(c.FirstName, ' ', c.MiddleName, ' ', c.LastName) AS 'Parent Name'
from [Kiwi-UAT].[dbo].[Child] chd 
inner join [Kiwi-UAT].[dbo].[User_Child] uchd on chd.Id = uchd.ChildId
inner join [Kiwi-UAT].[dbo].[User] u on uchd.UserId = u.Id
left join [Kiwi-UAT].[dbo].[User_Contact] uc on uc.UserId = u.Id
left join [Kiwi-UAT].[dbo].[Contact] c on uc.ContactId = c.Id
inner join [Kiwi-UAT].[dbo].[Org_Child] oc on uchd.ChildId = oc.ChildId
where oc.SiteId = 335 and oc.IsActive = 1 and chd.IsActive = 1 and (uc.ContactTypeId IN (11, 12) or uc.ContactTypeId IS NULL)
order by chd.Name;