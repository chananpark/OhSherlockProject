create table tbl_member
(userid             varchar2(40)   not null  -- 회원아이디
,pwd                varchar2(200)  not null  -- 비밀번호 (SHA-256 암호화 대상)
,name               varchar2(30)   not null  -- 회원명
,email              varchar2(200)  not null  -- 이메일 (AES-256 암호화/복호화 대상)
,mobile             varchar2(200)            -- 연락처 (AES-256 암호화/복호화 대상) 
,postcode           varchar2(5)              -- 우편번호
,address            varchar2(200)            -- 주소
,detailaddress      varchar2(200)            -- 상세주소
,extraaddress       varchar2(200)            -- 참고항목
,gender             varchar2(1)              -- 성별   남자:1  / 여자:2
,birthday           varchar2(10)             -- 생년월일   
,coin               number default 0         -- 코인액
,point              number default 0         -- 포인트 
,registerday        date default sysdate     -- 가입일자 
,last_passwd_date  date default sysdate     -- 마지막으로 암호를 변경한 날짜  
,status             number(1) default 1 not null     -- 회원탈퇴유무   1: 사용가능(가입중) / 0:사용불능(탈퇴) 
,idle               number(1) default 0 not null     -- 휴면유무      0 : 활동중  /  1 : 휴면중 
,constraint PK_tbl_member_userid primary key(userid)
,constraint UQ_tbl_member_email  unique(email)
,constraint CK_tbl_member_gender check( gender in('1','2') )
,constraint CK_tbl_member_status check( status in(0,1) )
,constraint CK_tbl_member_idle check( idle in(0,1) )
);

select *
from tbl_member;

insert into tbl_member(userid, passwd, name, email, mobile)
values ('leeye','qWer1234$','이예은','leeye@gmail.com','01012341234')


insert into tbl_member(userid, passwd, name, email, mobile)
values ('sonyj','qWer1234$','손여진','sonyj@gmail.com','01012341234')

commit;

update tbl_member set registerday = add_months(registerday,-4), last_passwd_date = add_months(last_passwd_date, -4)
where userid= 'leeye';

select userid, passwd, name, email, mobile, registerday, last_passwd_date
from tbl_member

delete 
from tbl_member
where userid like '%lim%';



create table tbl_product
(p_code             varchar2(40)  not null  -- 상품코드
,p_category         varchar2(20)            -- 카테고리
,p_name             varchar2(100)           -- 상품명      
,P_price            number                  -- 상품가격
,p_discount_rate    number default 0                  -- 할인율
,p_stock            number default 0                 -- 재고 
,p_soldout          number default 0                 -- 품절여부  품절: 1  품절아님: 0
,p_best             number default 0                 -- 베스트여부 베스트: 1  베스트아님: 0
,p_info             varchar2(400)           -- 상품한줄소개
,p_desc             clob                    -- 상품설명
,p_thumbnail        varchar2(400)           -- 썸네일이미지
,p_image            varchar2(400)           -- 첨부이미지
,p_registerday      date   default sysdate  -- 상품등록일 
,constraint PK_tbl_product_p_code primary key(p_code)
);

insert into tbl_product (p_code, p_category, p_name, p_price, p_discount_rate, p_stock, p_info, p_desc, p_thumbnail, p_image)
values ('1', '기프트박스', '벚꽃향 가득한 올레 20입', 23000, 0.3, 5, '벚꽃향이 아주 가득가득가득합니다.', '올레올레 제주도 올레 나는 제주도 여행가고 싶은데 언제 갈 수 있을까?올레올레 제주도 올레 나는 제주도 여행가고 싶은데 언제 갈 수 있을까?올레올레 제주도 올레 나는 제주도 여행가고 싶은데 언제 갈 수 있을까?올레올레 제주도 올레 나는 제주도 여행가고 싶은데 언제 갈 수 있을까?올레올레 제주도 올레 나는 제주도 여행가고 싶은데 언제 갈 수 있을까?올레올레 제주도 올레 나는 제주도 여행가고 싶은데 언제 갈 수 있을까?올레올레 제주도 올레 나는 제주도 여행가고 싶은데 언제 갈 수 있을까?올레올레 제주도 올레 나는 제주도 여행가고 싶은데 언제 갈 수 있을까?'
        , '벚꽃향가득한올레20입.jpg','tea_collection.png')


