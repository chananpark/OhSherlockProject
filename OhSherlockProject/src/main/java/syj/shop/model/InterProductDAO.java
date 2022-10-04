package syj.shop.model;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import common.model.ProductVO;

public interface InterProductDAO {

	// 이벤트 상품에 대한 총 페이지 알아오기
	int getEventTotalPage(Map<String, String> paraMap) throws SQLException;
	
	// 이벤트 상품 리스트 불러오기
	List<ProductVO> selectEventGoodsByCategory(Map<String, String> paraMap) throws SQLException;
	
	
	

}
