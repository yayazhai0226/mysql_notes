drop procedure if exists bspods.p_opt_oper_person ;
create procedure bspods.p_opt_oper_person()
begin
-- -------------------------------
-- 描述: 人员到岗情况 (日统计)
-- 来源: 行为管理 2.3.8 手术排班 orbm_operation_schedule、衣服发放记录 orbm_dispenserecord、迟到记录表 orbm_comelaterecord、人员 orbm_user
-- 来源: 行为管理 3.0 手术排班 orbm_base_operation_schedule 手术排班参与术者信息 orbm_base_operation_person
-- 来源: 协同 恢复室、接送任务
-- 来源: 人力资源 as_base_user 人员、as_kq_attendance 考勤表
-- 目标: 全景驾驶舱当前运营状态监控 t_opt_oper_person 人员情况
-- 作者: yan
-- 时间: 2020-08-05 10:35:26
-- -------------------------------
-- 1、定义变量、初始化变量、前置处理
-- -------------------------------
declare continue handler for sqlexception set @error_info=@error_location;
set @error_location='前置处理';
set @procedure_name = 'p_opt_oper_person';                       -- 存储过程名称
-- 目标表
set @table_name = 'opt_oper_person';
-- 目标表时间字段
set @time_name = 'day';
-- 统计数据来源临时表
set @data_table_name = 'personinfo,kq_user,new_kq_user,operschedule,ctm_room,ctm_dept_room1,ctm_courtyard_room1,ctm_dept_room2,ctm_courtyard_room2';
set @data_table_name = concat(@data_table_name,',ctm_trans_task,ctm_trans_pacu_bed_apply,orbm_operation_schedule');
call p_bsp_business_before();                                  -- 运行前置存储过程
call p_bsp_dimension_courtyard();                              -- 父维度处理: 院区
call p_bsp_dimension_optdept();                                -- 父维度处理: 手术室
call p_bsp_dimension_optroom();                                -- 手术间、手术室、院区映射关系
set @orbm_version = 2.3;                                       -- 行为管理版本 2.3 3.0

-- 数据来源临时表的定义
create temporary table tmp_operschedule(courtyard_id varchar(50),opt_dept_id varchar(32),oper varchar(50),apply varchar(50),state varchar(50),
  operid varchar(128),region varchar(128));
truncate table bspanalysis.t_opt_oper_person;
-- 当日手术id、手术台次、关联的术者id、术者类型、术者迟到状态、院区id、手术室id、术者名称、手术间id
create temporary table tmp_personinfo(schedule_id varchar(32),times int(6),person_id varchar(32),staff_type varchar(2),staff_status varchar(2),
  arrive_time timestamp,courtyard_id varchar(32),opt_dept_id varchar(32),staff_name varchar(128),operation_room varchar(128)) engine=memory;
-- 恢复室对应的手术间、手术室、院区
create temporary table tmp_ctm_room(station_id varchar(128),ctm_room_id varchar(128),opt_room_id varchar(32),opt_dept_id varchar(32),
  courtyard_id varchar(32)) engine=memory;
create temporary table tmp_ctm_trans_task as select * from ctm_trans_task where create_time>=date(@day_time) and create_time<date(date_add(@day_time,interval 1 day));
create temporary table tmp_ctm_trans_pacu_bed_apply as select * from ctm_trans_pacu_bed_apply 
  where create_time>=date(@day_time) and create_time<date(date_add(@day_time,interval 1 day));

-- 2、数据取值、赋值、转换、运算
-- -------------------------------
set @error_location='行为 数据取值';
if @orbm_version=3.0 then
	insert into tmp_personinfo(schedule_id,times,person_id,staff_type,staff_status,staff_name,operation_room) 
		select a.schedule_id,a.sequence,b.person_id,b.person_type,b.arrival_status,b.person_name,a.operation_room from
		orbm_base_operation_schedule a, orbm_base_operation_person b where a.schedule_id = b.schedule_id 
		and a.start_time>=date(@day_time) and a.start_time<date(date_add(@day_time,interval 1 day));
	-- 转换手术间
	update tmp_personinfo a set a.operation_room
		=ifnull((select b.mapp_id from bspanalysis.t_analy_mapping_data b where a.operation_room=b.data_value and b.system_code='orbm' 
		and b.data_type='03' limit 1),a.operation_room);
