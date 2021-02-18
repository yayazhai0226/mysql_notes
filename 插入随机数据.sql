#UUID



#创建表：

CREATE table table_a(`id` int(10) not null default 0 , `name` char(50) default null , primary key (`id`)) ENGINE = INNODB default CHARSET = utf8 ;#也可以不定义引擎和字符集，默认。

#创建产生随机字符串的函数：
set global log_bin_trust_function_creators = 1;
DROP FUNCTION IF EXISTS rand_string;
DELIMITER // #定义结束符号，默认是分号“;”.
CREATE FUNCTION rand_string(n INT)
RETURNS VARCHAR(255)

BEGIN
        DECLARE chars_str varchar(100) DEFAULT 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
        DECLARE return_str varchar(255) DEFAULT '';
        DECLARE i INT DEFAULT 0;
        WHILE i < n DO
                SET return_str = concat(return_str,substring(chars_str , FLOOR(1 + RAND()*62 ),1)); #substring 函数：提取自字符串，包含字符串，位置，长度
                SET i = i +1;
        END WHILE;
        RETURN return_str;
END //
delimiter ; 
select rand_string(9) ;

#创建插入表的procedure,x是从多少开始。y是多少结束，z是产生多少位随机数
delimiter // 
create procedure test(x int(10),y int(10),z int(10))
begin
  DECLARE i INT DEFAULT x;
  while i<y do
 insert into tables_a values(i,rand_string(z));
 set i=i+1;
 end while ;
 end ;
call test(5,5,6) ;

 
 /*
 mysql随机数据生成并插入

dblp数据库中引用信息很少，平均一篇论文引用0.2篇。使用dblp做实验数据集的某篇论文提到，可以随机添加引用信息。受此启发，我打算为每一篇论文都添加20篇随机引用，于是就写出了如下的sql语句：

String sql = "insert into citation(pId1,pId2) values( (select pId from papers limit ?,1),(select pId from papers limit ?,1))";

使用preparedstatement，以batch方式提交数据库。

第一个参数是paper的rowid信息，从0~N（N为papers的total row）。第二个参数是Java生成的20个不重复的随机数，范围是0-N。然后嵌套在for循环里，每1w条数据提交给数据库一次。

这段代码巧妙运用limit的特性完成随机选tuple，本来是暗暗得意的。自以为把所有的select都交给数据库去做了，省去了通过jdbc的多次连接，应该是很快就可以运行完成的。哪知，插了不过10w条（10000*10）数据，就耗时22分钟之多。最终的实验需要插入400w条数据，也就是说要花14h左右。

于是开始反思，不断做写类似的程序查找时间瓶颈，最终锁定在select limit，这个操作极耗时间。当初选用limit，原因在于：随机生成的是数字，要把数字映射到tuple，也就是对应到rowid；由于papers表的主键并非递增int，所以默认的rowid不存在。后来一想，可以在papers表上先增加一个auto_increment的temp列，完成citation插入后再删除。这样sql语句就改成了：

String sql = "insert into citation(pId1,pId2) values((select pId from papers where temp=?), (select pId from papers where temp=?))";

再一次插入10w条数据，耗时38s。效率大幅提高，但不知道还可不可以进一步优化。*/
 
 
 
 