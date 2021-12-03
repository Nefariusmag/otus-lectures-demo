USE cube_activity
GO

CREATE USER [bi-reader-user] FOR LOGIN [bi-reader-user]
ALTER ROLE [db_datareader] ADD MEMBER [bi-reader-user]
GO

CREATE TABLE events(
	[id] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[user_name] [nvarchar](70) NULL,
	[type_application] [nvarchar](150) NULL,
	[datetime] [nvarchar](30) NULL,
	[database_name] [nvarchar](15) NULL,
	[query] [nvarchar](max) NULL,
	[duration] [int] NULL,
	[host] [nvarchar](70) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO