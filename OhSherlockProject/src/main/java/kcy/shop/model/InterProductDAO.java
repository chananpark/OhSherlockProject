package kcy.shop.model;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import common.model.ProductVO;
import common.model.ReviewVO;

public interface InterProductDAO {

	// 제품번호를 가지고서 해당 제품의 정보를 조회해오기
	ProductVO selectOneProductByPnum(String pnum) throws SQLException;

	// 제품번호를 가지고서 해당 제품의 추가된 이미지 정보를 조회해오기
	List<String> getImagesByPnum(String pnum) throws SQLException;

	// 리뷰 내용 조회
	ReviewVO showReviewDetail(Map<String, String> paraMap) throws SQLException;

	// 전체 페이지 수 알아오기
	int getTotalPage(Map<String, String> paraMap) throws SQLException;

	// 리뷰 목록
	List<ReviewVO> showReviewList(Map<String, String> paraMap) throws SQLException;

	// 버튼아이디에 따른 리스트 select 해오기
	List<ReviewVO> selectreviewList(Map<String, String> paraMap) throws SQLException;

	

}
