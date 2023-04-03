USE BUDT703_Project_0501_08

CREATE TABLE [RollCall.Department] (
	dptId CHAR(10) NOT NULL,
	dptName VARCHAR(20),
	CONSTRAINT pk_Department_dptId PRIMARY KEY (dptId)
)

CREATE TABLE [RollCall.Student] (
	stuId CHAR(10) NOT NULL,
	stuFirstName VARCHAR(20),
	stuLastName VARCHAR(20),
	stuEmail VARCHAR(20),
	stuUsername VARCHAR(20),
	dptId CHAR(10),
	CONSTRAINT pk_Student_stuId PRIMARY KEY (stuId),
	CONSTRAINT fk_Student_dptId FOREIGN KEY (dptId)
		REFERENCES [RollCall.Department] (dptId)
		ON DELETE CASCADE ON UPDATE CASCADE
)

CREATE TABLE [RollCall.Course] (
	corId CHAR(10) NOT NULL,
	corName VARCHAR(70),
	corStrength INTEGER,
	CONSTRAINT pk_Course_corId PRIMARY KEY(corId)
)

CREATE TABLE [RollCall.Faculty] (
	facId CHAR(10) NOT NULL,
	facFirstName VARCHAR(30),
	facLastName VARCHAR(30),
	facEmail VARCHAR(30),
	CONSTRAINT pk_Faculty_facId PRIMARY KEY(facId)
)

CREATE TABLE [RollCall.Work] (
	dptId CHAR (10) NOT NULL,
	facId CHAR (10) NOT NULL,
	CONSTRAINT pk_Work_dptId_facId PRIMARY KEY (dptId, facId),
	CONSTRAINT fk_Work_dptId FOREIGN KEY (dptId)
		REFERENCES [RollCall.Department] (dptId)
		ON DELETE NO ACTION ON UPDATE CASCADE,
	CONSTRAINT fk_Work_facId FOREIGN KEY (facId)
		REFERENCES [RollCall.Faculty] (facId)
		ON DELETE NO ACTION ON UPDATE CASCADE
)
GO

CREATE TABLE [RollCall.Teach] (
	facId CHAR(10) NOT NULL,
	corId CHAR(10) NOT NULL,
	CONSTRAINT pk_Teach_facId_corId PRIMARY KEY (facId, corId),
	CONSTRAINT fk_Teach_facId FOREIGN KEY (facId)
		REFERENCES [RollCall.Faculty] (facId)
		ON DELETE NO ACTION ON UPDATE CASCADE,
	CONSTRAINT fk_Teach_corId FOREIGN KEY (corId)
		REFERENCES [RollCall.Course] (corId)
		ON DELETE NO ACTION ON UPDATE CASCADE
)

CREATE TABLE [RollCall.Attendance] (
	stuId CHAR(10) NOT NULL,
	corId CHAR(10) NOT NULL,
	atdstatus VARCHAR(20),
	atddate DATE, 
	CONSTRAINT pk_Attendance_stuId_corId PRIMARY KEY (stuId, corId),
	CONSTRAINT fk_Attendance_stuId FOREIGN KEY (stuId)
		REFERENCES [RollCall.Student] (stuId)
		ON DELETE NO ACTION ON UPDATE CASCADE,
	CONSTRAINT fk_Attendance_corId FOREIGN KEY (corId)
		REFERENCES [RollCall.Course] (corId)
		ON DELETE NO ACTION ON UPDATE CASCADE
)

CREATE TABLE [RollCall.Review] (
	stuId CHAR (10) NOT NULL,
	corId CHAR (10) NOT NULL,
	facId CHAR (10) NOT NULL,
	rating INT,
	CONSTRAINT pk_Review_stuId_corId PRIMARY KEY (stuId, corId),
	CONSTRAINT fk_Review_stuId FOREIGN KEY (stuId)
		REFERENCES [RollCall.Student] (stuId)
		ON DELETE NO ACTION ON UPDATE CASCADE,
	CONSTRAINT fk_Review_corId FOREIGN KEY (corId)
		REFERENCES [RollCall.Course] (corId)
		ON DELETE NO ACTION ON UPDATE CASCADE,
	CONSTRAINT fk_Review_facId FOREIGN KEY (facId)
		REFERENCES [RollCall.Faculty] (facId)
		ON DELETE NO ACTION ON UPDATE CASCADE
)

