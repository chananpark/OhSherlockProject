show user;
-- USER이(가) "SEMI_ORAUSER2"입니다.



-- 제약조건 조회하기 -- 
select A.constraint_name, A.constraint_type, A.search_condition, A.R_constraint_name
, A.status, A.index_name, B.column_name, B.position
from user_constraints A Join user_cons_columns B
on A.constraint_name = B.constraint_name
where A.table_name = 'TBL_MEMBER';
  
create table tbl_login_history
(fk_userid    varchar2(15)   not null
,logindate    date default sysdate not null 
,clientip     varchar2(20)   not null 
,constraint FK_tbl_login_history_fk_userid foreign key(fk_userid) references tbl_member(userid)
);

desc TBL_MEMBER;
desc tbl_login_history;