end if;
if @orbm_version=2.3 then
  create table tmp_orbm_operation_schedule like orbm_operation_schedule;
	insert into tmp_orbm_operation_schedule select * from orbm_operation_schedule where
		scheduled_date_time>=date(@day_time) and scheduled_date_time<date(date_add(@day_time,interval 1 day));
		
	insert into tmp_personinfo(schedule_id,times,person_id,staff_type,staff_status,staff_name,operation_room) 
	  select id,jt,patient_id,'麻师','1',anesthesia_assistant_name,operating_room_no from tmp_orbm_operation_schedule;
	insert into tmp_personinfo(schedule_id,times,person_id,staff_type,staff_status,staff_name,operation_room) 
	  select id,jt,patient_id,'麻师','1',anesthesia_doctor_name,operating_room_no from tmp_orbm_operation_schedule;
	insert into tmp_personinfo(schedule_id,times,person_id,staff_type,staff_status,staff_name,operation_room) 
	  select id,jt,patient_id,'麻师','1',ANESTHESIA_SECOND_ASSISTANT_NAME,operating_room_no from tmp_orbm_operation_schedule;
	insert into tmp_personinfo(schedule_id,times,person_id,staff_type,staff_status,staff_name,operation_room) 
	  select id,jt,patient_id,'麻师','1',ANESTHESIA_THIRD_ASSISTANT_NAME,operating_room_no from tmp_orbm_operation_schedule;
	insert into tmp_personinfo(schedule_id,times,person_id,staff_type,staff_status,staff_name,operation_room) 
	  select id,jt,patient_id,'医生','1',surgeon_name,operating_room_no from tmp_orbm_operation_schedule;
  insert into tmp_personinfo(schedule_id,times,person_id,staff_type,staff_status,staff_name,operation_room) 
	  select id,jt,patient_id,'医生','1',FIRST_ASSISTANT_NAME,operating_room_no from tmp_orbm_operation_schedule;
	insert into tmp_personinfo(schedule_id,times,person_id,staff_type,staff_status,staff_name,operation_room) 
	  select id,jt,patient_id,'医生','1',SECOND_ASSISTANT_NAME,operating_room_no from tmp_orbm_operation_schedule;
	insert into tmp_personinfo(schedule_id,times,person_id,staff_type,staff_status,staff_name,operation_room) 
	  select id,jt,patient_id,'医生','1',THIRD_ASSISTANT_NAME,operating_room_no from tmp_orbm_operation_schedule;
	insert into tmp_personinfo(schedule_id,times,person_id,staff_type,staff_status,staff_name,operation_room) 
	  select id,jt,patient_id,'医生','1',fourth_assistant_name,operating_room_no from tmp_orbm_operation_schedule;
	insert into tmp_personinfo(schedule_id,times,person_id,staff_type,staff_status,staff_name,operation_room) 
	  select id,jt,patient_id,'医生','1',fifth_assistant_name,operating_room_no from tmp_orbm_operation_schedule;		
	insert into tmp_personinfo(schedule_id,times,person_id,staff_type,staff_status,staff_name,operation_room) 
	  select id,jt,patient_id,'医生','1',pour_into_doctor_name,operating_room_no from tmp_orbm_operation_schedule;
	insert into tmp_personinfo(schedule_id,times,person_id,staff_type,staff_status,staff_name,operation_room) 
	  select id,jt,patient_id,'医生','1',pour_into_first_assistant_name,operating_room_no from tmp_orbm_operation_schedule;
	insert into tmp_personinfo(schedule_id,times,person_id,staff_type,staff_status,staff_name,operation_room) 
	  select id,jt,patient_id,'医生','1',pour_into_second_assistant_name,operating_room_no from tmp_orbm_operation_schedule;
	insert into tmp_personinfo(schedule_id,times,person_id,staff_type,staff_status,staff_name,operation_room) 
	  select id,jt,patient_id,'医生','1',fifth_assistant_name,operating_room_no from tmp_orbm_operation_schedule;
	insert into tmp_personinfo(schedule_id,times,person_id,staff_type,staff_status,staff_name,operation_room) 
	  select id,jt,patient_id,'医生','1',fifth_assistant_name,operating_room_no from tmp_orbm_operation_schedule;
	insert into tmp_personinfo(schedule_id,times,person_id,staff_type,staff_status,staff_name,operation_room) 
	  select id,jt,patient_id,'医生','1',blood_tran_assistant_name,operating_room_no from tmp_orbm_operation_schedule;	
	insert into tmp_personinfo(schedule_id,times,person_id,staff_type,staff_status,staff_name,operation_room) 
	  select id,jt,patient_id,'护士','1',first_operation_nurse_name,operating_room_no from tmp_orbm_operation_schedule;
	insert into tmp_personinfo(schedule_id,times,person_id,staff_type,staff_status,staff_name,operation_room)
	  select id,jt,patient_id,'护士','1',second_operation_nurse_name,operating_room_no from tmp_orbm_operation_schedule;		
	insert into tmp_personinfo(schedule_id,times,person_id,staff_type,staff_status,staff_name,operation_room) 
	  select id,jt,patient_id,'护士','1',first_supply_nurse_name,operating_room_no from tmp_orbm_operation_schedule;
	insert into tmp_personinfo(schedule_id,times,person_id,staff_type,staff_status,staff_name,operation_room) 
	  select id,jt,patient_id,'护士','1',second_supply_nurse_name,operating_room_no from tmp_orbm_operation_schedule;
		
	update tmp_personinfo a set a.staff_status = ifnull((select '迟到' from orbm_comelaterecord b,orbm_user c where a.staff_name=c.`name`
	  and b.OperateionTime>=date(@day_time) and b.OperateionTime<date(date_add(@day_time,interval 1 day)) and b.userid=c.userid limit 1),a.staff_status);
	update tmp_personinfo a set a.staff_status = ifnull((select '在岗' from orbm_dispenserecord b,orbm_user c where a.staff_name=c.`name`
	  and b.CreateTime>=date(@day_time) and b.CreateTime<date(date_add(@day_time,interval 1 day)) and b.userid=c.userid limit 1),a.staff_status)
		where a.staff_status='1';
	-- 转换手术间
	update tmp_personinfo a set a.operation_room
		=ifnull((select b.mapp_id from bspanalysis.t_analy_mapping_data b where a.operation_room=b.data_code and b.system_code='orbm' 
		and b.data_type='03' limit 1),a.operation_room);
