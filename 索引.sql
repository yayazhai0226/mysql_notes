怎么新增索引：

navicat 为表添加索引
分析常用的查询场景，为字段添加索引，增加查询速度。
可以添加单列索引，可以添加联合索引。




索引的使用：（普通索引，组合索引）
1. 如果针对单个字段进行查询，建立普通索引就满足了；
查看索引： show index from test_index;
创建索引：create index 索引名称 on 表名（字段名（字段长度））
create index title_index on test_index(title(10))
增加索引： alter table '表名' add index index_name on  字段名(字段长度)
删除索引： drop index 索引名称 on 表名;
drop index titile_index on test_index;

2. 如果是针对两个或两个以上条件的查询，就需要使用组合索引了；

将三个条件建立到一个索引里： ALTER TABLE 表名  ADD INDEX name_city_age(索引名) (Name(10),City,Age);
 # 如果分别在Name，City，Age上建立单列索引，让该表有3个单列索引，查询时比上述的组合索引效率一样吧？嘿嘿，大不一样，远远低于我们的组合索引！
# 组合索引遵循”最左前缀“原则             
ALTER TABLE 表名  ADD INDEX name_city_age(索引名) (Name(10),City,Age); 

        建立这样的组合索引，其实是相当于分别建立了三个组合索引：

               1）Name, City, Age

               2)  Name, City

               3)  Name

        简单的理解就是只从最左面的开始组合。并不是只要包含这三列的查询都会用到该组合索引，下面的几个T-SQL会用到：

       SELECT * FROM myIndex WHREE Name="erquan" AND City="郑州"

       SELECT * FROM myIndex WHREE Name="erquan"

        而下面几个则不会用到：    

       SELECT * FROM myIndex WHREE Age=20 AND City="郑州"

       SELECT * FROM myIndex WHREE City="郑州"

 
三，什么条件需使用索引   
       一般来说，在 where 和 join 中出现的列需要建立索引，但也不完全如此，因为MySQL只对 <，<=，=，>，>=，BETWEEN，IN，以及某些时候的LIKE(后面有说明)才会使用索引。  

      SELECT t.Name FROM testIndex t LEFT JOIN myIndex m ON t.Name=m.Name WHERE m.Age=20 AND m.City='郑州'  时，有对myIndex表的 City 和 Age 建立索引的需要，由于testIndex表的Name开出现在了JOIN子句中，也有对Name建立索引的必要（两个表的Name 都需要建索引）。 

刚才提到了，只有某些时候的LIKE才需建立索引？是的。因为在以通配符 % 和 _ 开头作查询时，MySQL不会使用索引，如

SELECT * FROM myIndex WHERE vc_Name like'erquan%'     会使用索引;

SELECT * FROM myIndex WHEREt vc_Name like'%erquan'    不会使用索引；

四. 索引不足之处：
        1. 虽然索引大大提高了查询速度，同时却会降低更新表的速度，如对表进行INSERT、UPDATE和DELETE。因为更新表时，MySQL不仅要保存数据，还要保存一下索引文件。

        2. 建立索引会占用磁盘空间的索引文件。一般情况这个问题不太严重，但如果你在一个大表上创建了多种组合索引，索引文件的会膨胀很快。

