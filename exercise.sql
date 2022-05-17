USE exercise;

-- 1、 查询student表中的所有记录的stu_name、stu_sex和stu_class列。
SELECT `stu_name`,`stu_sex`,`stu_sex`
FROM `student`;

-- 2、 查询教师所有的单位即不重复的tea_depart列。
SELECT DISTINCT `tea_depart`
FROM `teacher`;

-- 3、 查询student表的所有记录。
SELECT *
FROM `student`;

-- 4、 查询score表中成绩在60到80之间的所有记录。
SELECT *
FROM `score`
WHERE `sco_degree` BETWEEN 60 AND 80;

-- 5、 查询score表中成绩为85，86或88的记录
SELECT *
FROM `score`
WHERE `sco_degree` IN (85,86,88);

-- 6、 查询student表中“95031”班或性别为“女”的同学记录。
SELECT *
FROM `student`
WHERE `stu_class`='95031' OR `stu_sex`='女';

-- 7、 以stu_class降序查询student表的所有记录。
SELECT *
FROM `student`
ORDER BY `stu_class` DESC;

-- 8、 以stu_id升序、sco_degree降序查询score表的所有记录。
SELECT *
FROM `score`
ORDER BY `stu_id` ASC, `sco_degree` DESC;

-- 9、 查询“95031”班的学生人数。
SELECT COUNT(*)
FROM `student`
WHERE `stu_class`='95031';

-- 10、查询score表中的最高分的学生学号和课程号。
SELECT `stu_id`,`cou_id`
FROM `score`
WHERE `sco_degree`=(SELECT MAX(`sco_degree`) FROM `score`);

-- 11、查询‘3-105’号课程的平均分。
SELECT AVG(`sco_degree`)
FROM `score`
WHERE `cou_id`='3-105';

-- 12、查询score表中至少有5名学生选修
-- 的并以3开头的课程的平均分数。
SELECT AVG(`sco_degree`),`cou_id`
FROM `score`
GROUP BY `cou_id` LIKE "3%"
HAVING COUNT(*)>5;

-- 13、查询最低分大于70，最高分小于90的stu_id列。
SELECT `stu_id`,`sco_degree`
FROM `score`
WHERE `sco_degree` BETWEEN 70 AND 90
GROUP BY `sco_degree`;

-- 14、查询所有学生的stu_name、cou_id和sco_egree列。
SELECT `stu_name`,`cou_id``sco_degree`
FROM `student` stu, `score` sco
WHERE stu.`stu_id`=sco.`stu_id`;

-- 15、查询所有学生的stu_id、cou_name和sco_degree列。
SELECT stu.`stu_id`,`cou_name`,`sco_degree`
FROM `student` stu, `score` sco, `course` cou
WHERE stu.`stu_id`=sco.`stu_id`
AND cou.`cou_id`=sco.`cou_id`;

-- 16、查询所有学生的stu_name、cou_name和sco_degree列。
SELECT `stu_name`,`cou_name`,`sco_degree`
FROM `student` stu
INNER JOIN`score` sco
ON stu.`stu_id`=sco.`stu_id`
INNER JOIN`course` cou
ON sco.`cou_id`=sco.`cou_id`
JOIN `grade` gra
WHERE sco.`sco_degree` BETWEEN  gra.`gra_low` AND gra.`gra_upp`

-- 17、查询“95033”班所选课程的平均分。
SELECT student.stu_class, AVG(score.sco_degree) AS degree_avg
FROM student INNER JOIN 
score ON student.stu_id = score.stu_id
WHERE student.stu_class = '95031'

-- 18、假设使用如下命令建立了一个grade表, 现查询所有同学的stu_name、cou_name和gra_rank列。

CREATE TABLE grade
(
	gra_low   NUMERIC(3, 0),
	gra_upp   NUMERIC(3),
	gra_rank  CHAR(1)
 );
 
INSERT INTO grade VALUES(90, 100, 'A');
INSERT INTO grade VALUES(80, 89, 'B');
INSERT INTO grade VALUES(70, 79, 'C');
INSERT INTO grade VALUES(60, 69, 'D');
INSERT INTO grade VALUES(0, 59, 'E');
COMMIT;

