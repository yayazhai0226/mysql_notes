

IFNULL(expression, alt_value)
如果第一个参数的表达式 expression 为 NULL，则返回第二个参数的备用值。
参数说明:

第一个参数为 NULL：
SELECT IFNULL(NULL, "RUNOOB");
以上实例输出结果为：
RUNOOB

第一个参数不为 NULL：
SELECT IFNULL("Hello", "RUNOOB");
以上实例输出结果为：
Hello


