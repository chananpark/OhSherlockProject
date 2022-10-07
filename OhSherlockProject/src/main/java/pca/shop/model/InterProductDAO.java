package pca.shop.model;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import common.model.ProductVO;

public interface InterProductDAO {

	// 기프트세트 카테고리 조회 메소드
	List<HashMap<String, String>> getCategoryList() throws SQLException;
	
	// 티단품 카테고리 조회 메소드
	List<HashMap<String, String>> getTeaCategoryList() throws SQLException;
	
	// 페이징 방식 카테고리별 기프트세트 상품 총 페이지수 가져오기 메소드
	int getTotalPage(Map<String, String> paraMap) throws SQLException;
	
	// 페이징 방식 카테고리별 기프트세트 상품 목록 가져오기 메소드
	public List<ProductVO> selectSetGoodsByCategory(Map<String, String> paraMap) throws SQLException;

	// 검색 결과 총 페이지 수 가져오기
	int getSearchedTotalPage(Map<String, String> paraMap) throws SQLException;
	
	// 검색 상품 개수
	int countSearchedGoods(Map<String, String> paraMap) throws SQLException;
	
	// 검색어로 상품 목록 가져오기
	List<ProductVO> selectSearchedGoods(Map<String, String> paraMap) throws SQLException;

	// 메인에 표시할 상품 4개
	List<ProductVO> selectTodayProducts();

}
