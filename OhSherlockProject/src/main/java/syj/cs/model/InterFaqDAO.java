package syj.cs.model;

import java.sql.SQLException;
import java.util.Map;

public interface InterFaqDAO {

	// 자주묻는질문 공지사항 작성하기
	int registerFaq(Map<String, String> paraMap) throws SQLException;

}
