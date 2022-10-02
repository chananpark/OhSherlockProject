
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


select userid, name, mobile, email, postcode, (address || ' ' || detail_address || ' ' || extra_address) as address, birthday, gender, coin, point, registerday
from tbl_member
where userid = 'imbori1';


----------------------------------------------------------------------------------------------------------------
-- 자주묻는질문 테이블
create table tbl_faq
(faq_num              number   not null
,faq_category            Nvarchar2(20)   not null
,faq_subject             Nvarchar2(100)   not null
,faq_content             clob not null
,constraint PK_tbl_faq_faq_num primary key(faq_num)
);

create sequence seq_faq
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

insert into tbl_faq(faq_num, faq_category, faq_subject, faq_content) values(seq_faq.nextval, '운영','고객센터 운영 시간이 궁금해요.','상담 가능한 시간은 AM 09:30-PM 6:00 이며 점심시간은 PM 12:30-PM 1:30 입니다.'|| chr(10) || '(주말 및 공휴일 휴무) 상담 시간 외의 문의는 게시판이나 메일, 채팅 문의 주시면 가능한 빠른 시간에 답변을 드릴 수 있도록 하겠습니다.');

select faq_num, faq_category, faq_subject, faq_content
from tbl_faq
where faq_category = 'delivery'; -- categoryid 가 all 이 넘어오면 where절 제외하기


select faq_num, faq_category, faq_subject, faq_content
from tbl_faq
where faq_num = '7'; 


delete tbl_faq where faq_num = '14';
commit;


--------------------------------------------------------------------------------------------------------
-- 상품정보 테이블 select

select PNUM, PNAME, PIMAGE, PRDMANUAL_SYSTEMFILENAME,PRDMANUAL_ORGINFILENAME, PQTY, PRICE, SALEPRICE, FK_SNUM, PCONTENT, PSUMMARY, POINT, PINPUTDATE, FK_CNUM
from tbl_product;


INSERT INTO tbl_product(PNUM, PNAME, PIMAGE, PQTY, PRICE, SALEPRICE, FK_SNUM, PSUMMARY, POINT, PINPUTDATE, FK_CNUM)
VALUES (SEQ_PRODUCT_PNUM.nextval, '가루녹차', '가루녹차.png', 10, 15000, 12000, 1, '제주 녹차로 만든 고급 가루 녹차', ,sysdate, 1);

INSERT INTO tbl_product(PNUM, PNAME, PIMAGE, PQTY, PRICE, SALEPRICE, FK_SNUM, PSUMMARY, PINPUTDATE, FK_CNUM)
VALUES (SEQ_PRODUCT_PNUM.nextval, '가루녹차', '가루녹차.png', 10, 15000, 12000, 1, '제주 녹차로 만든 고급 가루 녹차', sysdate, 1);

INSERT INTO tbl_product(PNUM, PNAME, PIMAGE, PQTY, PRICE, SALEPRICE, FK_SNUM, PSUMMARY, PINPUTDATE, FK_CNUM)
VALUES (SEQ_PRODUCT_PNUM.nextval, '가루녹차', '가루녹차.png', 10, 15000, 12000, 1, '제주 녹차로 만든 고급 가루 녹차', sysdate, 1);

INSERT INTO tbl_product(PNUM, PNAME, PIMAGE, PQTY, PRICE, SALEPRICE, FK_SNUM, PSUMMARY, PINPUTDATE, FK_CNUM)
VALUES (SEQ_PRODUCT_PNUM.nextval, '가루녹차', '가루녹차.png', 10, 15000, 12000, 1, '제주 녹차로 만든 고급 가루 녹차', sysdate, 1);

INSERT INTO tbl_product(PNUM, PNAME, PIMAGE, PQTY, PRICE, SALEPRICE, FK_SNUM, PSUMMARY, PINPUTDATE, FK_CNUM)
VALUES (SEQ_PRODUCT_PNUM.nextval, '가루녹차', '가루녹차.png', 10, 15000, 12000, 1, '제주 녹차로 만든 고급 가루 녹차', sysdate, 1);

INSERT INTO tbl_product(PNUM, PNAME, PIMAGE, PQTY, PRICE, SALEPRICE,  PSUMMARY, PINPUTDATE, FK_CNUM)
VALUES (SEQ_PRODUCT_PNUM.nextval, '가루녹차2', '가루녹차.png', 10, 15000, 12000, '제주 녹차로 만든 고급 가루 녹차', sysdate, 1);

select CNUM, CODE, CNAME
from tbl_category;

insert into tbl_category(CNUM, CODE, CNAME)
values (seq_category_cnum.nextval, 10000, 'greentea');

insert into tbl_category(CNUM, CODE, CNAME)
values (seq_category_cnum.nextval, 20000, 'blacktea');

insert into tbl_category(CNUM, CODE, CNAME)
values (seq_category_cnum.nextval, 30000, 'herbtea');

-- 40000, 50000, 60000 은 세트상품

commit;

select PNUM, PNAME, PIMAGE, PRDMANUAL_SYSTEMFILENAME,PRDMANUAL_ORGINFILENAME, PQTY, PRICE, SALEPRICE, FK_SNUM, PCONTENT, PSUMMARY, POINT, PINPUTDATE, FK_CNUM
from tbl_product


         String sql = "select cname, sname, pnum, pname, pcompany, pimage1, pimage2, pqty, price, saleprice, pcontent, point, pinputdate "+
                   "from "+
                   "( "+
                   "    select rownum AS RNO, cname, sname, pnum, pname, pcompany, pimage1, pimage2, pqty, price, saleprice, pcontent, point, pinputdate "+ 
                   "    from "+
                   "    ( "+
                   "        select C.cname, S.sname, pnum, pname, pcompany, pimage1, pimage2, pqty, price, saleprice, pcontent, point, pinputdate "+
                   "        from "+
                   "            (select pnum, pname, pcompany, pimage1, pimage2, pqty, price, saleprice, pcontent, point "+
                   "                  , to_char(pinputdate, 'yyyy-mm-dd') as pinputdate, fk_cnum, fk_snum  "+
                   "             from tbl_product  "+
                   "             where fk_cnum = ? "+
                   "             order by pnum desc "+
                   "        ) P "+
                   "        JOIN tbl_category C "+
                   "        ON P.fk_cnum = C.cnum "+
                   "        left outer JOIN tbl_spec S "+
                   "        ON P.fk_snum = S.snum "+
                   "    ) V "+
                   ") T "+
                   "where T.RNO between 1 and 10 ";










