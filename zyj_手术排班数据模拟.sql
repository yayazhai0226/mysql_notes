
-- 插入排班
DELETE from bspods.bsp_operation_schedule where courtyard_id = '40288afb7370596a01737557b6ee0015' ;
drop PROCEDURE if exists zyj_insert_opt_schedule ;
CREATE DEFINER=`root`@`%` PROCEDURE `zyj_insert_opt_schedule`(in schedule_id char(32) , in department_id char(32) , in dpt_name varchar(128) ,in opt_room_id char(32) ,in opt_room_name varchar(128) , in opt_sequence varchar(4))
begin
INSERT INTO `bspods`.`bsp_operation_schedule`(`schedule_id`, `department_id`, `department_name`, `courtyard_id`, `his_code`, `source`, `operation_code`, `operation_no`, `operation_name`, `operation_type`, `operation_category`, `branch_name`, `operate_room_id`, `operate_room_name`, `before_operate_room_id`, `sequence`, `sequence_before`, `apply_sequence`, `work_start_time`, `work_end_time`, `start_time`, `end_time`, `plan_start_time`, `plan_end_time`, `reservation_time`, `patient_id`, `patient_name`, `patient_age`, `patient_gender`, `visit_no`, `emergercy_indicator`, `inpatient_area`, `hospitalization_no`, `bed_no`, `input_diagnose`, `diagnose_remark`, `anesthesia_method`, `diagnose`, `arrive_time`, `departure_time`, `anesthesia_time`, `skin_cut_time`, `prepare_status`, `schedule_status`, `status`, `operation_remark`, `remark`, `create_time`, `update_time`, `tenant_id`, `skin_sew_time`) VALUES (schedule_id, department_id , dpt_name , '40288afb7370596a01737557b6ee0015', concat('his',schedule_id) , '1', '00003', NULL, '南手术1', '1', '1', NULL, opt_room_id,opt_room_name , NULL,opt_sequence , NULL, '1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1000002', '一乙', NULL, '1', NULL, '1', '急诊区', NULL, '111114', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, now(), now(), NULL, NULL);
end ;

call zyj_insert_opt_schedule('2020-08-01nan001','40288afb732dc2f601734c16a0b70081','南科室a','40288afb7370596a0173755905550017','南手术间1','1') ;#(id,科室id,科室名称,手术间id,手术间名称,手术台次)
call zyj_insert_opt_schedule('2020-08-01nan002','40288afb732dc2f601734c16a0b70081','南科室a','40288afb7370596a0173755905550017','南手术间1','2') ;
call zyj_insert_opt_schedule('2020-08-01nan003','40288afb732dc2f601734c164a810080','南科室b','40288afb7370596a017398016f8900d6','南手术间2','1') ;
call zyj_insert_opt_schedule('2020-08-01nan004','40288afb732dc2f601734c164a810080','南科室b','40288afb7370596a017398016f8900d6','南手术间2','2') ;
call zyj_insert_opt_schedule('2020-08-01nan005','40288afb7370596a0173989d2a2400ef','南科室x','40288afb7370596a0173989db56b00f0','南手术间x','1') ;
call zyj_insert_opt_schedule('2020-08-01nan006','40288afb7370596a0173b8b206df0175','南科室y','40288afb7370596a0173b8b300300178','南手术间y','1') ;

call zyj_insert_opt_schedule('2020-08-03nan001','40288afb732dc2f601734c16a0b70081','南科室a','40288afb7370596a0173755905550017','南手术间1','1') ;#(id,科室id,科室名称,手术间id,手术间名称,手术台次)
call zyj_insert_opt_schedule('2020-08-03nan002','40288afb732dc2f601734c16a0b70081','南科室a','40288afb7370596a0173755905550017','南手术间1','2') ;
call zyj_insert_opt_schedule('2020-08-03nan003','40288afb732dc2f601734c164a810080','南科室b','40288afb7370596a017398016f8900d6','南手术间2','1') ;
call zyj_insert_opt_schedule('2020-08-03nan004','40288afb732dc2f601734c164a810080','南科室b','40288afb7370596a017398016f8900d6','南手术间2','2') ;
call zyj_insert_opt_schedule('2020-08-03nan005','40288afb7370596a0173989d2a2400ef','南科室x','40288afb7370596a0173989db56b00f0','南手术间x','1') ;
call zyj_insert_opt_schedule('2020-08-03nan006','40288afb7370596a0173b8b206df0175','南科室y','40288afb7370596a0173b8b300300178','南手术间y','1') ;

