create database SE_TEAM2_db

use SE_TEAM2_db

create table sections(
section_id varchar(20) NOT NULL,
primary key (section_id)
);

create table course_timeslot(
courseTimeslot_id int NOT NULL,
courseTiming varchar(30) NOT NULL unique,
primary key (courseTimeslot_id)
);

create table lab_timeslot(
labTimeslot_id int NOT NULL,
labTiming varchar(30) NOT NULL unique,
primary key (labTimeslot_id)
);

CREATE TABLE courseList(
 Course_id varchar(20) PRIMARY KEY,
 Course_name varchar(50) NOT NULL unique	
);

CREATE TABLE labList(
Lab_id varchar(20) PRIMARY KEY,
Lab_name varchar(50) NOT NULL unique
);

CREATE TABLE COURSE_INST_PREFERENCES(
 Instructor_id int PRIMARY KEY,
 Instructor_name varchar(40),
 pref_course_id_1 varchar(20) FOREIGN KEY REFERENCES courseList(Course_id),
 pref_course_id_2 varchar(20) FOREIGN KEY REFERENCES courseList(Course_id),
 pref_timeslotID_1 int FOREIGN KEY REFERENCES course_timeslot(courseTimeslot_id),
 pref_timeslotID_2 int FOREIGN KEY REFERENCES course_timeslot(courseTimeslot_id)
);

CREATE TABLE LAB_INST_PREFERENCE(
Instructor_id int PRIMARY KEY,
Instructor_name varchar(30),
gpa decimal(3,2),
uni_name char(50),
experience char(100),
pref_lab_id_1 varchar(20) FOREIGN KEY REFERENCES labList(Lab_id),
pref_lab_id_2 varchar(20) FOREIGN KEY REFERENCES labList(Lab_id),
non_pref_timeslotID_1 int FOREIGN KEY REFERENCES lab_timeslot(labTimeslot_id),
non_pref_timeslotID_2 int FOREIGN KEY REFERENCES lab_timeslot(labTimeslot_id),
lab_id_1_grade char(1),
lab_id_2_grade char(1)
);


drop table course_section_timing
drop table labs_section_timing

create table course_section_timing(
course_id varchar(20) NOT NULL,
course_name varchar(50) NOT NULL,
course_section varchar(20),
course_timing varchar(30),
course_venue varchar(20)
 CONSTRAINT FK_CourseList FOREIGN KEY (course_id) REFERENCES courseList(Course_id),
 CONSTRAINT COMP_NAME PRIMARY KEY (course_id,course_section),
 CONSTRAINT FK_SECTIONS FOREIGN KEY (course_section) REFERENCES sections(section_id),
 CONSTRAINT FK_TIMESLOT FOREIGN KEY (course_timing) REFERENCES  course_timeslot(courseTiming),
 CONSTRAINT FK_VENUE FOREIGN KEY (course_venue) REFERENCES venues(venue_id)
);

create table labs_section_timing(
lab_id varchar(20) NOT NULL,
lab_name varchar(50) NOT NULL,
lab_section varchar(20),
lab_timing varchar(30),
lab_venue varchar(20)
CONSTRAINT FK_LabList FOREIGN KEY (lab_id) REFERENCES labList(Lab_id),
CONSTRAINT COMP_LABS PRIMARY KEY (lab_id,lab_section),
CONSTRAINT FK_SECTIONS_LABS FOREIGN KEY (lab_section) REFERENCES sections(section_id),
CONSTRAINT FK_TIMESLOT_LABS FOREIGN KEY (lab_timing) REFERENCES lab_timeslot(labTiming),
CONSTRAINT FK_VENUEL FOREIGN KEY (lab_venue) REFERENCES venues(venue_id)
);

CREATE TABLE Course_Allocation( 
	CourseID varchar(20),
	CourseName varchar(50),
	Section varchar(20),
	InstructorID int,
	CONSTRAINT FK_COURSE_INSTRUCTOR FOREIGN KEY (InstructorID) REFERENCES COURSE_INST_PREFERENCES(Instructor_id),
	CONSTRAINT FK_CourseListAlloc FOREIGN KEY (CourseID) REFERENCES courseList(Course_id),
	CONSTRAINT FK_SECTIONSAlloc FOREIGN KEY (Section) REFERENCES sections(section_id),
	CONSTRAINT COMP_KEY_COURSEALLOC PRIMARY KEY (CourseID,Section)
);

CREATE TABLE Lab_Allocation( 
	LabID varchar(20),
	LabName varchar(50),
	Section varchar(20),
	InstructorID int,
	CONSTRAINT FK_LAB_INSTRUCTOR FOREIGN KEY (InstructorID) REFERENCES LAB_INST_PREFERENCE(Instructor_id),
	CONSTRAINT FK_LabListAlloc FOREIGN KEY (LabID) REFERENCES labList(Lab_id),
	CONSTRAINT FK_LABSECTIONSAlloc FOREIGN KEY (Section) REFERENCES sections(section_id),
	CONSTRAINT COMP_KEY_LABALLOC PRIMARY KEY (LabID,Section)
);


