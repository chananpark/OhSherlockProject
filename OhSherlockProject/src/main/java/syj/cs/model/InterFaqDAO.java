package syj.cs.model;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import common.model.FaqVO;

public interface InterFaqDAO {

	// 자주묻는질문 공지사항 작성하기
	int registerFaq(Map<String, String> paraMap) throws SQLException;

	// 자주묻는질문 버튼아이디에 따른 리스트 select 해오기
	List<FaqVO> selectFaqList(Map<String, String> paraMap) throws SQLException;

}
