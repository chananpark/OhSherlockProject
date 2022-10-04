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

	
	
	// 페이지바 처리를 위한 이벤트 상품에 대한 총 페이지 알아오기
	@Override
	public int getTotalPage() throws SQLException {
		int totalPage = 0; // 기본값이 null 이 나올 수가 없다. 변수에 null 을 넣어주지 않았기 때문에.
		
		try {

			conn = ds.getConnection();
			
			String sql = " select ceil(count(*)/6) "+ // 10이 sizeperpage 이다. ceil로 올림해주기
						 " from tbl_product "+
						 " where saleprice != price ";
			
			pstmt = conn.prepareStatement(sql);
			
			rs = pstmt.executeQuery();
			rs.next();
			
			totalPage = rs.getInt(1);
			
		} finally {
			close();
		}
		
		return totalPage;
	} // end of public int getTotalPage() throws SQLException

	
	// 이벤트 상품에 따른 제품들을 페이지바를 사용한 페이징처리 처리하여 조회(select)해오기
	@Override
	public List<ProductVO> selectPagingProdByEvent(Map<String, String> paraMap) throws SQLException {
		
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
					"                (select distinct count(FK_ONUM) from tbl_order_detail where FK_PNUM=pnum) as orederCnt,\n"+
					"                (select count(RNUM) from tbl_review where FK_PNUM=pnum) as reviewCnt\n"+
					"        FROM\n"+
					"            (SELECT\n"+
					"                pnum, pname, pimage, PRDMANUAL_SYSTEMFILENAME, PRDMANUAL_ORGINFILENAME,\n"+
					"                pqty, price, saleprice, pcontent, PSUMMARY, point,\n"+
					"                to_char(pinputdate, 'yyyy-mm-dd') AS pinputdate, fk_cnum, fk_snum\n"+
					"            FROM tbl_product\n"+
					"            WHERE saleprice != price \n" +
					"            ORDER BY pnum DESC) p\n"+
					"            JOIN tbl_category  c ON p.fk_cnum = c.cnum\n"+
					"            LEFT OUTER JOIN tbl_spec s\n"+
					"            ON p.fk_snum = s.snum)V\n"+
					"    ) t\n"+
					"WHERE t.rno BETWEEN ? AND ?";
			
//			=== 페이징처리의 공식 ===
//		    where RNO between (조회하고자 하는 페이지 번호 * 한페이지당 보여줄 행의 개수) - (한페이지당 보여줄 행의 개수 -1) 
//		                  and (조회하고자 하는 페이지 번호 * 한페이지당 보여줄 행의 개수);

			int currentShowPageNo = Integer.parseInt(paraMap.get("currentShowPageNo"));  // 조회하고자 하는 페이지 번호
			int sizePerPage = 6; // 한페이지당 화면상에 보여줄 제품의 개수는 10으로 고정한다.
			
			pstmt = conn.prepareStatement(sql);
		
			// 페이징 처리 공식
			// 검색어가 없는 경우의 위치홀더 값
			pstmt.setInt(1, (currentShowPageNo*sizePerPage) - (sizePerPage-1) );
			pstmt.setInt(2, (currentShowPageNo*sizePerPage) );
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				
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
				
			} // end of while
			
		} finally {
			close();
		}
		
		return productList;
	
	} // end of public List<ProductVO> selectPagingProdByEvent(Map<String, String> paraMap) throws SQLException

	
	// 단품 카테고리 리스트 불러오기
	@Override
	public List<HashMap<String, String>> getProdCategoryList() throws SQLException {

		List<HashMap<String, String>> categoryList = new ArrayList<>(); // 기본값이 null 이 나올 수가 없다. 변수에 null 을 넣어주지 않았기 때문에.
		
		try {

			conn = ds.getConnection();
			
			String sql = "select cnum, code, cname\n"+
						"from tbl_category\n"+
						"where cnum between 1 and 3";
			
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
	} // end of public List<HashMap<String, String>> getProdCategoryList()

	
	// 단품-카테고리 페이지바 처리를 위한 이벤트 상품에 대한 총 페이지 알아오기
	@Override
	public int getTotalCategoryPage(Map<String, String> paraMap) throws SQLException {

		int totalPage = 0; // 기본값이 null 이 나올 수가 없다. 변수에 null 을 넣어주지 않았기 때문에.
		
		try {

			conn = ds.getConnection();
			
			String sql = " select ceil(count(*)/6) "+ // 10이 sizeperpage 이다. ceil로 올림해주기
						 " from tbl_product "+
						 " where saleprice != price and fk_cnum = ? ";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, paraMap.get("cnum"));
			
			rs = pstmt.executeQuery();
			rs.next();
			
			totalPage = rs.getInt(1);
			
		} finally {
			close();
		}
		
		return totalPage;
	
	} // end of public int getTotalCategoryPage(Map<String, String> paraMap) throws SQLException 

	
	// 단품-카테고리 이벤트 상품에 따른 제품들을 페이지바를 사용한 페이징처리 처리하여 조회(select)해오기
	@Override
	public List<ProductVO> selectProdByEventCategory(Map<String, String> paraMap) throws SQLException {

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
					"                (select distinct count(FK_ONUM) from tbl_order_detail where FK_PNUM=pnum) as orederCnt,\n"+
					"                (select count(RNUM) from tbl_review where FK_PNUM=pnum) as reviewCnt\n"+
					"        FROM\n"+
					"            (SELECT\n"+
					"                pnum, pname, pimage, PRDMANUAL_SYSTEMFILENAME, PRDMANUAL_ORGINFILENAME,\n"+
					"                pqty, price, saleprice, pcontent, PSUMMARY, point,\n"+
					"                to_char(pinputdate, 'yyyy-mm-dd') AS pinputdate, fk_cnum, fk_snum\n"+
					"            FROM tbl_product\n"+
					"            WHERE saleprice != price and fk_cnum = ? \n" +
					"            ORDER BY pnum DESC) p\n"+
					"            JOIN tbl_category  c ON p.fk_cnum = c.cnum\n"+
					"            LEFT OUTER JOIN tbl_spec s\n"+
					"            ON p.fk_snum = s.snum)V\n"+
					"    ) t\n"+
					"WHERE t.rno BETWEEN ? AND ?";
			
//			=== 페이징처리의 공식 ===
//		    where RNO between (조회하고자 하는 페이지 번호 * 한페이지당 보여줄 행의 개수) - (한페이지당 보여줄 행의 개수 -1) 
//		                  and (조회하고자 하는 페이지 번호 * 한페이지당 보여줄 행의 개수);

			int currentShowPageNo = Integer.parseInt(paraMap.get("currentShowPageNo"));  // 조회하고자 하는 페이지 번호
			int sizePerPage = 6; // 한페이지당 화면상에 보여줄 제품의 개수는 10으로 고정한다.
			
			pstmt = conn.prepareStatement(sql);
		
			// 페이징 처리 공식
			// 검색어가 없는 경우의 위치홀더 값
			pstmt.setString(1, paraMap.get("cnum"));
			pstmt.setInt(2, (currentShowPageNo*sizePerPage) - (sizePerPage-1) );
			pstmt.setInt(3, (currentShowPageNo*sizePerPage) );
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				
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
				
			} // end of while
			
		} finally {
			close();
		}
		
		return productList;
	} // end of public List<ProductVO> selectProdByEventCategory(Map<String, String> paraMap) 

	
	// 단품-베스트 페이지바 처리를 위한 이벤트 상품에 대한 총 페이지 알아오기
	@Override
	public int getTotalBestPage(Map<String, String> paraMap) throws SQLException {

		int totalPage = 0; // 기본값이 null 이 나올 수가 없다. 변수에 null 을 넣어주지 않았기 때문에.
		
		try {

			conn = ds.getConnection();
			
			String sql = " select ceil(count(*)/6) "+ // 10이 sizeperpage 이다. ceil로 올림해주기
						 " from tbl_product "+
						 " where saleprice != price and fk_snum = 2 ";
			
			pstmt = conn.prepareStatement(sql);
			
			rs = pstmt.executeQuery();
			rs.next();
			
			totalPage = rs.getInt(1);
			
		} finally {
			close();
		}
		
		return totalPage;
	} // end of public int getTotalBestPage(Map<String, String> paraMap)

	
	// 단품-베스트 이벤트 상품에 따른 제품들을 페이지바를 사용한 페이징처리 처리하여 조회(select)해오기
	@Override
	public List<ProductVO> selectProdByEventBest(Map<String, String> paraMap) throws SQLException {

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
					"                (select distinct count(FK_ONUM) from tbl_order_detail where FK_PNUM=pnum) as orederCnt,\n"+
					"                (select count(RNUM) from tbl_review where FK_PNUM=pnum) as reviewCnt\n"+
					"        FROM\n"+
					"            (SELECT\n"+
					"                pnum, pname, pimage, PRDMANUAL_SYSTEMFILENAME, PRDMANUAL_ORGINFILENAME,\n"+
					"                pqty, price, saleprice, pcontent, PSUMMARY, point,\n"+
					"                to_char(pinputdate, 'yyyy-mm-dd') AS pinputdate, fk_cnum, fk_snum\n"+
					"            FROM tbl_product\n"+
					"            WHERE saleprice != price and fk_snum = 2 \n" +
					"            ORDER BY pnum DESC) p\n"+
					"            JOIN tbl_category  c ON p.fk_cnum = c.cnum\n"+
					"            LEFT OUTER JOIN tbl_spec s\n"+
					"            ON p.fk_snum = s.snum)V\n"+
					"    ) t\n"+
					"WHERE t.rno BETWEEN ? AND ?";
			
//			=== 페이징처리의 공식 ===
//		    where RNO between (조회하고자 하는 페이지 번호 * 한페이지당 보여줄 행의 개수) - (한페이지당 보여줄 행의 개수 -1) 
//		                  and (조회하고자 하는 페이지 번호 * 한페이지당 보여줄 행의 개수);

			int currentShowPageNo = Integer.parseInt(paraMap.get("currentShowPageNo"));  // 조회하고자 하는 페이지 번호
			int sizePerPage = 6; // 한페이지당 화면상에 보여줄 제품의 개수는 10으로 고정한다.
			
			pstmt = conn.prepareStatement(sql);
		
			// 페이징 처리 공식
			// 검색어가 없는 경우의 위치홀더 값
			pstmt.setInt(1, (currentShowPageNo*sizePerPage) - (sizePerPage-1) );
			pstmt.setInt(2, (currentShowPageNo*sizePerPage) );
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				
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
				
			} // end of while
			
		} finally {
			close();
		}
		
		return productList;
	
	} // end of public List<ProductVO> selectProdByEventBest(Map<String, String> paraMap)

	

	
	
	

}
