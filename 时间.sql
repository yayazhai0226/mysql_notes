【时间格式的转换】
字符串到时间格式
Str_to_date('2020-06-06 00:00:00','%Y-%m-%d %H:%i:%s');

【MySQL DATE_SUB() 函数】

DATE_SUB(date,INTERVAL expr type)
/*Type 值
MICROSECOND
SECOND
MINUTE
HOUR
DAY
WEEK
MONTH
QUARTER
YEAR
SECOND_MICROSECOND
MINUTE_MICROSECOND
MINUTE_SECOND
HOUR_MICROSECOND
HOUR_SECOND
HOUR_MINUTE
DAY_MICROSECOND
DAY_SECOND
DAY_MINUTE
DAY_HOUR
YEAR_MONTH
*/

-- 显示隔天时间/日期
SELECT DATE_SUB(now() , INTERVAL -5 DAY) AS OrderPayDate ; # subtract 减去，减少 ； interval 间隔 ；
select date_sub(date(now()) , interval -1 day) ;
SELECT DATE_SUB('2020-08-02' , INTERVAL -1 DAY) AS OrderPayDate ;
SELECT DATE_SUB('05:05:05' , INTERVAL -1 HOUR) AS OrderPayDate ;


-- 时间：时分秒转成秒
SELECT SEC_TO_TIME(42360);
SELECT TIME_TO_SEC('03:45:48') ;
-- 但是TIME_TO_SEC 是把 时分秒转为 秒，并不会对年月日进行处理；

drop procedure if exists p10 ;
CREATE PROCEDURE p10 ()   
BEGIN   
DECLARE a, b char(32) DEFAULT '2020-08-02' ;   
select a , b ;  
END;
call p10() ;


DECLARE i char ;
set i = '2020-08-02' ;
select i ;
while   do 


end while ;