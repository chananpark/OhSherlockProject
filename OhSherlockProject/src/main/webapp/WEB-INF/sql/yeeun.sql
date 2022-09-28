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
where userid = 'leeye06';
commit;

String sql = "update tbl_member set status = 0\n"+
"where userid = ?";


