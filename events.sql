drop event if exists insert_data ;
create event insert_data
on schedule every 3 second starts '2020-09-23 01:00:00' ends  '2025-10-01 01:00:00'
on completion preserve 
#当为on completion preserve 的时候,当event到期了,event会被disable,但是该event还是会存在；当为on completion not preserve的时候,当event到期的时候,该event会被自动删除掉.
do
INSERT INTO `test`.`temp_table`(`province`) VALUES ('山西省');

set global EVENT_scheduler = 1 ; #让mysql自动启动计划任务
alter event insert_data enable ;
show VARIABLES like 'insert%' ;#了解mysql运行时详细运行参数
show events where db in ('test') ;#查询指定数据库中的事件

-- delete from temp_table where id >= 105 ;


#注：do后面只能接一个语句—————可以串讲创建多重存储过程。实现一句执行多句的目的




mysql的定时触发的event建好后没有发生预定的事件，归纳起来有以下几种：
1.全局的event 是关闭的：
  实际上mysql的event默认值是off
  查看event是否开启: show variables like 'event_scheduler';
   将event事件计划开启: set global event_scheduler=1;
	 
	 
有时候event运行一段时间，电脑重启后，event失效了。在生产环境这种事是不允许发生的
怎么办？
--------系统重启后，event自动关闭的解决方法-----------------
my.ini（windows） or my.cnf（linux） 中的
[mysqld]
添加 event_scheduler=ON

 
2.用户权限的修改导致event失效，
这种情况很少发生，但发生后又找不到问题，那就看看你建的event所属者有没有这个执行权限吧
如： DEFINER=`root`@`127.0.0.1`
    select * from mysql.user where Host='127.0.0.1'

查看127.0.0.1这个ip有没有执行的权限


3.event 设成了DISABLE; 这种情况
这里以test_event为例：
关闭事件任务: alter event test_event ON COMPLETION PRESERVE DISABLE; 
开户事件任务: alter event test_event ON COMPLETION PRESERVE ENABLE;

查看所有 event:  SHOW EVENTS;
或者  select * from information_schema.EVENTS;

4.查看一下err log,如果event正常运行，并且检查PROCEDURE没有错误，那就有可能是PROCEDURE在执行过程中报错，这部分报错会记录到error日志中
比如，今天遇到的问题就是
阿里云上某环境中的归档event执行不成功，经过检查，确认event正常执行(select * from information_schema.EVENTS;);并且用户权限也都没有问题
[GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, RELOAD, PROCESS, REFERENCES, INDEX, ALTER, CREATE TEMPORARY TABLES, LOCK TABLES, EXECUTE, REPLICATION SLAVE, REPLICATION CLIENT, CREATE VIEW, SHOW VIEW, CREATE ROUTINE, ALTER ROUTINE, CREATE USER, EVENT, TRIGGER ON *.* TO 'user'@'10.60.40.%' WITH GRANT OPTION;].

之后检查日志，发现 有一个主键冲突，经过比对分析，删除归档表中该主键记录。等待下一次event执行验证