insert into tbl_product (p_code, p_category, p_name, p_price, p_discount_rate, p_stock, p_info, p_desc)
values ('c' || seq_pcode.nextval, '기프트박스', '벚꽃향 가득한 올레 20입', 23000, 0.3, 5, '벚꽃향이 아주 가득가득가득합니다.', '올레올레 제주도 올레 나는 제주도 여행가고 싶은데 언제 갈 수 있을까?올레올레 제주도 올레 나는 제주도 여행가고 싶은데 언제 갈 수 있을까?올레올레 제주도 올레 나는 제주도 여행가고 싶은데 언제 갈 수 있을까?올레올레 제주도 올레 나는 제주도 여행가고 싶은데 언제 갈 수 있을까?올레올레 제주도 올레 나는 제주도 여행가고 싶은데 언제 갈 수 있을까?올레올레 제주도 올레 나는 제주도 여행가고 싶은데 언제 갈 수 있을까?올레올레 제주도 올레 나는 제주도 여행가고 싶은데 언제 갈 수 있을까?올레올레 제주도 올레 나는 제주도 여행가고 싶은데 언제 갈 수 있을까?'
      )


select *
from tbl_product


 create sequence seq_pcode
   start with 10000                   -- 첫번째 출발은 1 부터 한다.
   increment by 1                 -- 증가치는 1 이다. 즉, 1씩 증가한다. 
   maxvalue 99999                     -- 최대값이 5 이다.
   minvalue 10000                     -- 최소값이 2 이다.
   cycle                          -- 반복을 한다.
   nocache;



insert into tbl_product (pnum, pname, fk_cnum, pimage, prdmanual_systemfilename, prdmanual_orginfilename, pqty, price, saleprice, fk_snum, pcontent, psummary, point, pinputdate)
values ('1', '기프트박스', '벚꽃향 가득한 올레 20입', 23000, 0.3, 5, '벚꽃향이 아주 가득가득가득합니다.', '올레올레 제주도 올레 나는 제주도 여행가고 싶은데 언제 갈 수 있을까?올레올레 제주도 올레 나는 제주도 여행가고 싶은데 언제 갈 수 있을까?올레올레 제주도 올레 나는 제주도 여행가고 싶은데 언제 갈 수 있을까?올레올레 제주도 올레 나는 제주도 여행가고 싶은데 언제 갈 수 있을까?올레올레 제주도 올레 나는 제주도 여행가고 싶은데 언제 갈 수 있을까?올레올레 제주도 올레 나는 제주도 여행가고 싶은데 언제 갈 수 있을까?올레올레 제주도 올레 나는 제주도 여행가고 싶은데 언제 갈 수 있을까?올레올레 제주도 올레 나는 제주도 여행가고 싶은데 언제 갈 수 있을까?'
        , '벚꽃향가득한올레20입.jpg','tea_collection.png')
   
   
   select pnum, pname, fk_cnum, pimage, prdmanual_systemfilename, prdmanual_orginfilename, pqty, price, saleprice, fk_snum, pcontent, psummary, point, pinputdate
						     from tbl_product
							 where pnum = 1 
                             
select pnum, pname, price, saleprice, pqty, (to_char(pinputdate,'yyyy-mm-dd')) pinputdate
from tbl_product

pnum, pname, fk_cnum, pimage, pqty, price, saleprice, fk_snum, pcontent, psummary, point


create table tbl_product_imagefile
(imgfileno     number         not null   -- 시퀀스로 입력받음.
,fk_pnum       number(8)      not null   -- 제품번호(foreign key)
,imgfilename   varchar2(100)  not null   -- 제품이미지파일명
,constraint PK_tbl_product_imagefile primary key(imgfileno)
,constraint FK_tbl_product_imagefile foreign key(fk_pnum) references tbl_product(pnum) on delete cascade 
);

create sequence seqImgfileno
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

commit;

select imgfileno, fk_pnum, imgfilename
from tbl_product_imagefile
order by imgfileno desc;


select pnum, pname, fk_cnum, pimage, pqty, price, saleprice, fk_snum, pcontent, psummary, point, pinputdate
(
select cnum, cname
from tbl_category
) c join

select pnum, pname, fk_cnum, pimage, pqty, price, saleprice, fk_snum, pcontent, psummary, point, pinputdate
from tbl_product

select S.sname, cname, pnum, pname, fk_cnum, pimage, pqty, price, saleprice, fk_snum, pcontent, psummary, point
    ,pinputdate
    from
(
select C.cname, pnum, pname, fk_cnum, pimage, pqty, price, saleprice, fk_snum, pcontent, psummary, point
    , to_char(pinputdate, 'yyyy-mm-dd') as pinputdate
from tbl_category C left join tbl_product P  
on C.cnum = P.fk_cnum 
)v left join tbl_spec S
on V.fk_snum = S.snum
where pnum = 12

