package kcy.shop.model;

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
				
				 String sql = " select S.sname, pnum, pname, price, saleprice, point, pqty, pcontent, pimage, prdmanual_systemfilename, nvl(prdmanual_orginfilename, '없음') AS prdmanual_orginfilename "+
						      " from  "+
						      " ( "+
						      " select fk_snum, pnum, pname, price, saleprice, point, pqty, pcontent, pimage, prdmanual_systemfilename, prdmanual_orginfilename "+
						      " from tbl_product "+
						      " where pnum = ? "+
						      " ) P JOIN tbl_spec S "+
						      " ON P.fk_snum = S.SNUM "; 
				 
				 pstmt = conn.prepareStatement(sql);
				 pstmt.setString(1, pnum);
				 			 
				 rs = pstmt.executeQuery();
				 
				 if(rs.next()) {
					 
					 String sname = rs.getString(1);     // "HIT", "NEW", "BEST" 값을 가짐 
					 int    npnum = rs.getInt(2);        // 제품번호
					 String pname = rs.getString(3);     // 제품명
					 int    price = rs.getInt(4);        // 제품 정가
					 int    saleprice = rs.getInt(5);    // 제품 판매가
					 int    point = rs.getInt(6);        // 포인트 점수
					 int    pqty = rs.getInt(7);         // 제품 재고량
					 String pcontent = rs.getString(8);  // 제품설명
					 String pimage = rs.getString(9);  // 제품이미지1
					 String prdmanual_systemfilename = rs.getString(10); // 파일서버에 업로드되어지는 실제 제품설명서 파일명
					 String prdmanual_orginfilename = rs.getString(11);  // 웹클라이언트의 웹브라우저에서 파일을 업로드 할때 올리는 제품설명서 파일명 
					 
					 pvo = new ProductVO(); 
					 
					 SpecVO spvo = new SpecVO();
					 spvo.setSname(sname);
					 
					 pvo.setSpvo(spvo);
					 pvo.setPnum(npnum);
					 pvo.setPname(pname);
					 pvo.setPrice(price);
					 pvo.setSaleprice(saleprice);
					 pvo.setPoint(point);
					 pvo.setPqty(pqty);
					 pvo.setPcontent(pcontent);
					 pvo.setPimage(pimage);
					 pvo.setPrdmanual_systemfilename(prdmanual_systemfilename);
					 pvo.setPrdmanual_orginfilename(prdmanual_orginfilename); 
					 
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
	
	
}
