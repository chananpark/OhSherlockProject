package lsw.admin.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import common.model.CategoryVO;
import common.model.ProductVO;
import common.model.SpecVO;

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

			String sql = " select pnum, pname, price, saleprice, pqty, to_char(pinputdate,'yyyy-mm-dd')  pinputdate "
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
				pvo.setPinputdate(rs.getString(6));
				
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
			
			String sql = " insert into tbl_product (pnum, fk_cnum, pname, price, saleprice, point, pqty , psummary, pcontent, pimage, prdmanual_systemfilename, prdmanual_orginfilename) "
					   + " values ( seq_product_pnum.nextval , ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
			
			
			pstmt = conn.prepareStatement(sql);
			
			// fk_snum, 베스트 여부 없음
			pstmt.setInt(1, product.getFk_cnum());
			pstmt.setString(2, product.getPname());
			pstmt.setInt(3, product.getPrice());
			pstmt.setInt(4, product.getSaleprice());
			pstmt.setInt(5, product.getPoint());
			pstmt.setInt(6, product.getPqty());
			pstmt.setString(7, product.getPsummary());
			pstmt.setString(8, product.getPcontent());
			pstmt.setString(9, product.getPimage());
			pstmt.setString(10, product.getPrdmanual_systemfilename());
			pstmt.setString(11, product.getPrdmanual_orginfilename());

		
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
				sql += " and pnum like '%' || ? || '%' "; 
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
				
				String sql = "select pnum, pname, price, saleprice, pqty, to_char(pinputdate,'yyyy-mm-dd') pinputdate "+
							"from\n"+
							"(\n"+
							"    select rownum AS RNO, pnum, pname, price, saleprice, pqty, pinputdate "+
							"    from\n"+
							"    (\n"+
							"        select pnum, pname, price, saleprice, pqty, pinputdate "+
							"        from tbl_product ";
						
					String searchWord = paraMap.get("searchWord");
					
					
					if( searchWord != null && !searchWord.trim().isEmpty() ) { // 서치워드에 공백을 지우고 동시에 비어있지 않는다면 // 검색어가 있다면
						// !searchWord.trim().isEmpty() 이거만 단독으로 주게되면 nullPonitException 이 떨어진다
						sql += " and pnum like '%' || ? || '%' ";  // 컬럼명과 변수명이 들어온다.
						// 위치홀더는 컬럼명이나 테이블명이 올 경우에는 에러발생. 검색어만 들어와야 한다. 테이블명 또는 컬럼명이 변수로 들어올 수 없다.
						// 테이블명 또는 컬럼명이 변수로 들어와야 할 경우에는 변수로 처리해주어야 한다.
					}		
							
					 sql +=	"        order by pinputdate desc\n"+
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
					pvo.setPnum(rs.getInt(1));
					pvo.setPname(rs.getString(2));
					pvo.setPrice(rs.getInt(3));
					pvo.setSaleprice(rs.getInt(4));
					pvo.setPqty(rs.getInt(5));
					pvo.setPinputdate(rs.getString(6));
					
					productList.add(pvo); // 리스트에 담아준다.
					
				} // end of while
				
			} finally {
				close();
			}
			
			return productList;
		} // end of public List<MemberVO> selectPagingMember(Map<String, String> paraMap) throws SQLException

		
		
		// 특정 상품 상세 페이지 불러오기 
		@Override
		public ProductVO product_list_detail(String pnum) throws SQLException {
			
			ProductVO product = null;
			
			try {
				conn = ds.getConnection();
						
				String sql = " select S.sname, cname, pnum, pname, fk_cnum, pimage, pqty, price, saleprice, fk_snum, pcontent, psummary, point\n "+
							"    ,pinputdate\n "+
							"    from\n "+
							" (\n "+
							" select C.cname, pnum, pname, fk_cnum, pimage, pqty, price, saleprice, fk_snum, pcontent, psummary, point\n "+
							"    , to_char(pinputdate, 'yyyy-mm-dd') as pinputdate\n "+
							" from tbl_category C left join tbl_product P  \n "+
							" on C.cnum = P.fk_cnum \n "+
							" )v left join tbl_spec S\n "+
							" on V.fk_snum = S.snum\n "+
							" where pnum = ?" ;

				
				pstmt = conn.prepareStatement(sql);
				
				pstmt.setString(1, pnum);
				
				rs = pstmt.executeQuery();
				
				if(rs.next()) {
					
					// select 해서 가져올 게 있냐
					product = new ProductVO();
					
					product.setPnum(rs.getInt(3));
					product.setPname(rs.getString(4));
					product.setFk_cnum(rs.getInt(5));
					product.setPimage(rs.getString(6));
					product.setPqty(rs.getInt(7));
					product.setPrice(rs.getInt(8));
					product.setSaleprice(rs.getInt(9));
					product.setFk_cnum(rs.getInt(10));
					product.setPcontent(rs.getString(11));
					product.setPsummary(rs.getString(12));
					product.setPoint(rs.getInt(13));
					product.setPinputdate(rs.getString(14));
					
					SpecVO spvo = new SpecVO();
					spvo.setSname(rs.getString(1));
					
					CategoryVO cvo = new CategoryVO();
					cvo.setCname(rs.getString(2));
					
				} // end of if(rs.next())
				
			} finally {
				close();
			}
		
			return product;
		}// end of public ProductVO product_list_detail(Map<String, String> paraMap) throws SQLException			

		
		// spec 목록을 보여주고자 한다.
		@Override
		public List<SpecVO> selectSpecList() throws SQLException {
			List<SpecVO> specList = new ArrayList<>();
			
			try {
				 conn = ds.getConnection();
				
				 String sql = " select snum, sname "
				 		    + " from tbl_spec "
				 		    + " order by snum asc "; 
				 
				 pstmt = conn.prepareStatement(sql);
				 
				 rs = pstmt.executeQuery();
				 
				 while(rs.next()) {
					 
					 SpecVO spvo = new SpecVO();
					 spvo.setSnum(rs.getInt(1));
					 spvo.setSname(rs.getString(2));
					 
					 specList.add(spvo);
					 
				 }// end of while-------------------
				
			} finally {
				close();
			}
			
			return specList;
		}// end of public List<SpecVO> selectSpecList() throws SQLException
		
		
		
		// 제품번호 채번 해오기
		@Override
		public int getPnumOfProduct() throws SQLException {
			
			int pnum = 0;
			
			try {
				 conn = ds.getConnection();
				 
				 String sql = " select seq_product_pnum.nextval AS PNUM " +
						      " from dual ";
						   
				 pstmt = conn.prepareStatement(sql);
				 rs = pstmt.executeQuery();
				 			 
				 rs.next();
				 pnum = rs.getInt(1);
			
			} finally {
				close();
			}
			
			return pnum;
		}// end of public int getPnumOfProduct() throws SQLException
		
		
		
		// tbl_product 테이블에 제품정보 insert 하기
	   @Override
	   public int productInsert(ProductVO pvo) throws SQLException {
	      
	      int result = 0;
	      
	      try {
	         conn = ds.getConnection();
	         
	         String sql = " insert into tbl_product(pnum, pname, fk_cnum, pimage, pqty, price, saleprice, fk_snum, pcontent, psummary, point) " +  
	                    " values(?,?,?,?,?,?,?,?,?,?,?)";
	         
	         pstmt = conn.prepareStatement(sql);
	         
	         pstmt.setInt(1, pvo.getPnum());
	         pstmt.setString(2, pvo.getPname());
	         pstmt.setInt(3, pvo.getFk_cnum());    
	         pstmt.setString(4, pvo.getPimage());    
	         pstmt.setInt(5, pvo.getPqty()); 
	         pstmt.setInt(6, pvo.getPrice());
	         pstmt.setInt(7, pvo.getSaleprice());
	         pstmt.setInt(8, pvo.getFk_snum());
	         pstmt.setString(9, pvo.getPcontent());
	         pstmt.setString(10, pvo.getPsummary());
	         pstmt.setInt(11, pvo.getPoint());
	            
	         result = pstmt.executeUpdate();
	         
	      } finally {
	         close();
	      }
	      
	      return result;      
	      
	   }// end of public void productInsert(ProductVO pvo) throws SQLException-------

	   
	   // tbl_product_imagefile 테이블에 제품의 추가이미지 파일명  insert 하기
		@Override
		public int product_imagefile_Insert(int pnum, String attachFileName) throws SQLException {
			int result = 0;
		      
		      try {
		         conn = ds.getConnection();
		         
		         String sql = " insert into tbl_product_imagefile(imgfileno, fk_pnum, imgfilename) "+ 
		                    " values(seqImgfileno.nextval, ?, ?) ";
		         
		         pstmt = conn.prepareStatement(sql);
		         
		         pstmt.setInt(1, pnum);
		         pstmt.setString(2, attachFileName);
		         
		         result = pstmt.executeUpdate();
		         
		      } finally {
		         close();
		      }
		      
		      return result;   
			
		} // end of public void product_imagefile_Insert(int pnum, String attachFileName) 
		
	   
		// 카테고리 조회 메소드
		@Override
		public List<HashMap<String, String>> getCategoryList() throws SQLException {
		    List<HashMap<String, String>> categoryList = new ArrayList<>();

		    try {
		        conn = ds.getConnection();

		        String sql = "select cnum, code, cname\r\n"
		                + "from tbl_category\r\n"
		                + "order by cnum asc";

		        pstmt = conn.prepareStatement(sql);

		        rs = pstmt.executeQuery();

		        while(rs.next()) {
		            HashMap<String, String> map = new HashMap<>();
		            map.put("cnum", rs.getString(1));
		            map.put("code", rs.getString(2));
		            map.put("cname", rs.getString(3));

		            categoryList.add(map);
		        }

		    } finally {
		        close();
		    }

		    return categoryList;
		}
}
