package syj.member.model;

import java.sql.SQLException;
import java.util.Map;

public interface InterMemberDAO {

	// 비밀번호 찾기(아이디, 이메일을 입력받아서 해당 사용자의 비밀번호를 알려준다.)
	boolean isUserExist(Map<String, String> paraMap) throws SQLException;

	// 비밀번호 변경하기
	int passwdUpdate(Map<String, String> paraMap) throws SQLException;

	
	
} // end of InterMemberDAO