-- update 手术日期
UPDATE bspods.bsp_operation_schedule set reservation_time = '2020-08-01 00:00:00' where schedule_id like '2020-08-01%' and courtyard_id = '40288afb7370596a01737557b6ee0015';
UPDATE bspods.bsp_operation_schedule set reservation_time = '2020-08-03 00:00:00' where schedule_id like '2020-08-03%' and courtyard_id = '40288afb7370596a01737557b6ee0015';

-- 随机 产生急诊
UPDATE bspods.bsp_operation_schedule set emergercy_indicator = FLOOR(1 + rand()*2) where courtyard_id = '40288afb7370596a01737557b6ee0015';

-- 插入手术各个动作的时间
DELETE from bspods.ods_operation_schedule where room_id = '40288afb7370596a0173755905550017' or room_id = '40288afb7370596a017398016f8900d6' or room_id = '40288afb7370596a0173989db56b00f0' or room_id = '40288afb7370596a0173b8b300300178' ;
drop PROCEDURE if EXISTS zyj_insert_opt_time ;
CREATE DEFINER=`root`@`%` PROCEDURE `zyj_insert_opt_time`(in opt_room_id char(32) , in opt_sequence varchar(4) , in opt_special_type varchar(128) , in opt_date VARCHAR(32))
begin

if (opt_sequence = '1' and opt_special_type = '正常') then
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('work_start', opt_room_id, opt_sequence, concat(opt_date,' 08:00:00') ,concat(opt_date , ' 00:00:00'));
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('anesthesia', opt_room_id, opt_sequence, concat(opt_date,' 09:00:00'), concat(opt_date , ' 00:00:00'));
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('opt_start', opt_room_id, opt_sequence, concat(opt_date,' 09:00:00'), concat(opt_date , ' 00:00:00')) ;
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('skin_cut', opt_room_id, opt_sequence, concat(opt_date,' 10:00:00'), concat(opt_date , ' 00:00:00'));
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('skin_sew', opt_room_id, opt_sequence, concat(opt_date,' 11:00:00'), concat(opt_date , ' 00:00:00')) ;
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('opt_end', opt_room_id, opt_sequence, concat(opt_date,' 12:00:00'), concat(opt_date , ' 00:00:00')) ;
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('work_end', opt_room_id, opt_sequence, concat(opt_date ,' 13:00:00'), concat(opt_date , ' 00:00:00')) ;

elseif (opt_sequence = '2' and opt_special_type = '正常') then
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('work_start', opt_room_id, opt_sequence, concat(opt_date ,' 14:00:00'), concat(opt_date , ' 00:00:00')) ;
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('anesthesia', opt_room_id, opt_sequence, concat(opt_date ,' 15:00:00'), concat(opt_date , ' 00:00:00'));
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('opt_start', opt_room_id, opt_sequence, concat(opt_date ,' 15:00:00'), concat(opt_date , ' 00:00:00')) ;
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('skin_cut', opt_room_id, opt_sequence, concat(opt_date ,' 16:00:00'), concat(opt_date , ' 00:00:00'));
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('skin_sew', opt_room_id, opt_sequence, concat(opt_date ,' 17:00:00'), concat(opt_date , ' 00:00:00')) ;
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('opt_end', opt_room_id, opt_sequence, concat(opt_date ,' 18:00:00'), concat(opt_date , ' 00:00:00')) ;
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('work_end', opt_room_id, opt_sequence, concat(opt_date ,' 19:00:00'), concat(opt_date , ' 00:00:00')) ;

elseif (opt_special_type = '跨天') then
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('work_start', opt_room_id, opt_sequence, concat(opt_date ,' 22:00:00'), concat(opt_date, ' 00:00:00')) ;
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('anesthesia', opt_room_id, opt_sequence, concat(opt_date ,' 23:00:00'), concat(opt_date, ' 00:00:00'));
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('opt_start', opt_room_id, opt_sequence, concat(opt_date,' 23:00:00'), concat(opt_date, ' 00:00:00')) ;
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('skin_cut', opt_room_id, opt_sequence, concat(DATE_SUB(opt_date , INTERVAL -1 DAY),' 01:00:00'), concat(opt_date,' 00:00:00'));
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('skin_sew', opt_room_id, opt_sequence, concat(DATE_SUB(opt_date , INTERVAL -1 DAY),' 02:00:00'), concat(opt_date,' 00:00:00'));
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('opt_end', opt_room_id, opt_sequence, concat(DATE_SUB(opt_date , INTERVAL -1 DAY),' 03:00:00'), concat(opt_date,' 00:00:00')) ;
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('work_end', opt_room_id, opt_sequence, concat(DATE_SUB(opt_date , INTERVAL -1 DAY) ,' 04:00:00'), concat(opt_date,' 00:00:00'));

