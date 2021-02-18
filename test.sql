DROP PROCEDURE if EXISTS aaa ;
CREATE PROCEDURE aaa()
BEGIN

DECLARE i int(16) DEFAULT(1) ;
SELECT id into i from t_student where sname = '李毅' ;
SELECT i ;

end ;


call aaa() ;