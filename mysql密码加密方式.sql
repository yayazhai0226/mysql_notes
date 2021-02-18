select password('123456') ;
SHOW VARIABLES LIKE 'validate_password%';#查看初始化密码策略
set global validate_password_policy = 0 ;#设置密码的验证强度等级
set global validate_password_length = 6 ;#密码长度
/*
关于 mysql 密码策略相关参数；
1）、validate_password_length  固定密码的总长度；
2）、validate_password_dictionary_file 指定密码验证的文件路径；
3）、validate_password_mixed_case_count  整个密码中至少要包含大/小写字母的总个数；
4）、validate_password_number_count  整个密码中至少要包含阿拉伯数字的个数；
5）、validate_password_policy 指定密码的强度验证等级，默认为 MEDIUM；
关于 validate_password_policy 的取值：
0/LOW：只验证长度；
1/MEDIUM：验证长度、数字、大小写、特殊字符；
2/STRONG：验证长度、数字、大小写、特殊字符、字典文件；
6）、validate_password_special_char_count 整个密码中至少要包含特殊字符的个数；
关于 mysql 密码策略问题 就解决了
*/


/*
1、第一种加密方式，password()函数，使用MySQLSHA1（安全Hash算法）进行加密
mysql一般的加密方式是password('root')将root在数据库客户端以40位字符串显示出来。这个40位字符串是来自于mysql的密码库。如果要改用户名密码的话update t_user set password=password('root') where username='Jim'，将用户名为Jim的密码修改为root。
两次用password()函数给root字符串加密，得出来的结果一样，说明密码产生自mysql的密码库
*/
select password('root') ;

/*
2、第二种加密方式，old_password()函数，方法和password()函数加密的方式一样，但是加密的效果查了一点。也是产生自mysql密码库
*/
select old_password('root') ;

/*
3、第三种加密方式，使用encode和decode的加密，但是前提是mysql字段类型要是blob的

如图，密码是‘123456’，在插入成功之后只有插入的人自己知道密码了，其他人在数据库中查询只查询到乱码。还原密码使用decode函数，如下图所示

*/
insert into t_user values(ENCODE('123456','abcdef')) ;
SELECT * from t_user ;

select decode(password,'abcdef') from t_user ;
/*
4、第四种方式使用MD5函数进行加密，如下图，MD5函数的使用，跟password()加密的效果差不多，无法反向解密这个密码。只有写入人自己知道


*/

insert into t_user values(md5('999999')) ;