end if;
-- 转换手术室/院区
update tmp_personinfo a set a.opt_dept_id
	=ifnull((select b.opt_dept_id from tmp_dimension_optroom b where a.operation_room=b.opt_room_id limit 1),a.opt_dept_id);
update tmp_personinfo a set a.courtyard_id
	=ifnull((select b.courtyard_id from tmp_dimension_optroom b where a.operation_room=b.opt_room_id limit 1),a.courtyard_id);

set @error_location='人力 数据取值';
-- 当日考勤记录
create temporary table tmp_kq_user(courtyard_id varchar(50),opt_dept_id varchar(32),room_id varchar(32),staff_name varchar(32),staff_status varchar(128));
insert ignore into tmp_kq_user(room_id,staff_status) select a.operid,a.userid from as_dayschedule a
  where a.DutyDay>=date(@day_time) and a.DutyDay<date(date_add(@day_time,interval 1 day));
update tmp_kq_user a set a.staff_name=(select b.username from as_kq_attendance b where a.staff_status=b.userid 
  and b.WorkDate>=date(@day_time) and b.WorkDate<date(date_add(@day_time,interval 1 day)) limit 1);
update tmp_kq_user a set a.staff_status=(select b.workbeginstatus from as_kq_attendance b where a.staff_status=b.userid 
  and b.WorkDate>=date(@day_time) and b.WorkDate<date(date_add(@day_time,interval 1 day)) limit 1);

-- 当日考勤记录更新院区、手术间映射关系
update tmp_kq_user a set a.room_id
  =ifnull((select b.mapp_id from bspanalysis.t_analy_mapping_data b where a.room_id=b.data_id and b.system_code='as' and b.data_type='03' limit 1),a.room_id);
update tmp_kq_user a set a.courtyard_id
  =ifnull((select b.courtyard_id from tmp_dimension_optroom b where a.room_id=b.opt_room_id limit 1),a.courtyard_id);
update tmp_kq_user a set a.opt_dept_id
  =ifnull((select b.opt_dept_id from tmp_dimension_optroom b where a.room_id=b.opt_room_id limit 1),a.opt_dept_id);

-- 明日手术排班
insert into tmp_operschedule(courtyard_id,oper,apply,state,operid,region) select region,opernumber,applynumber,state,operid,region from as_operschedule 
  where date(operdate)>=date(date_add(@day_time,interval 1 day)) and date(operdate)<date(date_add(@day_time,interval 2 day));
-- 明日手术排班更新院区、手术间映射关系
update tmp_operschedule a set a.operid
  =(select b.mapp_id from bspanalysis.t_analy_mapping_data b where a.operid=b.data_id and b.system_code='as' and b.data_type='03' limit 1) where  a.operid!='0';
update tmp_operschedule a set a.opt_dept_id
  =(select b.mapp_id from bspanalysis.t_analy_mapping_data b where a.region=b.data_id and b.system_code='as' and b.data_type='02' limit 1);
update tmp_operschedule a set a.courtyard_id
  =ifnull((select b.courtyard_id from tmp_dimension_optroom b where a.opt_dept_id=b.opt_dept_id limit 1),a.courtyard_id);

set @error_location='数据赋值';
insert into tmp_opt_oper_person(oper_person_id,courtyard_id,opt_dept_id,day) select replace(uuid(),'-',''),name_id,mapp_id,@day_time 
  from `bspanalysis`.t_analy_region_config group by mapp_id,name_id;

set @error_location='数据来源 行为管理';
if @orbm_version=2.3 then
	-- 1. 在岗情况-护士
	call p_bsp_set_one_value('on_gard_nurse_num','(select count(distinct b.staff_name) from tmp_personinfo b where a.opt_dept_id=b.opt_dept_id 
	  and b.staff_type="护士" and b.staff_status!="1")');
	-- 2. 在岗情况-医师
	call p_bsp_set_one_value('on_gard_doctor_num','(select count(distinct b.staff_name) from tmp_personinfo b where a.opt_dept_id=b.opt_dept_id 
	  and b.staff_type="医生" and b.staff_status!="1")');
  -- 3. 在岗情况-麻师
	call p_bsp_set_one_value('on_gard_anesthetist_num','(select count(distinct b.staff_name) from tmp_personinfo b where a.opt_dept_id=b.opt_dept_id 
	  and b.staff_type="麻师" and b.staff_status!="1")');
	-- 4. 首台迟到-护士
	call p_bsp_set_one_value('first_nurse_late_num','(select count(distinct b.staff_name) from tmp_personinfo b where a.opt_dept_id=b.opt_dept_id 
	  and b.staff_type="护士" and b.staff_status="迟到" and b.times="1")');
	-- 5. 首台迟到-医师
	call p_bsp_set_one_value('first_doctor_late_num','(select count(distinct b.staff_name) from tmp_personinfo b where a.opt_dept_id=b.opt_dept_id 
	  and b.staff_type="医生" and b.staff_status="迟到" and b.times="1")');
	-- 6. 首台迟到-麻师
	call p_bsp_set_one_value('first_anesthetist_late_num','(select count(distinct b.staff_name) from tmp_personinfo b where a.opt_dept_id=b.opt_dept_id 
	  and b.staff_type="麻师" and b.staff_status="迟到" and b.times="1")');
