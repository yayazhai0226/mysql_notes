
-- 【1】插入排班
drop PROCEDURE if exists zyj_insert_opt_schedule ;
CREATE DEFINER=`root`@`%` PROCEDURE `zyj_insert_opt_schedule`(in sch_date char(32) , in department_id char(32) , in dpt_name varchar(128) ,in opt_room_id char(32) ,in opt_room_name varchar(128) , in opt_sequence varchar(4))
#(手术日期，科室id，科室名称，手术间id，手术间名称，手术台次)
begin
INSERT INTO `bspods`.`bsp_operation_schedule`(`schedule_id`, `department_id`, `department_name`, `courtyard_id`, `his_code`, `source`, `operation_code`, `operation_no`, `operation_name`, `operation_type`, `operation_category`, `branch_name`, `operate_room_id`, `operate_room_name`, `before_operate_room_id`, `sequence`, `sequence_before`, `apply_sequence`, `work_start_time`, `work_end_time`, `start_time`, `end_time`, `plan_start_time`, `plan_end_time`, `reservation_time`, `patient_id`, `patient_name`, `patient_age`, `patient_gender`, `visit_no`, `emergercy_indicator`, `inpatient_area`, `hospitalization_no`, `bed_no`, `input_diagnose`, `diagnose_remark`, `anesthesia_method`, `diagnose`, `arrive_time`, `departure_time`, `anesthesia_time`, `skin_cut_time`, `prepare_status`, `schedule_status`, `status`, `operation_remark`, `remark`, `create_time`, `update_time`, `tenant_id`, `skin_sew_time`) VALUES (concat(sch_date , '_dong_',substr(opt_room_id , 28),'_', opt_sequence), department_id , dpt_name , '40288afb72cb0b290173271029ba019a', concat('his',schedule_id) , '1', '00003', NULL, '东手术1', '1', '1', NULL, opt_room_id,opt_room_name , NULL,opt_sequence , NULL, '1', NULL, NULL, NULL, NULL, NULL, NULL, concat(sch_date , ' 00:00:00'), 'dong_patient01', '一乙', NULL, '1', NULL, '1', '急诊区', NULL, '111114', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, now(), now(), NULL, NULL);-- 随机or指定 排班急诊类型
UPDATE bspods.bsp_operation_schedule set emergercy_indicator = FLOOR(1 + rand()*2) where courtyard_id = '40288afb72cb0b290173271029ba019a' and reservation_time = concat(sch_date , ' 00:00:00') and schedule_id = concat(sch_date , '_dong_',substr(opt_room_id , 28),'_', opt_sequence);
end ;

-- 【2】插入手术各个动作的时间
drop PROCEDURE if EXISTS zyj_insert_opt_time ;
CREATE DEFINER=`root`@`%` PROCEDURE `zyj_insert_opt_time`(in opt_room_id char(32) , in opt_sequence varchar(4) , in opt_special_type varchar(128) , in opt_date VARCHAR(32))
#(手术间id，手术台次，正常还是未完成，手术日期)
begin

if (opt_sequence = '1' and opt_special_type = '已完成') then
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('work_start', opt_room_id, opt_sequence, concat(opt_date,' 08:00:00') ,concat(opt_date , ' 00:00:00'));
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('anesthesia', opt_room_id, opt_sequence, concat(opt_date,' 08:30:00'), concat(opt_date , ' 00:00:00'));
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('opt_start', opt_room_id, opt_sequence, concat(opt_date,' 08:30:00'), concat(opt_date , ' 00:00:00')) ;
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('skin_cut', opt_room_id, opt_sequence, concat(opt_date,' 09:00:00'), concat(opt_date , ' 00:00:00'));
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('skin_sew', opt_room_id, opt_sequence, concat(opt_date,' 10:00:00'), concat(opt_date , ' 00:00:00')) ;
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('opt_end', opt_room_id, opt_sequence, concat(opt_date,' 10:30:00'), concat(opt_date , ' 00:00:00')) ;
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('work_end', opt_room_id, opt_sequence, concat(opt_date ,' 11:00:00'), concat(opt_date , ' 00:00:00')) ;

