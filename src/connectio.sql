-- Hidden Courses with Student Enrollments and Instructor Details
SELECT
	c.id AS 'Course ID',
	(
	SELECT
		COUNT(ra.userid)
	FROM
		mdl_role_assignments AS ra
	JOIN mdl_context AS ctx ON
		ra.contextid = ctx.id
	WHERE
		ra.roleid = 5
		AND ctx.instanceid = c.id) AS Students,
	(
	SELECT
		COUNT(ra.userid)
	FROM
		mdl_role_assignments AS ra
	JOIN mdl_context AS ctx ON
		ra.contextid = ctx.id
	WHERE
		ra.roleid = 3
		AND ctx.instanceid = c.id) AS Instructors,
	(
	SELECT
		DISTINCT u.email
	FROM
		mdl_role_assignments AS ra
	JOIN mdl_user AS u ON
		ra.userid = u.id
	JOIN mdl_context AS ctx ON
		ctx.id = ra.contextid
	WHERE
		ra.roleid = 3
		AND ctx.instanceid = c.id
		AND ctx.contextlevel = 50
	LIMIT 1) AS 'Instructor Email',
	FROM_UNIXTIME(c.startdate) AS 'Start Date',
	now() AS 'Report Timestamp'
FROM
	mdl_course AS c
WHERE
	c.visible = 0
	AND (
	SELECT
		COUNT(ra.userid)
	FROM
		mdl_role_assignments AS ra
	JOIN mdl_context AS ctx ON
		ra.contextid = ctx.id
	WHERE
		ra.roleid = 5
		AND ctx.instanceid = c.id) > 0
ORDER BY
	StartDate,
	'Instructor Email',
	Course_ID

    
    /* users activity all moduls with final grade */
select
mc.fullname  as 'Course',mgi.itemmodule,
case 
	when mgi.itemmodule = "quiz" 		then mq.name 
	when mgi.itemmodule = "assign" 		then ma.name 
	when mgi.itemmodule = "forum" 		then mf.name 
	when mgi.itemmodule = "data" 		then md.name 
	when mgi.itemmodule = "game" 		then mg.name 
	when mgi.itemmodule = "glossary" 	then mg2.name
	when mgi.itemmodule = "h5pactivity" then mhp.name
	when mgi.itemmodule = "hvp" 		then mh.name 
	when mgi.itemmodule = "lesson" 		then ml.name 
	when mgi.itemmodule = "lti" 		then ml2.name
	when mgi.itemmodule = "scorm" 		then ms.name 
	when mgi.itemmodule = "workshop" 	then mw.name 
	else mgi.itemmodule
end as instanceName,
mu.username as 'User Name',
mgg.finalgrade ,
mgg.finalgrade - mgg.rawgrade as difFinalRaw,/* ortalaması hesaplanarak modül bazlı ortalamaları verilebilir*/
mgi.gradetype ,
mgi.grademax ,
mgi.grademin ,
mgi.gradepass ,
mgg.rawgrade ,
mgg.rawgrademax ,
mgg.rawgrademin 
FROM  mdl_grade_grades mgg 
JOIN mdl_grade_items mgi on mgi.id = mgg.itemid 
JOIN mdl_user mu on mu.id=mgg.userid
JOIN mdl_course mc on mc.id =mgi.courseid 
LEFT JOIN mdl_quiz mq ON mgi.itemmodule 		= "quiz" 		 AND mgi.iteminstance = mq.id  
LEFT JOIN mdl_assign ma ON mgi.itemmodule 		= "assign" 		 AND mgi.iteminstance = ma.id  
LEFT JOIN mdl_forum mf ON mgi.itemmodule    	= "forum" 		 AND mgi.iteminstance = mf.id  
LEFT JOIN mdl_data md  ON mgi.itemmodule    	= "data" 		 AND mgi.iteminstance = md.id  
LEFT JOIN mdl_game mg ON mgi.itemmodule    		= "game" 		 AND mgi.iteminstance = mg.id  
LEFT JOIN mdl_glossary mg2 ON mgi.itemmodule    = "glossary" 	 AND mgi.iteminstance = mg2.id 
LEFT JOIN mdl_h5pactivity mhp ON mgi.itemmodule = "h5pactivity"  AND mgi.iteminstance = mhp.id 
LEFT JOIN mdl_hvp mh ON mgi.itemmodule    		= "hvp" 		 AND mgi.iteminstance = mh.id  
LEFT JOIN mdl_lesson ml ON mgi.itemmodule    	= "lesson" 		 AND mgi.iteminstance = ml.id  
LEFT JOIN mdl_lti ml2 ON mgi.itemmodule    		= "lti" 		 AND mgi.iteminstance = ml2.id 
LEFT JOIN mdl_scorm ms  ON mgi.itemmodule   	= "scorm" 		 AND mgi.iteminstance = ms.id  
LEFT JOIN mdl_workshop mw ON mgi.itemmodule    	= "workshop" 	 AND mgi.iteminstance = mw.id  
WHERE not ISNULL(mgi.itemmodule) and not ISNULL(mgg.finalgrade )
order by mc.fullname ,instanceName,mu.username 


-- Course Resource File Sizes and Counts
SELECT
	context.id "Context Id",
	mcc.name as 'Category',
	c.id "Course Id",
	c.fullname AS "Course",
	COUNT(*) "Course Files" ,
	ROUND( SUM(f.filesize) / 1048576 ) AS 'File Size Mb'
FROM
	mdl_files AS f
JOIN mdl_context AS context ON
	context.id = f.contextid
JOIN mdl_course AS c ON
	c.id = (
	SELECT
		instanceid
	FROM
		mdl_context
	WHERE
		id = SUBSTRING_INDEX( SUBSTRING_INDEX( context.path, '/' , -2 ) , '/', 1 ) )
JOIN mdl_course_categories mcc on
	mcc.id = c.category
WHERE
	filesize >0
GROUP BY
	c.id

 -- Courses with Teacher Count   
 SELECT
	 c.fullname as 'Course',
	(
	SELECT
		Count(ra.userid) AS Users
	FROM
		mdl_role_assignments AS ra
	JOIN mdl_context AS ctx ON
		ra.contextid = ctx.id
	WHERE
		ra.roleid = 3
		AND ctx.instanceid = c.id) AS Teachers
FROM
	mdl_course AS c
ORDER BY
	Teachers ASC

    -- Users Who Logged In Once
    SELECT
	u.id as 'UserId',
	u.username as 'User Name',
	concat(u.firstname, ' ', u.lastname) as 'Name',
	FROM_UNIXTIME(u.lastaccess) as 'Last Access'
FROM
	mdl_user u
WHERE
	u.deleted = 0
	AND u.lastlogin = 0
	AND u.lastaccess > 0

    --Users with No Access to Enrolled Courses
    SELECT
	u.id as UserId,
	concat(u.firstname, ' ', u.lastname) as 'Name',
	c.fullname as 'Course',
	IF (u.lastaccess = 0,
	'Never',
	DATE_FORMAT(FROM_UNIXTIME(u.lastaccess), '%Y-%m-%d')) AS 'User Last Access',
	(
	SELECT
		DATE_FORMAT(FROM_UNIXTIME(timeaccess), '%Y-%m-%d')
	FROM
		mdl_user_lastaccess
	WHERE
		userid = u.id
		and courseid = c.id) as 'Course Last Access'
FROM
	mdl_user_enrolments as ue
JOIN mdl_enrol as e on
	e.id = ue.enrolid
JOIN mdl_course as c ON
	c.id = e.courseid
JOIN mdl_user as u ON
	u .id = ue.userid
LEFT JOIN mdl_user_lastaccess as ul on
	ul.userid = u.id
where
	ul.timeaccess IS NULL

    --Users
    select
	mu.id 'UserId',
	mu.username 'User Name',
	mu.firstname 'First Name',
	mu.lastname 'Last Name',
	CONCAT(mu.firstname, ' ', mu.lastname) 'Name',
	mu.email 'EMail',
	mu.institution 'Institute',
	case
		when mu.department = '-' then ''
		else mu.department
	end 'Department',
	case 
		when mu.city = 'Turkey-İstanbul' then 'İstanbul'
		when mu.city = '-İstanbul' then 'İstanbul'
		when mu.city = 'İstanbul' then 'İstanbul'
		when mu.city = 'Denizli"' then 'Denizli'
        when mu.city = 'Karatay /konya' then 'Konya'
        when mu.city = 'Balıkesir/bandırma' then 'Balıkesir'
		when mu.city = '-' then ''
		else CONCAT(UPPER(SUBSTRING(mu.city, 1, 1)), LOWER(SUBSTRING(mu.city, 2)))
	end as 'City',
	mu.country 'Country',
	mu.lang 'Language',
	mu.confirmed 'Confirmed User',
	mu.deleted 'Deleted User',
	mu.suspended 'Suspended User',
	(IF(mu.suspended = 0,
	1,
	0)* IF(mu.deleted = 0,
	1,
	0)) 'Active User',
	FROM_UNIXTIME(lastlogin) as "Last Login",
	'Moodle' as 'Source',
	case
		when mra.roleid = 1 then 'Manager'
		when mra.roleid = 2 then 'Course Creator'
		when mra.roleid = 3 then 'Editing Teacher'
		when mra.roleid = 4 then 'Teacher'
		when mra.roleid = 5 then 'Student'
		when mra.roleid = 6 then 'Guest'
		when mra.roleid = 7 then 'User'
		when mra.roleid = 8 then 'Front Page'
		else mra.roleid
	end as "Role"
from
	mdl_user mu
left join mdl_role_assignments mra on
	mra.userid = mu.id
group BY 
	mu.id,
	mu.username,
	mu.firstname,
	mu.lastname,
	CONCAT(mu.firstname, ' ', mu.lastname),
	mu.email,
	mu.institution,
	mu.department,
	mu.city,
	mu.country,
	mu.lang,
	mu.confirmed,
	mu.suspended,
	mu.deleted,
	FROM_UNIXTIME(lastlogin),
	mra.roleid

--Questionbank Details
SELECT
    q.id AS 'Question ID',
    q.name AS 'Question Name',
    q.questiontext AS 'Question Text',
    q.defaultmark AS 'Question Default Mark',
    q.penalty AS 'Question Penalty',
    q.qtype AS 'Question Type',
    qs.s as 's',
    qs.effectiveweight as 'effectiveweight',
    qs.negcovar as 'negcovar',
    qs.discriminationindex as 'discriminationindex',
    qs.discriminativeefficiency as 'discriminativeefficiency',
    qs.sd as 'sd',
    qs.facility as 'facility',
    qs.maxmark as 'maxmark',
    qs.randomguessscore as 'randomguessscore',
    FROM_UNIXTIME(q.timecreated) AS 'Question Created_Time',
    FROM_UNIXTIME(q.timemodified) AS 'Question Modified_Time',
    creater.username AS 'Creater',
    modifier.username AS 'Modifier',
    qv.version AS 'Question Version',
    qv.status AS 'Question Status',
    owner.username AS 'QuestionBank Owner',
    mqc.name AS 'Category Name',
    CASE 
        WHEN mc.contextlevel = 50 AND mc.instanceid = mc2.id THEN mc2.fullname
        WHEN mc.contextlevel = 70 AND mcm.instance = mq.id THEN CONCAT(mc3.fullname, ' / ', mq.name)
        ELSE ''
    END AS 'Course Instance'
FROM mdl_question_versions qv
JOIN mdl_question q ON qv.questionid = q.id
JOIN mdl_question_bank_entries mqbe ON qv.questionbankentryid = mqbe.id
JOIN mdl_question_categories mqc ON mqbe.questioncategoryid = mqc.id
JOIN mdl_user creater ON q.createdby = creater.id
JOIN mdl_user modifier ON q.modifiedby = modifier.id
JOIN mdl_user owner ON mqbe.ownerid = owner.id
JOIN mdl_context mc ON mqc.contextid = mc.id
LEFT JOIN mdl_course_modules mcm ON mc.contextlevel = 70 AND mc.instanceid = mcm.id
LEFT JOIN mdl_modules mm ON mcm.module = mm.id
LEFT JOIN mdl_question_references qr ON qr.usingcontextid = mc.id AND qr.questionbankentryid = mqbe.id
LEFT JOIN mdl_course mc2 ON mc.contextlevel = 50 AND mc.instanceid = mc2.id
LEFT JOIN mdl_quiz mq ON mcm.instance = mq.id
LEFT JOIN mdl_course mc3 ON mq.course = mc3.id
LEFT JOIN mdl_question_statistics qs ON q.id = qs.questionid
ORDER BY Course_Instance;

-- List of Competencies
SELECT 
    f.shortname AS "Framework",
    comp.shortname AS "Competency",
    cccomp.courseid AS "Course id",
    c.fullname AS "Course name",
    c.shortname AS "Course code"
FROM mdl_competency_coursecomp cccomp
INNER JOIN mdl_competency comp ON cccomp.competencyid = comp.id
INNER JOIN mdl_course c ON cccomp.courseid = c.id
INNER JOIN mdl_competency_framework f ON comp.competencyframeworkid = f.id;

--User Activity Log Report
SELECT
	l.id AS "Log Event Id",
	u.username as 'User Name',
	concat(u.firstname, ' ', u.lastname) as 'Name',
	l.action as 'Action',
	l.origin as 'Origin',
	l.ip as 'Ip',	
	DATE_FORMAT(FROM_UNIXTIME(l.timecreated), '%Y-%m-%d %H:%i') AS "Time"
FROM
	mdl_logstore_standard_log l
JOIN mdl_user u ON
	u.id = l.userid
WHERE
	l.action IN ('loggedin', 'loggedout')
ORDER BY
	l.id asc

    -- Active Courses and Instructors Analysis Report
    SELECT
	mcc.name as Category,
	course.fullname AS Course,
	cast(IF(course.startdate > 0,
	FROM_UNIXTIME(startdate),
	'1970-01-01 00:00:00') as datetime) AS "Course Start Date",
    'Moodle' as 'Source',
	(
	SELECT
		COUNT(ra.userid) AS Users
	FROM
		mdl_role_assignments AS ra
	JOIN mdl_context AS ctx ON
		ra.contextid = ctx.id
	WHERE
		ra.roleid = 5
		AND ctx.instanceid = course.id
	) AS Students,
	(
	SELECT
		COUNT(ra.userid) AS Users
	FROM
		mdl_role_assignments AS ra
	JOIN mdl_context AS ctx ON
		ra.contextid = ctx.id
	WHERE
		ra.roleid = 4
		AND ctx.instanceid = course.id
	) AS "Assistant teacher",
	(
	SELECT
		COUNT(ra.userid) AS Users
	FROM
		mdl_role_assignments AS ra
	JOIN mdl_context AS ctx ON
		ra.contextid = ctx.id
	WHERE
		ra.roleid = 3
		AND ctx.instanceid = course.id
	) AS Teachers,
	(
	SELECT
		COUNT(*)
	FROM
		mdl_log AS l
	WHERE
		l.course = course.id) AS Hits,
	(
	SELECT
		COUNT(*)
	FROM
		mdl_log AS l
	JOIN mdl_context AS con ON
		con.instanceid = l.course
		AND con.contextlevel = 50
	JOIN mdl_role_assignments AS ra ON
		ra.contextid = con.id
		AND ra.userid = l.userid
		AND ra.roleid = 5
	WHERE
		l.course = course.id) AS "Students Hits",
	(
	SELECT
		COUNT(*)
	FROM
		mdl_log AS l
	JOIN mdl_context AS con ON
		con.instanceid = l.course
		AND con.contextlevel = 50
	JOIN mdl_role_assignments AS ra ON
		ra.contextid = con.id
		AND ra.userid = l.userid
		AND ra.roleid = 3
	WHERE
		l.course = course.id) AS "Teachers Hits",
	(
	SELECT
		GROUP_CONCAT( CONCAT( u.firstname, " ", u.lastname ) )
	FROM
		mdl_course c
	JOIN mdl_context con ON
		con.instanceid = c.id
	JOIN mdl_role_assignments ra ON
		con.id = ra.contextid
		AND con.contextlevel = 50
	JOIN mdl_role r ON
		ra.roleid = r.id
	JOIN mdl_user u ON
		u.id = ra.userid
	WHERE
		r.id = 3
		AND c.id = course.id
	GROUP BY
		c.id
	) AS 'Teachers List',
	(
	SELECT
		COUNT(*)
	FROM
		mdl_course_modules cm
	WHERE
		cm.course = course.id) Modules,
	(
	SELECT
		COUNT(DISTINCT cm.module)
	FROM
		mdl_course_modules cm
	WHERE
		cm.course = course.id) 'Unique Modules',
	(
	SELECT
		GROUP_CONCAT(DISTINCT m.name)
	FROM
		mdl_course_modules cm
	JOIN mdl_modules as m ON
		m.id = cm.module
	WHERE
		cm.course = course.id) 'Unique Module Names',
	(
	SELECT
		COUNT(*)
	FROM
		mdl_course_modules cm
	JOIN mdl_modules as m ON
		m.id = cm.module
	WHERE
		cm.course = course.id
		AND m.name IN ( 'ouwiki', 'wiki') ) "Num Wikis",
	(
	SELECT
		COUNT(*)
	FROM
		mdl_course_modules cm
	JOIN mdl_modules as m ON
		m.id = cm.module
	WHERE
		cm.course = course.id
		AND m.name IN ('oublog') ) "Num Blogs",
	(
	SELECT
		COUNT(*)
	FROM
		mdl_course_modules cm
	JOIN mdl_modules as m ON
		m.id = cm.module
	WHERE
		cm.course = course.id
		AND m.name IN ( 'forum', 'forumng') ) "Num Forums",
	(
	SELECT
		COUNT(*)
	FROM
		mdl_course_modules cm
	JOIN mdl_modules as m ON
		m.id = cm.module
	WHERE
		cm.course = course.id
		AND m.name IN ('resource', 'folder', 'url', 'tab', 'file', 'book', 'page') ) Resources,
	(
	SELECT
		COUNT(*)
	FROM
		mdl_course_modules cm
	JOIN mdl_modules as m ON
		m.id = cm.module
	WHERE
		cm.course = course.id
		AND m.name IN ('forum', 'forumng', 'oublog', 'page', 'file', 'url', 'wiki' , 'ouwiki') ) "Basic Activities",
	(
	SELECT
		COUNT(*)
	FROM
		mdl_course_modules cm
	JOIN mdl_modules as m ON
		m.id = cm.module
	WHERE
		cm.course = course.id
		AND m.name IN ('advmindmap', 'assign', 'attendance', 'book', 'choice', 'folder', 'tab', 'glossary', 'questionnaire', 'quiz', 'label' ) ) "Avarage Activities",
	(
	SELECT
		COUNT(*)
	FROM
		mdl_course_modules cm
	JOIN mdl_modules as m ON
		m.id = cm.module
	WHERE
		cm.course = course.id
		AND m.name IN ('elluminate', 'game', 'workshop') ) "Advanced Activities"
