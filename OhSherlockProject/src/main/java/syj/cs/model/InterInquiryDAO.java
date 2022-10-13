package syj.cs.model;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import common.model.InquiryVO;


public interface InterInquiryDAO {

	// 1대1문의 질문 리스트 3개
	List<InquiryVO> mypageInquiryList(String userid) throws SQLException;

	
}
