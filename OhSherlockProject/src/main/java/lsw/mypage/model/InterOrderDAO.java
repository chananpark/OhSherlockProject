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


}
