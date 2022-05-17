USE `myemployees`
#显示系统时间（注：日期+时间）
SELECT NOW();
#查询员工号，姓名，工资以及工资提高20%之后的结果（new salary）
SELECT `employee_id`, `last_name`, `salary`, `salary`*1.2 AS "new salary" #别名用双引号
FROM `employees`;
#将员工的姓名按首字母排序并写出姓名长度（length）
SELECT LENGTH(`last_name`), SUBSTR(`last_name`,1,1) 首字符, `last_name`
FROM `employees`
ORDER BY 首字符;
/*做一个查询，产生下面的结果
<last_name> earns<salsry> monthly but wants <salary*3>
Dream Salary
King earns 24000 monthly but wants 72000
*/
SELECT CONCAT(`last_name`,'earns',`salary`,'monthly but wants',`salary`*3)
FROM `employees`
WHERE salary = 240000;
/*
使用case-when按照下面的条件
job grade
ad_pres A
st_man B
it_prog C
*/

SELECT `last_name`, `job_id` AS job,
CASE `job_id`
WHEN 'ad_pres' THEN 'A'
WHEN 'st_man' THEN 'B'
WHEN 'it_prog' THEN 'C'
END AS grade
FROM `employees`
WHERE `job_id` = 'ad_pres'

#1.查询和zlotkey相同部门的员工姓名和工资
#1.查询z的部门
#2.查询部门号等于1的结果
SELECT `last_name`,`salary`
FROM `employees`
WHERE `department_id`=(
		SELECT `department_id`
		FROM `employees`
		WHERE `last_name`='zlotkey');
#2.查询工资比公司平均工资高的员工的员工号，姓名和工资
SELECT `employee_id`,`last_name`,`salary`
FROM `employees`
WHERE `salary`>(
		SELECT AVG(`salary`)
		FROM `employees`);
#3.查询各部门中工资比本部门平均高的员工的员工号，姓名和工资
SELECT `employee_id`,`last_name`,`salary`,e.`department_id`
FROM `employees` e
INNER JOIN (
	SELECT AVG(`salary`) ag,`department_id`
	FROM `employees`
	GROUP BY `department_id`)ag_dep
ON e.`department_id`=ag_dep.`department_id` 
WHERE `salary`>ag_dep.ag;
#4.查询姓名中包含字母u的员工在相同部门的员工的员工号和姓名
SELECT `employee_id`,`last_name`
FROM `employees` e
INNER JOIN (
	SELECT `department_id`
	FROM `employees`
	WHERE `last_name` LIKE '%u%')ag_dep
ON e.`department_id`=ag_dep.`department_id`;
#
SELECT `employee_id`,`last_name`
FROM `employees` 
WHERE `department_id`IN (
	SELECT DISTINCT`department_id`
	FROM `employees`
	WHERE `last_name` LIKE '%u%');
#5.查询在部门的`location_id`为1700的部门工作的员工的员工号
SELECT `employee_id`
FROM `employees` e
INNER JOIN (
	SELECT `department_id`
	FROM `departments` d
	INNER JOIN `locations` l
	WHERE d.`location_id`=l.`location_id`
	AND l.`location_id`=1700)ag_dep
ON e.`department_id`=ag_dep.`department_id`;
#
SELECT `employee_id`
FROM `employees`
WHERE `department_id`=ANY (
	SELECT DISTINCT `department_id`
	FROM `departments`
	WHERE `location_id`=1700);
#6.查询管理者是King的员工姓名和工资
#1.查询姓名为king的员工编号
SELECT `employee_id`
FROM `employees` 
WHERE `last_name`='k_ing'
#2.查询员工的mangerid
SELECT `last_name`,`salary`
FROM `employees`
WHERE `manager_id` IN(
		SELECT `employee_id`
		FROM `employees` e
		WHERE `last_name`='k_ing');
#7.查询工资最高的员工的姓名，要求`first_name`和`last_name`显示为一列，列为姓，名
#1.查询最高工资
SELECT MAX(`salary`)
FROM `employees`
#2.查询工资=1的姓名
SELECT CONCAT(`first_name`,`last_name`)"姓，名"
FROM `employees`
WHERE `salary`=(
		SELECT MAX(`salary`)
		FROM `employees`
);

#1.查询工资最低的员工信息：`last_name`，`salary`
SELECT `last_name`,`salary`
FROM `employees`
WHERE `salary`=(
		SELECT MIN(`salary`)
		FROM `employees`);