elseif (opt_sequence = '2' and opt_special_type = '已完成') then
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('work_start', opt_room_id, opt_sequence, concat(opt_date ,' 12:00:00'), concat(opt_date , ' 00:00:00')) ;
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('anesthesia', opt_room_id, opt_sequence, concat(opt_date ,' 12:30:00'), concat(opt_date , ' 00:00:00'));
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('opt_start', opt_room_id, opt_sequence, concat(opt_date ,' 12:30:00'), concat(opt_date , ' 00:00:00')) ;
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('skin_cut', opt_room_id, opt_sequence, concat(opt_date ,' 13:00:00'), concat(opt_date , ' 00:00:00'));
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('skin_sew', opt_room_id, opt_sequence, concat(opt_date ,' 14:00:00'), concat(opt_date , ' 00:00:00')) ;
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('opt_end', opt_room_id, opt_sequence, concat(opt_date ,' 14:30:00'), concat(opt_date , ' 00:00:00')) ;
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('work_end', opt_room_id, opt_sequence, concat(opt_date ,' 15:00:00'), concat(opt_date , ' 00:00:00')) ;

elseif (opt_sequence = '3' and opt_special_type = '已完成') then
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('work_start', opt_room_id, opt_sequence, concat(opt_date ,' 16:00:00'), concat(opt_date , ' 00:00:00')) ;
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('anesthesia', opt_room_id, opt_sequence, concat(opt_date ,' 16:30:00'), concat(opt_date , ' 00:00:00'));
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('opt_start', opt_room_id, opt_sequence, concat(opt_date ,' 16:30:00'), concat(opt_date , ' 00:00:00')) ;
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('skin_cut', opt_room_id, opt_sequence, concat(opt_date ,' 17:00:00'), concat(opt_date , ' 00:00:00'));
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('skin_sew', opt_room_id, opt_sequence, concat(opt_date ,' 18:00:00'), concat(opt_date , ' 00:00:00')) ;
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('opt_end', opt_room_id, opt_sequence, concat(opt_date ,' 18:30:00'), concat(opt_date , ' 00:00:00')) ;
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('work_end', opt_room_id, opt_sequence, concat(opt_date ,' 19:00:00'), concat(opt_date , ' 00:00:00')) ;

elseif (opt_sequence = '1' and opt_special_type = '进行中') then
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('work_start', opt_room_id, opt_sequence, concat(opt_date,' 08:00:00') ,concat(opt_date , ' 00:00:00'));
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('anesthesia', opt_room_id, opt_sequence, concat(opt_date,' 08:30:00'), concat(opt_date , ' 00:00:00'));
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('opt_start', opt_room_id, opt_sequence, concat(opt_date,' 08:30:00'), concat(opt_date , ' 00:00:00')) ;
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('skin_cut', opt_room_id, opt_sequence, concat(opt_date,' 09:00:00'), concat(opt_date , ' 00:00:00'));
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('skin_sew', opt_room_id, opt_sequence, NULL, concat(opt_date , ' 00:00:00'));
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('opt_end', opt_room_id, opt_sequence, NULL, concat(opt_date , ' 00:00:00'));
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('work_end', opt_room_id, opt_sequence, NULL, concat(opt_date , ' 00:00:00'));

elseif (opt_sequence = '2' and opt_special_type = '进行中') then
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('work_start', opt_room_id, opt_sequence, concat(opt_date ,' 12:00:00'), concat(opt_date , ' 00:00:00')) ;
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('anesthesia', opt_room_id, opt_sequence, concat(opt_date ,' 12:30:00'), concat(opt_date , ' 00:00:00'));
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('opt_start', opt_room_id, opt_sequence, concat(opt_date ,' 12:30:00'), concat(opt_date , ' 00:00:00')) ;
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('skin_cut', opt_room_id, opt_sequence, concat(opt_date ,' 13:00:00'), concat(opt_date , ' 00:00:00'));
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('skin_sew', opt_room_id, opt_sequence, NULL, concat(opt_date , ' 00:00:00'));
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('opt_end', opt_room_id, opt_sequence, NULL, concat(opt_date , ' 00:00:00'));
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('work_end', opt_room_id, opt_sequence, NULL, concat(opt_date , ' 00:00:00'));

