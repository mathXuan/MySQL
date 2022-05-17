#分组函数
/*
功能：用做统计使用，又称为聚合函数或统计函数或分组函数
分类：
sum 求和 avg 平均值 max最大值 min最小值 count 计算个数
1.sum avg数值型 max min count任何类型
2,以上分组函数都忽略null
3.和distinct搭配实现去重运算
4.count单独介绍
一般使用count(*)用做统计函数
5.和分组函数一同查询的字段要求是group by后的字段
*/

#简单使用
SELECT SUM(`salary`)
FROM `employees`;

SELECT AVG(`salary`)
FROM `employees`;

SELECT SUM(`salary`) 和, AVG(`salary`) 平均
FROM `employees`;

#特点：参数支持哪些类型
#不支持字符型，sum avg支持数值型
SELECT SUM(`last_name`), AVG(`last_name`)
FROM `employees`;

#max min count支持字符型，日期型
SELECT MAX(`last_name`), MIN(`last_name`),COUNT(`last_name`)
FROM `employees`

#忽略null
SELECT SUM(`commission_pct`),AVG(`commission_pct`)
FROM `employees`;

#和distinct搭配实现去重运算
SELECT SUM(DISTINCT `salary`), SUM(`salary`) FROM `employees`;

#count详细介绍
SELECT COUNT(`salary`) FROM `employees`;
#加*统计行数--用于统计个数
SELECT COUNT(*) FROM `employees`;
SELECT COUNT(1) FROM `employees`; #加了一列常数后统计行数

#和分组函数一同查询的字段有限制
#逻辑不对，前面一个值，后面107个值，不能同时出现
SELECT AVG(`salary`), `employee_id`
FROM `employees`;

#分组查询
/*
group by 将表中的数据分成若干组
语法：
     select 分组函数， 列（要修出现在group by的后面）
     from 表
     【where筛选条件】
     group by 分组的列表
     【order by 子句】
注意：查询列表必须特殊，要求是分组函数和group by后出现的字段
特点：
   1.分组查询中的筛选条件分类两类
                 数据源             位置   
    分组前筛选：  原始表           group by子句前面
    分组后筛选： 分组后的结果表    group by子句后面
    1.分组函数做条件肯定是放在having字句中
    2.能用分组前筛选的，优先考虑分组前筛选
    2.group by子句支持单子字段，也支持多个字段
    多个字段没有顺序，用,隔开（也支持函数）
    3.也可以添加排序，但是放在最后
    
*/
#引入：查询每个部门的平均工资
SELECT AVG(`salary`) 
FROM `employees`;

#每个公种的最高工资
SELECT MAX(`salary`), `job_id`
FROM `employees`
GROUP BY `job_id`;

#每个位置上的部门个数
SELECT COUNT(*),`location_id`
FROM `departments`
GROUP BY `location_id`;

#添加筛选条件：查询邮箱中包含a字符每个部门的平均工资
SELECT AVG(`salary`),`department_id`
FROM `employees`
WHERE `email` LIKE "%a%"
GROUP BY `department_id`;

#有奖金的每个领导手下员工的最高工资
SELECT MAX(`salary`),`manager_id`
FROM `employees`
WHERE `commission_pct` IS NOT NULL
GROUP BY `manager_id`;

#调价复杂筛选条件--添加分组后的筛选
#查询那个部门的员工个数大于2
#1.查询每个部门的员工个数
#2.根据1的结果进行筛选，哪个员工个数大于2
SELECT COUNT(*),`department_id`
FROM `employees`
GROUP BY `department_id`
HAVING COUNT(*) > 2  #在筛选后再筛选

#查询每个工种有奖金的员工的最高工资>120000的工种编号和最高工资
#1.查询每个工种有奖金的最高工资
#2.根据1 的结果继续筛选最高工资大于120000
SELECT MAX(`salary`),`job_id`
FROM `employees`
WHERE `commission_pct` IS NOT NULL
GROUP BY `job_id`
HAVING MAX(`salary`)>120000;

#查询领导编号大于102的领导手下的最低工资>5000的领导编号
#1.查询每个领导手下员工的最低工资
SELECT MIN(`salary`),`manager_id`
FROM `employees`
GROUP BY `manager_id`
#添加筛选条件编号>102
SELECT MIN(`salary`),`manager_id`
FROM `employees`
WHERE `manager_id`>102
GROUP BY `manager_id`
#添加筛选条件最低工资大于5000
SELECT MIN(`salary`),`manager_id`
FROM `employees`
WHERE `manager_id`>102
GROUP BY `manager_id`
HAVING MIN(`salary`)>5000;

#按表达式或函数分组
#按员工姓名的长度查询每一组员工个数，筛选员工个数>5有哪些
#1.查询每个长度的员工个数
#2.添加筛选条件
SELECT COUNT(*)
FROM `employees`
GROUP BY LENGTH(`last_name`)
HAVING COUNT(*)>5;

#按多个字段分组
#每个部门，每个工种的员工平均工资
SELECT AVG(`salary`),`department_id`,`job_id`
FROM `employees`
GROUP BY `department_id`,`job_id`;

#添加排序
#查询每个部门，每个工种的员工平均工资，按平均工资正序
SELECT AVG(`salary`),`department_id`,`job_id`
FROM `employees`
WHERE `department_id` IS NOT NULL
GROUP BY `department_id`,`job_id`
HAVING AVG(`salary`)>120000
ORDER BY `salary` DESC;

#练习题
#1.查询各`job_id`的员工工资的最大值，最小值，平均值，综合并按`job_id`升序
SELECT MAX(`salary`),MIN(`salary`),AVG(`salary`),SUM(`salary`)
FROM `employees`
GROUP BY `job_id`
ORDER BY `job_id` ASC;
#2.查询员工最高工资和最低工资的差距（difference）
SELECT MAX(`salary`)-MIN(`salary`) difference
FROM `employees`;
#各个，每个是分组的提示词
#3.查询各个管理者手下员工的最低工资，
#其中最低工资不能低于6000，
#没有管理者的员工不能算在内
/*1.查询员工最低工资
2.最低工资大于
3.不能包括没有管理员
*/
SELECT MIN(`salary`),`manager_id`
FROM `employees`
WHERE`manager_id` IS NOT NULL
GROUP BY `manager_id`
HAVING MIN(`salary`)>=6000;
#4.查询所有部门的编号，
#员工数量和工资平均值，
#并按照平均工资降序
/*
1.查询员工数量和平均值
2.平均工资降序
*/
SELECT `department_id`,COUNT(*), AVG(`salary`) a
FROM `employees`
GROUP BY `department_id`
ORDER BY a DESC;
#5.选择具有各个`job_id`的员工人数
SELECT COUNT(*),`job_id`
FROM `employees`
GROUP BY `job_id`;
