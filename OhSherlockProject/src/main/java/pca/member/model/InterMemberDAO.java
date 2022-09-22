package pca.member.model;

import java.sql.SQLException;
import java.util.Map;

public interface InterMemberDAO {

	MemberVO selectOneMember(Map<String, String> paraMap) throws SQLException;
 
	int activateMember(String userid, String clientip) throws SQLException;

}
