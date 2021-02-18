说明：having可用的前提是已经筛选出了price字段，在这种情况下和where的效果是等效的，But如果没有select price 就会报错！！因为having是从前筛选的字段再筛选，而where是从数据表中的字段直接进行的筛选的。
【】where和having都可以使用的情况
select price,name from goods where price > 100
select price,name from goods having price > 100
		
【】只可以用where，不可以用having的情况
select name from goods where price> 100
select name from goods having price> 100# //报错！！！因为select没有筛选出price 字段，having不能用,而where是对表进行检索price。
		
【】只可以用having，不可以用where情况
查询每种id 商品价格的平均值，获取平均价格大于100元的商品信息
select id, avg(price) as agprice from goods group by id having agprice > 100
select id, avg(price) as agprice from goods where agprice>100 group by id#//报错！！因为from goods这表里面没有agprice这个字段
		
		
		