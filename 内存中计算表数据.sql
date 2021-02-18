create table tmp_zyj_ods_operation_schedule like `bspods`.`ods_operation_schedule`;
alter table tmp_zyj_ods_operation_schedule engine=memory;#内存中运行各种操作语句

drop table if exists tmp_zyj_ods_operation_schedule;
drop table if exists tmp_zyj_bsp_operation_schedule;