FROM
	mdl_course AS course
LEFT JOIN mdl_course_categories mcc 
	on
	course.category = mcc.id
HAVING
	Modules > 0/*2*/
ORDER BY
	'Unique Modules' DESC

    --Categories
    SELECT
	cc.name AS 'Category',
	c.fullname AS 'Course',
	CASE
		WHEN gi.itemtype = 'course'
	   THEN CONCAT(c.fullname, ' - Total')
		ELSE gi.itemname
	END AS 'Item Name',
	gi.itemtype as 'Item Type',
	'Moodle' as 'Source'
FROM
	mdl_course AS c
JOIN mdl_grade_items AS gi ON
	gi.courseid = c.id
JOIN mdl_course_categories AS cc ON
	cc.id = c.category
WHERE
	gi.itemtype = 'category'
order by
	cc.name asc

    -- Manual

    SELECT
	cc.name AS 'Category',
	c.fullname AS 'Course',
	CASE
		WHEN gi.itemtype = 'course'
	   THEN CONCAT(c.fullname, ' - Total')
		ELSE gi.itemname
	END AS 'Item Name',
	gi.itemtype as 'Item Type',
	'Moodle' as 'Source'
FROM
	mdl_course AS c
JOIN mdl_grade_items AS gi ON
	gi.courseid = c.id
JOIN mdl_course_categories AS cc ON
	cc.id = c.category
WHERE
	gi.itemtype = 'manual'
order by
	cc.name asc

    --Course Completion with Criteria
    SELECT
	u.username AS 'User Name',
	concat(u.firstname, ' ', u.lastname) as 'Name',
	mcc.name as 'Category',
	c.shortname AS 'Course',
	CASE
		WHEN (
		SELECT
			a.method
		FROM
			mdl_course_completion_aggr_methd AS a
		WHERE
			(a.course = c.id
				AND a.criteriatype IS NULL) = 1) THEN "Any"
		ELSE "All"
	END AS Aggregation,
	CASE
		WHEN p.criteriatype = 1 THEN "Self"
		WHEN p.criteriatype = 2 THEN "By Date"
		WHEN p.criteriatype = 3 THEN "Unenrol Status"
		WHEN p.criteriatype = 4 THEN "Activity"
		WHEN p.criteriatype = 5 THEN "Duration"
		WHEN p.criteriatype = 6 THEN "Course Grade"
		WHEN p.criteriatype = 7 THEN "Approve by Role"
		WHEN p.criteriatype = 8 THEN "Previous Course"
	END AS 'Criteria Type',
	FROM_UNIXTIME(t.timecompleted) AS 'Completed'
FROM
	mdl_course_completion_crit_compl AS t
JOIN mdl_user AS u ON
	t.userid = u.id
JOIN mdl_course AS c ON
	t.course = c.id
JOIN mdl_course_categories mcc ON
	mcc.id = c.category
JOIN mdl_course_completion_criteria AS p ON
	t.criteriaid = p.id

    --Courses
    SELECT
	cc.name AS 'Category',
	c.fullname AS 'Course',
	CASE
		WHEN gi.itemtype = 'course'
	   THEN CONCAT(c.fullname, ' - Total')
		ELSE gi.itemname
	END AS 'Item Name',
	gi.itemtype as 'Item Type',
	'Moodle' as 'Source'
FROM
	mdl_course AS c
JOIN mdl_grade_items AS gi ON
	gi.courseid = c.id
JOIN mdl_course_categories AS cc ON
	cc.id = c.category
WHERE
	gi.itemtype = 'course'
order by
	cc.name asc

    --Enrolment Count by Course
    SELECT
	c.fullname as 'Course',
	concat(u.firstname, ' ', u.lastname) as 'Name'
FROM
	mdl_course AS c
JOIN mdl_enrol AS en ON
	en.courseid = c.id
JOIN mdl_user_enrolments AS ue ON
	ue.enrolid = en.id
JOIN mdl_user u on
	u.id = ue.userid
GROUP BY
	c.id,
	concat(u.firstname, ' ', u.lastname)
ORDER BY
	c.fullname
    
    -- Enrolled Courses by Students
    SELECT
	u.id as UserId,
	concat(u.firstname, ' ', u.lastname) as 'Name',
	c.fullname as 'Course',
	FROM_UNIXTIME(u.lastaccess) AS 'User Last Access',
	FROM_UNIXTIME(ul.timeaccess) as "Course Last Access",
	case 
		when ul.timeaccess is null then 'Yes'
		when ul.timeaccess is not null then 'No'
	end as 'No Access'
FROM
	mdl_user_enrolments as ue
JOIN mdl_enrol as e on
	e.id = ue.enrolid
JOIN mdl_course as c ON
	c.id = e.courseid
JOIN mdl_user as u ON
	u .id = ue.userid
LEFT JOIN mdl_user_lastaccess as ul on
	ul.userid = u.id
group by
	u.id,
	concat(u.firstname, ' ', u.lastname),
	c.fullname,
	u.lastaccess

    --Learner Report by Learner with Grades
SELECT
	concat(u.firstname, ' ', u.lastname) AS 'Name',
	cc.name AS 'Category',
	c.fullname AS 'Course',
	CASE
		WHEN gi.itemtype = 'Course' THEN c.fullname + ' Course Total'
		ELSE gi.itemname
	END AS 'Item Name',
	ROUND(gg.finalgrade, 2) AS Score,
	ROUND(gg.rawgrademax, 2) AS Max,
	ROUND(gg.finalgrade / gg.rawgrademax * 100 , 2) as Percentage
FROM
	mdl_course AS c
JOIN mdl_context AS ctx ON
	c.id = ctx.instanceid
JOIN mdl_role_assignments AS ra ON
	ra.contextid = ctx.id
JOIN mdl_user AS u ON
	u.id = ra.userid
JOIN mdl_grade_grades AS gg ON
	gg.userid = u.id
JOIN mdl_grade_items AS gi ON
	gi.id = gg.itemid
JOIN mdl_course_categories AS cc ON
	cc.id = c.category
WHERE
	gi.courseid = c.id
	and gi.itemname != 'Attendance'
ORDER BY
	`Name` ASC


/* Least Active Courses -- 33*/
SELECT
	mcc.name as 'Category',
	c.fullname as 'Course',
	CASE
		WHEN c.timecreated = c.timemodified THEN '-1'
		ELSE DATEDIFF(FROM_UNIXTIME(c.timemodified), FROM_UNIXTIME(c.timecreated))
	END AS 'Date Difference',
	COUNT(ue.id) AS 'Enroled Student',
	DATE_FORMAT(FROM_UNIXTIME(c.timecreated), '%Y-%m-%d %H:%i') AS 'Created Time',
	DATE_FORMAT(FROM_UNIXTIME(c.timemodified), '%Y-%m-%d %H:%i') AS 'Modified Time'
FROM
	mdl_course AS c
left join mdl_course_categories mcc on
	mcc.id = c.category
JOIN mdl_enrol AS en ON
	en.courseid = c.id
LEFT JOIN mdl_user_enrolments AS ue ON
	ue.enrolid = en.id
WHERE
	DATEDIFF(FROM_UNIXTIME(c.timemodified), FROM_UNIXTIME(c.timecreated) ) < 60
GROUP BY
	c.id
HAVING
	COUNT(ue.id) <= 3
ORDER BY
	c.fullname

    --Resources by Course and Teachers
    SELECT
	c.id as 'Id',
	mcc.name as 'Category',
	c.fullname as 'Course',
	(
	SELECT
		DISTINCT CONCAT(u.firstname, ' ', u.lastname)
	FROM
		mdl_role_assignments AS ra
	JOIN mdl_user AS u ON
		ra.userid = u.id
	JOIN mdl_context AS ctx ON
		ctx.id = ra.contextid
	WHERE
		ra.roleid = 4
		AND ctx.instanceid = c.id
		AND ctx.contextlevel = 50
	LIMIT 1) AS Teacher,
	(CASE
		WHEN c.fullname LIKE '%תשעב%' THEN '2012'
		WHEN c.fullname LIKE '%תשעא%' THEN '2011'
	END ) as Year,
	(CASE
		WHEN c.fullname LIKE '%סמסטר א%' THEN 'Semester A'
		WHEN c.fullname LIKE '%סמסטר ב%' THEN 'Semester B'
		WHEN c.fullname LIKE '%סמסטר ק%' THEN 'Semester C'
	END ) as Semester,
	COUNT(c.id) AS Total,
	(
	SELECT
		count(*)
	FROM
		mdl_course_modules AS cm
	WHERE
		cm.course = c.id
		AND cm.module = 20) AS 'Tabs',
	(
	SELECT
		count(*)
	FROM
		mdl_course_modules AS cm
	WHERE
		cm.course = c.id
		AND cm.module = 33) AS 'Books'
FROM
	mdl_resource as r
JOIN mdl_course AS c on
	c.id = r.course
JOIN mdl_course_categories mcc on
	mcc.id = c.category
GROUP BY
	course
ORDER BY
	c.id asc

    --ContentBank Details
    SELECT 
mcc.id as ContentBank_ID,
mcc.name as ContentBank_Name,
creater.username  as 'Creater', 
modifier.username as 'Modifier',
mf.itemid as File_ID,
mf.filename as File_Name,
mf.filesize as File_Size,
SUBSTRING_INDEX(SUBSTRING_INDEX(mf.source,"\"",-2 ),"\"",1) as File_Source
,mf.license as File_Lisence,
FROM_UNIXTIME(mcc.timecreated) as ContentBank_Timecreated,  
FROM_UNIXTIME(mcc.timemodified) as ContentBank_Timemodified,
mc2.fullname as 'Course Name'
FROM mdl_contentbank_content mcc 
JOIN mdl_context mc on mcc.contextid = mc.id 
JOIN mdl_course mc2 on mc.instanceid = mc2.id 
JOIN mdl_user creater on creater.id = mcc.usercreated
JOIN mdl_user modifier on modifier.id = mcc.usermodified
left JOIN mdl_files mf on mf.itemid =mcc.id  and  mf.filename =mcc.name 
GROUP by mcc.name,Modifier,mc2.fullname 
ORDER BY mc2.fullname,mcc.name 


--User Course Grades Report
SELECT 
	u.firstname AS 'First Name',
	u.lastname AS 'Last Name',
	CONCAT(u.firstname , ' ' , u.lastname) AS 'Name',
	c.fullname AS 'Course',
	cc.name AS 'Category',
	gi.itemmodule AS 'Item Module',
	CASE
		WHEN gi.itemtype = 'course'
	   THEN CONCAT(c.fullname, ' - Total')
		ELSE gi.itemname
	END AS 'Item Name',
	gi.itemtype as 'Item Type',
	ROUND(gg.finalgrade, 2) AS Grade,
	'Moodle' as 'Source',
	FROM_UNIXTIME(gg.timemodified) AS TIME
FROM
	mdl_course AS c
JOIN mdl_context AS ctx ON
	c.id = ctx.instanceid
JOIN mdl_role_assignments AS ra ON
	ra.contextid = ctx.id
JOIN mdl_user AS u ON
	u.id = ra.userid
JOIN mdl_grade_grades AS gg ON
	gg.userid = u.id
JOIN mdl_grade_items AS gi ON
	gi.id = gg.itemid
JOIN mdl_course_categories AS cc ON
	cc.id = c.category
WHERE
	gi.courseid = c.id

    --User Last Access
    select
	mul.id 'Id', 
	mu.id 'UserId',
	mu.username 'User Name',
	CONCAT(mu.firstname, ' ', mu.lastname) 'Name',
	case 
		when mra.roleid = 4 then 'Teacher'
		when mra.roleid = 5 then 'Student'
	end as "Role",
	FROM_UNIXTIME(mul.timeaccess) as "Access"
from
	mdl_user mu
inner join mdl_user_lastaccess mul on
	mu.id = mul.userid
inner join mdl_role_assignments mra on
	mra.userid = mu.id
where
	mra.roleid in(4, 5)
group BY 
	mu.id,
	mu.username,
	CONCAT(mu.firstname, ' ', mu.lastname),
	mra.roleid,
	FROM_UNIXTIME(mul.timeaccess)

    --Logged-In Users from the Last 120 Days
    SELECT
	u.id as 'UserId',
	u.username as 'User Name',
	concat(u.firstname, ' ', u.lastname) as 'Name',
	FROM_UNIXTIME(`lastlogin`) as 'Last Login'
FROM
	mdl_user u
WHERE
	DATEDIFF( NOW(), FROM_UNIXTIME(`lastlogin`) ) < 120

    --Course Completions
    select 
	CONCAT(mu.firstname, ' ', mu.lastname) as 'Name', 
	mcc2.name as 'Category',
	mc.fullname as 'Course',
	FROM_UNIXTIME(mcc.timestarted) as 'Start Time',
	FROM_UNIXTIME(mcc.timeenrolled) as 'Enroll Time',
	FROM_UNIXTIME(mcc.timecompleted) as 'Completed Time'
from
	mdl_course_completions mcc
join mdl_user mu on
	mu.id = mcc.userid
join mdl_course mc on
	mc.id = mcc.course
join mdl_course_categories mcc2 on
	mcc2.id = mc.category

    --User Logins by Course
    select
	concat(mu.firstname, ' ', mu.lastname) as 'Name',
	mcc.name as 'Category',
	mc.fullname as 'Course',
	FROM_UNIXTIME(mgch.timemodified) as 'Last Login' 
from
	mdl_grade_categories_history mgch
join mdl_user mu on mu.id = mgch.loggeduser 
join mdl_course mc on mc.id  = mgch.courseid 
join mdl_course_categories mcc on mc.category = mcc.id 
group by 
	concat(mu.firstname, ' ', mu.lastname),
	mcc.name,
	mc.fullname,
	FROM_UNIXTIME(mgch.timemodified)

    -- Daily User Interactions and Activity Statistics
    /*-- 181*/
