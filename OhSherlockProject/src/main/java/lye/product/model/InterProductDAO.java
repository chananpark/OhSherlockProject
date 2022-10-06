package lye.product.model;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import common.model.ProductVO;

public interface InterProductDAO {

	// Ajax(JSON)를 이용한 더보기 방식(페이징처리)으로 상품정보를 8개씩 잘라서(start ~ end) 조회해오기
	List<ProductVO> selectBySpecName(Map<String, String> paraMap) throws SQLException;

	// 페이지바를 만들기 위해서 전체 상품개수에 대한 총페이지수 알아오기
	int getTotalPage() throws SQLException;
	
	// 페이지바를 만들기 위해서 특정 카테고리의 상품개수에 대한 총페이지수 알아오기
	int getTotalPageByCategory(String cnum) throws SQLException;

	// 전체 및 특정상품들을 페이지바를 사용한 페이징 처리하여 조회(select) 해오기
	List<ProductVO> selectPagingProduct(Map<String, String> paraMap) throws SQLException;

	


		
	
}