elseif (opt_sequence = '3' and opt_special_type = '进行中') then
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('work_start', opt_room_id, opt_sequence, concat(opt_date ,' 16:00:00'), concat(opt_date , ' 00:00:00')) ;
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('anesthesia', opt_room_id, opt_sequence, concat(opt_date ,' 16:30:00'), concat(opt_date , ' 00:00:00'));
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('opt_start', opt_room_id, opt_sequence, concat(opt_date ,' 16:30:00'), concat(opt_date , ' 00:00:00')) ;
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('skin_cut', opt_room_id, opt_sequence, concat(opt_date ,' 17:00:00'), concat(opt_date , ' 00:00:00'));
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('skin_sew', opt_room_id, opt_sequence, NULL, concat(opt_date , ' 00:00:00'));
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('opt_end', opt_room_id, opt_sequence, NULL, concat(opt_date , ' 00:00:00'));
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('work_end', opt_room_id, opt_sequence, NULL, concat(opt_date , ' 00:00:00'));

elseif (opt_sequence = '1' and opt_special_type = '未开始') then
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('work_start', opt_room_id, opt_sequence,  NULL, concat(opt_date , ' 00:00:00'));
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('anesthesia', opt_room_id, opt_sequence, NULL, concat(opt_date , ' 00:00:00'));
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('opt_start', opt_room_id, opt_sequence,  NULL, concat(opt_date , ' 00:00:00'));
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('skin_cut', opt_room_id, opt_sequence,  NULL, concat(opt_date , ' 00:00:00'));
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('skin_sew', opt_room_id, opt_sequence, NULL, concat(opt_date , ' 00:00:00'));
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('opt_end', opt_room_id, opt_sequence, NULL, concat(opt_date , ' 00:00:00'));
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('work_end', opt_room_id, opt_sequence, NULL, concat(opt_date , ' 00:00:00'));

elseif (opt_sequence = '2' and opt_special_type = '未开始') then
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('work_start', opt_room_id, opt_sequence,  NULL, concat(opt_date , ' 00:00:00'));
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('anesthesia', opt_room_id, opt_sequence, NULL, concat(opt_date , ' 00:00:00'));
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('opt_start', opt_room_id, opt_sequence,  NULL, concat(opt_date , ' 00:00:00'));
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('skin_cut', opt_room_id, opt_sequence,  NULL, concat(opt_date , ' 00:00:00'));
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('skin_sew', opt_room_id, opt_sequence, NULL, concat(opt_date , ' 00:00:00'));
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('opt_end', opt_room_id, opt_sequence, NULL, concat(opt_date , ' 00:00:00'));
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('work_end', opt_room_id, opt_sequence, NULL, concat(opt_date , ' 00:00:00'));

elseif (opt_sequence = '3' and opt_special_type = '未开始') then
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('work_start', opt_room_id, opt_sequence,  NULL, concat(opt_date , ' 00:00:00'));
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('anesthesia', opt_room_id, opt_sequence, NULL, concat(opt_date , ' 00:00:00'));
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('opt_start', opt_room_id, opt_sequence,  NULL, concat(opt_date , ' 00:00:00'));
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('skin_cut', opt_room_id, opt_sequence,  NULL, concat(opt_date , ' 00:00:00'));
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('skin_sew', opt_room_id, opt_sequence, NULL, concat(opt_date , ' 00:00:00'));
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('opt_end', opt_room_id, opt_sequence, NULL, concat(opt_date , ' 00:00:00'));
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('work_end', opt_room_id, opt_sequence, NULL, concat(opt_date , ' 00:00:00'));

else 
select "没有这种情况" ;
end if ;
-- select * from ods_operation_schedule where room_id = opt_room_id and reservation_time = concat(opt_date , ' 00:00:00');
end ;

-- 【1+2】联合创建排班和时间。(把需要设计的放在方法内部，本方法就专门用来管理手术日期)
DROP PROCEDURE if exists zyj_insert_opt_schedule_union ;
CREATE PROCEDURE zyj_insert_opt_schedule_union (in opt_date char(32))
begin

select a.courtyard_id ,a.courtyard_name , b.department_id , b.department_name , c.operate_room_id , c.operate_room_name , d.patient_id , d.patient_name from bsp2.t_bsp_courtyard a , bsp2.t_bsp_department b , bsp2.t_bsp_operate_room c , bsp2.t_bsp_patient d where a.courtyard_name = '东院' and b.department_name = '口腔科' and operate_room_name = '手术间4' and d.patient_name = '一乙'; #直接查出院区，科室，手术间，患者；【辅助语句】

