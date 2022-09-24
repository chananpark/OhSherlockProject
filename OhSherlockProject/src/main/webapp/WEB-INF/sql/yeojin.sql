
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
 
 
 
 
-----------------------------------------------------------------------------------------------------------------------------
--- 오라클에서 프로시저를 사용하여 회원을 대량으로 입력(insert)하겠습니다. ---
select * 
from user_constraints
where table_name = 'TBL_MEMBER';

alter table tbl_member
drop constraint UK_TBL_MEMBER_EMAIL;  -- 이메일을 대량으로 넣기 위해서 어쩔수 없이 email 에 대한 unique 제약을 없애도록 한다. 

select * 
from user_constraints
where table_name = 'TBL_MEMBER';

select *
from tbl_member
order by registerday desc;

create or replace procedure pcd_member_insert 
(p_userid  IN  varchar2 -- 크기 입력 금지
,p_name    IN  varchar2
,p_gender  IN  char)
is
begin
     for i in 1..100 loop
         insert into tbl_member(userid, passwd, name, email, mobile, postcode, address, detail_address, extra_address, gender, birthday) 
         values(p_userid||i, '9695b88a59a1610320897fa84cb7e144cc51f2984520efb77111d94b402a8382', p_name||i, 'qzgtKJ690tyLSSPGMXbryWUeCF9ssiNwnUipv6RAvNM=' , 'xZLLos74/QMmrVCTcKZJQQ==', '15864', '경기 군포시 오금로 15-17', '102동 9004호', ' (금정동)', p_gender, '1991-01-27'); 
     end loop;
end pcd_member_insert;
-- Procedure PCD_MEMBER_INSERT이(가) 컴파일되었습니다.


exec pcd_member_insert('imgreentea','전녹수','1');
-- PL/SQL 프로시저가 성공적으로 완료되었습니다.
commit;

exec pcd_member_insert('imbori','임보리','2');
-- PL/SQL 프로시저가 성공적으로 완료되었습니다.
commit;
-----------------------------------------------------------------------------------------------------------------------------






























