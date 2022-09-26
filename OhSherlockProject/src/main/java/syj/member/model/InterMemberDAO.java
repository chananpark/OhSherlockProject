package syj.member.model;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import common.model.MemberVO;

public interface InterMemberDAO {

	// 비밀번호 찾기(아이디, 이메일을 입력받아서 해당 사용자의 비밀번호를 알려준다.)
	boolean isUserExist(Map<String, String> paraMap) throws SQLException;

	// 비밀번호 변경하기
	int passwdUpdate(Map<String, String> paraMap) throws SQLException;

	// 회원조회에서 특정 조건의 회원 페이징처리해서 보여주기
	// 페이징 처리를 한 모든 회원 또는 검색한 회원 목록 보여주기
	List<MemberVO> selectPagingMember(Map<String, String> paraMap) throws SQLException;

	// 페이징 처리를 위한 검색 유무에 따른 회원 수에 대한 페이지 출력하기
	int getTotalPage(Map<String, String> paraMap) throws SQLException;

	// 관리자 회원 목록에서 회원 상세조회
	MemberVO member_list_detail(Map<String, String> paraMap) throws SQLException;
		
	
} // end of InterMemberDAO
