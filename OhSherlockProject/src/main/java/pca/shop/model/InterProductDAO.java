package pca.shop.model;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import common.model.ProductVO;

public interface InterProductDAO {

	// 카테고리 조회 메소드
	List<HashMap<String, String>> getCategoryList() throws SQLException;
	
	// 페이징 방식 카테고리별 기프트세트 상품 총 페이지수 가져오기 메소드
	int getTotalPage(String cnum) throws SQLException;
	
	// 페이징 방식 카테고리별 기프트세트 상품 목록 가져오기 메소드
	public List<ProductVO> selectSetGoodsByCategory(Map<String, String> paraMap) throws SQLException;

}
