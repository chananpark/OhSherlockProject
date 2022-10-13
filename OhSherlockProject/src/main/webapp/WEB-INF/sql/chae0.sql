show user;
-- USER이(가) "SEMI_ORAUSER2"입니다.


update tbl_member set coin 



select *
from tbl_member
order by registerday desc;

rollback;

select *
from tbl_coin_history;

select *
from tbl_point_history;

select *
from tbl_login_history;

create sequence seq_coin_history
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

desc tbl_coin_history;
desc tbl_point_history;


insert into tbl_coin_history(COINNO, FK_USERID, COIN_AMOUNT)
values(seq_coin_history.nextval, ?, ? )



delete into tbl_coin_history(COINNO, FK_USERID, COIN_AMOUNT)
 values(seq_coin_history.nextval, 'codud1158',2000);



insert into tbl_coin_history(COINNO, FK_USERID, COIN_AMOUNT)
 values(seq_coin_history.nextval, 'codud1158',9000);

 commit;
 
 
select COINNO, FK_USERID,  COIN_DATE, COIN_AMOUNT
from tbl_coin_history




SELECT userid, coin, COINNO,  COIN_DATE, COIN_AMOUNT
FROM 
(
    select userid, coin
    from tbl_member
    where status = 1 and userid = 'codud1158' and PASSWD = '9695b88a59a1610320897fa84cb7e144cc51f2984520efb77111d94b402a8382' 
) M 
CROSS JOIN 
(
    select COINNO, COIN_DATE, COIN_AMOUNT
    from tbl_coin_history
    where fk_userid = 'codud1158'
    order by COIN_DATE desc
) H;



-- 1 페이지 ==> RNO : 1 ~ 10
    -- [올바른것]
    select userid, name, email, gender
    from
    (
        select rownum AS RNO, userid, coin, COINNO,  COIN_DATE, COIN_AMOUNT 
        from
        (
           SELECT userid, coin, COINNO,  COIN_DATE, COIN_AMOUNT
            FROM 
            (
                select userid, coin
                from tbl_member
                where status = 1 and userid = 'codud1158' and PASSWD = '9695b88a59a1610320897fa84cb7e144cc51f2984520efb77111d94b402a8382' 
            ) M 
            CROSS JOIN 
            (
                select COINNO, COIN_DATE, COIN_AMOUNT
                from tbl_coin_history
                where fk_userid = 'codud1158'
                order by COIN_DATE desc
            ) H
        ) V 
    )T
    where RNO between 1 and 10; 
/*
    === 페이징처리의 공식 ===
    where RNO between (조회하고자 하는 페이지번호 * 한페이지당 보여줄 행의 개수) - (한페이지당 보여줄 행의 개수 - 1) and (조회하고자 하는 페이지번호 * 한페이지당 보여줄 행의 개수);
    
    where RNO between (1 * 10) - (10 - 1) and (1 * 10);
    where RNO between (10) - (9) and (10)
    where RNO between 1 and 10;
*/




-- 1 페이지 ==> RNO : 1 ~ 10
    -- [올바른것]
    select COINNO, FK_USERID,  COIN_DATE, COIN_AMOUNT
    from
    (
        select rownum AS RNO, COINNO, FK_USERID,  COIN_DATE, COIN_AMOUNT
        from
        (
           select COINNO, FK_USERID,  COIN_DATE, COIN_AMOUNT
           from tbl_coin_history
           order by COINNO desc;
        ) V 
    )T
    where RNO between 1 and 10; 
/*
    === 페이징처리의 공식 ===
    where RNO between (조회하고자 하는 페이지번호 * 한페이지당 보여줄 행의 개수) - (한페이지당 보여줄 행의 개수 - 1) and (조회하고자 하는 페이지번호 * 한페이지당 보여줄 행의 개수);
    
    where RNO between (1 * 10) - (10 - 1) and (1 * 10);
    where RNO between (10) - (9) and (10)
    where RNO between 1 and 10;
*/


   
   select ceil(count(*)/10)
   from tbl_coin_history;
   
   
    select COIN_DATE
    from tbl_coin_history
    where COIN_DATE between date("22/09/24") and date("22/09/28")
    order by COIN_DATE desc;


    SELECT COINNO, FK_USERID,  COIN_DATE, COIN_AMOUNT 
    FROM tbl_coin_history 
    WHERE COIN_DATE BETWEEN '22/09/24' AND '22/09/28'
    order by COIN_DATE desc;
    
    
    
    
 drop table TBL_POINT_HISTORY purge;
 drop table TBL_POINT_HISTORY;   
    
    
create sequence seq_point_history
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;    


insert into TBL_POINT_HISTORY(POINTNO, FK_USERID, POINT_AMOUNT)
values(seq_point_history.nextval, 'codud1158',8000);



-- 1 페이지 ==> RNO : 1 ~ 10
    -- [올바른것]
    select POINTNO, FK_USERID,  POINT_DATE, POINT_AMOUNT
    from
    (
        select rownum AS RNO, POINTNO, FK_USERID,  POINT_DATE, POINT_AMOUNT
        from
        (
           select POINTNO, FK_USERID,  POINT_DATE, POINT_AMOUNT
           from tbl_POINT_history
           order by POINTNO desc;
        ) V 
    )T
    where RNO between 5 and 7; 
    
    
    