#插排班
DELETE from bsp_operation_schedule where schedule_id like concat(date(opt_date) , '%') and courtyard_id = '40288afb72cb0b290173271029ba019a';#删除重复的某日期排班

call zyj_insert_opt_schedule(opt_date,'40288afb7370596a0173c1865ac501a9','心内科','40288afb7370596a0173c188a5b501ae','手术间1','1') ;#【1】(手术日期，科室id，科室名称，手术间id，手术间名称，手术台次)
call zyj_insert_opt_schedule(opt_date,'40288afb7370596a0173c1865ac501a9','心内科','40288afb7370596a0173c188a5b501ae','手术间1','2') ;#【1】(手术日期，科室id，科室名称，手术间id，手术间名称，手术台次)
call zyj_insert_opt_schedule(opt_date,'40288afb7370596a0173c1865ac501a9','心内科','40288afb7370596a0173c188a5b501ae','手术间1','3') ;#【1】(手术日期，科室id，科室名称，手术间id，手术间名称，手术台次)

call zyj_insert_opt_schedule(opt_date,'40288afb7370596a0173c1860f5501a8','肝脏外科','40288afb7370596a0173c188a5b501af','手术间2','1') ;#【1】(手术日期，科室id，科室名称，手术间id，手术间名称，手术台次)
call zyj_insert_opt_schedule(opt_date,'40288afb7370596a0173c1860f5501a8','肝脏外科','40288afb7370596a0173c188a5b501af','手术间2','2') ;#【1】(手术日期，科室id，科室名称，手术间id，手术间名称，手术台次)
call zyj_insert_opt_schedule(opt_date,'40288afb7370596a0173c1860f5501a8','肝脏外科','40288afb7370596a0173c188a5b501af','手术间2','3') ;#【1】(手术日期，科室id，科室名称，手术间id，手术间名称，手术台次)

call zyj_insert_opt_schedule(opt_date,'40288afb7370596a0173c186f89b01ab','胸外科','40288afb7370596a0173c188a5b501ag','手术间3','1') ;#【1】(手术日期，科室id，科室名称，手术间id，手术间名称，手术台次)
call zyj_insert_opt_schedule(opt_date,'40288afb7370596a0173c186f89b01ab','胸外科','40288afb7370596a0173c188a5b501ag','手术间3','2') ;#【1】(手术日期，科室id，科室名称，手术间id，手术间名称，手术台次)
call zyj_insert_opt_schedule(opt_date,'40288afb7370596a0173c186f89b01ab','胸外科','40288afb7370596a0173c188a5b501ag','手术间3','3') ;#【1】(手术日期，科室id，科室名称，手术间id，手术间名称，手术台次)

call zyj_insert_opt_schedule(opt_date,'40288afb7370596a0173c1874b1a01ac','口腔科','40288afb7370596a0173c188a5b501ah','手术间4','1') ;#【1】(手术日期，科室id，科室名称，手术间id，手术间名称，手术台次)
call zyj_insert_opt_schedule(opt_date,'40288afb7370596a0173c1874b1a01ac','口腔科','40288afb7370596a0173c188a5b501ah','手术间4','2') ;#【1】(手术日期，科室id，科室名称，手术间id，手术间名称，手术台次)
call zyj_insert_opt_schedule(opt_date,'40288afb7370596a0173c1874b1a01ac','口腔科','40288afb7370596a0173c188a5b501ah','手术间4','3') ;#【1】(手术日期，科室id，科室名称，手术间id，手术间名称，手术台次)

call zyj_insert_opt_schedule(opt_date,'40288afb75e4c3f801761c327b730052','耳鼻咽喉和最长是','40288afb7370596a0173c188a5b501ai','手术间5','1') ;#【1】(手术日期，科室id，科室名称，手术间id，手术间名称，手术台次)
call zyj_insert_opt_schedule(opt_date,'40288afb75e4c3f801761c327b730052','耳鼻咽喉和最长是','40288afb7370596a0173c188a5b501ai','手术间5','2') ;#【1】(手术日期，科室id，科室名称，手术间id，手术间名称，手术台次)
call zyj_insert_opt_schedule(opt_date,'40288afb75e4c3f801761c32bb590053','某科室002','40288afb7370596a0173c188a5b501ai','手术间5','3') ;#【1】(手术日期，科室id，科室名称，手术间id，手术间名称，手术台次)

