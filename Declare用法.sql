MySQL declare语句是在复合语句中声明变量的指令。

在过程中定义的变量并不是真正的定义，你只是在BEGIN/END块内定义了而已（译注：也就是形参）。注意这些变量和会话变量不一样，不能使用修饰符@你必须清楚的在BEGIN/END块中声明变量和它们的类型。变量一旦声明，你就能在任何能使用会话变量、文字、列名的地方使用。

CREATE PROCEDURE p8 ()   
BEGIN   
DECLARE a INT;   
DECLARE b INT;   
SET a = 5;   
SET b = 5;   
INSERT INTO t VALUES (a);   
SELECT s1 * a FROM t WHERE s1 >= b;   
END; // /* I won't CALL this */  



含有DEFAULT子句的例子


CREATE PROCEDURE p10 ()   
BEGIN   
DECLARE a, b INT DEFAULT 5;   
INSERT INTO t VALUES (a);   
SELECT s1 * a FROM t WHERE s1 >= b;   
END; // 