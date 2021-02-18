
/*
用户变量：
用户变量与数据库连接有关，在这个连接中声明的变量，在连接断开的时候，就会消失。在此连接中声明的变量无法在另一连接中使用。
用户变量的变量名的形式为@varname的形式。名字必须以@开头。
set @a = 1;
# mysql里面的变量是不严格限制数据类型的，它的数据类型根据你赋给它的值而随时变化 。
（SQL SERVER中使用declare语句声明变量，且严格限制数据类型。）
我们还可以使用select 语句为变量赋值 。比如：
set @name = '';
select @name:=password from user limit 0,1;# 注意,等号的两边不要有空格（注意等于号前面有一个冒号，后面的limit 0,1是用来限制返回结果的，相当于SQL SERVER里面的top 1）
select max(id) from ods_operation_schedule into @idnum;# 另一种方式

如果直接写：
select @name:=password from user;#如果这个查询返回多个值的话，那@name变量的值就是最后一条记录的password字段的值 。

*/


/*
系统变量：
　　系统变量又分为全局变量与会话变量。
　　全局变量在MYSQL启动的时候由服务器自动将它们初始化为默认值，这些默认值可以通过更改my.ini这个文件来更改。

　　会话变量在每次建立一个新的连接的时候，由MYSQL来初始化。MYSQL会将当前所有全局变量的值复制一份。来做为会话变量。（也就是说，如果在建立会话以后，没有手动更改过会话变量与全局变量的值，那所有这些变量的值都是一样的。）
　　全局变量与会话变量的区别就在于，对全局变量的修改会影响到整个服务器，但是对会话变量的修改，只会影响到当前的会话（也就是当前的数据库连接）。

　　我们可以利用show session variables;语句将所有的会话变量输出（可以简写为show variables，没有指定是输出全局变量还是会话变量的话，默认就输出会话变量。）

show global variables;输出全局变量

    修改系统变量的值：
　　有些系统变量的值是可以利用语句来动态进行更改的，但是有些系统变量的值却是只读的。对于那些可以更改的系统变量，我们可以利用set语句进行更改。

　　如果想要更改会话变量的值，利用语句（一般系统定义的全局变量都是以@@开头，用户自定义变量以@开头）：

　　set session varname = value;或者set @@session.varname = value;

　　比如：

　　mysql> set session sort_buffer_size = 40000;

　　Query OK, 0 rows affected(0.00 sec)

　　如果想要更改全局变量的值，将session改成global：

　　set global sort_buffer_size = 40000;

　　set @@global.sort_buffer_size = 40000;

　　不过要想更改全局变量的值，需要拥有SUPER权限 。

　　（注意，ROOT只是一个内置的账号，而不是一种权限 ，

　　这个账号拥有了MYSQL数据库里的所有权限。任何账号只要它拥有了名为SUPER的这个权限，

　　就可以更改全局变量的值，正如任何用户只要拥有FILE权限就可以调用load_file或者

　　into   outfile ,into dumpfile,load data infile一样。）

　　利用select语句我们可以查询单个会话变量或者全局变量的值：

　　select @@session.sort_buffer_size

　　select @@global.sort_buffer_size

　　select @@global.tmpdir

　　凡是上面提到的session，都可以用local这个关键字来代替。

　　比如：

　　select @@local.sort_buffer_size

　　local 是 session的近义词。

　　无论是在设置系统变量还是查询系统变量值的时候，只要没有指定到底是全局变量还是会话变量。

　　都当做会话变量来处理。

　　比如：

　　set @@sort_buffer_size = 50000;

　　select @@sort_buffer_size;

　　上面都没有指定是GLOBAL还是SESSION，所以全部当做SESSION处理。

*/