  -- 1.不带返回值 默认值的存储过程的编写 
  use EASTEONE
  -- 判断存储过程名字是否存在 存在删除 注意：在执行完语句的时候要用go结束    
  if exists  
  (select name from sysobjects where name = 'up_getallstudents' and type = 'p' )
  drop procedure up_getallstudents 
  go   
  create procedure up_getallstudents
  as
  select * from student
  go
  -- 调用存储过程
  exec up_getallstudents;
  go
	
	
  -- 编写插入数据的存储过程
  create procedure up_insertstudent
  -- 传入的字段数据要加 @sid @sname 表示输入的参数
  @sid varchar(20),
  @sname varchar(30),
  @ssex char(3),
  @sbirth datetime,
  @sbirthplace varchar(60),
  @semail varchar(30)
  as
  begin
  insert into student
  (stu_id,stu_na,stu_s,stu_birth,stu_birthplace,stu_email)
  values
  (@sid,@sname,@ssex,@sbirth,@sbirthplace,@semail)
  end
  go
  exec up_insertstudent '201605','小雅','女','1992-06-06','鹤壁同城','xio@666'
  go
  --编写一个存储过程up_getstuinformationbystuId,根据输入的学生学号，显示该学生的学号、姓名、课程名和成绩
  drop procedure up_getstuinformationbystuId
  go
  create procedure up_getstuinformationbystuId
  @Sid varchar(20)
  as 
  begin
  select "S".stu_id, stu_na, cou_name, cou_score 
  from student "S", courses "C", stucourse "SC"
  where "S".stu_id = "SC".stu_id and "C".id="SC".cou_id and "S".stu_id = @Sid; 
  end
  go -- 调取存储过程
	
  exec up_getstuinformationbystuId '2016002'; 
  go

--  2、带输出参数
-- 在创建存储过程时，可以用关键字OUTPUT来创建一个输出参数，另外，调用时也必须给出OUTPUT关键字
-- 根据给定的学生姓名，
  use EASTEONE
  go
  create procedure getAvgscore
  @stuId varchar(30),@avgscore int output
  as 
  begin
  select @avgscore=avg(cou_score) from student s ,courses c ,stucourse sc
  where s.stu_id=sc.stu_id and sc.cou_id=c.id and s.stu_id=@stuId;
  end
  go
  -- 调用存储过程
  -- 声明一个变量
  declare @avgdcore int
  exec  getAvgscore '2016002' ,@avgdcore output
  print @avgdcore
  go
-- 3、带返回值的存储过程
-- （）print语句可以将用户定义的消息返回给客户端
-- 编写一个存储过程up_insertstudent2,在插入学生数据前，先判断一下学号是否存在，
-- 如果存在，输出“要插入的学生的学号已经存在”；否则，插入学生数据，并返回”恭喜，数据插入成功“

create procedure up_insertstudenttwo
  @sid varchar(20),
  @sname varchar(30),
  -- 默认值
  @ssex char(3)= '男',
  @sbirth datetime,
  @sbirthplace varchar(60),
  @semail varchar(30)
as
begin
if exists(select * from student s where s.stu_id=@sid)
print('要插入的学生学号已经存在')
else 
begin
insert into student
(stu_id,stu_na,stu_s,stu_birth,stu_birthplace,stu_email)
values
(
  @sid ,
  @sname ,
  @ssex,
  @sbirth ,
  @sbirthplace ,
  @semail 
)
print('插入成功')
end

end
go
exec up_insertstudenttwo '2016007','小王','男','2010-12-12','上海青浦','qq@666'
go

-- 4、带变量的存储过程
/*
  在存储过程可以定义变量，包含全局变量（@@变量名）和局部变量
  （@变量名）
  用于保存存储过程中的临时结果
  编写过程up_getavgscorebystuId,根据输入学生
  学号，计算机学生的平均成绩 。
  根据该生平均成绩和全体学生的平均成绩的关系，返回
  相应信息
*/
use EASTEONE
go
create procedure up_getavgscorebystuId
@sid varchar(20),@resStr varchar(30) output
as
begin
declare @curAvg decimal(18,2)
declare @totalAvg decimal(18,2)
select  @totalAvg=AVG(cou_score) from  courses
select  @curAvg=avg(cou_score) from student s,courses c,stucourse sc
where s.stu_id=sc.stu_id and c.id=sc.cou_id and s.stu_id=@sid;
if @curAvg>@totalAvg
set @resStr='高于平均分'
else
set @resStr='低于平均分'
print ('总平均数为'+convert(varchar(18),@totalAvg))
print ('该生的平均数为'+convert(varchar(18),@curAvg))
print @resStr
end
-- @resstring 这额变量可以随便写
declare @resstring varchar(30)
exec up_getavgscorebystuId '2016002',@resstring output
go
--5、使用output游标参数
--output 游标参数是用来将存储过程的局部
-- 局部游标
--存储过程的代码如下
create procedure up_getstudent_cursor
@student_cursor cursor varying output
as
begin
     set @student_cursor=cursor
     forward_only static for
     select stu_id, stu_na,stu_s, stu_birth,stu_birthplace,stu_email
     from student
     open @student_cursor
end
go
--过程存储
go
create procedure printstudentbycursor
as 
declare @Mycursor cursor
declare @sid varchar(20)
declare @sname varchar(30)
declare @ssex char(3)
declare @sbirth datetime
declare @sbirthplace varchar(60)
declare @semail varchar(30)
begin
exec up_getstudent_cursor @student_cursor=@Mycursor output
fetch next from @Mycursor into @sid ,@sname,@ssex,@sbirth,@sbirthplace,@semail
while(@@FETCH_STATUS=0)
begin
print('学号:'+@sid+'学生姓名：'+@sname+'学生性别：'+@ssex+'学生生日：'+convert(varchar(20),@sbirth,120)+'学生出生地：'+@sbirthplace+'学生邮箱：'+@semail)
fetch next from @Mycursor into @sid ,@sname,@ssex,@sbirth,@sbirthplace,@semail
end
close @Mycursor;
-- 释放资源
deallocate @Mycursor;
end
--调用存储过程
exec printstudentbycursor;
drop procedure printstudentbycursor;


insert into courses values(4,'音乐',88);
select * from courses;
select AVG(cou_score) from  courses;
go