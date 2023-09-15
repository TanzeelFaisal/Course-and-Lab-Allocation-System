create database course_database

USE course_database;


CREATE TABLE departments(
dep_name VARCHAR(50) NOT NULL,         
primary key(dep_name)
)

Insert into departments(dep_name)
Values ('Civil Dep')

Insert into departments(dep_name)
Values ('CS Dep')

Insert into departments(dep_name)
Values ('EE Dep')


-- Departments => Civil, CS, EM etc

CREATE TABLE venues (
venue_id VARCHAR(20) NOT NULL,
department VARCHAR(50) NOT NULL,
capacity int
primary key(venue_id)
FOREIGN KEY(department) REFERENCES departments(dep_name)
)

Insert into venues (venue_id,department,capacity)
values ('EM-11','EE Dep',50)

Insert into venues (venue_id,department,capacity)
values ('CS-3','CS Dep',50)

Insert into venues (venue_id,department,capacity)
values ('CE-120','Civil Dep',50)



-- venues => EM-xx for dep EM, CS-xx for dep CS, CE-xx for Civil etc

CREATE TABLE Program (
prog_name VARCHAR(10) NOT NULL,
primary key(prog_name)
)

Insert into Program
values ('BS(CS)')
Insert into Program
values ('BS(EE)')
Insert into Program
values ('BS(DS)')


-- Programs => BS(CS), MS(CS), BS(EE) etc



CREATE TABLE colorCode (
color_CodeID VARCHAR(10) NOT NULL,
batch VARCHAR(50) NOT NULL,
primary key(color_CodeID)
)

Insert into colorCode(color_CodeID,batch)
values ('#FF0000','Batch 2020')

Insert into colorCode(color_CodeID,batch)
values ('#00FF00','Batch 2021')


-- drop table colorCode
-- Color Codes => #FF0000 for Batch 2020 etc

CREATE TABLE courses (
  course_code VARCHAR(10) NOT NULL,
  course_title VARCHAR(100) NOT NULL,
  section VARCHAR(10) NOT NULL,
  teacher_name VARCHAR(100) ,
  offered_for VARCHAR(10) NOT NULL,
  category VARCHAR(50) ,
  start_time TIME,
  end_time TIME,
  room VARCHAR(20),
  color_code VARCHAR(10),
  day1 VARCHAR(10),
  day2 VARCHAR(10),
  CONSTRAINT COMP_NAME PRIMARY KEY (course_code, section),     
  FOREIGN KEY (room) REFERENCES venues(venue_id),
  FOREIGN KEY (offered_for) REFERENCES program(prog_name),
  FOREIGN KEY (color_code) REFERENCES colorCode(color_CodeID)
);





INSERT INTO courses (course_code, course_title, section, teacher_name, offered_for, category, start_time, end_time, room, color_code, day1,day2)
VALUES ('CS1004', 'Object Oriented Programming', 'BCS-2A', 'Dr. Saira Karim (CC)', 'BS(CS)', 'CS (Core)', '09:00:00', '11:00:00', 'EM-11', '#FF0000', 'Monday','Wednesday');

INSERT INTO courses (course_code, course_title, section, teacher_name, offered_for, category, start_time, end_time, room, color_code, day1,day2)
VALUES ('CS1004', 'Object Oriented Programming', 'BCS-2B', 'Dr. Saira Karim', 'BS(CS)', 'CS (Core)', '13:00:00', '15:00:00', 'CS-3', '#00FF00', 'Tuesday','Thursday');


INSERT INTO courses (course_code, course_title, section, teacher_name, offered_for, category, start_time, end_time, room, color_code, day1, day2)
VALUES ('CS1004', 'Object Oriented Programming', 'BCS-2C', 'Ms. Samin Iftikhar', 'BS(CS)', 'CS (Core)', '09:00:00', '11:00:00', 'CE-120', '#FF0000', 'Wednesday','Friday');

INSERT INTO courses (course_code, course_title, section, teacher_name, offered_for, category, start_time, end_time, room, color_code, day1, day2)
VALUES ('CS1004', 'Object Oriented Programming', 'BCS-2D', 'Ms. Samin Iftikhar', 'BS(CS)', 'CS (Core)', '11:00:00', '13:00:00', 'EM-11', '#00FF00', 'Monday', 'Friday');

select * from program
select * from colorCode
select * from venues
select * from departments
select * from courses

-------------------------------

CREATE TABLE course_preference (
  course_code VARCHAR(10) NOT NULL,
  teacher_name VARCHAR(100) NOT NULL,
  CONSTRAINT PK_course_preference PRIMARY KEY (course_code, teacher_name),
  -- FOREIGN KEY (course_code, section) REFERENCES courses(course_code, section)
);

CREATE TABLE time_preference (
  start_time TIME,
  end_time TIME,
  teacher_name VARCHAR(100) NOT NULL,
  CONSTRAINT PK_time_preference PRIMARY KEY (start_time, end_time, teacher_name)
  -- FOREIGN KEY (teacher_name) REFERENCES teachers(teacher_name)
);

INSERT INTO course_preference (course_code, teacher_name) VALUES ('CS2004', 'Dr. Saira Karim') --clashless
INSERT INTO course_preference (course_code, teacher_name) VALUES ('CS1004', 'MS. Samin Iftikhar') --clash
INSERT INTO time_preference (start_time, end_time, teacher_name)
VALUES ('13:00:00', '15:00:00', 'MS. Samin Iftikhar') --clash
INSERT INTO time_preference (start_time, end_time, teacher_name)
VALUES ('13:00:00', '15:00:00', 'Dr Saira Karim') --clashless