update tbl_product set fk_snum = null
where pnum = 4;

delete from tbl_product
where pnum = 101;


-- 특정 회원 주문내역 조회
select odnum, fk_pnum, oqty, oprice, fk_userid, odrdate, pname, ODRCODE
from
(
select rownum as rno, odnum, fk_pnum, oqty, oprice, fk_userid, odrdate, pname, ODRCODE
from
(
select odnum, fk_pnum, oqty, oprice, fk_userid, odrdate, pname, ODRCODE
from 
(
select fk_userid, substr(odrdate,0,10) odrdate , odnum, fk_pnum, oqty, oprice, ODRCODE
from tbl_order join tbl_order_detail
on odrcode = fk_odrcode  
where FK_USERID = 'pca719'
) v
join tbl_product 
on pnum = fk_pnum
order by odrdate desc) C
) T
where rno between 1 and 10


-- 특정 회원 주문목록 총페이지수
select ceil(count(*)/5)
from tbl_order join tbl_order_detail
on odrcode = fk_odrcode
where fk_userid = 'pca719'


-- 특정 주문코드의 주문조회
select fk_userid, substr(odrdate,0,10) odrdate, recipient_name, recipient_mobile, recipient_postcode, recipient_address, recipient_detail_address, recipient_extra_address, odrtotalprice, delivery_cost, odrstatus,
					 odnum, fk_pnum, oqty, oprice, odrcode, pname
from 
(
select fk_userid, substr(odrdate,0,10) odrdate, recipient_name, recipient_mobile, recipient_postcode, recipient_address, recipient_detail_address, recipient_extra_address, odrtotalprice, delivery_cost, odrstatus,
					 odnum, fk_pnum, oqty, oprice, odrcode
from tbl_order join tbl_order_detail
on odrcode = fk_odrcode  
where FK_USERID = 'pca719' and odrcode = 'O20221014-1'
) v
join tbl_product 
on pnum = fk_pnum
order by odrdate desc

---------------------------------------------
select fk_userid, odrdate, recipient_name, recipient_mobile, recipient_postcode, recipient_address, recipient_detail_address, recipient_extra_address, odrtotalprice, delivery_cost, odrstatus,
					 odnum, fk_pnum, oqty, oprice, odrcode, pname
from 
(
select fk_userid, odrdate, recipient_name, recipient_mobile, recipient_postcode, recipient_address, recipient_detail_address, recipient_extra_address, odrtotalprice, delivery_cost, odrstatus,
					 odnum, fk_pnum, oqty, oprice, odrcode
from tbl_order join tbl_order_detail
on odrcode = fk_odrcode  
where FK_USERID = 'pca719' and odrcode = 'O20221014-1'
) v
join tbl_product 
on pnum = fk_pnum
order by odrdate desc





select odnum, fk_pnum, oqty, oprice, fk_userid, odrdate, pname, ODRCODE
from 
(
select fk_userid, substr(odrdate,0,10) odrdate , odnum, fk_pnum, oqty, oprice, ODRCODE
from tbl_order join tbl_order_detail
on odrcode = fk_odrcode  
where FK_USERID = 'pca719' and odrcode = 'O20221014-1'
) v
join tbl_product 
on pnum = fk_pnum

----------------------------------------------------------------------
-- 특정 주문코드 상세 
select odnum, fk_pnum, oqty, oprice, fk_userid, odrdate, pname, pimage, ODRCODE
from 
(
select fk_userid, substr(odrdate,0,10) odrdate , odnum, fk_pnum, oqty, oprice, ODRCODE
from tbl_order join tbl_order_detail
on odrcode = fk_odrcode  
where FK_USERID = 'pca719' and odrcode = 'O20221014-1'
) v
join tbl_product 
on pnum = fk_pnum

select *
from tbl_product

select fk_userid, odrdate, recipient_name, recipient_mobile, recipient_postcode, recipient_address, recipient_detail_address, recipient_extra_address, odrtotalprice, delivery_cost, odrstatus 
from tbl_order
where odrcode = 'O20221014-1'


select *
from tbl_order join tbl_order_detail
on odrcode = fk_odrcode  
where FK_USERID = 'pca719' and odrcode = 'O20221014-1'

commit

select ODRCODE, FK_USERID, to_char(ODRDATE,'yyyy-mm-dd hh24:mi:ss') as ODRDATE, ODRTOTALPRICE
from tbl_order
where FK_USERID = 'pca719'
order by ODRDATE desc;
