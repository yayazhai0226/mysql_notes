Mysql存储过程查询结果赋值到变量的方法


drop procedure IF EXISTS pro_test_3;
06
delimiter //
07
create procedure pro_test_3()
08
begin
09
--  方式 1
10
    DECLARE cnt INT DEFAULT 0;
11
    select count(*) into cnt from test_tbl;
12
    select cnt;
		
		 
14
--  方式 2
15
    set @cnt = (select count(*) from test_tbl);
16
    select @cnt;
17
 
18
--  方式 3
19
    select count(*) into @cnt1 from test_tbl;
20
    select @cnt1;
		
		
		end ; 