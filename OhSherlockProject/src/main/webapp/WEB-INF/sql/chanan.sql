-- 로그인 이력 테이블 -- 
create table tbl_login_history
(fk_userid    varchar2(15)   not null
,logindate    date default sysdate not null 
,clientip     varchar2(20)   not null 
,constraint FK_tbl_login_history_fk_userid foreign key(fk_userid) references tbl_member(userid)
);

select * from tbl_member;
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
where status = 1 and userid = 'na0seok' and passwd = '0ffe1abd1a08215353c233d6e009613e95eec4253832a761af28ff37ac5a150c') M
cross join
(select max(logindate) as last_login_date, trunc(months_between(sysdate, max(logindate))) as last_login_gap
from tbl_login_history
where fk_userid = '5sherlock') H;

-- 휴면 상태 해제 sql --
update tbl_member set idle = 1 where userid = 'leess';
commit;

--------------------------------------------------------------------------------

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
values(seq_notice.nextval, '2조 화이팅', '아좌좌', null);

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

--------------------------------------------------------------------------------

-- 1:1 문의 테이블 --
create table tbl_inquiry(
inquiry_no number,
fk_userid varchar2(15),
inquiry_type Nvarchar2(20)  not null,
inquiry_subject Nvarchar2(100) not null,
inquiry_content clob not null,
inquiry_date date default sysdate,
inquiry_answered number default 0, -- 미답변:0, 답변완료:1
inquiry_email number default 0, -- 이메일발송거부:0, 이메일발송희망:1
inquiry_sms number default 0, -- 문자발송거부:0, 문자발송희망:1
constraint PK_tbl_inquiry_inquiry_no primary key(inquiry_no),
constraint CK_tbl_inquiry_inquiry_answered check (inquiry_answered in (0,1)),
constraint CK_tbl_inquiry_inquiry_email check (inquiry_email in (0,1)),
constraint CK_tbl_inquiry_inquiry_sms check (inquiry_sms in (0,1))
);

-- inquiry 시퀀스 사용 --
select seq_inquiry.nextval from dual;

-- inquiry 테이블 insert문 --
insert into tbl_inquiry(inquiry_no, fk_userid, inquiry_type, inquiry_subject, inquiry_content, inquiry_email, inquiry_sms)
values(seq_inquiry.nextval, 'test1', 'delivery', '문의', 'ㅇㅇ', 0, 0);
commit;

-- (사용자) 자신의 문의글 전체 개수 가져오기 select문 --
select count(*) from tbl_inquiry where fk_userid = 'test1' and inquiry_date between '2022-09-28' and to_date('2022-09-28 23:59:59', 'yyyy-mm-dd hh24:mi:ss');

String sql = "select count(*) from tbl_inquiry where fk_userid = ? and inquiry_date between ? and to_date(? ||' 23:59:59', 'yyyy-mm-dd hh24:mi:ss')";

-- (사용자) 자신의 문의 내역 가져오기 select문 --
String sql = "select INQUIRY_NO , INQUIRY_TYPE , INQUIRY_SUBJECT , INQUIRY_CONTENT , INQUIRY_DATE , INQUIRY_ANSWERED\n"+
"from\n"+
"(\n"+
"select row_number() over(order by INQUIRY_DATE desc) as rno,\n"+
"INQUIRY_NO , INQUIRY_TYPE , INQUIRY_SUBJECT , INQUIRY_CONTENT , INQUIRY_DATE , INQUIRY_ANSWERED\n"+
"from tbl_inquiry\n"+
"where fk_userid = ? AND inquiry_date between ? and to_date(? ||' 23:59:59', 'yyyy-mm-dd hh24:mi:ss')\n"+
")\n"+
"where rno between ? and ?";

-- (사용자) 자신의 문의글 상세보기 --
select inquiry_no, inquiry_reply_content, inquiry_type, inquiry_subject, inquiry_content, inquiry_date, inquiry_answered
FROM tbl_inquiry join tbl_inquiry_reply
on inquiry_no = fk_inquiry_no
where INQUIRY_NO = 1;

-- (관리자) 1:1문의 전체 페이지 수 --
select ceil(count(*)/7) from tbl_inquiry where INQUIRY_ANSWERED = 0;

String sql = "select ceil(count(*)/7) from tbl_inquiry where INQUIRY_ANSWERED = ?";

-- (관리자) 1:1 문의 글목록 --
String sql = "SELECT inquiry_no, inquiry_type, inquiry_subject, inquiry_content, inquiry_date, fk_userid "+
        " FROM ( SELECT ROWNUM AS rno, inquiry_no, inquiry_type, inquiry_subject, inquiry_content, inquiry_date, fk_userid "+
        " FROM ( SELECT inquiry_no, inquiry_type, inquiry_subject, inquiry_content, inquiry_date, fk_userid "+
        " FROM tbl_inquiry WHERE inquiry_answered = ? ORDER BY 1 DESC ) v ) t\n"+
        " WHERE rno BETWEEN ? AND ?";


