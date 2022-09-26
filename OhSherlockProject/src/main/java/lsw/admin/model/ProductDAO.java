package lsw.admin.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

public class ProductDAO implements InterProductDAO {

	
	private DataSource ds;  // DataSource ds 는 아파치톰캣이 제공하는 DBCP(DB Connection Pool) 이다.  
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	// 생성자
	public ProductDAO() {
		
		try {
			Context initContext = new InitialContext();
		    Context envContext  = (Context)initContext.lookup("java:/comp/env");
		    ds = (DataSource)envContext.lookup("jdbc/myprjoracle");
		    
		} catch(NamingException e) {
			e.printStackTrace();
		}
	}
	
	// 사용한 자원을 반납하는 close() 메소드 생성하기 
	private void close() {
		try {
			if(rs != null)    {rs.close();    rs=null;}
			if(pstmt != null) {pstmt.close(); pstmt=null;}
			if(conn != null)  {conn.close();  conn=null;}
		} catch(SQLException e) {
			e.printStackTrace();
		}
	}


	
	// 상품관리를 눌렀을때 나오는 상품목록리스트 출력 메소드(임선우) 	
	@Override
	public List<ProductVO> showProductList() throws SQLException {
		List<ProductVO> productList = new ArrayList<>();
		
		try {
			conn = ds.getConnection();

			String sql = "select p_code, p_name, p_price, p_discount_rate, p_stock "
					   + " from tbl_product ";

			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				
				ProductVO pvo = new ProductVO();
				
				pvo.setP_code(rs.getString(1));
				pvo.setP_name(rs.getString(2));
				pvo.setP_price(rs.getInt(3));
				pvo.setP_discount_rate(rs.getString(4));
				pvo.setP_stock(rs.getInt(5));
				
				productList.add(pvo);
			}

		} finally {
			close();
		}		
		
		return productList;
	} // end of public List<ProductVO> showProductList() throws SQLException{} ---------------
	
	
	
	
	// 관리자가 상품등록하는 메소드(임선우)  
	@Override
	public int registerProduct(ProductVO product) {
		int result = 0;
		try {
			conn = ds.getConnection();
			
			String sql = " insert into tbl_product (p_code, p_category, p_name, p_price, p_discount_rate, p_stock, p_info, p_desc, p_thumbnail, p_image) "
					   + " values (? || seq_pcode.nextval , ?, ?, ?, ?, ?, ?, ?, ?, ?)";
			
			pstmt = conn.prepareStatement(sql);
			
			
			pstmt.setString(1, product.getP_code());
			pstmt.setString(2, product.getP_category());
			pstmt.setString(3, product.getP_name());
			pstmt.setInt(4, product.getP_price());
			pstmt.setString(5, product.getP_discount_rate());
			pstmt.setInt(6, product.getP_stock());
			pstmt.setString(7, product.getP_info());
			pstmt.setString(8, product.getP_desc());
			pstmt.setString(9, product.getP_thumbnail());
			pstmt.setString(10, product.getP_image());
		
			result = pstmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			close();
		}
		
		return result;
	}// end of public int registerProduct(ProductVO product) {}-------------


}