--------------------------------

select * from program
select * from colorCode
select * from venues
select * from departments
select * from courses
select * from course_preference
select * from time_preference


---------------------------------

-- Procedure To Check For Course Clashes (Criteria: The Allocated Course Doesn't
-- Fall Within Instructor's Preferred Courses)

CREATE PROCEDURE check_course_clash (@teacher_name INT, @clash BIT OUTPUT)
AS BEGIN
	DECLARE @pref_count INT;
	DECLARE @allocated_count INT;
	-- getting number of preferred courses
	SELECT @pref_count = COUNT(*) FROM course_preference WHERE teacher_name = @teacher_name;

	-- detecting preference clashes
	SELECT @allocated_count = COUNT(*)
	FROM courses c
	LEFT JOIN course_preference p 
	ON c.course_code = p.course_code AND c.teacher_name = p.teacher_name
	WHERE p.course_code IS NULL AND c.teacher_name = @teacher_name

	-- checking if clashes detected
	IF @allocated_count > 0 OR @pref_count = 0
		SET @clash = 1
	ELSE
		SET @clash = 0
END

-- Procedure To Check For Timing Clashes (Criteria: The Allocated Timings Don't
-- Fall Within Instructor's Preferred Timings)

CREATE PROCEDURE check_timing_clash (@teacher_name INT, @start_time TIME, @end_time TIME, @clash BIT OUTPUT)
AS BEGIN
	DECLARE @pref_count INT;
	DECLARE @allocated_count INT;
	
	-- getting number of preferred timings
	SELECT @pref_count = COUNT(*) FROM time_preference WHERE teacher_name = @teacher_name 
		AND start_time <= @start_time AND end_time >= @end_time;

	-- detecting timing clashes
	SELECT @allocated_count = COUNT(*)
	FROM courses c
	LEFT JOIN time_preference p
	ON c.teacher_name = p.teacher_name 
	WHERE p.teacher_name = @teacher_name 
		AND (@start_time BETWEEN p.start_time AND p.end_time OR @end_time BETWEEN p.start_time AND p.end_time);

	-- checking if clashes detected
	IF @allocated_count > 0 OR @pref_count = 0
	BEGIN
		SET @clash = 1;
	END
	ELSE
	BEGIN
		SET @clash = 0;
	END
END

-- Procedure To Check For Venue Clashes (Criteria: Venue Allocated More Than Once On The Same Time Slot)

CREATE PROCEDURE check_venue_clash (@room INT, @start_time TIME, @end_time TIME, @clash BIT OUTPUT, @clash_details VARCHAR(255) OUTPUT)
AS BEGIN
	DECLARE @count INT;
	SELECT @count = COUNT(*)
	FROM courses
	WHERE room = @room
	AND start_time <= @end_time
	AND end_time >= @start_time;

	IF @count > 1
	BEGIN
		SET @clash = 1;
		SET @clash_details = CONCAT('Clash found in venue: ', @room);
	END
	ELSE
	BEGIN
		SET @clash = 0;
		SET @clash_details = 'No clash found';
	END
END

-- Main Procedure To Call That Will Check And Tell If The Timetable Is Clashless Or Not

CREATE PROCEDURE check_clash (@teacher_name INT, @start_time TIME, @end_time TIME, @venue_id INT, 
                              @clash BIT OUTPUT, @clash_details VARCHAR(255) OUTPUT)
AS BEGIN
    DECLARE @course_clash BIT
    DECLARE @timing_clash BIT
    DECLARE @venue_clash BIT
    DECLARE @course_clash_details VARCHAR(255)
    DECLARE @timing_clash_details VARCHAR(255)
    DECLARE @venue_clash_details VARCHAR(255)

    EXEC check_course_clash @teacher_name, @course_clash OUTPUT;

    EXEC check_timing_clash @teacher_name, @start_time, @end_time, @timing_clash OUTPUT;

    EXEC check_venue_clash @venue_id, @start_time, @end_time, @venue_clash OUTPUT, @venue_clash_details OUTPUT;

    -- output clashes
    IF @course_clash = 1 AND @timing_clash = 1 AND @venue_clash = 1
	BEGIN
        SET @clash = 1;
        SET @clash_details = CONCAT('Clash found in course: ', @course_clash_details, ', timing: ', @timing_clash_details, ', and venue: ', @venue_clash_details);
    END
	ELSE IF @course_clash = 1 AND @timing_clash = 1
	BEGIN
        SET @clash = 1;
        SET @clash_details = CONCAT('Clash found in course: ', @course_clash_details, ', and timing: ', @timing_clash_details);
    END
	ELSE IF @course_clash = 1 AND @venue_clash = 1
	BEGIN
        SET @clash = 1;
        SET @clash_details = CONCAT('Clash found in course: ', @course_clash_details, ', and venue: ', @venue_clash_details);
    END
	ELSE IF @timing_clash = 1 AND @venue_clash = 1
	BEGIN
        SET @clash = 1;
        SET @clash_details = CONCAT('Clash found in timing: ', @timing_clash_details, ', and venue: ', @venue_clash_details);
    END
	ELSE IF @course_clash = 1
	BEGIN
        SET @clash = 1;
        SET @clash_details = CONCAT('Clash found in course: ', @course_clash_details);
    END
	ELSE IF @timing_clash = 1 
	BEGIN
        SET @clash = 1;
        SET @clash_details = CONCAT('Clash found in timing: ', @timing_clash_details);
    END
	ELSE
	BEGIN
        SET @clash = 0;
        SET @clash_details = 'No clash found';
    END
END