#2.查询平均工资最低的部门信息
#查询各部门的最低工资
SELECT AVG(`salary`),`department_id`
FROM `employees`
GROUP BY`manager_id`
#查询1结果上的最低平均工资
SELECT MIN(ag)
FROM (
	SELECT AVG(`salary`) ag,`department_id`
	FROM `employees`
	GROUP BY`department_id`
	)ag_dep
#查询哪个部门的平均工资=2结果
SELECT AVG(`salary`)
FROM `employees`
GROUP BY `department_id`
HAVING AVG(`salary`)=(
		SELECT MIN(ag)
		FROM (
			SELECT AVG(`salary`) ag,`department_id`
			FROM `employees`
			GROUP BY`department_id`
			)ag_dep
);
#查询部门信息
SELECT d.*
FROM `departments` d
WHERE d.`department_id`=(
			SELECT `department_id`
			FROM `employees`
			GROUP BY `department_id`
			HAVING AVG(`salary`)=(
				SELECT MIN(ag)
				FROM (
					SELECT AVG(`salary`) ag
					FROM `employees`
					GROUP BY`department_id`
					)ag_dep
                                              )
)
#方法二
#查询各部门的最低工资
SELECT AVG(`salary`),`department_id`
FROM `employees`
GROUP BY`manager_id`
#求出最低的部门编号
SELECT `department_id`
FROM `employees`
GROUP BY `department_id`
ORDER BY AVG(`salary`)
LIMIT 1;
#查询部门信息
SELECT *
FROM `departments`
WHERE `department_id`=(
		SELECT `department_id`
		FROM `employees`
		GROUP BY `department_id`
		ORDER BY AVG(`salary`)
		LIMIT 1
);
#3.查询平均工资最低的部门信息和该部门的平均工资
#查询各部门的最低工资
SELECT AVG(`salary`),`department_id`
FROM `employees`
GROUP BY`manager_id`
#查询平均工资最低的部门
SELECT AVG(`salary`),`department_id`
FROM `employees`
GROUP BY `department_id`
ORDER BY AVG(`salary`)
LIMIT 1;
#查询部门信息（连接查询--表子查询）
SELECT d.*, ag
FROM `departments` d
JOIN (
	SELECT AVG(`salary`) ag,`department_id`
	FROM `employees`
	GROUP BY `department_id`
	ORDER BY AVG(`salary`)
	LIMIT 1
)ag_dep
ON d.`department_id`=ag_dep.`department_id`;
#4.查询平均工资最高的job信息
#查询平均工资最高
SELECT AVG(`salary`) sal, `job_id`
FROM `employees`
ORDER BY sal ASC
LIMIT 1;
#查询job
SELECT j.*
FROM `jobs` j
INNER JOIN (
	SELECT AVG(`salary`) sal, `job_id`
	FROM `employees`
	ORDER BY sal ASC
	LIMIT 1
)ag_dep
WHERE j.`job_id`=ag_dep.`job_id`;

#查询最高的job的平均工资
SELECT AVG(`salary`) sal, `job_id`
FROM `employees`
GROUP BY `job_id`
ORDER BY sal ASC
LIMIT 1;
#查询job
SELECT *
FROM `jobs`
WHERE `job_id`=(
	SELECT `job_id`
	FROM `employees`
	GROUP BY `job_id`
	ORDER BY AVG(`salary`) ASC
	LIMIT 1
);
#5.查询平均工资高于公司平均工资的部门有哪些
#查询公司平均工资
SELECT AVG(`salary`)
FROM `employees`
#查询每个部门的平均工资
SELECT AVG(`salary`)
FROM `employees` 
GROUP BY `department_id`
#3筛选2结果集，满足平均>1
SELECT AVG(`salary`)
FROM `employees` 
GROUP BY `department_id`
HAVING AVG(`salary`)>(
		SELECT AVG(`salary`)
		FROM `employees`
);
#6.查询出公司中所有`manager的详细信息
#查询所有manger的员工编号
SELECT DISTINCT `manager_id`
FROM `employees`
#查询详细信息满足`employee_id`=1
SELECT *
FROM `employees`
WHERE `employee_id`=ANY(
		SELECT DISTINCT `manager_id`
		FROM `employees`
);
#7.各个部门中 最高工资中最低的那个部门的最低工资是多少
#查询每个部门的最高工资
SELECT MAX(`salary`)
FROM `employees`
GROUP BY `department_id`
#查询最高工资中最低的
SELECT MIN(`salary`)
FROM `employees`
WHERE `salary`> ANY(
	SELECT MAX(`salary`)
	FROM `employees`
	GROUP BY `department_id`
)
#方法二
#查询最高工资中最低的
SELECT MAX(`salary`)
FROM `employees`
GROUP BY `department_id`
ORDER BY MAX(`salary`)
LIMIT 1
#查询那个部门的最高工资=1
SELECT MIN(`salary`)
FROM `employees`
WHERE `department_id`=(
	SELECT `department_id`
	FROM `employees`
	GROUP BY `department_id`
	ORDER BY MAX(`salary`)
	LIMIT 1
);
#8.查询平均工资最高的部门的`manager的
#详细信息`last_name`，`department_id`，
#`email`，`salary`