-- 관리자 1:1 문의글 상세 --
SELECT inquiry_reply_content, inquiry_reply_date
FROM tbl_inquiry_reply
WHERE fk_inquiry_no = 29;

-- 1:1 문의 댓글 시퀀스 --
create sequence seq_inquiry_reply_no
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

-- 관리자 1:1 문의글 댓글달기 --
String sql = "insert into tbl_inquiry_reply(inquiry_reply_no, fk_inquiry_no, inquiry_reply_content)\n"+
"values(?, ?, ?)";

-- 1:1 문의글의 답변여부 update --
String sql = "update tbl_inquiry set inquiry_answered = 1 where inquiry_no = ?";

--------------------------------------------------------------------------------

-- 카테고리 테이블 생성 --
create table tbl_category
(cnum    number(8)     not null  -- 카테고리 대분류 번호
,code    varchar2(20)  not null  -- 카테고리 코드
,cname   varchar2(100) not null  -- 카테고리명
,constraint PK_tbl_category_cnum primary key(cnum)
,constraint UQ_tbl_category_code unique(code)
);

-- 카테고리 시퀀스 생성 --
create sequence seq_category_cnum 
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

--------------------------------------------------------------------------------
-- 상품번호 시퀀스 생성 --
create sequence seq_product_pnum
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

--------------------------------------------------------------------------------

-- 주문 테이블 --
create table tbl_order (
onum number(8) not null, -- 주문번호
fk_userid varchar2(15), -- 주문자 아이디
odate date default sysdate, -- 주문일자
recipient_name varchar2(30) not null, -- 수령자 이름
recipient_mobile varchar2(200) not null, -- 수령자 핸드폰번호
recipient_postcode varchar2(5) not null, -- 수령자 우편번호
recipient_address varchar2(100) not null, -- 수령자 주소
recipient_detail_address varchar2(100) not null, -- 수령자 상세주소
recipient_extra_address varchar2(100) not null, -- 수령자 추가주소
osum number(8) not null, -- 총주문금액
delivery_cost number(4) not null, -- 배송비
payment_method varchar2(10) not null, -- 결제수단
constraint PK_tbl_order_onum primary key(onum),
constraint FK_tbl_order_fk_userid foreign key(fk_userid) references tbl_member(userid)
);

-- 주문상세 테이블 --
create table tbl_order_detail (
odnum number(8) not null, -- 주문상세번호
fk_onum number(8) not null, -- 주문번호
fk_pnum number(8) not null, -- 상품번호
oqty NUMBER(8) not null, -- 주문수량
oprice NUMBER(8) not null, -- 주문금액: 판매가격(할인율반영)*주문수량
refund number(1) default 0, -- 환불여부. 여:1, 부:0
exchange number(1) default 0, -- 교환여부. 여:1, 부:0
constraint PK_tbl_order_detail_odnum primary key(odnum),
constraint FK_tbl_order_detail_fk_onum foreign key(fk_onum) references tbl_order(onum),
constraint FK_tbl_order_detail_fk_pnum foreign key(fk_pnum) references tbl_product(pnum),
constraint CK_tbl_order_detail_refund check (refund in (0,1)),
constraint CK_tbl_order_detail_exchange check (exchange in (0,1))
);

-- 리뷰 테이블 --
create table tbl_review (
rnum number(8) not null, -- 리뷰번호
fk_onum number(8) not null, -- 주문번호
fk_odnum number(8) not null, -- 주문상세번호
fk_pnum number(8) not null, -- 상품번호
fk_userid varchar2(15), -- 주문자 아이디
score NUMBER(1) not null, -- 별점(1~5)
rsubject Nvarchar2(100) not null, -- 리뷰제목
rcontent Nvarchar2(500) not null, -- 리뷰내용
rimage VARCHAR2(100), -- 리뷰이미지
constraint PK_tbl_review_rnum primary key(rnum),
constraint FK_tbl_review_fk_onum foreign key(fk_onum) references tbl_order(onum),
constraint FK_tbl_review_fk_odnum foreign key(fk_odnum) references tbl_order_detail(odnum),
constraint FK_tbl_review_fk_pnum foreign key(fk_pnum) references tbl_product(pnum),
constraint FK_tbl_review_fk_userid foreign key(fk_userid) references tbl_member(userid)
);




-- 카테고리별 상품 가져오기 --
SELECT cname, sname, pnum, pname, pimage, PRDMANUAL_SYSTEMFILENAME, PRDMANUAL_ORGINFILENAME,
    pqty, price, saleprice, pcontent, PSUMMARY, point, pinputdate, reviewCnt, orederCnt
