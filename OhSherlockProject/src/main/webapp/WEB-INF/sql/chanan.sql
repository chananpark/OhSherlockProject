show user;
-- USER이(가) "SEMI_ORAUSER2"입니다.



select * from tbl_member;

-- 제약조건 조회하기 -- 
select A.constraint_name, A.constraint_type, A.search_condition, A.R_constraint_name
, A.status, A.index_name, B.column_name, B.position
from user_constraints A Join user_cons_columns B
on A.constraint_name = B.constraint_name
where A.table_name = 'TBL_MEMBER';
  
-- 로그인 이력 테이블 -- 
create table tbl_login_history
(fk_userid    varchar2(15)   not null
,logindate    date default sysdate not null 
,clientip     varchar2(20)   not null 
,constraint FK_tbl_login_history_fk_userid foreign key(fk_userid) references tbl_member(userid)
);

desc tbl_member;
desc tbl_login_history;

-- 로그인 sql --
String sql = "select userid, name, email, mobile, postcode, address, detail_address, extra_address, gender,\n"+
"       birthyyyy, birthmm, birthdd, coin, point, registerday, \n"+
"       passwd_change_gap, nvl(last_login_gap, months_between(sysdate, registerday)) as last_login_gap\n"+
"from\n"+
"(select userid, name, email, mobile, postcode, address, detail_address, extra_address, gender\n"+
"     , substr(birthday,1,4) AS birthyyyy, substr(birthday,6,2) AS birthmm, substr(birthday,9) AS birthdd\n"+
"     , coin, point, to_char(registerday, 'yyyy-mm-dd') AS registerday\n"+
"     , trunc( months_between(sysdate, last_passwd_date) ) AS passwd_change_gap\n"+
"from tbl_member\n"+
"where status = 1 and userid = ? and passwd = ?\n"+
") M\n"+
"cross join\n"+
"(select trunc(months_between(sysdate, max(logindate))) as last_login_gap\n"+
"from tbl_login_history\n"+
"where fk_userid = ?) H";

-- 휴면 상태 해제 sql --
String sql = "update tbl_member set idle = 0 where userid = ?";

update tbl_member set idle = 1 where userid = 'leess';
commit;

-- 공지사항 테이블 --
create table tbl_notice (
noticeNo number,
noticeSubject Nvarchar2(100) not null,
noticeContent clob not null,
noticeHit number default 0,
noticeDate date default sysdate,
noticeFile varchar2(100),
constraint PK_tbl_notice_noticeNo primary key(noticeNo)
);