engine 是为表指定用哪一种数据库引擎.
(
engine=memory是指这张表作为一张内存zhi表.内存表的特点是读写快,但重启dao后会清空.并且对字段大小和类型有要求,
详细的可以搜索一下mysql的数据库引擎介绍,
常用的几种类型为myisam ,innodb,memory,



1.常用的3种 

2.InnoDB、 Myisam、 Memory

3.InnoDB跟Myisam的默认索引是B+tree，Memory的默认索引是hash

区别：

1.InnoDB支持事务，支持外键，支持行锁，写入数据时操作快，MySQL5.6版本以上才支持全文索引

2.Myisam不支持事务。不支持外键，支持表锁，支持全文索引，读取数据快

3.Memory所有的数据都保留在内存中,不需要进行磁盘的IO所以读取的速度很快, 、

   但是一旦关机的话表的结构会保留但是数据就会丢失,表支持Hash索引，因此查找速度很快
	 	 )
	 
	 