if not exists(SELECT name FROM master.sys.server_principals WHERE name =  'SocialAdmin')
begin
Create Login [SocialAdmin] With password='s123'
Alter Any Login to [SocialAdmin]
end


use [SocialDevDB]
if not exists(select * from sys.database_principals where name = 'SocialAdmin')
begin
Create User [SocialAdmin] for login SocialAdmin
end
ALTER ROLE [db_datareader] ADD MEMBER [SocialAdmin]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [SocialAdmin]
GO
ALTER ROLE [db_owner] ADD MEMBER [SocialAdmin]
GO


