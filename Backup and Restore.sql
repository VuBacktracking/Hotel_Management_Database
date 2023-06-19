-- Create a login
CREATE LOGIN HoangVu with PassWord = 'Vu@12345';
-- Create user
use Hotel_Restaurant_Management;
Create USER user_hoangvu for Login HoangVu;
-- Authorize users
EXEC sys.sp_addrolemember N'db_datareader', N'user_hoangvu';

if(exists(select * from sysobjects where name =N'BackupDatabase'))
drop procedure BackupDatabase;
GO
create procedure BackupDatabase(@database nvarchar(200),@file_name nvarchar(200))
as
begin
	backup database @database to disk = @file_name
end;
Go
exec BackupDatabase 'Hotel_Restaurant_Management', '~/Hotel_Restaurant_Management.bak'

if(exists(select * from sysobjects where name =N'RestoreDatabase'))
drop procedure RestoreDatabase;
GO
create procedure RestoreDatabse(@tencsdl nvarchar(100),@tenpath nvarchar(256))
as
begin
  restore database @tencsdl from disk = @tenpath
end
GO
exec RestoreDatabse 'Hotel_Restaurant_Management', '~/Hotel_Restaurant_Management.bak';