end if;
if @orbm_version=3.0 then
	-- 1. 在岗情况-护士
	call p_bsp_set_one_value('on_gard_nurse_num','(select count(1) from tmp_personinfo b where a.opt_dept_id=b.opt_dept_id 
	  and b.staff_type in ("50", "51"))');
	-- 2. 在岗情况-医师
	call p_bsp_set_one_value('on_gard_doctor_num','(select count(1) from tmp_personinfo b where a.opt_dept_id=b.opt_dept_id 
	  and b.staff_type in ("10", "11", "30", "31", "40", "41"))');
	-- 3. 在岗情况-麻师
	call p_bsp_set_one_value('on_gard_anesthetist_num','(select count(1) from tmp_personinfo b where a.opt_dept_id=b.opt_dept_id 
	  and b.staff_type in ("20", "21"))');
	-- 4. 首台迟到-护士
	call p_bsp_set_one_value('first_nurse_late_num','(select count(1) from tmp_personinfo b where a.opt_dept_id=b.opt_dept_id 
	  and b.staff_type in ("50", "51") and b.times="1" and b.staff_status="2")');
	-- 5. 首台迟到-医师
	call p_bsp_set_one_value('first_doctor_late_num','(select count(1) from tmp_personinfo b where a.opt_dept_id=b.opt_dept_id 
	  and b.staff_type in ("10", "11", "30", "31", "40", "41") and b.times="1" and b.staff_status="2")');
	-- 6. 首台迟到-麻师
	call p_bsp_set_one_value('first_anesthetist_late_num','(select count(1) from tmp_personinfo b where a.opt_dept_id=b.opt_dept_id 
	  and b.staff_type in ("20", "21") and b.times="1" and b.staff_status="2")');
end if;
 
set @error_location='数据来源 人力资源';
-- 7. 护士迟到
call p_bsp_set_one_value('nurse_late_num','(select count(distinct b.staff_name) from tmp_kq_user b where a.opt_dept_id=b.opt_dept_id and b.staff_status="2")');
-- 8. 护士缺卡
call p_bsp_set_one_value('nurse_lackcard_num','(select count(distinct b.staff_name) from tmp_kq_user b where a.opt_dept_id=b.opt_dept_id and b.staff_status="5")');

set @error_location='数据来源 人力资源手术排班';
-- 16. 明日手术-已申请
call p_bsp_set_one_value('applyed_opt_num','(select count(1) from tmp_operschedule b where a.opt_dept_id=b.opt_dept_id)');
-- 17. 明日手术-不安排
call p_bsp_set_one_value('no_deal_opt_num','(select count(1) from tmp_operschedule b where a.opt_dept_id=b.opt_dept_id and b.operid="0")');
-- 18. 明日手术-已安排
drop table if exists tmp_num;
create temporary table tmp_num(room_id varchar(32),seq varchar(32),opt_dept_id varchar(32),num int) engine=memory;
insert into tmp_num select operid,oper,opt_dept_id,1 from tmp_operschedule where operid!="0" group by operid,oper,opt_dept_id;
delete from tmp_num where seq is null or room_id is null or length(seq)=0;
update tmp_num a set a.num=(select count(1) from tmp_operschedule b where a.room_id=b.operid and a.seq=b.oper and a.opt_dept_id=b.opt_dept_id);
call p_bsp_set_one_value('dealed_opt_num','(select sum(b.num) from tmp_num b where a.opt_dept_id=b.opt_dept_id)');
delete from tmp_num where num<2;
call p_bsp_set_one_value('dealed_opt_num','(dealed_opt_num-ifnull((select sum(b.num) from tmp_num b where a.opt_dept_id=b.opt_dept_id),0))');
drop table if exists tmp_num;
-- 19. 明日手术-待分配
call p_bsp_set_one_value('dealing_opt_num','(applyed_opt_num-no_deal_opt_num-dealed_opt_num)');

set @error_location='数据来源 协同管理';
-- 获取恢复室和手术间、手术室、院区的关系
alter table tmp_ctm_room add constraint ctm_room_id unique (ctm_room_id,station_id);
insert ignore into tmp_ctm_room(ctm_room_id,station_id) select room_id,area_id from ctm_base_room_station;
insert ignore into tmp_ctm_room(ctm_room_id) select room_id from tmp_ctm_trans_pacu_bed_apply;
insert ignore into tmp_ctm_room(ctm_room_id) select room_id from ctm_trans_task;
update tmp_ctm_room a set a.opt_room_id
  =ifnull((select b.mapp_id from bspanalysis.t_analy_mapping_data b where a.ctm_room_id=b.data_id and b.system_code='ctm' 
	and b.data_type='03' limit 1),a.ctm_room_id);
update tmp_ctm_room a set a.opt_dept_id
	=ifnull((select b.opt_dept_id from tmp_dimension_optroom b where a.opt_room_id=b.opt_room_id limit 1),a.opt_dept_id);
