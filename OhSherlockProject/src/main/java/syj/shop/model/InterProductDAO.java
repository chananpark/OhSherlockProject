package syj.shop.model;

import java.sql.SQLException;
import java.util.List;

import common.model.ProductVO;

public interface InterProductDAO {

	// 상품 전체 리스트 불러오기
	List<ProductVO> selectProduct() throws SQLException;

}