elseif (opt_sequence = '1' and opt_special_type = '未完成') then
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('work_start', opt_room_id, opt_sequence, concat(opt_date ,' 08:00:00') ,concat(opt_date , ' 08:00:00'));
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('anesthesia', opt_room_id, opt_sequence, concat(opt_date ,' 09:00:00'), concat(opt_date , ' 00:00:00'));
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('opt_start', opt_room_id, opt_sequence, concat(opt_date ,' 09:00:00'), concat(opt_date , ' 00:00:00'));
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('skin_cut', opt_room_id, opt_sequence, concat(opt_date ,' 10:00:00'), concat(opt_date , ' 00:00:00'));
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('skin_sew', opt_room_id, opt_sequence, NULL, concat(opt_date , ' 00:00:00'));
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('opt_end', opt_room_id, opt_sequence, NULL, concat(opt_date , ' 00:00:00'));
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('work_end', opt_room_id, opt_sequence, NULL, concat(opt_date , ' 00:00:00'));

elseif (opt_sequence = '2' and opt_special_type = '未完成') then
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('work_start', opt_room_id, opt_sequence, concat(opt_date ,' 14:00:00') ,concat(opt_date , ' 08:00:00'));
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('anesthesia', opt_room_id, opt_sequence, concat(opt_date ,' 15:00:00'), concat(opt_date , ' 00:00:00'));
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('opt_start', opt_room_id, opt_sequence, concat(opt_date ,' 15:00:00'), concat(opt_date , ' 00:00:00'));
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('skin_cut', opt_room_id, opt_sequence, concat(opt_date ,' 16:00:00'), concat(opt_date , ' 00:00:00'));
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('skin_sew', opt_room_id, opt_sequence, NULL, concat(opt_date , ' 00:00:00'));
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('opt_end', opt_room_id, opt_sequence, NULL, concat(opt_date , ' 00:00:00'));
INSERT INTO `bspods`.`ods_operation_schedule`(`time_type`, `room_id`, `sequence`, `time` , reservation_time ) VALUES ('work_end', opt_room_id, opt_sequence, NULL, concat(opt_date , ' 00:00:00'));

else 
select "没有这种情况" ;

end if ;

end ;

call zyj_insert_opt_time('40288afb7370596a0173755905550017','1','正常','2020-08-01') ;# (手术间id，手术台次，是否正常，手术日期)
call zyj_insert_opt_time('40288afb7370596a0173755905550017','2','正常','2020-08-01') ;# (手术间id，手术台次，是否正常，手术日期)
call zyj_insert_opt_time('40288afb7370596a017398016f8900d6','1','正常','2020-08-01') ;# (手术间id，手术台次，是否正常，手术日期)
call zyj_insert_opt_time('40288afb7370596a017398016f8900d6','2','正常','2020-08-01') ;# (手术间id，手术台次，是否正常，手术日期)
call zyj_insert_opt_time('40288afb7370596a0173989db56b00f0','1','跨天','2020-08-01') ;# (手术间id，手术台次，是否正常，手术日期)
call zyj_insert_opt_time('40288afb7370596a0173b8b300300178','1','未完成','2020-08-01') ;# (手术间id，手术台次，是否正常，手术日期)

call zyj_insert_opt_time('40288afb7370596a0173755905550017','1','正常','2020-08-03') ;# (手术间id，手术台次，是否正常，手术日期)
call zyj_insert_opt_time('40288afb7370596a0173755905550017','2','正常','2020-08-03') ;# (手术间id，手术台次，是否正常，手术日期)
call zyj_insert_opt_time('40288afb7370596a017398016f8900d6','1','正常','2020-08-03') ;# (手术间id，手术台次，是否正常，手术日期)
call zyj_insert_opt_time('40288afb7370596a017398016f8900d6','2','正常','2020-08-03') ;# (手术间id，手术台次，是否正常，手术日期)
call zyj_insert_opt_time('40288afb7370596a0173989db56b00f0','1','跨天','2020-08-03') ;# (手术间id，手术台次，是否正常，手术日期)
call zyj_insert_opt_time('40288afb7370596a0173b8b300300178','1','未完成','2020-08-03') ;# (手术间id，手术台次，是否正常，手术日期)



-- 创建患者

-- 创建术者




-- 运行22 给排班添加时间 再运行43









