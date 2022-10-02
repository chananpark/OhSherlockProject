package lsw.admin.model;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import common.model.ProductVO;

public interface InterProductDAO {

	// 상품관리를 눌렀을때 나오는 상품목록리스트 출력 메소드(임선우) 
	List<ProductVO> showProductList() throws SQLException;
	
	// 관리자가 상품등록하는 메소드(임선우)  
	int registerProduct(ProductVO product) throws SQLException;

	// 페이징 처리를 위한 검색 유무에 따른 상품 수에 대한 페이지 출력하기
	int getTotalPage(Map<String, String> paraMap) throws SQLException;
	
	// 상품조회에서 특정 조건의 상품 페이징처리해서 보여주기
	// 페이징 처리를 한 모든 상품 또는 검색한 상품 목록 보여주기
	List<ProductVO> selectPagingProduct(Map<String, String> paraMap) throws SQLException;
	

}
