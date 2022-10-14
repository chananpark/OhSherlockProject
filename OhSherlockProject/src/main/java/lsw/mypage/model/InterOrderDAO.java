package lsw.mypage.model;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import common.model.OrderVO;

public interface InterOrderDAO {
	
	// 특정 회원 주문목록 총 페이지 가지고 오기
	int getTotalMyOrderPage(Map<String, String> paraMap)throws SQLException;

	// 특정 회원 주문목록 가지고 오기 
	List<OrderVO> selectMyOrder(Map<String, String> paraMap)throws SQLException;

	// 주문 상세정보 출력하는 메소드 
	List<OrderVO> selectMyOrderDetail(Map<String, String> paraMap)throws SQLException;

	// 주문상세정보에서 상품리스트 출력하는 메소드
	List<OrderVO> selectOneOrder(Map<String, String> paraMap)throws SQLException;

	// 주문상세정보에서 배송지 출력하는 메소드
	OrderVO getOrderDetail(String odrcode)throws SQLException;

	// 주문을 반품하는 메소드
	int refundUpdate(Map<String, String> paraMap)throws SQLException;

	// 주문을 취소하는 메소드
	int cancelUpdate(Map<String, String> paraMap)throws SQLException;



}
