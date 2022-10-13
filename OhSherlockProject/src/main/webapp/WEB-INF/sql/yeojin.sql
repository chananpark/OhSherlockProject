
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
VALUES (SEQ_PRODUCT_PNUM.nextval, '가루녹차', '가루녹차.png', 10, 15000, 12000, 1, '제주 녹차로 만든 고급 가루 녹차', if(PRICE=SALEPRICE, PRICE*0.01, SALEPRICE*0.01), sysdate, 1);

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

INSERT INTO tbl_product(PNUM, PNAME, PIMAGE, PQTY, PRICE, SALEPRICE, FK_SNUM, PSUMMARY, POINT, PINPUTDATE, FK_CNUM)
VALUES (SEQ_PRODUCT_PNUM.nextval, '가루녹차', '가루녹차.png', 10, 15000, 12000, 1, '제주 녹차로 만든 고급 가루 녹차', 
(select case when PRICE = SALEPRICE then PRICE*0.01 else SALEPRICE*0.01 end as point from tbl_product), sysdate, 1);

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
from tbl_product;



-- 카테고리별 상품 가져오기 --
SELECT cname, sname, pnum, pname, pimage, PRDMANUAL_SYSTEMFILENAME, PRDMANUAL_ORGINFILENAME,
    pqty, price, saleprice, pcontent, PSUMMARY, point, pinputdate,
    reviewCnt , -- 리뷰수
    orederCnt -- 판매수
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
            WHERE saleprice != price)p
            JOIN tbl_category  c ON p.fk_cnum = c.cnum
            LEFT OUTER JOIN tbl_spec s
            ON p.fk_snum = s.snum)V
    ) t
-- WHERE t.rno BETWEEN 1 AND 5
ORDER BY pnum desc;

select ceil(count(*)/6) 
from tbl_product 
where saleprice != price;

select cnum, code, cname
from tbl_category
where cnum between 1 and 3;

select ceil(count(*)/6) 
from tbl_product 
where saleprice != price and FK_SNUM = 2;



SELECT cname, sname, pnum, pname, pimage, PRDMANUAL_SYSTEMFILENAME, PRDMANUAL_ORGINFILENAME,
    pqty, price, saleprice, pcontent, PSUMMARY, point, pinputdate,
    reviewCnt , -- 리뷰수
    orederCnt -- 판매수
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
            WHERE saleprice != price 
  )p
            JOIN tbl_category  c ON p.fk_cnum = c.cnum
            LEFT OUTER JOIN tbl_spec s
            ON p.fk_snum = s.snum)V
    ) t
--    WHERE t.rno BETWEEN 1 AND 5
ORDER BY  pnum desc



----------------------장바구니 테이블 생성하기----------------------
-- 로그인 한 회원만 장바구니 가능

desc tbl_member;
desc tbl_product;

create table tbl_cart
 (cartno        number               not null   --  장바구니 번호             
 ,fk_userid     varchar2(20)         not null   --  사용자ID            
 ,fk_pnum       number(8)            not null   --  제품번호                
 ,oqty          number(8) default 0  not null   --  주문량                   
 ,registerday   date default sysdate            --  장바구니 입력날짜
 ,constraint PK_tbl_cart_cartno primary key(cartno)
 ,constraint FK_tbl_cart_fk_userid foreign key(fk_userid) references tbl_member(userid) 
 ,constraint FK_tbl_cart_fk_pnum foreign key(fk_pnum) references tbl_product(pnum)
);

 create sequence seq_tbl_cart_cartno
 start with 1
 increment by 1
 nomaxvalue
 nominvalue
 nocycle
 nocache;

 comment on table tbl_cart
 is '장바구니 테이블';

 comment on column tbl_cart.cartno
 is '장바구니번호(시퀀스명 : seq_tbl_cart_cartno)';

 comment on column tbl_cart.fk_userid
 is '회원ID  tbl_member 테이블의 userid 컬럼을 참조한다.';

 comment on column tbl_cart.fk_pnum
 is '제품번호 tbl_product 테이블의 pnum 컬럼을 참조한다.';

 comment on column tbl_cart.oqty
 is '장바구니에 담을 제품의 주문량';

 comment on column tbl_cart.registerday
 is '장바구니에 담은 날짜. 기본값 sysdate';


select *
from user_tab_comments;

select column_name, comments
from user_col_comments
where table_name = 'TBL_CART';

select cartno, fk_userid, fk_pnum, oqty, registerday 
from tbl_cart
order by cartno asc;
-- 1 syj1234 60 2 2022-10-06 11:00
-- 장바구니에 해당 상품이 존재한다면, 장바구니에 추가하더라도 update를 해야한다. 무조건 insert 가 아니다. 


select A.cartno, A.fk_userid, A.fk_pnum, 
       B.pname, B.pimage, B.price, B.saleprice, B.point, A.oqty, B.pqty
from tbl_cart A join tbl_product B
on A.fk_pnum = B.pnum
where A.fk_userid = 'shonyj1'
order by A.cartno desc;

select nvl(sum(B.saleprice*A.oqty),0) as sumtotalprice, 
       nvl(sum(B.point*A.oqty),0) as sumtotalpoint 
from tbl_cart A join tbl_product B
on A.fk_pnum = B.pnum
where A.fk_userid = 'shonyj1'
order by A.cartno desc;

