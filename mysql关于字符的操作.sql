1、LOWER(column|str)：将字符串参数值转换为全小写字母后返回
select lower('adfCDF') ;

2、UPPER(column|str)：将字符串参数值转换为全大写字母后返回
select upper('adfCDF') ;

3、CONCAT(column|str1, column|str2,...)：将多个字符串参数首尾相连后返回
select concat(3,'asd','ASD',date(now())) ;

4、CONCAT_WS(separator,str1,str2,...)：将多个字符串参数以给定的分隔符separator首尾相连后返回
select concat_ws('$','asd','ASD',date(now())) ;

打开和关闭管道符号“|”的连接功能
|| 管道连接符：
mysql> select  列名1 || 列名2 || 列名3   from   表名;
在mysql中，进行上式连接查询之后，会将查询结果集在一列中显示(字符串连接)，列名是‘列名1 || 列名2 || 列名3’；
select * from t_student;
select id||sname||ssex from t_student;
①如果不显示结果，是因为sql_mode参数中没有PIPES_AS_CONCAT，只要给sql_mode参数加入PIPES_AS_CONCAT，就可以实现像CONCAT一样的功能；
②如果不给sql_mode参数加入PIPES_AS_CONCAT的话，|| 默认是or的意思，查询结果是一列显示是1。

5、SUBSTR(str,pos[,len])：从源字符串str中的指定位置pos开始取一个字串并返回
select substring('hello world',5);
select substring('hello world',-5);
select substring('hello world',5,3);

6、LENGTH(str)：返回字符串的存储长度 ;
select length('123456789') , length('你好');

7、CHAR_LENGTH(str)：返回字符串中的字符个数 ;
select char_length('123456789') , char_length('你好');

8、INSTR(str, substr)：从源字符串str中返回子串substr第一次出现的位置







