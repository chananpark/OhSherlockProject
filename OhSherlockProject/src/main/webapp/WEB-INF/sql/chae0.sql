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
from tbl_login_history;

create sequence seq_coin_history
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

desc tbl_coin_history;



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
           order by COIN_DATE desc;
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


   


