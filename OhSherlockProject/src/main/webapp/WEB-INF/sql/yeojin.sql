
show user;
-- USER이(가) "SEMI_ORAUSER2"입니다.

desc tbl_member;

-- TBL_MEMBER 테이블에 생성된 제약조건 조회하기
    select A.constraint_name, A.constraint_type, A.search_condition, A.r_constraint_name, 
           A.status, A.index_name, B.column_name, B.position
    from user_constraints A JOIN user_cons_columns B
    on A.constraint_name = B.constraint_name
    where A.table_name = 'tbl_member';