USE [master]
GO
/****** Object:  Database [SocialDevDB]    Script Date: 30.12.2020 17:51:35 ******/
CREATE DATABASE [SocialDevDB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'SocialDevDB', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\SocialDevDB.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'SocialDevDB_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\SocialDevDB_log.ldf' , SIZE = 73728KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [SocialDevDB] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [SocialDevDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [SocialDevDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [SocialDevDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [SocialDevDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [SocialDevDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [SocialDevDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [SocialDevDB] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [SocialDevDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [SocialDevDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [SocialDevDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [SocialDevDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [SocialDevDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [SocialDevDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [SocialDevDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [SocialDevDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [SocialDevDB] SET  DISABLE_BROKER 
GO
ALTER DATABASE [SocialDevDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [SocialDevDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [SocialDevDB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [SocialDevDB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [SocialDevDB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [SocialDevDB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [SocialDevDB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [SocialDevDB] SET RECOVERY FULL 
GO
ALTER DATABASE [SocialDevDB] SET  MULTI_USER 
GO
ALTER DATABASE [SocialDevDB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [SocialDevDB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [SocialDevDB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [SocialDevDB] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [SocialDevDB] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [SocialDevDB] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'SocialDevDB', N'ON'
GO
ALTER DATABASE [SocialDevDB] SET QUERY_STORE = OFF
GO
USE [SocialDevDB]
GO
/****** Object:  User [SocialAdmin]    Script Date: 30.12.2020 17:51:35 ******/
CREATE USER [SocialAdmin] FOR LOGIN [SocialAdmin] WITH DEFAULT_SCHEMA=[Users]
GO
ALTER ROLE [db_owner] ADD MEMBER [SocialAdmin]
GO
ALTER ROLE [db_datareader] ADD MEMBER [SocialAdmin]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [SocialAdmin]
GO
/****** Object:  Schema [Shares]    Script Date: 30.12.2020 17:51:35 ******/
CREATE SCHEMA [Shares]
GO
/****** Object:  Schema [Users]    Script Date: 30.12.2020 17:51:35 ******/
CREATE SCHEMA [Users]
GO
/****** Object:  UserDefinedFunction [Users].[AverageGender]    Script Date: 30.12.2020 17:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Function [Users].[AverageGender](@Gender bit)
Returns float
  as
 begin
 Declare @total float
 set @total=(select COUNT(UserId) from Users.UserAccounts)-1
  declare @Gnd float
	set @Gnd=(select COUNT(UserId) from Users.UserProfile where Gender=@Gender)
 
 Declare @avg float
 Set @avg = @Gnd/@Total
 set @avg=@avg*100
Return @avg

 end
GO
/****** Object:  UserDefinedFunction [Users].[GetFriendStatusText]    Script Date: 30.12.2020 17:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create FUNCTION [Users].[GetFriendStatusText](@Status [tinyint])
RETURNS [nvarchar](15) 
AS 
-- Returns the sales order status text representation for the status value.
BEGIN
    DECLARE @ret [nvarchar](15);

    SET @ret = 
        CASE @Status
            WHEN 0 THEN 'Pending'
            WHEN 1 THEN 'Accepted'
            WHEN 2 THEN 'Rejected'
            ELSE '** Invalid **'
        END;
    
    RETURN @ret
END;
GO
/****** Object:  Table [Users].[ZipCodes]    Script Date: 30.12.2020 17:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Users].[ZipCodes](
	[ZipId] [int] IDENTITY(1,1) NOT NULL,
	[ZipCode] [nvarchar](10) NOT NULL,
	[CityId] [int] NOT NULL,
	[State] [nchar](20) NOT NULL,
	[Province] [nchar](20) NOT NULL,
 CONSTRAINT [PK_ZipCodes] PRIMARY KEY CLUSTERED 
(
	[ZipId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Users].[Cities]    Script Date: 30.12.2020 17:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Users].[Cities](
	[CityId] [int] IDENTITY(1,1) NOT NULL,
	[CountryId] [int] NOT NULL,
	[LocalCityCode] [nvarchar](5) NOT NULL,
	[CityName] [nvarchar](20) NOT NULL,
 CONSTRAINT [PK_Cities] PRIMARY KEY CLUSTERED 
(
	[CityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Users].[Countries]    Script Date: 30.12.2020 17:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Users].[Countries](
	[CountryId] [int] NOT NULL,
	[CountryTag] [nvarchar](3) NOT NULL,
	[CountryName] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Countries] PRIMARY KEY CLUSTERED 
(
	[CountryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [Users].[ViewZipCodeDetails]    Script Date: 30.12.2020 17:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [Users].[ViewZipCodeDetails]
AS
SELECT zc.ZipCode,zc.State,zc.Province,ct.CityName,cn.CountryName FROM Users.ZipCodes zc LEFT JOIN Users.Cities ct ON ct.CityId=zc.CityId LEFT JOIN Users.Countries cn ON cn.CountryId=ct.CountryId
GO
/****** Object:  Table [Users].[UserProfile]    Script Date: 30.12.2020 17:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Users].[UserProfile](
	[UserId] [nvarchar](128) NOT NULL,
	[FirstName] [nvarchar](50) NOT NULL,
	[MiddleName] [nvarchar](50) NULL,
	[LastName] [nvarchar](50) NOT NULL,
	[Gender] [bit] NULL,
	[Phone] [nchar](15) NULL,
	[CityId] [int] NOT NULL,
	[BornCityId] [int] NULL,
	[ZipId] [int] NULL,
	[ProfilePhotoUrl] [nvarchar](500) NULL,
	[CoverPhotoIUrl] [nvarchar](500) NULL,
	[Biography] [nvarchar](500) NULL,
	[RelationshipId] [int] NULL,
	[CreationDate] [datetime] NULL,
 CONSTRAINT [PK_UserProfile] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Users].[UserAccounts]    Script Date: 30.12.2020 17:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Users].[UserAccounts](
	[UserId] [nvarchar](128) NOT NULL,
	[Username] [nvarchar](256) NOT NULL,
	[Email] [nvarchar](256) NOT NULL,
	[EmailConfirmed] [bit] NOT NULL,
	[PasswordHash] [nvarchar](max) NULL,
	[PrivacyId] [int] NOT NULL,
	[SecurityStamp] [nvarchar](max) NULL,
	[Enable] [bit] NOT NULL,
	[LockoutEndDateUtc] [datetime] NULL,
	[AccessFailedCount] [int] NOT NULL,
 CONSTRAINT [PK_UserAccounts] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [Users].[ViewAllUserDetail]    Script Date: 30.12.2020 17:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [Users].[ViewAllUserDetail]
as
Select  up.UserId,ua.Username,up.FirstName,ISNULL(up.MiddleName,'')AS MiddleName,up.LastName,
IIF (up.Gender = 1 ,'Female' , 'Male') as Gender,ua.Email,ISNULL(up.Biography,'')as Biography,ISNULL(zp.Province,'')as Province,ct.CityName,
cy.CountryName From Users.UserProfile up INNER JOIN Users.UserAccounts ua ON ua.UserId=up.UserId  INNER JOIN Users.Cities ct on ct.CityId=up.CityId INNER JOIN Users.Countries  cy on cy.CountryId=ct.CountryId LEFT JOIN Users.ZipCodes zp on zp.ZipId=up.ZipId
GO
/****** Object:  UserDefinedFunction [Users].[GetEnableUsers]    Script Date: 30.12.2020 17:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Function [Users].[GetEnableUsers]()
Returns Table
as
return(
Select a.Username,p.FirstName,p.LastName,a.Email from Users.UserAccounts a inner join Users.UserProfile p on p.UserId=a.UserId where Enable=1)
GO
/****** Object:  Table [Shares].[Likes]    Script Date: 30.12.2020 17:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Shares].[Likes](
	[LikeId] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [nvarchar](128) NOT NULL,
	[CommentID] [int] NULL,
	[PostID] [int] NULL,
 CONSTRAINT [PK_Likes] PRIMARY KEY CLUSTERED 
(
	[LikeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Shares].[WallPosts]    Script Date: 30.12.2020 17:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Shares].[WallPosts](
	[PostId] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [nvarchar](128) NOT NULL,
	[PostMessage] [nvarchar](280) NOT NULL,
	[AtachmentUrl] [nchar](500) NULL,
	[PostDateTime] [datetime] NOT NULL,
	[PrivacyId] [int] NOT NULL,
 CONSTRAINT [PK_WallPosts] PRIMARY KEY CLUSTERED 
(
	[PostId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [Shares].[vUsersWallPosts]    Script Date: 30.12.2020 17:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [Shares].[vUsersWallPosts]
as
Select (up.FirstName+' '+up.LastName)as Fullname ,wp.PostDateTime,(ISNULL(wp.PostMessage,'')+' '+ISNULL(wp.AtachmentUrl,'')) as Whole_Message ,(select COUNT(PostId) from Shares.Likes lk where lk.PostID=wp.PostId) as Likes

from Shares.WallPosts wp inner join Users.UserProfile up on up.UserId=wp.UserId
GO
/****** Object:  Table [Shares].[DirectMessages]    Script Date: 30.12.2020 17:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Shares].[DirectMessages](
	[DMId] [int] IDENTITY(1,1) NOT NULL,
	[SenderId] [nvarchar](128) NOT NULL,
	[FriendId] [nvarchar](128) NOT NULL,
	[DMMessage] [nvarchar](300) NOT NULL,
	[MessageDateTime] [datetime] NOT NULL,
	[Status] [bit] NOT NULL,
 CONSTRAINT [PK_DirectMessages] PRIMARY KEY CLUSTERED 
(
	[DMId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [Shares].[vUsersDirectMessages]    Script Date: 30.12.2020 17:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [Shares].[vUsersDirectMessages]
as
Select (up.FirstName+' '+up.LastName)as Sender,(rp.FirstName+' '+rp.LastName)as Friend , dm.DMMessage, dm.MessageDateTime, ([Users].[GetFriendStatusText](Status))as Status
from Shares.DirectMessages dm inner join Users.UserProfile up on up.UserId=dm.SenderId 
inner join Users.UserProfile rp on rp.UserId=dm.FriendId
GO
/****** Object:  Table [Shares].[Comments]    Script Date: 30.12.2020 17:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Shares].[Comments](
	[Commentd] [int] IDENTITY(1,1) NOT NULL,
	[PostId] [int] NOT NULL,
	[AuthorId] [nvarchar](128) NOT NULL,
	[CommentMessage] [nchar](280) NOT NULL,
	[CommentDatetime] [datetime] NOT NULL,
 CONSTRAINT [PK_Comments] PRIMARY KEY CLUSTERED 
(
	[Commentd] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [Shares].[vPostsCommentsList]    Script Date: 30.12.2020 17:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [Shares].[vPostsCommentsList]
as
Select cm.CommentDatetime,(upp.FirstName+' '+upp.LastName) as Post_Author,(up.FirstName+' '+up.LastName) as Comment_Author
,wp.PostDateTime,cm.CommentMessage ,(select COUNT(CommentID) from Shares.Likes lk where 
lk.CommentID=cm.Commentd) as Likes from Shares.Comments cm inner join Users.UserProfile up on up.UserId=cm.AuthorId
inner join Shares.WallPosts wp on wp.PostId=cm.PostId inner join Users.UserProfile upp on upp.UserId=wp.UserId
GO
/****** Object:  Table [Shares].[Album]    Script Date: 30.12.2020 17:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Shares].[Album](
	[AlbumId] [int] IDENTITY(1,1) NOT NULL,
	[AlbumType] [nchar](25) NOT NULL,
	[Userid] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_Album] PRIMARY KEY CLUSTERED 
(
	[AlbumId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Shares].[PhotoAlbum]    Script Date: 30.12.2020 17:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Shares].[PhotoAlbum](
	[PhotoId] [nvarchar](128) NOT NULL,
	[PhotoUrl] [nchar](300) NOT NULL,
	[AlbumId] [int] NOT NULL,
 CONSTRAINT [PK_PhotoAlbum] PRIMARY KEY CLUSTERED 
(
	[PhotoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [Shares].[vUserPhotoAlbums]    Script Date: 30.12.2020 17:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [Shares].[vUserPhotoAlbums]
as
Select (up.FirstName+' '+up.LastName)as FullName,al.AlbumType ,(select count(pa.AlbumId) from Shares.PhotoAlbum pa where pa.AlbumId=al.AlbumId ) as Photo_Amount From Shares.Album al inner join Users.UserProfile up on up.UserId=al.Userid 
GO
/****** Object:  Table [Shares].[Privacy]    Script Date: 30.12.2020 17:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Shares].[Privacy](
	[PrivacyId] [int] NOT NULL,
	[PrivacyType] [nchar](25) NOT NULL,
 CONSTRAINT [PK_Privacy] PRIMARY KEY CLUSTERED 
(
	[PrivacyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [Users].[vUserPrivacies]    Script Date: 30.12.2020 17:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [Users].[vUserPrivacies]
as
select up.FirstName,up.LastName,up.CreationDate,pr.PrivacyType from Users.UserProfile up inner join Users.UserAccounts ua on ua.UserId = up.UserId inner join Shares.Privacy pr on pr.PrivacyId=ua.PrivacyId   
GO
/****** Object:  Table [Users].[Friends]    Script Date: 30.12.2020 17:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Users].[Friends](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [nvarchar](128) NOT NULL,
	[FriendId] [nvarchar](128) NOT NULL,
	[CreateOn] [datetime] NOT NULL,
 CONSTRAINT [PK__Friends__3214EC07233ADD10] PRIMARY KEY CLUSTERED 
(
	[Id] ASC,
	[UserId] ASC,
	[FriendId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [Users].[vUserFriendAmount]    Script Date: 30.12.2020 17:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create VIEW [Users].[vUserFriendAmount]
as

select (up.FirstName+' '+ISNULL(up.MiddleName,'')) as Name,+up.LastName as Surname,(select count(uf.FriendId) from Users.Friends uf where uf.UserId=up.UserId )as Friends from Users.UserProfile up 
GO
/****** Object:  Table [Users].[Relationships]    Script Date: 30.12.2020 17:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Users].[Relationships](
	[RelationshipId] [int] IDENTITY(1,1) NOT NULL,
	[RelationshipType] [nchar](25) NOT NULL,
 CONSTRAINT [PK_Relationships] PRIMARY KEY CLUSTERED 
(
	[RelationshipId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [Users].[UsersRelationship]    Script Date: 30.12.2020 17:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [Users].[UsersRelationship]
as
select (up.FirstName + ' '+ISNULL(up.MiddleName,''))AS Name, up.LastName as Surname, (case when up.Gender=0 then'Male' else'Female' end)as Gender,r.RelationshipType from Users.UserProfile up inner join Users.Relationships r on r.RelationshipId=up.RelationshipId
GO
/****** Object:  Table [Users].[RequestFriend]    Script Date: 30.12.2020 17:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Users].[RequestFriend](
	[RequestId] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [nvarchar](128) NOT NULL,
	[ReceiverID] [nvarchar](128) NOT NULL,
	[Status] [tinyint] NOT NULL,
	[RequestDateTime] [datetime] NOT NULL,
 CONSTRAINT [PK_RequestFriend] PRIMARY KEY CLUSTERED 
(
	[RequestId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [Users].[vFriendRequests]    Script Date: 30.12.2020 17:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create VIEW [Users].[vFriendRequests]
as
select rf.RequestDateTime as Request_Date ,(up.FirstName + ' '+up.LastName)AS Sender,(upp.FirstName + ' '+upp.LastName)AS Receiver, (case when rf.Status = 1 then 'Accepted' else 'StandBy' end)as Status  from Users.UserProfile up inner join  Users.RequestFriend rf on rf.UserId=up.UserId inner join Users.UserProfile upp on upp.UserId=rf.ReceiverID
GO
/****** Object:  Table [Shares].[UserLogs]    Script Date: 30.12.2020 17:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Shares].[UserLogs](
	[LogId] [bigint] IDENTITY(1,1) NOT NULL,
	[UserId] [nvarchar](128) NOT NULL,
	[Event] [varchar](50) NOT NULL,
	[LogDateTime] [datetime] NOT NULL,
 CONSTRAINT [PK_UserLogs] PRIMARY KEY CLUSTERED 
(
	[LogId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Users].[UserAccount_Roles]    Script Date: 30.12.2020 17:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Users].[UserAccount_Roles](
	[UserId] [nvarchar](128) NOT NULL,
	[RoleId] [int] NOT NULL,
	[CreatedOn] [datetime] NULL,
 CONSTRAINT [PK_Users.UserAccountRoles] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Users].[UserRoles]    Script Date: 30.12.2020 17:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Users].[UserRoles](
	[RoleId] [int] IDENTITY(1,1) NOT NULL,
	[RoleDescription] [nchar](10) NOT NULL,
 CONSTRAINT [PK_UserRoles] PRIMARY KEY CLUSTERED 
(
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [Shares].[Album] ON 

INSERT [Shares].[Album] ([AlbumId], [AlbumType], [Userid]) VALUES (2, N'ProfilePhotos            ', N'035E2ED5-C06B-46CB-8504-FED6CCD7A2F8')
INSERT [Shares].[Album] ([AlbumId], [AlbumType], [Userid]) VALUES (3, N'CoverPhotos              ', N'035E2ED5-C06B-46CB-8504-FED6CCD7A2F8')
INSERT [Shares].[Album] ([AlbumId], [AlbumType], [Userid]) VALUES (4, N'ProfilePhotos            ', N'03F98D98-F861-4024-969B-AD54E6936EE5')
INSERT [Shares].[Album] ([AlbumId], [AlbumType], [Userid]) VALUES (6, N'CoverPhotos              ', N'03F98D98-F861-4024-969B-AD54E6936EE5')
INSERT [Shares].[Album] ([AlbumId], [AlbumType], [Userid]) VALUES (7, N'ProfilePhotos            ', N'0B41759E-D817-4655-A9DD-0432EF209F34')
INSERT [Shares].[Album] ([AlbumId], [AlbumType], [Userid]) VALUES (8, N'CoverPhotos              ', N'0B41759E-D817-4655-A9DD-0432EF209F34')
INSERT [Shares].[Album] ([AlbumId], [AlbumType], [Userid]) VALUES (9, N'ProfilePhotos            ', N'129D0BDF-EFF2-48C3-B1DD-5DC0A65467D4')
INSERT [Shares].[Album] ([AlbumId], [AlbumType], [Userid]) VALUES (11, N'CoverPhotos              ', N'129D0BDF-EFF2-48C3-B1DD-5DC0A65467D4')
INSERT [Shares].[Album] ([AlbumId], [AlbumType], [Userid]) VALUES (12, N'ProfilePhotos            ', N'1b44c7ce7c4b849563f4ad428470f39fbe2b3b3542f5e1cfa97fcb0f3ca33f36')
INSERT [Shares].[Album] ([AlbumId], [AlbumType], [Userid]) VALUES (14, N'CoverPhotos              ', N'1b44c7ce7c4b849563f4ad428470f39fbe2b3b3542f5e1cfa97fcb0f3ca33f36')
INSERT [Shares].[Album] ([AlbumId], [AlbumType], [Userid]) VALUES (15, N'ProfilePhotos            ', N'2AFD3600-0F14-427F-AAA0-FCF51D539EB6')
INSERT [Shares].[Album] ([AlbumId], [AlbumType], [Userid]) VALUES (16, N'CoverPhotos              ', N'2AFD3600-0F14-427F-AAA0-FCF51D539EB6')
INSERT [Shares].[Album] ([AlbumId], [AlbumType], [Userid]) VALUES (17, N'ProfilePhotos            ', N'373918E9-A661-4F77-86F8-C45AF458A584')
INSERT [Shares].[Album] ([AlbumId], [AlbumType], [Userid]) VALUES (18, N'CoverPhotos              ', N'373918E9-A661-4F77-86F8-C45AF458A584')
INSERT [Shares].[Album] ([AlbumId], [AlbumType], [Userid]) VALUES (19, N'ProfilePhotos            ', N'3FDE5416-81F4-45E5-9C14-C4EB612ACA01')
INSERT [Shares].[Album] ([AlbumId], [AlbumType], [Userid]) VALUES (20, N'CoverPhotos              ', N'3FDE5416-81F4-45E5-9C14-C4EB612ACA01')
INSERT [Shares].[Album] ([AlbumId], [AlbumType], [Userid]) VALUES (21, N'ProfilePhotos            ', N'43CE5A28-5EC1-4805-98C7-F0F7960129F2')
INSERT [Shares].[Album] ([AlbumId], [AlbumType], [Userid]) VALUES (22, N'CoverPhotos              ', N'43CE5A28-5EC1-4805-98C7-F0F7960129F2')
INSERT [Shares].[Album] ([AlbumId], [AlbumType], [Userid]) VALUES (23, N'ProfilePhotos            ', N'48E23B2B-DF86-462D-9344-70A40EA1D893')
INSERT [Shares].[Album] ([AlbumId], [AlbumType], [Userid]) VALUES (24, N'CoverPhotos              ', N'48E23B2B-DF86-462D-9344-70A40EA1D893')
INSERT [Shares].[Album] ([AlbumId], [AlbumType], [Userid]) VALUES (26, N'ProfilePhotos            ', N'66A3003D-A57E-4553-AF93-EA9CFB66EC65')
INSERT [Shares].[Album] ([AlbumId], [AlbumType], [Userid]) VALUES (27, N'CoverPhotos              ', N'66A3003D-A57E-4553-AF93-EA9CFB66EC65')
INSERT [Shares].[Album] ([AlbumId], [AlbumType], [Userid]) VALUES (28, N'ProfilePhotos            ', N'8AAE7A41-0338-4201-9529-704EDD2564B8')
INSERT [Shares].[Album] ([AlbumId], [AlbumType], [Userid]) VALUES (29, N'CoverPhotos              ', N'8AAE7A41-0338-4201-9529-704EDD2564B8')
INSERT [Shares].[Album] ([AlbumId], [AlbumType], [Userid]) VALUES (31, N'ProfilePhotos            ', N'8F4AFBA5-CA70-4D8E-8B21-F7195FB7640A')
INSERT [Shares].[Album] ([AlbumId], [AlbumType], [Userid]) VALUES (32, N'CoverPhotos              ', N'8F4AFBA5-CA70-4D8E-8B21-F7195FB7640A')
INSERT [Shares].[Album] ([AlbumId], [AlbumType], [Userid]) VALUES (33, N'ProfilePhotos            ', N'926ded48073c6cc72860525ada798376599a24403e3a62b6c5ae0f6c2620a237')
INSERT [Shares].[Album] ([AlbumId], [AlbumType], [Userid]) VALUES (34, N'CoverPhotos              ', N'926ded48073c6cc72860525ada798376599a24403e3a62b6c5ae0f6c2620a237')
INSERT [Shares].[Album] ([AlbumId], [AlbumType], [Userid]) VALUES (35, N'ProfilePhotos            ', N'9b8a6c9e6cb52d9e0311ccde5f125dc0d47ee78e9586cd1878673c8c6c1a2182')
INSERT [Shares].[Album] ([AlbumId], [AlbumType], [Userid]) VALUES (36, N'CoverPhotos              ', N'9b8a6c9e6cb52d9e0311ccde5f125dc0d47ee78e9586cd1878673c8c6c1a2182')
INSERT [Shares].[Album] ([AlbumId], [AlbumType], [Userid]) VALUES (37, N'ProfilePhotos            ', N'bba4d205bc5663e978158b4935c406e07ec973f754168b70fc5d08adc5956695')
INSERT [Shares].[Album] ([AlbumId], [AlbumType], [Userid]) VALUES (38, N'CoverPhotos              ', N'bba4d205bc5663e978158b4935c406e07ec973f754168b70fc5d08adc5956695')
INSERT [Shares].[Album] ([AlbumId], [AlbumType], [Userid]) VALUES (39, N'ProfilePhotos            ', N'BEDE2683-D8B1-4959-BE34-31970B47DC98')
INSERT [Shares].[Album] ([AlbumId], [AlbumType], [Userid]) VALUES (40, N'CoverPhotos              ', N'BEDE2683-D8B1-4959-BE34-31970B47DC98')
INSERT [Shares].[Album] ([AlbumId], [AlbumType], [Userid]) VALUES (41, N'ProfilePhotos            ', N'c0fc07f1ee1595492342e2f7091b3936692e9cd6ebe5eaad47a57a94335b3fca')
INSERT [Shares].[Album] ([AlbumId], [AlbumType], [Userid]) VALUES (42, N'CoverPhotos              ', N'c0fc07f1ee1595492342e2f7091b3936692e9cd6ebe5eaad47a57a94335b3fca')
INSERT [Shares].[Album] ([AlbumId], [AlbumType], [Userid]) VALUES (43, N'ProfilePhotos            ', N'C13C6B10-678A-4A64-A3EA-74C8EA15FD22')
INSERT [Shares].[Album] ([AlbumId], [AlbumType], [Userid]) VALUES (44, N'CoverPhotos              ', N'C13C6B10-678A-4A64-A3EA-74C8EA15FD22')
INSERT [Shares].[Album] ([AlbumId], [AlbumType], [Userid]) VALUES (45, N'ProfilePhotos            ', N'C9BE4E5A-B956-4EF3-94E8-EFB6D33165F2')
INSERT [Shares].[Album] ([AlbumId], [AlbumType], [Userid]) VALUES (46, N'CoverPhotos              ', N'C9BE4E5A-B956-4EF3-94E8-EFB6D33165F2')
INSERT [Shares].[Album] ([AlbumId], [AlbumType], [Userid]) VALUES (47, N'ProfilePhotos            ', N'D8BD85F0-0FD1-413F-9254-E41B028FAA7F')
INSERT [Shares].[Album] ([AlbumId], [AlbumType], [Userid]) VALUES (48, N'CoverPhotos              ', N'D8BD85F0-0FD1-413F-9254-E41B028FAA7F')
INSERT [Shares].[Album] ([AlbumId], [AlbumType], [Userid]) VALUES (49, N'ProfilePhotos            ', N'DD87D548-8BF3-4C87-9285-E0A256FDD3A0')
INSERT [Shares].[Album] ([AlbumId], [AlbumType], [Userid]) VALUES (50, N'CoverPhotos              ', N'DD87D548-8BF3-4C87-9285-E0A256FDD3A0')
INSERT [Shares].[Album] ([AlbumId], [AlbumType], [Userid]) VALUES (51, N'ProfilePhotos            ', N'E027A633-ADB8-4E8D-BF4F-E2A1FA0979EB')
INSERT [Shares].[Album] ([AlbumId], [AlbumType], [Userid]) VALUES (52, N'CoverPhotos              ', N'E027A633-ADB8-4E8D-BF4F-E2A1FA0979EB')
INSERT [Shares].[Album] ([AlbumId], [AlbumType], [Userid]) VALUES (53, N'ProfilePhotos            ', N'EB098AE4-FFF9-44E6-BD77-A4FAE551D482')
INSERT [Shares].[Album] ([AlbumId], [AlbumType], [Userid]) VALUES (54, N'CoverPhotos              ', N'EB098AE4-FFF9-44E6-BD77-A4FAE551D482')
INSERT [Shares].[Album] ([AlbumId], [AlbumType], [Userid]) VALUES (55, N'ProfilePhotos            ', N'f660ab912ec121d1b1e928a0bb4bc61b15f5ad44d5efdc4e1c92a25e99b8e44a')
INSERT [Shares].[Album] ([AlbumId], [AlbumType], [Userid]) VALUES (56, N'CoverPhotos              ', N'f660ab912ec121d1b1e928a0bb4bc61b15f5ad44d5efdc4e1c92a25e99b8e44a')
INSERT [Shares].[Album] ([AlbumId], [AlbumType], [Userid]) VALUES (58, N'ProfilePhotos            ', N'2B7835F4-4D99-4964-AC7B-6F0C44CD7BDC')
INSERT [Shares].[Album] ([AlbumId], [AlbumType], [Userid]) VALUES (59, N'CoverPhotos              ', N'2B7835F4-4D99-4964-AC7B-6F0C44CD7BDC')
INSERT [Shares].[Album] ([AlbumId], [AlbumType], [Userid]) VALUES (60, N'ProfilePhotos            ', N'07518837-9310-4160-966A-ACEBBCEC75FC')
INSERT [Shares].[Album] ([AlbumId], [AlbumType], [Userid]) VALUES (61, N'CoverPhotos              ', N'07518837-9310-4160-966A-ACEBBCEC75FC')
INSERT [Shares].[Album] ([AlbumId], [AlbumType], [Userid]) VALUES (62, N'ProfilePhotos            ', N'ABE6AFDB-6821-4BB0-80C0-4CF680E42D86')
INSERT [Shares].[Album] ([AlbumId], [AlbumType], [Userid]) VALUES (63, N'CoverPhotos              ', N'ABE6AFDB-6821-4BB0-80C0-4CF680E42D86')
INSERT [Shares].[Album] ([AlbumId], [AlbumType], [Userid]) VALUES (64, N'ProfilePhotos            ', N'AE0EB7DA-1DA3-42DF-9699-E821436EB87C')
INSERT [Shares].[Album] ([AlbumId], [AlbumType], [Userid]) VALUES (65, N'CoverPhotos              ', N'AE0EB7DA-1DA3-42DF-9699-E821436EB87C')
INSERT [Shares].[Album] ([AlbumId], [AlbumType], [Userid]) VALUES (66, N'ProfilePhotos            ', N'A858B3FD-81F5-43E5-8037-CC9B67041031')
INSERT [Shares].[Album] ([AlbumId], [AlbumType], [Userid]) VALUES (67, N'CoverPhotos              ', N'A858B3FD-81F5-43E5-8037-CC9B67041031')
SET IDENTITY_INSERT [Shares].[Album] OFF
GO
SET IDENTITY_INSERT [Shares].[Comments] ON 

INSERT [Shares].[Comments] ([Commentd], [PostId], [AuthorId], [CommentMessage], [CommentDatetime]) VALUES (1, 2, N'03F98D98-F861-4024-969B-AD54E6936EE5', N'Yeah!                                                                                                                                                                                                                                                                                   ', CAST(N'2020-12-28T17:09:53.963' AS DateTime))
INSERT [Shares].[Comments] ([Commentd], [PostId], [AuthorId], [CommentMessage], [CommentDatetime]) VALUES (2, 2, N'0B41759E-D817-4655-A9DD-0432EF209F34', N'All Right.. :)                                                                                                                                                                                                                                                                          ', CAST(N'2020-12-28T17:10:23.323' AS DateTime))
INSERT [Shares].[Comments] ([Commentd], [PostId], [AuthorId], [CommentMessage], [CommentDatetime]) VALUES (3, 6, N'DD87D548-8BF3-4C87-9285-E0A256FDD3A0', N'Really?                                                                                                                                                                                                                                                                                 ', CAST(N'2020-12-28T17:11:22.060' AS DateTime))
SET IDENTITY_INSERT [Shares].[Comments] OFF
GO
SET IDENTITY_INSERT [Shares].[DirectMessages] ON 

INSERT [Shares].[DirectMessages] ([DMId], [SenderId], [FriendId], [DMMessage], [MessageDateTime], [Status]) VALUES (1, N'03F98D98-F861-4024-969B-AD54E6936EE5', N'035E2ED5-C06B-46CB-8504-FED6CCD7A2F8', N'Hi. I''m really excited this my firsT PM', CAST(N'2020-12-28T17:13:05.540' AS DateTime), 1)
INSERT [Shares].[DirectMessages] ([DMId], [SenderId], [FriendId], [DMMessage], [MessageDateTime], [Status]) VALUES (3, N'035E2ED5-C06B-46CB-8504-FED6CCD7A2F8', N'03F98D98-F861-4024-969B-AD54E6936EE5', N'Yeyy;D', CAST(N'2020-12-28T17:14:08.567' AS DateTime), 1)
INSERT [Shares].[DirectMessages] ([DMId], [SenderId], [FriendId], [DMMessage], [MessageDateTime], [Status]) VALUES (6, N'03F98D98-F861-4024-969B-AD54E6936EE5', N'035E2ED5-C06B-46CB-8504-FED6CCD7A2F8', N'See you..', CAST(N'2020-12-28T17:15:13.310' AS DateTime), 1)
INSERT [Shares].[DirectMessages] ([DMId], [SenderId], [FriendId], [DMMessage], [MessageDateTime], [Status]) VALUES (7, N'035E2ED5-C06B-46CB-8504-FED6CCD7A2F8', N'03F98D98-F861-4024-969B-AD54E6936EE5', N'Ok.', CAST(N'2020-12-28T17:16:02.803' AS DateTime), 0)
INSERT [Shares].[DirectMessages] ([DMId], [SenderId], [FriendId], [DMMessage], [MessageDateTime], [Status]) VALUES (8, N'035E2ED5-C06B-46CB-8504-FED6CCD7A2F8', N'03F98D98-F861-4024-969B-AD54E6936EE5', N'Hello my friend', CAST(N'2020-12-29T22:45:19.720' AS DateTime), 0)
INSERT [Shares].[DirectMessages] ([DMId], [SenderId], [FriendId], [DMMessage], [MessageDateTime], [Status]) VALUES (9, N'03F98D98-F861-4024-969B-AD54E6936EE5', N'035E2ED5-C06B-46CB-8504-FED6CCD7A2F8', N'Hi. How re you', CAST(N'2020-12-29T23:43:47.667' AS DateTime), 0)
SET IDENTITY_INSERT [Shares].[DirectMessages] OFF
GO
SET IDENTITY_INSERT [Shares].[Likes] ON 

INSERT [Shares].[Likes] ([LikeId], [UserId], [CommentID], [PostID]) VALUES (1, N'8AAE7A41-0338-4201-9529-704EDD2564B8', NULL, 2)
INSERT [Shares].[Likes] ([LikeId], [UserId], [CommentID], [PostID]) VALUES (2, N'8F4AFBA5-CA70-4D8E-8B21-F7195FB7640A', NULL, 2)
INSERT [Shares].[Likes] ([LikeId], [UserId], [CommentID], [PostID]) VALUES (3, N'bba4d205bc5663e978158b4935c406e07ec973f754168b70fc5d08adc5956695', NULL, 6)
INSERT [Shares].[Likes] ([LikeId], [UserId], [CommentID], [PostID]) VALUES (4, N'c0fc07f1ee1595492342e2f7091b3936692e9cd6ebe5eaad47a57a94335b3fca', NULL, 6)
INSERT [Shares].[Likes] ([LikeId], [UserId], [CommentID], [PostID]) VALUES (5, N'C9BE4E5A-B956-4EF3-94E8-EFB6D33165F2', NULL, 6)
INSERT [Shares].[Likes] ([LikeId], [UserId], [CommentID], [PostID]) VALUES (6, N'66A3003D-A57E-4553-AF93-EA9CFB66EC65', NULL, 8)
INSERT [Shares].[Likes] ([LikeId], [UserId], [CommentID], [PostID]) VALUES (7, N'DD87D548-8BF3-4C87-9285-E0A256FDD3A0', NULL, 7)
INSERT [Shares].[Likes] ([LikeId], [UserId], [CommentID], [PostID]) VALUES (8, N'c0fc07f1ee1595492342e2f7091b3936692e9cd6ebe5eaad47a57a94335b3fca', 1, NULL)
INSERT [Shares].[Likes] ([LikeId], [UserId], [CommentID], [PostID]) VALUES (9, N'926ded48073c6cc72860525ada798376599a24403e3a62b6c5ae0f6c2620a237', 1, NULL)
INSERT [Shares].[Likes] ([LikeId], [UserId], [CommentID], [PostID]) VALUES (10, N'66A3003D-A57E-4553-AF93-EA9CFB66EC65', 1, NULL)
SET IDENTITY_INSERT [Shares].[Likes] OFF
GO
INSERT [Shares].[PhotoAlbum] ([PhotoId], [PhotoUrl], [AlbumId]) VALUES (N'10F56542-1E43-4708-88FA-0CBA7FD6DA92', N'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS9o5INl5Il_WCYOpky60-G_vKfZB_PwSogug&usqp=CAU                                                                                                                                                                                                         ', 7)
INSERT [Shares].[PhotoAlbum] ([PhotoId], [PhotoUrl], [AlbumId]) VALUES (N'1B4C1E78-3200-4C17-AC7B-42FB8F4E6DBB', N'https://pbs.twimg.com/media/EaUbspwUMAAJdCE?format=jpg&name=4096x4096                                                                                                                                                                                                                                       ', 23)
INSERT [Shares].[PhotoAlbum] ([PhotoId], [PhotoUrl], [AlbumId]) VALUES (N'23BD9C29-F6E8-4D51-A9C4-72BB08B476B7', N'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRy3c4RkBWWzTfw-eSlijPFiKIWqa_X8jTNBA&usqp=CAU                                                                                                                                                                                                         ', 7)
INSERT [Shares].[PhotoAlbum] ([PhotoId], [PhotoUrl], [AlbumId]) VALUES (N'29DA6DA1-8575-4ABA-A23F-F3A9E4A47E8C', N'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTq2hiMM4LY3J-nPX9QFO0URL2siUWeJP-t-A&usqp=CAU                                                                                                                                                                                                         ', 35)
INSERT [Shares].[PhotoAlbum] ([PhotoId], [PhotoUrl], [AlbumId]) VALUES (N'3882D348-3CAC-432E-8165-67A2396ACFC3', N'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTdX7wWCMOvGYD6_4-MthVKf-DjjgLF_GqQzg&usqp=CAU                                                                                                                                                                                                         ', 4)
INSERT [Shares].[PhotoAlbum] ([PhotoId], [PhotoUrl], [AlbumId]) VALUES (N'3CDED969-4DA1-4289-A4D2-C4E5BCEF470C', N'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQNOhpV67XSI4Vz5Z_L7XoWiH7UzZQDBTzS3g&usqp=CAU                                                                                                                                                                                                         ', 35)
INSERT [Shares].[PhotoAlbum] ([PhotoId], [PhotoUrl], [AlbumId]) VALUES (N'4A45282E-F2D8-4DC0-ABB1-A1E1662CE81B', N'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT2uoEMxidN_jxhH1X6ARoL2PZh7jca_bipWA&usqp=CAU                                                                                                                                                                                                         ', 9)
INSERT [Shares].[PhotoAlbum] ([PhotoId], [PhotoUrl], [AlbumId]) VALUES (N'56CF46B0-2A82-4A6E-99FC-CBB779AE8F06', N'data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBw8PDw8PDg8ODw8PDw0NDw0NDQ8NDw8NFREWFhURFRUYHSggGBolMAEIAEMQAIAABgNIucLEFx2O                                                                                                                                                                     ', 2)
INSERT [Shares].[PhotoAlbum] ([PhotoId], [PhotoUrl], [AlbumId]) VALUES (N'659E54C9-1142-49FC-BF54-C4BD01D3A5B2', N'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQQnm7qaETgFaoTabNbopUVHpsBcqASi5M1IQ&usqp=CAU                                                                                                                                                                                                         ', 4)
INSERT [Shares].[PhotoAlbum] ([PhotoId], [PhotoUrl], [AlbumId]) VALUES (N'6ACFF563-D400-4932-B3E6-D00964BDA85E', N'https://data.whicdn.com/images/303284270/original.jpg?t=1513309244                                                                                                                                                                                                                                          ', 26)
INSERT [Shares].[PhotoAlbum] ([PhotoId], [PhotoUrl], [AlbumId]) VALUES (N'8361EA4F-1DDF-48F1-9859-D3AF8542BF43', N'data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBw8QDw8PDxAPDw8NDw4QDw0QDxAODw0PFREWFxURFxMYHiggGBslHBY=                                                                                                                                                                                         ', 2)
INSERT [Shares].[PhotoAlbum] ([PhotoId], [PhotoUrl], [AlbumId]) VALUES (N'9BA7AF87-6F66-4EB6-BEBC-B96FEE80A1E4', N'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTvxDrCR5SfO2zzeBNLF9U9xbjlC8-ToAA68g&usqp=CAU                                                                                                                                                                                                         ', 2)
INSERT [Shares].[PhotoAlbum] ([PhotoId], [PhotoUrl], [AlbumId]) VALUES (N'9F75FEC8-F1C0-43B3-97F7-1E842542C4B0', N'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAASsAAACoCAMAAACPKThEAAABZVBMVEUAAAABt/8AAAMAtv8Auf8AAQAAuv8AAQAASUVORK5CYII=                                                                                                                                                                                  ', 2)
INSERT [Shares].[PhotoAlbum] ([PhotoId], [PhotoUrl], [AlbumId]) VALUES (N'9FE47611-AAA1-4827-9C0F-AFFD57AF1F95', N'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSUoegMf-5Blp1GkHOIyoQ5nWqPsJaNfV9Zmg&usqp=CAU                                                                                                                                                                                                         ', 4)
INSERT [Shares].[PhotoAlbum] ([PhotoId], [PhotoUrl], [AlbumId]) VALUES (N'A305E45B-AB45-4CF9-A582-106E7EF10C70', N'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRVfTF1TdrwAMMwiTEETvJUSaWz_kFK8FEr6A&usqp=CAU                                                                                                                                                                                                         ', 12)
INSERT [Shares].[PhotoAlbum] ([PhotoId], [PhotoUrl], [AlbumId]) VALUES (N'ABB457B3-AD11-46C4-9E14-09780B3C8DD2', N'https://learnenglish.britishcouncil.org/sites/podcasts/files/styles/article/public/RS8003_GettyImages-994576028-hig.jpg?itok=USdYN3SJ                                                                                                                                                                       ', 31)
INSERT [Shares].[PhotoAlbum] ([PhotoId], [PhotoUrl], [AlbumId]) VALUES (N'B1E3E365-9D99-46E8-9327-2954DE800B38', N'https://media.istockphoto.com/photos/cute-asian-baby-smile-to-you-picture-id159006617                                                                                                                                                                                                                       ', 9)
INSERT [Shares].[PhotoAlbum] ([PhotoId], [PhotoUrl], [AlbumId]) VALUES (N'B3F901E3-C15C-44A8-B9DD-2448C88471AB', N'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQcyWUxDCRCf3MkdbBP8YjbCshKCgcZ7ICskQ&usqp=CAU                                                                                                                                                                                                         ', 15)
INSERT [Shares].[PhotoAlbum] ([PhotoId], [PhotoUrl], [AlbumId]) VALUES (N'DED79856-C015-44F1-B3D7-CDD64768A12B', N'data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBxAQEA8QDxAPEBAPDw8PDw8PDw8PDw8PFRUWFhUVFRUYHSggHwJFNjc5KissLx/8QAGgEAAwEBAQEAAAAAAAAAAAAAAAECAwQFBv/EACoRAQ=                                                                                                                                    ', 12)
GO
INSERT [Shares].[Privacy] ([PrivacyId], [PrivacyType]) VALUES (1, N'Everyone                 ')
INSERT [Shares].[Privacy] ([PrivacyId], [PrivacyType]) VALUES (2, N'FriendsOnly              ')
INSERT [Shares].[Privacy] ([PrivacyId], [PrivacyType]) VALUES (3, N'OnlyMe                   ')
GO
SET IDENTITY_INSERT [Shares].[UserLogs] ON 

INSERT [Shares].[UserLogs] ([LogId], [UserId], [Event], [LogDateTime]) VALUES (1, N'ABE6AFDB-6821-4BB0-80C0-4CF680E42D86', N'Login Success', CAST(N'2020-12-29T22:16:56.717' AS DateTime))
INSERT [Shares].[UserLogs] ([LogId], [UserId], [Event], [LogDateTime]) VALUES (2, N'ABE6AFDB-6821-4BB0-80C0-4CF680E42D86', N'Login Success', CAST(N'2020-12-29T22:17:22.503' AS DateTime))
INSERT [Shares].[UserLogs] ([LogId], [UserId], [Event], [LogDateTime]) VALUES (3, N'ABE6AFDB-6821-4BB0-80C0-4CF680E42D86', N'Login Success', CAST(N'2020-12-29T22:17:29.430' AS DateTime))
INSERT [Shares].[UserLogs] ([LogId], [UserId], [Event], [LogDateTime]) VALUES (4, N'035E2ED5-C06B-46CB-8504-FED6CCD7A2F8', N'Send Direct Message', CAST(N'2020-12-29T22:45:19.720' AS DateTime))
INSERT [Shares].[UserLogs] ([LogId], [UserId], [Event], [LogDateTime]) VALUES (5, N'035E2ED5-C06B-46CB-8504-FED6CCD7A2F8', N'Send Post Message', CAST(N'2020-12-29T22:55:59.600' AS DateTime))
INSERT [Shares].[UserLogs] ([LogId], [UserId], [Event], [LogDateTime]) VALUES (6, N'035E2ED5-C06B-46CB-8504-FED6CCD7A2F8', N'Send Post Message', CAST(N'2020-12-29T22:57:09.757' AS DateTime))
INSERT [Shares].[UserLogs] ([LogId], [UserId], [Event], [LogDateTime]) VALUES (7, N'035E2ED5-C06B-46CB-8504-FED6CCD7A2F8', N'Send Post Message', CAST(N'2020-12-29T22:59:03.287' AS DateTime))
INSERT [Shares].[UserLogs] ([LogId], [UserId], [Event], [LogDateTime]) VALUES (8, N'03F98D98-F861-4024-969B-AD54E6936EE5', N'Send Direct Message', CAST(N'2020-12-29T23:43:47.667' AS DateTime))
INSERT [Shares].[UserLogs] ([LogId], [UserId], [Event], [LogDateTime]) VALUES (9, N'AE0EB7DA-1DA3-42DF-9699-E821436EB87C', N'Login Success', CAST(N'2020-12-29T23:55:34.947' AS DateTime))
INSERT [Shares].[UserLogs] ([LogId], [UserId], [Event], [LogDateTime]) VALUES (10, N'A858B3FD-81F5-43E5-8037-CC9B67041031', N'Login Success', CAST(N'2020-12-30T16:06:50.570' AS DateTime))
INSERT [Shares].[UserLogs] ([LogId], [UserId], [Event], [LogDateTime]) VALUES (11, N'A858B3FD-81F5-43E5-8037-CC9B67041031', N'Login Success', CAST(N'2020-12-30T16:17:34.170' AS DateTime))
SET IDENTITY_INSERT [Shares].[UserLogs] OFF
GO
SET IDENTITY_INSERT [Shares].[WallPosts] ON 

INSERT [Shares].[WallPosts] ([PostId], [UserId], [PostMessage], [AtachmentUrl], [PostDateTime], [PrivacyId]) VALUES (2, N'035E2ED5-C06B-46CB-8504-FED6CCD7A2F8', N'Hello World', N'https://www.google.com/imgres?imgurl=https%3A%2F%2Fyavuzyalcintas.com%2Fwp-content%2Fuploads%2F2020%2F08%2Fhello-world.png&imgrefurl=https%3A%2F%2Fyavuzyalcintas.com%2Fhello-world%2F&tbnid=02yrh6ToHf7A_M&vet=12ahUKEwiul_mO7PDtAhXRgKQKHc7nCwEQMygBegUIARCvAQ..i&docid=uYZDQ8R3qP6XTM&w=2000&h=1062&q=hello%20world&ved=2ahUKEwiul_mO7PDtAhXRgKQKHc7nCwEQMygBegUIARCvAQ                                                                                                                                          ', CAST(N'2020-12-28T17:05:09.053' AS DateTime), 1)
INSERT [Shares].[WallPosts] ([PostId], [UserId], [PostMessage], [AtachmentUrl], [PostDateTime], [PrivacyId]) VALUES (6, N'03F98D98-F861-4024-969B-AD54E6936EE5', N'Did you know85% of plant life is found in the ocean', N'https://www.ecolab.com/-/media/Ecolab/Ecolab-Home/Images/Programs/Pest/Did-you-Know-550x310.jpg                                                                                                                                                                                                                                                                                                                                                                                                                     ', CAST(N'2020-12-28T17:07:16.867' AS DateTime), 1)
INSERT [Shares].[WallPosts] ([PostId], [UserId], [PostMessage], [AtachmentUrl], [PostDateTime], [PrivacyId]) VALUES (7, N'129D0BDF-EFF2-48C3-B1DD-5DC0A65467D4', N'How Are You?', NULL, CAST(N'2020-12-28T17:07:49.127' AS DateTime), 1)
INSERT [Shares].[WallPosts] ([PostId], [UserId], [PostMessage], [AtachmentUrl], [PostDateTime], [PrivacyId]) VALUES (8, N'66A3003D-A57E-4553-AF93-EA9CFB66EC65', N'To Do List : Bla Bla', NULL, CAST(N'2020-12-28T17:08:42.937' AS DateTime), 3)
INSERT [Shares].[WallPosts] ([PostId], [UserId], [PostMessage], [AtachmentUrl], [PostDateTime], [PrivacyId]) VALUES (9, N'035E2ED5-C06B-46CB-8504-FED6CCD7A2F8', N'What a wonderful World :)', N'https://youtu.be/VqhCQZaH4Vs                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        ', CAST(N'2020-12-29T22:55:59.600' AS DateTime), 1)
INSERT [Shares].[WallPosts] ([PostId], [UserId], [PostMessage], [AtachmentUrl], [PostDateTime], [PrivacyId]) VALUES (10, N'035E2ED5-C06B-46CB-8504-FED6CCD7A2F8', N'You are so silent', NULL, CAST(N'2020-12-29T22:57:09.757' AS DateTime), 1)
INSERT [Shares].[WallPosts] ([PostId], [UserId], [PostMessage], [AtachmentUrl], [PostDateTime], [PrivacyId]) VALUES (11, N'035E2ED5-C06B-46CB-8504-FED6CCD7A2F8', N'Pretty Woman :D', N'https://youtu.be/3KFvoDDs0XM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        ', CAST(N'2020-12-29T22:59:03.287' AS DateTime), 1)
SET IDENTITY_INSERT [Shares].[WallPosts] OFF
GO
SET IDENTITY_INSERT [Users].[Cities] ON 

INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (1, 218, N'1', N'ADANA')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (2, 218, N'2', N'ADIYAMAN')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (3, 218, N'3', N'AFYON')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (4, 218, N'4', N'AĞRI')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (5, 218, N'5', N'AMASYA')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (6, 218, N'6', N'ANKARA')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (7, 218, N'7', N'ANTALYA')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (8, 218, N'8', N'ARTVİN')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (9, 218, N'9', N'AYDIN')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (10, 218, N'10', N'BALIKESİR')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (11, 218, N'11', N'BİLECİK')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (12, 218, N'12', N'BİNGÖL')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (13, 218, N'13', N'BİTLİS')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (14, 218, N'14', N'BOLU')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (15, 218, N'15', N'BURDUR')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (16, 218, N'16', N'BURSA')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (17, 218, N'17', N'ÇANAKKALE')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (18, 218, N'18', N'ÇANKIRI')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (19, 218, N'19', N'ÇORUM')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (20, 218, N'20', N'DENİZLİ')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (21, 218, N'21', N'DİYARBAKIR')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (22, 218, N'22', N'EDİRNE')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (23, 218, N'23', N'ELAZIĞ')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (24, 218, N'24', N'ERZİNCAN')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (25, 218, N'25', N'ERZURUM')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (26, 218, N'26', N'ESKİŞEHİR')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (27, 218, N'27', N'GAZİANTEP')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (28, 218, N'28', N'GİRESUN')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (29, 218, N'29', N'GÜMÜŞHANE')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (30, 218, N'30', N'HAKKARİ')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (31, 218, N'31', N'HATAY')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (32, 218, N'32', N'ISPARTA')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (33, 218, N'33', N'İÇEL')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (34, 218, N'34', N'İSTANBUL')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (35, 218, N'35', N'İZMİR')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (36, 218, N'36', N'KARS')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (37, 218, N'37', N'KASTAMONU')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (38, 218, N'38', N'KAYSERİ')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (39, 218, N'39', N'KIRKLARELİ')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (40, 218, N'40', N'KIRŞEHİR')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (41, 218, N'41', N'KOCAELİ')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (42, 218, N'42', N'KONYA')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (43, 218, N'43', N'KÜTAHYA')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (44, 218, N'44', N'MALATYA')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (45, 218, N'45', N'MANİSA')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (46, 218, N'46', N'KAHRAMANMARAŞ')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (47, 218, N'47', N'MARDİN')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (48, 218, N'48', N'MUĞLA')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (49, 218, N'49', N'MUŞ')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (50, 218, N'50', N'NEVŞEHİR')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (51, 218, N'51', N'NİĞDE')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (52, 218, N'52', N'ORDU')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (53, 218, N'53', N'RİZE')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (54, 218, N'54', N'SAKARYA')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (55, 218, N'55', N'SAMSUN')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (56, 218, N'56', N'SİİRT')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (57, 218, N'57', N'SİNOP')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (58, 218, N'58', N'SİVAS')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (59, 218, N'59', N'TEKİRDAĞ')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (60, 218, N'60', N'TOKAT')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (61, 218, N'61', N'TRABZON')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (62, 218, N'62', N'TUNCELİ')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (63, 218, N'63', N'ŞANLIURFA')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (64, 218, N'64', N'UŞAK')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (65, 218, N'65', N'VAN')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (66, 218, N'66', N'YOZGAT')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (67, 218, N'67', N'ZONGULDAK')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (68, 218, N'68', N'AKSARAY')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (69, 218, N'69', N'BAYBURT')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (70, 218, N'70', N'KARAMAN')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (71, 218, N'71', N'KIRIKKALE')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (72, 218, N'72', N'BATMAN')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (73, 218, N'73', N'ŞIRNAK')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (74, 218, N'74', N'BARTIN')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (75, 218, N'75', N'ARDAHAN')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (76, 218, N'76', N'IĞDIR')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (77, 218, N'77', N'YALOVA')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (78, 218, N'78', N'KARABÜK')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (79, 218, N'79', N'KİLİS')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (80, 218, N'80', N'OSMANİYE')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (81, 218, N'81', N'DÜZCE')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (83, 226, N'NJ', N'NEW JERSEY')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (85, 226, N'WA', N'WASHINGTON')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (90, 226, N'AK ', N'ALASKA')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (91, 226, N'AL ', N'ALABAMA')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (92, 226, N'AR ', N'ARKANSAS')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (93, 226, N'AZ ', N'ARIZONA')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (94, 226, N'CA ', N'CALIFORNIA')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (95, 226, N'CO ', N'COLORADO')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (96, 226, N'CT ', N'CONNECTICUT')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (97, 226, N'DC ', N'DISTRICT OF COLUMBIA')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (98, 226, N'DE ', N'DELAWARE')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (99, 226, N'FL ', N'FLORIDA')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (100, 226, N'GA ', N'GEORGIA')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (101, 226, N'GU ', N'GUAM')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (102, 226, N'HI ', N'HAWAII')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (103, 226, N'IA ', N'IOWA')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (104, 226, N'ID ', N'IDAHO')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (105, 226, N'IL ', N'ILLINOIS')
GO
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (106, 226, N'IN ', N'INDIANA')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (107, 226, N'KS ', N'KANSAS')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (108, 226, N'KY ', N'KENTUCKY')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (109, 226, N'LA ', N'LOUISIANA')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (110, 226, N'MA ', N'MASSACHUSETTS')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (111, 226, N'MD ', N'MARYLAND')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (112, 226, N'ME ', N'MAINE')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (113, 226, N'MI ', N'MICHIGAN')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (114, 226, N'MN ', N'MINNESOTA')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (115, 226, N'MO ', N'MISSOURI')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (116, 226, N'MS ', N'MISSISSIPPI')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (117, 226, N'MT ', N'MONTANA')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (118, 226, N'NC ', N'NORTH CAROLINA')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (119, 226, N'ND ', N'NORTH DAKOTA')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (120, 226, N'NE ', N'NEBRASKA')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (121, 226, N'NH ', N'NEW HAMPSHIRE')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (122, 226, N'NJ ', N'NEW JERSEY')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (123, 226, N'NM ', N'NEW MEXICO')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (124, 226, N'NV ', N'NEVADA')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (125, 226, N'NY ', N'NEW YORK')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (126, 226, N'OH ', N'OHIO')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (127, 226, N'OK ', N'OKLAHOMA')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (128, 226, N'OR ', N'OREGON')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (129, 226, N'PA ', N'PENNSYLVANIA')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (130, 226, N'PR ', N'PUERTO RICO')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (131, 226, N'RI ', N'RHODE ISLAND')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (132, 226, N'SC ', N'SOUTH CAROLINA')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (133, 226, N'SD ', N'SOUTH DAKOTA')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (134, 226, N'TN ', N'TENNESSEE')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (135, 226, N'TX ', N'TEXAS')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (136, 226, N'UT ', N'UTAH')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (137, 226, N'VA ', N'VIRGINIA')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (138, 226, N'VT ', N'VERMONT')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (140, 226, N'WI ', N'WISCONSIN')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (141, 226, N'WV ', N'WEST VIRGINIA')
INSERT [Users].[Cities] ([CityId], [CountryId], [LocalCityCode], [CityName]) VALUES (142, 226, N'WY ', N'WYOMING')
SET IDENTITY_INSERT [Users].[Cities] OFF
GO
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (1, N'AF ', N'AFGHANISTAN              ')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (2, N'AL', N'ALBANIA')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (3, N'DZ', N'ALGERIA')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (4, N'AS', N'AMERICAN SAMOA')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (5, N'AD', N'ANDORRA')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (6, N'AO', N'ANGOLA')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (7, N'AI', N'ANGUILLA')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (8, N'AQ', N'ANTARCTICA')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (9, N'AG', N'ANTIGUA AND BARBUDA')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (10, N'AR', N'ARGENTINA')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (11, N'AM', N'ARMENIA')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (12, N'AW', N'ARUBA')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (13, N'AU', N'AUSTRALIA')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (14, N'AT', N'AUSTRIA')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (15, N'AZ', N'AZERBAIJAN')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (16, N'BS', N'BAHAMAS')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (17, N'BH', N'BAHRAIN')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (18, N'BD', N'BANGLADESH')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (19, N'BB', N'BARBADOS')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (20, N'BY', N'BELARUS')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (21, N'BE', N'BELGIUM')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (22, N'BZ', N'BELIZE')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (23, N'BJ', N'BENIN')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (24, N'BM', N'BERMUDA')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (25, N'BT', N'BHUTAN')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (26, N'BO', N'BOLIVIA')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (27, N'BA', N'BOSNIA AND HERZEGOVINA')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (28, N'BW', N'BOTSWANA')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (29, N'BV', N'BOUVET ISLAND')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (30, N'BR', N'BRAZIL')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (31, N'IO', N'BRITISH INDIAN OCEAN TERRITORY')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (32, N'BN', N'BRUNEI DARUSSALAM')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (33, N'BG', N'BULGARIA')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (34, N'BF', N'BURKINA FASO')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (35, N'BI', N'BURUNDI')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (36, N'KH', N'CAMBODIA')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (37, N'CM', N'CAMEROON')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (38, N'CA', N'CANADA')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (39, N'CV', N'CAPE VERDE')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (40, N'KY', N'CAYMAN ISLANDS')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (41, N'CF', N'CENTRAL AFRICAN REPUBLIC')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (42, N'TD', N'CHAD')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (43, N'CL', N'CHILE')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (44, N'CN', N'CHINA')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (45, N'CX', N'CHRISTMAS ISLAND')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (46, N'CC', N'COCOS (KEELING) ISLANDS')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (47, N'CO', N'COLOMBIA')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (48, N'KM', N'COMOROS')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (49, N'CG', N'CONGO')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (50, N'CD', N'CONGO, THE DEMOCRATIC REPUBLIC OF THE')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (51, N'CK', N'COOK ISLANDS')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (52, N'CR', N'COSTA RICA')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (53, N'CI', N'COTE D''IVOIRE')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (54, N'HR', N'CROATIA')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (55, N'CU', N'CUBA')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (56, N'CY', N'CYPRUS')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (57, N'CZ', N'CZECH REPUBLIC')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (58, N'DK', N'DENMARK')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (59, N'DJ', N'DJIBOUTI')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (60, N'DM', N'DOMINICA')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (61, N'DO', N'DOMINICAN REPUBLIC')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (62, N'EC', N'ECUADOR')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (63, N'EG', N'EGYPT')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (64, N'SV', N'EL SALVADOR')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (65, N'GQ', N'EQUATORIAL GUINEA')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (66, N'ER', N'ERITREA')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (67, N'EE', N'ESTONIA')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (68, N'ET', N'ETHIOPIA')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (69, N'FK', N'FALKLAND ISLANDS (MALVINAS)')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (70, N'FO', N'FAROE ISLANDS')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (71, N'FJ', N'FIJI')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (72, N'FI', N'FINLAND')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (73, N'FR', N'FRANCE')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (74, N'GF', N'FRENCH GUIANA')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (75, N'PF', N'FRENCH POLYNESIA')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (76, N'TF', N'FRENCH SOUTHERN TERRITORIES')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (77, N'GA', N'GABON')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (78, N'GM', N'GAMBIA')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (79, N'GE', N'GEORGIA')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (80, N'DE', N'GERMANY')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (81, N'GH', N'GHANA')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (82, N'GI', N'GIBRALTAR')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (83, N'GR', N'GREECE')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (84, N'GL', N'GREENLAND')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (85, N'GD', N'GRENADA')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (86, N'GP', N'GUADELOUPE')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (87, N'GU', N'GUAM')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (88, N'GT', N'GUATEMALA')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (89, N'GN', N'GUINEA')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (90, N'GW', N'GUINEA-BISSAU')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (91, N'GY', N'GUYANA')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (92, N'HT', N'HAITI')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (93, N'HM', N'HEARD ISLAND AND MCDONALD ISLANDS')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (94, N'VA', N'HOLY SEE (VATICAN CITY STATE)')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (95, N'HN', N'HONDURAS')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (96, N'HK', N'HONG KONG')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (97, N'HU', N'HUNGARY')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (98, N'IS', N'ICELAND')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (99, N'IN', N'INDIA')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (100, N'ID', N'INDONESIA')
GO
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (101, N'IR', N'IRAN, ISLAMIC REPUBLIC OF')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (102, N'IQ', N'IRAQ')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (103, N'IE', N'IRELAND')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (104, N'IL', N'ISRAEL')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (105, N'IT', N'ITALY')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (106, N'JM', N'JAMAICA')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (107, N'JP', N'JAPAN')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (108, N'JO', N'JORDAN')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (109, N'KZ', N'KAZAKHSTAN')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (110, N'KE', N'KENYA')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (111, N'KI', N'KIRIBATI')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (112, N'KP', N'KOREA, DEMOCRATIC PEOPLE''S REPUBLIC OF')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (113, N'KR', N'KOREA, REPUBLIC OF')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (114, N'KW', N'KUWAIT')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (115, N'KG', N'KYRGYZSTAN')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (116, N'LA', N'LAO PEOPLE''S DEMOCRATIC REPUBLIC')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (117, N'LV', N'LATVIA')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (118, N'LB', N'LEBANON')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (119, N'LS', N'LESOTHO')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (120, N'LR', N'LIBERIA')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (121, N'LY', N'LIBYAN ARAB JAMAHIRIYA')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (122, N'LI', N'LIECHTENSTEIN')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (123, N'LT', N'LITHUANIA')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (124, N'LU', N'LUXEMBOURG')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (125, N'MO', N'MACAO')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (126, N'MK', N'MACEDONIA, THE FORMER YUGOSLAV REPUBLIC OF')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (127, N'MG', N'MADAGASCAR')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (128, N'MW', N'MALAWI')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (129, N'MY', N'MALAYSIA')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (130, N'MV', N'MALDIVES')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (131, N'ML', N'MALI')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (132, N'MT', N'MALTA')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (133, N'MH', N'MARSHALL ISLANDS')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (134, N'MQ', N'MARTINIQUE')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (135, N'MR', N'MAURITANIA')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (136, N'MU', N'MAURITIUS')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (137, N'YT', N'MAYOTTE')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (138, N'MX', N'MEXICO')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (139, N'FM', N'MICRONESIA, FEDERATED STATES OF')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (140, N'MD', N'MOLDOVA, REPUBLIC OF')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (141, N'MC', N'MONACO')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (142, N'MN', N'MONGOLIA')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (143, N'MS', N'MONTSERRAT')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (144, N'MA', N'MOROCCO')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (145, N'MZ', N'MOZAMBIQUE')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (146, N'MM', N'MYANMAR')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (147, N'NA', N'NAMIBIA')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (148, N'NR', N'NAURU')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (149, N'NP', N'NEPAL')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (150, N'NL', N'NETHERLANDS')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (151, N'AN', N'NETHERLANDS ANTILLES')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (152, N'NC', N'NEW CALEDONIA')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (153, N'NZ', N'NEW ZEALAND')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (154, N'NI', N'NICARAGUA')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (155, N'NE', N'NIGER')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (156, N'NG', N'NIGERIA')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (157, N'NU', N'NIUE')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (158, N'NF', N'NORFOLK ISLAND')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (159, N'MP', N'NORTHERN MARIANA ISLANDS')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (160, N'NO', N'NORWAY')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (161, N'OM', N'OMAN')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (162, N'PK', N'PAKISTAN')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (163, N'PW', N'PALAU')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (164, N'PS', N'PALESTINIAN TERRITORY, OCCUPIED')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (165, N'PA', N'PANAMA')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (166, N'PG', N'PAPUA NEW GUINEA')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (167, N'PY', N'PARAGUAY')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (168, N'PE', N'PERU')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (169, N'PH', N'PHILIPPINES')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (170, N'PN', N'PITCAIRN')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (171, N'PL', N'POLAND')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (172, N'PT', N'PORTUGAL')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (173, N'PR', N'PUERTO RICO')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (174, N'QA', N'QATAR')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (175, N'RE', N'REUNION')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (176, N'RO', N'ROMANIA')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (177, N'RU', N'RUSSIAN FEDERATION')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (178, N'RW', N'RWANDA')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (179, N'SH', N'SAINT HELENA')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (180, N'KN', N'SAINT KITTS AND NEVIS')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (181, N'LC', N'SAINT LUCIA')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (182, N'PM', N'SAINT PIERRE AND MIQUELON')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (183, N'VC', N'SAINT VINCENT AND THE GRENADINES')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (184, N'WS', N'SAMOA')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (185, N'SM', N'SAN MARINO')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (186, N'ST', N'SAO TOME AND PRINCIPE')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (187, N'SA', N'SAUDI ARABIA')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (188, N'SN', N'SENEGAL')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (189, N'CS', N'SERBIA AND MONTENEGRO')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (190, N'SC', N'SEYCHELLES')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (191, N'SL', N'SIERRA LEONE')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (192, N'SG', N'SINGAPORE')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (193, N'SK', N'SLOVAKIA')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (194, N'SI', N'SLOVENIA')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (195, N'SB', N'SOLOMON ISLANDS')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (196, N'SO', N'SOMALIA')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (197, N'ZA', N'SOUTH AFRICA')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (198, N'GS', N'SOUTH GEORGIA AND THE SOUTH SANDWICH ISLANDS')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (199, N'ES', N'SPAIN')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (200, N'LK', N'SRI LANKA')
GO
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (201, N'SD', N'SUDAN')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (202, N'SR', N'SURINAME')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (203, N'SJ', N'SVALBARD AND JAN MAYEN')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (204, N'SZ', N'SWAZILAND')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (205, N'SE', N'SWEDEN')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (206, N'CH', N'SWITZERLAND')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (207, N'SY', N'SYRIAN ARAB REPUBLIC')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (208, N'TW', N'TAIWAN, PROVINCE OF CHINA')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (209, N'TJ', N'TAJIKISTAN')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (210, N'TZ', N'TANZANIA, UNITED REPUBLIC OF')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (211, N'TH', N'THAILAND')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (212, N'TL', N'TIMOR-LESTE')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (213, N'TG', N'TOGO')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (214, N'TK', N'TOKELAU')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (215, N'TO', N'TONGA')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (216, N'TT', N'TRINIDAD AND TOBAGO')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (217, N'TN', N'TUNISIA')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (218, N'TR', N'TURKEY')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (219, N'TM', N'TURKMENISTAN')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (220, N'TC', N'TURKS AND CAICOS ISLANDS')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (221, N'TV', N'TUVALU')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (222, N'UG', N'UGANDA')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (223, N'UA', N'UKRAINE')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (224, N'AE', N'UNITED ARAB EMIRATES')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (225, N'GB', N'UNITED KINGDOM')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (226, N'US', N'UNITED STATES')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (227, N'UM', N'UNITED STATES MINOR OUTLYING ISLANDS')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (228, N'UY', N'URUGUAY')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (229, N'UZ', N'UZBEKISTAN')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (230, N'VU', N'VANUATU')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (231, N'VE', N'VENEZUELA')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (232, N'VN', N'VIET NAM')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (233, N'VG', N'VIRGIN ISLANDS, BRITISH')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (234, N'VI', N'VIRGIN ISLANDS, U.S.')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (235, N'WF', N'WALLIS AND FUTUNA')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (236, N'EH', N'WESTERN SAHARA')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (237, N'YE', N'YEMEN')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (238, N'ZM', N'ZAMBIA')
INSERT [Users].[Countries] ([CountryId], [CountryTag], [CountryName]) VALUES (239, N'ZW', N'ZIMBABWE')
GO
SET IDENTITY_INSERT [Users].[Friends] ON 

INSERT [Users].[Friends] ([Id], [UserId], [FriendId], [CreateOn]) VALUES (79, N'1b44c7ce7c4b849563f4ad428470f39fbe2b3b3542f5e1cfa97fcb0f3ca33f36', N'0B41759E-D817-4655-A9DD-0432EF209F34', CAST(N'2020-12-29T19:36:01.537' AS DateTime))
INSERT [Users].[Friends] ([Id], [UserId], [FriendId], [CreateOn]) VALUES (80, N'0B41759E-D817-4655-A9DD-0432EF209F34', N'1b44c7ce7c4b849563f4ad428470f39fbe2b3b3542f5e1cfa97fcb0f3ca33f36', CAST(N'2020-12-29T19:36:01.537' AS DateTime))
INSERT [Users].[Friends] ([Id], [UserId], [FriendId], [CreateOn]) VALUES (81, N'035E2ED5-C06B-46CB-8504-FED6CCD7A2F8', N'03F98D98-F861-4024-969B-AD54E6936EE5', CAST(N'2020-12-29T19:36:02.267' AS DateTime))
INSERT [Users].[Friends] ([Id], [UserId], [FriendId], [CreateOn]) VALUES (82, N'03F98D98-F861-4024-969B-AD54E6936EE5', N'035E2ED5-C06B-46CB-8504-FED6CCD7A2F8', CAST(N'2020-12-29T19:36:02.267' AS DateTime))
INSERT [Users].[Friends] ([Id], [UserId], [FriendId], [CreateOn]) VALUES (83, N'035E2ED5-C06B-46CB-8504-FED6CCD7A2F8', N'8F4AFBA5-CA70-4D8E-8B21-F7195FB7640A', CAST(N'2020-12-29T19:38:06.707' AS DateTime))
INSERT [Users].[Friends] ([Id], [UserId], [FriendId], [CreateOn]) VALUES (84, N'8F4AFBA5-CA70-4D8E-8B21-F7195FB7640A', N'035E2ED5-C06B-46CB-8504-FED6CCD7A2F8', CAST(N'2020-12-29T19:38:06.707' AS DateTime))
INSERT [Users].[Friends] ([Id], [UserId], [FriendId], [CreateOn]) VALUES (85, N'C13C6B10-678A-4A64-A3EA-74C8EA15FD22', N'D8BD85F0-0FD1-413F-9254-E41B028FAA7F', CAST(N'2020-12-29T19:38:07.070' AS DateTime))
INSERT [Users].[Friends] ([Id], [UserId], [FriendId], [CreateOn]) VALUES (86, N'D8BD85F0-0FD1-413F-9254-E41B028FAA7F', N'C13C6B10-678A-4A64-A3EA-74C8EA15FD22', CAST(N'2020-12-29T19:38:07.070' AS DateTime))
INSERT [Users].[Friends] ([Id], [UserId], [FriendId], [CreateOn]) VALUES (87, N'9b8a6c9e6cb52d9e0311ccde5f125dc0d47ee78e9586cd1878673c8c6c1a2182', N'bba4d205bc5663e978158b4935c406e07ec973f754168b70fc5d08adc5956695', CAST(N'2020-12-29T19:38:07.380' AS DateTime))
INSERT [Users].[Friends] ([Id], [UserId], [FriendId], [CreateOn]) VALUES (88, N'bba4d205bc5663e978158b4935c406e07ec973f754168b70fc5d08adc5956695', N'9b8a6c9e6cb52d9e0311ccde5f125dc0d47ee78e9586cd1878673c8c6c1a2182', CAST(N'2020-12-29T19:38:07.380' AS DateTime))
INSERT [Users].[Friends] ([Id], [UserId], [FriendId], [CreateOn]) VALUES (89, N'129D0BDF-EFF2-48C3-B1DD-5DC0A65467D4', N'03F98D98-F861-4024-969B-AD54E6936EE5', CAST(N'2020-12-29T19:38:08.043' AS DateTime))
INSERT [Users].[Friends] ([Id], [UserId], [FriendId], [CreateOn]) VALUES (90, N'03F98D98-F861-4024-969B-AD54E6936EE5', N'129D0BDF-EFF2-48C3-B1DD-5DC0A65467D4', CAST(N'2020-12-29T19:38:08.043' AS DateTime))
SET IDENTITY_INSERT [Users].[Friends] OFF
GO
SET IDENTITY_INSERT [Users].[Relationships] ON 

INSERT [Users].[Relationships] ([RelationshipId], [RelationshipType]) VALUES (1, N'Unspecified              ')
INSERT [Users].[Relationships] ([RelationshipId], [RelationshipType]) VALUES (2, N'Single                   ')
INSERT [Users].[Relationships] ([RelationshipId], [RelationshipType]) VALUES (3, N'Has Relationship         ')
INSERT [Users].[Relationships] ([RelationshipId], [RelationshipType]) VALUES (4, N'Married                  ')
SET IDENTITY_INSERT [Users].[Relationships] OFF
GO
SET IDENTITY_INSERT [Users].[RequestFriend] ON 

INSERT [Users].[RequestFriend] ([RequestId], [UserId], [ReceiverID], [Status], [RequestDateTime]) VALUES (1, N'035E2ED5-C06B-46CB-8504-FED6CCD7A2F8', N'03F98D98-F861-4024-969B-AD54E6936EE5', 1, CAST(N'2020-12-28T17:00:10.250' AS DateTime))
INSERT [Users].[RequestFriend] ([RequestId], [UserId], [ReceiverID], [Status], [RequestDateTime]) VALUES (2, N'1b44c7ce7c4b849563f4ad428470f39fbe2b3b3542f5e1cfa97fcb0f3ca33f36', N'0B41759E-D817-4655-A9DD-0432EF209F34', 1, CAST(N'2020-12-28T17:01:38.663' AS DateTime))
INSERT [Users].[RequestFriend] ([RequestId], [UserId], [ReceiverID], [Status], [RequestDateTime]) VALUES (3, N'129D0BDF-EFF2-48C3-B1DD-5DC0A65467D4', N'03F98D98-F861-4024-969B-AD54E6936EE5', 1, CAST(N'2020-12-28T17:02:13.053' AS DateTime))
INSERT [Users].[RequestFriend] ([RequestId], [UserId], [ReceiverID], [Status], [RequestDateTime]) VALUES (4, N'9b8a6c9e6cb52d9e0311ccde5f125dc0d47ee78e9586cd1878673c8c6c1a2182', N'bba4d205bc5663e978158b4935c406e07ec973f754168b70fc5d08adc5956695', 1, CAST(N'2020-12-29T10:42:14.233' AS DateTime))
INSERT [Users].[RequestFriend] ([RequestId], [UserId], [ReceiverID], [Status], [RequestDateTime]) VALUES (5, N'C13C6B10-678A-4A64-A3EA-74C8EA15FD22', N'D8BD85F0-0FD1-413F-9254-E41B028FAA7F', 1, CAST(N'2020-12-29T10:43:37.570' AS DateTime))
INSERT [Users].[RequestFriend] ([RequestId], [UserId], [ReceiverID], [Status], [RequestDateTime]) VALUES (6, N'035E2ED5-C06B-46CB-8504-FED6CCD7A2F8', N'8F4AFBA5-CA70-4D8E-8B21-F7195FB7640A', 1, CAST(N'2020-12-29T12:30:16.230' AS DateTime))
SET IDENTITY_INSERT [Users].[RequestFriend] OFF
GO
INSERT [Users].[UserAccount_Roles] ([UserId], [RoleId], [CreatedOn]) VALUES (N'07518837-9310-4160-966A-ACEBBCEC75FC', 1, CAST(N'2020-12-29T20:22:21.210' AS DateTime))
INSERT [Users].[UserAccount_Roles] ([UserId], [RoleId], [CreatedOn]) VALUES (N'1b44c7ce7c4b849563f4ad428470f39fbe2b3b3542f5e1cfa97fcb0f3ca33f36', 1, CAST(N'2020-12-27T16:11:38.477' AS DateTime))
INSERT [Users].[UserAccount_Roles] ([UserId], [RoleId], [CreatedOn]) VALUES (N'2B7835F4-4D99-4964-AC7B-6F0C44CD7BDC', 1, CAST(N'2020-12-29T20:16:20.843' AS DateTime))
INSERT [Users].[UserAccount_Roles] ([UserId], [RoleId], [CreatedOn]) VALUES (N'926ded48073c6cc72860525ada798376599a24403e3a62b6c5ae0f6c2620a237', 1, CAST(N'2020-12-27T16:12:12.363' AS DateTime))
INSERT [Users].[UserAccount_Roles] ([UserId], [RoleId], [CreatedOn]) VALUES (N'926ded48073c6cc72860525ada798376599a24403e3a62b6c5ae0f6c2620a237', 2, CAST(N'2020-12-27T16:12:20.673' AS DateTime))
INSERT [Users].[UserAccount_Roles] ([UserId], [RoleId], [CreatedOn]) VALUES (N'9b8a6c9e6cb52d9e0311ccde5f125dc0d47ee78e9586cd1878673c8c6c1a2182', 1, CAST(N'2020-12-27T16:12:33.050' AS DateTime))
INSERT [Users].[UserAccount_Roles] ([UserId], [RoleId], [CreatedOn]) VALUES (N'9b8a6c9e6cb52d9e0311ccde5f125dc0d47ee78e9586cd1878673c8c6c1a2182', 2, CAST(N'2020-12-27T16:12:48.873' AS DateTime))
INSERT [Users].[UserAccount_Roles] ([UserId], [RoleId], [CreatedOn]) VALUES (N'A858B3FD-81F5-43E5-8037-CC9B67041031', 1, CAST(N'2020-12-30T15:53:58.253' AS DateTime))
INSERT [Users].[UserAccount_Roles] ([UserId], [RoleId], [CreatedOn]) VALUES (N'ABE6AFDB-6821-4BB0-80C0-4CF680E42D86', 1, CAST(N'2020-12-29T20:24:06.440' AS DateTime))
INSERT [Users].[UserAccount_Roles] ([UserId], [RoleId], [CreatedOn]) VALUES (N'AE0EB7DA-1DA3-42DF-9699-E821436EB87C', 1, CAST(N'2020-12-29T23:54:41.780' AS DateTime))
INSERT [Users].[UserAccount_Roles] ([UserId], [RoleId], [CreatedOn]) VALUES (N'c0fc07f1ee1595492342e2f7091b3936692e9cd6ebe5eaad47a57a94335b3fca', 1, CAST(N'2020-12-27T16:13:09.043' AS DateTime))
GO
INSERT [Users].[UserAccounts] ([UserId], [Username], [Email], [EmailConfirmed], [PasswordHash], [PrivacyId], [SecurityStamp], [Enable], [LockoutEndDateUtc], [AccessFailedCount]) VALUES (N'035E2ED5-C06B-46CB-8504-FED6CCD7A2F8', N'alice0', N'alice0@adventure-works.com', 0, N'JCeXjpjVxj9AEzWyOtt6yEg2ENO49Wj6ozjtUBxkZO0=', 1, N'8xYWhbw=', 1, NULL, 0)
INSERT [Users].[UserAccounts] ([UserId], [Username], [Email], [EmailConfirmed], [PasswordHash], [PrivacyId], [SecurityStamp], [Enable], [LockoutEndDateUtc], [AccessFailedCount]) VALUES (N'03F98D98-F861-4024-969B-AD54E6936EE5', N'andy0', N'andy0@adventure-works.com', 0, N'QROygmt2UVpD0Fd11a8sBoXipB/Gosap6D/WII9WYto=', 1, N'aZQFxrY=', 1, NULL, 0)
INSERT [Users].[UserAccounts] ([UserId], [Username], [Email], [EmailConfirmed], [PasswordHash], [PrivacyId], [SecurityStamp], [Enable], [LockoutEndDateUtc], [AccessFailedCount]) VALUES (N'07518837-9310-4160-966A-ACEBBCEC75FC', N'alpha0', N'alphachino@blabla.com', 0, N'D0673E95E927806365B84986951A1F880C21231A9A97FDF86A54B5C1B49D3360', 1, N'A69C94D52F42AD875AD9E04D0B1A8A59F6C3CC549F778FFD6DB69687180339D0', 0, NULL, 0)
INSERT [Users].[UserAccounts] ([UserId], [Username], [Email], [EmailConfirmed], [PasswordHash], [PrivacyId], [SecurityStamp], [Enable], [LockoutEndDateUtc], [AccessFailedCount]) VALUES (N'0B41759E-D817-4655-A9DD-0432EF209F34', N'mindy0', N'mindy0@adventure-works.com', 0, N'oMVBqIOBFTIS+WPOsOKncadIdnFVDd5ERE4SU/lLtAU=', 2, N'XrfukwM=', 1, NULL, 0)
INSERT [Users].[UserAccounts] ([UserId], [Username], [Email], [EmailConfirmed], [PasswordHash], [PrivacyId], [SecurityStamp], [Enable], [LockoutEndDateUtc], [AccessFailedCount]) VALUES (N'129D0BDF-EFF2-48C3-B1DD-5DC0A65467D4', N'john2', N'john2@adventure-works.com', 0, N'aryuzXTktme+k7TIhOfkRH/Or1C70EgfUYCISEZUg1k=', 1, N'A2jILiI=', 1, NULL, 0)
INSERT [Users].[UserAccounts] ([UserId], [Username], [Email], [EmailConfirmed], [PasswordHash], [PrivacyId], [SecurityStamp], [Enable], [LockoutEndDateUtc], [AccessFailedCount]) VALUES (N'1b44c7ce7c4b849563f4ad428470f39fbe2b3b3542f5e1cfa97fcb0f3ca33f36', N'carol0', N'carol0@adventure-works.com', 0, N'bc54832ec0ce601b7d4894ef02976eaa31256cffe5699ae08442fc3887824eae', 1, N'ec8e2a84513ffc606e31c17b44044d50d5123301da8080b339ada150eac7b54e', 1, NULL, 0)
INSERT [Users].[UserAccounts] ([UserId], [Username], [Email], [EmailConfirmed], [PasswordHash], [PrivacyId], [SecurityStamp], [Enable], [LockoutEndDateUtc], [AccessFailedCount]) VALUES (N'2AFD3600-0F14-427F-AAA0-FCF51D539EB6', N'benjamin0', N'benjamin0@adventure-works.com', 0, N'7VU8vejBywIxI00bctr0ZkCISsNb1fdnvfnTrQf9qMM=', 2, N'C3HBNCk=', 1, NULL, 0)
INSERT [Users].[UserAccounts] ([UserId], [Username], [Email], [EmailConfirmed], [PasswordHash], [PrivacyId], [SecurityStamp], [Enable], [LockoutEndDateUtc], [AccessFailedCount]) VALUES (N'2B7835F4-4D99-4964-AC7B-6F0C44CD7BDC', N'gizem0', N'gizem0@blabla.com', 0, N'62DD6773B60B8FFADAD94D800B14A560002AAD1434B36489570471CECBB6BAB6', 1, N'0B0EC44CCDA5ABCCFCB4FB684F7EB89F9736068067F44D12C4D25F16C7AA8611', 0, NULL, 0)
INSERT [Users].[UserAccounts] ([UserId], [Username], [Email], [EmailConfirmed], [PasswordHash], [PrivacyId], [SecurityStamp], [Enable], [LockoutEndDateUtc], [AccessFailedCount]) VALUES (N'373918E9-A661-4F77-86F8-C45AF458A584', N'andrew0', N'andrew0@adventure-works.com', 0, N'OZg1gWJ8cJwFeGr4+7FZ+MqKBARAS7J+8B1pFKa1XcQ=', 1, N'ZymdKp8=', 1, NULL, 0)
INSERT [Users].[UserAccounts] ([UserId], [Username], [Email], [EmailConfirmed], [PasswordHash], [PrivacyId], [SecurityStamp], [Enable], [LockoutEndDateUtc], [AccessFailedCount]) VALUES (N'3FDE5416-81F4-45E5-9C14-C4EB612ACA01', N'borah0', N'deborah0@adventure-works.com', 0, N'rOt2UIFUZAv7loiP82NqrhuNy2K3TW8Vxj04JWioRMM=', 1, N'rWdLV3U=', 1, NULL, 0)
INSERT [Users].[UserAccounts] ([UserId], [Username], [Email], [EmailConfirmed], [PasswordHash], [PrivacyId], [SecurityStamp], [Enable], [LockoutEndDateUtc], [AccessFailedCount]) VALUES (N'43CE5A28-5EC1-4805-98C7-F0F7960129F2', N'garrett1', N'garrett1@adventure-works.com', 0, N'fNwcaDNepJv0/R+Uyza8EWKx32zOSY8sUq4gz64A/hg=', 1, N'VSnBytA=', 1, NULL, 0)
INSERT [Users].[UserAccounts] ([UserId], [Username], [Email], [EmailConfirmed], [PasswordHash], [PrivacyId], [SecurityStamp], [Enable], [LockoutEndDateUtc], [AccessFailedCount]) VALUES (N'48E23B2B-DF86-462D-9344-70A40EA1D893', N'Andreas0', N'andreas0@adventure-works.com', 0, N'IyF/gbxc8gYtU/s9QZdlUvp4HQKYcipgLqo1rUQvxuA=', 1, N'sN4Tqxo=', 1, NULL, 0)
INSERT [Users].[UserAccounts] ([UserId], [Username], [Email], [EmailConfirmed], [PasswordHash], [PrivacyId], [SecurityStamp], [Enable], [LockoutEndDateUtc], [AccessFailedCount]) VALUES (N'66A3003D-A57E-4553-AF93-EA9CFB66EC65', N'alan0', N'alan0@adventure-works.com', 0, N'jn4FnE9mvjrxW7rtOzNmpI2B54n0GfDDy8VToYiBgAY=', 1, N'ffdON48=', 1, NULL, 0)
INSERT [Users].[UserAccounts] ([UserId], [Username], [Email], [EmailConfirmed], [PasswordHash], [PrivacyId], [SecurityStamp], [Enable], [LockoutEndDateUtc], [AccessFailedCount]) VALUES (N'8AAE7A41-0338-4201-9529-704EDD2564B8', N'jean0', N'jean0@adventure-works.com', 0, N'1ItzcT0ArqUBNyqvxEmnmf6eYwvv2rODTK91RzB+IwU=', 1, N'1pA38QU=', 1, NULL, 0)
INSERT [Users].[UserAccounts] ([UserId], [Username], [Email], [EmailConfirmed], [PasswordHash], [PrivacyId], [SecurityStamp], [Enable], [LockoutEndDateUtc], [AccessFailedCount]) VALUES (N'8F4AFBA5-CA70-4D8E-8B21-F7195FB7640A', N'amy0', N'amy0@adventure-works.com', 0, N'PO+MCFKaaFupLGe8sQMfotE39AQzWvuIjc/tlOrtg7Y=', 2, N'NQQU7Ks=', 1, NULL, 0)
INSERT [Users].[UserAccounts] ([UserId], [Username], [Email], [EmailConfirmed], [PasswordHash], [PrivacyId], [SecurityStamp], [Enable], [LockoutEndDateUtc], [AccessFailedCount]) VALUES (N'926ded48073c6cc72860525ada798376599a24403e3a62b6c5ae0f6c2620a237', N'alperen', N'alperen@hotmail.com', 0, N'41373ba709de074a24aab1744db855f636f04f712393a86b6ae70c31e5381d95', 3, N'5583344a295ea70953098175e9be44aceea98ef4142e996d497db6c44fda538c', 1, NULL, 0)
INSERT [Users].[UserAccounts] ([UserId], [Username], [Email], [EmailConfirmed], [PasswordHash], [PrivacyId], [SecurityStamp], [Enable], [LockoutEndDateUtc], [AccessFailedCount]) VALUES (N'9b8a6c9e6cb52d9e0311ccde5f125dc0d47ee78e9586cd1878673c8c6c1a2182', N'osman', N'caniskit@gmail.com', 0, N'9375b0209447988fceca9394bfc27f80fc2df48c4b621e3b5508c60e9f856f12', 3, N'cb97fc3f6dc9150df1150d1a5e3344a54ee28d44f932d1a4703f9a5345d43f29', 1, NULL, 0)
INSERT [Users].[UserAccounts] ([UserId], [Username], [Email], [EmailConfirmed], [PasswordHash], [PrivacyId], [SecurityStamp], [Enable], [LockoutEndDateUtc], [AccessFailedCount]) VALUES (N'A858B3FD-81F5-43E5-8037-CC9B67041031', N'ali1', N'ali@blabla.com', 0, N'7D7DADDA319493B39FB4BB9CC6CE802CFC66FB72E21E06254A0118394B7ABC20', 1, N'F7AB2A47832A29488767D68DFFBD7F78F39AAE95AF4DCBE1562DAB0D29E55144', 1, NULL, 0)
INSERT [Users].[UserAccounts] ([UserId], [Username], [Email], [EmailConfirmed], [PasswordHash], [PrivacyId], [SecurityStamp], [Enable], [LockoutEndDateUtc], [AccessFailedCount]) VALUES (N'ABE6AFDB-6821-4BB0-80C0-4CF680E42D86', N'alpha2', N'alpha2@blabla.com', 0, N'972C3960D9ED7007ABA6BC77077C1DB47024D17C565CDDA19BE92ACA2F7E7343', 1, N'D8B9EDD4CD1082B97C61D9E8740D7919E60194D107BCB88446A31D35A55893F3', 0, NULL, 0)
INSERT [Users].[UserAccounts] ([UserId], [Username], [Email], [EmailConfirmed], [PasswordHash], [PrivacyId], [SecurityStamp], [Enable], [LockoutEndDateUtc], [AccessFailedCount]) VALUES (N'AE0EB7DA-1DA3-42DF-9699-E821436EB87C', N'george1', N'george@blabla.com', 0, N'7ACBA0C033D31104ACA2D5EB2A26F1E5227CE5C60DB77A44DCB93EAE7C148B68', 1, N'C8E485F9DDD5D30EEE718CB6F5A1640039A65D908D8DA694D322C359AF839B58', 1, NULL, 0)
INSERT [Users].[UserAccounts] ([UserId], [Username], [Email], [EmailConfirmed], [PasswordHash], [PrivacyId], [SecurityStamp], [Enable], [LockoutEndDateUtc], [AccessFailedCount]) VALUES (N'bba4d205bc5663e978158b4935c406e07ec973f754168b70fc5d08adc5956695', N'gokhan0', N'gokhan92@gmail.com', 0, N'2078d2a837abcf2ff1e5dcde0c128a543d60dbcd905937acb69d3669a0ea90d3', 1, N'c9b0f71a135d215b51252ca7bc814bfc9f2ac45b48671cd683e351c06d5fcdba', 1, NULL, 0)
INSERT [Users].[UserAccounts] ([UserId], [Username], [Email], [EmailConfirmed], [PasswordHash], [PrivacyId], [SecurityStamp], [Enable], [LockoutEndDateUtc], [AccessFailedCount]) VALUES (N'BEDE2683-D8B1-4959-BE34-31970B47DC98', N'charles0', N'charles0@adventure-works.com', 0, N'aryuzXTktme+k7TIhOfkRH/Or1C70EgfUYCISEZUsdag=', 1, N'ec8e2a84513ffc606e31c17b44044d50d5123301da8080b339ada150eac7bsfae', 1, NULL, 0)
INSERT [Users].[UserAccounts] ([UserId], [Username], [Email], [EmailConfirmed], [PasswordHash], [PrivacyId], [SecurityStamp], [Enable], [LockoutEndDateUtc], [AccessFailedCount]) VALUES (N'c0fc07f1ee1595492342e2f7091b3936692e9cd6ebe5eaad47a57a94335b3fca', N'bmericd', N'mericc@gmail.com', 0, N'1b36ac1518562f38dc5a837ceaac2b3ed3c889347a99f1dd21ee4c6506b988a7', 2, N'2020a717fee891a2dd08d40fccf4a20baf95704300835238e3e52edf832273ac', 1, NULL, 0)
INSERT [Users].[UserAccounts] ([UserId], [Username], [Email], [EmailConfirmed], [PasswordHash], [PrivacyId], [SecurityStamp], [Enable], [LockoutEndDateUtc], [AccessFailedCount]) VALUES (N'C13C6B10-678A-4A64-A3EA-74C8EA15FD22', N'cristian0', N'cristian0@adventure-works.com', 0, N'rEI2s12gXSaZL5t+0Q1kasE2DP8wP05zf9s4qGLs80Q=', 2, N'xwU0wMc=', 1, NULL, 0)
INSERT [Users].[UserAccounts] ([UserId], [Username], [Email], [EmailConfirmed], [PasswordHash], [PrivacyId], [SecurityStamp], [Enable], [LockoutEndDateUtc], [AccessFailedCount]) VALUES (N'C9BE4E5A-B956-4EF3-94E8-EFB6D33165F2', N'andrew1', N'andrew1@adventure-works.com', 0, N'rc62gkVeu7V6m7C5LKFxi1alG8aAMhWuDyXZMO0Cwp4=', 1, N'2FSknCM=', 1, NULL, 0)
INSERT [Users].[UserAccounts] ([UserId], [Username], [Email], [EmailConfirmed], [PasswordHash], [PrivacyId], [SecurityStamp], [Enable], [LockoutEndDateUtc], [AccessFailedCount]) VALUES (N'D103DE26-49D6-4561-B464-DC6CEEFCDB33', N'alp0', N'alp0@blabla.com', 0, N'2BB962D18AEAE1B3A11E50A84308F9D8E28790F81881B11FC541E738F8D3DE9A', 1, N'A2FDE4D68D5CF3F5266CA92595712775C3DF9124A957E9E52B9148FAEBE7B431', 0, NULL, 0)
INSERT [Users].[UserAccounts] ([UserId], [Username], [Email], [EmailConfirmed], [PasswordHash], [PrivacyId], [SecurityStamp], [Enable], [LockoutEndDateUtc], [AccessFailedCount]) VALUES (N'D8BD85F0-0FD1-413F-9254-E41B028FAA7F', N'ben0', N'reuben0@adventure-works.com', 0, N'ylQsPrk00YFxDUrP6ji9fYqJhpQeL21R7cDfi+VoQS8=', 1, N'ANcWAkg=', 1, NULL, 0)
INSERT [Users].[UserAccounts] ([UserId], [Username], [Email], [EmailConfirmed], [PasswordHash], [PrivacyId], [SecurityStamp], [Enable], [LockoutEndDateUtc], [AccessFailedCount]) VALUES (N'DD87D548-8BF3-4C87-9285-E0A256FDD3A0', N'alex0', N'alex0@adventure-works.com', 0, N'd9dqvIGsmT9slizKCQaWTWfZ2KgEtoQmezRGWPjblOg=', 1, N'Kkt285U=', 1, NULL, 0)
INSERT [Users].[UserAccounts] ([UserId], [Username], [Email], [EmailConfirmed], [PasswordHash], [PrivacyId], [SecurityStamp], [Enable], [LockoutEndDateUtc], [AccessFailedCount]) VALUES (N'E027A633-ADB8-4E8D-BF4F-E2A1FA0979EB', N'matthias0', N'matthias0@adventure-works.com', 0, N's4kqBqZ5uLnllvVg96/ZqjHBnVKoaKCFbYE6lqVX3Ag=', 1, N'zUJvzGw=', 1, NULL, 0)
INSERT [Users].[UserAccounts] ([UserId], [Username], [Email], [EmailConfirmed], [PasswordHash], [PrivacyId], [SecurityStamp], [Enable], [LockoutEndDateUtc], [AccessFailedCount]) VALUES (N'EB098AE4-FFF9-44E6-BD77-A4FAE551D482', N'alejandro0', N'alejandro0@adventure-works.com', 0, N'5Pcl/OrJip4XjxK++/1lfd2ors+2g/xjIZw7JPEoL6s=', 1, N'hntHe5o=', 1, NULL, 0)
INSERT [Users].[UserAccounts] ([UserId], [Username], [Email], [EmailConfirmed], [PasswordHash], [PrivacyId], [SecurityStamp], [Enable], [LockoutEndDateUtc], [AccessFailedCount]) VALUES (N'f660ab912ec121d1b1e928a0bb4bc61b15f5ad44d5efdc4e1c92a25e99b8e44a', N'carole0', N'carole0@adventure-works.com', 0, N'6db62864f56143f84eaba655841a3b55d087f08f01d93be882d8d047b116b8f3', 1, N'b47a2c31e07240fcd2d6980fa41c93fef50824e2601b7e159daf19fbd3ffd9e7', 1, NULL, 0)
GO
INSERT [Users].[UserProfile] ([UserId], [FirstName], [MiddleName], [LastName], [Gender], [Phone], [CityId], [BornCityId], [ZipId], [ProfilePhotoUrl], [CoverPhotoIUrl], [Biography], [RelationshipId], [CreationDate]) VALUES (N'035E2ED5-C06B-46CB-8504-FED6CCD7A2F8', N'Alice', N'O', N'Ciccu                                             ', 1, NULL, 85, NULL, NULL, NULL, NULL, NULL, 3, CAST(N'2020-12-20T00:00:00.000' AS DateTime))
INSERT [Users].[UserProfile] ([UserId], [FirstName], [MiddleName], [LastName], [Gender], [Phone], [CityId], [BornCityId], [ZipId], [ProfilePhotoUrl], [CoverPhotoIUrl], [Biography], [RelationshipId], [CreationDate]) VALUES (N'03F98D98-F861-4024-969B-AD54E6936EE5', N'Andy', N'M', N'Ruth                                              ', 0, NULL, 102, NULL, NULL, NULL, NULL, NULL, 3, CAST(N'2020-12-20T00:00:00.000' AS DateTime))
INSERT [Users].[UserProfile] ([UserId], [FirstName], [MiddleName], [LastName], [Gender], [Phone], [CityId], [BornCityId], [ZipId], [ProfilePhotoUrl], [CoverPhotoIUrl], [Biography], [RelationshipId], [CreationDate]) VALUES (N'07518837-9310-4160-966A-ACEBBCEC75FC', N'Alpacino', NULL, N'Gonzalez', 0, NULL, 34, NULL, NULL, NULL, NULL, NULL, 1, CAST(N'2020-12-29T20:22:21.207' AS DateTime))
INSERT [Users].[UserProfile] ([UserId], [FirstName], [MiddleName], [LastName], [Gender], [Phone], [CityId], [BornCityId], [ZipId], [ProfilePhotoUrl], [CoverPhotoIUrl], [Biography], [RelationshipId], [CreationDate]) VALUES (N'0B41759E-D817-4655-A9DD-0432EF209F34', N'Mindy', N'C', N'Martin                                            ', 1, NULL, 106, NULL, NULL, NULL, NULL, NULL, 1, CAST(N'2020-12-20T00:00:00.000' AS DateTime))
INSERT [Users].[UserProfile] ([UserId], [FirstName], [MiddleName], [LastName], [Gender], [Phone], [CityId], [BornCityId], [ZipId], [ProfilePhotoUrl], [CoverPhotoIUrl], [Biography], [RelationshipId], [CreationDate]) VALUES (N'129D0BDF-EFF2-48C3-B1DD-5DC0A65467D4', N'John', N'Y', N'Chen                                              ', 0, NULL, 102, NULL, NULL, NULL, NULL, NULL, 4, CAST(N'2020-12-20T00:00:00.000' AS DateTime))
INSERT [Users].[UserProfile] ([UserId], [FirstName], [MiddleName], [LastName], [Gender], [Phone], [CityId], [BornCityId], [ZipId], [ProfilePhotoUrl], [CoverPhotoIUrl], [Biography], [RelationshipId], [CreationDate]) VALUES (N'1b44c7ce7c4b849563f4ad428470f39fbe2b3b3542f5e1cfa97fcb0f3ca33f36', N'Carol', N'M', N'Philips                                           ', 1, NULL, 106, NULL, NULL, NULL, NULL, NULL, 4, CAST(N'2020-12-20T00:00:00.000' AS DateTime))
INSERT [Users].[UserProfile] ([UserId], [FirstName], [MiddleName], [LastName], [Gender], [Phone], [CityId], [BornCityId], [ZipId], [ProfilePhotoUrl], [CoverPhotoIUrl], [Biography], [RelationshipId], [CreationDate]) VALUES (N'2AFD3600-0F14-427F-AAA0-FCF51D539EB6', N'Benjamin', N'R', N'Martin                                            ', 0, NULL, 90, NULL, NULL, NULL, NULL, NULL, 1, CAST(N'2020-12-20T00:00:00.000' AS DateTime))
INSERT [Users].[UserProfile] ([UserId], [FirstName], [MiddleName], [LastName], [Gender], [Phone], [CityId], [BornCityId], [ZipId], [ProfilePhotoUrl], [CoverPhotoIUrl], [Biography], [RelationshipId], [CreationDate]) VALUES (N'2B7835F4-4D99-4964-AC7B-6F0C44CD7BDC', N'Gizem', NULL, N'Doru', 1, NULL, 34, NULL, NULL, NULL, NULL, NULL, 1, CAST(N'2020-12-29T20:16:20.840' AS DateTime))
INSERT [Users].[UserProfile] ([UserId], [FirstName], [MiddleName], [LastName], [Gender], [Phone], [CityId], [BornCityId], [ZipId], [ProfilePhotoUrl], [CoverPhotoIUrl], [Biography], [RelationshipId], [CreationDate]) VALUES (N'373918E9-A661-4F77-86F8-C45AF458A584', N'Andrew', N'R', N'Hill                                              ', 0, NULL, 92, NULL, NULL, NULL, NULL, NULL, 2, CAST(N'2020-12-20T00:00:00.000' AS DateTime))
INSERT [Users].[UserProfile] ([UserId], [FirstName], [MiddleName], [LastName], [Gender], [Phone], [CityId], [BornCityId], [ZipId], [ProfilePhotoUrl], [CoverPhotoIUrl], [Biography], [RelationshipId], [CreationDate]) VALUES (N'3FDE5416-81F4-45E5-9C14-C4EB612ACA01', N'Deborah', N'E', N'Poe                                               ', 1, NULL, 90, NULL, NULL, NULL, NULL, NULL, 1, CAST(N'2020-12-20T00:00:00.000' AS DateTime))
INSERT [Users].[UserProfile] ([UserId], [FirstName], [MiddleName], [LastName], [Gender], [Phone], [CityId], [BornCityId], [ZipId], [ProfilePhotoUrl], [CoverPhotoIUrl], [Biography], [RelationshipId], [CreationDate]) VALUES (N'43CE5A28-5EC1-4805-98C7-F0F7960129F2', N'Garrett', N'R', N'Vargas                                            ', 0, NULL, 91, NULL, NULL, NULL, NULL, NULL, 1, CAST(N'2020-12-20T00:00:00.000' AS DateTime))
INSERT [Users].[UserProfile] ([UserId], [FirstName], [MiddleName], [LastName], [Gender], [Phone], [CityId], [BornCityId], [ZipId], [ProfilePhotoUrl], [CoverPhotoIUrl], [Biography], [RelationshipId], [CreationDate]) VALUES (N'48E23B2B-DF86-462D-9344-70A40EA1D893', N'Andreas', N'T', N'Berglund                                          ', 0, NULL, 92, NULL, NULL, NULL, NULL, NULL, 1, CAST(N'2020-12-21T00:00:00.000' AS DateTime))
INSERT [Users].[UserProfile] ([UserId], [FirstName], [MiddleName], [LastName], [Gender], [Phone], [CityId], [BornCityId], [ZipId], [ProfilePhotoUrl], [CoverPhotoIUrl], [Biography], [RelationshipId], [CreationDate]) VALUES (N'66A3003D-A57E-4553-AF93-EA9CFB66EC65', N'Alan', N'J', N'Brewer                                            ', 0, NULL, 85, NULL, NULL, NULL, NULL, NULL, 2, CAST(N'2020-12-21T00:00:00.000' AS DateTime))
INSERT [Users].[UserProfile] ([UserId], [FirstName], [MiddleName], [LastName], [Gender], [Phone], [CityId], [BornCityId], [ZipId], [ProfilePhotoUrl], [CoverPhotoIUrl], [Biography], [RelationshipId], [CreationDate]) VALUES (N'8AAE7A41-0338-4201-9529-704EDD2564B8', N'Jean', N'E', N'Trenary                                           ', 0, NULL, 100, NULL, NULL, NULL, NULL, NULL, 1, CAST(N'2020-12-21T00:00:00.000' AS DateTime))
INSERT [Users].[UserProfile] ([UserId], [FirstName], [MiddleName], [LastName], [Gender], [Phone], [CityId], [BornCityId], [ZipId], [ProfilePhotoUrl], [CoverPhotoIUrl], [Biography], [RelationshipId], [CreationDate]) VALUES (N'8F4AFBA5-CA70-4D8E-8B21-F7195FB7640A', N'Amy', N'E', N'Alberts                                           ', 1, NULL, 96, NULL, NULL, NULL, NULL, NULL, 1, CAST(N'2020-12-21T00:00:00.000' AS DateTime))
INSERT [Users].[UserProfile] ([UserId], [FirstName], [MiddleName], [LastName], [Gender], [Phone], [CityId], [BornCityId], [ZipId], [ProfilePhotoUrl], [CoverPhotoIUrl], [Biography], [RelationshipId], [CreationDate]) VALUES (N'926ded48073c6cc72860525ada798376599a24403e3a62b6c5ae0f6c2620a237', N'Dursun', N'Alperen', N'Çoban                                             ', 0, NULL, 34, 34, 50, NULL, NULL, NULL, 1, CAST(N'2020-12-10T00:00:00.000' AS DateTime))
INSERT [Users].[UserProfile] ([UserId], [FirstName], [MiddleName], [LastName], [Gender], [Phone], [CityId], [BornCityId], [ZipId], [ProfilePhotoUrl], [CoverPhotoIUrl], [Biography], [RelationshipId], [CreationDate]) VALUES (N'9b8a6c9e6cb52d9e0311ccde5f125dc0d47ee78e9586cd1878673c8c6c1a2182', N'Osman', N'Can', N'İskit                                             ', 0, NULL, 34, NULL, NULL, NULL, NULL, NULL, 1, CAST(N'2020-12-10T00:00:00.000' AS DateTime))
INSERT [Users].[UserProfile] ([UserId], [FirstName], [MiddleName], [LastName], [Gender], [Phone], [CityId], [BornCityId], [ZipId], [ProfilePhotoUrl], [CoverPhotoIUrl], [Biography], [RelationshipId], [CreationDate]) VALUES (N'A858B3FD-81F5-43E5-8037-CC9B67041031', N'Alihan', NULL, N'Kerim', 1, NULL, 34, NULL, NULL, NULL, NULL, NULL, 1, CAST(N'2020-12-30T15:53:58.250' AS DateTime))
INSERT [Users].[UserProfile] ([UserId], [FirstName], [MiddleName], [LastName], [Gender], [Phone], [CityId], [BornCityId], [ZipId], [ProfilePhotoUrl], [CoverPhotoIUrl], [Biography], [RelationshipId], [CreationDate]) VALUES (N'ABE6AFDB-6821-4BB0-80C0-4CF680E42D86', N'Ali', NULL, N'Dero', 1, NULL, 34, NULL, NULL, NULL, NULL, NULL, 1, CAST(N'2020-12-29T20:24:06.437' AS DateTime))
INSERT [Users].[UserProfile] ([UserId], [FirstName], [MiddleName], [LastName], [Gender], [Phone], [CityId], [BornCityId], [ZipId], [ProfilePhotoUrl], [CoverPhotoIUrl], [Biography], [RelationshipId], [CreationDate]) VALUES (N'AE0EB7DA-1DA3-42DF-9699-E821436EB87C', N'George', NULL, N'Lucas', 1, NULL, 34, NULL, NULL, NULL, NULL, NULL, 1, CAST(N'2020-12-29T23:54:41.773' AS DateTime))
INSERT [Users].[UserProfile] ([UserId], [FirstName], [MiddleName], [LastName], [Gender], [Phone], [CityId], [BornCityId], [ZipId], [ProfilePhotoUrl], [CoverPhotoIUrl], [Biography], [RelationshipId], [CreationDate]) VALUES (N'bba4d205bc5663e978158b4935c406e07ec973f754168b70fc5d08adc5956695', N'Gökhan', NULL, N'Erdemir                                           ', 0, NULL, 34, NULL, NULL, NULL, NULL, NULL, 1, CAST(N'2020-12-23T00:00:00.000' AS DateTime))
INSERT [Users].[UserProfile] ([UserId], [FirstName], [MiddleName], [LastName], [Gender], [Phone], [CityId], [BornCityId], [ZipId], [ProfilePhotoUrl], [CoverPhotoIUrl], [Biography], [RelationshipId], [CreationDate]) VALUES (N'BEDE2683-D8B1-4959-BE34-31970B47DC98', N'Charles', N'B', N'Fitzgerald                                        ', 0, NULL, 96, NULL, NULL, NULL, NULL, NULL, 1, CAST(N'2020-12-23T00:00:00.000' AS DateTime))
INSERT [Users].[UserProfile] ([UserId], [FirstName], [MiddleName], [LastName], [Gender], [Phone], [CityId], [BornCityId], [ZipId], [ProfilePhotoUrl], [CoverPhotoIUrl], [Biography], [RelationshipId], [CreationDate]) VALUES (N'c0fc07f1ee1595492342e2f7091b3936692e9cd6ebe5eaad47a57a94335b3fca', N'Buğra', N'Meriç', N'Değirmenci                                        ', 0, NULL, 34, NULL, NULL, NULL, NULL, NULL, 1, CAST(N'2020-12-15T00:00:00.000' AS DateTime))
INSERT [Users].[UserProfile] ([UserId], [FirstName], [MiddleName], [LastName], [Gender], [Phone], [CityId], [BornCityId], [ZipId], [ProfilePhotoUrl], [CoverPhotoIUrl], [Biography], [RelationshipId], [CreationDate]) VALUES (N'C13C6B10-678A-4A64-A3EA-74C8EA15FD22', N'Cristian', N'K', N'Petculescu                                        ', 1, NULL, 100, NULL, NULL, NULL, NULL, NULL, 1, CAST(N'2020-12-23T00:00:00.000' AS DateTime))
INSERT [Users].[UserProfile] ([UserId], [FirstName], [MiddleName], [LastName], [Gender], [Phone], [CityId], [BornCityId], [ZipId], [ProfilePhotoUrl], [CoverPhotoIUrl], [Biography], [RelationshipId], [CreationDate]) VALUES (N'C9BE4E5A-B956-4EF3-94E8-EFB6D33165F2', N'Andrew', N'M', N'Cencini                                           ', 0, NULL, 100, NULL, NULL, NULL, NULL, NULL, 1, CAST(N'2020-12-23T00:00:00.000' AS DateTime))
INSERT [Users].[UserProfile] ([UserId], [FirstName], [MiddleName], [LastName], [Gender], [Phone], [CityId], [BornCityId], [ZipId], [ProfilePhotoUrl], [CoverPhotoIUrl], [Biography], [RelationshipId], [CreationDate]) VALUES (N'D8BD85F0-0FD1-413F-9254-E41B028FAA7F', N'Reuben', N'H', N'D''sa                                              ', 1, NULL, 108, NULL, NULL, NULL, NULL, NULL, 1, CAST(N'2020-12-25T00:00:00.000' AS DateTime))
INSERT [Users].[UserProfile] ([UserId], [FirstName], [MiddleName], [LastName], [Gender], [Phone], [CityId], [BornCityId], [ZipId], [ProfilePhotoUrl], [CoverPhotoIUrl], [Biography], [RelationshipId], [CreationDate]) VALUES (N'DD87D548-8BF3-4C87-9285-E0A256FDD3A0', N'Alex', N'M', N'Nayberg                                           ', 0, NULL, 85, NULL, NULL, NULL, NULL, NULL, 2, CAST(N'2020-12-25T00:00:00.000' AS DateTime))
INSERT [Users].[UserProfile] ([UserId], [FirstName], [MiddleName], [LastName], [Gender], [Phone], [CityId], [BornCityId], [ZipId], [ProfilePhotoUrl], [CoverPhotoIUrl], [Biography], [RelationshipId], [CreationDate]) VALUES (N'E027A633-ADB8-4E8D-BF4F-E2A1FA0979EB', N'Matthias', N'T', N'Berndt                                            ', 0, NULL, 108, NULL, NULL, NULL, NULL, NULL, 3, CAST(N'2020-12-25T00:00:00.000' AS DateTime))
INSERT [Users].[UserProfile] ([UserId], [FirstName], [MiddleName], [LastName], [Gender], [Phone], [CityId], [BornCityId], [ZipId], [ProfilePhotoUrl], [CoverPhotoIUrl], [Biography], [RelationshipId], [CreationDate]) VALUES (N'EB098AE4-FFF9-44E6-BD77-A4FAE551D482', N'Alejandro', N'E', N'McGuel                                            ', 1, NULL, 85, NULL, NULL, NULL, NULL, NULL, 2, CAST(N'2020-12-25T00:00:00.000' AS DateTime))
INSERT [Users].[UserProfile] ([UserId], [FirstName], [MiddleName], [LastName], [Gender], [Phone], [CityId], [BornCityId], [ZipId], [ProfilePhotoUrl], [CoverPhotoIUrl], [Biography], [RelationshipId], [CreationDate]) VALUES (N'f660ab912ec121d1b1e928a0bb4bc61b15f5ad44d5efdc4e1c92a25e99b8e44a', N'Carole', N'M', N'Poland                                            ', 1, NULL, 109, NULL, NULL, NULL, NULL, NULL, 2, CAST(N'2020-12-25T00:00:00.000' AS DateTime))
GO
SET IDENTITY_INSERT [Users].[UserRoles] ON 

INSERT [Users].[UserRoles] ([RoleId], [RoleDescription]) VALUES (1, N'User      ')
INSERT [Users].[UserRoles] ([RoleId], [RoleDescription]) VALUES (2, N'Admin     ')
SET IDENTITY_INSERT [Users].[UserRoles] OFF
GO
SET IDENTITY_INSERT [Users].[ZipCodes] ON 

INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (3, N'34433', 34, N'CİHANGİR            ', N'BEYOĞLU             ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (7, N'34000', 34, N'ISTANBUL            ', N'ISTANBUL            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (8, N'34010', 34, N'TOPKAPI             ', N'ZEYTİNBURNU         ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (9, N'34015', 34, N'SEYİTNİZAM          ', N'ZEYTİNBURNU         ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (10, N'34020', 34, N'TELSİZ              ', N'ZEYTİNBURNU         ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (11, N'34025', 34, N'ÇIRPICI             ', N'ZEYTİNBURNU         ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (12, N'34120', 34, N'MAHMUTPAŞA          ', N'ISTANBUL            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (13, N'34035', 34, N'ALTINTEPSİ          ', N'BAYRAMPAŞA          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (14, N'34040', 34, N'MURATPAŞA           ', N'BAYRAMPAŞA          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (15, N'34045', 34, N'YILDIRIM            ', N'BAYRAMPAŞA          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (16, N'34116', 34, N'TAHTAKALE           ', N'FATİH               ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (17, N'34050', 34, N'EYÜP                ', N'EYÜP                ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (18, N'34055', 34, N'RAMİ                ', N'EYÜP                ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (19, N'34060', 34, N'ALİBEYKÖY           ', N'EYÜP                ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (20, N'34076', 34, N'MERKEZKÖY           ', N'EYÜP                ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (21, N'34080', 34, N'İSKENDERPAŞA        ', N'FATİH               ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (22, N'34087', 34, N'BALAT               ', N'FATİH               ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (23, N'34091', 34, N'KARAGÜMRÜK          ', N'FATİH               ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (24, N'34093', 34, N'TOPKAPI             ', N'FATİH               ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (25, N'34098', 34, N'KOCAMUSTAFAPAŞA     ', N'FATİH               ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (26, N'34104', 34, N'ŞEHREMİNİ           ', N'FATİH               ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (27, N'34112', 34, N'SİRKECİ             ', N'FATİH               ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (28, N'34140', 34, N'ZEYTINLIK           ', N'BAKIRKOY            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (29, N'34142', 34, N'CEVIZLI             ', N'BAKIRKOY            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (30, N'34145', 34, N'KARTALTEPE          ', N'BAKIRKOY            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (31, N'34146', 34, N'OSMANIYE            ', N'BAKIRKOY            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (32, N'34149', 34, N'YESILKOY            ', N'BAKIRKOY            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (33, N'34153', 34, N'FLORYA              ', N'BAKIRKOY            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (34, N'34158', 34, N'ATAKOY              ', N'BAKIRKOY            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (35, N'34174', 34, N'ZUHURATBABA         ', N'BAKIRKOY            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (36, N'34180', 34, N'BAHCELIEVLER        ', N'BAHCELIEVLER        ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (37, N'34182', 34, N'SIYAVUSPASA         ', N'BAHCELIEVLER        ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (38, N'34183', 34, N'SOGANLI             ', N'BAHCELIEVLER        ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (39, N'34186', 34, N'CUMHURIYET          ', N'BAHCELIEVLER        ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (40, N'34188', 34, N'SIRINEVLER          ', N'BAHCELIEVLER        ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (41, N'34192', 34, N'KOCASINAN           ', N'BAHCELIEVLER        ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (42, N'34194', 34, N'FEVZICAKMAK         ', N'BAHCELIEVLER        ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (43, N'34196', 34, N'COBANCESME          ', N'BAHCELIEVLER        ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (44, N'34197', 34, N'YENIBOSNA           ', N'BAHCELIEVLER        ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (45, N'34200', 34, N'BAGCILAR            ', N'BAGCILAR            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (46, N'34203', 34, N'BARBAROS            ', N'BAGCILAR            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (47, N'34204', 34, N'KEMALPASA           ', N'BAGCILAR            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (48, N'34209', 34, N'HURRIYET            ', N'BAGCILAR            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (49, N'34210', 34, N'KIRAZLI             ', N'BAGCILAR            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (50, N'34212', 34, N'GUNESLI             ', N'BAGCILAR            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (51, N'34214', 34, N'DEMIRKAPI           ', N'BAGCILAR            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (52, N'34218', 34, N'MAHMUTBEY           ', N'BAGCILAR            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (53, N'34275', 34, N'ARNAVUTKOY          ', N'ARNAVUTKOY          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (54, N'34281', 34, N'HARACCI             ', N'ARNAVUTKOY          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (55, N'34283', 34, N'TASOLUK             ', N'ARNAVUTKOY          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (56, N'34285', 34, N'BOGAZKOY            ', N'ARNAVUTKOY          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (57, N'34287', 34, N'BOLLUCA             ', N'ARNAVUTKOY          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (58, N'34310', 34, N'AVCILAR             ', N'AVCILAR             ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (59, N'34315', 34, N'AMBARLI             ', N'AVCILAR             ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (60, N'34320', 34, N'GUMUSPALA           ', N'AVCILAR             ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (61, N'34325', 34, N'FIRUZKOY            ', N'AVCILAR             ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (62, N'34360', 34, N'19MAYIS             ', N'SISLI               ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (63, N'34375', 34, N'BOZKURT             ', N'SISLI               ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (64, N'34377', 34, N'FERIKOY             ', N'SISLI               ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (65, N'34379', 34, N'DUATEPE             ', N'SISLI               ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (66, N'34380', 34, N'CUMHURIYET          ', N'SISLI               ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (67, N'34394', 34, N'ESENTEPE            ', N'SISLI               ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (68, N'34480', 34, N'BASAKSEHIR          ', N'BASAKSEHIR          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (69, N'34488', 34, N'BAHCESEHIR          ', N'BASAKSEHIR          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (70, N'34490', 34, N'IKITELLI            ', N'BASAKSEHIR          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (71, N'34494', 34, N'ALTINSEHIR          ', N'BASAKSEHIR          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (72, N'34555', 34, N'HADIMKOY            ', N'ARNAVUTKOY          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (73, N'34557', 34, N'DURUSU              ', N'ARNAVUTKOY          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (74, N'34704', 34, N'ORNEK               ', N'ATASEHİR            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (75, N'34707', 34, N'MUSTAFAKEMAL        ', N'ATASEHİR            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (76, N'34746', 34, N'YENISAHRA           ', N'ATASEHİR            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (77, N'34750', 34, N'KUCUKBAKKALKOY      ', N'ATASEHİR            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (78, N'34752', 34, N'ICERENKOY           ', N'ATASEHİR            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (79, N'34755', 34, N'KAYISDAGI           ', N'ATASEHİR            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (80, N'34758', 34, N'ATATURK             ', N'ATASEHİR            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (81, N'34779', 34, N'YENICAMLICA         ', N'ATASEHİR            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (82, N'34888', 34, N'FERHATPASA          ', N'ATASEHİR            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (83, N'34970', 34, N'BUYUKADA            ', N'ADALAR              ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (84, N'34973', 34, N'HEYBELIADA          ', N'ADALAR              ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (85, N'34975', 34, N'BURGAZADA           ', N'ADALAR              ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (86, N'34977', 34, N'KINALIADA           ', N'ADALAR              ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (87, N'07081', 83, N'SPRINGFIELD         ', N'NEW JERSEY          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (89, N'01906', 110, N'Saugus              ', N'Massachusetts       ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (90, N'02062', 110, N'Norwood             ', N'Massachusetts       ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (91, N'02093', 110, N'Wrentham            ', N'Massachusetts       ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (92, N'02113', 110, N'Boston              ', N'Massachusetts       ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (93, N'02139', 110, N'Cambridge           ', N'Massachusetts       ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (94, N'02184', 110, N'Braintree           ', N'Massachusetts       ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (95, N'02368', 110, N'Randolph            ', N'Massachusetts       ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (96, N'02889', 131, N'Warwick             ', N'Rhode Island        ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (97, N'02892', 131, N'West Kingston       ', N'Rhode Island        ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (98, N'02895', 131, N'Woonsocket          ', N'Rhode Island        ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (99, N'03064', 121, N'Nashua              ', N'New Hampshire       ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (100, N'03106', 121, N'Hooksett            ', N'New Hampshire       ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (101, N'03276', 121, N'Tilton              ', N'New Hampshire       ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (102, N'03865', 121, N'Plaistow            ', N'New Hampshire       ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (103, N'03904', 112, N'Kittery             ', N'Maine               ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (104, N'06032', 96, N'Farmington          ', N'Connecticut         ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (105, N'06460', 96, N'Milford             ', N'Connecticut         ')
GO
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (106, N'06510', 96, N'New Haven           ', N'Connecticut         ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (107, N'06512', 96, N'East Haven          ', N'Connecticut         ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (108, N'06518', 96, N'Hamden              ', N'Connecticut         ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (109, N'06710', 96, N'Waterbury           ', N'Connecticut         ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (110, N'06880', 96, N'Westport            ', N'Connecticut         ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (111, N'06901', 96, N'Stamford            ', N'Connecticut         ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (112, N'10007', 125, N'New York            ', N'New York            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (113, N'10917', 125, N'Central Valley      ', N'New York            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (114, N'11580', 125, N'Valley Stream       ', N'New York            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (115, N'11747', 125, N'Melville            ', N'New York            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (116, N'12210', 125, N'Albany              ', N'New York            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (117, N'12845', 125, N'Lake George         ', N'New York            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (118, N'13041', 125, N'Clay                ', N'New York            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (119, N'13214', 125, N'De Witt             ', N'New York            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (120, N'13413', 125, N'New Hartford        ', N'New York            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (121, N'13760', 125, N'Endicott            ', N'New York            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (122, N'14227', 125, N'Cheektowaga         ', N'New York            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (123, N'14850', 125, N'Ithaca              ', N'New York            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (124, N'19107', 129, N'Philadelphia        ', N'Pennsylvania        ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (125, N'20151', 137, N'Chantilly           ', N'Virginia            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (126, N'20176', 137, N'Leesburg            ', N'Virginia            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (127, N'21201', 111, N'Baltimore           ', N'Maryland            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (128, N'22046', 137, N'Falls Church        ', N'Virginia            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (129, N'23451', 137, N'Virginia Beach      ', N'Virginia            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (130, N'23607', 137, N'Newport News        ', N'Virginia            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (131, N'27104', 118, N'Winston-Salem       ', N'North Carolina      ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (132, N'27412', 118, N'Greensboro          ', N'North Carolina      ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (133, N'27577', 118, N'Smithfield          ', N'North Carolina      ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (134, N'27603', 118, N'Raleigh             ', N'North Carolina      ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (135, N'27803', 118, N'Rocky Mount         ', N'North Carolina      ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (136, N'28081', 118, N'Kannapolis          ', N'North Carolina      ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (137, N'28202', 118, N'Charlotte           ', N'North Carolina      ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (138, N'29340', 132, N'Gaffney             ', N'South Carolina      ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (139, N'29577', 132, N'Myrtle Beach        ', N'South Carolina      ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (140, N'29910', 132, N'Bluffton            ', N'South Carolina      ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (141, N'30021', 100, N'Clarkston           ', N'Georgia             ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (142, N'30024', 100, N'Suwanee             ', N'Georgia             ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (143, N'30030', 100, N'Decatur             ', N'Georgia             ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (144, N'30060', 100, N'Marietta            ', N'Georgia             ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (145, N'30106', 100, N'Austell             ', N'Georgia             ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (146, N'30240', 100, N'La Grange           ', N'Georgia             ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (147, N'30253', 100, N'Mcdonough           ', N'Georgia             ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (148, N'30308', 100, N'Atlanta             ', N'Georgia             ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (149, N'30901', 100, N'Augusta             ', N'Georgia             ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (150, N'31008', 100, N'Byron               ', N'Georgia             ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (151, N'31401', 100, N'Savannah            ', N'Georgia             ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (152, N'31901', 100, N'Columbus            ', N'Georgia             ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (153, N'32541', 99, N'Destin              ', N'Florida             ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (154, N'32701', 99, N'Altamonte Springs   ', N'Florida             ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (155, N'32804', 99, N'Orlando             ', N'Florida             ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (156, N'32952', 99, N'Merritt Island      ', N'Florida             ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (157, N'32960', 99, N'Vero Beach          ', N'Florida             ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (158, N'33021', 99, N'Hollywood           ', N'Florida             ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (159, N'33127', 99, N'Miami               ', N'Florida             ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (160, N'33143', 99, N'Kendall             ', N'Florida             ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (161, N'33162', 99, N'North Miami Beach   ', N'Florida             ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (162, N'33322', 99, N'Sunrise             ', N'Florida             ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (163, N'33602', 99, N'Tampa               ', N'Florida             ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (164, N'33755', 99, N'Clearwater          ', N'Florida             ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (165, N'33801', 99, N'Lakeland            ', N'Florida             ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (166, N'34205', 99, N'Bradenton           ', N'Florida             ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (167, N'34236', 99, N'Sarasota            ', N'Florida             ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (168, N'35203', 91, N'Birmingham          ', N'Alabama             ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (169, N'35630', 91, N'Florence            ', N'Alabama             ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (170, N'35801', 91, N'Huntsville          ', N'Alabama             ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (171, N'36104', 91, N'Montgomery          ', N'Alabama             ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (172, N'36602', 91, N'Mobile              ', N'Alabama             ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (173, N'37086', 134, N'La Vergne           ', N'Tennessee           ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (174, N'37203', 134, N'Nashville           ', N'Tennessee           ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (175, N'37343', 134, N'Hixson              ', N'Tennessee           ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (176, N'37501', 134, N'Downey              ', N'Tennessee           ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (177, N'37660', 134, N'Kingsport           ', N'Tennessee           ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (178, N'37801', 134, N'Maryville           ', N'Tennessee           ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (179, N'37863', 134, N'Pigeon Forge        ', N'Tennessee           ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (180, N'38054', 134, N'Millington          ', N'Tennessee           ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (181, N'38103', 134, N'Memphis             ', N'Tennessee           ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (182, N'38555', 134, N'Crossville          ', N'Tennessee           ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (183, N'38804', 116, N'Tupelo              ', N'Mississippi         ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (184, N'39501', 116, N'Gulfport            ', N'Mississippi         ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (185, N'39530', 116, N'Biloxi              ', N'Mississippi         ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (186, N'40207', 108, N'Saint Matthews      ', N'Kentucky            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (187, N'41042', 108, N'Florence            ', N'Kentucky            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (188, N'41071', 108, N'Newport             ', N'Kentucky            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (189, N'42501', 108, N'Somerset            ', N'Kentucky            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (190, N'42718', 108, N'Campbellsville      ', N'Kentucky            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (191, N'43056', 126, N'Heath               ', N'Ohio                ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (192, N'43215', 126, N'Columbus            ', N'Ohio                ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (193, N'43528', 126, N'Holland             ', N'Ohio                ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (194, N'44060', 126, N'Mentor              ', N'Ohio                ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (195, N'44074', 126, N'Oberlin             ', N'Ohio                ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (196, N'44119', 126, N'Euclid              ', N'Ohio                ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (197, N'44128', 126, N'North Randall       ', N'Ohio                ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (198, N'44214', 126, N'Burbank             ', N'Ohio                ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (199, N'44903', 126, N'Mansfield           ', N'Ohio                ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (200, N'45202', 126, N'Cincinnati          ', N'Ohio                ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (201, N'45246', 126, N'Springdale          ', N'Ohio                ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (202, N'46204', 106, N'Indianapolis        ', N'Indiana             ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (203, N'46360', 106, N'Michigan City       ', N'Indiana             ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (204, N'46601', 106, N'South Bend          ', N'Indiana             ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (205, N'46807', 106, N'Fort Wayne          ', N'Indiana             ')
GO
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (206, N'46947', 106, N'Logansport          ', N'Indiana             ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (207, N'47334', 85, N'Daleville           ', N'Indiana             ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (208, N'47362', 85, N'New Castle          ', N'Indiana             ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (209, N'48034', 85, N'Southfield          ', N'Michigan            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (210, N'48060', 85, N'Port Huron          ', N'Michigan            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (211, N'48071', 85, N'Madison Heights     ', N'Michigan            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (212, N'48185', 85, N'Westland            ', N'Michigan            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (213, N'48195', 85, N'Southgate           ', N'Michigan            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (214, N'48226', 85, N'Detroit             ', N'Michigan            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (215, N'48239', 85, N'Redford             ', N'Michigan            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (216, N'48342', 85, N'Pontiac             ', N'Michigan            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (217, N'48375', 85, N'Novi                ', N'Michigan            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (218, N'48601', 85, N'Saginaw             ', N'Michigan            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (219, N'48640', 85, N'Midland             ', N'Michigan            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (220, N'48843', 85, N'Howell              ', N'Michigan            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (221, N'49423', 85, N'Holland             ', N'Michigan            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (222, N'49464', 85, N'Zeeland             ', N'Michigan            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (223, N'53038', 85, N'Johnson Creek       ', N'Wisconsin           ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (224, N'53182', 85, N'Racine              ', N'Wisconsin           ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (225, N'53202', 85, N'Milwaukee           ', N'Wisconsin           ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (226, N'54455', 85, N'Mosinee             ', N'Wisconsin           ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (227, N'55049', 85, N'Medford             ', N'Minnesota           ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (228, N'55056', 85, N'Branch              ', N'Minnesota           ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (229, N'55125', 85, N'Woodbury            ', N'Minnesota           ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (230, N'55402', 85, N'Minneapolis         ', N'Minnesota           ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (231, N'55436', 85, N'Edina               ', N'Minnesota           ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (232, N'55802', 85, N'Duluth              ', N'Minnesota           ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (233, N'57049', 85, N'North Sioux City    ', N'South Dakota        ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (234, N'57716', 85, N'Denby               ', N'South Dakota        ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (235, N'59101', 85, N'Billings            ', N'Montana             ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (236, N'59401', 85, N'Great Falls         ', N'Montana             ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (237, N'59715', 85, N'Mill Valley         ', N'Montana             ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (238, N'59801', 85, N'Missoula            ', N'Montana             ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (239, N'60120', 85, N'Elgin               ', N'Illinois            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (240, N'60185', 85, N'West Chicago        ', N'Illinois            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (241, N'60188', 85, N'Carol Stream        ', N'Illinois            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (242, N'60191', 85, N'Wood Dale           ', N'Illinois            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (243, N'60433', 85, N'Joliet              ', N'Illinois            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (244, N'60610', 85, N'Chicago             ', N'Illinois            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (245, N'60706', 85, N'Norridge            ', N'Illinois            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (246, N'61265', 85, N'Moline              ', N'Illinois            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (247, N'61606', 85, N'Peoria              ', N'Illinois            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (248, N'61953', 85, N'Tuscola             ', N'Illinois            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (249, N'63074', 85, N'Saint Ann           ', N'Missouri            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (250, N'63103', 85, N'Saint Louis         ', N'Missouri            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (251, N'63103', 85, N'St. Louis           ', N'Missouri            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (252, N'63135', 85, N'Ferguson            ', N'Missouri            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (253, N'63301', 85, N'Lakewood            ', N'Missouri            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (254, N'64076', 85, N'Odessa              ', N'Missouri            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (255, N'64106', 85, N'Kansas City         ', N'Missouri            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (256, N'65101', 85, N'Jefferson City      ', N'Missouri            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (257, N'65616', 85, N'Branson             ', N'Missouri            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (258, N'68601', 85, N'Mill Valley         ', N'Nebraska            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (259, N'75006', 85, N'Carrollton          ', N'Texas               ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (260, N'75040', 85, N'Garland             ', N'Texas               ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (261, N'75061', 85, N'Irving              ', N'Texas               ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (262, N'75074', 85, N'Plano               ', N'Texas               ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (263, N'75149', 85, N'Mesquite            ', N'Texas               ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (264, N'75201', 85, N'Dallas              ', N'Texas               ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (265, N'76010', 85, N'Arlington           ', N'Texas               ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (266, N'76102', 85, N'Fort Worth          ', N'Texas               ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (267, N'76541', 85, N'Killeen             ', N'Texas               ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (268, N'76645', 85, N'Hillsboro           ', N'Texas               ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (269, N'77003', 85, N'Houston             ', N'Texas               ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (270, N'77338', 85, N'Humble              ', N'Texas               ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (271, N'77477', 85, N'Stafford            ', N'Texas               ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (272, N'77478', 85, N'Sugar Land          ', N'Texas               ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (273, N'77520', 85, N'Baytown             ', N'Texas               ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (274, N'77568', 85, N'La Marque           ', N'Texas               ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (275, N'77840', 85, N'College Station     ', N'Texas               ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (276, N'78040', 85, N'Laredo              ', N'Texas               ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (277, N'78204', 85, N'San Antonio         ', N'Texas               ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (278, N'78404', 85, N'Corpus Christi      ', N'Texas               ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (279, N'78613', 85, N'Cedar Park          ', N'Texas               ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (280, N'78664', 85, N'Round Rock          ', N'Texas               ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (281, N'78701', 85, N'Austin              ', N'Texas               ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (282, N'80030', 85, N'Westminster         ', N'Colorado            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (283, N'80110', 85, N'Englewood           ', N'Colorado            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (284, N'80138', 85, N'Parker              ', N'Colorado            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (285, N'80203', 85, N'Denver              ', N'Colorado            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (286, N'80501', 85, N'Longmont            ', N'Colorado            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (287, N'80537', 85, N'Loveland            ', N'Colorado            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (288, N'80631', 85, N'Greeley             ', N'Colorado            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (289, N'82001', 85, N'Cheyenne            ', N'Wyoming             ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (290, N'82070', 85, N'Novato              ', N'Wyoming             ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (291, N'82601', 85, N'Casper              ', N'Wyoming             ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (292, N'82901', 85, N'Rock Springs        ', N'Wyoming             ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (293, N'83301', 85, N'West Covina         ', N'Idaho               ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (294, N'83402', 85, N'Idaho Falls         ', N'Idaho               ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (295, N'83501', 85, N'Lewiston            ', N'Idaho               ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (296, N'83702', 85, N'Boise               ', N'Idaho               ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (297, N'83864', 85, N'Sandpoint           ', N'Idaho               ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (298, N'84010', 85, N'Bountiful           ', N'Utah                ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (299, N'84065', 85, N'Riverton            ', N'Utah                ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (300, N'84070', 85, N'Sandy               ', N'Utah                ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (301, N'84074', 85, N'Tooele              ', N'Utah                ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (302, N'84098', 85, N'Park City           ', N'Utah                ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (303, N'84101', 85, N'Salt Lake City      ', N'Utah                ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (304, N'84401', 85, N'Ogden               ', N'Utah                ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (305, N'84407', 85, N'Nevada              ', N'Utah                ')
GO
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (306, N'84720', 85, N'Cedar City          ', N'Utah                ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (307, N'85004', 85, N'Phoenix             ', N'Arizona             ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (308, N'85201', 85, N'Mesa                ', N'Arizona             ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (309, N'85225', 85, N'Chandler            ', N'Arizona             ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (310, N'85233', 85, N'Gilbert             ', N'Arizona             ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (311, N'85252', 85, N'Lemon Grove         ', N'Arizona             ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (312, N'85257', 85, N'Scottsdale          ', N'Arizona             ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (313, N'85284', 85, N'Lemon Grove         ', N'Arizona             ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (314, N'85374', 85, N'Surprise            ', N'Arizona             ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (315, N'85701', 85, N'Tucson              ', N'Arizona             ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (316, N'87124', 85, N'Rio Rancho          ', N'New Mexico          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (317, N'87501', 85, N'Santa Fe            ', N'New Mexico          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (318, N'88001', 85, N'Las Cruces          ', N'New Mexico          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (319, N'88044', 85, N'La Mesa             ', N'New Mexico          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (320, N'89030', 85, N'North Las Vegas     ', N'Nevada              ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (321, N'89106', 85, N'Las Vegas           ', N'Nevada              ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (322, N'89408', 85, N'Fernley             ', N'Nevada              ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (323, N'89431', 85, N'Sparks              ', N'Nevada              ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (324, N'89502', 85, N'Reno                ', N'Nevada              ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (325, N'89701', 85, N'W. Linn             ', N'Nevada              ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (326, N'90012', 85, N'Los Angeles         ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (327, N'90040', 85, N'City Of Commerce    ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (328, N'90201', 85, N'Bell Gardens        ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (329, N'90210', 85, N'Beverly Hills       ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (330, N'90232', 85, N'Culver City         ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (331, N'90241', 85, N'Downey              ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (332, N'90245', 85, N'El Segundo          ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (333, N'90401', 85, N'Santa Monica        ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (334, N'90505', 85, N'Torrance            ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (335, N'90605', 85, N'Whittier            ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (336, N'90650', 85, N'Norwalk             ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (337, N'90703', 85, N'Cerritos            ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (338, N'90706', 85, N'Bellflower          ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (339, N'90712', 85, N'Lakewood            ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (340, N'90746', 85, N'Carson              ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (341, N'90802', 85, N'Long Beach          ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (342, N'91001', 85, N'Altadena            ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (343, N'91016', 85, N'Monrovia            ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (344, N'91203', 85, N'Glendale            ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (345, N'91303', 85, N'Canoga Park         ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (346, N'91364', 85, N'Woodland Hills      ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (347, N'91403', 85, N'Sherman Oaks        ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (348, N'91411', 85, N'Van Nuys            ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (349, N'91502', 85, N'Burbank             ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (350, N'91706', 85, N'Baldwin Park        ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (351, N'91764', 85, N'Ontario             ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (352, N'91776', 85, N'San Gabriel         ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (353, N'91786', 85, N'Upland              ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (354, N'91791', 85, N'West Covina         ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (355, N'91801', 85, N'Alhambra            ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (356, N'91901', 85, N'Alpine              ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (357, N'91910', 85, N'Chula Vista         ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (358, N'91932', 85, N'Imperial Beach      ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (359, N'91941', 85, N'Grossmont           ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (360, N'91941', 85, N'La Mesa             ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (361, N'91945', 85, N'Lemon Grove         ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (362, N'91950', 85, N'Lincoln Acres       ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (363, N'91950', 85, N'National City       ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (364, N'91977', 85, N'Spring Valley       ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (365, N'92020', 85, N'El Cajon            ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (366, N'92025', 85, N'Escondido           ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (367, N'92084', 85, N'Vista               ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (368, N'92102', 85, N'San Diego           ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (369, N'92118', 85, N'Coronado            ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (370, N'92173', 85, N'San Ysidro          ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (371, N'92311', 85, N'Barstow             ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (372, N'92335', 85, N'Fontana             ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (373, N'92373', 85, N'Redlands            ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (374, N'92530', 85, N'Lake Elsinore       ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (375, N'92614', 85, N'Irvine              ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (376, N'92625', 85, N'Newport Beach       ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (377, N'92679', 85, N'Trabuco Canyon      ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (378, N'92701', 85, N'Santa Ana           ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (379, N'92806', 85, N'La Jolla            ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (380, N'92831', 85, N'Fullerton           ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (381, N'92867', 85, N'Orange              ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (382, N'93010', 85, N'Camarillo           ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (383, N'93030', 85, N'Oxnard              ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (384, N'93065', 85, N'Simi Valley         ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (385, N'93230', 85, N'Hanford             ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (386, N'93291', 85, N'Visalia             ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (387, N'93955', 85, N'Sand City           ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (388, N'94010', 85, N'Burlingame          ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (389, N'94014', 85, N'Colma               ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (390, N'94015', 85, N'Daly City           ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (391, N'94063', 85, N'Redwood City        ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (392, N'94066', 85, N'San Bruno           ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (393, N'94070', 85, N'San Carlos          ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (394, N'94109', 85, N'San Francisco       ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (395, N'94303', 85, N'Palo Alto           ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (396, N'94404', 85, N'San Mateo           ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (397, N'94519', 85, N'Concord             ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (398, N'94536', 85, N'Fremont             ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (399, N'94541', 85, N'Hayward             ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (400, N'94560', 85, N'Newark              ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (401, N'94566', 85, N'Pleasanton          ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (402, N'94583', 85, N'San Ramon           ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (403, N'94587', 85, N'Union City          ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (404, N'94596', 85, N'Walnut Creek        ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (405, N'94611', 85, N'Oakland             ', N'California          ')
GO
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (406, N'94704', 85, N'Berkeley            ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (407, N'94801', 85, N'Richmond            ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (408, N'94941', 85, N'Mill Valley         ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (409, N'94947', 85, N'Novato              ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (410, N'95020', 85, N'Gilroy              ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (411, N'95035', 85, N'Milpitas            ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (412, N'95062', 85, N'Santa Cruz          ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (413, N'95112', 85, N'San Jose            ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (414, N'95202', 85, N'Stockton            ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (415, N'95354', 85, N'Modesto             ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (416, N'95501', 85, N'Eureka              ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (417, N'95603', 85, N'Auburn              ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (418, N'95610', 85, N'Citrus Heights      ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (419, N'95624', 85, N'Elk Grove           ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (420, N'95688', 85, N'Vacaville           ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (421, N'95814', 85, N'Sacramento          ', N'California          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (422, N'97005', 85, N'Beaverton           ', N'Oregon              ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (423, N'97015', 85, N'Clackamas           ', N'Oregon              ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (424, N'97015-6403', 85, N'Clackamas           ', N'Oregon              ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (425, N'97034', 85, N'Lake Oswego         ', N'Oregon              ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (426, N'97045', 85, N'Oregon City         ', N'Oregon              ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (427, N'97060', 85, N'Troutdale           ', N'Oregon              ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (428, N'97068', 85, N'W. Linn             ', N'Oregon              ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (429, N'97071', 85, N'Woodburn            ', N'Oregon              ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (430, N'97123', 85, N'Hillsboro           ', N'Oregon              ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (431, N'97205', 85, N'Portland            ', N'Oregon              ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (432, N'97222', 85, N'Milwaukie           ', N'Oregon              ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (433, N'97223', 85, N'Tigard              ', N'Oregon              ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (434, N'97301', 85, N'Salem               ', N'Oregon              ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (435, N'97321', 85, N'Albany              ', N'Oregon              ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (436, N'97330', 85, N'Corvallis           ', N'Oregon              ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (437, N'97355', 85, N'Lebanon             ', N'Oregon              ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (438, N'97477', 85, N'Springfield         ', N'Oregon              ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (439, N'97504', 85, N'Medford             ', N'Oregon              ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (440, N'97601', 85, N'Klamath Falls       ', N'Oregon              ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (441, N'98003', 85, N'Federal Way         ', N'Washington          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (442, N'98004', 85, N'Bellevue            ', N'Washington          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (443, N'98006', 85, N'Newport Hills       ', N'Washington          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (444, N'98011', 85, N'Bothell             ', N'Washington          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (445, N'98014', 85, N'Carnation           ', N'Washington          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (446, N'98019', 85, N'Duvall              ', N'Washington          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (447, N'98020', 85, N'Edmonds             ', N'Washington          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (448, N'98027', 85, N'Issaquah            ', N'Washington          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (449, N'98028', 85, N'Kenmore             ', N'Washington          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (450, N'98031', 85, N'Kent                ', N'Washington          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (451, N'98033', 85, N'Kirkland            ', N'Washington          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (452, N'98036', 85, N'Lynnwood            ', N'Washington          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (453, N'98045', 85, N'North Bend          ', N'Washington          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (454, N'98052', 85, N'Redmond             ', N'Washington          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (455, N'98055', 85, N'Renton              ', N'Washington          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (456, N'98072', 85, N'Woodinville         ', N'Washington          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (457, N'98074', 85, N'Sammamish           ', N'Washington          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (458, N'98104', 85, N'Seattle             ', N'Washington          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (459, N'98107', 85, N'Ballard             ', N'Washington          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (460, N'98168', 85, N'Burien              ', N'Washington          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (461, N'98201', 85, N'Everett             ', N'Montana             ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (462, N'98201', 85, N'Everett             ', N'Washington          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (463, N'98221', 85, N'Anacortes           ', N'Washington          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (464, N'98225', 85, N'Bellingham          ', N'Washington          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (465, N'98251', 85, N'Gold Bar            ', N'Washington          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (466, N'98256', 85, N'Index               ', N'Washington          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (467, N'98270', 85, N'Marysville          ', N'Washington          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (468, N'98272', 85, N'Monroe              ', N'Michigan            ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (469, N'98272', 85, N'Monroe              ', N'Washington          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (470, N'98284', 85, N'Sedro Woolley       ', N'Washington          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (471, N'98296', 85, N'Snohomish           ', N'Washington          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (472, N'98312', 85, N'Bremerton           ', N'Washington          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (473, N'98366', 85, N'Port Orchard        ', N'Washington          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (474, N'98371', 85, N'Puyallup            ', N'Washington          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (475, N'98382', 85, N'Sequim              ', N'Washington          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (476, N'98403', 85, N'Tacoma              ', N'Washington          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (477, N'98501', 85, N'Olympia             ', N'Washington          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (478, N'98503', 85, N'Lacey               ', N'Washington          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (479, N'98532', 85, N'Chehalis            ', N'Washington          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (480, N'98584', 85, N'Shelton             ', N'Washington          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (481, N'98626', 85, N'Kelso               ', N'Washington          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (482, N'98632', 85, N'Longview            ', N'Washington          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (483, N'98671', 85, N'Washougal           ', N'Washington          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (484, N'98801', 85, N'Wenatchee           ', N'Washington          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (485, N'98901', 85, N'Yakima              ', N'Washington          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (486, N'98903', 85, N'Union Gap           ', N'Washington          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (487, N'98926', 85, N'Ellensburg          ', N'Washington          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (488, N'99202', 85, N'Spokane             ', N'Washington          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (489, N'99337', 85, N'Kennewick           ', N'Washington          ')
INSERT [Users].[ZipCodes] ([ZipId], [ZipCode], [CityId], [State], [Province]) VALUES (490, N'99362', 85, N'Walla Walla         ', N'Washington          ')
SET IDENTITY_INSERT [Users].[ZipCodes] OFF
GO
/****** Object:  Index [IX_RoleId]    Script Date: 30.12.2020 17:51:35 ******/
CREATE NONCLUSTERED INDEX [IX_RoleId] ON [Users].[UserAccount_Roles]
(
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_UserId]    Script Date: 30.12.2020 17:51:35 ******/
CREATE NONCLUSTERED INDEX [IX_UserId] ON [Users].[UserAccount_Roles]
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__UserAcco__1788CC4D126C23CB]    Script Date: 30.12.2020 17:51:35 ******/
ALTER TABLE [Users].[UserAccounts] ADD  CONSTRAINT [UQ__UserAcco__1788CC4D126C23CB] UNIQUE NONCLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ_UserAccounts_Email]    Script Date: 30.12.2020 17:51:35 ******/
ALTER TABLE [Users].[UserAccounts] ADD  CONSTRAINT [UQ_UserAccounts_Email] UNIQUE NONCLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ_UserAccounts_Username]    Script Date: 30.12.2020 17:51:35 ******/
ALTER TABLE [Users].[UserAccounts] ADD  CONSTRAINT [UQ_UserAccounts_Username] UNIQUE NONCLUSTERED 
(
	[Username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [Shares].[Comments] ADD  CONSTRAINT [DF_Comments_CommentDatetime]  DEFAULT (getdate()) FOR [CommentDatetime]
GO
ALTER TABLE [Shares].[DirectMessages] ADD  CONSTRAINT [DF_DirectMessages_MessageDateTime]  DEFAULT (getdate()) FOR [MessageDateTime]
GO
ALTER TABLE [Shares].[DirectMessages] ADD  CONSTRAINT [DF_DirectMessages_Status]  DEFAULT ((0)) FOR [Status]
GO
ALTER TABLE [Shares].[UserLogs] ADD  CONSTRAINT [DF_UserLogs_LogDateTime]  DEFAULT (getdate()) FOR [LogDateTime]
GO
ALTER TABLE [Shares].[WallPosts] ADD  CONSTRAINT [DF_WallPosts_PostDateTime]  DEFAULT (getdate()) FOR [PostDateTime]
GO
ALTER TABLE [Shares].[WallPosts] ADD  CONSTRAINT [DF_WallPosts_PrivacyId]  DEFAULT ((1)) FOR [PrivacyId]
GO
ALTER TABLE [Users].[Cities] ADD  CONSTRAINT [DF_Cities_CountryId]  DEFAULT ((218)) FOR [CountryId]
GO
ALTER TABLE [Users].[Friends] ADD  CONSTRAINT [DF_Friends_CreateOn]  DEFAULT (getdate()) FOR [CreateOn]
GO
ALTER TABLE [Users].[RequestFriend] ADD  CONSTRAINT [DF_RequestFriend_Status]  DEFAULT ((0)) FOR [Status]
GO
ALTER TABLE [Users].[RequestFriend] ADD  CONSTRAINT [DF_RequestFriend_RequestDateTİme]  DEFAULT (getdate()) FOR [RequestDateTime]
GO
ALTER TABLE [Users].[UserAccount_Roles] ADD  CONSTRAINT [DF_UserAccount_Roles_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]
GO
ALTER TABLE [Users].[UserAccounts] ADD  CONSTRAINT [DF_UserAccounts_EmailConfirmed]  DEFAULT ((0)) FOR [EmailConfirmed]
GO
ALTER TABLE [Users].[UserAccounts] ADD  CONSTRAINT [DF_UserAccounts_PrivacyId]  DEFAULT ((1)) FOR [PrivacyId]
GO
ALTER TABLE [Users].[UserAccounts] ADD  CONSTRAINT [DF_UserAccounts_Enable]  DEFAULT ((1)) FOR [Enable]
GO
ALTER TABLE [Users].[UserAccounts] ADD  CONSTRAINT [DF_UserAccounts_AccessFailedCount]  DEFAULT ((0)) FOR [AccessFailedCount]
GO
ALTER TABLE [Users].[UserProfile] ADD  CONSTRAINT [DF_UserProfile_CityId]  DEFAULT ((34)) FOR [CityId]
GO
ALTER TABLE [Users].[UserProfile] ADD  CONSTRAINT [DF_UserProfile_RelationshipId]  DEFAULT ((1)) FOR [RelationshipId]
GO
ALTER TABLE [Users].[UserProfile] ADD  CONSTRAINT [DF_UserProfile_CreationDate]  DEFAULT (getdate()) FOR [CreationDate]
GO
ALTER TABLE [Shares].[Album]  WITH CHECK ADD  CONSTRAINT [FK_Album_UserProfile] FOREIGN KEY([Userid])
REFERENCES [Users].[UserProfile] ([UserId])
GO
ALTER TABLE [Shares].[Album] CHECK CONSTRAINT [FK_Album_UserProfile]
GO
ALTER TABLE [Shares].[Comments]  WITH CHECK ADD  CONSTRAINT [FK_Comments_UserProfile] FOREIGN KEY([AuthorId])
REFERENCES [Users].[UserProfile] ([UserId])
GO
ALTER TABLE [Shares].[Comments] CHECK CONSTRAINT [FK_Comments_UserProfile]
GO
ALTER TABLE [Shares].[Comments]  WITH CHECK ADD  CONSTRAINT [FK_Comments_WallPosts] FOREIGN KEY([PostId])
REFERENCES [Shares].[WallPosts] ([PostId])
GO
ALTER TABLE [Shares].[Comments] CHECK CONSTRAINT [FK_Comments_WallPosts]
GO
ALTER TABLE [Shares].[DirectMessages]  WITH CHECK ADD  CONSTRAINT [FK_DirectMessages_UserProfile] FOREIGN KEY([FriendId])
REFERENCES [Users].[UserProfile] ([UserId])
GO
ALTER TABLE [Shares].[DirectMessages] CHECK CONSTRAINT [FK_DirectMessages_UserProfile]
GO
ALTER TABLE [Shares].[DirectMessages]  WITH CHECK ADD  CONSTRAINT [FK_DirectMessages_UserProfile1] FOREIGN KEY([SenderId])
REFERENCES [Users].[UserProfile] ([UserId])
GO
ALTER TABLE [Shares].[DirectMessages] CHECK CONSTRAINT [FK_DirectMessages_UserProfile1]
GO
ALTER TABLE [Shares].[Likes]  WITH CHECK ADD  CONSTRAINT [FK_Likes_Comments] FOREIGN KEY([CommentID])
REFERENCES [Shares].[Comments] ([Commentd])
GO
ALTER TABLE [Shares].[Likes] CHECK CONSTRAINT [FK_Likes_Comments]
GO
ALTER TABLE [Shares].[Likes]  WITH CHECK ADD  CONSTRAINT [FK_Likes_UserProfile] FOREIGN KEY([UserId])
REFERENCES [Users].[UserProfile] ([UserId])
GO
ALTER TABLE [Shares].[Likes] CHECK CONSTRAINT [FK_Likes_UserProfile]
GO
ALTER TABLE [Shares].[Likes]  WITH CHECK ADD  CONSTRAINT [FK_Likes_WallPosts] FOREIGN KEY([PostID])
REFERENCES [Shares].[WallPosts] ([PostId])
GO
ALTER TABLE [Shares].[Likes] CHECK CONSTRAINT [FK_Likes_WallPosts]
GO
ALTER TABLE [Shares].[PhotoAlbum]  WITH CHECK ADD  CONSTRAINT [FK_PhotoAlbum_Album] FOREIGN KEY([AlbumId])
REFERENCES [Shares].[Album] ([AlbumId])
GO
ALTER TABLE [Shares].[PhotoAlbum] CHECK CONSTRAINT [FK_PhotoAlbum_Album]
GO
ALTER TABLE [Shares].[UserLogs]  WITH CHECK ADD  CONSTRAINT [FK_UserLogs_UserAccounts] FOREIGN KEY([UserId])
REFERENCES [Users].[UserAccounts] ([UserId])
GO
ALTER TABLE [Shares].[UserLogs] CHECK CONSTRAINT [FK_UserLogs_UserAccounts]
GO
ALTER TABLE [Shares].[WallPosts]  WITH CHECK ADD  CONSTRAINT [FK_WallPosts_Privacy] FOREIGN KEY([PrivacyId])
REFERENCES [Shares].[Privacy] ([PrivacyId])
GO
ALTER TABLE [Shares].[WallPosts] CHECK CONSTRAINT [FK_WallPosts_Privacy]
GO
ALTER TABLE [Users].[Cities]  WITH CHECK ADD  CONSTRAINT [FK_Cities_CountryId] FOREIGN KEY([CountryId])
REFERENCES [Users].[Countries] ([CountryId])
GO
ALTER TABLE [Users].[Cities] CHECK CONSTRAINT [FK_Cities_CountryId]
GO
ALTER TABLE [Users].[Friends]  WITH CHECK ADD  CONSTRAINT [FK_Friends_UserProfile] FOREIGN KEY([UserId])
REFERENCES [Users].[UserProfile] ([UserId])
GO
ALTER TABLE [Users].[Friends] CHECK CONSTRAINT [FK_Friends_UserProfile]
GO
ALTER TABLE [Users].[Friends]  WITH CHECK ADD  CONSTRAINT [FK_Friends_UserProfile1] FOREIGN KEY([FriendId])
REFERENCES [Users].[UserProfile] ([UserId])
GO
ALTER TABLE [Users].[Friends] CHECK CONSTRAINT [FK_Friends_UserProfile1]
GO
ALTER TABLE [Users].[RequestFriend]  WITH CHECK ADD  CONSTRAINT [FK_RequestFriend_UserProfile] FOREIGN KEY([UserId])
REFERENCES [Users].[UserProfile] ([UserId])
GO
ALTER TABLE [Users].[RequestFriend] CHECK CONSTRAINT [FK_RequestFriend_UserProfile]
GO
ALTER TABLE [Users].[RequestFriend]  WITH CHECK ADD  CONSTRAINT [FK_RequestFriend_UserProfile1] FOREIGN KEY([ReceiverID])
REFERENCES [Users].[UserProfile] ([UserId])
GO
ALTER TABLE [Users].[RequestFriend] CHECK CONSTRAINT [FK_RequestFriend_UserProfile1]
GO
ALTER TABLE [Users].[UserAccount_Roles]  WITH CHECK ADD  CONSTRAINT [FK_UserAccount_Roles_UserRoles] FOREIGN KEY([RoleId])
REFERENCES [Users].[UserRoles] ([RoleId])
GO
ALTER TABLE [Users].[UserAccount_Roles] CHECK CONSTRAINT [FK_UserAccount_Roles_UserRoles]
GO
ALTER TABLE [Users].[UserAccount_Roles]  WITH CHECK ADD  CONSTRAINT [FK_Users.UserAccountRoles_Users.UserAccounts_UserId] FOREIGN KEY([UserId])
REFERENCES [Users].[UserAccounts] ([UserId])
ON DELETE CASCADE
GO
ALTER TABLE [Users].[UserAccount_Roles] CHECK CONSTRAINT [FK_Users.UserAccountRoles_Users.UserAccounts_UserId]
GO
ALTER TABLE [Users].[UserAccounts]  WITH CHECK ADD  CONSTRAINT [FK_UserAccounts_Privacy] FOREIGN KEY([PrivacyId])
REFERENCES [Shares].[Privacy] ([PrivacyId])
GO
ALTER TABLE [Users].[UserAccounts] CHECK CONSTRAINT [FK_UserAccounts_Privacy]
GO
ALTER TABLE [Users].[UserProfile]  WITH CHECK ADD  CONSTRAINT [FK_UserProfile_BornCity] FOREIGN KEY([BornCityId])
REFERENCES [Users].[Cities] ([CityId])
GO
ALTER TABLE [Users].[UserProfile] CHECK CONSTRAINT [FK_UserProfile_BornCity]
GO
ALTER TABLE [Users].[UserProfile]  WITH CHECK ADD  CONSTRAINT [FK_UserProfile_CityId] FOREIGN KEY([CityId])
REFERENCES [Users].[Cities] ([CityId])
GO
ALTER TABLE [Users].[UserProfile] CHECK CONSTRAINT [FK_UserProfile_CityId]
GO
ALTER TABLE [Users].[UserProfile]  WITH CHECK ADD  CONSTRAINT [FK_UserProfile_Relationships] FOREIGN KEY([RelationshipId])
REFERENCES [Users].[Relationships] ([RelationshipId])
GO
ALTER TABLE [Users].[UserProfile] CHECK CONSTRAINT [FK_UserProfile_Relationships]
GO
ALTER TABLE [Users].[UserProfile]  WITH CHECK ADD  CONSTRAINT [FK_UserProfile_UserAccounts] FOREIGN KEY([UserId])
REFERENCES [Users].[UserAccounts] ([UserId])
GO
ALTER TABLE [Users].[UserProfile] CHECK CONSTRAINT [FK_UserProfile_UserAccounts]
GO
ALTER TABLE [Users].[UserProfile]  WITH CHECK ADD  CONSTRAINT [FK_UserProfile_ZipCodes] FOREIGN KEY([ZipId])
REFERENCES [Users].[ZipCodes] ([ZipId])
GO
ALTER TABLE [Users].[UserProfile] CHECK CONSTRAINT [FK_UserProfile_ZipCodes]
GO
ALTER TABLE [Users].[ZipCodes]  WITH CHECK ADD  CONSTRAINT [FK_ZipCodes_Cities] FOREIGN KEY([CityId])
REFERENCES [Users].[Cities] ([CityId])
GO
ALTER TABLE [Users].[ZipCodes] CHECK CONSTRAINT [FK_ZipCodes_Cities]
GO
/****** Object:  StoredProcedure [Shares].[GetSenderMessageCount]    Script Date: 30.12.2020 17:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create procedure [Shares].[GetSenderMessageCount] @Username varchar(128)
as
IF Exists (select*from Users.UserAccounts where Username=@Username) 
begin
select p.FirstName as Sender,pp.FirstName as Friend ,COUNT(*)as [Sended Message] from Shares.DirectMessages dm inner join Users.UserAccounts a on a.UserId=dm.SenderId 
inner join Users.UserProfile p on p.UserId=dm.SenderId inner join Users.UserProfile pp on pp.UserId=dm.FriendId 
where a.Username=@Username Group By p.FirstName , pp.FirstName
end
else
Begin 
Print 'User not found'
end
GO
/****** Object:  StoredProcedure [Shares].[GetUserPosts]    Script Date: 30.12.2020 17:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [Shares].[GetUserPosts]
@username varchar(256)
as
begin
	declare @Post nvarchar(500)
	declare crs CURSOR for select (P.PostMessage+' '+ISNULL(P.AtachmentUrl,' '))AS post from Shares.WallPosts P inner join Users.UserAccounts a on a.UserId=p.UserId where a.Username=@username
	Open crs 
	Fetch next from crs INTO @Post
	While @@FETCH_STATUS=0
	begin
	Print @Post
	Fetch next from crs INTO @Post
	end
	Close crs
	DEallocate crs
end
GO
/****** Object:  StoredProcedure [Shares].[SendDM]    Script Date: 30.12.2020 17:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Shares].[SendDM] @Sender varchar(256), @Receiever varchar(256),@Msg varchar(300)
as
Declare @Sid varchar(128)
Select @Sid=ua.UserId from Users.UserAccounts ua where ua.Username=@Sender and Enable=1
DEclare @Rid varchar(128)
Select @Rid=ua.UserId from Users.UserAccounts ua where ua.Username=@Receiever and Enable=1
if(@Sid is not null and @Rid is not null)
begin
if exists (select ff.Id from Users.Friends ff Where ff.UserId=@Sid and ff.FriendId=@Rid)
begin
insert into Shares.DirectMessages (SenderId,FriendId,DMMessage) values (@Sid,@Rid,@Msg)
insert into Shares.UserLogs (UserId,Event) values (@Sid,'Send Direct Message')
Print 'The message has been sent successfully.'
end
else
begin
Print 'Message could not be delivered, Friend not found or wrong entry'
end
end
else
begin
print 'Message could not be delivered, You or your Friend not have permission'
end
GO
/****** Object:  StoredProcedure [Shares].[SendPost]    Script Date: 30.12.2020 17:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Shares].[SendPost] @Sender varchar(256), @Attachment varchar(256),@Msg varchar(300)
as
Declare @Sid varchar(128)
Select @Sid=ua.UserId from Users.UserAccounts ua where ua.Username=@Sender and Enable=1
if(@Sid is not null)
Begin
if (@Msg is not null)
begin
insert into Shares.WallPosts (UserId,AtachmentUrl,PostMessage) values (@Sid,@Attachment,@Msg)
insert into Shares.UserLogs (UserId,Event) values (@Sid,'Send Post Message')
Print 'The message has been sent successfully.'
end
else
begin
Print 'Message could not be delivered, Message must have least one content'

end
end
else 
begin
Print 'This user not available or do not have a permission'
end
GO
/****** Object:  StoredProcedure [Users].[AverageGenders]    Script Date: 30.12.2020 17:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [Users].[AverageGenders]
as
Declare @AvgF float
set @AvgF= (Select Users.AverageGender(1))
Declare @AvgM float
set @AvgM= (Select Users.AverageGender(0))
Declare @myTable table
(Gender varchar(8),
Average float)



insert into @myTable Values ('Females',@AvgF),('Males',@AvgM)

Select*from @MyTable
GO
/****** Object:  StoredProcedure [Users].[BanUser]    Script Date: 30.12.2020 17:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [Users].[BanUser] @BanUsername varchar(256),@Enable bit
as
if exists (Select*from UserAccounts where Username=@BanUsername)
begin

update UserAccounts set Enable=@Enable where Username=@BanUsername
if(@Enable=1)
begin
print'User unblock successfully.'
end
else
begin
print'User banned succeed.'
end
end
else
begin
print'Wrong parameter entered.'
end
GO
/****** Object:  StoredProcedure [Users].[CreateUserProc]    Script Date: 30.12.2020 17:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Users].[CreateUserProc] @Username varchar(256),@Email varchar(256),@Password varchar(128),@Name varchar(50),@LastName varchar(50),@Gender bit
as
DECLARE @ID varchar(128)
set @ID=NEWID()
DECLARE @Salt varchar(128)
set @Salt = CONVERT(NVARCHAR(64),HashBytes('SHA2_256',@Email),2)
DECLARE @Passhs varchar(128)
set @Passhs =CONVERT(NVARCHAR(64),HASHBYTES('SHA2_256',@Salt+@Password),2)

Insert into Users.UserAccounts (UserId,Username,Email,PasswordHash,SecurityStamp) values (@ID,@Username,@Email,@Passhs,@Salt)
Insert into Users.UserProfile (UserId,FirstName,LastName,Gender) values (@ID,@Name,@LastName,@Gender)

GO
/****** Object:  StoredProcedure [Users].[FindSameCityUsers]    Script Date: 30.12.2020 17:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  CREATE PROCEDURE [Users].[FindSameCityUsers] @City nvarchar(30) 
  AS
  SELECT*FROM Users.ViewAllUserDetail ud WHERE ud.CityName=@City 
GO
/****** Object:  StoredProcedure [Users].[GetUserFriends]    Script Date: 30.12.2020 17:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Users].[GetUserFriends] @Username varchar(256)
as
declare @id varchar(128)
declare @name varchar(300)
select @id=UserId from Users.UserAccounts where Username=@Username
if  (@id is not null)
begin
if exists (select * from Users.Friends f where f.UserId=@id)
begin
Select (up.FirstName+' '+LastName)as 'User' from Users.UserProfile up where up.UserId=@id

select (uf.FirstName +' '+uf.LastName)as 'Friends' from Users.Friends f  inner join users.UserProfile uf on uf.UserId=f.FriendId where f.UserId=@id
end
else 
begin 
print 'The user has no friends yet'
end
end else
begin
print'Username not found'
end
GO
/****** Object:  StoredProcedure [Users].[GetUserinfo]    Script Date: 30.12.2020 17:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [Users].[GetUserinfo] @Username nvarchar(256)
as
IF exists (Select UserId from Users.UserAccounts where Username = @Username)
begin
Select * from Users.ViewAllUserDetail where Username=@Username 
end
else
begin 
Print'No such as Username'
end
GO
/****** Object:  StoredProcedure [Users].[LoginProc]    Script Date: 30.12.2020 17:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Users].[LoginProc] @Email varchar(128),@Pass varchar(50)
as
declare @id varchar(256)
Declare @salt varchar(256)
set @salt=(Select ua.SecurityStamp from Users.UserAccounts ua where @Email=Email)
declare @psh varchar(256)
set @psh=Convert(varchar(64),HASHBYTES('SHA2_256',@salt+@Pass),2)

Select @id=uu.UserId from Users.UserAccounts uu where uu.PasswordHash=@psh and uu.Email=@Email 
if exists(Select * from UserAccounts where Email=@Email and Enable=1)
begin
if  (@id= (Select uu.UserId from Users.UserAccounts uu where uu.PasswordHash=@psh and uu.Email=@Email))

begin

insert into Shares.UserLogs (UserId,Event) values (@id,'Login Success')
print'Login Success'
end
else 
begin
print 'Wrong values'
end
end
else
begin
print'Your account not available or suspended'
end
GO
/****** Object:  Trigger [Shares].[DeletePrivacy]    Script Date: 30.12.2020 17:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Trigger [Shares].[DeletePrivacy] on [Shares].[Privacy]
Instead of delete
as
Print 'You cannot delete action on this table'
GO
ALTER TABLE [Shares].[Privacy] ENABLE TRIGGER [DeletePrivacy]
GO
/****** Object:  Trigger [Shares].[UpdatePrivacy]    Script Date: 30.12.2020 17:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Trigger [Shares].[UpdatePrivacy] on [Shares].[Privacy]
Instead of Update
as
Print 'You cannot update action on this table'
GO
ALTER TABLE [Shares].[Privacy] ENABLE TRIGGER [UpdatePrivacy]
GO
/****** Object:  Trigger [Users].[DeleteCity]    Script Date: 30.12.2020 17:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [Users].[DeleteCity] on [Users].[Cities]
INSTEAD OF DELETE
AS 
PRINT 'You cannot delete a city in table'
GO
ALTER TABLE [Users].[Cities] ENABLE TRIGGER [DeleteCity]
GO
/****** Object:  Trigger [Users].[UpdateCity]    Script Date: 30.12.2020 17:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create trigger[Users].[UpdateCity] on[Users].[Cities]
INSTEAD OF UPDATE
AS
PRINT 'You cannot perform this aciton Update'
GO
ALTER TABLE [Users].[Cities] ENABLE TRIGGER [UpdateCity]
GO
/****** Object:  Trigger [Users].[AddCountry]    Script Date: 30.12.2020 17:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [Users].[AddCountry]
ON [Users].[Countries]
INSTEAD OF INSERT
AS
PRINT 'This table do not allow insert operation'
GO
ALTER TABLE [Users].[Countries] ENABLE TRIGGER [AddCountry]
GO
/****** Object:  Trigger [Users].[DeleteCountry]    Script Date: 30.12.2020 17:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [Users].[DeleteCountry]
on [Users].[Countries]
INSTEAD OF DELETE
AS
PRINT 'You Cannot delete a country'
GO
ALTER TABLE [Users].[Countries] ENABLE TRIGGER [DeleteCountry]
GO
/****** Object:  Trigger [Users].[UpdateCountry]    Script Date: 30.12.2020 17:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [Users].[UpdateCountry]
ON [Users].[Countries]
INSTEAD OF UPDATE
AS
PRINT 'This table do not allow UPDATE operation'
GO
ALTER TABLE [Users].[Countries] ENABLE TRIGGER [UpdateCountry]
GO
/****** Object:  Trigger [Users].[DeleteRelationships]    Script Date: 30.12.2020 17:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Trigger [Users].[DeleteRelationships] on [Users].[Relationships]
Instead of Delete
as
Print 'You cannot delete action on this table'


GO
ALTER TABLE [Users].[Relationships] ENABLE TRIGGER [DeleteRelationships]
GO
/****** Object:  Trigger [Users].[UpdateRelationships]    Script Date: 30.12.2020 17:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Trigger [Users].[UpdateRelationships] on [Users].[Relationships]
Instead of Update
as
Print 'You cannot update action on this table'
GO
ALTER TABLE [Users].[Relationships] ENABLE TRIGGER [UpdateRelationships]
GO
/****** Object:  Trigger [Users].[tAcceptBlockFriend]    Script Date: 30.12.2020 17:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE TRIGGER [Users].[tAcceptBlockFriend]
on [Users].[RequestFriend] 
After Update
as
Declare @UserID varchar(128)
Declare @FriendID varchar(128)
Declare @RID int
Declare @Status tinyint
Select @RID=ins.RequestId, @UserID=ins.UserId, @FriendID=ins.ReceiverID, @Status=ins.Status  from inserted ins
IF (@Status=2)
BEGIN
IF EXISTS (SELECT * FROM Users.Friends fa WHERE fa.UserId=@UserID and fa.FriendId=@FriendID)
	BEGIN
	
	delete Users.Friends  where UserId=@UserID and FriendId=@FriendID
	delete Users.Friends  where UserId=@FriendID and FriendId=@UserID
	END
END
IF(@Status=1)
BEGIN
IF NOT EXISTS (SELECT * FROM Users.Friends fa WHERE fa.UserId=@UserID and fa.FriendId=@FriendID)
	BEGIN
	insert into Friends (UserId,FriendId) Values (@UserID,@FriendID),(@FriendID,@UserID)
	END
END
else
BEGIN
PRINT''
END
GO
ALTER TABLE [Users].[RequestFriend] ENABLE TRIGGER [tAcceptBlockFriend]
GO
/****** Object:  Trigger [Users].[DeleteUserAccount]    Script Date: 30.12.2020 17:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Trigger [Users].[DeleteUserAccount] on [Users].[UserAccounts]
Instead of delete
as
Print 'You cannot delete action on this table'
GO
ALTER TABLE [Users].[UserAccounts] ENABLE TRIGGER [DeleteUserAccount]
GO
/****** Object:  Trigger [Users].[AddUserTrig]    Script Date: 30.12.2020 17:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [Users].[AddUserTrig] on [Users].[UserProfile]
AFTER INSERT
as 
Declare @ID varchar(128)
Select @ID=ins.UserId from inserted ins
begin
insert into Shares.Album (Userid,AlbumType)
values (@ID,'ProfilePhotos'),(@ID,'CoverPhotos');
IF Not exists (Select * from Users.UserAccount_Roles where RoleId=1 and UserId=@ID)
begin
insert into Users.UserAccount_Roles (UserId,RoleId)
Values(@ID,1)
end
end
GO
ALTER TABLE [Users].[UserProfile] ENABLE TRIGGER [AddUserTrig]
GO
/****** Object:  Trigger [Users].[DeleteUserProfile]    Script Date: 30.12.2020 17:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Trigger [Users].[DeleteUserProfile] on [Users].[UserProfile]
Instead of delete
as
Print 'You cannot delete action on this table'
GO
ALTER TABLE [Users].[UserProfile] ENABLE TRIGGER [DeleteUserProfile]
GO
/****** Object:  Trigger [Users].[ReadOnlyRoles]    Script Date: 30.12.2020 17:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create trigger[Users].[ReadOnlyRoles] on[Users].[UserRoles]
INSTEAD OF INSERT,UPDATE,DELETE
AS
PRINT 'This Table is perform read only'
GO
ALTER TABLE [Users].[UserRoles] ENABLE TRIGGER [ReadOnlyRoles]
GO
USE [master]
GO
ALTER DATABASE [SocialDevDB] SET  READ_WRITE 
GO
