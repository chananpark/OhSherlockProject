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
			
			String sql = " select ceil( count(*)/6 ) "  // 6 이 sizePerPage 이다. 한페이지당 보여주는 상품목록
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
		        		 "        pqty, price, saleprice, pcontent, PSUMMARY, point, pinputdate, reviewCnt, orederCnt "+
		        		 " FROM "+
		        		 "    (SELECT ROWNUM AS rno, cname, sname, pnum, pname, pimage, "+
		        		 "            pqty, price, saleprice, pcontent, PSUMMARY, point, pinputdate, reviewCnt, orederCnt "+
		        		 "     FROM "+
		        		 "        (SELECT c.cname, s.sname, pnum, pname, pimage, "+
		        		 "                pqty, price, saleprice, pcontent, PSUMMARY, point, pinputdate, "+
		        		 "                (select distinct count(FK_ODRCODE) from tbl_order_detail where FK_PNUM=pnum) as orederCnt, "+
		        		 "                (select count(RNUM) from tbl_review where FK_PNUM=pnum) as reviewCnt "+
		        		 "         FROM "+
		        		 "            (SELECT\n"+
		        		 "                pnum, pname, pimage, "+
		        		 "                pqty, price, saleprice, pcontent, PSUMMARY, point, "+
		        		 "                to_char(pinputdate, 'yyyy-mm-dd') AS pinputdate, fk_cnum, fk_snum "+
		        		 "             FROM tbl_product ";
       
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
	       
	        //System.out.println("dao order>>>>>>> " + paraMap.get("order"));
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



	
	