-- 장바구니에 없을 경우 null 이 아니라 0 값을 넘겨준다.
select nvl(sum(B.saleprice*A.oqty),0) as sumtotalprice, 
       nvl(sum(B.point*A.oqty),0) as sumtotalpoint,
       nvl(sum(B.price*A.oqty),0) as sumtotaloriginprice
from tbl_cart A join tbl_product B
on A.fk_pnum = B.pnum
where A.fk_userid = 'shonyj1'
order by A.cartno desc;

update tbl_cart set oqty = 1
where cartno = 5;

select *
from tbl_cart


select *
from tbl_like

select *
from tbl_member

-- 1대1문의

select rownum, inquiry_no, fk_userid, inquiry_type, inquiry_subject, inquiry_content, to_char(inquiry_date,'yyyy.MM.dd') as inquiry_date
from
(select  inquiry_no, fk_userid, inquiry_type, inquiry_subject, inquiry_content, inquiry_date
from tbl_inquiry
where fk_userid='shonyj1'
order by inquiry_date desc)
where rownum between 1 and 3

select ODRCODE, FK_USERID, to_char(ODRDATE,'yyyy.MM.dd') as ODRDATE, ODRTOTALPRICE
from tbl_order
where (ODRDATE between add_months(sysdate,-1) and sysdate) and FK_USERID = '5sherlock'
order by ODRDATE desc;

select ODRCODE, FK_USERID, to_char(ODRDATE,'yyyy.MM.dd') as ODRDATE, ODRTOTALPRICE
from tbl_order
where (ODRDATE between '2022.10.01' and '2022.10.14') and FK_USERID = 'pca719'
order by ODRDATE desc;

select *
from tbl_order_detail

select ODRCODE, FK_USERID, to_char(ODRDATE,'yyyy.MM.dd') as ODRDATE, ODRTOTALPRICE
from tbl_order 
where ODRDATE between to_char(add_months(sysdate,-1), 'yyyy-MM-dd') and to_char(sysdate, 'yyyy-MM-dd') and FK_USERID = 'pca719'
order by ODRDATE desc;


select odrcode, fk_pnum, fk_userid, to_char(ODRDATE,'yyyy.MM.dd') as ODRDATE, ODRTOTALPRICE, pname
from tbl_order_detail D JOIN tbl_order O
on D.fk_odrcode = O.ODRCODE
JOIN tbl_product P
on d.fk_pnum = P.pnum
where ODRDATE between to_char(add_months(sysdate,-1), 'yyyy-MM-dd') and to_char(sysdate, 'yyyy-MM-dd') and FK_USERID = 'pca719'
order by ODRDATE desc;

select odnum, fk_pnum, oqty, fk_userid, odrdate, pname, odrcode, ODRTOTALPRICE
from   
   (select rownum as rno, odnum, fk_pnum, oqty, oprice, fk_userid, odrdate, pname, pimage, odrcode, ODRTOTALPRICE   
    from    
        (select odnum, fk_pnum, oqty, oprice, fk_userid, odrdate, pname, pimage, odrcode, ODRTOTALPRICE   
        from   
            ( select fk_userid, odrdate, odnum, fk_pnum, oqty, oprice, odrcode, ODRTOTALPRICE 
              from tbl_order join tbl_order_detail  on odrcode = fk_odrcode
              where fk_userid = 'pca719' and odrdate between to_char(add_months(sysdate,-1), 'yyyy-MM-dd') and to_char(sysdate, 'yyyy-MM-dd')  ) v 
join tbl_product   
on pnum = fk_pnum  order by odrdate desc) C  ) T 



-- 상품 상세보기 sql
 select S.sname, pnum, pname, price, saleprice, point, pqty, psummary, pimage, prdmanual_systemfilename, nvl(prdmanual_orginfilename, '없음') AS prdmanual_orginfilename  
 from   (  select fk_snum, pnum, pname, price, saleprice, point, pqty, psummary, pimage, fk_cnum
            from tbl_product  
            where pnum = 1  ) P 
outer JOIN tbl_spec S  ON P.fk_snum = S.SNUM 


select  likeno, fk_userid, pnum, pname, pimage
from tbl_like L join tbl_product P
on P.pnum = L.fk_pnum

INSERT INTO tbl_product_imagefile(imgfileno, fk_pnum, imgfilename)
VALUES (SEQ_IMGFILENO.nextval, 14, '찬물루이보스티상세.png');

INSERT INTO tbl_product_imagefile(imgfileno, fk_pnum, imgfilename)
VALUES (SEQ_IMGFILENO.nextval, 15, '제주쑥차상세.png');

INSERT INTO tbl_product_imagefile(imgfileno, fk_pnum, imgfilename)
VALUES (SEQ_IMGFILENO.nextval, 19, '루이보스3입상세.png');

INSERT INTO tbl_product_imagefile(imgfileno, fk_pnum, imgfilename)
VALUES (SEQ_IMGFILENO.nextval, 35, '메모리인제주상세.png');

INSERT INTO tbl_product_imagefile(imgfileno, fk_pnum, imgfilename)
VALUES (SEQ_IMGFILENO.nextval, 37, '베스트 블렌디드 티백 박스상세.png');

commit;


select pnum, pname, pimage, imgfileno, imgfilename
from tbl_product P join tbl_product_imagefile I
on P.pnum = I.fk_pnum
where pnum = 14