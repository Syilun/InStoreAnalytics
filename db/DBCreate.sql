
USE [ShopAnalytics]
GO
/****** Object:  Table [dbo].[CustomerInfor]    Script Date: 05/02/2018 17:21:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CustomerInfor](
	[FaceID] [varchar](50) NOT NULL,
	[Name] [varchar](50) NULL,
	[IsVip] [bit] NULL,
	[IsCelebrity] [bit] NULL,
	[Currency] [int] NULL,
	[RecentPurchased] [varchar](50) NULL,
	[Recommand] [varchar](50) NULL,
 CONSTRAINT [PK_CustomerInfor] PRIMARY KEY CLUSTERED 
(
	[FaceID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[VisitRecord]    Script Date: 05/02/2018 17:21:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[VisitRecord](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[FaceID] [varchar](50) NULL,
	[Emotion] [int] NULL,
	[Age] [int] NULL,
	[Gender] [int] NULL,
	[BeautyScore] [int] NULL,
	[EnterTime] [datetime] NULL,
	[LeaveTime] [datetime] NULL,
	[PicId] [varchar](50) NULL,
	[Spent] [float] NULL,
 CONSTRAINT [PK_VisitRecord] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO


CREATE TABLE [dbo].[ProductInfor](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](200) NULL,
	[Price] [float] NULL,
	[Location] [varchar](50) NULL,
	[Notes] [varchar](200) NULL,
	[Pic] [varchar](50) NULL,
 CONSTRAINT [PK_ProductInfor] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

/****** Object:  StoredProcedure [dbo].[GenearateMockData]    Script Date: 05/02/2018 17:21:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GenearateMockData]
	-- Add the parameters for the stored procedure here
	@UntilCurrentTime tinyint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	-- Clear Old data
	Delete from VisitRecord
	
	declare @timeIndex int, @originVol varchar(500),@pos int,  @ix  int , @sizebyhour int,@innerIndex int, @random int, @temp int, @faceid int, @age int,@currentfaceid  int
	declare @emotion int, @duration int, @gender int, @spend float
	declare @entertime datetime
	DECLARE @currentDay datetime
	set @originVol = '30,40,80,90,70,50,30,40,70,90,120,100,80,'
	
	
	declare @dayindex int
	SET @dayindex = 30
	set @faceid = 0
	WHILE @dayindex >= 0
		BEGIN
			
			set @timeIndex = 9
			set @pos =0 
			set @sizebyhour=0
			
	
			set @currentDay = DATEADD(day,-@dayindex, CAST( CAST ( GETDATE() AS DATE) AS DATETIME))
			while @timeIndex <= 21
			begin
				set @ix = charindex(',',@originVol,@pos)
				print substring(@originVol, @pos, @ix - @pos)
				set @sizebyhour = CAST(substring(@originVol, @pos, @ix - @pos) AS INT)
				set @innerIndex = 0
				SET @pos = @ix+1
				set @random = @sizebyhour + floor(rand()*20)
				
				while @innerIndex <  @random
					begin
						-- Ramdon choose emotion, during,gender
						--1) Time: 30,40,80,90,70,50,30,40,70,90,120,100,80
						--2) 1MIN 25%, 5MIN 30%, 15 25%, MORE 20%
						--3) 7:3 Female/Male
						--4) 45%, 30%
						--5) Age, 0 - 70

						SET @temp = floor(rand()*100)
						SELECT @duration =
							(CASE WHEN  @temp >= 0  and @temp< 25 THEN 0 WHEN  @temp >= 25 and @temp< 55 THEN 4 WHEN  @temp >= 55 and @temp< 80 THEN 14 ELSE 20 END)
						SET @temp = floor(rand()*100)
						--0: angry, 1:frown, 2:happy, 3:nature
						SELECT @emotion =
							(CASE WHEN  @temp >= 0  and @temp< 70 THEN 2 
							WHEN  @temp >= 70 and @temp< 85 THEN 3 
							WHEN  @temp >= 85 and @temp< 90 THEN  0
							ELSE 1 END)
						SET @temp = floor(rand()*100)
						SELECT @gender =
							(CASE WHEN  @temp >= 0  and @temp< 70 THEN 1 ELSE 0 END)
						
						SET @temp = floor(rand()*100)
						SELECT @spend =
							(CASE WHEN  @temp >= 60  THEN @temp ELSE 0 END)
							
						SET @temp = floor(rand()*100)
						if @faceid > 10 and @temp > 80
							begin 
								set @currentfaceid  = floor(rand()*@faceid)
							end
						else
							begin
								set @currentfaceid  = @faceid
								set @faceid =@faceid +1
							end	
						SET @temp = floor(rand()*6)
						IF @temp < 3 -- take 1/2 chance
							BEGIN
								set @age = floor(rand()*20)+20 --20 yeas to  40 years
							END
						ELSE IF @TEMP <5
							BEGIN
								set @age = floor(rand()* 20)  -- 10 to 20 and 40 to 50
								if @age >= 10
									BEGIN
										SET @age = @age + 30
									END
								ELSE
									BEGIN
										SET @age = @age + 10
									END
							END
						ELSE
							BEGIN
								set @age = floor(rand()* 30)  -- 0 to 10 and 50 to 70
								if @age >= 10
									BEGIN
										SET @age = @age + 40
									END
							END
						set @entertime  = @currentDay+  (CAST(@timeIndex AS VARCHAR(2)) + ':'+ CAST(FLOOR(RAND()*30) AS VARCHAR(2)) +':00')	
						INSERT INTO VisitRecord (FaceID,Emotion,Age,Gender,EnterTime,LeaveTime,Spent)
						VALUES (@currentfaceid,@emotion,@age,@gender, @entertime, @entertime+ ('00:'+CAST(@duration AS  VARCHAR(2))+':00'),@spend)
						
						SET @innerIndex  =@innerIndex +1
					END
			set @timeIndex = @timeIndex +1
		END
			set @dayindex =@dayindex -1
		END
		
	
END
GO

CREATE PROCEDURE GenerateMockProductionInfor
AS
BEGIN
	delete from ProductInfor;
	INSERT INTO dbo.ProductInfor(Name,Price,Location,Notes,Pic) VALUES('A Brief History of Time',15.75,'Stephen Hawking','A landmark volume in science writing by one of the great minds of our time','535-059')
	INSERT INTO dbo.ProductInfor(Name,Price,Location,Notes,Pic) VALUES('A Heartbreaking Work of Staggering Genius',18.99,'Dave Eggers','A book that redefines both family and narrative for the twenty-first century','535-061')
	INSERT INTO dbo.ProductInfor(Name,Price,Location,Notes,Pic) VALUES('A Long Way Gone: Memoirs of a Boy Soldier',17.5,'Ishmael Beah','This is how wars are fought now: by children, hopped-up on drugs and wielding AK-47s','535-066')
	INSERT INTO dbo.ProductInfor(Name,Price,Location,Notes,Pic) VALUES('The Bad Beginning: Or, Orphans!',16,'Lemony Snicket','Are you made fainthearted by death? Does fire unnerve you? ','535-013')
	INSERT INTO dbo.ProductInfor(Name,Price,Location,Notes,Pic) VALUES('Selected Stories',15,'Stephen Hawking','Spanning almost thirty years and settings that range from big cities to small towns.','535-019')
	
	INSERT INTO dbo.ProductInfor(Name,Price,Location,Notes,Pic) VALUES('Are You There God? Its Me, Margaret',4.99,'Judy Blume','A twelve-year-old talks to God about her ardent desire to be grown up','535-029')
	INSERT INTO dbo.ProductInfor(Name,Price,Location,Notes,Pic) VALUES('Beloved',4.16,'Toni Morrison','Nominated as one of America’s best-loved novels by PBS’s The Great American Read','535-032')
	INSERT INTO dbo.ProductInfor(Name,Price,Location,Notes,Pic) VALUES('Cutting for Stone',19,'Abraham Verghese','Cutting for Stone is an unforgettable story of love and betrayal','535-045')
	INSERT INTO dbo.ProductInfor(Name,Price,Location,Notes,Pic) VALUES('Charlie and the Chocolate Factory',13,'Roald Dahl','This special edition of Charlie and the Chocolate Factory is perfect for longtime Roald Dahl fan','535-053')
	INSERT INTO dbo.ProductInfor(Name,Price,Location,Notes,Pic) VALUES('The Autobiography of Malcolm X: As Told to Alex Haley',12,'Malcolm X','ONE OF TIME’S TEN MOST IMPORTANT NONFICTION BOOKS OF THE TWENTIETH CENTURY"','535-017')
END
GO

