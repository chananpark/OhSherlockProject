show user;
-- USER이(가) "SEMI_ORAUSER2"입니다.

desc tbl_member;

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
select userid, name, email, mobile, postcode, address, detail_address, extra_address, gender,       
birthyyyy, birthmm, birthdd, coin, point, registerday,        
passwd_change_gap, last_login_date, nvl(last_login_gap, months_between(sysdate, registerday)) as last_login_gap
from
(select userid, name, email, mobile, postcode, address, detail_address, extra_address, gender     
, substr(birthday,1,4) AS birthyyyy, substr(birthday,6,2) AS birthmm, substr(birthday,9) AS birthdd     
, coin, point, to_char(registerday, 'yyyy-mm-dd') AS registerday     
, trunc( months_between(sysdate, last_passwd_date) ) AS passwd_change_gap
from tbl_member
where status = 1 and userid = '5sherlock' and passwd = '0ffe1abd1a08215353c233d6e009613e95eec4253832a761af28ff37ac5a150c') M
cross join
(select max(logindate) as last_login_date, trunc(months_between(sysdate, max(logindate))) as last_login_gap
from tbl_login_history
where fk_userid = '5sherlock') H;

String sql = "select userid, name, email, mobile, postcode, address, detail_address, extra_address, gender,       \n"+
"birthyyyy, birthmm, birthdd, coin, point, registerday,        \n"+
"passwd_change_gap, nvl(last_login_gap, months_between(sysdate, registerday)) as last_login_gap, last_login_date\n"+
"from\n"+
"(select userid, name, email, mobile, postcode, address, detail_address, extra_address, gender     \n"+
", substr(birthday,1,4) AS birthyyyy, substr(birthday,6,2) AS birthmm, substr(birthday,9) AS birthdd     \n"+
", coin, point, to_char(registerday, 'yyyy-mm-dd') AS registerday     \n"+
", trunc( months_between(sysdate, last_passwd_date) ) AS passwd_change_gap\n"+
"from tbl_member\n"+
"where status = 1 and userid = ? and passwd = ?) M\n"+
"cross join\n"+
"(select max(logindate) as last_login_date, trunc(months_between(sysdate, max(logindate))) as last_login_gap\n"+
"from tbl_login_history\n"+
"where fk_userid = ?) H";

-- 휴면 상태 해제 sql --
String sql = "update tbl_member set idle = 0 where userid = ?";

update tbl_member set idle = 1 where userid = 'leess';
commit;

desc tbl_notice;

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

-- 공지사항 글번호 시퀀스 --
CREATE SEQUENCE seq_notice
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOMINVALUE
NOCYCLE
NOCACHE;

-- 공지사항 글쓰기 sql --
insert into tbl_notice(noticeNo, noticeSubject, noticeContent, noticeFile)
values(seq_notice.nextval, '오셜록고객님들께', '안녕하세요', null);

commit;

-- 공지사항 글목록 가져오기 sql --
String sql = "select noticeNo, noticeSubject, noticeContent, noticeHit, noticeDate from tbl_notice";

-- 공지사항 글내용 가져오기 sql --
String sql = "select noticeSubject, noticeContent, noticeHit, noticeDate, noticeFile from tbl_notice where noticeNo = ?";

-- 공지사항 글 조회수 증가 sql --
String sql = "update tbl_notice set noticeHit = noticeHit + 1 where noticeNo = ?";

-- 시퀀스 얻기 sql --
String sql = "select seq_notice.nextval from dual";

-- 공지사항 글쓰기 sql --
String sql = "insert into tbl_notice(noticeNo, noticeSubject, noticeContent, noticeFile)\n"+
"values(?, ?, ?, ?)";

-- 공지사항 글삭제 sql --
String sql = "delete from tbl_notice where noticeNo = ?";

-- 공지사항 글수정 sql --
String sql = "update tbl_notice set noticeSubject = ?, noticeContent = ? where noticeNo = ?";