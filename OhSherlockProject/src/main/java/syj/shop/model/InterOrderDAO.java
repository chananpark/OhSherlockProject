package syj.shop.model;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import common.model.OrderDetailVO;
import common.model.OrderVO;

public interface InterOrderDAO {

	// 주문 내역 조회하기
	List<OrderVO> mypageOrderList(String userid)  throws SQLException;

	

}
