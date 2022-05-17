#sql99
/*
语法：
   select 查询列表
   from 表1 别名【连接类型】
   join 表2 别名
   on 连接条件
   【where 筛选条件】
   【group by 分组】
   【having 筛选条件】
   【order by排序列表】
分类：  
内连接：inner
外连接 
     左外:left [outer]
     右外:right[outer]
     全外:full[outer]
交叉连接:cross
*/

#一。内连接
/*
语法：
  select 查询列表
  from 表1 别名
  inner join 表2 别名
  on 连接条件;
  
 分类：
 等值连接
 非等值
 自连接
 特点：
    1.可以添加排序分组筛选
    2.inner可以省略
    3，筛选条件放在where后面，连接条件放在on后面
    4.inner join连接和sql92语法中的等值连接效果一样，都是查询多表
*/
/*
内连接和外连接的区别
以下面两张表为例来看一下内连接与外连接的区别：
一、内连接( 最常用 )
定义：仅将两个表中满足连接条件的行组合起来作为结果集。
关键词：INNER JOIN

select * from employees e inner join department d 
on e.employee_id = d.department_id  where e.employee_id = "1";
相当于
select * from employees e,department d 
where e.employee_id = d.department_id and e.employee_id = "1";

二、外连接
1、左（外）连接
定义：在内连接的基础上，还包含左表中所有不符合条件的数据行，并在其中的右表列填写NULL
只有在两个表中匹配的行才能在结果集中出现 。有一下三种情况：
a. 对于table1中的每一条记录对应的记录如果在table2中也恰好存在而且刚好只有一条，那么就会在返回的结果中形成一条新的记录。
b. 对于table1中的每一条记录对应的记录如果在table2中也恰好存在而且有N条，那么就会在返回的结果中形成 N条新的记录。
c. 对于table1中的每一条记录对应的记录如果在table2中不存在，那么就会在返回的结果中形成一条条新的记录，且该记录的右边全部NULL。
条件在join子句：

select  *  from employees e
left outer join department d
  on  e.employee_id = d.department_id
        and  e.employee_id = "2"     (其中outer可以省略)
        
2、右（外）连接
定义：在内连接的基础上，还包含右表中所有不符合条件的数据行，并在其中的左表列填写NULL
关键字：RIGHT JOIN
*/
#1.等值连接
#查询员工名，部门名（调换位置）
SELECT `last_name`,`department_name`
FROM `departments` d
INNER JOIN `employees` e
ON e.`department_id`=d.`department_id`;

#查询名字中包含e的员工名和工种名（筛选）
SELECT `last_name`,`job_title`
FROM `employees` e
INNER JOIN `jobs` j
ON e.`job_id`=j.`job_id`
WHERE e.`last_name` LIKE '%e%';

#查询部门个数>3的城市名和部门个数（分组+筛选）
SELECT `city`, COUNT(*)
FROM `locations` l
INNER JOIN `departments` d
ON l.`location_id`=d.`location_id`
GROUP BY `city`
HAVING COUNT(*)>3;

#查询哪个部门的部门员工个数>3的部门名和员工个数，
#并按照个数降序（排序）
SELECT COUNT(*), `department_name`
FROM `departments` d
INNER JOIN `employees` e
ON d.`department_id`=e.`department_id`
HAVING COUNT(*)>3
ORDER BY COUNT(*) DESC;

#多个表查询(三表连接)   
#三表有点顺序后一个后前面两个连起来，保证后面的表和前面的有一个条件
#查询员工名。部门名。公众名并按照部门名降序
SELECT `last_name`,`department_name`,`job_title`
FROM `employees` e
INNER JOIN `departments` d
ON e.`department_id`=d.`department_id`
INNER JOIN `jobs` j
ON j.`job_id`=e.`job_id`
ORDER BY `department_name` DESC;

#二。非等值连接
#查询员工的工资级别
SELECT `salary`,`grade_level`
FROM `employees` e
INNER JOIN `job_grades` g
ON e.`salary` BETWEEN g.`lowest_sal` AND g.`highest_sal`;

#查询工资级别的个数》20的个数，并且按工资级别降序
SELECT COUNT(*),`salary`,`grade_level`
FROM `employees` e
INNER JOIN `job_grades` g
ON e.`salary` BETWEEN g.`lowest_sal` AND g.`highest_sal`
GROUP BY `grade_level`
HAVING COUNT(*)>20 
ORDER BY `grade_level` DESC;

#自连接
#查询员工的名字，上级的名字
SELECT e.`last_name`,m.`last_name`
FROM `employees` e
JOIN `employees` m
ON e.`employee_id`=m.`employee_id`;

#查询姓名中包含字符k的员工的名字，上级的名字
SELECT e.`last_name`,m.`last_name`
FROM `employees` e
JOIN `employees` m
ON e.`employee_id`=m.`employee_id`
WHERE e.`last_name` LIKE '%k%';

#外连接
/*
应用场景：用于查询一个表中有，另一个表没有的纪录
特点：
1.外连接的查询结果为主表中的所有记录
    如果从表中有和他匹配的，则显示匹配结果
    如果从表中没有和他匹配的，则显示null
    外连接查询结果中=内连接结果+主表中有从表没有记录
2.左外连接 left join左边是主表
  右外连接 right join右边的是主表
3.左外和右外交换两个表的顺序，可以实现同样的效果
4.全外连接=内连接的结果+表1中有但表2没有+表2中有但表1没有
*/
#查询男朋友不在男神表的女神名
SELECT b.`name`, bo.* #最终想查询的是主表
FROM `beauty` b
LEFT OUTER JOIN `boys` bo
ON b.`boyfriend_id`=bo.`id`
WHERE bo.`id` IS NULL;  #优先用主键排序

SELECT b.`name`, bo.* #最终想查询的是主表
FROM boys bo
RIGHT OUTER JOIN `beauty` b
ON b.`boyfriend_id`=bo.`id`
WHERE bo.`id` IS NULL;  #优先用主键排序

#查询那个部门没有员工
SELECT d.*, e.`employee_id`
FROM `departments` d
LEFT JOIN `employees` e
ON d.`department_id`=e.`department_id`
WHERE e.`employee_id` IS NULL;

#全外
SELECT b.*, bo.*
FROM `beauty` b
FULL OUTER JOIN `boys` bo
ON b.`boyfriend_id`=bo.`id`;

#交叉连接
SELECT b.*,bo.*
FROM `beauty` b
CROSS JOIN `boys` bo;

#sql92 vs sql99
/*
功能：sql99支持的较多
可读性：sql99实现连接条件和筛选条件的分离，可读性较高
*/

#查询编号>3的女神的男朋友的信息，如果有则列出详细，如果没有用null填充
SELECT b.`id`, b.`name`,bo.*
FROM `beauty` b
LEFT JOIN `boys` bo
ON b.`boyfriend_id`=bo.`id`
WHERE b.`id`>3;

#查询哪个城市没有部门
SELECT l.`city`, d.*
FROM `departments` d
RIGHT JOIN `locations` l
ON d.`location_id`=l.`location_id`
WHERE d.`department_id` IS NULL;

#查询部门名为sal或it的员工信息
SELECT d.`department_name`, e.*
FROM `departments` d
LEFT JOIN `employees` e
ON d.`department_id`=e.`department_id`
WHERE d.`department_name` IN ('sal', 'it');