CREATE TABLE venues (
venue_id VARCHAR(20) NOT NULL,
department VARCHAR(50) NOT NULL,
capacity int,
primary key(venue_id)
)

create table timetable(
timetable_ver varchar(50) NOT NULL,
coursetimetable_slots varchar(30),
labtimetable_slots varchar(30),
timetable_venues varchar(20) NOT NULL,
CONSTRAINT FK_COURSETIMESLOT_TT FOREIGN KEY (coursetimetable_slots) REFERENCES course_timeslot(courseTiming),
CONSTRAINT FK_LABTIMESLOT_TT FOREIGN KEY (labtimetable_slots) REFERENCES lab_timeslot(labTiming),
CONSTRAINT FK_venues_TT FOREIGN KEY (timetable_venues) REFERENCES venues(venue_id) 
)

Insert into sections(section_id)
values('6A')

Insert into sections(section_id)
values('6B')

Insert into sections(section_id)
values('6C')

Insert into course_timeslot(courseTimeslot_id,courseTiming)
values(1,'08:30-10:00')

Insert into course_timeslot(courseTimeslot_id,courseTiming)
values(2,'10:00-11:30')

Insert into course_timeslot(courseTimeslot_id,courseTiming)
values(3,'11:30-01:00')


Insert into courseList(Course_id,Course_name)
values('CS1003', 'Programming Fundamentals')

Insert into courseList(Course_id,Course_name)
values('CS2003', 'Object Oriented Programming')

Insert into courseList(Course_id,Course_name)
values('CS3003', 'Data Structures')


Insert into course_section_timing(course_id,course_name,course_section,course_timing, course_venue)
values('CS1003','Programming Fundamentals','6A','08:30-10:00', 'CS-3')

Insert into course_section_timing(course_id,course_name,course_section,course_timing, course_venue)
values('CS1003','Programming Fundamentals','6B','08:30-10:00', 'EM-11')

Insert into course_section_timing(course_id,course_name,course_section,course_timing, course_venue)
values('CS1003','Programming Fundamentals','6C','11:30-01:00', 'CS-3')

Insert into labs_section_timing(lab_id,lab_name,lab_section,lab_timing, lab_venue)
values('CS1003','Programming Fundamentals','6C','11:30-01:00', 'Lab-3')

Insert into COURSE_INST_PREFERENCES(Instructor_id,Instructor_name,pref_course_id_1,pref_course_id_2,pref_timeslotID_1,pref_timeslotID_2)
values(1,'Ishaq Raza','CS1003','CS2003',1,2)

Insert into Course_Allocation(CourseID,CourseName,InstructorID,Section)
values('CS1003','Programming Fundamentals',1,'6B')



Insert into venues (venue_id,department,capacity)
values ('EM-11','EE Dep',50)

Insert into venues (venue_id,department,capacity)
values ('CS-3','CS Dep',50)

Insert into venues (venue_id,department,capacity)
values ('Lab-2','CS Dep',50)

Insert into timetable(timetable_ver,timetable_venues,coursetimetable_slots)
values('FAST School of Computing version_1.0','CS-3','08:30-10:00')


Insert into timetable(timetable_ver,timetable_venues,coursetimetable_slots)
values('FAST School of Computing version_1.0','CS-3','11:30-01:00')


select * from COURSE_INST_PREFERENCES
select * from LAB_INST_PREFERENCE
select * from sections
select * from courseList
select * from labList
select * from course_section_timing
select * from labs_section_timing
select * from Course_Allocation
select * from venues
select * from course_timeslot
select * from timetable

-----------------------------------------------------------------