update tmp_ctm_room a set a.courtyard_id
	=ifnull((select b.courtyard_id from tmp_dimension_optroom b where a.opt_room_id=b.opt_room_id limit 1),a.courtyard_id);
delete from tmp_ctm_room where opt_dept_id is null;
create table tmp_ctm_dept_room1 as select * from tmp_ctm_room group by station_id,opt_dept_id;
create table tmp_ctm_courtyard_room1 as select * from tmp_ctm_room group by station_id,courtyard_id;
create table tmp_ctm_dept_room2 as select * from tmp_ctm_room group by station_id,opt_dept_id,ctm_room_id;
create table tmp_ctm_courtyard_room2 as select * from tmp_ctm_room group by station_id,courtyard_id,ctm_room_id;

-- 9. 恢复室总床位数
call p_bsp_set_one_value('recovery_bed_num','(select sum(b.config_value) from ctm_base_pacu_config b,tmp_ctm_dept_room1 c 
  where a.opt_dept_id=c.opt_dept_id and c.station_id=b.area_id)');
-- 10. 正在使用的床位数
call p_bsp_set_one_value('recoveery_usingbed_num','(select count(distinct b.apply_id) from tmp_ctm_trans_pacu_bed_apply b,tmp_ctm_dept_room1 c
  where b.status in (3) and a.opt_dept_id=c.opt_dept_id and c.station_id=b.area_id)'); 
-- 11. 已预定的床位数
call p_bsp_set_one_value('recovery_reservebed_num','(select count(distinct b.apply_id) from tmp_ctm_trans_pacu_bed_apply b,tmp_ctm_dept_room1 c
  where b.status in (2,3)and a.opt_dept_id=c.opt_dept_id and c.station_id=b.area_id)'); 
-- 12. 等待审核的床位数
call p_bsp_set_one_value('recovery_auditingbed_num','(select count(distinct b.apply_id) from tmp_ctm_trans_pacu_bed_apply b,tmp_ctm_dept_room1 c
  where b.status in (1) and a.opt_dept_id=c.opt_dept_id and c.station_id=b.area_id)'); 
-- 13. 已完成接送任务
call p_bsp_set_one_value('picked_up_task_num','(select count(distinct b.task_id) from tmp_ctm_trans_task b,tmp_ctm_dept_room2 c 
  where b.task_status=3 and b.room_id=c.ctm_room_id and a.opt_dept_id=c.opt_dept_id)');
-- 14. 正在进行中的任务
call p_bsp_set_one_value('running_task_num','(select count(distinct b.task_id) from tmp_ctm_trans_task b,tmp_ctm_dept_room2 c 
  where b.task_status=2 and b.room_id=c.ctm_room_id and a.opt_dept_id=c.opt_dept_id)');
-- 15. 等待接收的任务
call p_bsp_set_one_value('waiting_task_num','(select count(distinct b.task_id) from tmp_ctm_trans_task b,tmp_ctm_dept_room2 c 
  where b.task_status=1 and b.room_id=c.ctm_room_id and a.opt_dept_id=c.opt_dept_id)');

set @error_location='统计所有手术室';
insert tmp_all_opt_oper_person(oper_person_id,courtyard_id,opt_dept_id,day,dealing_opt_num,dealed_opt_num,no_deal_opt_num,applyed_opt_num,waiting_task_num,running_task_num
  ,picked_up_task_num,recovery_auditingbed_num,recovery_reservebed_num,recoveery_usingbed_num,recovery_bed_num,first_nurse_late_num,first_anesthetist_late_num
	,first_doctor_late_num,nurse_lackcard_num,nurse_late_num,on_gard_doctor_num,on_gard_anesthetist_num,on_gard_nurse_num) 
  select replace(uuid(),'-',''),courtyard_id,opt_dept_id,day,sum(dealing_opt_num),sum(dealed_opt_num),sum(no_deal_opt_num),sum(applyed_opt_num),sum(waiting_task_num)
	,sum(running_task_num),sum(picked_up_task_num),sum(recovery_auditingbed_num),sum(recovery_reservebed_num),sum(recoveery_usingbed_num),sum(recovery_bed_num)
	,sum(first_nurse_late_num),sum(first_anesthetist_late_num),sum(first_doctor_late_num),sum(nurse_lackcard_num),sum(nurse_late_num),sum(on_gard_doctor_num)
	,sum(on_gard_anesthetist_num),sum(on_gard_nurse_num) 
  from tmp_opt_oper_person group by day,opt_dept_id;
