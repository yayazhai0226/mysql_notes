
【函数】【】【】【】【】
-- 无参的函数
CREATE FUNCTION	fn1()
RETURNS datetime
DETERMINISTIC
BEGIN
return NOW();
end;

SELECT fn1();

-- 有参的函数

CREATE function fn2(a INT,b INT)
RETURNS INT
BEGIN
	RETURN a + b;
END;

SELECT fn2(1,2)

-- 随机返回一个字符串。
drop function if exists get_room_id ;
create function get_room_id() 
returns char(32)
DETERMINISTIC
begin
declare i char(32) default '' ;
set i  = (select `name` from table_a order by rand() limit 1) ;
return i ;
end ;
select get_room_id() ;


【存储过程】【】【】【】
-- 无参的过程
drop procedure if EXISTS test.proc1;-- 删除存储过程
create procedure proc1()
begin
SELECT create_time;
end;
-- 调用存储过程,注意：存储过程名称后面必须加括号，哪怕该存储过程没有参数传递
call proc1();

-- 有参的过程
CREATE PROCEDURE `ADD_CUST` (IN c_name VARCHAR ( 20 ),IN c_num INTEGER,IN cred_lim DECIMAL ( 16, 2 ),IN tgt_sls DECIMAL ( 16, 2 ),IN c_rep INTEGER,IN c_offc VARCHAR ( 20 )) 
BEGIN
    INSERT INTO customers ( cust_num, company, cust_rep, credit_limit )
    VALUES
        ( c_num, c_name, c_rep, cred_lim );
    UPDATE salesreps 
    SET quota = quota + quota + tgt_sls 
    WHERE
        empl_num = c_rep;
    UPDATE offices 
    SET target = target + tgt_sls 
    WHERE
        city = c_offc;
    COMMIT;

END；
-- 调用存储过程
CALL `ADD_CUST` ( '李四', 504, 200.00, 500.00, 309, '广州' );

-- 【循环while】【】【】【】
CREATE PROCEDURE test_while_001(IN in_count INT) # 创建存储过程 学习while循环的用法
BEGIN
    DECLARE COUNT INT DEFAULT 0;
    DECLARE SUM INT DEFAULT 0;
    WHILE COUNT < in_count DO
        SET SUM = SUM + COUNT;
        SET COUNT = COUNT + 1;
    END WHILE;
    SELECT SUM;
END $$
DELIMITER ;

【if条件函数】【】【】【】

drop procedure if exists p_hello_world;
 
create procedure p_hello_world(in v_id int)
begin
    if (v_id > 0) then
        select '> 0';
    elseif (v_id = 0) then
        select '= 0';
    else
        select '< 0';
    end if;
end;
 select date(curdate()-1) ;

【游标】【】【】【】
游标的适用场景

存储过程
函数
触发器
事件

CREATE table temp(num1 int , num2 int)// -- 创建一个临时表，来存游标的数据

drop PROCEDURE if EXISTS apple//
create procedure apple() -- 存储过程
begin 

DECLARE done int DEFAULT 0 ; -- 状态为0
declare i1 int ;
declare i2 int ;
declare pp cursor for SELECT order_num , cust_id from orders ;  -- DECLARE 光标名称 CURSOR FOR 查询语法
DECLARE CONTINUE HANDLER FOR NOT found set done = 1 ; -- 当最后一行读完，状态为1

open pp ; -- 开启游标，OPEN 光标名称

loop1:loop -- 用一个循环取游标的数据
fethch pp into i1,i2 ; 
insert into temp(num1,num2) values (i1,i2) ; 
end loop ;-- 结束循环

close pp ;-- 关闭游标

end//





-- 创建临时表

drop TABLE if exists tmp_t_student ;
CREATE TABLE tmp_t_student like t_student ;
insert into tmp_t_student SELECT * from t_student where address = '北京' ;
select * from tmp_t_student ;

set @orbm_version = 2.3 ;#行为管理版本 2.3 3.0
select @orbm_version ;