SELECT
	FROM_UNIXTIME(timecreated) AS "Date",
	YEAR(FROM_UNIXTIME(timecreated)) as 'Year',
	CONCAT(YEAR(FROM_UNIXTIME(timecreated)), '-', MONTH(FROM_UNIXTIME(timecreated))) as 'Year-Month', 
	case
		when MONTH(FROM_UNIXTIME(timecreated)) = 1 then 'January'
		when MONTH(FROM_UNIXTIME(timecreated)) = 2 then 'Februay'
		when MONTH(FROM_UNIXTIME(timecreated)) = 3 then 'March'
		when MONTH(FROM_UNIXTIME(timecreated)) = 4 then 'April'
		when MONTH(FROM_UNIXTIME(timecreated)) = 5 then 'May'
		when MONTH(FROM_UNIXTIME(timecreated)) = 6 then 'June'
		when MONTH(FROM_UNIXTIME(timecreated)) = 7 then 'July'
		when MONTH(FROM_UNIXTIME(timecreated)) = 8 then 'Agust'
		when MONTH(FROM_UNIXTIME(timecreated)) = 9 then 'September'
		when MONTH(FROM_UNIXTIME(timecreated)) = 10 then 'October'
		when MONTH(FROM_UNIXTIME(timecreated)) = 11 then 'November'
		when MONTH(FROM_UNIXTIME(timecreated)) = 12 then 'December'
	end as 'Month Name',
	MONTH(FROM_UNIXTIME(timecreated)) as 'Month',
	DAY(FROM_UNIXTIME(timecreated)) as 'Day',
	COUNT(DISTINCT userid) AS "Unique Users",
	ROUND(COUNT(*)/ 10) "User Hits (K)",
	SUM(IF(component = 'mod_quiz', 1, 0)) "Quizzes",
	SUM(IF(component = 'mod_forum' or component = 'mod_forumng', 1, 0)) "Forums",
	SUM(IF(component = 'mod_assign', 1, 0)) "Assignments",
	SUM(IF(component = 'mod_oublog', 1, 0)) "Blogs",
	SUM(IF(component = 'mod_resource', 1, 0)) "Files (Resource)",
	SUM(IF(component = 'mod_url', 1, 0)) "Links (Resource)",
	SUM(IF(component = 'mod_page', 1, 0)) "Pages (Resource)"
FROM
	mdl_logstore_standard_log
WHERE
	timecreated > UNIX_TIMESTAMP('2015-03-01 00:00:00')
GROUP BY
	MONTH(FROM_UNIXTIME(timecreated)),
	DAY(FROM_UNIXTIME(timecreated))
ORDER BY
	FROM_UNIXTIME(timecreated) desc

    --Activity Data
    SELECT
    u.username as 'User Name',
    u.firstname AS 'First Name',
    u.lastname AS 'Last Name',
    CONCAT(u.firstname , ' ' , u.lastname) AS 'Name',
    c.fullname AS 'Course',
    cc.name AS 'Category',
    m.name AS 'Activity Type',
    CASE
        WHEN m.name = 'assign'      THEN (SELECT name FROM mdl_assign      WHERE id = cm.instance)
        WHEN m.name = 'book'        THEN (SELECT name FROM mdl_book        WHERE id = cm.instance)
        WHEN m.name = 'chat'        THEN (SELECT name FROM mdl_chat        WHERE id = cm.instance)
        WHEN m.name = 'choice'      THEN (SELECT name FROM mdl_choice      WHERE id = cm.instance)
        WHEN m.name = 'data'        THEN (SELECT name FROM mdl_data        WHERE id = cm.instance)
        WHEN m.name = 'feedback'    THEN (SELECT name FROM mdl_feedback    WHERE id = cm.instance)
        WHEN m.name = 'folder'      THEN (SELECT name FROM mdl_folder      WHERE id = cm.instance)
        WHEN m.name = 'forum'       THEN (SELECT name FROM mdl_forum       WHERE id = cm.instance)
        WHEN m.name = 'glossary'    THEN (SELECT name FROM mdl_glossary    WHERE id = cm.instance)
        WHEN m.name = 'h5pactivity' THEN (SELECT name FROM mdl_h5pactivity WHERE id = cm.instance)
        WHEN m.name = 'imscp'       THEN (SELECT name FROM mdl_imscp       WHERE id = cm.instance)
        WHEN m.name = 'label'       THEN (SELECT name FROM mdl_label       WHERE id = cm.instance)
        WHEN m.name = 'lesson'      THEN (SELECT name FROM mdl_lesson      WHERE id = cm.instance)
        WHEN m.name = 'lti'         THEN (SELECT name FROM mdl_lti         WHERE id = cm.instance)
        WHEN m.name = 'page'        THEN (SELECT name FROM mdl_page        WHERE id = cm.instance)
        WHEN m.name = 'quiz'        THEN (SELECT name FROM mdl_quiz        WHERE id = cm.instance)
        WHEN m.name = 'resource'    THEN (SELECT name FROM mdl_resource    WHERE id = cm.instance)
        WHEN m.name = 'scorm'       THEN (SELECT name FROM mdl_scorm       WHERE id = cm.instance)
        WHEN m.name = 'survey'      THEN (SELECT name FROM mdl_survey      WHERE id = cm.instance)
        WHEN m.name = 'url'         THEN (SELECT name FROM mdl_url         WHERE id = cm.instance)
        WHEN m.name = 'wiki'        THEN (SELECT name FROM mdl_wiki        WHERE id = cm.instance)
        WHEN m.name = 'workshop'    THEN (SELECT name FROM mdl_workshop    WHERE id = cm.instance)
        ELSE 'Other activity'
    END AS 'Activity Name',
    CASE
        WHEN cm.completion = 0 THEN '0 None'
        WHEN cm.completion = 1 THEN '1 Self'
        WHEN cm.completion = 2 THEN '2 Auto'
    END AS 'Activity Completion Type',
    CASE
        WHEN cmc.completionstate = 0 THEN 'In Progress'
        WHEN cmc.completionstate = 1 THEN 'Completed'
        WHEN cmc.completionstate = 2 THEN 'Completed with Pass'
        WHEN cmc.completionstate = 3 THEN 'Completed with Fail'
        ELSE 'Unknown'
    END AS 'Progress',
    coalesce(ROUND(gg.finalgrade, 2), 0) AS Grade,
    FROM_UNIXTIME(cmc.timemodified) AS 'DateTime',
    'Moodle' as 'Source'
FROM mdl_course_modules_completion cmc
    JOIN mdl_user u ON cmc.userid = u.id
    JOIN mdl_course_modules cm ON cmc.coursemoduleid = cm.id
    JOIN mdl_course c ON cm.course = c.id
    JOIN mdl_course_categories cc ON cc.id = c.category
    JOIN mdl_modules m ON cm.module = m.id
    LEFT JOIN mdl_grade_grades gg ON gg.userid = u.id AND gg.itemid = cm.id -- Eklendi
WHERE u.id > 2

--Assignments and Grades
select 
	ma.name 'Course',
	STR_TO_DATE(DATE_FORMAT(FROM_UNIXTIME(ma.duedate), '%Y-%m-%d'), '%Y-%m-%d') AS 'DueDate',
	'Moodle' as 'Source',
	STR_TO_DATE(DATE_FORMAT(FROM_UNIXTIME(ma.timemodified), '%Y-%m-%d'), '%Y-%m-%d') AS 'DateTime',
	STR_TO_DATE(DATE_FORMAT(FROM_UNIXTIME(mas.timemodified), '%Y-%m-%d'), '%Y-%m-%d') AS 'SubmissionDate',
	mas.status 'Status',
	CONCAT(mu.firstname, ' ', mu.lastname) 'Name',
	mag.grade 'Grade',
	STR_TO_DATE(DATE_FORMAT(FROM_UNIXTIME(mag.timemodified), '%Y-%m-%d'), '%Y-%m-%d') AS 'GradingDate'
from
	mdl_assign ma,
	mdl_assign_submission mas,
	mdl_assign_grades mag,
	mdl_user mu
where
	ma.id = mas.`assignment`
	and ma.id = mag.`assignment`
	and mu.id = mas.userid
	and mu.id = mag.userid

    --Badges
    SELECT 
	u.username,
	CONCAT(u.firstname,' ',u.lastname) 'Name',
	b.name AS 'Badge Name',
	CASE
		WHEN b.courseid IS NOT NULL THEN
		(SELECT c.fullname 
		    FROM mdl_course AS c
		    WHERE c.id = b.courseid)
		WHEN b.courseid IS NULL THEN "*"
	END AS 'Course',
	CASE
	  WHEN t.criteriatype = 1 AND t.method = 1 THEN "Activity Completion (All)"
	  WHEN t.criteriatype = 1 AND t.method = 2 THEN "Activity Completion (Any)"
	  WHEN t.criteriatype = 2 AND t.method = 2 THEN "Manual Award"
	  WHEN t.criteriatype = 4 AND t.method = 1 THEN "Course Completion (All)"
	  WHEN t.criteriatype = 4 AND t.method = 2 THEN "Course Completion (Any)"
	  ELSE CONCAT ('Other: ', t.criteriatype)
	END AS 'Criteria Type',
	STR_TO_DATE(DATE_FORMAT( FROM_UNIXTIME( d.dateissued ), '%Y-%m-%d' ), '%Y-%m-%d' ) AS 'Date Issued',
	STR_TO_DATE(DATE_FORMAT( FROM_UNIXTIME( d.dateissued ), '%Y-%m-%d' ), '%Y-%m-%d' ) AS 'DateTime',
	STR_TO_DATE(DATE_FORMAT( FROM_UNIXTIME( d.dateexpire ), '%Y-%m-%d' ), '%Y-%m-%d' ) AS 'Date Expires',
	CONCAT ('<a target="_new" href="/badges/badge.php?hash=',d.uniquehash,'">link</a>') AS Details,
	'Moodle' as 'Source' 
FROM mdl_badge_issued   AS d
	JOIN mdl_badge          AS b ON d.badgeid = b.id
	JOIN mdl_user           AS u ON d.userid  = u.id
	JOIN mdl_badge_criteria AS t ON b.id      = t.badgeid
WHERE t.criteriatype <> 0
ORDER BY u.username

--Badges with Earned Count
/*--143*/
SELECT 
	b.id 'BadgeId',
	b.name 'Badge Name',
	b.description 'Description',
	CASE
		WHEN b.type = 1 THEN "System"
		WHEN b.type = 2 THEN "Course"
	END AS Context,
	CASE
		WHEN b.courseid IS NOT NULL THEN
		(SELECT c.fullname
		    FROM mdl_course AS c
		    WHERE c.id = b.courseid)
		WHEN b.courseid IS NULL THEN "*"
	END AS Course,
	CASE
		WHEN b.status = 0 OR b.status = 2 THEN "No"
		WHEN b.status = 1 OR b.status = 3 THEN "Yes"
		WHEN b.status = 4 THEN "x"
	END AS Available,
	CASE
		WHEN b.status = 0 OR b.status = 1 THEN "0"
		WHEN b.status = 2 OR b.status = 3 OR b.status = 4 THEN
		 (SELECT COUNT(*)
		   FROM mdl_badge_issued AS d
		   WHERE d.badgeid = b.id
		 )
	END AS Earned,
	'Moodle' as 'Source' 
FROM mdl_badge AS b

--Course Based Badges
SELECT
	b.id 'BadgeId',
	b.name 'Badge Name',
	b.description 'Description',
	c.fullname 'Course',
	'Moodle' as 'Source',
	CASE
		WHEN b.type = 1 THEN 'System'
		WHEN b.type = 2 THEN 'Course'
	END AS Level,
	CONCAT('<a target="_new" href="/badges/index.php?type=', b.type, '&id=',
			  c.id, '">Manage badges in: ', c.fullname, '</a>') AS Manage
FROM
	mdl_badge AS b
JOIN mdl_course AS c ON
	c.id = b.courseid

    --Course General
    SELECT 
	u.firstname AS 'First Name',
	u.lastname AS 'Last Name',
	CONCAT(u.firstname , ' ' , u.lastname) AS 'Name',
	c.fullname AS 'Course',
	cc.name AS 'Category',
    gi.itemmodule AS 'Item Module',
	CASE
		WHEN gi.itemtype = 'course'
	   THEN CONCAT(c.fullname, ' - Total')
		ELSE gi.itemname
	END AS 'Item Name',
	gi.itemtype as 'Item Type',
	ROUND(gg.finalgrade, 2) AS Grade,
	'Moodle' as 'Source',
	FROM_UNIXTIME(gg.timemodified) AS TIME
FROM
	mdl_course AS c
JOIN mdl_context AS ctx ON
	c.id = ctx.instanceid
JOIN mdl_role_assignments AS ra ON
	ra.contextid = ctx.id
JOIN mdl_user AS u ON
	u.id = ra.userid
JOIN mdl_grade_grades AS gg ON
	gg.userid = u.id
JOIN mdl_grade_items AS gi ON
	gi.id = gg.itemid
JOIN mdl_course_categories AS cc ON
	cc.id = c.category
WHERE
	gi.courseid = c.id
	AND gi.itemtype = 'course'

    --Course Resources
    SELECT
	concat('<a target="_new" href="/course/view.php?id=',c.id,'">',c.fullname,'</a>') AS 'Course Link',
	c.fullname 'Course',
	r.name 'Resource Name',
	'Moodle' as 'Source',
	(SELECT CONCAT(u.firstname,' ', u.lastname) AS 'Name' 
FROM mdl_role_assignments AS ra
	JOIN mdl_context AS ctx ON ra.contextid = ctx.id
	JOIN mdl_user AS u ON u.id = ra.userid
WHERE ra.roleid = 3 AND ctx.instanceid = c.id LIMIT 1) AS Teacher,
	concat('<a target="_new" href="/mod/resource/view.php?id=',r.id,'">',r.name,'</a>') AS 'Resource Link'
FROM mdl_resource AS r
	JOIN mdl_course AS c ON r.course = c.id

    --Feedbacks
    SELECT
	c.fullname as "Course",
	f.name AS "Feedback",
	CONCAT(u.firstname,'  ',u.lastname) as "Name",
	STR_TO_DATE(DATE_FORMAT(FROM_UNIXTIME(fc.timemodified), '%Y-%m-%d %H:%i'),'%Y-%m-%d %H:%i') AS "DateTime",
	IF(i.typ = 'label', i.presentation, i.name) AS "Question",
	/* answers presentation string starts with these 6 characters:  r>>>>>*/
	CASE 
		WHEN i.typ = 'multichoice' THEN SUBSTRING(i.presentation,7) 
	END AS "Possible Answers",
	CASE i.typ 
		WHEN 'multichoice' THEN v.value 
		ELSE '-' 
	END AS "Chosen Answer Num",
	CASE v.value
	  WHEN 1 THEN SUBSTRING(i.presentation, 7, POSITION('|' IN i.presentation) - 7)
	  WHEN 2 THEN SUBSTRING_INDEX(SUBSTRING_INDEX(i.presentation, '|',2), '|',-1)
	  WHEN 3 THEN SUBSTRING_INDEX(SUBSTRING_INDEX(i.presentation, '|',3), '|',-1)
	  WHEN 4 THEN SUBSTRING_INDEX(SUBSTRING_INDEX(i.presentation, '|',4), '|',-1)
	  WHEN 5 THEN SUBSTRING_INDEX(SUBSTRING_INDEX(i.presentation, '|',5), '|',-1)
	  WHEN 6 THEN SUBSTRING_INDEX(SUBSTRING_INDEX(i.presentation, '|',6), '|',-1)
	  WHEN 7 THEN SUBSTRING_INDEX(SUBSTRING_INDEX(i.presentation, '|',7), '|',-1)
	  WHEN 8 THEN SUBSTRING_INDEX(SUBSTRING_INDEX(i.presentation, '|',8), '|',-1)
	  WHEN 9 THEN SUBSTRING_INDEX(SUBSTRING_INDEX(i.presentation, '|',9), '|',-1)
	  ELSE CONCAT("More:", v.value)
	END AS "Chosen Answer Text",'Moodle' as 'Source'
FROM mdl_feedback AS f
	JOIN mdl_course AS c ON c.id=f.course
	JOIN mdl_feedback_item AS i ON f.id=i.feedback
	JOIN mdl_feedback_completed AS fc ON f.id=fc.feedback
	LEFT JOIN mdl_feedback_value AS v ON v.completed=fc.id AND v.item=i.id
	JOIN mdl_user AS u ON fc.userid=u.id
