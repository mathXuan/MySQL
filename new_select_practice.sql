#子查询
/*
含义：
   出现在其他语句中的select语句，称为子查询或内查询
   外部的查询语句，成为主查询或外查询

分类：
按子查询出现的位置：
      select后面：
             仅仅支持标量子查询
      from后面：
             支持表子查询
      where或having后面：
             标量子查询（单行）
             列子查询（多行）
             行子查询
      exists后面（相关子查询）：
             表子查询
按结果集的行列数不同：
      行量子查询（结果只有一行一列）
      列子查询（结果只有一列多行）
      行子查询（结果集有一行多列）
      表子查询（结果集一般为多行多列）
      
*/

#用在where或having
#1.标量子查询（单行子查询）
#2.列子查询（多行子查询）
/*
搭配着多行操作符
in any/some all
*/

#3.行子查询（多列多行）
/*
特点：
1.子查询放在小括号内
2.子查询一般放在条件的右侧
3.标量子查询一般搭配着单行操作符使用
< > >= <= = <>
4.子查询的执行优先与主查询执行，主查询的条件用到了子查询的结果
*/

#1.行量子查询
#谁的工资比able高
#1.查询able的工资
SELECT `salary`
FROM `employees`
WHERE `last_name`='abel'
#2.查询员工的信息，满足salary>1的结果
SELECT *
FROM `employees`
WHERE `salary`>11000 #这个值是上面的结果换出来的

SELECT *
FROM `employees`
WHERE `salary`>(SELECT `salary`
		FROM `employees`
		WHERE `last_name`='abel');

#查询`job_id`与141号员工相同，`salary`比143号员工多的员工姓名，`job_id`和工资
#查询141号员工的`job_id`
SELECT `job_id`
FROM `employees`
WHERE `employee_id` =141;
#查询143好员工的salary
SELECT `salary`
FROM `employees`
WHERE `employee_id` =143;
#
SELECT `last_name`,`job_id`,`salary`
FROM `employees`
WHERE `job_id`>(
		SELECT `job_id`
		FROM `employees`
		WHERE `employee_id` =141)
AND `salary`>(
		SELECT `salary`
		FROM `employees`
		WHERE `employee_id` =143);
		
#返回公司工资最少的员工的`last_name`，`job_id`和`salary`（分组）
#1.查询工资最少
SELECT MIN(`salary`)
FROM `employees`;
#2。查询……要求工资最少
SELECT `last_name`,`job_id`,`salary`
FROM `employees`
WHERE `salary`=(
		SELECT MIN(`salary`)
		FROM `employees`);

#查询最低工资大于50号部门最低工资的部门id和其最低工资
#1.求50号部门最低工资
SELECT MIN(`salary`)
FROM `employees`
WHERE `department_id`=50
#2.求工资大于最低
SELECT `department_id`,MIN(salary)
FROM `employees`
GROUP BY `department_id`
HAVING MIN(salary)>(
		SELECT MIN(`salary`)
		FROM `employees`
		WHERE `department_id`=50);
		
#非法用标量子查询

#列子查询（多行子查询）
#多行操作符： in any/some all

#返回`location_id`是1400或1700的部门中所有员工姓名
#1。查询`location_id`符合的部门号
SELECT DISTINCT `department_id`
FROM `departments`
WHERE `location_id` IN (1400,1700)
#2.部门号满足的员工姓名
SELECT `last_name`
FROM `employees`
WHERE `department_id` IN(
			SELECT DISTINCT `department_id`
			FROM `departments`
			WHERE `location_id` IN (1400,1700));
			
#返回其他部门中比`job_id`为‘it_prog’部门任一工资低的员工的：工号，姓名，`job_id`和`salary`
#
SELECT `salary`
FROM `employees`
WHERE `job_id`='it_prog'
#
SELECT DISTINCT `employee_id`,`last_name`,`salary`
FROM `employees`
WHERE `salary`< ANY(
		SELECT `salary`
		FROM `employees`
		WHERE `job_id`='it_prog')
