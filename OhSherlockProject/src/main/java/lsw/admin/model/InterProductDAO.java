package lsw.admin.model;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import common.model.ProductVO;
import common.model.SpecVO;

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

	// 특정 상품 상세 페이지 불러오기 
	ProductVO product_list_detail(String pnum) throws SQLException;
	
	// spec 목록을 보여주고자 한다.
	List<SpecVO> selectSpecList() throws SQLException;
	
	// 제품번호 채번 해오기
	int getPnumOfProduct() throws SQLException;

	// tbl_product 테이블에 제품정보 insert 하기
	int productInsert(ProductVO pvo) throws SQLException;

	// tbl_product_imagefile 테이블에 제품의 추가이미지 파일명
	int product_imagefile_Insert(int pnum, String attachFileName)throws SQLException;
	
	// 카테고리 조회 메소드
	List<HashMap<String, String>> getCategoryList() throws SQLException;

	// 관리자가 제품정보을 수정하는 메소드
	int productUpdate(ProductVO pvo)throws SQLException;

	// 관리자가 제품삭제하는 메소드
	int prod_mgmt_delete(String pnum)throws SQLException;
	
	// 제품번호를 가지고서 해당 제품의 추가된 이미지 정보를 조회해오기
	List<HashMap<String, String>> getImagesByPnum(String pnum)throws SQLException;
	
	// 추가이미지테이블에서 특정 이미지 삭제
	int prod_imgfile_delete(String imgfileno)throws SQLException;

	

}