WHERE i.typ IN ('label', 'multichoice')

--Grade Report
SELECT * 
FROM (
    SELECT 
        u.firstname AS 'First Name',
        u.lastname AS 'Last Name',
        CONCAT(u.firstname, ' ', u.lastname) AS 'Name',
        c.fullname AS 'Course',
        cc.name AS 'Category',
        gi.itemmodule AS 'Item Module',
        gi.itemtype AS 'Item Type',
        CASE 
            WHEN gi.gradetype=0 THEN 'No Grade'
            WHEN gi.gradetype=1 THEN 'Grade'
            WHEN gi.gradetype=2 THEN 'Scale'
            ELSE 'Unknown'
        END AS 'Grade Type',
        CASE
            WHEN gi.itemtype = 'course' THEN CONCAT(c.fullname, ' Course Total')
            ELSE gi.itemname
        END AS 'Item Name',
        coalesce(ROUND(gg.finalgrade, 2), 0) AS Grade,
        FROM_UNIXTIME(gg.timemodified) AS 'DateTime',
        'Moodle' AS 'Source',
        CASE
            WHEN cmc.completionstate = 0 THEN 'In Progress'
            WHEN cmc.completionstate = 1 THEN 'Completed'
            WHEN cmc.completionstate = 2 THEN 'Completed with Pass'
            WHEN cmc.completionstate = 3 THEN 'Completed with Fail'
            ELSE 'Unknown'
        END AS 'Progress'
    FROM 
        mdl_course AS c
    JOIN mdl_grade_items AS gi ON gi.courseid = c.id
    JOIN mdl_context AS ctx ON c.id = ctx.instanceid
    JOIN mdl_role_assignments AS ra ON ra.contextid = ctx.id
    JOIN mdl_user AS u ON u.id = ra.userid
    JOIN mdl_grade_grades AS gg ON gg.userid = u.id
    JOIN mdl_course_categories AS cc ON cc.id = c.category
    LEFT JOIN mdl_course_modules AS cm ON cm.course = gi.courseid AND cm.instance = gi.iteminstance
    LEFT JOIN mdl_course_modules_completion AS cmc ON cmc.userid = u.id AND cmc.coursemoduleid = cm.id
) AS sub
WHERE sub.Progress != 'Unknown' and sub.DateTime is not null
group BY 	
		sub.`First Name`,
        sub.`Last Name`,
        sub.Name,
        sub.Course,
        sub.Category,
        sub.`Item Module`,
        sub.`Item Type`,
        sub.`Grade Type`,
        sub.`Item Name`,
        sub.Grade,
        sub.DateTime,
        sub.Source,
        sub.Progress

--Student Activity
SELECT
	mul.id,
	CONCAT(u.firstname , ' ' , u.lastname) AS 'Name',
	c.fullname AS 'Course',
	cc.name AS 'Category',
	FROM_UNIXTIME(mul.timeaccess) as 'Date'
FROM mdl_course AS c
	JOIN mdl_context AS ctx ON c.id = ctx.instanceid
	JOIN mdl_role_assignments AS ra ON ra.contextid = ctx.id
	JOIN mdl_user AS u ON u.id = ra.userid
	JOIN mdl_user_lastaccess as mul on mul.userid = u.id and mul.courseid = c.id 
	JOIN mdl_course_categories AS cc ON cc.id = c.category
group BY 
	mul.id


    --User Based Badges
    SELECT
	u.username,
	CONCAT(u.firstname, ' ', u.lastname) 'Name' ,
	(
	SELECT
		COUNT(*)
	FROM
		mdl_badge_issued AS d
	WHERE
		d.userid = u.id) as 'Earned Badges',
	'Moodle' as 'Source'
FROM
	mdl_user AS u
ORDER BY
	'Earned Badges' DESC,
	u.username ASC

    --Waiting Enrolments
    SELECT
	u.username,
	CONCAT(u.firstname, ' ', u.lastname) 'Name', 
	c.fullname AS "Course",
	'Moodle' as "Source",
	ef.action 'Action',
	r.shortname AS "Role",
	STR_TO_DATE(DATE_FORMAT(FROM_UNIXTIME(ef.timestart),   '%Y-%m-%d %H:%i'),'%Y-%m-%d %H:%i') AS "DateTime",
	STR_TO_DATE(DATE_FORMAT(FROM_UNIXTIME(ef.timestart),   '%Y-%m-%d %H:%i'),'%Y-%m-%d %H:%i') AS "Enrolment Start",
	STR_TO_DATE(DATE_FORMAT(FROM_UNIXTIME(ef.timeend),     '%Y-%m-%d %H:%i'),'%Y-%m-%d %H:%i') AS "Enrolment End",
	STR_TO_DATE(DATE_FORMAT(FROM_UNIXTIME(ef.timemodified),'%Y-%m-%d %H:%i'),'%Y-%m-%d %H:%i') AS "Uploaded Date"
FROM mdl_enrol_flatfile ef
	JOIN mdl_user           u  ON u.id = ef.userid
	JOIN mdl_course         c  ON c.id = ef.courseid
	JOIN mdl_role           r  ON r.id = ef.roleid
ORDER BY u.username


--User Access Info
select
	mul.id 'Id', 
	mu.id 'UserId',
	mu.username 'User Name',
	CONCAT(mu.firstname, ' ', mu.lastname) 'Name',
	mra.roleid as 'RoleId',
	case
		when mra.roleid = 1 then 'Manager'
		when mra.roleid = 2 then 'Course Creator'
		when mra.roleid = 3 then 'Editing Teacher'
		when mra.roleid = 4 then 'Teacher'
		when mra.roleid = 5 then 'Student'
		when mra.roleid = 6 then 'Guest'
		when mra.roleid = 7 then 'User'
		when mra.roleid = 8 then 'Front Page'
		else mra.roleid
	end as "Role",
	FROM_UNIXTIME(mul.timeaccess) as "Access"
from
	mdl_user mu
inner join mdl_user_lastaccess mul on
	mu.id = mul.userid
inner join mdl_role_assignments mra on
	mra.userid = mu.id
group BY 
	mu.id,
	mu.username,
	CONCAT(mu.firstname, ' ', mu.lastname),
	mra.roleid,
	FROM_UNIXTIME(mul.timeaccess)
order by
	FROM_UNIXTIME(mul.timeaccess) desc

    --User Last Access by Course
    SELECT
	mu.id AS UserId,
	mu.firstname AS First_Name,
	mu.lastname AS Last_Name,
	CONCAT(mu.firstname, ' ', mu.lastname) AS Name,
	mu.email AS EMail,
	CASE
		WHEN mu.city = 'Turkey-İstanbul' THEN 'İstanbul'
		WHEN mu.city = '-İstanbul' THEN 'İstanbul'
		WHEN mu.city = 'İstanbul' THEN 'İstanbul'
		WHEN mu.city = 'Denizli"' THEN 'Denizli'
		WHEN mu.city = '-' THEN ''
		ELSE CONCAT(UPPER(SUBSTRING(mu.city, 1, 1)), LOWER(SUBSTRING(mu.city, 2)))
	END AS City,
	mu.phone1 AS Phone,
	mu.institution AS Institute,
	c.fullname AS Course,
	IF (mu.lastaccess = 0,
	'never',
	FROM_UNIXTIME(mu.lastaccess)) AS Last_Access,
	(
	SELECT
		FROM_UNIXTIME(timeaccess)
	FROM
		mdl_user_lastaccess
	WHERE
		userid = mu.id
		AND courseid = c.id
    ) AS Course_Last_Access
FROM
	mdl_user_enrolments AS ue
JOIN mdl_enrol AS e ON
	e.id = ue.enrolid
JOIN mdl_course AS c ON
	c.id = e.courseid
JOIN mdl_user AS mu ON
	mu.id = ue.userid
LEFT JOIN mdl_user_lastaccess AS ul ON
	ul.userid = mu.id
group BY
	mu.id,
	mu.firstname,
	mu.lastname,
	CONCAT(mu.firstname, ' ', mu.lastname),
	mu.email,
	mu.city,
	mu.phone1,
	mu.institution,
	c.fullname,
	mu.lastaccess

--All the Users in Groups
SELECT
	c.fullname AS "Course",
	g.name AS "Group",
	u.id as 'UserId',
	u.username as 'User Name',
	concat(u.firstname, ' ', u.lastname) AS "Name"
FROM
	mdl_groups_members gm
JOIN mdl_groups g ON
	g.id = gm.groupid
JOIN mdl_course c ON
	c.id = g.courseid
JOIN mdl_user u ON
	u.id = gm.userid

    --Assignment Grades and Feedback Comments Report
    select
	mu.id as 'User Id',
	mu.username as 'User Name',
	concat(mu.firstname, ' ', mu.lastname) as 'User',
	ma.name as 'Assign Name',
	mag.attemptnumber as 'Attempt Number',
	mag.grade as 'Grade',
	grader.username as 'Grader',
	mac.commenttext as 'Comment Text'
from
	mdl_assignfeedback_comments mac
JOIN mdl_assign ma on
	ma.id = mac.`assignment`
JOIN mdl_assign_grades mag on
	mag.id = mac.grade
JOIN mdl_user mu on
	mu.id = mag.userid
JOIN mdl_user grader on
	grader.id = mag.grader

    --Assignment Submission and Grading Details Report
    SELECT 
    user.username as 'User Name',
	concat(user.firstname, ' ', user.lastname) as 'Name',
	course.fullname AS 'Course',
	assign.name AS 'Assignment Name',
	submission.status AS 'Submission Status',
	submission.latest AS 'Latest Submission',
	submission.attemptnumber AS 'Attempt Number',
	submission.assignment AS 'Assignment Id',
	assign.attemptreopenmethod AS 'Reopen Method',
	assign.grade as 'Max Grade',
	grade.grade as 'Final Grade',
	grader_user.username as 'Grader User Name',
	onlinetext.id as 'Submit on Line Text Id',
	onlinetext.onlinetext as 'Submission Text',
	file.id as 'Submit File Id',
	file.numfiles as 'Num Files', 
     CASE 
        WHEN submission.timecreated != 0 THEN timestamp(DATE_FORMAT(FROM_UNIXTIME(submission.timecreated), '%Y-%m-%d %H:%i' )) ELSE NULL 
    END  AS 'Submission Time',
     CASE 
        WHEN submission.timemodified != 0 THEN timestamp(DATE_FORMAT(FROM_UNIXTIME(submission.timemodified), '%Y-%m-%d %H:%i' ))ELSE NULL 
    END AS 'Last Modified Time',
     CASE  
        WHEN assign.duedate != 0 THEN timestamp(DATE_FORMAT(FROM_UNIXTIME(assign.duedate), '%Y-%m-%d %H:%i' )) ELSE NULL 
    END  AS 'Due Date',
     CASE 
        WHEN assign.allowsubmissionsfromdate != 0 THEN timestamp(DATE_FORMAT(FROM_UNIXTIME(assign.allowsubmissionsfromdate), '%Y-%m-%d %H:%i' )) ELSE NULL 
    END  AS 'Submissions Open Date',
     CASE 
        WHEN assign.cutoffdate != 0 THEN timestamp(DATE_FORMAT(FROM_UNIXTIME(assign.cutoffdate), '%Y-%m-%d %H:%i' )) ELSE NULL 
    END  AS 'Cutoff Date',
     CASE 
        WHEN assign.gradingduedate != 0 THEN timestamp(DATE_FORMAT(FROM_UNIXTIME(assign.gradingduedate), '%Y-%m-%d %H:%i' )) ELSE NULL 
    END  AS 'Grading Due Date',
     CASE 
        WHEN grade.timecreated != 0 THEN timestamp(DATE_FORMAT(FROM_UNIXTIME(grade.timecreated), '%Y-%m-%d %H:%i' )) ELSE NULL 
    END  AS 'Grade Creation Time',
     CASE 
        WHEN grade.timemodified != 0 THEN timestamp(DATE_FORMAT(FROM_UNIXTIME(grade.timemodified), '%Y-%m-%d %H:%i' )) ELSE NULL 
    END  AS 'Grade Modified Time',
    CASE 
	    when 0<DATEDIFF(FROM_UNIXTIME(submission.timecreated),FROM_UNIXTIME(assign.duedate))then "Late" else "On Time" 
    end as 'Is Late'
FROM mdl_assign_submission AS submission
JOIN mdl_assign AS assign ON
assign.id = submission.assignment
JOIN mdl_user AS user ON
submission.userid = user.id
JOIN mdl_course AS course ON
course.id = assign.course
LEFT JOIN mdl_assignsubmission_onlinetext AS onlinetext ON
onlinetext.assignment = submission.assignment
AND onlinetext.submission = submission.id
LEFT JOIN mdl_assignsubmission_file AS file ON
file.assignment = submission.assignment
AND file.submission = submission.id
LEFT JOIN mdl_assign_grades AS grade ON
grade.assignment = assign.id
AND grade.userid = user.id
AND grade.attemptnumber = submission.attemptnumber
LEFT JOIN mdl_user AS grader_user ON
grader_user.id = grade.grader

--Assignment Types Usage in Courses
/*-- 88*/
SELECT
	c.id as 'Course Id',
	c.fullname AS "Course",
	c.shortname as 'Course Short Name',
	(
	SELECT
		COUNT(*)
	FROM
		mdl_assign
	WHERE
		c.id = course) AS Assignments,
	(
	SELECT
		COUNT(*)
	FROM
		mdl_assign_plugin_config AS apc
	JOIN mdl_assign AS iassign ON
		iassign.id = apc.assignment
	WHERE
		iassign.course = c.id
		AND apc.plugin = 'file'
		AND apc.subtype = 'assignsubmission'
		AND apc.name = 'enabled'
		AND apc.value = '1'
) AS "File Assignments",
	(
	SELECT
		COUNT(*)
	FROM
		mdl_assign_plugin_config AS apc
	JOIN mdl_assign AS iassign ON
		iassign.id = apc.assignment
	WHERE
		iassign.course = c.id
		AND apc.plugin = 'onlinetext'
		AND apc.subtype = 'assignsubmission'
		AND apc.name = 'enabled'
		AND apc.value = '1'
) AS "Online Assignments",
	(
	SELECT
		COUNT(*)
	FROM
		mdl_assign_plugin_config AS apc
	JOIN mdl_assign AS iassign ON
		iassign.id = apc.assignment
	WHERE
		iassign.course = c.id
		AND apc.plugin = 'pdf'
		AND apc.subtype = 'assignsubmission'
		AND apc.name = 'enabled'
		AND apc.value = '1'
) AS "Pdf Assignments",
	(
	SELECT
		COUNT(*)
	FROM
		mdl_assign_plugin_config AS apc
	JOIN mdl_assign AS iassign ON
		iassign.id = apc.assignment
	WHERE
		iassign.course = c.id
		AND apc.plugin = 'offline'
		AND apc.subtype = 'assignsubmission'
		AND apc.name = 'enabled'
		AND apc.value = '1'
) AS "Offline Assignments",
	(
	SELECT
		COUNT(*)
	FROM
		mdl_assign_plugin_config AS apc
	JOIN mdl_assign AS iassign ON
		iassign.id = apc.assignment
	WHERE
		iassign.course = c.id
		AND apc.plugin = 'comments'
		AND apc.subtype = 'assignsubmission'
		AND apc.name = 'enabled'
		AND apc.value = '1'
) AS "Assignments Comments"
FROM
	mdl_assign AS assign
JOIN mdl_course AS c ON
	c.id = assign.course
GROUP BY
	c.id

    --Badge General
    /*--142*/
SELECT
	b.id as 'Badge Id',
	b.name as 'Badge Name',
	b.description as 'Description',
	CASE
		WHEN b.type = 1 THEN "System"
		WHEN b.type = 2 THEN "Course"
	END AS Context,
	CASE
		WHEN b.courseid IS NOT NULL THEN
(
		SELECT
			c.fullname
		FROM
			mdl_course AS c
		WHERE
			c.id = b.courseid)
		WHEN b.courseid IS NULL THEN "*"
	END AS Course,
	CASE
		WHEN b.status = 0
		OR b.status = 2 THEN "No"
		WHEN b.status = 1
		OR b.status = 3 THEN "Yes"
		WHEN b.status = 4 THEN "x"
	END AS Available,
	CASE
		WHEN b.status = 0
		OR b.status = 1 THEN "0"
		WHEN b.status = 2
		OR b.status = 3
		OR b.status = 4 THEN
 (
		SELECT
			COUNT(*)
		FROM
			mdl_badge_issued AS d
		WHERE
			d.badgeid = b.id
 )
	END AS Earned