#查询平均工资最高
SELECT MAX(`salary`)
FROM `employees`
#平均工资最高
SELECT `department_id`
FROM `employees`
WHERE `salary`=(
	SELECT MAX(`salary`)
	FROM `employees`
)
#查询详细信息
SELECT `last_name`,`department_id`,`email`,`salary`
FROM `employees` e
WHERE e.`department_id`=(
		SELECT `department_id`
		FROM `employees`
		WHERE `salary`=(
			SELECT MAX(`salary`)
			FROM `employees`
)
);

#查询平均工资最高的部门编号
SELECT `department_id`
FROM `employees`
GROUP BY `department_id`
ORDER BY AVG(`salary`) DESC
LIMIT 1
#将`employees`和`departments`连接，筛选条件是1
SELECT `last_name`,d.`department_id`,`email`,`salary`
FROM `employees` e
INNER JOIN `departments` d
ON d.`manager_id`=e.`manager_id`
WHERE d.`department_id`=(
		SELECT `department_id`
		FROM `employees`
		GROUP BY `department_id`
		ORDER BY AVG(`salary`) DESC
		LIMIT 1
)


#作业
#1.查询每个专业的学生人数
SELECT COUNT(*)
FROM `student`
GROUP BY `majorid`;
#2.查询参加考试的学生中，每个学生的平均分，最高分
SELECT AVG(`score`),MAX(`score`),s.`studentno`
FROM `result` r
INNER JOIN `student` s
ON r.`studentno`=s.`studentno`
GROUP BY s.`studentno`;
#3.查询姓张的每个学生的最低分大于60的学号，姓名
#查询姓张的同学的成绩
SELECT s.`studentname`, score
FROM `student` s
INNER JOIN `result` r
ON r.`studentno`=s.`studentno`
WHERE `studentname` LIKE '张%'
#查询每个人的最低分
SELECT s.`studentname`, MIN(score)
FROM `student` s
INNER JOIN `result` r
ON r.`studentno`=s.`studentno`
WHERE `studentname` LIKE '张%'
GROUP BY `studentname`
#查询姓名，学号
SELECT stu_sco.`studentname`,stu_sco.`studentno`
FROM (
	SELECT s.`studentname`, MIN(score) sco,s.studentno
	FROM `student` s
	INNER JOIN `result` r
	ON r.`studentno`=s.`studentno`
	WHERE s.`studentname` LIKE '张%'
	GROUP BY s.`studentname`
)stu_sco
WHERE stu_sco.`sco`>60;
#方法二
SELECT s.`studentname`, MIN(score) sco,s.studentno
FROM `student` s
INNER JOIN `result` r
ON r.`studentno`=s.`studentno`
WHERE s.`studentname` LIKE '张%'
GROUP BY s.`studentname`
HAVING sco>60;
#4.查询每个专业生日在“1988-1-1”后的学生姓名。专业名称
#查询专业生日
SELECT `borndate`
FROM `student`
WHERE `borndate` >'1988-1-1' 
#查询
SELECT dat.`studentname`,dat.`majorid`
FROM (
	SELECT `borndate`,`studentname`,`majorid`
	FROM `student`
	WHERE `borndate` >'1988-1-1' 
)dat
GROUP BY dat.`majorid`;
#正确答案：关键是日期更大,不能用大于号比较
SELECT `studentname`,`majorname`,s.`majorid`
FROM `student` s
JOIN `major` m
ON m.`majorid`=s.`majorid`
WHERE DATEDIFF(`borndate`,'1988-1-1')>0;
#5.查询每个专业的男生人数和女生人数分别是多少
#查询每个专业的男生人数
SELECT gri.count(*)
FROM(
	SELECT `majorid`,`studentno`,`sex`
	FROM `student`
	WHERE  `sex`='女'
	GROUP BY `majorid`;
)gri;
FROM `student`
WHERE `sex`='男'
GROUP BY `majorid`;
#计算个数的时候，可以直接把结果放到select后面
#方法一
SELECT COUNT(*),`sex`,`majorid`
FROM `student`
GROUP BY `sex`,`majorid`;
#方式二
SELECT `majorid`,
(SELECT COUNT(*) FROM `student` WHERE sex='男' AND `majorid`=s.`majorid`) 男,
(SELECT COUNT(*) FROM `student` WHERE sex='女' AND `majorid`=s.`majorid`) 女
FROM `student` s
GROUP BY `majorid`;
#6.查询专业和张翠山一样的学生的最低分
#查询张翠山专业
SELECT m.`majorid`
FROM `student` s
INNER JOIN `major` m
ON m.`majorid`=s.`majorid`
WHERE `studentname`='张翠山'
#查询一样学生
SELECT MIN(`score`)
FROM `student` s
INNER JOIN `result` r
ON r.`studentno`=s.`studentno`
WHERE s.`majorid` IN (
		SELECT m.`majorid`
		FROM `student` s
		INNER JOIN `major` m
		ON m.`majorid`=s.`majorid`
		WHERE `studentname`='张翠山'
);
#不应该直接等于，应该是In
#7.查询大于60分的学生姓名，密码，专业名
SELECT `studentname`,`loginpwd`,COUNT(*)
FROM `student` s
INNER JOIN `result` r
ON r.`studentno`=s.`studentno`
WHERE r.`score`>60;
#正确答案应该把三个表都放在一起
SELECT `studentname`,`loginpwd`,`majorname`
FROM `student` s
JOIN `major` m ON s.`majorid`=m.`majorid`
JOIN `result` r ON r.`studentno`=s.`studentno`
WHERE r.`score`>60;
#8.按邮箱位数分组，查询每组的学生个数
SELECT COUNT(*)
FROM `student`
GROUP BY LENGTH(`email`)
#9.查询学生名，专业名，分数
SELECT s.`studentname`,m.`majorname`,r.`score`
FROM `student` s
INNER JOIN `result` r
ON s.`studentno`=r.`studentno`
INNER JOIN `major` m
ON s.`majorid`=m.`majorid`;
#10.查询哪个专业没有学生，分别用左连接和右连接实现
#左连接
SELECT m.`majorid`,m.`majorname`,s.`studentno`
FROM `major` m
LEFT JOIN `student` s ON m.`majorid`=s.`majorid`
WHERE s.`studentno` IS NULL;
#右连接
SELECT m.`majorid`,m.`majorname`,s.`studentno`
FROM `student` s 
RIGHT JOIN `major` m ON m.`majorid`=s.`majorid`
WHERE s.`studentno` IS NULL;

#11.查询没有成绩的学生人数
SELECT COUNT(*)
FROM `student` s
LEFT JOIN `result` r
ON s.`studentno`=r.`studentno`
WHERE r.`id` IS NULL;

/*
1.运行以下脚本创建表my_employees
create table my_employees(
      id int(10),
      first_name verchar(10),
      last_name verchar(10),
      userid verchar(10),
      salary double(10,2)
)
create table users(
      id int,
      userid verchar(10),
      department_id int
)
*/
#2.显示表my_employees的结构
#3.向表my_employees中插入以下数据
/*
id  first_name  last_name   useris  salsry
1   patel       rpatel      895
2   dances      bdancs      860
3   biri        bbiri       1100
4   newman      cnewman     750
5   ropeburn    audrey      1550  
*/
#4.向users表中插入数据
/*
1  rpatel  10
2  bdances  10
3  bbiri  20
4  cnewman  30
5  aropebur  40

*/

USE `myemployees`  #先选定库
CREATE TABLE my_employees(
      id INT(10),
      first_name VARCHAR(10),
      last_name VARCHAR(10),
      userid VARCHAR(10),
      salary DOUBLE(10,2)
);
CREATE TABLE users(
      id INT,
      userid VARCHAR(10),
      department_id INT
);