package syj.shop.model;

import java.io.UnsupportedEncodingException;
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

import common.model.CartVO;
import common.model.CategoryVO;
import common.model.ProductVO;
import common.model.SpecVO;
import util.security.AES256;
import util.security.SecretMyKey;

public class ProductDAO implements InterProductDAO {

	private DataSource ds;	// tomcat에서 제공하는 DBCP(DB connection pool) 이다.
	// import javax.sql.DataSource; 로 import 
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	private AES256 aes;
	
	// 생성자
	public ProductDAO() {	
		try {
			Context initContext = new InitialContext();
		    Context envContext  = (Context)initContext.lookup("java:/comp/env");
		    ds = (DataSource)envContext.lookup("jdbc/myprjoracle");

		    aes = new AES256(SecretMyKey.KEY);
		    // SecretMyKey.KEY: 우리가 만든 비밀키

		} catch(NamingException e) {
			e.printStackTrace();
		} catch(UnsupportedEncodingException e) {
			e.printStackTrace();
		}
	}
	
	// 사용한 자원을 반납하는 close() 메소드 생성하기
	private void close() {
		try {
			if( rs != null ) { rs.close(); rs=null; }
			if( pstmt != null ) { pstmt.close(); pstmt=null; }
			if( conn != null ) { conn.close(); conn=null; }
		} catch(SQLException e) {
			e.printStackTrace();
		}
	}

	
	