FROM
	mdl_badge AS b
    

    --Choice Activity Results Summary
    /*-- 96*/
SELECT
	c.shortname AS 'Course',
	u.username as 'User Name',
	concat(u.firstname, ' ', u.lastname) as 'Name',
	h.name as 'Question',
	o.text AS 'Answer',
	FROM_UNIXTIME(a.timemodified) as 'Modified Time'
FROM
	mdl_choice AS h
JOIN mdl_course AS c ON
	h.course = c.id
JOIN mdl_choice_answers AS a ON
	h.id = a.choiceid
JOIN mdl_user AS u ON
	a.userid = u.id
JOIN mdl_choice_options AS o ON
	a.optionid = o.id

    --Cohorts with Courses
    /*-- 147*/
SELECT
	h.idnumber AS 'Cohort Id',
	h.name AS Cohort,
	CASE
		WHEN h.visible = 1 THEN 'Yes'
		ELSE '-'
	END AS 'Cohort Visible',
	c.fullname AS Course
FROM
	mdl_cohort h
JOIN mdl_enrol e ON
	h.id = e.customint1
JOIN mdl_course c ON
	c.id = e.courseid
WHERE
	e.enrol = 'cohort'

    --Conversation Messages
    /*-- 151*/
SELECT
	cv.id AS "Conversation Id",
	DATE_FORMAT(FROM_UNIXTIME(me.timecreated), '%Y-%m-%d %H:%i') AS "At",
	(
	SELECT
		CONCAT(firstname, ' ', lastname, ' (', username, ')')
	FROM
		mdl_user
	WHERE
		id = me.useridfrom) AS 'From',
	(
	SELECT
		GROUP_CONCAT(DISTINCT CONCAT(u.firstname , ' ', lastname, ' (', username, ')'))
	FROM
		mdl_user u
	JOIN mdl_message_conversation_members cvm ON
		cvm.userid = u.id
	WHERE
		cvm.conversationid = cv.id
		AND u.id != me.useridfrom
	GROUP BY
		cvm.conversationid
	) AS "To",
	IF(me.subject IS NULL,
	"(reply)",
	me.subject) AS "Subject",
	me.fullmessage AS "Message"
FROM
	mdl_messages me
JOIN mdl_message_conversations cv ON
	cv.id = me.conversationid
ORDER BY
	cv.id,
	me.timecreated

    --Course Overview with Instructor, Student Count, and Weekly Edits
    /*-- 172*/
SELECT
	cc.name AS 'Category',
	c.shortname AS 'Course Id',
	c.fullname as 'Course',
	CONCAT(u.firstname , ' ', u.lastname) AS Instructor,
	(
	SELECT
		COUNT(ra2.userid) AS Users2
	FROM
		mdl_role_assignments AS ra2
	JOIN mdl_context AS ctx2 ON
		ra2.contextid = ctx2.id
	WHERE
		ra2.roleid = 5
		AND ctx2.instanceid = c.id) AS Students,
	FROM_UNIXTIME(c.startdate) AS 'Course Start Date',
	c.visible AS Visible,
	COUNT(DISTINCT l.id) AS Edits,
	COUNT(DISTINCT IF((l.timecreated-c.startdate)<0, l.id, NULL)) AS 'Before Term',
	COUNT(DISTINCT IF(FLOOR((l.timecreated - c.startdate)/(60 * 60 * 24 * 7))= 0, l.id, NULL)) AS 'Week 1',
	COUNT(DISTINCT IF(FLOOR((l.timecreated - c.startdate)/(60 * 60 * 24 * 7))= 1, l.id, NULL)) AS 'Week 2',
	COUNT(DISTINCT IF(FLOOR((l.timecreated - c.startdate)/(60 * 60 * 24 * 7))= 2, l.id, NULL)) AS 'Week 3',
	COUNT(DISTINCT IF(FLOOR((l.timecreated - c.startdate)/(60 * 60 * 24 * 7))= 3, l.id, NULL)) AS 'Week 4',
	COUNT(DISTINCT IF(FLOOR((l.timecreated - c.startdate)/(60 * 60 * 24 * 7))= 4, l.id, NULL)) AS 'Week 5',
	COUNT(DISTINCT IF(FLOOR((l.timecreated - c.startdate)/(60 * 60 * 24 * 7))= 5, l.id, NULL)) AS 'Week 6',
	COUNT(DISTINCT IF(FLOOR((l.timecreated - c.startdate)/(60 * 60 * 24 * 7))= 6, l.id, NULL)) AS 'Week 7',
	COUNT(DISTINCT IF(FLOOR((l.timecreated - c.startdate)/(60 * 60 * 24 * 7))= 7, l.id, NULL)) AS 'Week 8',
	COUNT(DISTINCT IF(FLOOR((l.timecreated - c.startdate)/(60 * 60 * 24 * 7))= 8, l.id, NULL)) AS 'Week 9',
	COUNT(DISTINCT IF(FLOOR((l.timecreated - c.startdate)/(60 * 60 * 24 * 7))= 9, l.id, NULL)) AS 'Week 10',
	COUNT(DISTINCT IF(FLOOR((l.timecreated - c.startdate)/(60 * 60 * 24 * 7))= 10, l.id, NULL)) AS 'Week 11',
	COUNT(DISTINCT IF(FLOOR((l.timecreated - c.startdate)/(60 * 60 * 24 * 7))= 11, l.id, NULL)) AS 'Week 12',
	COUNT(DISTINCT IF(FLOOR((l.timecreated - c.startdate)/(60 * 60 * 24 * 7))>= 12, l.id, NULL)) AS 'After Term'
	FROM
	mdl_user AS u
LEFT JOIN mdl_role_assignments AS ra ON
	u.id = ra.userid
LEFT JOIN mdl_context AS ctx ON
	ra.contextid = ctx.id
LEFT JOIN mdl_course AS c ON
	c.id = ctx.instanceid
LEFT JOIN mdl_course_categories as cc ON
	c.category = cc.id
LEFT JOIN mdl_logstore_standard_log AS l ON
	l.userid = u.id
	AND l.courseid = c.id
	AND l.crud IN ('c', 'u')
WHERE
	ra.roleid = 3
	AND ctx.instanceid = c.id
GROUP BY
	u.idnumber,
	c.id
ORDER BY
	RIGHT(c.shortname,
	2),
	c.shortname

    --Courses Group Mode Settings
    /*-- 58, -- 59*/
SELECT 
	c.fullname as 'Course',
	CASE
		c.groupmode
		WHEN 0 THEN "No groups"
		WHEN 1 THEN "Separate groups"
		WHEN 2 THEN "Visible groups"
		ELSE "This should not happen!"
	END AS "Group mode",
	IF(c.groupmodeforce = 0, "Not forced", "Forced") AS "Group mode forced",
	(SELECT count(*) FROM mdl_course_modules cm WHERE cm.course = c.id) Modules,
	(SELECT count(*) FROM mdl_groups g WHERE g.courseid = c.id) Groups
 FROM mdl_course AS c

 --Courses with Extra Credit Items
 /*-- 83*/
SELECT
	c.id as 'Course Id',
	c.fullname as 'Course',
	c.shortname as 'Course Short Name',
	gi.itemname AS 'Item Name',
	(
	SELECT
		COUNT(ra.userid)
	FROM
		mdl_role_assignments AS ra
	JOIN mdl_context AS ctx ON
		ra.contextid = ctx.id
	WHERE
		ra.roleid = 5
		AND ctx.instanceid = c.id) AS 'Students',
	(
	SELECT
		COUNT(ra.userid)
	FROM
		mdl_role_assignments AS ra
	JOIN mdl_context AS ctx ON
		ra.contextid = ctx.id
	WHERE
		ra.roleid = 3
		AND ctx.instanceid = c.id) AS 'Instructors',
	(
	SELECT
		DISTINCT u.email
	FROM
		mdl_role_assignments AS ra
	JOIN mdl_user AS u ON
		ra.userid = u.id
	JOIN mdl_context AS ctx ON
		ctx.id = ra.contextid
	WHERE
		ra.roleid = 3
		AND ctx.instanceid = c.id
		AND ctx.contextlevel = 50
	LIMIT 1) AS 'Instructor Email',
	DATE(FROM_UNIXTIME(c.startdate)) AS 'Course Start Date',
	now() AS 'Report Timestamp'
FROM
	mdl_grade_items AS gi
JOIN mdl_course AS c ON
	gi.courseid = c.id
WHERE
	gi.itemname LIKE '%extra credit%'
	AND gi.gradetype = '1'
	AND gi.hidden = '0'
	AND gi.aggregationcoef = '0'
	AND c.visible = 1
	AND (
	SELECT
		COUNT(ra.userid)
	FROM
		mdl_role_assignments AS ra
	JOIN mdl_context AS ctx ON
		ra.contextid = ctx.id
	WHERE
		ra.roleid = 5
		AND ctx.instanceid = c.id) > 0
GROUP BY
	'Course Id',
	gi.id
ORDER BY
	'Course Start Date',
	'Course Id'


--Daily Unique User Hits Report for the Last 7 Days
/*-- 182*/
SELECT
	DATE_FORMAT(FROM_UNIXTIME(l.timecreated), '%d-%m-%y') 'Date',
	COUNT(DISTINCT l.userid) AS 'Distinct Users Hits',
	COUNT(l.userid) AS 'Users Hits'
FROM
	mdl_logstore_standard_log AS l
WHERE
	l.courseid > 1
	AND FROM_UNIXTIME(l.timecreated) >= DATE_SUB(NOW(), INTERVAL 7 DAY)
GROUP BY
	DAY(FROM_UNIXTIME(timecreated))

    --Data Record Content Details
select
md.id as 'DataId',
md.course as 'CourseId',
mc.fullname as 'Course',
md.name as 'Data Module Name',
mu.username as 'User Name',
CONCAT(
    COALESCE(mdc.content, ''),
    COALESCE(mdc.content1, ''),
    COALESCE(mdc.content2, ''),
    COALESCE(mdc.content3, ''),
    COALESCE(mdc.content4, '')
) AS "Content",
mdr.approved as 'Approved',
mdf.`type` as 'Content Type',
mdf.name as 'Content Name',
mdf.required as 'Required',
 IF(md.timeavailablefrom = 0, NULL, FROM_UNIXTIME(md.timeavailablefrom)) AS "Time Available From",
 IF(md.timeavailableto = 0, NULL, FROM_UNIXTIME(md.timeavailableto)) AS "Time Available To",
 IF(md.timeviewfrom = 0, NULL, FROM_UNIXTIME(md.timeviewfrom)) AS "Time View From",
 IF(md.timeviewto = 0, NULL, FROM_UNIXTIME(md.timeviewto)) AS "Time View To",
 IF(mdr.timecreated = 0, NULL, FROM_UNIXTIME(mdr.timecreated)) AS "Created Time",
 IF(mdr.timemodified = 0, NULL, FROM_UNIXTIME(mdr.timemodified)) AS "Modified Time"
from  mdl_data_content mdc
JOIN mdl_data_records mdr  on mdc.recordid = mdr.id 
JOIN mdl_data md on md.id = mdr.dataid 
left JOIN mdl_data_fields mdf on mdf.dataid = md.id and mdc.fieldid = mdf.id 
JOIN mdl_user mu on mu.id = mdr.userid 
JOIN mdl_course mc on mc.id = md.course

--Detailed Report of Lesson Questions with Student Answers and Grades
/*-- 112*/
SELECT
	c.id as 'Course Id',
	c.fullname AS "Course",
	c.shortname as 'Course Short Name',
	l.name AS "Lesson Name",
	p.title AS "Page Title",
	p.contents AS "Question",
	a.grade as 'Grade',
	a.score as 'Score',
	a.answer as 'Answer',
	a.response as 'Response'
FROM
	mdl_lesson_answers a
JOIN mdl_lesson l ON
	l.id = a.lessonid
JOIN mdl_lesson_pages p ON
	p.id = a.pageid
	AND p.lessonid = l.id
JOIN mdl_course c ON
	c.id = l.course
JOIN mdl_course_modules cm ON
	cm.instance = l.id
JOIN mdl_modules m ON
	m.id = cm.module
WHERE
	m.name = 'lesson'

--Detailed Scale Information
/* --150*/
SELECT
	s.id AS 'Scale Id',
	s.name AS 'Scale Name',
	s.scale AS 'Scale',
	CASE
		WHEN s.courseid = 0 THEN 'System'
		ELSE (
		SELECT
			shortname
		FROM
			mdl_course
		WHERE
			id = s.courseid)
	END AS 'Context',
	CASE
		WHEN s.userid = 0 THEN 'System'
		ELSE (
		SELECT
			username
		FROM
			mdl_user
		WHERE
			id = s.userid)
	END AS 'Created User',
	s.description as 'Description',
	FROM_UNIXTIME(s.timemodified) AS 'Modified Date'
FROM
	mdl_scale s

    --Enrolment Methods Used in All Courses
    /*-- 56*/
SELECT
	c.fullname AS "Course",
	e.enrol AS "Method",
	CASE
		e.status 
   WHEN 0 THEN 'Enabled'
		WHEN 1 THEN '-'
		ELSE e.status
	END AS "Status",
	IF(e.name IS NOT NULL,
	e.name,
	'-') AS "Custom name"
FROM
	mdl_enrol e
JOIN mdl_course c ON
	c.id = e.courseid
ORDER BY
	c.fullname,
	e.sortorder

    --Forum Activity and Participation Analysis in Courses
    /*--104*/
SELECT
	c.fullname as 'Course',
	f.name as 'Name',
	f.type as 'Type',
	FROM_UNIXTIME(f.duedate) as 'Due date',
	FROM_UNIXTIME(f.cutoffdate) as 'Cutoff Date',
	FROM_UNIXTIME(f.assesstimestart) as 'Assess Time Start',
	FROM_UNIXTIME(f.assesstimefinish) as 'Assess Time Finish',
	(
	SELECT
		count(id)
	FROM
		mdl_forum_discussions as fd
	WHERE
		f.id = fd.forum) as Discussions,
	(
	SELECT
		count(distinct fd.userid)
	FROM
		mdl_forum_discussions as fd
	WHERE
		fd.forum = f.id) as UniqueUsersDiscussions,
	(
	SELECT
		count(fp.id)
	FROM
		mdl_forum_discussions fd
	JOIN mdl_forum_posts as fp ON
		fd.id = fp.discussion
	WHERE
		f.id = fd.forum) as Posts,
	(
	SELECT
		count(distinct fp.userid)
	FROM
		mdl_forum_discussions fd
	JOIN mdl_forum_posts as fp ON
		fd.id = fp.discussion
	WHERE
		f.id = fd.forum) as UniqueUsersPosts,
	(
	SELECT
		Count(ra.userid) AS Students
	FROM
		mdl_role_assignments AS ra
	JOIN mdl_context AS ctx ON
		ra.contextid = ctx.id
	WHERE
		ra.roleid = 5
		AND ctx.instanceid = c.id) AS StudentsCount,
	(
	SELECT
		Count(ra.userid) AS Teachers
	FROM
		mdl_role_assignments AS ra
	JOIN mdl_context AS ctx ON
		ra.contextid = ctx.id
	WHERE
		ra.roleid = 3
		AND ctx.instanceid = c.id) AS 'Teacher Count',
	(
	SELECT
		Count(ra.userid) AS Users
	FROM
		mdl_role_assignments AS ra
	JOIN mdl_context AS ctx ON
		ra.contextid = ctx.id
	WHERE
		ra.roleid IN (3, 5)
			AND ctx.instanceid = c.id) AS UserCount,
	(
	SELECT
		(UniqueUsersDiscussions / StudentsCount ) ) as StudentDissUsage,
	(
	SELECT
		(UniqueUsersPosts / StudentsCount)) as StudentPostUsage
FROM
	mdl_forum as f
JOIN mdl_course as c ON
	f.course = c.id
ORDER BY
	StudentPostUsage DESC

    --Forum Usage Count per Course by Type
    /*-- 101 -- 102*/
SELECT 
	mdl_forum.course AS 'Course Id',
	mdl_course.fullname AS 'Course',
	mdl_course.shortname as 'Course Short Name',
	mdl_forum.type AS 'Forum Type',
	COUNT(*) AS 'Total'
FROM
	mdl_forum
INNER JOIN 
    mdl_course ON
	mdl_course.id = mdl_forum.course
