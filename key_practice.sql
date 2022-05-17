#常见约束
/*
含义：一种限制，用于限制表中的数据，为了保证表中的数据的准确性和可靠性

分类：六大约束
      1.not null：非空，用于保证该字段的值不能为空
      比如姓名，学号等
      2.default 默认，用于保证该字段的值有默认值
      比如性别
      3.primary key 主键，用于保证该字段的值具有唯一性
      比如学号，员工编号等
      4.unique 唯一，用于保证该字段的值具有唯一性，可以为空
      比如座位号
      5.check 检查约束【MySQL中不支持】
      比如年龄，性别
      6.foreign ket 外键，用于限制两个表的关系，用于保证该字段的值
      来自于主表的关联列的值
      在表中添加外键约束，用于引用主表中某列的值
      比如学生表的专业编号，员工表的部门编号，员工表的工种编号
      
添加约束的时机：
       1.创建表时
       2.修改表时

约束的添加分类：
         列级约束：
             六大约束语法上都支持，但是外键约束没有效果
         表级约束：
             除了非空，默认，其他的都支持   

主键和唯一的大对比：
            保证唯一性        是否为空     一个表中可以有多少个   是否允许组合
    主键     可以             不可以         至多有1个             可以但不推荐
    唯一     可以              可以          可以有多个             可以但不推荐
    insert into major values(1,'java');
    insert into major values(2,'h5');
    insert into stuinfo values(1,'john','男','null',19,1);
    insert into stuinfo values(2,'lily','男','null',19,2);
           
create table 表名(
      字段名 字段类型 列级约束，
      字段名 字段类型
      表级约束
)

*/

#外键
/*
1.要求在从表设置外键关系
2.从表的外键列的类型和主表的关联列的类型要求一致或兼容，名称无要求
3.主表的关联列必须是一个key（一般是主键或唯一）
4.插入数据时，先插入主表，在插入从表
  删除数据时，先删除从表，再删除主表

*/  
#修改表时添加约束
DROP TABLE IF EXISTS stuinfo;
CREATE TABLE stuinfo(
    id INT,
    stuname VARCHAR(20),
    gender CHAR(1),
    seat INT,
    age INT,
    majorid INT
)
DESC `stuinfo`;
#添加非空约束
ALTER TABLE `stuinfo` MODIFY COLUMN `stuname` VARCHAR(20) NOT NULL;
#添加默认约束
ALTER TABLE `stuinfo` MODIFY COLUMN age INT DEFAULT 18;
#添加主键
ALTER TABLE `stuinfo` MODIFY COLUMN `id` INT PRIMARY KEY;
#添加唯一
#表级约束
ALTER TABLE `stuinfo` MODIFY COLUMN seat INT UNIQUE;
#表级约束

#一创建列级约束
/*
语法：
直接在字段名和类型后面追加约束类型即可
只支持：默认，非空，主键，唯一
*/

#二修改表时添加约束
DROP TABLE IF EXISTS stuinfo;
CREATE TABLE stuinfo(
    id INT,
    stuname VARCHAR(20),
    gender CHAR(1),
    seat INT,
    age INT,
    majorid INT
)
DESC `stuinfo`
#添加非空约束
ALTER TABLE stuinfo MODIFY COLUMN stuname VARCHAR(20) NOT NULL
#添加默认约束
ALTER TABLE stuinfo MODIFY COLUMN age INT DEFAULT 18
#添加主键
#列级约束
ALTER TABLE stuinfo MODIFY COLUMN ID INT PRIMARY KEY
#表级约束
ALTER TABLE stuinfo ADD PRIMARY  KEY (id)