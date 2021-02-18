
-- 查询结果是id = 2且age = 20,或者id=1
SELECT * from student WHERE id = 1 or id = 2 AND age = 20;


-- 查询结果是 id=1或id=2 ,且age = 20
SELECT * from student WHERE (id = 1 or id = 2 ) AND age = 20;

