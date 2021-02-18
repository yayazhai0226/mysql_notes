-- 库的操作
show databases ;
use test ;
show tables ;
create database test1 ;
show databases ;
drop database test1 ;
show databases ;

-- 创建数据表
use test ;
CREATE table table_a(`id` int(10) not null default 0 , `name` char(50) default null , primary key (`id`)) ENGINE = INNODB default CHARSET = utf8 ; #也可以不定义引擎和字符集，默认。
show tables ;
select * from article ;

-- 删除数据库
drop table article ;

-- 修改数据库表名
alter table article rename new_article ;
show tables ;

-- 查看表结构
desc new_article ;

-- 【字段的】增删改
begin
-- 增加表字段 add
alter TABLE new_article add username VARCHAR(50) ;
alter table article add username varchar(50) first ;#调整表字段增加的顺序（默认是把字段加到末尾处） 关键字： first 、after

-- 删除表字段 drop
alter table article drop column sex ;#column可加 可不加

-- 修改表字段类型 modify
alter table article modify id varchar(50);
alter table article modify password after name;
alter table article modify password varchar(64) first;

-- 修改表字段名字 change
alter table article change username name varchar(30);
alter table article change username name char(30) first;
alter table article change username name varchar(30) after age;
end ;

-- 【数据行的】操作（增、删、改、查）】
begin

增 insert
insert into articles values(18,'123456',1,1,'jiadong','武汉大东哥');
insert into articles(name,password,title,age) values('liangzai','654321','千锋靓仔',19);
insert into articles values(20,'123456789',3,0,'weiming','武汉大明.哥'),(20,'123456789',3,0,'weiming','武汉大明.哥'),(20,'123456789',3,0,'weiming','武汉大明.哥');#插入多条数据

删 delete
delete from 表名;#删除整张表的数据
delete from 表名 where 条件; #删除指定条件的数据
truncate table 表名; #也是删除整张表的数据
delete和truncate的区别:
delete from 表名; 清空数据以后 再次插入数据 id 从原来的id 往后顺延
truncate table 表名; 清空数据以后 再次插入数据 id 从1开始

改 update
update 表名 set 字段名1=值1，字段名2=值2 where 条件;

查 select
select 你要查询的字段名 from 表名 where 条件;



end ;