call zyj_insert_opt_schedule(opt_date,'40288afb75e4c3f801761c32e8e20054','某科室003','40288afb7370596a0173c188a5b501aj','手术间6','1') ;#【1】(手术日期，科室id，科室名称，手术间id，手术间名称，手术台次)
call zyj_insert_opt_schedule(opt_date,'40288afb75e4c3f801761c3318e10055','某科室004','40288afb7370596a0173c188a5b501aj','手术间6','2') ;#【1】(手术日期，科室id，科室名称，手术间id，手术间名称，手术台次)


call zyj_insert_opt_schedule(opt_date,'40288afb75e4c3f801761c3346a20056','某科室005','40288afb75e4c3f801761c353afb005c','手术间7','1') ;#【1】(手术日期，科室id，科室名称，手术间id，手术间名称，手术台次)
call zyj_insert_opt_schedule(opt_date,'40288afb75e4c3f801761c3346a20056','某科室005','40288afb75e4c3f801761c353afb005c','手术间7','2') ;#【1】(手术日期，科室id，科室名称，手术间id，手术间名称，手术台次)
call zyj_insert_opt_schedule(opt_date,'40288afb75e4c3f801761c336f370057','某科室006','40288afb75e4c3f801761c353afb005c','手术间7','3') ;#【1】(手术日期，科室id，科室名称，手术间id，手术间名称，手术台次)


call zyj_insert_opt_schedule(opt_date,'40288afb75e4c3f801761c3399c40058','某科室007','40288afb75e4c3f801761c357983005e','手术间8','1') ;#【1】(手术日期，科室id，科室名称，手术间id，手术间名称，手术台次)
call zyj_insert_opt_schedule(opt_date,'40288afb75e4c3f801761c33c02a0059','某科室008','40288afb75e4c3f801761c357983005e','手术间8','2') ;#【1】(手术日期，科室id，科室名称，手术间id，手术间名称，手术台次)


call zyj_insert_opt_schedule(opt_date,'40288afb75e4c3f801761c33ea76005a','某科室009','40288afb75e4c3f801761c35bedd0060','手术间9','1') ;#【1】(手术日期，科室id，科室名称，手术间id，手术间名称，手术台次)
call zyj_insert_opt_schedule(opt_date,'40288afb75e4c3f801761c341a23005b','某科室010','40288afb75e4c3f801761c35bedd0060','手术间9','2') ;#【1】(手术日期，科室id，科室名称，手术间id，手术间名称，手术台次)
call zyj_insert_opt_schedule(opt_date,'40288afb75e4c3f801761c341a23005b','某科室010','40288afb75e4c3f801761c35bedd0060','手术间9','3') ;#【1】(手术日期，科室id，科室名称，手术间id，手术间名称，手术台次)



#插动作时间
DELETE from bspods.ods_operation_schedule where room_id in ('40288afb7370596a0173c188a5b501af','40288afb7370596a0173c188a5b501ae','40288afb7370596a0173c188a5b501ag','40288afb7370596a0173c188a5b501ah') and reservation_time = concat(opt_date , ' 00:00:00');# 删除这些手术间重复的时间
call zyj_insert_opt_time('40288afb7370596a0173c188a5b501af','1','已完成',opt_date) ;#【2】(手术间id，手术台次，正常还是未完成，手术日期)
call zyj_insert_opt_time('40288afb7370596a0173c188a5b501af','2','进行中',opt_date) ;#【2】(手术间id，手术台次，正常还是未完成，手术日期)
call zyj_insert_opt_time('40288afb7370596a0173c188a5b501af','3','未开始',opt_date) ;#【2】(手术间id，手术台次，正常还是未完成，手术日期)
call zyj_insert_opt_time('40288afb7370596a0173c188a5b501ae','1','已完成',opt_date) ;#【2】(手术间id，手术台次，正常还是未完成，手术日期)
call zyj_insert_opt_time('40288afb7370596a0173c188a5b501ae','2','进行中',opt_date) ;#【2】(手术间id，手术台次，正常还是未完成，手术日期)
call zyj_insert_opt_time('40288afb7370596a0173c188a5b501ae','3','未开始',opt_date) ;#【2】(手术间id，手术台次，正常还是未完成，手术日期)
call zyj_insert_opt_time('40288afb7370596a0173c188a5b501ag','1','已完成',opt_date) ;#【2】(手术间id，手术台次，正常还是未完成，手术日期)
call zyj_insert_opt_time('40288afb7370596a0173c188a5b501ag','2','已完成',opt_date) ;#【2】(手术间id，手术台次，正常还是未完成，手术日期)
call zyj_insert_opt_time('40288afb7370596a0173c188a5b501ag','3','进行中',opt_date) ;#【2】(手术间id，手术台次，正常还是未完成，手术日期)
call zyj_insert_opt_time('40288afb7370596a0173c188a5b501ah','1','已完成',opt_date) ;#【2】(手术间id，手术台次，正常还是未完成，手术日期)
call zyj_insert_opt_time('40288afb7370596a0173c188a5b501ah','2','已完成',opt_date) ;#【2】(手术间id，手术台次，正常还是未完成，手术日期)
call zyj_insert_opt_time('40288afb7370596a0173c188a5b501ah','3','已完成',opt_date) ;#【2】(手术间id，手术台次，正常还是未完成，手术日期)

