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

	
	
	// 제품번호 채번 해오기
	//int getPnumOfProduct() throws SQLException;

	// tbl_product 테이블에 제품정보 insert 하기
	//int productInsert(ProductVO pvo) throws SQLException;
	
	// 제품번호를 가지고서 해당 제품의 정보를 조회해오기
	//ProductVO selectOneProductByPnum(String pnum) throws SQLException;

	
	
	// 찜목록 담기 
    // 찜목록 테이블(tbl_Like)에 해당 제품을 담아야 한다.
    // 찜목록 테이블에 해당 제품이 존재하지 않는 경우에는 tbl_Like 테이블에 insert 를 해야하고, 
    // 찜목록 테이블에 해당 제품이 존재하는 경우에 또 찜목록을 누르는 경우 tbl_Like 테이블에 delete 를 해야한다. 
	int addLike(String userid, String pnum) throws SQLException;

	// 로그인한 사용자의 찜목록을 조회하기
	List<LikeVO> selectProductLike(String userid) throws SQLException;
	
	// 찜목록 테이블에서 특정제품 1개행을 찜목록에서 비우기
	int delLike(String likeno) throws SQLException;
	
	// 찜목록 테이블에서 특정제품 선택행들을 찜목록에서 비우기
	int delSelectLike(String[] likenoArr) throws SQLException;


		
	
}
