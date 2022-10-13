package kcy.shop.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import common.model.FaqVO;
import common.model.ProductVO;
import common.model.ReviewVO;
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
		
		// 자원 반납 메소드
		private void close() {
			try {
				if(rs != null)    {rs.close();    rs=null;}
				if(pstmt != null) {pstmt.close(); pstmt=null;}
				if(conn != null)  {conn.close();  conn=null;}
			} catch(SQLException e) {
				e.printStackTrace();
			}
		}

		// 제품번호를 가지고서 해당 제품의 정보를 조회해오기 
	      @Override
	      public ProductVO selectOneProductByPnum(String pnum) throws SQLException {

	         ProductVO pvo = null;
	         
	         try {
	             conn = ds.getConnection();
	            
	             String sql = "select fk_snum, pnum, pname, price, saleprice, point, pqty, psummary, pimage, fk_cnum\n"+
	                   "            from tbl_product  \n"+
	                   "            where pnum = ? "; 
	             
	             pstmt = conn.prepareStatement(sql);
	             pstmt.setString(1, pnum);
	                       
	             rs = pstmt.executeQuery();
	             
	             if(rs.next()) {
	                
	                int fk_snum = rs.getInt("fk_snum");     // "HIT", "NEW", "BEST" 값을 가짐 
	                int npnum = rs.getInt("pnum");
	                String pname = rs.getString("pname");
	                int price = rs.getInt("price");
	                int saleprice = rs.getInt("saleprice");
	                int point = rs.getInt("point");
	                int pqty = rs.getInt("pqty");
	                String psummary = rs.getString("psummary");
	                String pimage = rs.getString("pimage");
	                int fk_cnum = rs.getInt("fk_cnum");
	                
	                pvo = new ProductVO(); 
	                
	                pvo.setFk_snum(fk_snum);
	                pvo.setPnum(npnum);
	                pvo.setPname(pname);
	                pvo.setPrice(price);
	                pvo.setSaleprice(saleprice);
	                pvo.setPoint(point);
	                pvo.setPqty(pqty);
	                pvo.setPsummary(psummary);
	                pvo.setPimage(pimage);
	                pvo.setFk_cnum(fk_cnum);
	                
	             }// end of while-----------------------------
	             
	         } finally {
	            close();
	         }
	         
	         return pvo;   
	         
	      }// end of 제품번호를 가지고서 해당 제품의 정보를 조회해오기 -------------------------  

		
		// 제품번호를 가지고서 해당 제품의 추가된 이미지 정보를 조회해오기
		@Override
		public List<String> getImagesByPnum(String pnum) throws SQLException {

			List<String> imgList = new ArrayList<>();
			
			try {
				conn = ds.getConnection();
				
				String sql = " select imgfilename "
						   + " from tbl_product_imagefile "
						   + " where fk_pnum = ? ";
				
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, pnum);
				
				rs = pstmt.executeQuery();
				
				while(rs.next()) {
					
					String imgfilename = rs.getString(1); // 이미지파일명 
					imgList.add(imgfilename);
				}// end of while-------------------
				
			} finally {
				close();
			}
			
			return imgList;
			
		}// end of 제품번호를 가지고서 해당 제품의 추가된 이미지 정보를 조회해오기 -----------------------

		
		// 리뷰 내용 조회
		@Override
		public ReviewVO showReviewDetail(Map<String, String> paraMap) throws SQLException {
			
			ReviewVO rvo = new ReviewVO();
			
			try {
				conn = ds.getConnection();

				String sql = " select rnum, rsubject, fk_userid, writedate, score "+
						     " from TBL_REVIEW "+
						     " where rnum = ? ";

				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, paraMap.get("rnum"));
				rs = pstmt.executeQuery();

				if (rs.next()) {
					rvo.setRnum(Integer.parseInt(paraMap.get("rnum")));
					rvo.setRsubject(rs.getString(2));
					rvo.setUserid(rs.getString(3));
					rvo.setWriteDate(rs.getString(4));
					rvo.setScore(rs.getInt(5));
					
				}

			} finally {
				close();
			}	
			
			return rvo;
			
			
		}// end of 리뷰 내용 조회 ------------------------------------------------

		
		// 전체 페이지 수 알아오기
		@Override
		public int getTotalPage(Map<String, String> paraMap) throws SQLException {
			
			
			int totalPage = 0;

			try {
				conn = ds.getConnection();

				String sql = " select ceil(count(*)/?) from TBL_REVIEW ";

				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, 10);

				rs = pstmt.executeQuery();
				rs.next();
				totalPage = rs.getInt(1);

			} finally {
				close();
			}

			return totalPage;
			
			
		}// end of 전체 페이지 수 알아오기 ------------------------------------------

		// 리뷰 목록
		@Override
		public List<ReviewVO> showReviewList(Map<String, String> paraMap) throws SQLException {

			List<ReviewVO> reviewList = new ArrayList<>();
			
			String pnum = paraMap.get("pnum"); 

			try {
				conn = ds.getConnection();

				String sql = " select rnum, fk_userid, fk_pnum, rsubject, rcontent, to_char(writeDate, 'yyyy-mm-dd') AS writeDate, score "+
							 " from  "+
							 "    (select rownum as rno, rnum, fk_userid, fk_pnum, rsubject, rcontent, writeDate, score "+
							 "     from  "+
							 "         (select rnum, fk_userid, fk_pnum, rsubject, rcontent, writeDate, score "+
							 "          from TBL_REVIEW "+
							 "          where fk_pnum = ? "+
							 "          order by 1 desc) V  "+
							 "    ) T  "+
							 " where RNO between ? and ? ";      
				
				
				
				// 페이징처리
				
				int currentShowPageNo = Integer.parseInt(paraMap.get("currentShowPageNo"));  // 조회하고자 하는 페이지 번호
				int sizePerPage = 10; // 한페이지당 보여줄 행의 개수

				pstmt = conn.prepareStatement(sql);
				
				pstmt.setString(1, pnum);
				pstmt.setInt(2, (currentShowPageNo*sizePerPage) - (sizePerPage-1) );
				pstmt.setInt(3, (currentShowPageNo*sizePerPage) );
				
				rs = pstmt.executeQuery();

				while (rs.next()) {
					ReviewVO review = new ReviewVO();
					
					review.setRnum(rs.getInt(1));
					review.setUserid(rs.getString(2));
					review.setPnum(rs.getInt(3));
					review.setRsubject(rs.getString(4));
					review.setRcontent(rs.getString(5));
					review.setWriteDate(rs.getString(6));
					review.setScore(rs.getInt(7));
					
					reviewList.add(review);
				}

			} finally {
				close();
			}		
			
			return reviewList;
			
		}// end of 리뷰 목록 목록 -------------------------------------------------

		
		// 버튼아이디에 따른 리스트 select 해오기
		@Override
		public List<ReviewVO> selectreviewList(Map<String, String> paraMap) throws SQLException {
			
			List<ReviewVO> reviewList = new ArrayList<>();
			
			try {

				conn = ds.getConnection();
				
				String sql = " select rnum, rsubject, fk_userid, writedate, score "+
							 " from TBL_REVIEW ";
				
				String selectid = paraMap.get("selectid");
				
				if( !("all".equals(selectid)) ) {
					// faq_category 가 선택되어질 경우의 sql 문
					sql += " where rnum = ? ";
				}
				
				pstmt = conn.prepareStatement(sql);
				
				pstmt.setString(1, selectid);
				
				rs = pstmt.executeQuery();
				
				// 복수개의 행 출력
				while(rs.next()) {
					
					ReviewVO rvo = new ReviewVO();
					
					rvo.setRnum(rs.getInt(1));
					rvo.setRsubject(rs.getString(2));
					rvo.setUserid(rs.getString(3));
					rvo.setWriteDate(rs.getString(4));
					rvo.setScore(rs.getInt(5));

					reviewList.add(rvo);
					
				} // end of while
				
			} finally {
				close();
			}

			return reviewList;
			
			
		}// end of 버튼아이디에 따른 리스트 select 해오기 --------------------------------------------------

		
		// 리뷰번호 선택시 리뷰 자세히 보기
		public ReviewVO rnumReviewDetail(String rnum) throws SQLException {
			
			ReviewVO rvo = null;

			try {
				conn = ds.getConnection();

				String sql = " select rsubject, rcontent, score "+
							 " from TBL_REVIEW "+
							 " where rnum = ? ";

				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, rnum);
				
				rs = pstmt.executeQuery();

				if (rs.next()) {
					rvo = new ReviewVO();
					
					rvo.setRsubject(rs.getString(1));
					rvo.setRcontent(rs.getString(2));
					rvo.setScore(rs.getInt(3));

				}

			} finally {
				close();
			}

			return rvo;
			
		}// end of 리뷰번호 선택시 리뷰 자세히 보기 -------------------------
	
	
}