GROUP BY
	mdl_course.fullname,
	mdl_forum.course,
	mdl_forum.type
ORDER BY
	'Total' DESC;

    --Glossary Activity Report
    /*-- 111*/
SELECT
	c.shortname AS "Course",
	g.name AS "Glossary",
	CASE 
		when g.globalglossary =1 then "global glossary" else "cource glosasry"
	END as 'Is Global',
	CASE 
		when ge.teacherentry =1 then "teachers entery" else "others enterys"
	END as 'Entry By',
	u.username as 'User Name',
	concat(u.firstname, ' ', u.lastname) as 'Name',
	ge.concept AS "Concept",
	ge.definition AS "Definition",
	IF(ge.approved = 1, 'Yes', 'No') AS "Approved",
	DATE_FORMAT(FROM_UNIXTIME(ge.timecreated), '%Y-%m-%d %H:%i' ) AS "Created Date",
	DATE_FORMAT(FROM_UNIXTIME(ge.timemodified), '%Y-%m-%d %H:%i' ) AS "Modified Date"
FROM
	mdl_glossary_entries ge
JOIN mdl_glossary g ON
	g.id = ge.glossaryid
JOIN mdl_user u ON
	u.id = ge.userid
JOIN mdl_course c ON
	c.id = g.course

    --Grade Types
    SELECT
	mc2.id as 'CourseId',
	mc2.fullname as 'Course',
	mga.component as 'Component',
	mga.areaname as 'Area Name',
	mga.activemethod as 'ActiveMethod',
	mgi.gradetype as 'Grade Type',
	mcm.module as 'ModuleId',
	mcm.instance as 'Instance',
	CASE
		WHEN mcm.module = 1 THEN "quiz"
		WHEN mcm.module = 6 THEN "assign"
		WHEN mcm.module = 9 THEN "forum"
		WHEN mcm.module = 10 THEN "data"
		WHEN mcm.module = 11 THEN "game"
		WHEN mcm.module = 14 THEN "glossary"
		WHEN mcm.module = 15 THEN "h5pactivity"
		WHEN mcm.module = 17 THEN "hvp"
		WHEN mcm.module = 19 THEN "lesson"
		WHEN mcm.module = 23 THEN "lti"
		WHEN mcm.module = 24 THEN "scorm"
		WHEN mcm.module = 26 THEN "workshop"
		ELSE NULL
	END AS 'Module Type',
	CASE
		WHEN mcm.module = 1 THEN ma.name
		WHEN mcm.module = 6 THEN md.name
		WHEN mcm.module = 9 THEN mf.name
		WHEN mcm.module = 10 THEN mg.name
		WHEN mcm.module = 11 THEN mh.name
		WHEN mcm.module = 14 THEN ml2.name
		WHEN mcm.module = 15 THEN ml3.name
		WHEN mcm.module = 17 THEN mq.name
		WHEN mcm.module = 19 THEN ms.name
		WHEN mcm.module = 23 THEN mw2.name
		WHEN mcm.module = 24 THEN mg2.name
		WHEN mcm.module = 26 THEN mh2.name
		ELSE NULL
	END AS 'Module Name',
	mgi.itemtype as 'Item Type'
FROM
	mdl_grading_areas mga
JOIN mdl_context mc ON
	mc.id = mga.contextid
JOIN mdl_course_modules mcm ON
	mcm.id = mc.instanceid
JOIN mdl_course mc2 on
	mc2.id = mcm.course
left JOIN mdl_grade_items mgi on
	mgi.iteminstance = mcm.instance
LEFT JOIN mdl_assign ma ON
	(mcm.module = 1
		AND ma.id = mcm.instance)
LEFT JOIN mdl_data md ON
	(mcm.module = 6
		AND md.id = mcm.instance)
LEFT JOIN mdl_forum mf ON
	(mcm.module = 9
		AND mf.id = mcm.instance)
LEFT JOIN mdl_glossary mg ON
	(mcm.module = 10
		AND mg.id = mcm.instance)
LEFT JOIN mdl_h5pactivity mh ON
	(mcm.module = 11
		AND mh.id = mcm.instance)
LEFT JOIN mdl_lesson ml2 ON
	(mcm.module = 14
		AND ml2.id = mcm.instance)
LEFT JOIN mdl_lti ml3 ON
	(mcm.module = 15
		AND ml3.id = mcm.instance)
LEFT JOIN mdl_quiz mq ON
	(mcm.module = 17
		AND mq.id = mcm.instance)
LEFT JOIN mdl_scorm ms ON
	(mcm.module = 19
		AND ms.id = mcm.instance)
LEFT JOIN mdl_workshop mw2 ON
	(mcm.module = 23
		AND mw2.id = mcm.instance)
LEFT JOIN mdl_game mg2 ON
	(mcm.module = 24
		AND mg2.id = mcm.instance)
LEFT JOIN mdl_hvp mh2 ON
	(mcm.module = 26
		AND mh2.id = mcm.instance)
GROUP by
	mga.component ,
	mga.areaname ,
	mga.activemethod ,
	mcm.module ,
	mcm.instance ,
	'Module Name',
	mc2.fullname

    --Graded Activities Overview for Courses
/*-- 70*/
SELECT
	c.id as 'Course Id',
	c.fullname as 'Course',
	gi.itemmodule AS 'Activity Type',
	cs.section AS 'Section Number',
	CONCAT(DATE_FORMAT(FROM_UNIXTIME(c.startdate + (7 * 24 * 60 * 60 * (cs.section-1))), '%b %e, %Y'), ' - ', DATE_FORMAT(FROM_UNIXTIME(c.startdate + (7 * 24 * 60 * 60 * (cs.section))), '%b %e, %Y')) AS 'Date',
	gi.itemname AS 'Activity Name',
	(
	SELECT
		asg.intro
	FROM
		mdl_assign AS asg
	WHERE
		asg.id = cm.instance) AS 'Intro',
	(
	SELECT
		f.intro
	FROM
		mdl_forum AS f
	WHERE
		f.id = cm.instance) AS 'Forum intro',
	CASE
		gi.itemmodule
	WHEN 'assign' THEN (
		SELECT
			asg.intro
		FROM
			mdl_assign AS asg
		WHERE
			asg.id = gi.iteminstance)
		WHEN 'forum' THEN (
		SELECT
			f.intro
		FROM
			mdl_forum AS f
		WHERE
			f.id = gi.iteminstance)
		WHEN 'quiz' THEN (
		SELECT
			q.intro
		FROM
			mdl_quiz AS q
		WHERE
			q.id = gi.iteminstance)
	END AS 'Test Case'
FROM
	mdl_course AS c
LEFT JOIN mdl_course_sections AS cs ON
	cs.course = c.id
	AND cs.section > 0
	AND cs.section <= 14
LEFT JOIN mdl_course_modules AS cm ON
	cm.course = c.id
	AND cm.section = cs.id
JOIN mdl_grade_items AS gi ON
	gi.iteminstance = cm.instance
	AND gi.gradetype = 1
	AND gi.hidden != 1
	AND gi.courseid = c.id
	AND cm.course = c.id
	AND cm.section = cs.id
ORDER BY
	c.id,
	cs.section,
	FROM_UNIXTIME(c.startdate) asc

    --Grading Components and Module Information Report
    SELECT
	mga.id as 'Component Id',
	mga.component as 'Component',
	mga.areaname as 'Area Name',
	mga.activemethod as 'Active Method',
	mcm.module as 'Module',
	mcm.`instance` as 'Instance',
	CASE
		WHEN mcm.module = 1 THEN ma.name
		WHEN mcm.module = 1 THEN ma.course
		WHEN mcm.module = 9 THEN mf.name
		WHEN mcm.module = 9 THEN mf.course
		ELSE NULL
	END AS 'Module Name',
	CASE
		WHEN mcm.module = 1 THEN ma.course
		WHEN mcm.module = 9 THEN mf.course
		ELSE NULL
	END AS 'Module Course',
	CASE
		WHEN mcm.module = 1 THEN mgi.gradetype
		ELSE NULL
	END AS 'Grade Type',
	mc2.id as 'Course Id',
	mc2.fullname as 'Course'
FROM
	mdl_grading_areas mga
JOIN mdl_context mc ON
	mc.id = mga.contextid
JOIN mdl_course_modules mcm ON
	mcm.id = mc.instanceid
JOIN mdl_course mc2 on
	mc2.id = mcm.course
LEFT JOIN mdl_assign ma ON
	(mcm.module = 1
		AND ma.id = mcm.`instance`)
LEFT JOIN mdl_forum mf ON
	(mcm.module = 9
		AND mf.id = mcm.`instance`)
left JOIN mdl_grade_items mgi on
	mgi.iteminstance = mcm.instance
GROUP by
	mga.component ,
	mga.areaname ,
	mga.activemethod,
	mcm.module ,
	mcm.`Instance`,
	'Module Name',
	'Module Course',
	mc2.fullname

    --H5P Activity Attempt Details
    select
mu.username as 'User Name',
mc.fullname as 'Course',
mhpar.interactiontype  as 'H5P Activity Type',
mhp.name as 'H5P Activity Name',
mhp.grade as 'Grade',
CASE mhp.grademethod
      WHEN 1 THEN "GRADEHIGHEST"
      WHEN 2 THEN "GRADEAVERAGE"
      WHEN 3 THEN "ATTEMPTFIRST"
      WHEN 4 THEN "ATTEMPTLAST"
