#联合查询
/*
union 联合 合并：将多条查询语句的结果合并成一个结果

语法：
查询语句1
union
查询语句2
union
……

应用场景：
要查询的结来自于多个表，且多个表没有直接的连接关系，但查询的信息一致时

注意事项：
1.要求多条查询语句的查询列数是一致的
2.要求多条查询语句的查询的每一列的类型和顺序最好一致
3.union关键字默认去重，如果使用union all可以包含重复项
*/

#部门编号>90或邮箱中包含a的员工信息
SELECT *
FROM `employees`
WHERE `email` LIKE '%a%'
OR `department_id` >90;

#方法二
SELECT * FROM `employees` WHERE `email` LIKE '%a%'
UNION
SELECT * FROM `employees` OR `department_id` >90;

#查询中国用户中男性信息和外国用户中男性的用户信息
SELECT id,cname,csex FROM t_ca WHERE csex='男'
UNION
SELECT t_id, tName,tGender FROM t_us WHERE t_Gender='male';

#dml语言
/*
数据插入语言
插入：insert
修改：update
删除：delete

*/
#插入语句
/*
语法：
insert into 表名（列名）
values(值1，……)


1.插入的数值的类型一致或兼容
2.可以为空的地方用null
3.列的顺序可以调换
4.列数和值的个数必须一致
5.可以省略列名，默认所有列，而且列的顺序和表中列的顺序一直
*/

#1.1.插入的数值的类型一致或兼容
#插入beauty中
INSERT INTO `beauty`(`id`,`name`,`sex`,`borndate`,`phone`,`photo`,`boyfriend_id`)
VALUE(13,'唐艺昕','女','1990-4-23','89880000',NULL,2)
#2.不可以为null的列必须插入，可以为null的列
#方式一：值为null
INSERT INTO `beauty`(`id`,`name`,`sex`,`borndate`,`phone`,`photo`,`boyfriend_id`)
VALUE(13,'唐艺昕','女','1990-4-23','89880000',NULL,2)
#方式二：列名值名都没有
INSERT INTO `beauty`(`id`,`name`,`sex`,`borndate`,`phone`,`boyfriend_id`)
VALUE(14,'金星','女','1990-4-22','89880000',9)
#3.列的顺序可以调换
#4.列数和值的个数必须一致
#5.可以省略列名，默认所有列，而且列的顺序和表中列的顺序一直


#方式二
/*
语法：
insert into 表名
set 列名=值，列名=值
*/

#两种方式大pk
/*
1.方式一支持插入多行
2.方式一支持子查询
*/

INSERT INTO `beauty`(`id`,`name`,`sex`,`borndate`,`phone`,`photo`,`boyfriend_id`)
VALUE(13,'唐艺昕','女','1990-4-23','89880000',NULL,2)
,13,'刘涛','女','1990-4-23','89880000',NULL,2)

INSERT INTO beauty(`id`,`name`,`phone`)
SELECT 26,'宋茜','11809866';

#二修改语句
/*
1.修改单表中的记录
语法：
update 表名
set 列=新值，列=新值
where 筛选条件；  #不加筛选条件则所有行都改变了
2.修改多表中的记录
语法
update 表1 别名，表2 别名
set 列=值
where 连接条件
and 筛选条件

sql99语法
update 表1 别名
inner|left|right join表2 别名
on 连接条件
set 列=值
where 筛选条件
*/

#1.修改单表的记录
#修改beauty中唐电话为19999999
UPDATE `beauty` SET phone='10000000'
WHERE `name` LIKE '唐%';

#多表查询
#案例：修改张无忌的女朋友的手机号为10000
UPDATE `boys` bo
INNER JOIN `beauty` b
ON b.`boyfriend_id`=bo.`id`
SET b.`phone`='114'
WHERE bo.`boyName`='张无忌';

#修改没有男朋友的女神的男朋友编号都是2
UPDATE `boys` bo
RIGHT JOIN `beauty` b
ON b.`boyfriend_id`=bo.`id`
SET b.`boyfriend_id`=2
WHERE b.`id` IS NULL;

#删除语句
/*
方式一：delete   直接删除一行
语法
1.单表删除
delete from 表名 where 筛选条件
2.多表删除
sql92 
delete 别名
from 表1 别名，表2 别名
where 连接条件
and 筛选条件

sql99
delete 别名
from 表1 别名
inner表2 别名
inner|left|right join表2 别名
on 连接条件
and 筛选条件
方式二：truncate
语法：truncate table 表名  #全部删除，能用where
*/

#方式一：
#1.单表删除
#案例：删除手机编号最后一位为9
DELETE FROM `beauty` WHERE `photo` LIKE '%9';
#多表的删除
#删除张无忌的女朋友
DELETE b
FROM `beauty` b
INNER JOIN `boys` bo
ON bo.`id`=b.`boyfriend_id`
WHERE bo.`boyName`='张无忌';

#删除黄晓明的信息以及女朋友的信息
DELETE b,bo
FROM `beauty` b
INNER JOIN `boys` bo
ON bo.`id`=b.`boyfriend_id`
WHERE bo.`boyName`='黄晓明';

#方式二：truncate语句
#将魅力值>100的男神信息删除
TRUNCATE TABLE boys;  #不允许加where，里面的数据全部删除--清空

/*
delete pk truncate
1.delete可以加where， truncate 不能加
2.truncate效率高
3.假如要删除的表中有自增长列，
如果用delete删除后，在插入数据，自增长列的值从断点开始
而truncate删除后，在插入数据，自增长列的值从1开始
4.truncate删除没有返回值，delete删除有返回值
5.truncate删除不能回滚，delete删除可以回滚
*/

DELETE FROM boy;
INSERT INTO boys
VALUES('张飞',100),('刘备',100),('关羽',100)


