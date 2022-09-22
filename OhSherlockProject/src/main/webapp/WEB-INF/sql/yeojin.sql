
show user;
-- USER이(가) "SEMI_ORAUSER2"입니다.

desc tbl_member;

-- TBL_MEMBER 테이블에 생성된 제약조건 조회하기
select A.constraint_name, A.constraint_type, A.search_condition, A.r_constraint_name, 
       A.status, A.index_name, B.column_name, B.position
from user_constraints A JOIN user_cons_columns B
on A.constraint_name = B.constraint_name
where A.table_name = 'tbl_member';
    
select * 
from tbl_member 
where status = 1 and userid = 'sonyj' and email = '3o/fiFv5Fh9920BFzqqhfYk8Ktd7DhWgCUWyjFOyDQ0=' and name = '손여진';
 
 
update tbl_member set email='3o/fiFv5Fh9920BFzqqhfYk8Ktd7DhWgCUWyjFOyDQ0='
where userid='sonyj';

commit;
-- 커밋 완료
 