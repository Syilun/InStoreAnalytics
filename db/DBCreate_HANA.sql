SET SCHEMA  SHOPDB;

create column table "CustomerInfor"( "FaceID" VARCHAR (50) null,
	 "Name" VARCHAR (50) null,
	 "IsVip" TINYINT null,
	 "IsCelebrity" TINYINT null,
	 "Currency" INTEGER null,
	 "RecentPurchased" VARCHAR(50) null,
	"Recommand" VARCHAR(50) null)
;	 
	 
CREATE COLUMN TABLE "VisitRecord" ("ID" INTEGER not null primary key generated by default as IDENTITY,
	 "FaceID" VARCHAR (50) NULL ,
	 "Emotion" INTEGER  NULL ,
	 "Age" INTEGER  NULL,
	 "Gender" INTEGER  NULL,
	 "BeautyScore" INTEGER  NULL,
	 "EnterTime" LONGDATE CS_LONGDATE,
	 "LeaveTime" LONGDATE CS_LONGDATE,
	 "PicId" VARCHAR (500) null,
	 "Spent" float NULL) ;

CREATE COLUMN TABLE "ProductInfor" ("ID" INTEGER not null primary key generated by default as IDENTITY,
	 "Name" VARCHAR (100)  NULL ,
	 "Price" float  NULL ,
	 "Location" VARCHAR (50)  NULL,
	 "Notes" VARCHAR (500)  NULL,
	 "Pic" VARCHAR (100)   NULL) ;

 
CREATE PROCEDURE "GENEARATEMOCKDATA" (IN UntilCurrentTime tinyint) 
AS
	timeIndex int; 
	originVol varchar(500);
	pos int; 
	ix  int ; 
	sizebyhour int;
	innerIndex int; 
	random int; 
	temp int; 
	faceid int; 
	age int;
	emotion int; 
	duration int; 
	gender int;
	entertime timestamp;
	leavetime timestamp;
	currentDay timestamp;
	dayindex int;
	currentfaceid  int;
	spend int;
	
BEGIN	
	--Clear old record
	Delete from "VisitRecord";
	
	originVol := '30,40,80,90,70,50,30,40,70,90,120,100,80,';
	dayindex := 14;
	
	
	WHILE dayindex >= 0 do
		timeIndex := 9;
		pos :=1;
		sizebyhour :=0;
		faceid := 0;
		
		currentDay := ADD_DAYS(CAST(CAST(NOW() AS date) AS timestamp),-:dayindex);
		WHILE :timeIndex <= 21 DO 
			ix := LOCATE(:originVol,',',:pos);
			sizebyhour := CAST(substring(:originVol,:pos,:ix - :pos) AS integer);
			innerIndex := 0;
			pos := :ix + 1;
			random := :sizebyhour + floor(RAND() * 20);
			WHILE :innerIndex < :random DO 
				temp := floor(RAND() * 100);
				duration :=
					 (CASE WHEN :temp >= 0 
					AND :temp < 25 
					THEN 0 WHEN :temp >= 25 
					AND :temp < 55 
					THEN 4 WHEN :temp >= 55 
					AND :temp < 80 
					THEN 14 
					ELSE 20 
					END);
				
				temp := floor(RAND() * 100);
				
				emotion :=
					 (CASE WHEN :temp >= 0 
					AND :temp < 70 
					THEN 2 WHEN :temp >= 70 
					AND :temp < 80 
					THEN 3 WHEN :temp >= 80 
					AND :temp < 87 
					THEN 0
					ELSE 1 
					END);
				
				temp := floor(RAND() * 100);
				
				gender :=
					 (CASE WHEN :temp >= 0 
					AND :temp < 70 
					THEN 0 
					ELSE 1 
					END);
					
					
				temp := floor(rand()*100);
				spend := (CASE WHEN  :temp >= 60  THEN :temp ELSE 0 END);
							
				temp := floor(rand()*100);
				if :faceid > 10 and :temp > 80 then
					currentfaceid  := floor(rand()*:faceid);
				else
					currentfaceid  := :faceid;
					faceid := :faceid +1;
				end if;
				
				temp := floor(RAND() * 6);
				
				IF :temp < 3 THEN 
					age := floor(RAND() * 20) + 20;
					--20 yeas to  40 years
				ELSE 
					IF :TEMP < 5 THEN
						age := floor(RAND() * 20);
						-- 10 to 20 and 40 to 50
						IF :age >= 10 THEN
							age := :age + 30;
						ELSE 
							age := :age + 10;
						END IF;
					ELSE 
						age := floor(RAND() * 30);
						-- 0 to 10 and 50 to 70
						IF :age >= 10 THEN 
							age := :age + 40;
						END IF;
					END IF;
					
				END IF;
				-- take 1/2 chance
				entertime :=  ADD_SECONDS(:currentDay,:timeIndex *60*60+ FLOOR(RAND()*30)*60);
				leavetime :=  ADD_SECONDS(:entertime,:duration *60);
				INSERT INTO "VisitRecord" ("FaceID","Emotion","Age","Gender","EnterTime","LeaveTime","Spent") 
				VALUES (:currentfaceid, :emotion,:age, :gender,:entertime,:leavetime,:spend);
				faceid := :faceid + 1;
				innerIndex := :innerIndex + 1;
			END WHILE;
			timeIndex := :timeIndex + 1;
		END WHILE;
		dayindex := :dayindex - 1;
	END WHILE;
