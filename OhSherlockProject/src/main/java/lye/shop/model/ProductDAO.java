package lye.shop.model;

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

	
	// 페이징 방식 카테고리별 티 상품 총 페이지수 알아오기
	@Override
	public int getTotalPage(Map<String, String> paraMap) throws SQLException {
		
		int totalPage = 0;

		String cnum = paraMap.get("cnum");
		String snum = paraMap.get("snum");
		
		try {
			conn = ds.getConnection();

			String sql = " select ceil( count(*)/6 ) " // 6 이 sizePerPage 이다.
					   + " from tbl_product " ;
			
			// 특정 카테고리 조회시
			if (!"".equals(cnum)) {
				sql += " where fk_cnum = ? ";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, cnum);
			}
			
			// 특정 스펙 조회시
			else if (!"".equals(snum)) {
				sql += " where fk_snum = ? and fk_cnum in (1,2,3) ";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, snum);
			}
			
			// 전체 조회시
			else {
				sql += " where fk_cnum in (1,2,3) ";
				pstmt = conn.prepareStatement(sql);
			}
			rs = pstmt.executeQuery();

			rs.next();

			totalPage = rs.getInt(1);

		} finally {
			close();
		}

		return totalPage;

	}// end of	public int getTotalPage(Map<String, String> paraMap) throws SQLException {}-------------------
	
	
	// 전체 및 특정상품들을 페이지바를 사용한 페이징 처리하여 조회(select) 해오기
	@Override
	public List<ProductVO> selectGoodsByCategory(Map<String, String> paraMap) throws SQLException {

		List<ProductVO> productList = new ArrayList<>();

	    try {
	        conn = ds.getConnection();

	        String sql = " SELECT cname, sname, pnum, pname, pimage, "+
		        		 "     pqty, price, saleprice, pcontent, PSUMMARY, point, pinputdate, reviewCnt, orederCnt "+
		        		 " FROM "+
		        		 "     (SELECT ROWNUM AS rno, cname, sname, pnum, pname, pimage, "+
		        		 "             pqty, price, saleprice, pcontent, PSUMMARY, point, pinputdate, reviewCnt, orederCnt "+
		        		 "     FROM "+
		        		 "         (SELECT c.cname, s.sname, pnum, pname, pimage, "+
		        		 "                 pqty, price, saleprice, pcontent, PSUMMARY, point, pinputdate, "+
		        		 "                 orederCnt,reviewCnt "+
		        		 "          FROM "+
		        		 "             (SELECT "+
		        		 "                 pnum, pname, pimage, "+
		        		 "                 pqty, price, saleprice, pcontent, PSUMMARY, point, "+
		        		 "                 to_char(pinputdate, 'yyyy-mm-dd') AS pinputdate, fk_cnum, fk_snum, "+
		        		 "                 (select distinct count(fk_odrcode) from tbl_order_detail where FK_PNUM=pnum) as orederCnt, "+
		        		 "                 (select count(RNUM) from tbl_review where FK_PNUM=pnum) as reviewCnt "+
		        		 "              FROM tbl_product\n";
	        
		    // 특정 카테고리 조회시
	        if (!"".equals(paraMap.get("cnum"))) {
	        	sql +=	"            WHERE fk_cnum = ?\n";
	        }
	        
	        // 특정 스펙 조회시
	        else if (!"".equals(paraMap.get("snum"))) {
	        	sql +=	"            WHERE fk_snum = ? and fk_cnum in (1,2,3)\n";
	        }
	        
	        // 전체 조회시
	        else {
	        	sql +=	"            WHERE fk_cnum in (1,2,3)\n";
	        }
        
	        sql += "            ) p\n"+
        		"            JOIN tbl_category  c ON p.fk_cnum = c.cnum\n"+
        		"            LEFT OUTER JOIN tbl_spec s\n"+
        		"            ON p.fk_snum = s.snum "+
        		"			 ORDER BY " + paraMap.get("order")+")V\n"+
        		"    ) t\n"+
        		"WHERE t.rno BETWEEN ? AND ?\n";
	        	
	        /*
	         === 페이징처리 공식 === 
	         where RNO between (조회하고자 하는 페이지 번호 * 한페이지당 보여줄 행의 개수) -
	         (한페이지당 보여줄 행의 개수 - 1) and (조회하고자 하는 페이지 번호 * 한페이지당 보여줄 행의 개수)
	         */
	        
	        int currentShowPageNo = Integer.parseInt(paraMap.get("currentShowPageNo"));
	        int sizePerPage = 6;

	        pstmt = conn.prepareStatement(sql);
	        
	        // 특정 카테고리 조회시
	        if (!"".equals(paraMap.get("cnum"))) {
		        pstmt.setString(1, paraMap.get("cnum"));
		        pstmt.setInt(2, (currentShowPageNo * sizePerPage) - (sizePerPage - 1));
		        pstmt.setInt(3, (currentShowPageNo * sizePerPage));
	        }
	        // 특정 스펙 조회시
	        else if (!"".equals(paraMap.get("snum"))) {
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
	        }

	    } finally {
	        close();
	    }

	    return productList;
	}// end of public List<ProductVO> selectGoodsByCategory(Map<String, String> paraMap) throws SQLException {}-------------------


	
	
	
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
    // 찜목록 테이블에 해당 제품이 존재하는 경우에 또 찜목록을 누르는 경우 tbl_Like 테이블에 해당상품을 덮어씌워 update를 한다.
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
	        	 // 기존 찜하기한 제품을 업데이트한다.
	        	 
	        	 int likeno = rs.getInt("likeno");  // 조회된 찜하기가 있다라면 찜제품번호를 알아온다. 찜목록번호는 시퀀스.
	        	 
	        	 sql = " update tbl_like set likeno = likeno "+
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
               //System.out.println("확인용 ==> " + result);
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
			
			String sql = " select likeno, fk_userid, fk_pnum, pname, pimage, price, saleprice, point, oqty "+
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
				int price = rs.getInt("price");
				int saleprice = rs.getInt("saleprice");
				int point = rs.getInt("point");
				int oqty = rs.getInt("oqty");  // 주문량
				
				ProductVO prodvo = new ProductVO();  // join한 제품테이블
				prodvo.setPnum(fk_pnum);
				prodvo.setPname(pname);
				prodvo.setPimage(pimage);
				prodvo.setPrice(price);
				prodvo.setSaleprice(saleprice);
				prodvo.setPoint(point);
				
				prodvo.setTotalPriceTotalPoint(oqty); // 총 결제금액, 포인트
				
				LikeVO lvo = new LikeVO(); // 찜목록 테이블
				lvo.setLikeno(likeno);     // 찜목록번호
				lvo.setUserid(fk_userid);  // 사용자아이디
				lvo.setPnum(fk_pnum);      // 제품번호
				lvo.setOqty(oqty);
				lvo.setProd(prodvo);       // join 한 제품테이블 정보(위에서 set한 정보들을 넣어준다.)
				
				likeList.add(lvo);
			}// end of while---------------------
			
		} finally {
			close();
		}
		
		return likeList;  // 리턴할 값이 없으면 0 이 들어온다.
	}// end of public List<LikeVO> selectProductLike(String userid) throws SQLException {}-------------------
	
	
	// 찜목록 테이블에서 특정제품 1개행을 찜목록에서 비우기
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
	

	// 찜목록 테이블에서 특정제품 선택행들을 찜목록에서 비우기
	@Override
	public int delSelectLike(String[] likenoArr) throws SQLException {
		
		int n = 0;
		
		String params = "";
		for (int i = 0; i < likenoArr.length; i++) {
			params += likenoArr[i];
			if(i<likenoArr.length-1) {
				params += ",";  // ["1,2"]
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

	
	

	// 로그인한 사용자의 상품리뷰 조회하기
	@Override
	public List<ReviewVO> ProductReviewList(String userid) throws SQLException {
		
		List<ReviewVO> reviewList = new ArrayList<>();
		
		try {
			conn = ds.getConnection(); // 커넥션풀 방식
			
			String sql = " select rnum, fk_userid, fk_odnum, score, rsubject, rcontent, rimage, A.fk_odrcode, writeDate, A.fk_pnum "+
						 "      , pname, pimage, price, saleprice, oprice "+
						 " from tbl_review A join tbl_product B "+
						 " on A.fk_pnum = B.pnum "+
						 " join tbl_order_detail C "+
						 " on A.fk_odrcode = C.fk_odrcode "+
						 " where fk_userid = ? "+
						 " order by writeDate desc ";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userid);
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {  // 조회한 상품리뷰가 있다면
				
				int rnum = rs.getInt("rnum");
				String fk_userid = rs.getString("fk_userid");
				int fk_odnum = rs.getInt("fk_odnum");
				int score = rs.getInt("score");
				String rsubject = rs.getString("rsubject");
				String rcontent = rs.getString("rcontent");
				String rimage = rs.getString("rimage");
				String fk_odrcode = rs.getString("fk_odrcode");
				String writeDate = rs.getString("writeDate");
				int fk_pnum = rs.getInt("fk_pnum");
				String pname = rs.getString("pname");
				String pimage = rs.getString("pimage");
				int price = rs.getInt("price");
				int saleprice = rs.getInt("saleprice");
				int oprice = rs.getInt("oprice");
				
				ProductVO prodvo = new ProductVO();  // join한 제품테이블
				prodvo.setPnum(fk_pnum);
				prodvo.setPname(pname);
				prodvo.setPimage(pimage);
				prodvo.setPrice(price);
				prodvo.setSaleprice(saleprice);
				
				OrderDetailVO odvo = new OrderDetailVO(); // join한 주문상세테이블
				odvo.setFk_odrcode(fk_odrcode);
				odvo.setOprice(oprice);
				
				ReviewVO rvo = new ReviewVO(); // 리뷰 테이블
				rvo.setRnum(rnum);
				rvo.setUserid(fk_userid);  // 사용자아이디
				rvo.setOdnum(fk_odnum);
				rvo.setScore(score);
				rvo.setRsubject(rsubject);
				rvo.setRcontent(rcontent);
				rvo.setRimage(rimage);
				rvo.setOdrcode(fk_odrcode);
				rvo.setWriteDate(writeDate);
				rvo.setPnum(fk_pnum);      // 제품번호
				rvo.setProd(prodvo);       // join 한 제품테이블 정보(위에서 set한 정보들을 넣어준다.)
				rvo.setOddt(odvo);         // join 한 주문상세테이블 정보(위에서 set한 정보들을 넣어준다.)
				
				reviewList.add(rvo);
			}// end of while---------------------
			
		} finally {
			close();
		}
		
		//System.out.println(reviewList.toString());
		return reviewList;  // 리턴할 값이 없으면 0 이 들어온다.
		
	}// end of public List<LikeVO> ProductReviewList(String userid) throws SQLException {}-------------------

	
	// 페이징 방식 리뷰상품 총 페이지수 알아오기
	@Override
	public int getTotalPages(String userid) throws SQLException {

		int totalPage = 0;  // 초기값
		
		try {
			conn = ds.getConnection();  // 커넥션풀 방식
			
			String sql = " select ceil( count(*)/10 ) "  // 10 이 sizePerPage 이다. 한페이지당 보여주는 제품목록  // ceil 은 예를 들어 3.5 이면 보다큰 최소의 정수 4로 올려준다.
					   + " from tbl_review "
					   + " where fk_userid = ? ";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userid);
			
			rs = pstmt.executeQuery();
			
			rs.next();
				
			totalPage = rs.getInt(1);
			
		} catch (Exception e) {
			close();
		}
		
		System.out.println("확인용 totalPage:" + totalPage);
		return totalPage;
	}// end of public int getTotalPage(String cnum) throws SQLException {}-------------------


	// 페이징 처리를 한 모든 상품리뷰 목록 보여주기
	public List<ReviewVO> selectPagingReview(Map<String, Object> paraMap) throws SQLException {
		
		List<ReviewVO> reviewList = new ArrayList<>();  // ArrayList 객체생성
		
		try {
			conn = ds.getConnection();  // 커넥션풀 방식 연결
			
			String sql = " select rnum, fk_userid, fk_odnum, score, rsubject, rcontent, rimage, fk_odrcode, writeDate, fk_pnum "+
						 "      , pname, pimage "+
						 "     from "+
						 "     ( "+
						 "         select rownum AS RNO, V.rnum, V.fk_userid, V.fk_odnum, V.score, V.rsubject, V.rcontent, V.rimage, V.fk_odrcode, V.writeDate, V.fk_pnum "+
						 "              , V.pname, V.pimage "+
						 "         from "+
						 "         ( "+
						 "             select rnum, fk_userid, fk_odnum, score, rsubject, rcontent, rimage, A.fk_odrcode, writeDate, A.fk_pnum "+
						 "                  , pname, pimage, price, saleprice, oprice "+
						 "             from tbl_review A join tbl_product B "+
						 "             on A.fk_pnum = B.pnum "+
						 "             join tbl_order_detail C "+
						 "             on A.fk_odrcode = C.fk_odrcode "+
						 "             where fk_userid = ? "+
						 "             order by writeDate desc "+
						 "         ) V "+
						 "     ) T "+
						 " where T.RNO between ? and ? ";  
			
			int currentShowPageNo = Integer.parseInt((String)paraMap.get("currentShowPageNo"));  // 조회하고자 하는 페이지 번호
			int sizePerPage = 10; // 한페이지당 보여줄 행의 개수

			
			pstmt = conn.prepareStatement(sql);  // 우편배달부
			pstmt.setString(1, (String) paraMap.get("userid"));
			pstmt.setInt(2, (currentShowPageNo*sizePerPage) - (sizePerPage - 1) ); // 공식(몇 페이지부터)
			pstmt.setInt(3, (currentShowPageNo*sizePerPage) ); // 공식(몇 페이지까지)
			
			
			rs = pstmt.executeQuery();  // 자원 저장소(결과값)
			
			while(rs.next()) {  // 조회한 상품리뷰가 있다면
				
				int rnum = rs.getInt("rnum");
				String fk_userid = rs.getString("fk_userid");
				int fk_odnum = rs.getInt("fk_odnum");
				int score = rs.getInt("score");
				String rsubject = rs.getString("rsubject");
				String rcontent = rs.getString("rcontent");
				String rimage = rs.getString("rimage");
				String fk_odrcode = rs.getString("fk_odrcode");
				String writeDate = rs.getString("writeDate");
				int fk_pnum = rs.getInt("fk_pnum");
				String pname = rs.getString("pname");
				String pimage = rs.getString("pimage");
				
				ProductVO prodvo = new ProductVO();  // join한 제품테이블
				prodvo.setPnum(fk_pnum);
				prodvo.setPname(pname);
				prodvo.setPimage(pimage);
				
				OrderDetailVO odvo = new OrderDetailVO(); // join한 주문상세테이블
				odvo.setFk_odrcode(fk_odrcode);
				
				ReviewVO rvo = new ReviewVO(); // 리뷰 테이블
				rvo.setRnum(rnum);
				rvo.setUserid(fk_userid);  // 사용자아이디
				rvo.setOdnum(fk_odnum);
				rvo.setScore(score);
				rvo.setRsubject(rsubject);
				rvo.setRcontent(rcontent);
				rvo.setRimage(rimage);
				rvo.setOdrcode(fk_odrcode);
				rvo.setWriteDate(writeDate);
				rvo.setPnum(fk_pnum);      // 제품번호
				rvo.setProd(prodvo);       // join 한 제품테이블 정보(위에서 set한 정보들을 넣어준다.)
				rvo.setOddt(odvo);         // join 한 주문상세테이블 정보(위에서 set한 정보들을 넣어준다.)
				
				reviewList.add(rvo);
			}// end of while---------------------
			
		} finally {
			close();
		}
		
		return reviewList;
	}// end of public List<ReviewVO> selectPagingReview(Map<String, Object> paraMap) throws SQLException {}-------------------






	

}