insert all 
into tbl_coin_history(COINNO, FK_USERID, COIN_AMOUNT) values(seq_coin_history.nextval, 'lee0ji',9000 ) 
into tbl_point_history(POINTNO, FK_USERID, POINT_AMOUNT) values(seq_point_history.nextval, 'lee0ji',9000 )
select *
from dual;    
    
commit;   

update tbl_coin_history set COIN_DATE = to_date('2022-10-01', 'yyyy-mm-dd') where fk_userid='lee0ji';
    
    
    
   SELECT
    coinno,
    fk_userid,
    coin_date,
    coin_amount
FROM
    (
        SELECT
            ROWNUM AS rno,
            coinno,
            fk_userid,
            coin_date,
            coin_amount
        FROM
            (
                SELECT
                    coinno,
                    fk_userid,
                    coin_date,
                    coin_amount
                FROM
                    tbl_coin_history
                WHERE
                    coin_date BETWEEN TO_DATE('2022-10-01', 'yyyy-mm-dd') AND TO_DATE('2022-10-04', 'yyyy-mm-dd')
                ORDER BY
                    coin_date DESC
            ) v
    ) t
WHERE
    rno BETWEEN 1 AND 10;
    
    
    
    
    
    
    
    
    
insert all 
into tbl_coin_history(COINNO, COIN_AMOUNT) values(seq_coin_history.nextval, 9000 ) 
into tbl_point_history(POINTNO, POINT_AMOUNT) values(seq_point_history.nextval, 9000 )
select *
from dual
where fk_userid = 'codud1158';      
    
    
    
select S.sname, pnum, pname, price, saleprice, point, pqty, pcontent, pimage, prdmanual_systemFileName, nvl(prdmanual_orginFileName, '없음') AS prdmanual_orginFileName
from 
(
select fk_snum, pnum, pname, price, saleprice, point, pqty, pcontent, pimage, prdmanual_systemFileName, prdmanual_orginFileName
from tbl_product
where pnum = 16
) P JOIN tbl_spec S
ON P.fk_snum = S.SNUM;    
    
    
select imgfilename
from tbl_product_imagefile
where fk_pnum = 16;
    


create table tbl_review
(rnum        not null number(8)     -- 리뷰번호
,fk_odnum    not null number(8)     -- 주문번호
,fk_pnum     not null number(8)     -- 상품코드 
,fk_userid   not null varchar2(15)  -- 아이디 
,score       not null number(2)     -- 별점 
,rsubject    not null varchar2(100) -- 리뷰제목
,rcontent    not null varchar2(500) -- 리뷰내용
,rimage               varchar2(100) -- 첨부파일
,fk_odrcode  not null varchar2(20)  -- 주문상세번호
,registerday date default sysdate   -- 리뷰 작성일자
,constraint PK_tbl_review_rnum primary key(rnum)
,constraint fk_tbl_review_fk_odrcode foreign key(fk_odrcode) references tbl_order(odrcode)
,constraint FK_tbl_review_fk_odnum foreign key(fk_odnum) references tbl_order_detail(odnum)
,constraint FK_tbl_review_fk_pnum foreign key(fk_pnum) references tbl_product(pnum)
,constraint FK_tbl_review_fk_userid foreign key(fk_userid) references tbl_member(userid)
);

select RNUM, FK_ODNUM, FK_PNUM, FK_USERID, SCORE, RSUBJECT, RCONTENT, RIMAGE, FK_ODRCODE, WRITEDATE
from TBL_REVIEW;

select *
from TBL_PRODUCT;

select *
from tbl_order_detail;

select ceil(count(*)/?) from TBL_REVIEW


select rnum, rsubject, fk_userid, writedate, score
from TBL_REVIEW 
where rnum = 2

select rnum, rsubject, fk_userid, writedate, score
from 
    (select rownum as rno, rnum, rsubject, fk_userid, writedate, score 
     from 
         (select rnum, rsubject, fk_userid, writedate, score
          from TBL_REVIEW  
          order by 1 desc) V 
    ) T 
where RNO between 1 and 6
             
 rnum, rsubject, fk_userid, writedate, score, rcontent
 
select rnum, fk_userid, fk_pnum, rsubject, rcontent, to_char(writeDate, 'yyyy-mm-dd') AS writeDate, score
from TBL_REVIEW
where fk_pnum = 32
order by rnum desc;   
 
 
select rnum, fk_userid, fk_pnum, rsubject, rcontent, to_char(writeDate, 'yyyy-mm-dd') AS writeDate, score
from 
    (select rownum as rno, rnum, fk_userid, fk_pnum, rsubject, rcontent, writeDate, score
     from 
         (select rnum, fk_userid, fk_pnum, rsubject, rcontent, writeDate, score
          from TBL_REVIEW
          where fk_pnum = 1
          order by 1 desc) V 
    ) T 
where RNO between 1 and 6  


select *
from TBL_REVIEW



select inquiry_type, inquiry_subject,
inquiry_content, inquiry_date, inquiry_answered
from tbl_inquiry
where inquiry_no = 89


select rsubject, rcontent, score
from TBL_REVIEW
where rnum = 14


