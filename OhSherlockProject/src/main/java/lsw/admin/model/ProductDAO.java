package lsw.admin.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import common.model.ProductVO;

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

			String sql = "select "
					   + " from tbl_product ";

			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				
				ProductVO pvo = new ProductVO();
				
				pvo.setPnum(rs.getInt(1));
				pvo.setPname(rs.getString(2));
				pvo.setPrice(rs.getInt(3));
				pvo.setSaleprice(rs.getInt(4));
				pvo.setPqty(rs.getInt(5));
				
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

	
	
	// 페이징 처리를 위한 검색 유무에 따른 상품 수에 대한 페이지 출력하기
	@Override
	public int getTotalPage(Map<String, String> paraMap) throws SQLException {

		int totalPage = 0;
		
		try {
			conn = ds.getConnection();
			
			String sql = " select ceil(count(*)/?) "
						+ " from tbl_product ";
			
			String searchWord = paraMap.get("searchWord");
			
			// 맵에는 서치월드와 서치타입이 있는데 서치타입은 default가 회원명이기 때문에 무조건 여기로 보내준다. 
			// 디비에서도 검색어가 있는지 없는지에 대해서 알기 위해서는 서치 워드의 유무를 본다.
			
			
			if( searchWord != null && !searchWord.trim().isEmpty() ) { // 서치워드에 공백을 지우고 동시에 비어있지 않는다면
				// !searchWord.trim().isEmpty() 이거만 단독으로 주게되면 nullPonitException 이 떨어진다
				sql += " and p_code like '%' || ? || '%' "; 
				// 위치홀더는 컬럼명이나 테이블명이 올 경우에는 에러발생. 검색어만 들어와야 한다. 테이블명 또는 컬럼명이 변수로 들어올 수 없다.
				// 테이블명 또는 컬럼명이 변수로 들어와야 할 경우에는 변수로 처리해주어야 한다.
			}
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, Integer.parseInt(paraMap.get("sizePerPage")));
			
			if( searchWord != null && !searchWord.trim().isEmpty() ) {
				// 검색이 있다면
				pstmt.setString(2, searchWord); // 두번째 위치홀더 자리엔 searchWord를 넣어주어야 한다.
			}
			
			rs = pstmt.executeQuery();
			rs.next();
			totalPage = rs.getInt(1);
			
		} finally {
			close();
		}
		
		return totalPage;
			
	} // end of public int getTotalPage(Map<String, String> paraMap) throws SQLException
	
	
		// 상품조회에서 특정 조건의 상품 페이징처리해서 보여주기
		// 페이징 처리를 한 모든 상품 또는 검색한 상품 목록 보여주기
		@Override
		public List<ProductVO> selectPagingProduct(Map<String, String> paraMap) throws SQLException {
			
			List<ProductVO> productList = new ArrayList<>();
			
			try {
				conn = ds.getConnection();
				
				String sql = "select p_code, p_name, p_price, p_discount_rate, p_stock "+
							"from\n"+
							"(\n"+
							"    select rownum AS RNO, p_code, p_name, p_price, p_discount_rate, p_stock "+
							"    from\n"+
							"    (\n"+
							"        select p_code, p_name, p_price, p_discount_rate, p_stock"+
							"        from tbl_product ";
						
					String searchWord = paraMap.get("searchWord");
					
					
					if( searchWord != null && !searchWord.trim().isEmpty() ) { // 서치워드에 공백을 지우고 동시에 비어있지 않는다면 // 검색어가 있다면
						// !searchWord.trim().isEmpty() 이거만 단독으로 주게되면 nullPonitException 이 떨어진다
						sql += " and p_code like '%' || ? || '%' ";  // 컬럼명과 변수명이 들어온다.
						// 위치홀더는 컬럼명이나 테이블명이 올 경우에는 에러발생. 검색어만 들어와야 한다. 테이블명 또는 컬럼명이 변수로 들어올 수 없다.
						// 테이블명 또는 컬럼명이 변수로 들어와야 할 경우에는 변수로 처리해주어야 한다.
					}		
							
					 sql +=	"        order by p_registerday desc\n"+
							"    )V\n"+
							") T --RNO를 where 절에 사용할 수 없어서 다시 인라인뷰를 사용하여 T 라는 테이블로 간주한다.\n"+
							"where RNO between ? and ? ";
					
//				=== 페이징처리의 공식 ===
//				where RNO between (조회하고자 하는 페이지 번호 * 한페이지당 보여줄 행의 개수) - (한페이지당 보여줄 행의 개수 -1) 
//				              and (조회하고자 하는 페이지 번호 * 한페이지당 보여줄 행의 개수);

				int currentShowPageNo = Integer.parseInt(paraMap.get("currentShowPageNo"));  // 조회하고자 하는 페이지 번호
				int sizePerPage = Integer.parseInt(paraMap.get("sizePerPage")); // 한페이지당 보여줄 행의 개수
				
				pstmt = conn.prepareStatement(sql);
			
				/// 검색어가 있는 경우에 위치홀더 값
				if( searchWord != null && !searchWord.trim().isEmpty() ) {
					pstmt.setString(1, searchWord);
					pstmt.setInt(2, (currentShowPageNo*sizePerPage) - (sizePerPage-1) );
					pstmt.setInt(3, (currentShowPageNo*sizePerPage) );
				} else {
					// 페이징 처리 공식
					// 검색어가 없는 경우의 위치홀더 값
					pstmt.setInt(1, (currentShowPageNo*sizePerPage) - (sizePerPage-1) );
					pstmt.setInt(2, (currentShowPageNo*sizePerPage) );
				}
				
				rs = pstmt.executeQuery();
				
				while(rs.next()) {
					
					ProductVO pvo = new ProductVO();
					pvo.setP_code(rs.getString(1)); 
					pvo.setP_name(rs.getString(2));
					pvo.setP_price(rs.getInt(3));
					pvo.setP_discount_rate(rs.getString(4)); 
					pvo.setP_stock(rs.getInt(4)); 
					
					productList.add(pvo); // 리스트에 담아준다.
					
				} // end of while
				
			} finally {
				close();
			}
			
			return productList;
		} // end of public List<MemberVO> selectPagingMember(Map<String, String> paraMap) throws SQLException

			
}