FROM
    (SELECT ROWNUM AS rno, cname, sname, pnum, pname, pimage, PRDMANUAL_SYSTEMFILENAME, PRDMANUAL_ORGINFILENAME,
            pqty, price, saleprice, pcontent, PSUMMARY, point, pinputdate, reviewCnt, orederCnt
    FROM
        (SELECT c.cname, s.sname, pnum, pname, pimage, PRDMANUAL_SYSTEMFILENAME, PRDMANUAL_ORGINFILENAME,
                pqty, price, saleprice, pcontent, PSUMMARY, point, pinputdate,
                (select distinct count(FK_ONUM) from tbl_order_detail where FK_PNUM=pnum) as orederCnt,
                (select count(RNUM) from tbl_review where FK_PNUM=pnum) as reviewCnt
        FROM
            (SELECT
                pnum, pname, pimage, PRDMANUAL_SYSTEMFILENAME, PRDMANUAL_ORGINFILENAME,
                pqty, price, saleprice, pcontent, PSUMMARY, point,
                to_char(pinputdate, 'yyyy-mm-dd') AS pinputdate, fk_cnum, fk_snum
            FROM tbl_product
            WHERE fk_cnum in (4, 5, 6)
            ORDER BY pnum DESC) p
            JOIN tbl_category  c ON p.fk_cnum = c.cnum
            LEFT OUTER JOIN tbl_spec s
            ON p.fk_snum = s.snum)V
    ) t
WHERE t.rno BETWEEN 1 AND 5;

select ceil( count(*)/10 )  from tbl_product  where fk_cnum in (4,5,6);
    
INSERT INTO tbl_product(PNUM, PNAME, PIMAGE, PQTY, PRICE, SALEPRICE, PSUMMARY, POINT, PINPUTDATE, FK_CNUM)
VALUES (SEQ_PRODUCT_PNUM.nextval, '프리미엄 티 컬렉션', '프리미엄 티 컬렉션.png', 1000, 28000, 28000, 
'취향과 기분에 따라 다채로운 맛과 향을 즐기기 좋은, 알찬 구성의 베스트셀러 티 세트', 
280, sysdate, 4);
COMMIT;


String sql = "SELECT cname, sname, pnum, pname, pimage, PRDMANUAL_SYSTEMFILENAME, PRDMANUAL_ORGINFILENAME,\n"+
"    pqty, price, saleprice, pcontent, PSUMMARY, point, pinputdate, reviewCnt, orederCnt\n"+
"FROM\n"+
"    (SELECT ROWNUM AS rno, cname, sname, pnum, pname, pimage, PRDMANUAL_SYSTEMFILENAME, PRDMANUAL_ORGINFILENAME,\n"+
"            pqty, price, saleprice, pcontent, PSUMMARY, point, pinputdate, reviewCnt, orederCnt\n"+
"    FROM\n"+
"        (SELECT c.cname, s.sname, pnum, pname, pimage, PRDMANUAL_SYSTEMFILENAME, PRDMANUAL_ORGINFILENAME,\n"+
"                pqty, price, saleprice, pcontent, PSUMMARY, point, pinputdate,\n"+
"                (select distinct count(FK_ONUM) from tbl_order_detail where FK_PNUM=pnum) as orederCnt,\n"+
"                (select count(RNUM) from tbl_review where FK_PNUM=pnum) as reviewCnt\n"+
"        FROM\n"+
"            (SELECT\n"+
"                pnum, pname, pimage, PRDMANUAL_SYSTEMFILENAME, PRDMANUAL_ORGINFILENAME,\n"+
"                pqty, price, saleprice, pcontent, PSUMMARY, point,\n"+
"                to_char(pinputdate, 'yyyy-mm-dd') AS pinputdate, fk_cnum, fk_snum\n"+
"            FROM tbl_product\n"+
"            WHERE fk_cnum = ?\n"+
"            ORDER BY ? DESC) p\n"+
"            JOIN tbl_category  c ON p.fk_cnum = c.cnum\n"+
"            LEFT OUTER JOIN tbl_spec s\n"+
"            ON p.fk_snum = s.snum)V\n"+
"    ) t\n"+
"WHERE t.rno BETWEEN ? AND ?";

SELECT cname, sname, pnum, pname, pimage, pqty, price, saleprice, reviewCnt, orederCnt
FROM (SELECT ROWNUM AS rno, cname, sname, pnum, pname, pimage,
pqty, price, saleprice, reviewCnt, orederCnt

FROM

    (SELECT c.cname, s.sname, pnum, pname, pimage, pqty, price, saleprice, orederCnt,reviewCnt 
    FROM
    (SELECT pnum, pname, pimage, pqty, price, saleprice, fk_cnum, fk_snum,
    (select distinct count(FK_ONUM) from tbl_order_detail where FK_PNUM=pnum) as orederCnt,
    (select count(RNUM) from tbl_review where FK_PNUM=pnum) as reviewCnt
    FROM tbl_product
    WHERE pname like '%차%') p
    JOIN tbl_category  c ON p.fk_cnum = c.cnum
    LEFT OUTER JOIN tbl_spec s
    ON p.fk_snum = s.snum
    oRDER BY price desc)v
) t
WHERE t.rno BETWEEN 7 AND 12;