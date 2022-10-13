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

	// 기존의 faq 내용을 faqEdit_admin.jsp 단에 뿌려주기
	FaqVO faqEditSelect(String faq_num) throws SQLException;

	// 수정된 FAQ DB에 업데이트 해주는 메소드
	int faqEditUpdate(Map<String, String> paraMap) throws SQLException;

	// 자주묻는질문 삭제하기
	int faqDelete(String faq_num) throws SQLException;

}
