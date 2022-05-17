#进阶1：基础查询
/*
语法：
select 查询列表
from 表名

特点：1，查询列表可以是：表中字段、常量值、表达式、函数
2，查询结果是一个虚拟表哥
*/
#先打开库
USE employees;
#查询表格中单个字段
SELECT last_name FROM employees;
#查询表格多个字段
SELECT last_name,salary,email FROM employees;
#查询表中所有字段 (F12可以直接规范格式)
SELECT 
  `first_name`, #是1旁边的着重号而不是单引号
  `last_name`,
  `email`,
  `job_id`,
  `salary`
FROM employees;

SELECT * FROM employees;

#查询常量值
SELECT 100;
SELECT 'john';
#查询表达式
SELECT 100*98;
#查询函数
SELECT VERSION();
#为字段起别名
SELECT 100*98 AS 结果;
SELECT last_name AS 姓, first_name AS 名 FROM employees;

SELECT last_name 姓, first_name 名 FROM employees;

#案例：查询salary显示结果为out put
SELECT salary AS "out put" FROM employees;#别名和关键字一样，用双引号

#去重
#案例：查询员工表中的涉及到的部门编号
SELECT DISTINCT `department_id` FROM employees;

#+作用
/*
仅仅只有一个功能就是运算符，不能当做连接符
select 100+90 两个操作都是数值型，则做加法运算
select '123'+93;其中一个是字符型，试图字符型数值转换成数值型；转换成功则为加法运算
                转换失败，自复制转换成0；其中一个为null，结果为null
*/
#案例：查询员工姓和名连接成一个字段
SELECT `last_name`+`first_name` AS 姓名
FROM employees;

SELECT CONCAT(`last_name`,`first_name`) AS 姓名
FROM employees;

#练习题
#显示表departments的结构，并查询其中全部的数据
DESC departments; #desc是describe的缩写，用法： desc 表名/查询语句
SELECT * FROM departments;
#显示出表employees中的全部job_id（不能查询）
SELECT DISTINCT job_id FROM employees;
#显示出表employees的全部列，各个列之间用逗号连接，列头显示成out_put
SELECT CONCAT(`first_name`,',',`last_name`,',',`email`) AS out_put
FROM employees;
#如果在拼接的时候有数据是null，因此需要有一个判断，是null则返回0
SELECT IFNULL(`commission_pct`,0) AS 奖金率,
       `commission_pct`
FROM `employees`;

#进阶2 条件查询
/*
语法
*/