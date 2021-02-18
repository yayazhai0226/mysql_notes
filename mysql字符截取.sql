Mysql处理字符串函数

感觉上MySQL的字符串函数截取字符，比用程序截取（如PHP或JAVA）来得强大，所以在这里做一个记录，希望对大家有用。 
函数： 
1、从左开始截取字符串 
left（str, length） 
说明：left（被截取字段，截取长度） 
例：select left（content,200） as abstract from my_content_t 
select left('123456' , 2) ;

2、从右开始截取字符串 
right（str, length） 
说明：right（被截取字段，截取长度） 
例：select right（content,200） as abstract from my_content_t 
select right('123456' , 2) ;

3、截取字符串 
substring（str, pos） 
substring（str, pos, length） 
说明：substring（被截取字段，从第几位开始截取） 
substring（被截取字段，从第几位开始截取，截取长度） 
例：select substring（content,5） as abstract from my_content_t 
select substring（content,5,200） as abstract from my_content_t 
（注：如果位数是负数 如-5 则是从后倒数位数，到字符串结束或截取的长度） 
select substring('123456789' , 2 , 4) ;

4、按关键字截取字符串 
substring_index（str,delim,count） 
说明：substring_index（被截取字段，关键字，关键字出现的次数） 
例：select substring_index（"blog.jb51.net"，"。"，2） as abstract from my_content_t 
结果：blog.jb51 
（注：如果关键字出现的次数是负数 如-2 则是从后倒数，到字符串结束） 

函数简介：

SUBSTRING(str,pos) , SUBSTRING(str FROM pos) SUBSTRING(str,pos,len) , SUBSTRING(str FROM pos FORlen)

不带有len 参数的格式从字符串str返回一个子字符串，起始于位置 pos。带有len参数的格式从字符串str返回一个长度同len字符相同的子字符串，起始于位置 pos。 使用 FROM的格式为标准 SQL 语法。也可能对pos使用一个负值。假若这样，则子字符串的位置起始于字符串结尾的pos 字符，而不是字符串的开头位置。在以下格式的函数中可以对pos 使用一个负值。

详情请查阅手册。