END;
	
-- =============================================
CREATE PROCEDURE "GENERATEMOCKPRODUCTIONINFOR" 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	delete from "ProductInfor";
	INSERT INTO "ProductInfor"("Name","Price","Location","Notes","Pic") VALUES('A Brief History of Time',15.75,'Stephen Hawking','A landmark volume in science writing by one of the great minds of our time','535-059');
	INSERT INTO "ProductInfor"("Name","Price","Location","Notes","Pic") VALUES('A Heartbreaking Work of Staggering Genius',18.99,'Dave Eggers','A book that redefines both family and narrative for the twenty-first century','535-061');
	INSERT INTO "ProductInfor"("Name","Price","Location","Notes","Pic") VALUES('A Long Way Gone: Memoirs of a Boy Soldier',17.5,'Ishmael Beah','This is how wars are fought now: by children, hopped-up on drugs and wielding AK-47s','535-066');
	INSERT INTO "ProductInfor"("Name","Price","Location","Notes","Pic") VALUES('The Bad Beginning: Or, Orphans!',16,'Lemony Snicket','Are you made fainthearted by death? Does fire unnerve you? ','535-013');
	INSERT INTO "ProductInfor"("Name","Price","Location","Notes","Pic") VALUES('Selected Stories',15,'Stephen Hawking','Spanning almost thirty years and settings that range from big cities to small towns.','535-019');
	
	INSERT INTO "ProductInfor"("Name","Price","Location","Notes","Pic") VALUES('Are You There God? Its Me, Margaret',4.99,'Judy Blume','A twelve-year-old talks to God about her ardent desire to be grown up','535-029');
	INSERT INTO "ProductInfor"("Name","Price","Location","Notes","Pic") VALUES('Beloved',4.16,'Toni Morrison','Nominated as one of America’s best-loved novels by PBS’s The Great American Read','535-032');
	INSERT INTO "ProductInfor"("Name","Price","Location","Notes","Pic") VALUES('Cutting for Stone',19,'Abraham Verghese','Cutting for Stone is an unforgettable story of love and betrayal','535-045');
	INSERT INTO "ProductInfor"("Name","Price","Location","Notes","Pic") VALUES('Charlie and the Chocolate Factory',13,'Roald Dahl','This special edition of Charlie and the Chocolate Factory is perfect for longtime Roald Dahl fan','535-053');
	INSERT INTO "ProductInfor"("Name","Price","Location","Notes","Pic") VALUES('The Autobiography of Malcolm X: As Told to Alex Haley',12,'Malcolm X','ONE OF TIME’S TEN MOST IMPORTANT NONFICTION BOOKS OF THE TWENTIETH CENTURY"','535-017');
END;



	
