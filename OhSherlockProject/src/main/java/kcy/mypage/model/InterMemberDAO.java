package kcy.mypage.model;

import java.sql.SQLException;
import java.util.Map;

public interface InterMemberDAO {

	// 아이디 찾기(성명, 이메일을 입력받아서 해당 사용자의 아이디를 알려준다)
	String idFind(Map<String, String> paraMap) throws SQLException;


	
}
