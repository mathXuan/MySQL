CREATE SCHEMA exercise;
 
USE exercise;
 
CREATE TABLE Student
(
	stu_id 			VARCHAR(3) NOT NULL, 
	stu_name 		VARCHAR(4) NOT NULL,
	stu_sex 		VARCHAR(2) NOT NULL, 
        stu_birthday            DATETIME NOT NULL,
	stu_class 		VARCHAR(5)
);
 
CREATE TABLE Course
(
	cou_id 		VARCHAR(5) NOT NULL, 
	cou_name 	VARCHAR(10) NOT NULL, 
	tea_id 		VARCHAR(10) NOT NULL
);
 
CREATE TABLE Score 
(
	stu_id 		VARCHAR(3) NOT NULL, 
	cou_id 		VARCHAR(5) NOT NULL, 
	sco_degree 	NUMERIC(10, 1) NOT NULL
);
 
CREATE TABLE Teacher
(
    tea_id          VARCHAR(3) NOT NULL,
    tea_name        VARCHAR(4) NOT NULL,
    tea_sex         VARCHAR(2) NOT NULL,
    tea_birthday    DATETIME NOT NULL,
    tea_prof        VARCHAR(6), 
    tea_depart      VARCHAR(10) NOT NULL
);
 
INSERT INTO Student (stu_id, stu_name, stu_sex, stu_birthday, stu_class)
VALUES (108, '曾华', '男', '1977-09-01', 95033);
INSERT INTO Student (stu_id, stu_name, stu_sex, stu_birthday, stu_class)
VALUES (105, '匡明', '男', '1975-10-02', 95031);
INSERT INTO Student (stu_id, stu_name, stu_sex, stu_birthday, stu_class)
VALUES (107, '王丽', '女', '1976-01-23', 95033);
INSERT INTO Student (stu_id, stu_name, stu_sex, stu_birthday, stu_class)
VALUES (101, '李军', '男', '1976-02-20', 95033);
INSERT INTO Student (stu_id, stu_name, stu_sex, stu_birthday, stu_class)
VALUES (109, '王芳', '女', '1975-02-10', 95031);
INSERT INTO Student (stu_id, stu_name, stu_sex, stu_birthday, stu_class)
VALUES (103, '陆君', '男', '1974-06-03', 95031);
 
INSERT INTO Course (cou_id, cou_name, tea_id)
VALUES ('3-105', '计算机导论', 825);
INSERT INTO Course (cou_id, cou_name, tea_id)
VALUES ('3-245', '操作系统', 804);
INSERT INTO Course (cou_id, cou_name, tea_id)
VALUES ('6-166', '数据电路', 856);
INSERT INTO Course (cou_id, cou_name, tea_id)
VALUES ('9-888', '高等数学', 100);
 
INSERT INTO Score (stu_id, cou_id, sco_degree)
VALUES (103, '3-245', 86); 
INSERT INTO Score (stu_id, cou_id, sco_degree)
VALUES (105, '3-245', 75);
INSERT INTO Score (stu_id, cou_id, sco_degree)
VALUES (109, '3-245', 68);
INSERT INTO Score (stu_id, cou_id, sco_degree)
VALUES (103, '3-105', 92);
INSERT INTO Score (stu_id, cou_id, sco_degree)
VALUES (105, '3-105', 88);
INSERT INTO Score (stu_id, cou_id, sco_degree)
VALUES (109, '3-105', 76);
INSERT INTO Score (stu_id, cou_id, sco_degree)
VALUES (101, '3-105', 64);
INSERT INTO Score (stu_id, cou_id, sco_degree)
VALUES (107, '3-105', 91);
INSERT INTO Score (stu_id, cou_id, sco_degree)
VALUES (108, '3-105', 78);
INSERT INTO Score (stu_id, cou_id, sco_degree)
VALUES (101, '6-166', 85);
INSERT INTO Score (stu_id, cou_id, sco_degree)
VALUES (107, '6-166', 79);
INSERT INTO Score (stu_id, cou_id, sco_degree)
VALUES (108, '6-166', 81);
 
INSERT INTO Teacher (tea_id, tea_name, tea_sex, tea_birthday, tea_prof, tea_depart)
VALUES (804, '李诚', '男', '1958-12-02', '副教授', '计算机系'); 
INSERT INTO Teacher (tea_id, tea_name, tea_sex, tea_birthday, tea_prof, tea_depart)
VALUES (856, '张旭', '男', '1969-03-12', '讲师', '电子工程系');
INSERT INTO Teacher (tea_id, tea_name, tea_sex, tea_birthday, tea_prof, tea_depart)
VALUES (825, '王萍', '女', '1972-05-05', '助教', '计算机系');
INSERT INTO Teacher (tea_id, tea_name, tea_sex, tea_birthday, tea_prof, tea_depart)
VALUES (831, '刘冰', '女', '1977-08-14', '助教', '电子工程系');