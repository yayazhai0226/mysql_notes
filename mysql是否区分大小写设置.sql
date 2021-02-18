Mysql默认的字符检索策略：utf8_general_ci，表示不区分大小写；utf8_general_cs表示区分大小写，utf8_bin表示二进制比较，同样也区分大小写 。（注意：在Mysql5.6.10版本中，不支持utf8_genral_cs）


ALTER TABLE TABLENAME MODIFY COLUMN COLUMNNAME VARCHAR(50) BINARY CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL;
