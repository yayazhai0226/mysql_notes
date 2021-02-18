-- 从另个一个地方同步导数据过来。
TRUNCATE bsp_courtyard;
insert into bsp_courtyard select * from `bsp2`.t_bsp_courtyard;#可以从同一个数据库地址的不同的库里拷贝数据。

-- for循环
drop table if EXISTS temp_table ;
create table temp_table (id int auto_increment not null, province varchar(20),primary key(id)) engine=InnoDB auto_increment=101;
insert temp_table (province) values('江苏省'),('广东'),('浙江省'),('山东'),('山西省');
select * from temp_table;

-- 游标
delimiter //  # 定义//为一句sql的结束标志，取消;的所代表的意义
drop procedure if exists test;  # 如果存在名字为test的procedure则删除
create procedure test()  # 创建（创建函数使用的关键字为function 函数名()）
begin
    declare old_pro varchar(30);  # 声明变量
    declare temp_id int;
    declare flag int default 0;
    # 这是重点，定义一个游标来记录sql查询的结果(此处的知识点还有SQL的模糊查询，见补充)
    declare s_list cursor for select id, province from temp_table where  province  like '%省'; 
    # 为下面while循环建立一个退出标志，当游标遍历完后将flag的值设置为1
    declare continue handler for not found set flag=1;
    open s_list;  # 打开游标
    # 将游标中的值赋给定义好的变量，实现for循环的要点
        fetch s_list into temp_id, old_pro;
        while flag <> 1 do
            # sql提供了字符串的切分，有left、right、substring、substring_index
            # 在T-SQL中，局部变量必须以@作为前缀，声明方式set，select还有点差别
            set @temp_s = substring_index(old_pro, "省", 1);
            # 根据id的唯一性，利用当前查询到的记录中的字段值来实现更新
            update temp_table set province=@temp_s where id=temp_id;
            # 游标往后移（此处的游标是不是让你想起了C里面的指针）
            fetch s_list into temp_id, old_pro;
        end while;
        #select * from temp_table;
    close s_list;  # 关闭游标
end
//
delimiter ;  # 重新定义;为一句sql的结束标志，取消//的所代表的意义