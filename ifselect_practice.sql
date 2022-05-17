#条件查询
/*
语法：
   select 查询列表
   from 表名
   where 筛选条件； -------部分行，过滤
分类：
1.按条件表达式筛选
条件运算符 > < = !=/<> >= <=
2.按逻辑表达式筛选
作用：连接条件表达式
逻辑运算符 && || ！and or not
&&和and如果两个条件都为true,结果为true
||和or如果有一个条件都为true,结果为true
3.模糊查询 
like/ between and/ in / is null
*/
#按条件表达式筛选
#案例：工资大于10000
SELECT *
FROM `employees`
WHERE salary > 12000;

#案例：部门编号不等于90的员工名和部门编号
SELECT`last_name`, `department_id`
FROM `employees`
WHERE `department_id` != 90;

#按逻辑表达式筛选
#案例：工资在1w到2w之间的员工名，工资及奖金
SELECT `last_name`,`salary`,`commission_pct`
FROM `employees`
WHERE salary >=1000 && salary <= 20000;

#案例：部门编号不是90-100之间或者工资高于1.5w
SELECT *
FROM `employees`
WHERE `department_id`<90 OR `department_id`>110 OR `salary` > 15000;

#模糊查询 
/*
like 像；1.一般和通配符搭配使用，%->任意多个字符；_任意单个字符
between and 在……中间 1.可以提高语句简洁度2.包含临界值3.两个值不可以颠倒顺序
in 在……中 1.用于判断某字段的值是否属于某列表中的某一项；使用in 比 or更加简洁
          2.in列表的值类型必须统一
          3.in列表的值不能用通配符
is null   = !=不能判断null
           is不能判断其他值
*/
#案例：查询员工名中包含字符a的员工信息--不是精确匹配
SELECT *
FROM `employees`
WHERE `last_name` LIKE '%a%';  #%表示任意字符
#案例：员工名中第3个字符为e，第5个为a的员工名和工资
SELECT `last_name`, `salary`
FROM `employees`
WHERE `last_name` LIKE '__n_l%';
#案例：查询员工名第二个为_
SELECT `last_name`
FROM `employees`
WHERE `last_name` LIKE '_\_%'  #_为特殊值，因此用\转译符号来
#转译也可以自己定义新的
WHERE `last_name` LIKE '_&_%' ESCAPE '&';

#between and
#案例：查询员工编号在100到120之间
SELECT *
FROM `employees`
WHERE `employee_id` >= 100 AND `employee_id` <=120;
--------------------------
WHERE `employee_id` BETWEEN 100 AND 120;

#in
#案例：查询员工的工种编号是it_prog,advp,ad_pres中的一个的员工名和工种编号
SELECT `last_name`, `job_id`
FROM `employees`
WHERE `job_id` IN ('it_prog' OR 'ad_vp');

SELECT `last_name`, `job_id`
FROM `employees`
WHERE `job_id` IN ('it_prog', 'ad_vp');`employees`

--------------------------------
WHERE `job_id` = 'it_prog';

#is null
#案例：没有奖金的员工名和奖金率
SELECT `last_name`,`commission_pct`
FROM `employees`
WHERE `commission_pct` IS NULL; 
WHERE `commission_pct` = NULL; # 不成功，因为=不能识别null

#安全等于<=>也能判断null，还可以求解其他
SELECT `last_name`,`commission_pct`
FROM `employees`
WHERE `commission_pct` <=> NULL; 
#查询工资为1.2w的人
SELECT `last_name`,`salary`
FROM `employees`
WHERE `salary` <=> 12000; 

#is null 仅仅 null;安全等于<=>也能判断null，还可以判断其他

#查询员工号为176的员工的姓名和部门号和年薪