SELECT student.stu_name, course.cou_name, grade.gra_rank
FROM score, student, course, grade
WHERE student.stu_id = score.stu_id
    AND score.cou_id = course.cou_id
    AND (score.sco_degree BETWEEN grade.gra_low AND grade.gra_upp)

-- 19、查询选修“3-105”课程的成绩高于“109”号同学成绩的所有同学的记录
SELECT s1.*
FROM score AS s1 INNER JOIN 
score AS s2 ON s1.cou_id = s2.cou_id
WHERE s1.cou_id = '3-105'
	AND s1.sco_degree > s2.sco_degree
	AND s2.cou_id = '3-105' AND s2.stu_id = '109'

-- 20、查询score中选学一门以上课程的同学中分数为非最高分成绩的记录。
SELECT score.*
FROM score
WHERE score.sco_degree < (SELECT MAX(score.sco_degree) FROM score)
GROUP BY score.stu_id
HAVING COUNT(*) > 1

-- 21、查询成绩高于学号为“109”、课程号为“3-105”的成绩的所有记录。
SELECT *
FROM score
WHERE score.sco_degree > (SELECT score.sco_degree
                          FROM score
                          WHERE score.stu_id = '109' AND score.cou_id = '3-105')

-- 22、查询和学号为‘108’的同学同年出生的所有学生的stu_id、stu_name和stu_birthday列。
SELECT student.stu_id, student.stu_name, student.stu_birthday
FROM student
WHERE YEAR(student.stu_birthday) = (SELECT YEAR(student.stu_birthday)
                                    FROM student
                                    WHERE student.stu_id = '108')

-- 23、查询“张旭“教师任课的学生成绩。
SELECT score.sco_degree, score.stu_id
FROM score, course, teacher
WHERE score.cou_id = course.cou_id 
    AND course.tea_id = teacher.tea_id
    AND teacher.tea_name = '张旭'

-- 24、查询选修某课程的同学人数多于5人的教师姓名。
SELECT teacher.tea_name
FROM teacher, course, score
WHERE teacher.tea_id = course.tea_id
	AND course.cou_id = score.cou_id
GROUP BY teacher.tea_name
HAVING COUNT(*) > 5

-- 25、查询95033班和95031班全体学生的记录。
SELECT *
FROM student 
WHERE stu_class IN ('95031', '95033')

-- 26、查询存在有85分以上成绩的课程cou_id。
SELECT score.cou_id
FROM score
GROUP BY score.cou_id
HAVING MAX(sco_degree) > 85;

-- 27、查询出“计算机系“教师所教课程的成绩表。
SELECT student.stu_name, score.sco_degree, course.cou_name, teacher.tea_name
FROM score, teacher, course, student
WHERE student.stu_id = score.stu_id
    AND score.cou_id = course.cou_id
    AND course.tea_id = teacher.tea_id
    AND teacher.tea_depart = '计算机系'

-- 28、查询“计算机系”与“电子工程系“不同tea_prof的教师的tea_name和tea_prof。
SELECT tea_name, tea_prof
FROM teacher
WHERE tea_depart = '计算机系'
    AND tea_prof NOT IN (SELECT tea_prof 
                         FROM teacher
                         WHERE tea_depart = '电子工程系')

-- 29、查询选修编号为“3-105“课程且成绩至少高于选修编号为“3-245”的同学的cou_id、stu_id和sco_degree,并按sco_degree从高到低次序排序。
SELECT cou_id, stu_id, sco_degree
FROM score
WHERE cou_id = '3-105'
    AND sco_degree > ALL(SELECT sco_degree
                         FROM score
                         WHERE cou_id = '3-245')
                         ORDER BY sco_degree DESC
                         
-- 31、查询所有教师和同学的name、sex和birthday。
SELECT tea_name AS NAME, tea_sex AS sex,  tea_birthday AS birthday
FROM teacher
UNION 
SELECT stu_name, stu_sex, stu_birthday
FROM student