END as "Grade Method",
mhp.reviewmode as 'Review Mode',
date(DATE_FORMAT(FROM_UNIXTIME(mhpa.timecreated), '%Y-%m-%d %H:%i' )) as 'Created Time' ,
date(DATE_FORMAT(FROM_UNIXTIME(mhpa.timemodified), '%Y-%m-%d %H:%i' )) as 'Modified Time',
mhpa.attempt as 'Attempt',
mhpa.rawscore as 'Raw Score',
mhpa.maxscore as 'Max Score',
mhpa.rawscore/mhpa.maxscore*100 as 'Correct Percentage',
mhpa.completion as 'Completion',
mhpa.success as 'Success',
(sec_to_time(mhpar.duration) as 'Duration'
FROM mdl_h5pactivity_attempts_results mhpar
JOIN mdl_h5pactivity_attempts mhpa on mhpa.id =mhpar.attemptid 
JOIN mdl_h5pactivity mhp on mhp.id =mhpa.h5pactivityid 
JOIN mdl_course mc on mc.id = mhp.course
JOIN mdl_user mu on mu.id = mhpa.userid

--Instructor Course Activity Report with Weekly Edit Breakdown
/*-- 173*/
SELECT
	concat(u.firstname, ' ', u.lastname) as 'Name',
	c.fullname as 'Course',
	COUNT(l.id) AS 'Edits',
	COUNT(DISTINCT IF((l.timecreated-c.startdate)<0, l.id, NULL)) AS 'Before Term',
	COUNT(DISTINCT IF(FLOOR((l.timecreated - c.startdate)/(60 * 60 * 24 * 7))= 0, l.id, NULL)) AS 'Week 1',
	COUNT(DISTINCT IF(FLOOR((l.timecreated - c.startdate)/(60 * 60 * 24 * 7))= 1, l.id, NULL)) AS 'Week 2',
	COUNT(DISTINCT IF(FLOOR((l.timecreated - c.startdate)/(60 * 60 * 24 * 7))= 2, l.id, NULL)) AS 'Week 3',
	COUNT(DISTINCT IF(FLOOR((l.timecreated - c.startdate)/(60 * 60 * 24 * 7))= 3, l.id, NULL)) AS 'Week 4',
	COUNT(DISTINCT IF(FLOOR((l.timecreated - c.startdate)/(60 * 60 * 24 * 7))= 4, l.id, NULL)) AS 'Week 5',
	COUNT(DISTINCT IF(FLOOR((l.timecreated - c.startdate)/(60 * 60 * 24 * 7))= 5, l.id, NULL)) AS 'Week 6',
	COUNT(DISTINCT IF(FLOOR((l.timecreated - c.startdate)/(60 * 60 * 24 * 7))= 6, l.id, NULL)) AS 'Week 7',
	COUNT(DISTINCT IF(FLOOR((l.timecreated - c.startdate)/(60 * 60 * 24 * 7))= 7, l.id, NULL)) AS 'Week 8',
	COUNT(DISTINCT IF(FLOOR((l.timecreated - c.startdate)/(60 * 60 * 24 * 7))= 8, l.id, NULL)) AS 'Week 9',
	COUNT(DISTINCT IF(FLOOR((l.timecreated - c.startdate)/(60 * 60 * 24 * 7))= 9, l.id, NULL)) AS 'Week 10',
	COUNT(DISTINCT IF(FLOOR((l.timecreated - c.startdate)/(60 * 60 * 24 * 7))= 10, l.id, NULL)) AS 'Week 11',
	COUNT(DISTINCT IF(FLOOR((l.timecreated - c.startdate)/(60 * 60 * 24 * 7))= 11, l.id, NULL)) AS 'Week 12',
	COUNT(DISTINCT IF(FLOOR((l.timecreated - c.startdate)/(60 * 60 * 24 * 7))>= 12, l.id, NULL)) AS 'After Term'
FROM
	mdl_user AS u
JOIN mdl_role_assignments AS ra ON
	u.id = ra.userid
JOIN mdl_context AS ctx ON
	ra.contextid = ctx.id
JOIN mdl_course AS c ON
	c.id = ctx.instanceid
JOIN mdl_course_categories as cc ON
	c.category = cc.id
LEFT JOIN mdl_logstore_standard_log AS l ON
	l.userid = u.id
	AND l.courseid = c.id
	AND l.crud IN ('c', 'u')
WHERE
	 ctx.instanceid = c.id
GROUP BY
	u.idnumber,
	c.fullname
ORDER BY
	concat(u.firstname, ' ', u.lastname)

    --Lesson Grades and User Completion Report
    select
	mc.id as 'Course Id',
	mc.fullname as 'Course',
	ml.name as 'Lesson Name',
	mu.username as 'User Name',
	concat(mu.firstname, ' ', mu.lastname) as 'User',
	mlg.grade as 'Grade',
	FROM_UNIXTIME(mlg.completed) as 'Completed Date'
from
	mdl_lesson_grades mlg
JOIN mdl_lesson ml on
	ml.id = mlg.lessonid
JOIN mdl_course mc on
	mc.id = ml.course
JOIN mdl_user mu on
	mu.id = mlg.userid

    --Lesson Progress and Timing Report
    SELECT
	mu.id as 'User Id',
	mu.username as 'User Name',
	mc.id as 'Course Id',
	mc.fullname AS 'Course',
	mlt.completed as 'Completed',
	ml.name as 'Lesson',
	ml.modattempts as 'Mod Attempts',
	ml.grade AS 'Max Grade',
	ml.maxanswers as 'Max Answers',
	ml.maxattempts as 'Max Attempts',
	ml.maxpages as 'Max Pages',
	ml.completionendreached as 'Completion End Reached',
	mc.format as 'Format',
	CASE
		WHEN ml.timelimit != 0 THEN DATE_FORMAT(FROM_UNIXTIME(ml.timelimit), '%H:%i:%s')
		ELSE NULL
	END AS 'Tİme Limit',
	CASE
		WHEN mlt.starttime != 0 THEN DATE_FORMAT(FROM_UNIXTIME(mlt.starttime), '%Y-%m-%d %H:%i')
		ELSE NULL
	END AS 'Start Time',
	CASE
		WHEN mlt.lessontime != 0 THEN DATE_FORMAT(FROM_UNIXTIME(mlt.lessontime), '%Y-%m-%d %H:%i')
		ELSE NULL
	END AS 'Lesson Time',
	CASE
		WHEN ml.available != 0 THEN DATE_FORMAT(FROM_UNIXTIME(ml.available), '%Y-%m-%d %H:%i')
		ELSE NULL
	END AS 'Available',
	CASE
		WHEN ml.deadline != 0 THEN DATE_FORMAT(FROM_UNIXTIME(ml.deadline), '%Y-%m-%d %H:%i')
		ELSE NULL
	END AS 'Deadline',
	CASE
		WHEN ml.completiontimespent != 0 THEN DATE_FORMAT(FROM_UNIXTIME(ml.completiontimespent), '%H:%i:%s')
		ELSE NULL
	END AS 'Completion Time Spent'
FROM
	mdl_lesson_timer mlt
JOIN mdl_lesson ml ON
	ml.id = mlt.lessonid
JOIN mdl_user mu ON
	mu.id = mlt.userid
JOIN mdl_course mc ON
	mc.id = ml.course

    --List of All Courses with Custom Outcomes
    /* --42*/
SELECT
	mgo.courseid as 'Course Id',
	mcc.fullname as 'Course',
	mgo.fullname as 'Item Name',
	mgo.usermodified as 'User Id',
	mu.username as 'User Name',
	concat(mu.firstname, ' ', mu.lastname) as 'Name',
	FROM_UNIXTIME(mgo.timemodified) as 'Date'
FROM
	mdl_grade_outcomes mgo
JOIN mdl_course mcc on
	mcc.id = mgo.courseid
JOIN mdl_user mu on
	mu.id = mgo.usermodified
WHERE
	1 = 1

    --List of All Posts in Discussions
    /*--110*/
SELECT
	f.id as 'Forum Id',
	f.name AS 'Forum Name',
	mc.id as 'Course Id',
	mc.fullname as 'Course',
	fd.name AS 'Discussion',
	concat(mu.firstname, ' ', mu.lastname) as 'Name',
	fp.message as 'Message',
	FROM_UNIXTIME(fd.timemodified) as 'Date'
FROM
	mdl_forum_posts AS fp
JOIN mdl_forum_discussions AS fd ON
	fd.id = fp.discussion
JOIN mdl_forum AS f ON
	f.id = fd.forum
JOIN mdl_course_modules AS cm ON
	cm.instance = f.id
JOIN mdl_course mc on
	mc.id = fd.course
JOIN mdl_user mu on
	mu.id = fd.userid
GROUP BY
	f.id,
	mc.id,
	mu.id,
	fp.message,
	FROM_UNIXTIME(fd.timemodified)

    --List of Chat Activities with Course Details
    select
	ch.course as 'Course Id',
	c.fullname as 'Course',
	ch.id as 'Chat Id',
	FROM_UNIXTIME(ch.chattime) as 'Date'
FROM
	mdl_chat ch
INNER JOIN mdl_course c ON
	c.id = ch.course
ORDER BY
	ch.chattime,
	c.fullname

    --List of Courses with All Grade Types in Moodle
    /*--118*/
SELECT
	c.fullname AS Course,
	gi.itemtype,
	COUNT(*)
FROM
	mdl_grade_items AS gi
JOIN mdl_course as c ON
	c.id = gi.courseid
GROUP BY
	gi.courseid,
	gi.itemtype

    --List of Courses with Uploaded Syllabus and First Teacher by Category
    /* --43*/
SELECT
	mcc.name as 'Category',
	c.fullname as 'Course',
	r.name as 'Resource' ,
	(
	SELECT
		CONCAT(u.firstname, ' ', u.lastname) as Teacher
	FROM
		mdl_role_assignments AS ra
	JOIN mdl_context AS ctx ON
		ra.contextid = ctx.id
	JOIN mdl_user as u ON
		u.id = ra.userid
	WHERE
		ra.roleid = 3
		AND ctx.instanceid = c.id
	LIMIT 1) as Teacher
FROM
	mdl_resource as r
JOIN mdl_course as c ON
	r.course = c.id
	AND c.category IN (1, 2, 3)
JOIN mdl_course_categories mcc on
	c.category = mcc.id

    --List of Participants for a Specific Chat Activity
    SELECT
	c.id AS 'Course Id',
	chu.chatid as 'Chat Id',
	chu.userid AS 'User Id',
	c.fullname as 'Course',
	u.username as 'User Name',
	concat(u.firstname, ' ', u.lastname) as 'Name',
	u.email as 'EMail'
FROM
	mdl_user u
LEFT JOIN mdl_chat_users chu ON
	chu.userid = u.id
INNER JOIN mdl_course c ON
	c.id = chu.course
WHERE
	1 = 1
ORDER BY
	c.fullname

    --List of Questions for Each Quiz in Course
    /*--121*/
SELECT
	cm.course 'Course Id',
	cm.id 'Course Module Id',
	quiz.id 'Quiz Id',
	quiz.name 'Quiz Name',
	qc.id 'Question Category Id',
	qc.name 'Question Category',
	q.name 'Question',
	q.questiontext 'Question Text',
	FROM_UNIXTIME(q.timecreated) 'Created Time',
	FROM_UNIXTIME(q.timemodified) 'Updated Time'
FROM
	mdl_question_references qr
JOIN mdl_context context ON
	context.id = qr.usingcontextid
JOIN mdl_course_modules cm
     ON
	context.instanceid = cm.id
	AND context.contextlevel = 70
	AND cm.module = (
	SELECT
		id
	FROM
		mdl_modules
	WHERE
		name = 'quiz')
JOIN mdl_quiz quiz ON
	quiz.id = cm.instance
JOIN mdl_question_bank_entries qbe ON
	qbe.id = qr.questionbankentryid
JOIN mdl_question_versions qv ON
	qv.questionbankentryid = qbe.id
	AND qv.version = 1
JOIN mdl_question q ON
	q.id = qv.questionid
JOIN mdl_question_categories qc ON
	qc.id = qbe.questioncategoryid

    --List of Teachers and Their Courses
    SELECT
	c.id as 'Id',
	cc.name 'Category',
	c.fullname as 'Course',
	c.shortname as 'Short Name',
	u.id as 'Prof Id',
	u.username as 'User Name',
	concat(u.firstname, ' ', u.lastname) as 'Name',
	r.shortname as 'Role'
From
	mdl_user as u
join mdl_user_enrolments ue on
	ue.userid = u.id
join mdl_enrol en on
	ue.enrolid = en.id
join mdl_role_assignments ra on
	u.id = ra.userid
join mdl_role r on
	ra.roleid = r.id
	and (r.shortname = 'editingteacher'
		or r.shortname = 'teacher')
join mdl_context cx on
	cx.id = ra.contextid
	and cx.contextlevel = 50
JOIN mdl_course c ON
	c.id = cx.instanceid
	AND en.courseid = c.id
JOIN mdl_course_categories cc ON
	c.category = cc.id

    --List of Users and Their Courses
    SELECT
	c.id as 'Id',
	cc.name 'Category',
	c.fullname as 'Course',
	c.shortname as 'Short Name',
	u.id as 'UserId',
	u.username as 'User Name',
	concat(u.firstname, ' ', u.lastname) as 'Name',
	case
		when ra.roleid = 1 then 'Manager'
		when ra.roleid = 2 then 'Course Creator'
		when ra.roleid = 3 then 'Editing Teacher'
		when ra.roleid = 4 then 'Teacher'
		when ra.roleid = 5 then 'Student'
		when ra.roleid = 6 then 'Guest'
		when ra.roleid = 7 then 'User'
		when ra.roleid = 8 then 'Front Page'
		else ra.roleid
	end as "Role"
From
	mdl_user as u
join mdl_user_enrolments ue on
	ue.userid = u.id
join mdl_enrol en on
	ue.enrolid = en.id
join mdl_role_assignments ra on
	u.id = ra.userid
join mdl_context cx on
	cx.id = ra.contextid
	and cx.contextlevel = 50
JOIN mdl_course c ON
	c.id = cx.instanceid
	AND en.courseid = c.id
JOIN mdl_course_categories cc ON
	c.category = cc.id

    --List of Users and Their Private Files in Moodle
    select
	u.id as 'User Id',
	concat(u.firstname, ' ', u.lastname) as 'User',
	u.username as 'User Name',
	FROM_UNIXTIME(u.lastlogin) AS 'Last Login',
	case 
		when u.suspended = 0 then '1'
		else u.suspended
	end as 'Active User',
	f.filename as 'File Name',
	CONCAT('/', LEFT(f.contenthash, 2), '/', MID(f.contenthash, 3, 2), '/', f.contenthash) AS "File Directory Location",
	f.filesize as 'File Size',
	FROM_UNIXTIME(f.timecreated) as 'Created'
from
	mdl_files AS f
JOIN mdl_user AS u ON
	u.id = f.userid
where
	filearea = "private"
	AND f.filename != "."

    --Module Outcomes Report
    select 
	mgi.iteminstance as 'Item Instance Id',
	mgi.itemmodule as 'Item Module',
	mc.fullname as 'Course',
	case 
		when mgi.itemmodule = "quiz" 		then mq.name 
		when mgi.itemmodule = "assign" 		then ma.name 
		when mgi.itemmodule = "forum" 		then mf.name 
		when mgi.itemmodule = "data" 		then md.name 
		when mgi.itemmodule = "game" 		then mg.name 
		when mgi.itemmodule = "glossary" 	then mg2.name
		when mgi.itemmodule = "h5pactivity" then mhp.name
		when mgi.itemmodule = "hvp" 		then mh.name 
		when mgi.itemmodule = "lesson" 		then ml.name 
		when mgi.itemmodule = "lti" 		then ml2.name
		when mgi.itemmodule = "scorm" 		then ms.name 
		when mgi.itemmodule = "workshop" 	then mw.name 
	else mgi.itemmodule
	end as 'Instance Name',
	mgo.fullname as 'Outcame' ,
	FROM_UNIXTIME(mgi.timecreated) as 'Created Time' ,
	FROM_UNIXTIME(mgi.timemodified) as 'Modified Time'
FROM mdl_grade_items mgi  
JOIN mdl_course mc on mc.id = mgi.courseid 
left JOIN mdl_grade_outcomes mgo on mgo.id = mgi.outcomeid 
LEFT JOIN mdl_quiz mq ON mgi.itemmodule 		= "quiz" 		 AND mgi.iteminstance = mq.id  
LEFT JOIN mdl_assign ma ON mgi.itemmodule 		= "assign" 		 AND mgi.iteminstance = ma.id  
LEFT JOIN mdl_forum mf ON mgi.itemmodule    	= "forum" 		 AND mgi.iteminstance = mf.id  
LEFT JOIN mdl_data md  ON mgi.itemmodule    	= "data" 		 AND mgi.iteminstance = md.id  
LEFT JOIN mdl_game mg ON mgi.itemmodule    		= "game" 		 AND mgi.iteminstance = mg.id  
LEFT JOIN mdl_glossary mg2 ON mgi.itemmodule    = "glossary" 	 AND mgi.iteminstance = mg2.id 
LEFT JOIN mdl_h5pactivity mhp ON mgi.itemmodule = "h5pactivity"  AND mgi.iteminstance = mhp.id 
LEFT JOIN mdl_hvp mh ON mgi.itemmodule    		= "hvp" 		 AND mgi.iteminstance = mh.id  
LEFT JOIN mdl_lesson ml ON mgi.itemmodule    	= "lesson" 		 AND mgi.iteminstance = ml.id  
LEFT JOIN mdl_lti ml2 ON mgi.itemmodule    		= "lti" 		 AND mgi.iteminstance = ml2.id 
LEFT JOIN mdl_scorm ms  ON mgi.itemmodule   	= "scorm" 		 AND mgi.iteminstance = ms.id  
LEFT JOIN mdl_workshop mw ON mgi.itemmodule    	= "workshop" 	 AND mgi.iteminstance = mw.id  
WHERE not ISNULL( mgi.outcomeid )

--Number of Forum Posts by Instructors per Course
/*-- 108*/
SELECT
	c.id as 'Course Id',
	c.fullname as 'Course',
	c.shortname AS 'Course Short Name',
	CONCAT(u.firstname , ' ', u.lastname) AS 'Instructors',
	(
	SELECT
		COUNT(m.name) AS COUNT
	FROM
		mdl_course_modules AS cm
	JOIN mdl_modules AS m ON
		cm.module = m.id
	WHERE
		cm.course = c.id
		AND m.name LIKE '%forum%') AS 'Forums',
	COUNT(*) AS 'Posts'
FROM
	mdl_forum_posts AS fp
JOIN mdl_forum_discussions AS fd ON
	fp.discussion = fd.id
JOIN mdl_forum AS f ON
	f.id = fd.forum
JOIN mdl_course AS c ON
	c.id = fd.course
JOIN mdl_user AS u ON
	u.id = fp.userid
WHERE
	fp.userid =(
	select
		distinct mdl_user.id
	from
		mdl_user
	join mdl_role_assignments as ra on
		ra.userid = mdl_user.id
	where
		ra.roleid = 3
		and userid = fp.userid
	limit 1)
GROUP BY
	c.id,
	u.id

    --Pending Flat File Enrolments Awaiting Processing
    SELECT
	u.username as 'User Name',
	c.fullname AS "Course",
	ef.action as 'Action',
	r.shortname AS "Role",
	DATE_FORMAT(FROM_UNIXTIME(ef.timestart), '%Y-%m-%d %H:%i') AS "Enrolment Start",
	DATE_FORMAT(FROM_UNIXTIME(ef.timeend), '%Y-%m-%d %H:%i') AS "Enrolment End",
	DATE_FORMAT(FROM_UNIXTIME(ef.timemodified), '%Y-%m-%d %H:%i') AS "Uploaded Date"
FROM
	mdl_enrol_flatfile ef
JOIN mdl_user u ON
	u.id = ef.userid
JOIN mdl_course c ON
	c.id = ef.courseid
JOIN mdl_role r ON
	r.id = ef.roleid
ORDER BY
	u.username

    --Quiz Attempt and Question Performance Details
    SELECT
	cm.course "Course Id",
	cm.id "Module Id",
	q.id "Quiz Id",
	q.name "Quiz Name",
	CASE
		q.grademethod
      WHEN 1 THEN "GRADEHIGHEST"
		WHEN 2 THEN "GRADEAVERAGE"
		WHEN 3 THEN "ATTEMPTFIRST"
		WHEN 4 THEN "ATTEMPTLAST"
	END "Grade Method",
	q.attempts "Quiz Attempts Allowed",
    qatt.behaviour as 'Behaviour',
	cm.groupmode "Group Mode",
	qa.id "Attempt Id",
	qa.state "Attempt State",
	qa.sumgrades "Attempt Grade",
	qg.grade "User Final Grade",
	q.grade "Quiz Max Grade",
	(
	SELECT
		GROUP_CONCAT(g.name)
	FROM
		mdl_groups AS g
	JOIN mdl_groups_members AS m ON
		g.id = m.groupid
	WHERE
		g.courseid = q.course
		AND m.userid = u.id) "User Groups",
	FROM_UNIXTIME(qa.timestart) "Attempt Start",
	FROM_UNIXTIME(qa.timefinish) "Attempt Finish",
	u.id "User Id",
	concat(u.firstname, ' ', u.lastname) as 'Name',
	question.id "Question Id",
	question.name "Question Name",
	qas.state "Question Step State",
	qas.fraction "Question Grade",
	qh.hint as "Hint",
	question.qtype "Question Type"
FROM
	mdl_quiz as q
JOIN mdl_course_modules as cm ON
	cm.instance = q.id
	and cm.module = 17
JOIN mdl_quiz_attempts qa ON
	q.id = qa.quiz
LEFT JOIN mdl_quiz_grades as qg ON
	qg.quiz = q.id
	and qg.userid = qa.userid
JOIN mdl_user as u ON
	u.id = qa.userid
JOIN mdl_question_usages as qu ON
	qu.id = qa.uniqueid
JOIN mdl_question_attempts as qatt ON
	qatt.questionusageid = qu.id
JOIN mdl_question as question ON
	question.id = qatt.questionid
JOIN mdl_question_attempt_steps as qas ON
	qas.questionattemptid = qatt.id
LEFT JOIN mdl_question_hints as qh ON
	qh.questionid = q.id

    --Report on Grade Book Categories, Weightings, and Assignment Types
    /*-- 67*/
SELECT
    c.fullname as 'Couse_Name',
	IF(gc.parent IS NOT NULL, gc.fullname, 'None') AS 'Grade Book Category',
	IF(gc.parent IS NOT NULL, ROUND(gic.aggregationcoef, 2),
	ROUND(SUM(DISTINCT gi.aggregationcoef), 2) + ROUND(SUM(DISTINCT mgi.aggregationcoef), 2)) AS 'Category Weight',
	gi.itemmodule AS 'Activity Type',
    IF(mgi.id, 'manual', NULL) AS 'Manual Activity Type',
	gi.itemname AS 'Activity Name',
	COUNT(DISTINCT IF(gi.id, cm.id, NULL)) + COUNT(DISTINCT mgi.id) AS 'Activity Count',
	cm.visible AS 'Visible'
FROM
	mdl_course AS c
LEFT JOIN mdl_grade_categories AS gc ON
	gc.courseid = c.id
JOIN mdl_grade_items AS gic ON
	gic.courseid = c.id
	AND gic.itemtype = 'category'
	AND gic.aggregationcoef != 0
	AND (LOCATE(gic.iteminstance, gc.path)
		OR (gc.parent IS NULL))
JOIN mdl_course_modules AS cm ON
	cm.course = c.id
LEFT JOIN mdl_grade_items AS gi ON
	gi.courseid = c.id
	AND gi.iteminstance = cm.instance
	AND gi.itemtype = 'mod'
	AND gi.categoryid = gc.id
	AND gi.hidden != 1
LEFT JOIN mdl_grade_items AS mgi ON
	mgi.courseid = c.id
	AND mgi.itemtype = 'manual'
	AND mgi.categoryid = gc.id
GROUP BY
	gc.id,
	gi.itemmodule,
	mgi.id,
	gi.itemname
ORDER BY
	gc.parent,
	gi.itemmodule

    --Rubrics Without Zero-Value Criteria in Moodle Courses
    /* --92*/
SELECT
	cat.id as 'Category Id',
	cat.name AS 'Category',
	c.id AS 'Course Id',
	c.fullname AS 'Course',
	concat('<a target="_new" href="%%WWWROOT%%/grade/grading/form/rubric/edit.php', CHAR(63), 'areaid=', gd.areaid, '">', gd.areaid, '</a>') AS Rubric
FROM
	mdl_course AS c
JOIN mdl_course_categories AS cat ON
	cat.id = c.category
JOIN mdl_course_modules AS cm ON
	c.id = cm.course
JOIN mdl_context AS ctx ON
	cm.id = ctx.instanceid
JOIN mdl_grading_areas AS garea ON
	ctx.id = garea.contextid
JOIN mdl_grading_definitions AS gd ON
	garea.id = gd.areaid
JOIN mdl_gradingform_rubric_criteria AS crit ON
	gd.id = crit.definitionid
JOIN mdl_gradingform_rubric_levels AS levels ON
	levels.criterionid = crit.id
WHERE
	cm.visible = '1'
	AND garea.activemethod = 'rubric'
	AND (crit.id NOT IN
(
	SELECT
		crit.id
	FROM
		mdl_gradingform_rubric_criteria AS crit
	JOIN mdl_gradingform_rubric_levels AS levels
ON
		levels.criterionid = crit.id
	WHERE
		levels.score = '0'))
GROUP BY
	Rubric
ORDER BY
	'Course Id',
	Rubric

    --Scales Used in Activities
    /* --82*/
SELECT
	mcc.name as 'Category',
	c.fullname AS Course,
	scale.name as 'Scale',
	gi.itemname AS "Module View"
FROM
	mdl_grade_items AS gi
JOIN mdl_course AS c ON
	c.id = gi.courseid
LEFT JOIN mdl_course_categories mcc ON
	mcc.id = c.category
JOIN mdl_course_modules AS cm ON
	cm.course = gi.courseid
	AND cm.instance = gi.iteminstance
JOIN mdl_scale AS scale ON
	scale.id = gi.scaleid
WHERE
	gi.scaleid IS NOT NULL

    --Scorm Activity Usage Report by Course Start Date
    /* -- 128 -- 129*/
SELECT
	cc.name AS 'Category',
	c.fullname as 'Course',
	c.shortname AS 'Course Short Name',
	scm.name AS 'Sample Activity Name',
	FROM_UNIXTIME(c.startdate) AS 'Course Start Date',
	COUNT(DISTINCT cm.id) AS 'Resources Used',
	(
	SELECT
		COUNT(cm_inner.id)
	FROM
		mdl_course_modules AS cm_inner
	JOIN mdl_modules AS m_inner ON
		cm_inner.module = m_inner.id
	WHERE
		cm_inner.course = c.id
		AND m_inner.name LIKE '%scorm%'
    ) AS 'Total Scorm Activities'
FROM
	mdl_course_modules AS cm
JOIN mdl_modules AS m ON
	cm.module = m.id
	AND m.name LIKE 'SCO%'
JOIN mdl_course AS c ON
	c.id = cm.course
JOIN mdl_course_categories AS cc ON
	cc.id = c.category
JOIN mdl_scorm AS scm ON
	scm.id = cm.instance
WHERE
	1
GROUP BY
	c.shortname,
	scm.name,
	cc.name,
	c.startdate
ORDER BY
	c.startdate,
	c.shortname;

    --Student Responses to Quiz Questions
    /* --126*/
SELECT
	u.id as 'User Id',
	concat( u.firstname, " ", u.lastname ) AS "Name",
	mcc.id as 'Category Id',
	mcc.name as 'Category',
	q.course as 'Course Id',
	mc.fullname as 'Course',
	q.name as 'Quiz Name',
	quiza.attempt as 'Quiz Attempt',
	qa.slot as 'Slot',
	que.questiontext AS 'Question',
	qa.rightanswer AS 'Correct Answer',
	qa.responsesummary AS 'Student Answer'
FROM
	mdl_quiz_attempts quiza
JOIN mdl_quiz q ON
	q.id = quiza.quiz
JOIN mdl_question_usages qu ON
	qu.id = quiza.uniqueid
JOIN mdl_question_attempts qa ON
	qa.questionusageid = qu.id
JOIN mdl_question que ON
	que.id = qa.questionid
JOIN mdl_user u ON
	u.id = quiza.userid
JOIN mdl_course mc on
	mc.id = q.course
JOIN mdl_course_categories mcc on
	mc.category = mcc.id

    --Summary of Course Sections with Ungraded Resources, Forums, and Graded Activities
    /* --66*/
SELECT
	mcc.name as 'Category',
	c.fullname as 'Course',
	cs.section AS 'Week',
	cs.name AS 'Section Name',
	COUNT(DISTINCT IF((gi.id IS NULL) AND (m.name NOT LIKE 'label'), cm.id, NULL)) AS 'Ungraded Resources',
	COUNT(DISTINCT IF(m.name LIKE 'forum', cm.id, NULL)) AS 'Forums',
	COUNT(DISTINCT IF(gi.id, cm.id, NULL)) AS 'Graded Activities'
FROM
	mdl_course AS c
JOIN mdl_course_categories mcc ON
	c.category = mcc.id
JOIN mdl_course_sections AS cs ON
	cs.course = c.id
	AND cs.section <= 14
	AND cs.section > 0
LEFT JOIN mdl_course_modules AS cm ON
	cm.course = c.id
	AND cm.section = cs.id
JOIN mdl_modules AS m ON
	m.id = cm.module
LEFT JOIN mdl_grade_items AS gi ON
	gi.courseid = c.id
	AND gi.itemmodule = m.name
	AND gi.iteminstance = cm.instance
WHERE
	cs.visible = 1
	AND cm.visible = 1
GROUP BY
	cs.section,
	mcc.id,
	c.id
ORDER BY
	cs.section

    --System-wide Usage of Activities
    SELECT	
	m.name as 'Activity',
	COUNT(cm.id) AS 'Count'
FROM
	mdl_course_modules AS cm
JOIN mdl_modules AS m ON
	cm.module = m.id
GROUP BY
	cm.module
ORDER BY
	COUNT(cm.id) DESC

    --User Based Choice Answers
    select
	mca.id as "ChoiceId",
	mc2.name as "Question",
	mco.text as "Answer",
	CONCAT(mu.firstname, ' ', mu.lastname) as "Name",
	mc.fullname as "Course",
	STR_TO_DATE(DATE_FORMAT(FROM_UNIXTIME(mca.timemodified), '%Y-%m-%d %H:%i'), '%Y-%m-%d %H:%i') as "AnsweredDateTime",
	STR_TO_DATE(DATE_FORMAT(FROM_UNIXTIME(mc2.timemodified), '%Y-%m-%d %H:%i'), '%Y-%m-%d %H:%i') as "DateTime",
	'Moodle' as "Source"
from
	mdl_choice_options mco,
	mdl_choice_answers mca,
	mdl_user mu,
	mdl_choice mc2,
	mdl_course mc
where
	mco.id = mca.optionid
	and mu.id = mca.userid
	and mc.id = mc2.course
	and mc2.id = mca.choiceid

    --User Forum Engagement Report
    /*--100*/
SELECT
	CONCAT(u.firstname, ' ', u.lastname) As 'Name',
	f.name AS 'Forum Name',
	count(*) as 'Posts',
	(
	SELECT
		count(*)
	FROM
		mdl_forum_discussions AS ifd
	JOIN mdl_forum as iforum ON
		iforum.id = ifd.forum
	WHERE
		ifd.userid = fp.userid
		AND iforum.id = f.id) AS 'All Discussion Count'
FROM
	mdl_forum_posts AS fp
JOIN mdl_user as u ON
	u.id = fp.userid
JOIN mdl_forum_discussions AS fd ON
	fp.discussion = fd.id
JOIN mdl_forum AS f ON
	f.id = fd.forum
JOIN mdl_course as c ON
	c.id = fd.course
GROUP BY
	f.id,
	u.id

    --Users Activity All Moduls With All Grades
    select 
mc.fullname as 'Course' , mgi.itemmodule as 'Item Module',
case 
	when mgi.itemmodule = "quiz" 		then mq.name 
	when mgi.itemmodule = "assign" 		then ma.name 
	when mgi.itemmodule = "forum" 		then mf.name 
	when mgi.itemmodule = "data" 		then md.name 
	when mgi.itemmodule = "game" 		then mg.name 
	when mgi.itemmodule = "glossary" 	then mg2.name
	when mgi.itemmodule = "h5pactivity" then mhp.name
	when mgi.itemmodule = "hvp" 		then mh.name 
	when mgi.itemmodule = "lesson" 		then ml.name 
	when mgi.itemmodule = "lti" 		then ml2.name
	when mgi.itemmodule = "scorm" 		then ms.name 
	when mgi.itemmodule = "workshop" 	then mw.name 
	else mgi.itemmodule
end as 'Instance Name',
mu.username as 'User Name',
concat(mu.firstname, ' ', mu.lastname) as 'User',
mgg.finalgrade as 'Final Grade',
mgi.gradetype as 'Grade Type',
mgi.grademax as 'Grade Max',
mgi.grademin as 'Grade Min',
mgi.gradepass as 'Grade Pass',
mgg.rawgrade as 'Raw Grade',
mgg.rawgrademax as 'Raw Grade Max',
mgg.rawgrademin  as 'Raw Grade Min' 
FROM  mdl_grade_grades mgg 
JOIN mdl_grade_items mgi on mgi.id = mgg.itemid 
JOIN mdl_user mu on mu.id=mgg.userid
JOIN mdl_course mc on mc.id =mgi.courseid 
LEFT JOIN mdl_quiz mq ON mgi.itemmodule 		= "quiz" 		 AND mgi.iteminstance = mq.id  
LEFT JOIN mdl_assign ma ON mgi.itemmodule 		= "assign" 		 AND mgi.iteminstance = ma.id  
LEFT JOIN mdl_forum mf ON mgi.itemmodule    	= "forum" 		 AND mgi.iteminstance = mf.id  
LEFT JOIN mdl_data md  ON mgi.itemmodule    	= "data" 		 AND mgi.iteminstance = md.id  
LEFT JOIN mdl_game mg ON mgi.itemmodule    		= "game" 		 AND mgi.iteminstance = mg.id  
LEFT JOIN mdl_glossary mg2 ON mgi.itemmodule    = "glossary" 	 AND mgi.iteminstance = mg2.id 
LEFT JOIN mdl_h5pactivity mhp ON mgi.itemmodule = "h5pactivity"  AND mgi.iteminstance = mhp.id 
LEFT JOIN mdl_hvp mh ON mgi.itemmodule    		= "hvp" 		 AND mgi.iteminstance = mh.id  
LEFT JOIN mdl_lesson ml ON mgi.itemmodule    	= "lesson" 		 AND mgi.iteminstance = ml.id  
LEFT JOIN mdl_lti ml2 ON mgi.itemmodule    		= "lti" 		 AND mgi.iteminstance = ml2.id 
LEFT JOIN mdl_scorm ms  ON mgi.itemmodule   	= "scorm" 		 AND mgi.iteminstance = ms.id  
LEFT JOIN mdl_workshop mw ON mgi.itemmodule    	= "workshop" 	 AND mgi.iteminstance = mw.id  
WHERE not ISNULL(mgi.itemmodule) and not ISNULL(mgg.finalgrade )
order by `Course` ,`Instance Name`, `User Name`

--Users Attempts In Lesson Module
SELECT 
     mc.fullname as 'Course',
     ml.name AS 'Lesson',
     mlp.title AS 'Title',
     mlp.contents AS 'Question',
     mu.username as 'User Name',
     concat(mu.firstname, ' ', mu.lastname) as 'User',
     mla.correct AS 'Is Correct',
     COUNT(mla.correct) AS 'User Count'
FROM mdl_lesson_attempts mla
JOIN mdl_lesson ml ON ml.id = mla.lessonid 
JOIN mdl_user mu ON mu.id = mla.userid 
JOIN mdl_lesson_pages mlp ON mlp.id = mla.pageid 
JOIN mdl_lesson_answers mla2 ON mla2.id = mla.answerid AND mla2.lessonid = ml.id AND mla2.pageid = mlp.id 
JOIN mdl_course mc ON mc.id = ml.course 
GROUP BY mlp.title, mla.correct,mu.username
ORDER BY mlp.title,mu.username, mla.correct

--Weekly Online Activity Count by User and Course
/*-- 174*/
SELECT
	concat(u.firstname, ' ', u.lastname) as 'Name',
	c.fullname as 'Course',
	l.component AS 'Activity',
	COUNT(DISTINCT IF((l.timecreated-c.startdate)<0,l.id,NULL)) AS 'Before Term',
	COUNT(DISTINCT IF(FLOOR((l.timecreated - c.startdate)/(60*60*24*7))=0,l.id,NULL))  AS 'Week 1',
	COUNT(DISTINCT IF(FLOOR((l.timecreated - c.startdate)/(60*60*24*7))=1,l.id,NULL))  AS 'Week 2',
	COUNT(DISTINCT IF(FLOOR((l.timecreated - c.startdate)/(60*60*24*7))=2,l.id,NULL))  AS 'Week 3',
	COUNT(DISTINCT IF(FLOOR((l.timecreated - c.startdate)/(60*60*24*7))=3,l.id,NULL))  AS 'Week 4',
	COUNT(DISTINCT IF(FLOOR((l.timecreated - c.startdate)/(60*60*24*7))=4,l.id,NULL))  AS 'Week 5',
	COUNT(DISTINCT IF(FLOOR((l.timecreated - c.startdate)/(60*60*24*7))=5,l.id,NULL))  AS 'Week 6',
	COUNT(DISTINCT IF(FLOOR((l.timecreated - c.startdate)/(60*60*24*7))=6,l.id,NULL))  AS 'Week 7',
	COUNT(DISTINCT IF(FLOOR((l.timecreated - c.startdate)/(60*60*24*7))=7,l.id,NULL))  AS 'Week 8',
	COUNT(DISTINCT IF(FLOOR((l.timecreated - c.startdate)/(60*60*24*7))=8,l.id,NULL))  AS 'Week 9',
	COUNT(DISTINCT IF(FLOOR((l.timecreated - c.startdate)/(60*60*24*7))=9,l.id,NULL))  AS 'Week 10',
	COUNT(DISTINCT IF(FLOOR((l.timecreated - c.startdate)/(60*60*24*7))=10,l.id,NULL)) AS 'Week 11',
	COUNT(DISTINCT IF(FLOOR((l.timecreated - c.startdate)/(60*60*24*7))=11,l.id,NULL)) AS 'Week 12',
	COUNT(DISTINCT IF(FLOOR((l.timecreated - c.startdate)/(60*60*24*7))>=12,l.id,NULL)) AS 'After Term',
	COUNT(l.id) AS 'Total'
FROM mdl_user AS u
	JOIN mdl_role_assignments AS ra ON u.id = ra.userid
	JOIN mdl_context AS ctx ON ra.contextid = ctx.id
	JOIN mdl_course AS c ON c.id = ctx.instanceid
	JOIN mdl_course_categories as cc ON c.category = cc.id
	LEFT JOIN mdl_logstore_standard_log AS l ON l.userid = u.id AND l.courseid = c.id  AND l.crud IN ('c','u')
WHERE 1
	AND ctx.instanceid = c.id
GROUP BY concat(u.firstname, ' ', u.lastname), c.fullname, l.component
ORDER BY l.component asc
