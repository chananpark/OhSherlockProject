package syj.shop.model;

import java.io.UnsupportedEncodingException;
import java.security.GeneralSecurityException;
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

import common.model.InquiryVO;
import common.model.MemberVO;
import common.model.OrderDetailVO;
import common.model.OrderVO;
import common.model.ProductVO;
import util.security.AES256;
import util.security.SecretMyKey;

public class OrderDAO implements InterOrderDAO {

	private DataSource ds;  // DataSource ds 는 아파치톰캣이 제공하는 DBCP(DB Connection Pool) 이다.  
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	private AES256 aes;
	
	// 생성자
	public OrderDAO() {
		
		try {
			Context initContext = new InitialContext();
		    Context envContext  = (Context)initContext.lookup("java:/comp/env");
		    ds = (DataSource)envContext.lookup("jdbc/myprjoracle");
		    
		    aes = new AES256(SecretMyKey.KEY);
		    
		} catch(NamingException e) {
			e.printStackTrace();
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
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

	// 주문 내역 조회하기
	@Override
	public List<OrderVO> mypageOrderList(String userid)  throws SQLException {
		List<OrderVO> orderList = new ArrayList<>();
		try {
			
			conn = ds.getConnection();

			String sql = "select odrcode, fk_userid, to_char(ODRDATE,'yyyy.MM.dd') as odrdate, odrtotalprice \n"+
						"from tbl_order\n"+
						"where (ODRDATE between add_months(sysdate,-1) and sysdate) and FK_USERID = ? \n"+
						"order by ODRDATE desc";

			pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, userid);
	        rs = pstmt.executeQuery();
	        
	        while (rs.next()) {
	        	OrderVO ovo = new OrderVO();
	            
	        	ovo.setOdrcode(rs.getString("odrcode"));
	        	ovo.setFk_userid(rs.getString("fk_userid"));
	        	ovo.setOdrdate(rs.getString("odrdate"));
	        	ovo.setOdrtotalprice(rs.getInt("odrtotalprice"));
	            
	            orderList.add(ovo);
	        }
	        
		} finally {
	        close();
	    }
		
		return orderList;
	}
	
	
	
	

}
