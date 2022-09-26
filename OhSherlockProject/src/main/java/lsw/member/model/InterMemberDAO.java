package lsw.member.model;

import java.sql.SQLException;

import common.model.MemberVO;

public interface InterMemberDAO {

	// 회원가입을 해주는 메소드(tbl_member 테이블 insert)(임선우)
	int registerMember(MemberVO member) throws SQLException;

	// ID 중복검사(임선우)
	boolean idDuplicateCheck(String userid) throws SQLException;

	// email 중복검사(임선우) 
	boolean emailDuplicateCheck(String email) throws SQLException;

}
