show user;
-- USER이(가) "SEMI_ORAUSER2"입니다.


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



insert into tbl_coin_history(COINNO, FK_USERID, COIN_DATE, COIN_AMOUNT) values(1,'codud1158', sysdate - 3, 2000);

insert into tbl_coin_history(COINNO, FK_USERID, COIN_DATE, COIN_AMOUNT)
 values(seq_coin_history.nextval, 'codud1158',sysdate - 3, 2000);

 commit;
 
 
select COINNO, FK_USERID,  COIN_DATE, COIN_AMOUNT
from tbl_coin_history;



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
) H;

