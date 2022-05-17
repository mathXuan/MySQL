#ddl
/*
数据定义语言

库和表的管理
一。库的管理
创建，修改，删除
二。表的管理
创建，修改，删除

创建：create
修改：alter
删除：drop
*/

#一。库的管理
#1.库的创建
/*
语法
create database IF NOT EXISTS 库名;
*/

#创建库books
CREATE DATABASE IF NOT EXISTS books;

#库的修改
#rename database books to 库名;

#更改库的字符集
ALTER DATABASE books CHARACTER SET gbk;

#3.库的删除
DROP DATABASE IF EXISTS books;

#二表的创建
#1.表的创建
/*
create table 表名（
       列名 列的类型【（长度）约束】，
       列名 列的类型【（长度）约束】，
       ……
       列名 列的类型【（长度）约束】
       
）
*/
#创建book表
CREATE TABLE book(
      id INT,
      bname VARCHAR(20), #图书名
      price VARCHAR(20), #价格
      authorid INT, #作者编号
      publishdata DATETIME #出版日期
);
DESC book;
CREATE TABLE author(
            id INT,
            au_name VARCHAR(20),
            nation varcher(10)
);
DESC author;

#表的修改
/*
alter table 表名 add|drop|modify|changr column 列名 【类型 约束】
*/
#修改列名
ALTER TABLE book CHANGE COLUMN publishdata pubdate DATETIME;
#修改列的类型
ALTER TABLE book MODIFY COLUMN pubdate TIMESTAMP;
#添加新列
ALTER TABLE author ADD COLUMN annual DOUBLE;
#删除列
ALTER TABLE author DROP COLUMN annual;
#修改表名
ALTER TABLE author RENAME TO book_author;

#表的删除
DROP TABLE IF EXISTS book_author;

#通用的写法
DROP DATABASE IF EXISTS 旧库名;
CREATE DATABASE 新库名;

DROP TABLE IF EXISTS 旧库名;
CREATE TABLE 新库名;

#表的复制
INSERT INTO author VALUES
(1,'村上春树','日本'),
(2,'莫言','中国'),
(3,'金庸','中国');

#1.仅仅复制表的结构
CREATE TABLE copy LIKE author;

#2.复制表的结构外加数据
CREATE TABLE copy
SELECT * FROM author;

#3.只复制部分数据
CREATE TABLE copy3
SELECT id, au_name
FROM author
WHERE nation='中国';

#4.仅仅复制某些字段
CREATE TABLE copy4
SELECT id,au_name
WHERE author
WHERE 1=2;
#或者
WHERE 0;#这种情况肯定不存在，因此这两列肯定没有

#常见数据类型
/*
数值型：整型
        小数：定点数，浮点数
字符型：较短的文本：char,varchar
        较长的文本：text,blob(较长的二进制数据)
日期型：

*/

#二。小数
/*
分类
1.浮点型
float(M,D)
double(N,D)
2.定点型
dec(M,D)
dec(M,D)
特点：
1.M和D
*/

CREATE TABLE tab_float(
     f1 FLOAT(5,2),
     f1 DOUBLE(5,2),
     f1 DECIMAL(5,2)
)

SELECT * FROM tab_float;

INSERT INTO tab_float VALUES(123.45,123.45,123.45);
