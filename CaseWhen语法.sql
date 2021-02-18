-- case when
#数据准备
create table if not exists test_user(
  `id` bigint(20) not null AUTO_INCREMENT comment '主键自增ID',
  `name` varchar(64) not null comment '姓名',
  `gender` integer not null comment '性别,1: 男, 2: 女',
  `country_code` integer not null comment '所属国家CODE',
  primary key (`id`)
) charset = 'utf8mb4' comment '测试表';
INSERT INTO `test_user` (`name`, `gender`, `country_code`)
VALUES 
  ('清风', 1, 100), 
  ('玄武', 2, 100), 
  ('Kobe', 1, 110), 
  ('John Snow', 1, 200), 
  ('Peut-être', 0, 120);

#【简单函数】
CASE case_value
    WHEN when_value THEN statement_list
    [WHEN when_value THEN statement_list] ...
    [ELSE statement_list]
END CASE
-- 例如
select `id`, `name`, `gender`, 
(case `gender`
when 1 then '男'
when 2 then '女'
else '未知'
end) as '性别',
`country_code`
from test_user;


#【case搜索函数】
CASE
    WHEN search_condition THEN statement_list
    [WHEN search_condition THEN statement_list] ...
    [ELSE statement_list]
END CASE
-- 例如
select id, `name`, gender, 
(case 
when gender = 1 then '男'
when gender = 2 then '女'
else '未知' 
end) as '性别', 
country_code,
(case 
when country_code = 100 then '中国'
when country_code = 110 then '英国'
when country_code = 120 then '法国'
else '雪国' 
end) as '国籍'
from test_user;