	///////////////////////////////////////////////////////////////////////////////////////////
	// 이벤트 상품에 대한 총 페이지 알아오기
	@Override
	public int getEventTotalPage(Map<String, String> paraMap) throws SQLException {

		int totalPage = 0; // 기본값이 null 이 나올 수가 없다. 변수에 null 을 넣어주지 않았기 때문에.
		
		try {

			conn = ds.getConnection();
			
			String sql = " select ceil(count(*)/6) "+ // 10이 sizeperpage 이다. ceil로 올림해주기
						 " from tbl_product "+
						 " where saleprice != price ";
			
			String snum = paraMap.get("snum");
	        String cnum = paraMap.get("cnum");
	        
	        if( "".equals(snum) && "".equals(cnum) ) {
	        	// 전체 상품
	        	sql += " ";
	        } else if( "".equals(cnum) && !("".equals(snum)) ) {
	        	// 스펙만 넘어올 때
	        	sql += " and fk_snum = ? ";
	        } else if( !("".equals(cnum)) && "".equals(snum) ) {
	        	// 카테고리만 넘어올 때
	        	sql += " and fk_cnum = ? ";
	        } 
	        
			pstmt = conn.prepareStatement(sql);
			
			if( "".equals(snum) && "".equals(cnum) ) {
	        	// 전체 상품

			} else if( "".equals(cnum) && !("".equals(snum)) ) {
	        	// 스펙만 넘어올 때
				pstmt.setString(1, snum);
	        } else if( !("".equals(cnum)) && "".equals(snum) ) {
	        	// 카테고리만 넘어올 때
	        	pstmt.setString(1, cnum);
	        } 
			
			rs = pstmt.executeQuery();
			rs.next();
			
			totalPage = rs.getInt(1);
			
		} finally {
			close();
		}
		
		return totalPage;
	
	} // end of public int getTotalPage(Map<String, String> paraMap) throws SQLException

	
	// 페이징 방식 이벤트 상품 목록 가져오기 메소드
	@Override
	public List<ProductVO> selectEventGoodsByCategory(Map<String, String> paraMap) throws SQLException {
		List<ProductVO> productList = new ArrayList<>();

	    try {
	        conn = ds.getConnection();

	        String sql = "SELECT cname, sname, pnum, pname, pimage, PRDMANUAL_SYSTEMFILENAME, PRDMANUAL_ORGINFILENAME,\n"+
	        		"    pqty, price, saleprice, pcontent, PSUMMARY, point, pinputdate,\n"+
	        		"    reviewCnt , -- 리뷰수\n"+
	        		"    orederCnt -- 판매수\n"+
	        		"FROM\n"+
	        		"    (SELECT ROWNUM AS rno, cname, sname, pnum, pname, pimage, PRDMANUAL_SYSTEMFILENAME, PRDMANUAL_ORGINFILENAME,\n"+
	        		"            pqty, price, saleprice, pcontent, PSUMMARY, point, pinputdate, reviewCnt, orederCnt\n"+
	        		"    FROM\n"+
	        		"        (SELECT c.cname, s.sname, pnum, pname, pimage, PRDMANUAL_SYSTEMFILENAME, PRDMANUAL_ORGINFILENAME,\n"+
	        		"                pqty, price, saleprice, pcontent, PSUMMARY, point, pinputdate,\n"+
	        		"                (select distinct count(FK_ODRCODE) from tbl_order_detail where FK_PNUM=pnum) as orederCnt,\n"+
	        		"                (select count(RNUM) from tbl_review where FK_PNUM=pnum) as reviewCnt\n"+
	        		"        FROM\n"+
	        		"            (SELECT\n"+
	        		"                pnum, pname, pimage, PRDMANUAL_SYSTEMFILENAME, PRDMANUAL_ORGINFILENAME,\n"+
	        		"                pqty, price, saleprice, pcontent, PSUMMARY, point,\n"+
	        		"                to_char(pinputdate, 'yyyy-mm-dd') AS pinputdate, fk_cnum, fk_snum\n"+
	        		"            FROM tbl_product\n"+
	        		"            WHERE saleprice != price \n";
	        		            

	        String snum = paraMap.get("snum");
	        String cnum = paraMap.get("cnum");
	        String order = paraMap.get("order");

	        if( "".equals(snum) && "".equals(cnum) ) {
	        	// 전체 상품
	        	sql += " ";
	        } else if( "".equals(cnum) && !("".equals(snum)) ) {
	        	// 스펙(new, best) 가 넘어올 경우
	        	sql += " and fk_snum = ? ";
	        } else if( !("".equals(cnum)) && "".equals(snum) ) {
	        	// 컬럼이 넘어올 경우
	        	sql += " and fk_cnum = ? ";
	        } 
	        
	        sql += " )p\n"+
		    		"            JOIN tbl_category  c ON p.fk_cnum = c.cnum\n"+
		    		"            LEFT OUTER JOIN tbl_spec s\n"+
		    		"            ON p.fk_snum = s.snum" +
		    		"			 ORDER BY " + order +")V\n"+
		    		"    ) t\n"+
		    		" WHERE t.rno BETWEEN ? AND ? ";
		    		
	        
	        /*
	         === 페이징처리 공식 === 
	         where RNO between (조회하고자 하는 페이지 번호 * 한페이지당 보여줄 행의 개수) -
	         (한페이지당 보여줄 행의 개수 - 1) and (조회하고자 하는 페이지 번호 * 한페이지당 보여줄 행의 개수)
	         */
	        
	        int currentShowPageNo = Integer.parseInt(paraMap.get("currentShowPageNo"));
	        int sizePerPage = 6;

	        pstmt = conn.prepareStatement(sql);
	        
	        if( "".equals(snum) && "".equals(cnum) ) {
	        	// 전체 상품
	        	pstmt.setInt(1, (currentShowPageNo * sizePerPage) - (sizePerPage - 1));
		        pstmt.setInt(2, (currentShowPageNo * sizePerPage));
	        } else if( "".equals(cnum) && !("".equals(snum)) ) {
	        	// 스펙(new, best) 가 넘어올 경우
	        	pstmt.setString(1, snum);
		        pstmt.setInt(2, (currentShowPageNo * sizePerPage) - (sizePerPage - 1));
		        pstmt.setInt(3, (currentShowPageNo * sizePerPage));
	        } else if( !("".equals(cnum)) && "".equals(snum) ) {
	        	// 컬럼이 넘어올 경우
	        	pstmt.setString(1, cnum);
		        pstmt.setInt(2, (currentShowPageNo * sizePerPage) - (sizePerPage - 1));
		        pstmt.setInt(3, (currentShowPageNo * sizePerPage));
	        } 
	        
	        rs = pstmt.executeQuery();

	        while (rs.next()) {
	        	ProductVO pvo = new ProductVO();
				
				CategoryVO categvo = new CategoryVO();
				categvo.setCname(rs.getString("cname")); // 카테고리명
				pvo.setCategvo(categvo);
				
				SpecVO spvo = new SpecVO();
	            spvo.setSname(rs.getString("sname")); // 스펙명
	            pvo.setSpvo(spvo);
				
	            pvo.setPnum(rs.getInt("pnum")); // 상품번호
				pvo.setPname(rs.getString("pname")); // 제품명
				pvo.setPimage(rs.getString("pimage"));   // 제품이미지
				pvo.setPrdmanual_systemfilename(rs.getString("prdmanual_systemfilename"));
				pvo.setPrdmanual_orginfilename(rs.getString("prdmanual_orginfilename"));
				pvo.setPqty(rs.getInt("pqty")); // 제품 재고량
				pvo.setPrice(rs.getInt("price"));        // 제품 정가
				pvo.setSaleprice(rs.getInt("saleprice"));    // 제품 판매가
				pvo.setPcontent(rs.getString("pcontent")); // 제품설명
				pvo.setPsummary(rs.getString("psummary")); // 제품요약
				pvo.setPoint(rs.getInt("point")); // 포인트 점수
				pvo.setPinputdate(rs.getString("pinputdate")); // 제품 입고 일자
				pvo.setReviewCnt(rs.getInt("reviewCnt"));
				pvo.setOrederCnt(rs.getInt("orederCnt"));
				
	            productList.add(pvo);
	        }

	    } finally {
	        close();
	    }

	    return productList;
	} // end of public List<ProductVO> selectEventGoodsByCategory(Map<String, String> paraMap) throws SQLException

	
	// 장바구니에 추가하기
	@Override
	public int addCart(String userid, String pnum, String oqty) throws SQLException {
		int result = 0;
	      
	      try {
	         conn = ds.getConnection();
	         
	         String sql = " select cartno "
	         			+ " from tbl_cart "
	         			+ " where fk_userid = ? and fk_pnum = ? ";
	         
	         // 장바구니 번호가 userid 에 존재한다면 장바구니 번호만 알아와서 update 해주고, 없다면 insert 해준다. 
	         pstmt = conn.prepareStatement(sql);
	         pstmt.setString(1, userid);
	         pstmt.setString(2, pnum);
	         rs = pstmt.executeQuery();
	         
	         if(rs.next()) {
	        	 // 장바구니에 존재하는 상품을 추가로 장바구니에 넣고자 하는 경우
	        	 
	        	 int cartno = rs.getInt("cartno"); // 위에서 셀렉트되어진 게 있다면 rs 에서 cartno 를 알아온다.
	        	 
	        	 sql = " update tbl_cart set oqty = oqty + ? "
	        	 	 + " where cartno = ?";
	        	 
	        	 pstmt = conn.prepareStatement(sql);
	        	 pstmt.setInt(1, Integer.parseInt(oqty)); // 문자면 문자열 결합이 되기 때문에 숫자로 바꾸어 주어야 한다. 
	        	 pstmt.setInt(2, cartno);
	        	 
	        	 result = pstmt.executeUpdate(); // 정상이라면 1

	         } else {
	        	 // 장바구니에 존재하지 않는 새로운 제품을 장바구니에 넣고자 하는 경우
	        	 sql = " insert into tbl_cart(cartno, fk_userid, fk_pnum, oqty, registerday) "
	        			 + " values(seq_tbl_cart_cartno.nextval, ?, ?, ?, default) ";
	        	 
	        	 pstmt = conn.prepareStatement(sql);
	        	 pstmt.setString(1, userid); // 문자면 문자열 결합이 되기 때문에 숫자로 바꾸어 주어야 한다. 
	        	 pstmt.setInt(2, Integer.parseInt(pnum));
	        	 pstmt.setInt(3, Integer.parseInt(oqty));
	        	 
	        	 result = pstmt.executeUpdate(); // 정상이라면 1

	         }
	         
	      } finally {
	         close();
	      }
	      
	      return result;   
	} // end of  public int addCart(String userid, String pnum, String oqty) throws SQLException

	
	// 로그인한 사용자의 장바구니 목록을 조회하기 
	@Override
	public List<CartVO> selectProductCart(String userid) throws SQLException {
		List<CartVO> cartList = new ArrayList<>();
		
		try {
			conn = ds.getConnection();
			
			String sql = "select A.cartno, A.fk_userid, A.fk_pnum, \n"+
						"       B.pname, B.pimage, B.price, B.saleprice, B.point, A.oqty, B.pqty \n"+
						"from tbl_cart A join tbl_product B\n"+
						"on A.fk_pnum = B.pnum\n"+
						"where A.fk_userid = ? \n"+
						"order by A.cartno desc\n";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userid);
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				
				int cartno = rs.getInt("cartno"); // 컬럼명에는 A.cartno 이런 식으로 쓰면 안된다!!!
				String fk_userid = rs.getString("fk_userid");
				int fk_pnum = rs.getInt("fk_pnum");
				String pname = rs.getString("pname");
				String pimage = rs.getString("pimage");
				int price = rs.getInt("price");
				int saleprice = rs.getInt("saleprice");
				int point = rs.getInt("point");
				int oqty = rs.getInt("oqty");  // 주문량
				int pqty = rs.getInt("pqty"); // 재고량
				
				ProductVO prodvo = new ProductVO();
				prodvo.setPnum(fk_pnum);
				prodvo.setPname(pname);
				prodvo.setPimage(pimage);
				prodvo.setPrice(price);
				prodvo.setSaleprice(saleprice);
				prodvo.setPoint(point);
				prodvo.setPqty(pqty);
				
				prodvo.setTotalPriceTotalPoint(oqty); // 총 결제금액, 포인트
				
				CartVO cvo = new CartVO();
				cvo.setCartno(cartno);
				cvo.setUserid(fk_userid);
				cvo.setPnum(fk_pnum);
				cvo.setOqty(oqty);
				cvo.setProd(prodvo);
				
				cartList.add(cvo); // 이거는 이미 insert 되어진 목록을 장바구니 보기로 리스트를 select 해오는 것이다.
	            
			}// end of while--------------------------------------
			
		} finally {
			close();
		}
		
		return cartList;  // 이때 리스트가 비어있더라도 null 이 아니라 size 가 0 이다.
	} // end of public List<CartVO> selectProductCart(String userid) throws SQLException

	
	// 로그인한 사용자의 장바구니에 담긴 주문 총액 합계 및 총 포인트 합계
	@Override
	public HashMap<String, String> selectCartSumPricePoint(String userid) throws SQLException {

		HashMap<String, String> sumMap = new HashMap<String, String>();
		
		try {
			conn = ds.getConnection();
			String sql = "select nvl(sum(B.saleprice*A.oqty),0) as sumtotalprice, \n"+
						"       nvl(sum(B.point*A.oqty),0) as sumtotalpoint,\n"+
						"       nvl(sum(B.price*A.oqty),0) as sumtotaloriginprice\n"+
						"from tbl_cart A join tbl_product B\n"+
						"on A.fk_pnum = B.pnum\n"+
						"where A.fk_userid = ? \n"+
						"order by A.cartno desc\n";

			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userid);

			rs = pstmt.executeQuery();
			
			rs.next();// 없더라도 0 이 나오도록 찍어줘야 한다.
				
			sumMap.put("SUMTOTALPRICE", rs.getString("SUMTOTALPRICE"));
			sumMap.put("SUMTOTALPOINT", rs.getString("SUMTOTALPOINT"));
			sumMap.put("SUMTOTALORIGINPRICE", rs.getString("SUMTOTALORIGINPRICE"));
			
		} finally {
			close();
		}
	
		return sumMap;
	
	} // end of public HashMap<String, String> selectCartSumPricePoint(String userid) throws SQLException 

	
	////////////////////////////////////////////////////////////////////////////////////////////////////////
	// 찜목록 테이블에서 장바구니 담기 성공시 특정제품 1개행을 찜목록에서 비우기(예은)
	@Override
	public int delLike(String likeno) throws SQLException {
		
		int n = 0;
		
		try {
			 conn = ds.getConnection();  // 커넥션풀 방식
			 
			 String sql = " delete from tbl_like " +
					      " where likeno = ? ";
					   
			 pstmt = conn.prepareStatement(sql);
			 pstmt.setString(1, likeno);
			 			 
			 n = pstmt.executeUpdate();
			 
		} finally {
			close();
		}
		
		return n;
	}// end of public int delLike(String likeno) throws SQLException {}-------------------	

	
	// 장바구니 테이블에서 특정 제품을 장바구니에서 지우기
	@Override
	public int delCart(String cartno) throws SQLException {
		
		int n = 0;
		
		try {
			conn = ds.getConnection();

			String sql = " delete from tbl_cart "+
						 " where cartno = ? ";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, cartno);

			n = pstmt.executeUpdate();
			
		} finally {
			close();
		}
	
		return n;
		
	} // end of public int delCart(String cartno) throws SQLException 

	
	// 장바구니 테이블에서 특정 제품의 수량을 변경하기
	@Override
	public int updateCart(String cartno, String oqty) throws SQLException {
		
		int n = 0;
		
		try {
			conn = ds.getConnection();

			String sql = " update tbl_cart set oqty = ? "+
						 " where cartno = ? ";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, oqty);
			pstmt.setString(2, cartno);

			n = pstmt.executeUpdate();
			
		} finally {
			close();
		}
	
		return n;
	
	} // end of public int updateCart(String cartno, String oqty) throws SQLException

	
	// 장바구니에서 특정제품만 삭제하기
	@Override
	public int delSelectCart(String[] cartnoArr) throws SQLException {

		int n = 0;
		
		String params = "";
		for (int i = 0; i < cartnoArr.length; i++) {
			params += cartnoArr[i];
			if(i<cartnoArr.length-1) {
				params += ",";  // ["1,2"]
			}
		}
		
		try {
			 conn = ds.getConnection(); 
			 
			 String sql = " delete from tbl_cart " +
					      " where cartno in ("+params+") ";
					   
			 pstmt = conn.prepareStatement(sql);
			 
			 n = pstmt.executeUpdate();
			 
			 if(n > 0) {
				 n = 1;
			 }
			 else {
				 n = 0;
			 }
			 
		} finally {
			close();
		}
		
		return n;
	
	} // end of public int delSelectCart(String[] cartnoArr) throws SQLException
	
	

}