-- 32、查询所有“女”教师和“女”同学的name、sex和birthday。
SELECT tea_name AS NAME, tea_sex AS sex,  tea_birthday AS birthday
FROM teacher
WHERE tea_sex = '女'
UNION 
SELECT stu_name, stu_sex, stu_birthday
FROM student
WHERE stu_sex = '女';

-- 33**、查询成绩比该课程平均成绩低的同学的成绩表。
#
SELECT AVG(`sco_degree`)
FROM `score`
GROUP BY`cou_id`
#
SELECT sco1.*
FROM `score` sco1
INNER JOIN `student` stu
ON stu.`stu_id`=sco1.`stu_id`
WHERE sco1.`sco_degree`<(
		SELECT AVG(`sco_degree`)
		FROM `score` sco2
		WHERE sco1.`cou_id`=sco2.`cou_id`
)

-- 34、查询所有任课教师的tea_name和tea_depart。
SELECT `tea_name`,`tea_depart`
FROM `teacher`

-- 35、查询所有未讲课的教师的tea_name和tad_depart。
SELECT tea.`tea_name`,tea.`tea_depart`
FROM `teacher` tea
WHERE tea.`tea_id` NOT IN (
		SELECT cou.`tea_id`
		FROM `course` cou
)
                       
-- 36、查询至少有2名男生的班号。
SELECT stu_class
FROM student
WHERE stu_sex = '男'
GROUP BY stu_class
HAVING COUNT(*) >= 2

-- 37、查询Student表中不姓“王”的同学记录。
SELECT *
FROM student
WHERE stu_name NOT LIKE '王%' 

-- 38、查询Student表中每个学生的姓名和年龄。
SELECT stu_name, YEAR(NOW()) - YEAR(stu_birthday) AS stu_age
FROM student

-- 39、查询Student表中最大和最小的stu_birthday日期值
SELECT MAX(stu_birthday) AS max_birthday, MIN(stu_birthday) AS min_birthday
FROM student

-- 40、以班号和年龄从大到小的顺序查询Student表中的全部记录。
SELECT student.*, YEAR(NOW()) - YEAR(stu_birthday) AS stu_age
FROM student
ORDER BY stu_class DESC, stu_age DESC

-- 41、查询“男”教师及其所上的课程。 
SELECT course.*
FROM course 
INNER JOIN teacher 
ON teacher.tea_id = course.tea_id
WHERE teacher.tea_sex = '男'

-- 42、查询最高分同学的stu_id、cou_id和sco_degree列。
SELECT S1.*
FROM score AS S1
WHERE S1.sco_degree = (SELECT MAX(S2.sco_degree)
		       FROM score AS S2)

-- 43、查询和“李军”同性别的所有同学的stu_name.
SELECT S1.stu_name
FROM student AS S1
WHERE S1.stu_sex = (SELECT S2.stu_sex
                    FROM student AS S2
                    WHERE s2.stu_name = '李军')

-- 44、查询和“李军”同性别并同班的同学stu_name.
#查询同性别
SELECT stu1.`stu_sex`
FROM `student` stu1
WHERE stu1.`stu_name`='李军'
#查询同班
SELECT stu1.`stu_class`
FROM `student` stu1
WHERE stu1.`stu_name`='李军'
#
SELECT stu2.`stu_name`
FROM `student` stu2
WHERE stu2.`stu_sex`=(
		SELECT stu1.`stu_sex`
		FROM `student` stu1
		WHERE stu1.`stu_name`='李军'
)
AND stu2.`stu_class`=(
		SELECT stu1.`stu_class`
		FROM `student` stu1
		WHERE stu1.`stu_name`='李军'
)

-- 45、查询所有选修“计算机导论”课程的“男”同学的成绩表
SELECT score.*
FROM score, student, course
WHERE score.stu_id = student.stu_id
    AND score.cou_id = course.cou_id
    AND course.cou_name = '计算机导论'
    AND student.stu_sex = '男'

