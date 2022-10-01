package pca.cs.model;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import common.model.InquiryVO;


public interface InterInquiryDAO {

	// 1:1 문의 등록하기
	int makeInquiry(InquiryVO ivo) throws SQLException;

	// 특정 기간의 1:1 문의 개수
	int countInquiry(Map<String, String> paraMap) throws SQLException;

	// 자신의 1:1 문의 내역 가져오기
	List<InquiryVO> showMyInquiryList(Map<String, String> paraMap) throws SQLException;

	// 자신의 1:1 문의 글 내용 가져오기
	InquiryVO showMyInquiryDetail(String inquiry_no) throws SQLException;

	// 관리자 1:1 문의 전체 글 수 가져오기
	int getTotalInquiries(String inquiry_answered) throws SQLException;

	// 관리자 1:1 문의 글내역 가져오기
	List<InquiryVO> showInquiryList(Map<String, String> paraMap) throws SQLException;

	// 관리자 선택한 1:1 문의 글 내용 가져오기
	InquiryVO showInquiryDetail(String inquiry_no) throws SQLException;

	// 1:1 문의글 답변달기
	int writeReply(Map<String, String> paraMap);
}