-- Procedure To Check For Course Clashes (Criteria: The Allocated Course Doesn't
-- Fall Within Instructor's Preferred Courses)

CREATE PROCEDURE check_course_clash (@instructor_id INT, @course_id VARCHAR(10), @clash BIT OUTPUT)
AS BEGIN
	DECLARE @pref_found_count INT;
	SET @clash = 0

	-- getting number of preferred courses that match the given course_id
	SELECT @pref_found_count = COUNT(*) 
	FROM (
		SELECT pref_course_id_1 AS pref_course_id FROM COURSE_INST_PREFERENCES WHERE instructor_id = @instructor_id
		UNION
		SELECT pref_course_id_2 AS pref_course_id FROM COURSE_INST_PREFERENCES WHERE instructor_id = @instructor_id
		UNION
		SELECT pref_lab_id_1 AS pref_course_id FROM LAB_INST_PREFERENCE WHERE instructor_id = @instructor_id
		UNION
		SELECT pref_lab_id_2 AS pref_course_id FROM LAB_INST_PREFERENCE WHERE instructor_id = @instructor_id
	) AS pref_course_id
	WHERE pref_course_id = @course_id;

	-- checking if clashes detected
	IF @pref_found_count = 0
	BEGIN
		SET @clash = 1
	END
END

DECLARE @my_output_param BIT
EXEC check_course_clash @instructor_id = 1, @course_id = CS3003, @clash = @my_output_param OUTPUT
SELECT @my_output_param

-- Procedure To Check For Timing Clashes (Criteria: The Allocated Timings Don't
-- Fall Within Instructor's Preferred Timings)

CREATE PROCEDURE check_timing_clash (@instructor_id INT, @time_slot VARCHAR(20), @clash BIT OUTPUT)
AS BEGIN

	DECLARE @pref_found_count INT
	DECLARE @non_pref_found_count INT
	DECLARE @time_slot_id INT

	SELECT @time_slot_id = courseTimeslot_id
	FROM course_timeslot
	WHERE courseTiming = @time_slot

	SET @pref_found_count = 0
	SET @non_pref_found_count = 0
	SET @clash = 0
	-- getting number of preferred courses that match the given course_id
	SELECT @pref_found_count = COUNT(*) 
	FROM COURSE_INST_PREFERENCES
	WHERE instructor_id = @instructor_id AND (pref_timeslotID_1 = @time_slot_id OR pref_timeslotID_2 = @time_slot_id)

	-- checking if clashes detected
	IF @pref_found_count = 0
	BEGIN
		SET @clash = 1
	END

	SELECT @non_pref_found_count = COUNT(*)
	FROM LAB_INST_PREFERENCE
	WHERE instructor_id = @instructor_id AND (non_pref_timeslotID_1 = @time_slot_id OR non_pref_timeslotID_2 = @time_slot_id)

	IF @non_pref_found_count > 0
	BEGIN
		SET @clash = 1
	END
END

DECLARE @my_output_param BIT
EXEC check_timing_clash @instructor_id = 1, @time_slot_id = 1, @clash = @my_output_param OUTPUT
SELECT @my_output_param

-- Procedure To Check For Venue Clashes (Criteria: Venue Allocated More Than Once On The Same Time Slot)

alter PROCEDURE check_venue_clash (@venue_id VARCHAR(20), @time_slot VARCHAR(20), @clash BIT OUTPUT)
AS BEGIN

	DECLARE @found_count INT;
	SET @clash = 0

	-- getting number of preferred courses that match the given course_id
	SELECT @found_count = COUNT(*) 
	FROM (
		SELECT course_timing AS timing FROM course_section_timing WHERE course_venue = @venue_id
		UNION
		SELECT course_timing AS timing FROM course_section_timing WHERE course_venue = @venue_id
		UNION
		SELECT lab_timing AS timing FROM labs_section_timing WHERE lab_venue = @venue_id
		UNION
		SELECT lab_timing AS timing FROM labs_section_timing WHERE lab_venue = @venue_id
	) AS timing
	WHERE timing = @time_slot

	-- checking if clashes detected
	IF @found_count > 0
	BEGIN
		SET @clash = 1
	END
END

select * from course_section_timing

DECLARE @my_output_param BIT
EXEC check_venue_clash @venue_id = 'CS-3', @time_slot = '08:30-10:00', @clash = @my_output_param OUTPUT
SELECT @my_output_param

-- Main Procedure To Call That Will Check And Tell If The Timetable Is Clashless Or Not

CREATE PROCEDURE check_clash (@instructor_id INT, @course_id varchar(20), @time_slot VARCHAR(20), @venue_id VARCHAR(20), 
                              @course_clash_output BIT OUTPUT, @timing_clash_output BIT OUTPUT, @venue_clash_output BIT OUTPUT)
AS BEGIN
    DECLARE @course_clash BIT
    DECLARE @timing_clash BIT
    DECLARE @venue_clash BIT
    --DECLARE @course_clash_output BIT
    --DECLARE @timing_clash_output BIT
    --DECLARE @venue_clash_output BIT

    EXEC check_course_clash @instructor_id, @course_id, @course_clash_output OUTPUT
    EXEC check_timing_clash @instructor_id, @time_slot, @timing_clash_output OUTPUT
    EXEC check_venue_clash @venue_id, @time_slot, @venue_clash_output OUTPUT
END

DECLARE @my_output_param1 BIT, @my_output_param2 BIT, @my_output_param3 BIT
EXEC check_clash @instructor_id= 1, @course_id = 'CS2003', @time_slot = '10:00-11:30', @venue_id = 'CS-3', 
	@course_clash_output = @my_output_param1 OUTPUT, @timing_clash_output = @my_output_param2 OUTPUT, @venue_clash_output = @my_output_param3 OUTPUT
SELECT @my_output_param1, @my_output_param2, @my_output_param3