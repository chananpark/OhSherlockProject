package pca.shop.model;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import common.model.OrderDetailVO;
import common.model.OrderVO;

public interface InterOrderDAO {

	// 주문목록 총 페이지수
	int getTotalPage(Map<String, String> paraMap) throws SQLException;

	// 주문목록 가져오기
	List<OrderVO> showOrderList(Map<String, String> paraMap) throws SQLException;

	// 주문 상세정보 가져오기
	OrderVO getOrderDetail(String odrcode) throws SQLException;

	// 주문 상품 정보 가져오기
	List<OrderDetailVO> getOrderPrdDetail(String odrcode) throws SQLException;

}
