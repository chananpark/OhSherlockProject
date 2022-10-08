package syj.shop.model;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import common.model.CartVO;
import common.model.ProductVO;

public interface InterProductDAO {

	// 이벤트 상품에 대한 총 페이지 알아오기
	int getEventTotalPage(Map<String, String> paraMap) throws SQLException;
	
	// 이벤트 상품 리스트 불러오기
	List<ProductVO> selectEventGoodsByCategory(Map<String, String> paraMap) throws SQLException;

	// 장바구니에 추가하기
	int addCart(String userid, String pnum, String oqty)  throws SQLException;

	// 로그인한 사용자의 장바구니 목록을 조회하기 
	List<CartVO> selectProductCart(String userid) throws SQLException;

	// 로그인한 사용자의 장바구니에 담긴 주문 총액 합계 및 총 포인트 합계
	HashMap<String, String> selectCartSumPricePoint(String userid) throws SQLException;

	
	
	

}
