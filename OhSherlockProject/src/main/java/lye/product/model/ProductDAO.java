package lye.product.model;

import java.sql.*;
import java.util.*;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import common.model.*;

public class ProductDAO implements InterProductDAO {

	private DataSource ds;     
	private Connection conn;          
	private PreparedStatement pstmt;  
	private ResultSet rs;             // 자원 저장소 초기화
	
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
			
			if( rs != null ) { rs.close(); rs=null; }           // 자원저장소가 null 이 아니라면 rs 을 반납한다. 그리고 확인차 null 로 만들어준다.
			if( pstmt != null ) { pstmt.close(); pstmt=null; }  // 우편배달부가 null 이 아니라면 pstmt 을 반납한다. 
			if( conn != null ) { conn.close(); conn=null; }     // 연결이 null 이 아니라면 conn 을 반납한다.
			
		} catch(SQLException e) {
			e.printStackTrace();
		}
		
	}
	
	
	// Ajax(JSON)를 이용한 더보기 방식(페이징처리)으로 상품정보를 8개씩 잘라서(start ~ end) 조회해오기  
	@Override
	public List<ProductVO> selectBySpecName(Map<String, String> paraMap) throws SQLException {
		
		List<ProductVO> prodList = new ArrayList<>();
		
		try {
			 conn = ds.getConnection(); // 커넥션풀 방식
			
			 String sql = " select pnum, pname, code, pimage, pqty, price, saleprice, pcontent, psummary, point, pinputdate "+
						  " from "+
						  " ( "+
						  "     select row_number() over(order by pnum desc) AS RNO "+
						  "          , pnum, pname, C.code, pimage, pqty, price, saleprice, pcontent, psummary, point "+
						  "          , to_char(pinputdate, 'yyyy-mm-dd') as pinputdate "+
						  "     from tbl_product P "+
						  "     JOIN tbl_category C "+
						  "     ON P.fk_cnum = C.cnum "+
						  " ) V "+
						  " where RNO between ? and ? ";
			 
			 pstmt = conn.prepareStatement(sql);
			 pstmt.setString(1, paraMap.get("start"));
			 pstmt.setString(2, paraMap.get("end"));
			 
			 rs = pstmt.executeQuery();
			 
			 while(rs.next()) {   // 값이 있다면
				 
				 ProductVO pvo = new ProductVO();
				 
				 pvo.setPnum(rs.getInt(1));      // 제품번호  
				 pvo.setPname(rs.getString(2));  // 제품명  
				 
				 CategoryVO categvo = new CategoryVO();  // categvo 객체생성 
				 categvo.setCode(rs.getString(3));       // code(카테고리 코드)를 categvo(카테고리VO)를 통해 담아옴.
				 pvo.setCategvo(categvo);                // 카테고리 코드
				 
				 pvo.setPimage(rs.getString(4));   // 썸네일이미지   이미지파일명
				 pvo.setPqty(rs.getInt(5));         // 제품 재고량
				 pvo.setPrice(rs.getInt(6));        // 제품 정가
				 pvo.setSaleprice(rs.getInt(7));    // 제품 판매가(할인해서 팔 것)
				 
				 pvo.setPcontent(rs.getString(8));   // 제품설명
				 pvo.setPsummary(rs.getString(9));   // 제품요약
				 pvo.setPoint(rs.getInt(10));         // 포인트 점수 
				 pvo.setPinputdate(rs.getString(11)); // 제품입고일자 
				 
				 prodList.add(pvo);
			 }// end of while-----------------------------
			 
		} finally {
			close();
		}
		
		return prodList;
	}// end of public List<ProductVO> selectBySpecName(Map<String, String> paraMap) throws SQLException {}-------------------


	
	// 페이지바를 만들기 위해서 전체 상품개수에 대한 총페이지수 알아오기
	@Override
	public int getTotalPage() throws SQLException {
		
		int totalPage = 0;  // 초기값
		
		try {
			conn = ds.getConnection();  // 커넥션풀 방식
			String sql = " select ceil( count(*)/6 ) "+
						 " from tbl_product "+
						 " where fk_cnum between 1 and 3 ";
			
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			
			rs.next();
			totalPage = rs.getInt(1);
			
		} catch (Exception e) {
			close();
		}
		
		return totalPage;
	}// end of public int getTotalPage() throws SQLException {}-------------------

	
	
	// 페이지바를 만들기 위해서 특정 카테고리의 상품개수에 대한 총페이지수 알아오기
	@Override
	public int getTotalPageByCategory(String cnum) throws SQLException {

		int totalPageByCategory = 0;  // 초기값
		
		try {
			conn = ds.getConnection();  // 커넥션풀 방식
			
			String sql = " select ceil( count(*)/6 ) "  // 6 이 sizePerPage 이다. 한페이지당 보여주는 제품목록
					   + " from tbl_product "
					   + " where fk_cnum = ? ";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, cnum);  // 'NEW', 'BEST' 에 대한 스펙번호인 시퀀스번호를 참조한 것
			
			rs = pstmt.executeQuery();
			
			rs.next();
				
			totalPageByCategory = rs.getInt(1);
			
		} catch (Exception e) {
			close();
		}
		
		return totalPageByCategory;
	}// end of public int getTotalPage(String cnum) throws SQLException {}-------------------

	
	// 전체 및 특정상품들을 페이지바를 사용한 페이징 처리하여 조회(select) 해오기
	@Override
	public List<ProductVO> selectPagingProduct(Map<String, String> paraMap) throws SQLException {

		List<ProductVO> productList = new ArrayList<>();  // ArrayList 객체생성
		
		try {
			conn = ds.getConnection();  // 커넥션풀 방식 연결
			
			String sql = " SELECT cname, sname, pnum, pname, pimage, "+
	        		 "     pqty, price, saleprice, pcontent, PSUMMARY, point, pinputdate, reviewCnt, orederCnt "+
	        		 " FROM "+
	        		 "    (SELECT ROWNUM AS rno, cname, sname, pnum, pname, pimage, "+
	        		 "            pqty, price, saleprice, pcontent, PSUMMARY, point, pinputdate, reviewCnt, orederCnt "+
	        		 "    FROM "+
	        		 "        (SELECT c.cname, s.sname, pnum, pname, pimage, "+
	        		 "                pqty, price, saleprice, pcontent, PSUMMARY, point, pinputdate, "+
	        		 "                (select distinct count(FK_ONUM) from tbl_order_detail where FK_PNUM=pnum) as orederCnt, "+
	        		 "                (select count(RNUM) from tbl_review where FK_PNUM=pnum) as reviewCnt "+
	        		 "        FROM "+
	        		 "            (SELECT\n"+
	        		 "                pnum, pname, pimage, "+
	        		 "                pqty, price, saleprice, pcontent, PSUMMARY, point, "+
	        		 "                to_char(pinputdate, 'yyyy-mm-dd') AS pinputdate, fk_cnum, fk_snum "+
	        		 "            FROM tbl_product ";
       
	       // 특정 카테고리 조회시
	       if (paraMap.get("cnum") != null) {
	       	sql +=	"            WHERE fk_cnum = ? ";
	       }
	       // 베스트 카테고리 조회시
	       else if(paraMap.get("snum") != null) {
    	    sql +=	"            WHERE fk_snum = ? and fk_cnum in (1,2,3) ";
	       }
	       // 전체 조회시
	       else {
	       	sql +=	"            WHERE fk_cnum in (1,2,3) ";
	       }
	       
	        System.out.println("dao order>>>>>>> " + paraMap.get("order"));
    	    sql +=	"            ) p "+
		    	    "            JOIN tbl_category  c ON p.fk_cnum = c.cnum "+
		    	    "            LEFT OUTER JOIN tbl_spec s "+
		    	    "            ON p.fk_snum = s.snum "+
		    	    "			 ORDER BY " + paraMap.get("order")+") V "+
		    	    "    ) t "+
		    	    " WHERE t.rno BETWEEN ? AND ? ";
    	    
			int currentShowPageNo = Integer.parseInt(paraMap.get("currentShowPageNo"));  // String 타입이므로 int 타입으로 변환해준다. currentShowPageNo 는 몇번째 페이지를 보여주는지 나타냄.
			int sizePerPage = 6;         // 한 페이지당 화면상에 보여줄 제품의 개수는 6개씩 보여주는 것으로 한다.     
			
	        pstmt = conn.prepareStatement(sql);
	        
	        // 특정 카테고리 조회시
	        if (paraMap.get("cnum") != null) {
		        pstmt.setString(1, paraMap.get("cnum"));
		        pstmt.setInt(2, (currentShowPageNo * sizePerPage) - (sizePerPage - 1));
		        pstmt.setInt(3, (currentShowPageNo * sizePerPage));
	        }
	        // 베스트 카테고리 조회시
	        else if(paraMap.get("snum") != null) {
	        	pstmt.setString(1, paraMap.get("snum"));
		        pstmt.setInt(2, (currentShowPageNo * sizePerPage) - (sizePerPage - 1));
		        pstmt.setInt(3, (currentShowPageNo * sizePerPage));
	        }
	        // 전체 조회시
	        else {
		        pstmt.setInt(1, (currentShowPageNo * sizePerPage) - (sizePerPage - 1));
		        pstmt.setInt(2, (currentShowPageNo * sizePerPage));
	        }

	        rs = pstmt.executeQuery();
			
			while (rs.next()) {
	            ProductVO pvo = new ProductVO();
	            pvo.setPnum(rs.getInt("pnum")); // 제품번호
	            pvo.setPname(rs.getString("pname")); // 제품명
	            //pvo.setFk_cnum(rs.getInt("fk_cnum")); // 카테고리 번호

	            CategoryVO categvo = new CategoryVO();
	            categvo.setCname(rs.getString("cname")); // 카테고리 이름
	            pvo.setCategvo(categvo);

	            pvo.setPimage(rs.getString("pimage")); // 제품이미지1 이미지파일명
	            pvo.setPqty(rs.getInt("pqty")); // 제품 재고량
	            pvo.setPrice(rs.getInt("price")); // 제품 정가
	            pvo.setSaleprice(rs.getInt("saleprice")); // 제품 판매가

	            SpecVO spvo = new SpecVO();
	            spvo.setSname(rs.getString("sname"));
	            pvo.setSpvo(spvo);

	            pvo.setPcontent(rs.getString("pcontent"));
	            pvo.setPsummary(rs.getString("psummary"));
	            pvo.setPoint(rs.getInt("point"));
	            pvo.setPinputdate(rs.getString("pinputdate"));
	            pvo.setReviewCnt(rs.getInt("reviewCnt"));
	            pvo.setOrederCnt(rs.getInt("orederCnt"));

	            productList.add(pvo);
			}// end of while--------------------
			
		} finally {
			close();
		}
		
		return productList;
	}// end of public List<ProductVO> selectPagingProductByCategory(Map<String, String> paraMap) throws SQLException {}-------------------

	

	
	

}