/*	
	// 제품번호 채번 해오기
	@Override
	public int getPnumOfProduct() throws SQLException {
		
		int pnum = 0;
		
		try {
			 conn = ds.getConnection();
			 
			 String sql = " select seq_tbl_product_pnum.nextval AS PNUM " +
					      " from dual ";
					   
			 pstmt = conn.prepareStatement(sql);
			 rs = pstmt.executeQuery();
			 			 
			 rs.next();
			 pnum = rs.getInt(1);
		
		} finally {
			close();
		}
		
		return pnum;

	}// end of public int getPnumOfProduct() throws SQLException {}-------------------


	// tbl_product 테이블에 제품정보 insert 하기
	@Override
	public int productInsert(ProductVO pvo) throws SQLException {

		int result = 0;
	      
	      try {
	         conn = ds.getConnection();
	         
	         String sql = " insert into tbl_product(pnum, pname, fk_cnum, pimage, pqty, price, saleprice, fk_snum, pcontent, point) " +  
	                    " values(?,?,?,?,?,?,?,?,?,?)";
	         
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
	         pstmt.setInt(10, pvo.getPoint());
	            
	         result = pstmt.executeUpdate();
	         
	      } finally {
	         close();
	      }
	      
	      return result;   
	      
	}// end of public void productInsert(ProductVO pvo) throws SQLException {}-------------------

	// 제품번호를 가지고서 해당 제품의 정보를 조회해오기
	@Override
	public ProductVO selectOneProductByPnum(String pnum) throws SQLException {
		
		ProductVO pvo = null;  // get 방식일때 사용자가 url 에 장난칠 수 있으므로 null 값을 주었음.
		
		try {
			 conn = ds.getConnection(); // 커넥션풀 방식
			
			 String sql = " select S.sname, pnum, pname, price, saleprice, point, pqty, pcontent, pimage "+
						  " from "+
						  " ( "+
						  "     select fk_snum, pnum, pname, price, saleprice, point, pqty, pcontent, pimage "+
						  "     from tbl_product "+
						  "     where pnum = ? "+
						  " )P JOIN tbl_spec S "+
						  " ON P.fk_snum  = S.snum "; 
			 
			 pstmt = conn.prepareStatement(sql);
			 pstmt.setString(1, pnum);  // 첫번째 위치홀더 제품번호
			 
			 rs = pstmt.executeQuery();
			 
			 if(rs.next()) {   // 값이 존재한다면 (get 방식이므로 사용자가 장난쳐서 존재하지 않는 제품번호를 입력한 경우를 판별하기 위해 if문 사용함. 만약 장난친 경우 null 값을 리턴, 장난친 것이 아니라면 pvo 리턴함.)
				 
				 String sname = rs.getString(1);     // "NEW", "BEST"
	             int    npnum = rs.getInt(2);        // 제품번호
	             String pname = rs.getString(3);     // 제품명
	             int    price = rs.getInt(4);        // 제품 정가
	             int    saleprice = rs.getInt(5);    // 제품 판매가
	             int    point = rs.getInt(6);        // 포인트 점수
	             int    pqty = rs.getInt(7);         // 제품 재고량
	             String pcontent = rs.getString(8);  // 제품설명
	             String pimage = rs.getString(9);    // 제품이미지
	             
	             pvo = new ProductVO(); // ProductVO 객체생성
	             
	             SpecVO spvo = new SpecVO();  // SpecVO 객체생성
	             spvo.setSname(sname);        // Sname(스펙명)을 spvo(스펙VO)를 통해 담아옴.
	             
	             pvo.setSpvo(spvo);
	             pvo.setPnum(npnum);
	             pvo.setPname(pname);
	             pvo.setPrice(price);
	             pvo.setSaleprice(saleprice);
	             pvo.setPoint(point);
	             pvo.setPqty(pqty);
	             pvo.setPcontent(pcontent);
	             pvo.setPimage(pimage);
				 
			 }// end of while-----------------------------
			 
		} finally {
			close();
		}
		
		return pvo;
		
	}// end of public ProductVO selectOneProductByPnum(String pnum) throws SQLException {}-------------------
*/
	
	
	
	// 찜목록 담기 
    // 찜목록 테이블(tbl_Like)에 해당 제품을 담아야 한다.
    // 찜목록 테이블에 해당 제품이 존재하지 않는 경우에는 tbl_Like 테이블에 insert 를 해야하고, 
    // 찜목록 테이블에 해당 제품이 존재하는 경우에 또 찜목록을 누르는 경우 tbl_Like 테이블에 delete 를 해야한다.
	@Override
	public int addLike(String userid, String pnum) throws SQLException {
		int result = 0;
	      
	      try {
	         conn = ds.getConnection();
	         
       /*
           먼저 찜목록 테이블(tbl_like)에 어떤 회원이 새로운 제품을 넣는 것인지,
           아니면 기존에 찜함 제품을 삭제하는 것인지 알아야 한다.
           이것을 알기위해서 어떤 회원이 어떤 제품을 찜하기 할때
           그 제품이 이미 존재하는지 select 를 통해서 알아와야 한다.
           
         --------------------------------
          likeno   fk_userid   fk_pnum  
         --------------------------------
            1      leeye05        7            
            2      leeye05        6             
            3      leess          7            
        */   
	         
	         String sql = " select likeno "+
	                      " from tbl_like "+
	                      " where fk_userid = ? and fk_pnum = ? ";

	         
	         pstmt = conn.prepareStatement(sql);
	         pstmt.setString(1, userid);
	         pstmt.setString(2, pnum);

	         rs = pstmt.executeQuery();  // 조회하면 한개만 나온다.
	         
	         if(rs.next()) {  // 있다라면
	        	 // 기존 찜하기한 제품을 삭제한다.
	        	 
	        	 int likeno = rs.getInt("likeno");  // 조회된 찜하기가 있다라면 찜제품번호를 알아온다. 찜목록번호는 시퀀스.
	        	 
	        	 sql = " delete from tbl_like "+
	        		   " where likeno = ? ";
	        	 
	        	 pstmt = conn.prepareStatement(sql);
		         pstmt.setInt(1, likeno);  // 위에서 조회해온 찜목록번호
	        	
		         result = pstmt.executeUpdate();
	         }
	         else { // 없다라면
	        	 // 찜목록에 존재하지 않는 새로운 제품을 넣고자 하는 경우
	        	 
	        	 sql = " insert into tbl_like(likeno, fk_userid, fk_pnum, registerday) "+
	        		   " values(seq_tbl_like_likeno.nextval, ?, ?, default) ";
	                  
               pstmt = conn.prepareStatement(sql);
               pstmt.setString(1, userid);
               pstmt.setInt(2, Integer.parseInt(pnum));  // 제품번호
                
               result = pstmt.executeUpdate();
               System.out.println("확인용 ==> " + result);
	         }
	         
	      } finally {
	         close();
	      }
	      
	      return result; 
	}// end of public int addLike(String userid, String pnum) throws SQLException {}-------------------


	// 로그인한 사용자의 찜목록을 조회하기
	@Override
	public List<LikeVO> selectProductLike(String userid) throws SQLException {
		List<LikeVO> likeList = new ArrayList<>();
		
		try {
			conn = ds.getConnection(); // 커넥션풀 방식
			
			String sql = " select likeno, fk_userid, fk_pnum, pname, pimage, saleprice "+
						 " from tbl_like A join tbl_product B "+
						 " on A.fk_pnum = B.pnum "+
						 " where A.fk_userid = ? "+
						 " order by likeno desc ";
			
			pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userid);
			
            rs = pstmt.executeQuery();
            
            while(rs.next()) {  // 조회한 찜목록이 있다라면
            	
            	int likeno = rs.getInt("likeno");
                String fk_userid = rs.getString("fk_userid");
                int fk_pnum = rs.getInt("fk_pnum");
                String pname = rs.getString("pname");
                String pimage = rs.getString("pimage");
                int saleprice = rs.getInt("saleprice");
                
                ProductVO prodvo = new ProductVO();  // join한 제품테이블
                prodvo.setPnum(fk_pnum);
                prodvo.setPname(pname);
                prodvo.setPimage(pimage);
                prodvo.setSaleprice(saleprice);
                
                LikeVO lvo = new LikeVO(); // 찜목록 테이블
                lvo.setLikeno(likeno);     // 찜목록번호
                lvo.setUserid(fk_userid);  // 사용자아이디
                lvo.setPnum(fk_pnum);      // 제품번호
                lvo.setProd(prodvo);       // join 한 제품테이블 정보(위에서 set한 정보들을 넣어준다.)
                
                likeList.add(lvo);
            }// end of while---------------------
            
		} finally {
			close();
		}
		
		//System.out.println("확인용 :::::::::: " + likeList);
		return likeList;  // 리턴할 값이 없으면 0 이 들어온다.
	}// end of public List<LikeVO> selectProductLike(String userid) throws SQLException {}-------------------


	// 찜목록 테이블에서 특정제품을 찜목록에서 비우기
	@Override
	public int delLike(String[] likeno) throws SQLException {
		
		int n = 0;
		
		String params = "";
		for (int i = 0; i < likeno.length; i++) {
			params += likeno[i];
			if(i<likeno.length-1) {
				params += ",";
			}
		}
		
		try {
			 conn = ds.getConnection();  // 커넥션풀 방식
			 
			 String sql = " delete from tbl_like " +
					      " where likeno in ("+params+") ";
					   
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
	}// end of public int delLike(String likeno) throws SQLException {}-------------------


	

}
