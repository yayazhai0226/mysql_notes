在mysql中，round函数用于数据的四舍五入，它有两种形式：
1、round(x,d)  ，x指要处理的数，d是指保留几位小数#这里有个值得注意的地方是，d可以是负数
2、round(x)  ,其实就是round(x,0),也就是默认d为0；
实例：
select round(1123.26723,2);
select round(1123.26723,0);
select round(1123.26723);


注意：
round() :四舍五入 
floor() :取整
