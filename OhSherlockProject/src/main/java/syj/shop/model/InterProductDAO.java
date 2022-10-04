package syj.shop.model;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import common.model.ProductVO;

public interface InterProductDAO {


	// 페이지바 처리를 위한 이벤트 상품에 대한 총 페이지 알아오기
	int getTotalPage() throws SQLException;

	// 이벤트 상품에 따른 제품들을 페이지바를 사용한 페이징처리 처리하여 조회(select)해오기
	List<ProductVO> selectPagingProdByEvent(Map<String, String> paraMap) throws SQLException;

	// 단품 카테고리 리스트 불러오기
	List<HashMap<String, String>> getProdCategoryList() throws SQLException;

	// 단품-카테고리 페이지바 처리를 위한 이벤트 상품에 대한 총 페이지 알아오기
	int getTotalCategoryPage(Map<String, String> paraMap) throws SQLException;

	// 단품-카테고리 이벤트 상품에 따른 제품들을 페이지바를 사용한 페이징처리 처리하여 조회(select)해오기
	List<ProductVO> selectProdByEventCategory(Map<String, String> paraMap) throws SQLException;

	// 단품-베스트 페이지바 처리를 위한 이벤트 상품에 대한 총 페이지 알아오기
	int getTotalBestPage(Map<String, String> paraMap) throws SQLException;

	// 단품-베스트 이벤트 상품에 따른 제품들을 페이지바를 사용한 페이징처리 처리하여 조회(select)해오기
	List<ProductVO> selectProdByEventBest(Map<String, String> paraMap) throws SQLException;
	
	
	

}
