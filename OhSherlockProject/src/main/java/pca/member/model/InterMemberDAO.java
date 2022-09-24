package pca.member.model;

import java.sql.SQLException;
import java.util.Map;

import common.model.MemberVO;

public interface InterMemberDAO {

	// 로그인 처리
	MemberVO selectOneMember(Map<String, String> paraMap) throws SQLException;
 
	// 휴면계정 해제
	int activateMember(String userid, String clientip) throws SQLException;

}
