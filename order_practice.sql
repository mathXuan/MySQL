#排序查询
#引入
/*
语法
select 查询列表
from 表
where 筛选条件 
order by 排序列表【asc|desc】
特点：ascs升序，desc降序，默认升序
order by 支持单个字段，多个字段，表达式，函数，别名
order by子句一般放在查询语句的最后面，limit子句除外
*/

SELECT * FROM employees;
GROUP BY salary;

#案例：查询员工信息，要求工资从高到低
SELECT * FROM employees ORDER BY salary DESC;
ELECT * FROM employees ORDER BY salary ASC;


#查询员工的姓名和部门号和年薪，按年薪降序，按姓名升序
SELECT `last_name`, `department_id`, salary*12*(1+IFNULL(`commission_pct`,0)) AS 年薪
FROM `employees` 
ORDER BY `last_name` ASC, 年薪 DESC;

#选择工资不在8000到17000的员工的姓名和工资，按工资降序
SELECT `last_name`, `salary`
FROM `employees`
WHERE `salary` NOT BETWEEN 8000 AND 17000
ORDER BY `salary` DESC;

#查询邮箱中包含e的员工信息，并按邮箱的字节数降序，再按部门号升序
SELECT *
FROM `employees`
WHERE `email` LIKE "%e%"
ORDER BY LENGTH(`email`) DESC, `department_id` ASC;

#常见函数的学习
/*
概念：类似于java的方法：将一组逻辑语句封装在方法中，对外暴露方法名
好处：1.隐藏了实现细节 2.提高了代码的重用性
调用： select 函数名（实参列表）[from 表] -----函数中的参数用到表中的字段
特点：1,叫什么（函数名）
      2，干什么（函数功能）
分类 1.单行函数
     concat;length;ifhull
     2.分组函数
     功能：做统计用，又称为统计函数，组函数
*/ 

#一，字符函数
#length获取参数值的字节
SELECT LENGTH('jhon');
SELECT LENGTH('褚梦雪');#一个汉字三个字节

#concat拼接字符串
SELECT CONCAT(`last_name`,`first_name`) FROM `employees`;

#upper, lower
SELECT UPPER('jhon');
#案例：将姓变大写，名小写
SELECT CONCAT(UPPER(`last_name`),LOWER(`first_name`)) 姓名 FROM `employees`;

#substr，substring截取字符 
#注意：索引从1开始
SELECT SUBSTR('小龙女很厉害',4) out_put;
#截取从指定索引出指定字符长度的字符
SELECT SUBSTR('小龙女很厉害',1,3) out_put;
#案例姓名中首字符大写，其他字符小写，然后用_拼接，显示出来
SELECT CONCAT(UPPER (SUBSTR(`last_name`,1,1)), '_', LOWER (SUBSTR(`last_name`,2))) out_put
FROM `employees`;

#instr 返回字符第一次出现的索引，如果找不到，返回-1
SELECT INSTR ('杨不悔爱上了殷六侠','殷六侠') AS out_put;

#trim 去掉前后空格
SELECT TRIM('         张翠山       ') AS out_put;
SELECT TRIM('a' FROM'aaaaaa张翠山aaaaa') AS out_put;

#lpad 用指定的字符实现左填充实现的字符长度，超过了会从右边截断
SELECT LPAD('殷素素',10,'*') out_put;
#rpad 用指定的字符实现右填充实现的字符长度

#replace 所有的自负都会被替换
SELECT REPLACE ('张无忌爱上了周芷若','周芷若','赵敏') out_put;

#二，数学函数
#round 四舍五入/小数点后保留
SELECT ROUND(1.65);
SELECT ROUND(1.567, 2);

#ceil向上取整,返回>=该参数的最小整数
SELECT CEIL(1.00);

#floor向下取整,返回<=该参数的最大整数
SELECT FLOOR(1.00);

#truncate截断 小数点后
SELECT TRUNCATE (1.65,1);

#mod取余 被除数为正数，结果为正数，被除数为负数，结果为负数
#mod(a,b) a-a/b*b
SELECT MOD(-10,-3);
SELECT 10%3;

#日期函数
#now 返回当前系统日期+时间
SELECT NOW();

#curdate返回当前系统日期，不包含时间
SELECT CURDATE();

#curtime返回当前时间，不包含日期
SELECT CURTIME();

#可以获取指定部分的年，月，日，小时
SELECT YEAR(NOW()) 年;
SELECT YEAR('1998-1-1') 年;

SELECT MONTH(NOW()) 月;
SELECT MONTHNAME(NOW()) 月;

#str_to_data将字符通过指定格式转化成日期
SELECT STR_TO_DATE('9-13-1999','%c-%d-%Y') AS out_put;

#查询入职日期为1992-4-3的员工信息
SELECT * FROM `employees` WHERE hiredate = '1992-4-3';
#因为日期的位置不一定相等，因此需要位置转换
SELECT * FROM `employees` WHERE hiredate = STR_TO_DATE('9-13-1999','%c-%d-%Y');

#将日期转化为字符
SELECT DATE_FORMAT(NOW(),%Y年%m月%d日) AS out_put;

#查询有奖金的员工名和入职日期（月日年）
SELECT last_name, DATE_FORMAT(hiredate,'%m月/%d日 %y年') 入职日期
FROM `employees`;

#其他函数
SELECT VERSION();
SELECT DATABASE();
SELECT USER();

#流程控制函数
#1.if函数: if else
SELECT IF(10>5, '大','小');

SELECT last_name,`commission_pct`, IF(`commission_pct` IS NULL, '没奖金','有奖金')
FROM `employees`;

#case函数的使用一: 类似switch CASE
/*
switch(变量或表达量)（case 常量1：语句；break；
                      default：语句； break;）
                      
mysql中
case 研判断的字段或表达式
when常量1 then 要显示的值1或语句1；

else 要显示的值n或语句n
end
*/

/*
案例：查询员工的工资，要求
部门号=30 显示工资为1,1倍
部门号=40 显示工资为1,1倍
部门号=50 显示工资为1,1倍
其他部门显示工资为原工资
*/

SELECT salary 原始工资, `department_id`,
CASE `department_id`
WHEN 30 THEN `salary`*1.1
WHEN 40 THEN `salary`*1.2 #是值不能有;
WHEN 50 THEN `salary`*1.3
ELSE salary
END AS 新工资
FROM `employees`;

#case函数的使用一: 类似多重if
/*
if(条件1)
    语句1；
else if（条件2）
    语句2；
                      
mysql中
case 
when 条件1 then要显示的值1或语句1；
when 条件2 then要显示的值2或语句2；
else 要显示的值n或语句n
end
*/

#案例查询员工工资情况
/*
如果工资>20000,显示A级别
如果工资>15000,显示B级别
如果工资<10000,显示C级别
否则显示D级别
*/
SELECT `salary`,
CASE
WHEN `salary`>20000 THEN 'A'
WHEN `salary`>15000 THEN 'B'
WHEN `salary`>10000 THEN 'C'
ELSE 'D'
END AS 工资级别
FROM `employees`;

/*
常见函数：
1.字符函数：length concat substr instr trim upper lower rpad replace
2.数学函数 round floor ceil truncate mod
3.日期函数 now curtime year month monthname day hour minute second str_to_date date_format
4.其他函数 version datebase user 
5.控制函数 if case
*/

