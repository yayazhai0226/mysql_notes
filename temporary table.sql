-- 关于 temporary table
(
首先是上面提到的他的引擎类型，然后temp table还不支持在集群中使用。
第三show tables命令不显示temp table
第四不支持rename 但可以alter table 
第五就是关于replication时的注意事项。
)


TEMPORARY table  有什么优点：
(
什么时候用：
1。当你需要保存中间结果的时候使用，比如在vb中你要保存一串数据的时候，你可以建立一个数组，然后用循环访问数据或付值，但在sqlserver中没有数组，你可以将一串数据存储到临时表中，用游标或select ，insert,update语句访问。
2。建立复杂的结果集（比如很复杂的报表），用一条语句不能实现。可以建立临时表生成需要的数据。
有点：
1。不同间连接之间不冲突，虽然在操作同一个数据库，建立同一个临时表。但sqlserver的控制机制是他们之间决不冲突。
2。操作数据不屑你的数据库日志，不至于造成日志膨胀。
3。临时表一般在内存中。存取速度快

)

(
create temporary table tmp_ctm_room(station_id varchar(128),ctm_room_id varchar(128),opt_room_id varchar(32),opt_dept_id varchar(32),courtyard_id varchar(32)) engine=memory;
create temporary table tmp_ctm_trans_task as select * from ctm_trans_task where create_time>=date(@day_time) and create_time<date(date_add(@day_time,interval 1 day));

insert into tmp_personinfo(schedule_id,times,person_id,staff_type,staff_status,staff_name,operation_room) 
		select a.schedule_id,a.sequence,b.person_id,b.person_type,b.arrival_status,b.person_name,a.operation_room from
		orbm_base_operation_schedule a, orbm_base_operation_person b where a.schedule_id = b.schedule_id 
		and a.start_time>=date(@day_time) and a.start_time<date(date_add(@day_time,interval 1 day));

update tmp_personinfo a set a.operation_room
		=ifnull((select b.mapp_id from bspanalysis.t_analy_mapping_data b where a.operation_room=b.data_code and b.system_code='orbm' 
		and b.data_type='03' limit 1),a.operation_room);

)





	
	
	