package pca.shop.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import common.model.OrderVO;

public class OrderDAO implements InterOrderDAO {

	private DataSource ds;  // DataSource ds 는 아파치톰캣이 제공하는 DBCP(DB Connection Pool) 이다.  
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	
	// 생성자
	public OrderDAO() {
		
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
	
	// 총 페이지수 계산
	@Override
	public int getTotalPage(Map<String, String> paraMap) throws SQLException {

		int totalPage = 0;
		
		try {
			conn = ds.getConnection();

			String sql = "select ceil(count(*)/?) from tbl_order where odrstatus = ? ";
			
			String colname = paraMap.get("searchType");
			String searchWord = paraMap.get("searchWord");
			
			// 검색어가 있다면
			if(!searchWord.trim().isEmpty()) {
				
				sql += " and " + colname + " like '%' || ? || '%'";
			}
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1,Integer.parseInt(paraMap.get("sizePerPage")));
			pstmt.setString(2,paraMap.get("odrstatus"));
			
			// 검색어가 있다면
			if(!searchWord.trim().isEmpty()) {
				pstmt.setString(3, searchWord);
			}
			
			rs = pstmt.executeQuery();
			rs.next();
			totalPage = rs.getInt(1);
			
		} finally {
			close();
		}
		
		return totalPage;
		
	}

	// 주문목록 가져오기
	@Override
	public List<OrderVO> showOrderList(Map<String, String> paraMap) throws SQLException {

		List<OrderVO> orderList = new ArrayList<>();
		
		try {
			conn = ds.getConnection();
			
			String sql = "select odrcode, fk_userid, odrdate, odrtotalprice, odrstatus \n"+
						 "from\n"+
						 "(select rownum as rno, odrcode, fk_userid, odrdate, odrtotalprice, odrstatus \n"+
						 "from \n"+
						 "    (select odrcode, fk_userid, odrdate, odrtotalprice, odrstatus \n"+
						 "    from tbl_order\n"+
						 "    where odrstatus = ? ";
			
			String colname = paraMap.get("searchType");
			String searchWord = paraMap.get("searchWord");
		
			// 검색어가 있다면
			if(searchWord != null && !searchWord.trim().isEmpty()) {
				sql += " and " + colname + " like '%' || ? || '%'";
			}
						 
				sql += " order by odrdate desc\n"+
						 "    )V\n"+
					 	 ")T\n"+
						 "where rno between ? and ?";
			
			// 조회하고자 하는 페이지 번호
			int currentShowPageNo = Integer.parseInt(paraMap.get("currentShowPageNo"));
			
			// 한페이지당 보여줄 행의 개수
			int sizePerPage = Integer.parseInt(paraMap.get("sizePerPage"));
			
			pstmt = conn.prepareStatement(sql);
			
			// 검색어가 있다면 
			if(!searchWord.trim().isEmpty()) {
				pstmt.setString(1, paraMap.get("odrstatus"));
				pstmt.setString(2, searchWord);
				pstmt.setInt(3, (currentShowPageNo * sizePerPage) - (sizePerPage - 1));
				pstmt.setInt(4, (currentShowPageNo * sizePerPage));
			} else { // 검색어가 없다면
				pstmt.setString(1, paraMap.get("odrstatus"));
				pstmt.setInt(2, (currentShowPageNo * sizePerPage) - (sizePerPage - 1));
				pstmt.setInt(3, (currentShowPageNo * sizePerPage));
			}
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				OrderVO ovo = new OrderVO(rs.getString(1), rs.getString(2), rs.getString(3).substring(0, 10), 
						rs.getInt(4), rs.getInt(5));
				orderList.add(ovo);
			}
			
		} finally {
			close();
		}
		
		return orderList;
		
	}

}