set @error_location='统计所有院区';
insert tmp_all_opt_oper_person(oper_person_id,courtyard_id,opt_dept_id,day,dealing_opt_num,dealed_opt_num,no_deal_opt_num,applyed_opt_num,waiting_task_num,running_task_num
  ,picked_up_task_num,recovery_auditingbed_num,recovery_reservebed_num,recoveery_usingbed_num,recovery_bed_num,first_nurse_late_num,first_anesthetist_late_num
	,first_doctor_late_num,nurse_lackcard_num,nurse_late_num,on_gard_doctor_num,on_gard_anesthetist_num,on_gard_nurse_num) 
  select replace(uuid(),'-',''),courtyard_id,'100000',day,sum(dealing_opt_num),sum(dealed_opt_num),sum(no_deal_opt_num),sum(applyed_opt_num),sum(waiting_task_num)
	,sum(running_task_num),sum(picked_up_task_num),sum(recovery_auditingbed_num),sum(recovery_reservebed_num),sum(recoveery_usingbed_num),sum(recovery_bed_num)
	,sum(first_nurse_late_num),sum(first_anesthetist_late_num),sum(first_doctor_late_num),sum(nurse_lackcard_num),sum(nurse_late_num),sum(on_gard_doctor_num)
	,sum(on_gard_anesthetist_num),sum(on_gard_nurse_num) 
  from tmp_opt_oper_person group by day,courtyard_id;
call p_bsp_set_many_value('all_opt_oper_person','recovery_bed_num','(select sum(b.config_value) from ctm_base_pacu_config b,tmp_ctm_courtyard_room1 c 
  where a.courtyard_id=c.courtyard_id and c.station_id=b.area_id) where a.opt_dept_id="100000"');
call p_bsp_set_many_value('all_opt_oper_person','recoveery_usingbed_num','(select count(distinct b.apply_id) from tmp_ctm_trans_pacu_bed_apply b,tmp_ctm_courtyard_room1 c
  where b.status in (3) and a.courtyard_id=c.courtyard_id and c.station_id=b.area_id) where a.opt_dept_id="100000"'); 
call p_bsp_set_many_value('all_opt_oper_person','recovery_reservebed_num','(select count(distinct b.apply_id) from tmp_ctm_trans_pacu_bed_apply b,tmp_ctm_courtyard_room1 c
  where b.status in (2,3) and a.courtyard_id=c.courtyard_id and c.station_id=b.area_id) where a.opt_dept_id="100000"'); 
call p_bsp_set_many_value('all_opt_oper_person','recovery_auditingbed_num','(select count(distinct b.apply_id) from tmp_ctm_trans_pacu_bed_apply b,tmp_ctm_courtyard_room1 c
  where b.status in (1) and a.courtyard_id=c.courtyard_id and c.station_id=b.area_id) where a.opt_dept_id="100000"'); 
call p_bsp_set_many_value('all_opt_oper_person','picked_up_task_num','(select count(distinct b.task_id) from tmp_ctm_trans_task b,tmp_ctm_courtyard_room2 c 
  where b.task_status=3 and b.room_id=c.ctm_room_id and a.courtyard_id=c.courtyard_id) where a.opt_dept_id="100000"');
call p_bsp_set_many_value('all_opt_oper_person','running_task_num','(select count(distinct b.task_id) from tmp_ctm_trans_task b,tmp_ctm_courtyard_room2 c  
  where b.task_status=2 and b.room_id=c.ctm_room_id and a.courtyard_id=c.courtyard_id) where a.opt_dept_id="100000"');
call p_bsp_set_many_value('all_opt_oper_person','waiting_task_num','(select count(distinct b.task_id) from tmp_ctm_trans_task b,tmp_ctm_courtyard_room2 c 
  where b.task_status=1  and b.room_id=c.ctm_room_id and a.courtyard_id=c.courtyard_id) where a.opt_dept_id="100000"');

