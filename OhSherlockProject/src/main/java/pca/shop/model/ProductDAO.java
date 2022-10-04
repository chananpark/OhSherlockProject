package pca.shop.model;

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

	// 카테고리 조회 메소드
	@Override
	public List<HashMap<String, String>> getCategoryList() throws SQLException {
	    List<HashMap<String, String>> categoryList = new ArrayList<>();

	    try {
	        conn = ds.getConnection();

	        String sql = "select cnum, code, cname\r\n"
	                + "from tbl_category\r\n"
	                + "where cnum between 4 and 6"
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
	
	// 페이징 방식 카테고리별 기프트세트 상품 총 페이지수 가져오기 메소드
	@Override
	public int getTotalPage(String cnum) throws SQLException {
		
		int totalPage = 0;

		try {
			conn = ds.getConnection();

			String sql = " select ceil( count(*)/10 ) " // 10 이 sizePerPage 이다.
					+ " from tbl_product " ;
			
			// 특정 카테고리 조회시
			if (cnum != null) {
				sql += " where fk_cnum = ? ";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, cnum);
			}
			
			// 전체 조회시
			else {
				sql += " where fk_cnum in (4,5,6) ";
				pstmt = conn.prepareStatement(sql);
			}
			rs = pstmt.executeQuery();

			rs.next();

			totalPage = rs.getInt(1);

		} finally {
			close();
		}

		return totalPage;

	}

	// 페이징 방식 카테고리별 기프트세트 상품 목록 가져오기 메소드
	@Override
	public List<ProductVO> selectSetGoodsByCategory(Map<String, String> paraMap) throws SQLException {
		List<ProductVO> productList = new ArrayList<>();

	    try {
	        conn = ds.getConnection();

	        String sql = "SELECT cname, sname, pnum, pname, pimage, \n"+
	        		"    pqty, price, saleprice, pcontent, PSUMMARY, point, pinputdate, reviewCnt, orederCnt\n"+
	        		"FROM\n"+
	        		"    (SELECT ROWNUM AS rno, cname, sname, pnum, pname, pimage, \n"+
	        		"            pqty, price, saleprice, pcontent, PSUMMARY, point, pinputdate, reviewCnt, orederCnt\n"+
	        		"    FROM\n"+
	        		"        (SELECT c.cname, s.sname, pnum, pname, pimage, \n"+
	        		"                pqty, price, saleprice, pcontent, PSUMMARY, point, pinputdate,\n"+
	        		"                (select distinct count(FK_ONUM) from tbl_order_detail where FK_PNUM=pnum) as orederCnt,\n"+
	        		"                (select count(RNUM) from tbl_review where FK_PNUM=pnum) as reviewCnt\n"+
	        		"        FROM\n"+
	        		"            (SELECT\n"+
	        		"                pnum, pname, pimage, \n"+
	        		"                pqty, price, saleprice, pcontent, PSUMMARY, point,\n"+
	        		"                to_char(pinputdate, 'yyyy-mm-dd') AS pinputdate, fk_cnum, fk_snum\n"+
	        		"            FROM tbl_product\n";
	        
	        // 특정 카테고리 조회시
	        if (paraMap.get("cnum") != null) {
	        	sql +=	"            WHERE fk_cnum = ?\n";
	        }
	        // 전체 조회시
	        else {
	        	sql +=	"            WHERE fk_cnum in (4,5,6)\n";
	        }
	        
	        	sql +=	"            ORDER BY ? DESC) p\n"+
	        		"            JOIN tbl_category  c ON p.fk_cnum = c.cnum\n"+
	        		"            LEFT OUTER JOIN tbl_spec s\n"+
	        		"            ON p.fk_snum = s.snum)V\n"+
	        		"    ) t\n"+
	        		"WHERE t.rno BETWEEN ? AND ?";
	        /*
	         === 페이징처리 공식 === 
	         where RNO between (조회하고자 하는 페이지 번호 * 한페이지당 보여줄 행의 개수) -
	         (한페이지당 보여줄 행의 개수 - 1) and (조회하고자 하는 페이지 번호 * 한페이지당 보여줄 행의 개수)
	         */

	        int currentShowPageNo = Integer.parseInt(paraMap.get("currentShowPageNo"));
	        int sizePerPage = 10;

	        pstmt = conn.prepareStatement(sql);
	        
	        // 특정 카테고리 조회시
	        if (paraMap.get("cnum") != null) {
	        pstmt.setString(1, paraMap.get("cnum"));
	        pstmt.setString(2, paraMap.get("order"));
	        pstmt.setInt(3, (currentShowPageNo * sizePerPage) - (sizePerPage - 1));
	        pstmt.setInt(4, (currentShowPageNo * sizePerPage));
	        }
	        // 전체 조회시
	        else {
		        pstmt.setString(1, paraMap.get("order"));
		        pstmt.setInt(2, (currentShowPageNo * sizePerPage) - (sizePerPage - 1));
		        pstmt.setInt(3, (currentShowPageNo * sizePerPage));
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
	        }

	    } finally {
	        close();
	    }

	    return productList;
	}


}