AND `job_id`<>'it_prog';
#方法2：
SELECT DISTINCT `employee_id`,`last_name`,`salary`
FROM `employees`
WHERE `salary`< (
		SELECT MAX(`salary`)
		FROM `employees`
		WHERE `job_id`='it_prog')
AND `job_id`<>'it_prog';

#返回其他部门中比`job_id`为'it_prog'部门所有工资都低的员工
#的员工号，姓名，`job_id`以及`salary`
#
SELECT `salary`
FROM `employees`
WHERE `job_id`='it_prog'
#
SELECT DISTINCT `employee_id`,`last_name`,`salary`
FROM `employees`
WHERE `salary`< ALL(
		SELECT `salary`
		FROM `employees`
		WHERE `job_id`='it_prog')
AND `job_id`<>'it_prog';
#方法2
SELECT DISTINCT `employee_id`,`last_name`,`salary`
FROM `employees`
WHERE `salary`< (
		SELECT MIN(`salary`)
		FROM `employees`
		WHERE `job_id`='it_prog')
AND `job_id`<>'it_prog';

#3.行子查询（结果集一行多列或多行多列）
#查询员工编号最小而且工资最高的员工信息
SELECT MIN(`employee_id`)
FROM `employees`
SELECT MAX(`salary`)
FROM `employees`
#
SELECT *
FROM `employees`
WHERE `employee_id`=(
		SELECT MIN(`employee_id`)
		FROM `employees`)
AND salary=(
		SELECT MAX(`salary`)
		FROM `employees`
);

#筛选都是=则可以用行子查询
SELECT *
FROM `employees`
WHERE (`employee_id`,`salary`)=(
        SELECT MIN(`employee_id`),MAX(`salary`)
        FROM `employees`);
        
#二。放在select后面
/*
仅仅支持标量子查询
*/
#查询每个部门的员工个数
SELECT d.*, (
		SELECT COUNT(*)
		FROM `employees` e
		WHERE e.`department_id`=d.`department_id`)
FROM `departments` d;

#查询员工号等于102的部门名
SELECT (
	SELECT `department_name`
	FROM `departments` d
	INNER JOIN `employees` e
	ON e.`department_id`=d.`department_id`
	WHERE e.`department_id`=10)部门名;


#三。from后面
/*
将子查询结果充当一张表，要求必须起别名
*/
#案例：查询每个部门的工资等级
#1.查询每个部门的平均工资
SELECT AVG(`salary`),`department_id`
FROM `employees`
GROUP BY `department_id`;
#2.连接1的结果集和登记表，筛选条件平均工资
SELECT ag_dep.*, g.`grade_level`
FROM (
	SELECT AVG(`salary`) ag,`department_id`
	FROM `employees`
	GROUP BY `department_id`)ag_dep
INNER JOIN `job_grades` g
ON ag_dep.ag BETWEEN `lowest_sal` AND `highest_sal`;

#四exist后面，相关子查询
#exist是否存在
/*
语法：
exist（完整的查询语句）
结果1或0

子查询涉及到部门名
*/
SELECT EXISTS(SELECT `employee_id` FROM `employees`)
#查询有员工名的部门名
SELECT `department_name`
FROM `departments` d
WHERE EXISTS(
         SELECT *
         FROM `employees` e
         WHERE d.`department_id`=e.`department_id`
);
#查询有员工名的部门名
#in
SELECT `department_name`
FROM `departments` d
WHERE d.`department_id` IN(
         SELECT `department_id`
         FROM `employees` 
);

#查询没有女朋友的男神信息
SELECT bo.*
FROM `boys` bo
WHERE bo.`id` NOT IN(
           SELECT `boyfriend_id`
           FROM `beauty`
);

SELECT bo.*
FROM `boys` bo
WHERE NOT EXISTS(
           SELECT `boyfriend_id`
           FROM `beauty` b
           WHERE bo.`id`=b.`boyfriend_id`
);	
	
