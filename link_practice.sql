#连接查询
/*
含义：多表连接，当查询的字段来自多个表，就会用到连接查询

笛卡尔乘积现象：表1有m行，表2有n行，结果有m*n行
发生原因：没有有效的链接条件
如何避免：添加有效的连接条件

分类：
   1.按年代分类 
    sq92
    sq99标准【推荐】
   2.按功能分类
         内连接：
               等值连接
               非等直连接
               自连接
         外连接：
               左外连接
               右外连接
               全外连接
         交叉连接
*/
SELECT NAME, `boyName` FROM `boys`,`beauty`
WHERE `beauty`.`boyfriend_id`=`boys`.`id`;

#一。sql92标准
#1.等值连接
/*
1.多表等值连接的结果为多表的交集部分
2.n表连接，至少需要n-1个连接条件
3.多表的顺序没有要求
4.多表连接一般需要起别名
5.可以搭配所有查询子句舒勇，比如，排序，分组，查询

*/
#案例一：查询女神名和对应男神名
SELECT NAME, `boyName` 
FROM `boys`,`beauty`
WHERE `beauty`.`boyfriend_id`=`boys`.`id`;

#案例：查询员工名和对应的部门名字
SELECT `last_name`,`department_name`
FROM `employees`,`departments`
WHERE `employees`.`department_id`=`departments`last_name`,`.`department_id`;

#2.为表起别名
/*
提高语句简洁度
区分多个重名的字段

注意：如果为表起了别名，则我们原来的字段就不能用原来的别名去使用
*/
#查询员工名，公种号，工种名
SELECT `last_name`,`employees`.`job_id`,`job_title`
FROM `employees` e,`jobs` j
WHERE `employees`.`job_id`=`jobs`.`job_id`;

#3.两个表的顺序可以调换

#4.可以加筛选
#查询有将近的员工名，部门名
SELECT `last_name`,`department_name`,`commission_pct`
FROM `employees` e,`departments` d
WHERE e.`department_id`=d.`department_id`
AND e.`commission_pct` IS NOT NULL;

#查询城市中第二个字符为o的对应的部门名和城市名
SELECT `department_name`,`city`
FROM `departments` d,`locations` l
WHERE d.`location_id`=l.`location_id`
AND city LIKE '_o%'

#5.可以加分组
#查询每个城市的部门个数
SELECT COUNT(*) 个数, city
FROM `departments` d,`locations` l
WHERE d.`location_id`=l.`location_id`
GROUP BY city;

#查询有奖金的每个部门名和部门的领导编号和该部门的最低工资
SELECT `department_name`,d.`manager_id`,MIN(`salary`)
FROM `departments` d,`employees` e
WHERE d.`department_id`=e.`department_id`
AND `commission_pct` IS NOT NULL
GROUP BY `department_name`,d.`manager_id`;

#6.可以排序
#查询每个工种的公种名和员工的个数，并且按员工个数降序
SELECT `job_title`, COUNT(*) 员工个数
FROM `jobs` j,`employees` e
WHERE j.`job_id`=e.`job_id`
GROUP BY j.`job_title`
ORDER BY 员工个数 DESC;

#7.实现三表连接
#查询员工名部门名和所在城市
SELECT `last_name`,`department_name`,`city`
FROM `departments` d,`employees` e,`locations` l
WHERE e.`department_id`=d.`department_id`
AND d.`location_id`=l.`location_id`;

#2.非等值连接
#查询员工的工资和工资级别
CREATE TABLE job_grades
(grade_level VARCHAR(3),
 lowest_sal  INT,
 highest_sal INT);

INSERT INTO job_grades
VALUES ('A', 1000, 2999);

INSERT INTO job_grades
VALUES ('B', 3000, 5999);

INSERT INTO job_grades
VALUES('C', 6000, 9999);

INSERT INTO job_grades
VALUES('D', 10000, 14999);

INSERT INTO job_grades
VALUES('E', 15000, 24999);

INSERT INTO job_grades
VALUES('F', 25000, 40000);

SELECT * 
FROM job_grades;

SELECT `salary`,`grade_level`
FROM `employees` e, `job_grades` g
WHERE salary BETWEEN g.`lowest_sal` AND g.`highest_sal`
AND g.`grade_level`='A';

#3.自连接 -->相当于等值链接
#案例，查询员工名和上级的名称
SELECT e.`employee_id`,e.`last_name`,m.`employee_id`,e.`last_name`
FROM `employees` e, `employees` m
WHERE e.`manager_id`=m.`employee_id`;

#1.查询员工表的最大工资，工资平均值
SELECT MAX(`salary`), AVG(`salary`)
FROM `employees`;
#2.查询员工表的`employee_id`，`job_id`，
#`last_name`按`department_id`降序，`salary`升序
SELECT `employee_id`,`job_id`,`last_name`
FROM `employees`
ORDER BY `department_id` DESC, `salary` ASC;
#3.查询员工表的`job_id`中包含a和c的，并且a在c前面
SELECT `job_id`
FROM `employees`
WHERE `job_id` LIKE '%a%c%';
#4.已知表student里面有ID，name,gradeid
#已知表grade里面有id，name
#已知表result里面有ID，score，studentno
SELECT s.name,g.name,r.score
FROM student s,grade g,result r
WHERE s.id=r.studentno
AND g.id=s.gradeid;
#5.显示当前日期以及去前后空格，截取子字符
SELECT NOW()
SELECT TRIM(字符 FROM'')

SELECT SUBSTR(str,startindex)
SELECT SUBSTR(str,startindex,LENGTH)

#复习
/*
一、语法
select 查询列表
from 表
where 筛选条件
order by 筛选条件【asc|desc】

二。特点
1.asc:升序，如果不写默认升序
  desc:降序
2.排序列表支持单个字段。多个字段、函数。表达式、别名

一、函数
概述：
   功能：类似于java中的方法
   好处：提高重用性和隐藏实现细节
   调用：select函数名（实参列表）
二、单行函数
concat 连接
substr 截取子段
upper 变大写
lower 变小写
replace 替换
length 获取字节长度
trim 去前后空格
iPad 左填充
rpad 右填充
instr 获取子串第一次出现的索引
2.数学函数
ceil 向上取整
round 四舍五入
mod 取模
floor 向下取整
truncate 截断
rand 获取随机数
3.日期函数
new 返回当前日期时间
year 返回年
month 返回月
day 返回日
date_format 将日期转换成字符
str_to_date 将字符转换成日期
curtime 返回当前日期
hour 小时
minute 分钟
second 秒
detediff 返回两个日期相除
4.其他函数
version 当前数据库服务器的版本
databass当前打开的数据库
user当前用户
password（‘字符’）：返回该字符的密码形式
5.流程控制函数
1.if（条件表达式，表达式1，表达式2）：如果条件表达式成立，返回表达式1，否则返回表达式2
2.case情况1
case 变量或表达式或子段
when 常量1 then值1
when 常量2 then 值2
……
else 值
end
三、分组函数
1.分类
max 最大值
min 最小值
sum 和
AVG 平均值
count 计算个数
2,特点
1.语法 select max（字段）from 表名；
2。支持的类型
sum和AVG一般用于处理数值型
max,min,count可以处理任何数值类型
3.以上分组函数都忽略null
4.都可以搭配distinct使用，实现去重的统计
select sum（distinct 字段）from 表
5.count（字段）：统计该字段非空值的个数
count（*）：统计结果集的行数
*/