call zyj_insert_opt_time('40288afb7370596a0173c188a5b501ai','1','已完成',opt_date) ;#【2】(手术间id，手术台次，正常还是未完成，手术日期)
call zyj_insert_opt_time('40288afb7370596a0173c188a5b501ai','2','已完成',opt_date) ;#【2】(手术间id，手术台次，正常还是未完成，手术日期)
call zyj_insert_opt_time('40288afb7370596a0173c188a5b501ai','3','已完成',opt_date) ;#【2】(手术间id，手术台次，正常还是未完成，手术日期)

call zyj_insert_opt_time('40288afb7370596a0173c188a5b501aj','1','已完成',opt_date) ;#【2】(手术间id，手术台次，正常还是未完成，手术日期)
call zyj_insert_opt_time('40288afb7370596a0173c188a5b501aj','2','进行中',opt_date) ;#【2】(手术间id，手术台次，正常还是未完成，手术日期)

call zyj_insert_opt_time('40288afb75e4c3f801761c353afb005c','1','已完成',opt_date) ;#【2】(手术间id，手术台次，正常还是未完成，手术日期)
call zyj_insert_opt_time('40288afb75e4c3f801761c353afb005c','2','已完成',opt_date) ;#【2】(手术间id，手术台次，正常还是未完成，手术日期)
call zyj_insert_opt_time('40288afb75e4c3f801761c353afb005c','3','进行中',opt_date) ;#【2】(手术间id，手术台次，正常还是未完成，手术日期)

call zyj_insert_opt_time('40288afb75e4c3f801761c357983005e','1','已完成',opt_date) ;#【2】(手术间id，手术台次，正常还是未完成，手术日期)
call zyj_insert_opt_time('40288afb75e4c3f801761c357983005e','2','未开始',opt_date) ;#【2】(手术间id，手术台次，正常还是未完成，手术日期)

call zyj_insert_opt_time('40288afb75e4c3f801761c35bedd0060','1','已完成',opt_date) ;#【2】(手术间id，手术台次，正常还是未完成，手术日期)
call zyj_insert_opt_time('40288afb75e4c3f801761c35bedd0060','2','已完成',opt_date) ;#【2】(手术间id，手术台次，正常还是未完成，手术日期)
call zyj_insert_opt_time('40288afb75e4c3f801761c35bedd0060','3','进行中',opt_date) ;#【2】(手术间id，手术台次，正常还是未完成，手术日期)


end ;











call zyj_insert_opt_schedule_union('2020-12-02') ;#【1+2】创建该日期的排班和时间，需要设计基础数据（科室、手术间、台次、是否完成等信息），请在本方法内部进行更改。

SELECT schedule_id,department_name,operate_room_name,start_time,anesthesia_time,skin_cut_time,emergercy_indicator '急诊标识' FROM `bsp_operation_schedule` where courtyard_id = '40288afb72cb0b290173271029ba019a' ORDER BY schedule_id desc;#看一下赋值情况


-- 运行22 给排班添加上时间；再运行43 把数据算出来
-- 定时器
-- drop EVENT if EXISTS event_update_todayschedule ;
-- show events where db in ('bspods' , 'bsp2' , 'bspanalysis') ;








