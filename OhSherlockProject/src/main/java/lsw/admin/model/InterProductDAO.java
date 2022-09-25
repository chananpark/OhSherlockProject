package lsw.admin.model;

import java.sql.SQLException;
import java.util.List;

public interface InterProductDAO {

	// 상품관리를 눌렀을때 나오는 상품목록리스트 출력 메소드(임선우) 
	List<ProductVO> showProductList() throws SQLException;
	
	// 관리자가 상품등록하는 메소드(임선우)  
	int registerProduct(ProductVO product) throws SQLException;
	

}
