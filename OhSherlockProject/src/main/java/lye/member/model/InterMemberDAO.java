package lye.member.model;

import java.sql.SQLException;
import java.util.Map;

import common.model.MemberVO;

public interface InterMemberDAO {

	// 아이디 찾기(성명, 이메일을 입력받아서 해당 사용자의 아이디를 알려준다)
	String idFind(Map<String, String> paraMap) throws SQLException;

	// 회원의 개인정보 변경시 현재 그 회원이 사용중인 email 을 제외한 나머지 email 에서
	// email 중복검사 (tbl_member 테이블에서 email 이 존재하면 true를 리턴해주고, email 이 존재하지 않으면 false를 리턴한다)
	boolean emailDuplicateCheck_2(Map<String, String> paraMap) throws SQLException;

	// 회원의 개인정보 변경하기
	int updateMember(MemberVO member) throws SQLException;

	// 회원의 개인정보 변경하기 - 이메일 인증하기
	boolean isUserEmailExist(Map<String, String> paraMap) throws SQLException;


	
}
