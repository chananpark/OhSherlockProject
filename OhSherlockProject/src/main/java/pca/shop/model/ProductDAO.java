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
	
	// 카테고리 조회 메소드
		@Override
		public List<HashMap<String, String>> getTeaCategoryList() throws SQLException {
		    List<HashMap<String, String>> categoryList = new ArrayList<>();

		    try {
		        conn = ds.getConnection();

		        String sql = "select cnum, code, cname\r\n"
		                + "from tbl_category\r\n"
		                + "where cnum between 1 and 3"
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
				sql += " where fk_snum = ? and fk_cnum in (4,5,6) ";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, snum);
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

		        String sql = "select cname, sname, pnum, pname, pimage, \n"+
		        		"    pqty, price, saleprice, psummary, point, reviewcnt, oredercnt\n"+
		        		"from\n"+
		        		"    (select rownum as rno, cname, sname, pnum, pname, pimage, \n"+
		        		"            pqty, price, saleprice, psummary, point, reviewcnt, oredercnt\n"+
		        		"    from\n"+
		        		"        (select c.cname, s.sname, pnum, pname, pimage, \n"+
		        		"                pqty, price, saleprice, psummary, point,\n"+
		        		"                oredercnt,reviewcnt\n"+
		        		"        from\n"+
		        		"            (select\n"+
		        		"                pnum, pname, pimage, \n"+
		        		"                pqty, price, saleprice, psummary, point,\n"+
		        		"                fk_cnum, fk_snum,\n"+
		        		"                (select sum(oqty) from tbl_order_detail where fk_pnum = pnum) as ordercnt,\n"+
		        		"                (select count(rnum) from tbl_review where fk_pnum = pnum) as reviewcnt\n"+
		        		"            from tbl_product\n";
		        
			    // 특정 카테고리 조회시
		        if (!"".equals(paraMap.get("cnum"))) {
		        	sql +=	"            WHERE fk_cnum = ?\n";
		        }
		        
		        // 특정 스펙 조회시
		        else if (!"".equals(paraMap.get("snum"))) {
		        	sql +=	"            WHERE fk_snum = ? and fk_cnum in (4,5,6)\n";
		        }
		        
		        // 전체 조회시
		        else {
		        	sql +=	"            WHERE fk_cnum in (4,5,6)\n";
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

		            pvo.setPsummary(rs.getString("psummary"));
		            pvo.setPoint(rs.getInt("point"));
		            pvo.setReviewCnt(rs.getInt("reviewCnt"));
		            pvo.setOrderCnt(rs.getInt("orderCnt"));

		            productList.add(pvo);
		        }

		    } finally {
		        close();
		    }

		    return productList;
		}

		// 검색결과 총 페이지수
		@Override
		public int getSearchedTotalPage(Map<String, String> paraMap) throws SQLException{
			int totalPage = 0;
			String searchWord = paraMap.get("searchWord");
			String cnum = paraMap.get("cnum");

			try {
				conn = ds.getConnection();

				String sql = " select ceil( count(*)/6 ) "
						+ " from tbl_product "
						+ " where pname like '%' || ? || '%' " ;
				
				// 특정 카테고리 조회시
				if (!"".equals(cnum) && Character.isDigit(cnum.charAt(0))) {
					sql += " and fk_cnum = ? ";
				}
				else if ("teaAll".equals(cnum)) {
					sql += " and fk_cnum in (1,2,3) ";
				}
				else if ("setAll".equals(cnum)) {
					sql += " and fk_cnum in (4,5,6) ";
				}
				
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, searchWord);
				
				// 특정 카테고리 조회시
				if (!"".equals(cnum) && Character.isDigit(cnum.charAt(0))) {
					pstmt.setString(2, cnum);
				}

				rs = pstmt.executeQuery();
				rs.next();
				totalPage = rs.getInt(1);
				
			} finally {
				close();
			}

			return totalPage;
		}
		
		// 검색 상품 개수
		public int countSearchedGoods(Map<String, String> paraMap) throws SQLException{
			int n = 0;
			String searchWord = paraMap.get("searchWord");
			String cnum = paraMap.get("cnum");
			
			try {
				conn = ds.getConnection();

				String sql = " select count(*) "
						+ " from tbl_product "
						+ " where pname like '%' || ? || '%' " ;
				
				// 특정 카테고리 조회시
				if (!"".equals(cnum) && Character.isDigit(cnum.charAt(0))) {
					sql += " and fk_cnum = ? ";
				}
				// 티단품 조회시
				else if ("teaAll".equals(cnum)) {
					sql += " and fk_cnum in (1,2,3) ";
				}
				// 세트상품 조회시
				else if ("setAll".equals(cnum)) {
					sql += " and fk_cnum in (4,5,6) ";
				}
				
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, searchWord);
				
				// 특정 카테고리 조회시
				if (!"".equals(cnum) && Character.isDigit(cnum.charAt(0))) {
					pstmt.setString(2, cnum);
				}

				rs = pstmt.executeQuery();
				rs.next();
				n = rs.getInt(1);
				
			} finally {
				close();
			}

			return n;
		}
		
		// 검색어로 상품 목록 가져오기
		@Override
		public List<ProductVO> selectSearchedGoods(Map<String, String> paraMap) throws SQLException {
			List<ProductVO> productList = new ArrayList<>();
			String searchWord = paraMap.get("searchWord");
			String cnum = paraMap.get("cnum");
			String order = paraMap.get("order");
			int currentShowPageNo = Integer.parseInt(paraMap.get("currentShowPageNo"));
			
		    try {
		        conn = ds.getConnection();

		        String sql = "select cname, sname, pnum, pname, pimage, \n"+
		        		"    pqty, price, saleprice, reviewcnt, oredercnt\n"+
		        		"from\n"+
		        		"    (select rownum as rno, cname, sname, pnum, pname, pimage, \n"+
		        		"            pqty, price, saleprice, reviewcnt, oredercnt\n"+
		        		"    from\n"+
		        		"        (select c.cname, s.sname, pnum, pname, pimage, \n"+
		        		"                pqty, price, saleprice, reviewcnt, oredercnt\n"+
		        		"        from\n"+
		        		"            (select\n"+
		        		"                pnum, pname, pimage, \n"+
		        		"                pqty, price, saleprice, \n"+
		        		"                fk_cnum, fk_snum,\n"+
		        		"                (select sum(oqty) from tbl_order_detail where fk_pnum = pnum) as ordercnt,\n"+
		        		"                (select count(rnum) from tbl_review where fk_pnum=pnum) as reviewcnt\n"+
		        		"            from tbl_product\n"+
		        		"			 where pname like '%' || ? || '%' ";
		        
			    // 특정 카테고리 조회시
		        if (!"".equals(cnum) && Character.isDigit(cnum.charAt(0))) {
		        	sql +=	"            and fk_cnum = ?\n";
		        }
		        // 티단품 조회시
		        else if ("teaAll".equals(cnum)) {
					sql += " and fk_cnum in (1,2,3) ";
				}
		        // 세트상품 조회시
				else if ("setAll".equals(cnum)) {
					sql += " and fk_cnum in (4,5,6) ";
				}
	        
		        sql += "            ) p\n"+
	        		"            JOIN tbl_category  c ON p.fk_cnum = c.cnum\n"+
	        		"            LEFT OUTER JOIN tbl_spec s\n"+
	        		"            ON p.fk_snum = s.snum "+
	        		"			 ORDER BY " + order +")V\n"+
	        		"    ) t\n"+
	        		"WHERE t.rno BETWEEN ? AND ?\n";
		        
		        int sizePerPage = 6;

		        pstmt = conn.prepareStatement(sql);
		        
		        // 특정 카테고리 조회시
		        if (!"".equals(cnum) && Character.isDigit(cnum.charAt(0))) {
		        pstmt.setString(1, searchWord);
		        pstmt.setString(2, cnum);
		        pstmt.setInt(3, (currentShowPageNo * sizePerPage) - (sizePerPage - 1));
		        pstmt.setInt(4, (currentShowPageNo * sizePerPage));
		        }
		        // 전체 조회시
		        else {
		        	pstmt.setString(1, searchWord);
			        pstmt.setInt(2, (currentShowPageNo * sizePerPage) - (sizePerPage - 1));
			        pstmt.setInt(3, (currentShowPageNo * sizePerPage));
		        }
		        
		        rs = pstmt.executeQuery();

		        while (rs.next()) {
		            ProductVO pvo = new ProductVO();
		            pvo.setPnum(rs.getInt("pnum")); // 제품번호
		            pvo.setPname(rs.getString("pname")); // 제품명

		            CategoryVO categvo = new CategoryVO();
		            categvo.setCname(rs.getString("cname")); // 카테고리 이름
		            pvo.setCategvo(categvo);

		            pvo.setPimage(rs.getString("pimage")); // 제품 이미지 파일명
		            pvo.setPqty(rs.getInt("pqty")); // 제품 재고량
		            pvo.setPrice(rs.getInt("price")); // 제품 정가
		            pvo.setSaleprice(rs.getInt("saleprice")); // 제품 판매가

		            SpecVO spvo = new SpecVO();
		            spvo.setSname(rs.getString("sname"));
		            pvo.setSpvo(spvo);

		            pvo.setReviewCnt(rs.getInt("reviewCnt"));
		            pvo.setOrderCnt(rs.getInt("orderCnt"));

		            productList.add(pvo);
		        }

		    } finally {
		        close();
		    }

		    return productList;
		}

		// 메인에 표시할 상품 4개
		@Override
		public List<ProductVO> selectTodayProducts() {

			List<ProductVO> todayProductList = new ArrayList<>();
			try {
				
				conn = ds.getConnection();

		        String sql = "SELECT rownum, pnum, pname, pimage, price, saleprice from "
		        		+ "(SELECT pnum, pname, pimage, price, saleprice FROM tbl_product ORDER BY pnum desc)"
		        		+ "where rownum between 1 and 4";
		        pstmt = conn.prepareStatement(sql);
		        rs = pstmt.executeQuery();
		        
		        while (rs.next()) {
		            ProductVO pvo = new ProductVO();
		            pvo.setPnum(rs.getInt("pnum")); // 제품번호
		            pvo.setPname(rs.getString("pname")); // 제품명

		            pvo.setPimage(rs.getString("pimage")); // 제품 이미지 파일명
		            pvo.setPrice(rs.getInt("price")); // 제품 정가
		            pvo.setSaleprice(rs.getInt("saleprice")); // 제품 판매가

		            todayProductList.add(pvo);
		        }
			} catch(SQLException e) {
				e.printStackTrace();
			}finally {
		        close();
		    }
			
			return todayProductList;
		}

		// 주문번호 시퀀스 채번
		@Override
		public int getSeq_tbl_order() throws SQLException {
			int seq = 0;

		    try {
		        conn = ds.getConnection();

		        String sql = " select seq_tbl_order.nextval as seq "
		                   + " from dual ";

		        pstmt = conn.prepareStatement(sql);

		        rs = pstmt.executeQuery();

		        rs.next();

		        seq = rs.getInt("seq");

		    } finally {
		        close();
		    }

		    return seq;
		}

		@Override
		public List<ProductVO> getJumunProductList(String pnumjoin) throws SQLException {
			List<ProductVO> jumunProductList = new ArrayList<>();
		      
		       try {
		           conn = ds.getConnection();
		         
		           String[] pnumArr = pnumjoin.split("\\,"); 
		           pnumjoin = String.join("','", pnumArr);   
		           pnumjoin = "'"+pnumjoin+"'";            
		          
		           String sql = " select pnum, pname, saleprice, pimage"
		                    + " from tbl_product "
		                    + " where pnum in ("+pnumjoin+") "; 
		          
		           pstmt = conn.prepareStatement(sql);
		          
		           rs = pstmt.executeQuery();
		          
		           while(rs.next()) {
		             
		              ProductVO pvo = new ProductVO();
		             
		              pvo.setPnum(rs.getInt(1));       
		              pvo.setPname(rs.getString(2));  
		              pvo.setSaleprice(rs.getInt(3));   
		              pvo.setPimage(rs.getString(4)); 
		                 
		              jumunProductList.add(pvo);
		           }// end of while-----------------------------
		          
		       } finally {
		          close();
		       }
		      
		       return jumunProductList;
		}

}
