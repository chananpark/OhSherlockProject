package pca.cs.model;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import common.model.InquiryVO;


public interface InterInquiryDAO {

	// 1:1 문의 등록하기
	int makeInquiry(InquiryVO ivo) throws SQLException;

	// 1:1 문의 전체 페이지 알아오기
	int getTotalPage(Map<String, String> paraMap) throws SQLException;

	// 자신의 1:1 문의 내역 가져오기
	List<InquiryVO> showMyInquiryList(Map<String, String> paraMap) throws SQLException;

}