set @error_location='统计全院区';
insert tmp_all_opt_oper_person(oper_person_id,courtyard_id,opt_dept_id,day,dealing_opt_num,dealed_opt_num,no_deal_opt_num,applyed_opt_num,waiting_task_num,running_task_num
  ,picked_up_task_num,recovery_auditingbed_num,recovery_reservebed_num,recoveery_usingbed_num,recovery_bed_num,first_nurse_late_num,first_anesthetist_late_num
	,first_doctor_late_num,nurse_lackcard_num,nurse_late_num,on_gard_doctor_num,on_gard_anesthetist_num,on_gard_nurse_num) 
  select replace(uuid(),'-',''),'100000','100000',day,sum(dealing_opt_num),sum(dealed_opt_num),sum(no_deal_opt_num),sum(applyed_opt_num),sum(waiting_task_num)
	,sum(running_task_num),sum(picked_up_task_num),sum(recovery_auditingbed_num),sum(recovery_reservebed_num),sum(recoveery_usingbed_num),sum(recovery_bed_num)
	,sum(first_nurse_late_num),sum(first_anesthetist_late_num),sum(first_doctor_late_num),sum(nurse_lackcard_num),sum(nurse_late_num),sum(on_gard_doctor_num)
	,sum(on_gard_anesthetist_num),sum(on_gard_nurse_num) 
  from tmp_opt_oper_person group by day;
call p_bsp_set_many_value('all_opt_oper_person','recovery_bed_num','(select sum(b.config_value) from ctm_base_pacu_config b,tmp_ctm_courtyard_room1 c 
  where c.station_id=b.area_id) where a.opt_dept_id="100000" and a.courtyard_id="100000"');
call p_bsp_set_many_value('all_opt_oper_person','recoveery_usingbed_num','(select count(distinct b.apply_id) from tmp_ctm_trans_pacu_bed_apply b,tmp_ctm_courtyard_room1 c
  where b.status in (3) and c.station_id=b.area_id) where a.opt_dept_id="100000" and a.courtyard_id="100000"'); 
call p_bsp_set_many_value('all_opt_oper_person','recovery_reservebed_num','(select count(distinct b.apply_id) from tmp_ctm_trans_pacu_bed_apply b,tmp_ctm_courtyard_room1 c
  where b.status in (2,3) and c.station_id=b.area_id) where a.opt_dept_id="100000" and a.courtyard_id="100000"'); 
call p_bsp_set_many_value('all_opt_oper_person','recovery_auditingbed_num','(select count(distinct b.apply_id) from tmp_ctm_trans_pacu_bed_apply b,tmp_ctm_courtyard_room1 c
  where b.status in (1) and c.station_id=b.area_id) where a.opt_dept_id="100000" and a.courtyard_id="100000"'); 
call p_bsp_set_many_value('all_opt_oper_person','picked_up_task_num','(select count(distinct b.task_id) from tmp_ctm_trans_task b,tmp_ctm_courtyard_room2 c 
  where b.task_status=3 and b.room_id=c.ctm_room_id) where a.opt_dept_id="100000" and a.courtyard_id="100000"');
call p_bsp_set_many_value('all_opt_oper_person','running_task_num','(select count(distinct b.task_id) from tmp_ctm_trans_task b,tmp_ctm_courtyard_room2 c
  where b.task_status=2 and b.room_id=c.ctm_room_id) where a.opt_dept_id="100000" and a.courtyard_id="100000"');
call p_bsp_set_many_value('all_opt_oper_person','waiting_task_num','(select count(distinct b.task_id) from tmp_ctm_trans_task b,tmp_ctm_courtyard_room2 c
  where b.task_status=1 and b.room_id=c.ctm_room_id) where a.opt_dept_id="100000" and a.courtyard_id="100000"');

delete from tmp_opt_oper_person where (courtyard_id,opt_dept_id) in (select courtyard_id,opt_dept_id from tmp_all_opt_oper_person);
insert ignore into tmp_opt_oper_person select * from tmp_all_opt_oper_person;

-- 3、后置处理、保存数据
-- -------------------------------
call p_bsp_business_after();
end ;

call p_bsp_test_select_init('2020-08-21','租户id,id（唯一,数据创建时间');
call bspods.p_opt_oper_person();
call p_bsp_test_select_data('t_opt_oper_person');

