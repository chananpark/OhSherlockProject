show user; 
-- USER이(가) "SEMI_ORAUSER2"입니다.

-- 전체회원 조회
select *
from tbl_member
order by registerday desc;

-- tbl_member 테이블 보기
describe tbl_member;

delete from tbl_member
where userid= 'leeye06';
commit;

delete from tbl_login_history
where fk_userid= 'leeye06';
commit;

-- 회원계정 사용가능
update tbl_member set status = '1'
where userid = 'leeye05';
commit;

String sql = "update tbl_member set status = 0\n"+
"where userid = ?";


---------------------------------------------------------------------------------------

select * from tab;  -- 모든 테이블 및 뷰 조회
-- 테이블 보기
describe TBL_SPEC;
describe TBL_CATEGORY;
describe tbl_product;


---- *** 제품 테이블 : tbl_product *** ----
-- drop table tbl_product purge; 
create table tbl_product
(pnum           number(8) not null       -- 제품번호(Primary Key)
,pname          varchar2(100) not null   -- 제품명
,fk_code        varchar2(20)                -- 카테고리코드(Foreign Key)의 시퀀스번호 참조
,pimage         varchar2(100) default 'noimage.png' -- 'noimage.png' -- 썸네일 이미지 파일명
,prdmanual_systemFileName varchar2(200)            -- 파일서버에 업로드되어지는 실제 제품설명서 파일명 (파일명이 중복되는 것을 피하기 위해서 중복된 파일명이 있으면 파일명뒤에 숫자가 자동적으로 붙어 생성됨)
,prdmanual_orginFileName  varchar2(200)            -- 웹클라이언트의 웹브라우저에서 파일을 업로드 할때 올리는 제품설명서 파일명 
,pqty           number(8) default 0      -- 제품 재고량
,price          number(8) default 0      -- 제품 정가
,saleprice      number(8) default 0      -- 제품 판매가(할인해서 팔 것이므로)
,fk_snum        number(8)                -- 'NEW', 'BEST' 에 대한 스펙번호인 시퀀스번호를 참조
,pcontent       varchar2(4000)           -- 제품설명  varchar2는 varchar2(4000) 최대값이므로
                                         -- 4000 byte 를 초과하는 경우 clob 를 사용한다. 제품설명이 길어질 때는 clob 을 사용하면 된다.
                                         -- clob 는 최대 4GB 까지 지원한다. ** clob 는 글자를 4GB 까지 저장가능하다. 사이즈가 큰 데이터를 외부파일로 저장하기 위한 데이터 타입이다. 용량이 너무 크기때문에 자유게시판에서 잘 사용하지 않는다. 단, 운영자는 사용할 수 있다.
,psummary	    Nvarchar2(200)                                  
,point          number(8) default 0      -- 포인트 점수                                         
,pinputdate     date default sysdate     -- 제품입고일자
,constraint  PK_tbl_product_pnum primary key(pnum)
,constraint  FK_tbl_product_fk_code foreign key(fk_code) references tbl_category(cnum)
,constraint  FK_tbl_product_fk_snum foreign key(fk_snum) references tbl_spec(snum)
);

-- drop sequence seq_tbl_product_pnum;
create sequence seq_tbl_product_pnum
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;




-- 상품별 스펙명(New, Best) 테이블
-- drop table tbl_spec purge;
create table tbl_spec
(snum    number(8)     not null  -- 스펙번호       
,sname   varchar2(100) not null  -- 스펙명         
,constraint PK_tbl_spec_snum primary key(snum)
,constraint UQ_tbl_spec_sname unique(sname)
);

-- drop sequence seq_spec_snum;
create sequence seq_spec_snum
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;


insert into tbl_spec(snum, sname) values(seq_spec_snum.nextval, 'NEW');
insert into tbl_spec(snum, sname) values(seq_spec_snum.nextval, 'BEST');

commit;

-- tbl_spec 테이블 전체 조회
select snum, sname
from tbl_spec
order by snum asc;


/*
   컬럼정의 
     -- 카테고리 대분류 번호  : 시퀀스(seq_category_cnum)로 증가함.(Primary Key)
     -- 카테고리 코드(unique) : ex) 전자제품  '100000'
                                  의류      '200000'
                                  도서      '300000' 
     -- 카테고리명(not null)  : 전자제품, 의류, 도서           
  
*/ 
-- 카테고리 테이블명 : tbl_category
-- drop table tbl_category purge; 
create table tbl_category
(code    varchar2(20)  not null  -- 카테고리 코드
,cname   varchar2(100) not null  -- 카테고리명
,constraint PK_tbl_category_cnum primary key(cnum)
,constraint UQ_tbl_category_code unique(code)
);

-- drop sequence seq_category_cnum;
create sequence seq_category_cnum 
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;


/*
insert into tbl_category(cnum, code, cname) values(seq_category_cnum.nextval, '10000', '베스트');
insert into tbl_category(cnum, code, cname) values(seq_category_cnum.nextval, '20000', '녹차말차');
insert into tbl_category(cnum, code, cname) values(seq_category_cnum.nextval, '30000', '홍차');
insert into tbl_category(cnum, code, cname) values(seq_category_cnum.nextval, '40000', '허브차');

commit;
*/


-- tbl_category 테이블에서 카테고리 카테고리코드(code), 카테고리명(cname)을 조회해오기
select code, cname
from tbl_category
order by code asc;


-- 컬럼값이 1 인 HIT 상품의 전체개수를 알아온다.
select count(*)
from tbl_product
where fk_snum = 1;  

select count(*)
from tbl_product
where fk_snum = '1';  

from tbl_product
where snum = 1; 

-------------------------------------------------------------------------------------------


--- HIT 상품에 대해서 1~8번까지 조회를 해온다. ---
select pnum, pname, code, pimage, pqty, price, saleprice, sname, pcontent, point, pinputdate
from 
(
    select row_number() over(order by pnum desc) AS RNO -- 최신 제품을 먼저보인다. 제품번호가 클수록 최신 제품이다.
         , pnum, pname, C.code, pimage, pqty, price, saleprice, s.sname, pcontent, psummary, point
         , to_char(pinputdate, 'yyyy-mm-dd') as pinputdate
    from tbl_product P
    JOIN tbl_category C
    ON P.fk_cnum = C.cnum
    JOIN tbl_spec S
    ON P.fk_snum = S.snum
    where S.sname = 'NEW'
) V
where V.RNO between 1 and 8;


select count(*)
from tbl_product
where fk_snum = '1';
