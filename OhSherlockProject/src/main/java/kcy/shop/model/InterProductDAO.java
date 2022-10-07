package kcy.shop.model;

import java.sql.SQLException;
import java.util.List;

import common.model.ProductVO;

public interface InterProductDAO {

	// 제품번호를 가지고서 해당 제품의 정보를 조회해오기
	ProductVO selectOneProductByPnum(String pnum) throws SQLException;

	// 제품번호를 가지고서 해당 제품의 추가된 이미지 정보를 조회해오기
	List<String> getImagesByPnum(String pnum) throws SQLException;

	

}
