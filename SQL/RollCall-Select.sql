USE BUDT703_Project_0501_08


--•	1. To find the bottom ten students who have least regularly attended the courses.

SELECT TOP(10) ac.[Student Name], ac.stuId, ac.attendanceCount
FROM (SELECT s.stuId, 
		CONCAT(s.stuFirstName,' ',s.stuLastName) AS 'Student Name', 
		COUNT(a.atdstatus) AS attendanceCount
	  FROM [RollCall.Student] s, [RollCall.Attendance] a
	  WHERE a.stuId = s.stuId AND a.atdstatus = 'Present'
	  GROUP BY s.stuId, s.stuFirstName, s.stuLastName) ac
ORDER BY attendanceCount


--•	2. To find the list of students present for the courses for the first day of the class.

SELECT s.* 
FROM [RollCall.Student] s 
WHERE s.stuId IN (
	SELECT a.stuId 
	FROM [RollCall.Attendance] a, (
		SELECT MIN(a.atddate) AS firstDay
		FROM [RollCall.Attendance] a) fd
	WHERE a.atddate = fd.firstDay
)


--•	3. To find the average rating given by all students for each faculty.

SELECT r.facId, f.facFirstName, f.facLastName, AVG(r.rating) AS 'Average Rating'
FROM [RollCall.Review] r, [RollCall.Faculty] f
WHERE r.facId = f.facId
GROUP BY r.facId, f.facFirstName, f.facLastName, r.rating
ORDER BY r.facId ASC


--•	4. To find the department having the highest positive feedback given from their students.

SELECT d.dptId, d.dptName, AVG(r.rating) as 'Average Rating' 
FROM [RollCall.Department] d, [RollCall.Review] r, [RollCall.Student] s
WHERE s.dptId = d.dptId AND r.stuId = s.stuId
GROUP BY d.dptId, d.dptName
ORDER BY 'Average Rating' DESC

