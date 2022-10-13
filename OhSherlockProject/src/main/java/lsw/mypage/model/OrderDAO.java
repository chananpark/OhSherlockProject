package lsw.mypage.model;

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


	
	// 특정 회원 주문목록 총 페이지 가지고 오기
	@Override
	public int getTotalMyOrderPage(Map<String, String> paraMap) throws SQLException {
		
		int totalPage = 0;
		
		try {
			conn = ds.getConnection();
			
			String sql = " select ceil(count(*)/5) "+
						" from tbl_order join tbl_order_detail "+
						" on odrcode = fk_odrcode "+
						" where fk_userid = ? and odrdate between ? and ? ";
			
						
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1,paraMap.get("loginuser"));
			pstmt.setString(2,paraMap.get("startDate"));
			pstmt.setString(3,paraMap.get("endDate"));
			
			rs = pstmt.executeQuery();
			rs.next();
			totalPage = rs.getInt(1);
			
		} finally {
			close();
		}

		return totalPage;
	}// end of public int getTotalMyOrderPage(Map<String, String> paraMap) throws SQLException

	
	
	// 특정 회원 주문목록 가지고 오기 
	@Override
	public List<OrderVO> selectMyOrder(Map<String, String> paraMap) throws SQLException {
		List<OrderVO> orderList = new ArrayList<>();
		
		try {
			conn = ds.getConnection();
			
			String sql = "select odnum, fk_pnum, oqty, oprice, fk_userid, odrdate, pname, pimage, odrcode, odrstatus "+
						" from "+
						" ( "+
						" select rownum as rno, odnum, fk_pnum, oqty, oprice, fk_userid, odrdate, pname, pimage, odrcode, odrstatus "+
						" from "+
						" ( "+
						" select odnum, fk_pnum, oqty, oprice, fk_userid, odrdate, pname, pimage, odrcode, odrstatus "+
						" from  "+
						" ( "+
						" select fk_userid, odrdate, odnum, fk_pnum, oqty, oprice, odrcode, odrstatus "+
						" from tbl_order join tbl_order_detail "+
						" on odrcode = fk_odrcode   "+
						" where fk_userid = ? and odrdate between ? and to_date(? ||' 23:59:59', 'yyyy-mm-dd hh24:mi:ss') "+
						  
						" ) v "+
						" join tbl_product  "+
						" on pnum = fk_pnum "+
						" order by odrdate desc) C "+
						" ) T "+
						" where rno between ? and ? ";
			
			// 조회하고자 하는 페이지 번호
			int currentShowPageNo = Integer.parseInt(paraMap.get("currentShowPageNo"));
			
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, paraMap.get("loginuser"));
			pstmt.setString(2,paraMap.get("startDate"));
			pstmt.setString(3,paraMap.get("endDate"));
			pstmt.setInt(4, (currentShowPageNo * 5) - (5 - 1));
			pstmt.setInt(5, (currentShowPageNo * 5));
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				
				OrderVO ovo = new OrderVO();
				ovo.setFk_userid(rs.getString("fk_userid"));
				ovo.setOdrdate(rs.getString("odrdate").substring(0, 10));
				ovo.setOdrcode(rs.getString("odrcode"));
				ovo.setOdrstatus(rs.getInt("odrstatus"));
				
				OrderDetailVO odvo = new OrderDetailVO();
				odvo.setOdnum(rs.getInt("odnum"));
				odvo.setFk_pnum(rs.getInt("fk_pnum"));
				odvo.setOqty(rs.getInt("oqty"));
				odvo.setOprice(rs.getInt("oprice"));
				
				ProductVO pvo = new ProductVO();
				pvo.setPname(rs.getString("pname"));
				pvo.setPimage(rs.getString("pimage"));
				odvo.setPvo(pvo);
				
				ovo.setOdvo(odvo);
				
				orderList.add(ovo);
			}
			
		} finally {
			close();
		}
		
		return orderList;
		
	}// end of public List<OrderVO> selectMyOrder(Map<String, String> paraMap) throws SQLException-----

	
	// 주문 상세정보 출력하는 메소드 
	@Override
	public List<OrderVO> selectMyOrderDetail(Map<String, String> paraMap) throws SQLException {
		List<OrderVO> orderList = new ArrayList<>();
		
		try {
			conn = ds.getConnection();
		
			
			String sql = "select odnum, fk_pnum, oqty, oprice, fk_userid, odrdate, pname, pimage, odrcode "+
						"from  "+
						"( "+
						"select fk_userid, substr(odrdate,0,10) odrdate , odnum, fk_pnum, oqty, oprice, odrcode "+
						"from tbl_order join tbl_order_detail "+
						"on odrcode = fk_odrcode   "+
						"where fk_userid = ? and odrcode = ? "+
						") v "+
						"join tbl_product  "+
						"on pnum = fk_pnum";
	
		pstmt = conn.prepareStatement(sql);
		
		pstmt.setString(1, paraMap.get("loginuser"));
		pstmt.setString(2, paraMap.get("odrcode"));
		
		rs = pstmt.executeQuery();
		
		while(rs.next()) {

			OrderVO ovo = new OrderVO();
			ovo.setFk_userid(rs.getString("fk_userid"));
			ovo.setOdrdate(rs.getString("odrdate").substring(0, 10));
			ovo.setOdrcode(rs.getString("odrcode"));
			
			OrderDetailVO odvo = new OrderDetailVO();
			odvo.setOdnum(rs.getInt("odnum"));
			odvo.setFk_pnum(rs.getInt("fk_pnum"));
			odvo.setOqty(rs.getInt("oqty"));
			odvo.setOprice(rs.getInt("oprice"));
			
			ProductVO pvo = new ProductVO();
			pvo.setPname(rs.getString("pname"));
			pvo.setPimage(rs.getString("pimage"));
			odvo.setPvo(pvo);
			
			ovo.setOdvo(odvo);
			
			orderList.add(ovo);
		}
			
		} finally {
			close();
		}
		
		return orderList;

	}// end of public List<OrderVO> selectMyOrderDetail(Map<String, String> paraMap) throws SQLException-----

	
	
	// 주문상세정보에서 상품리스트 출력하는 메소드
	@Override
	public List<OrderVO> selectOneOrder(Map<String, String> paraMap) throws SQLException {
	
		List<OrderVO> orderList = new ArrayList<>();
		
		try {
			conn = ds.getConnection();
		
			
			String sql = " select fk_userid, odrdate, recipient_name, recipient_mobile, recipient_postcode, recipient_address, recipient_detail_address, recipient_extra_address, odrtotalprice, delivery_cost, odrstatus, odrcode, "+
						"        odnum, fk_pnum, oqty, oprice, pname, pimage "+
						" from  "+
						" ( "+
						" select fk_userid, odrdate, recipient_name, recipient_mobile, recipient_postcode, recipient_address, recipient_detail_address, recipient_extra_address, odrtotalprice, delivery_cost, odrstatus, odrcode, "+
						"		odnum, fk_pnum, oqty, oprice "+
						" from tbl_order join tbl_order_detail "+
						" on odrcode = fk_odrcode   "+
						" where fk_userid = ? and odrcode = ? "+
						" ) v "+
						" join tbl_product  "+
						" on pnum = fk_pnum "+
						" order by odrdate desc ";
	
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, paraMap.get("loginuser"));
			pstmt.setString(2, paraMap.get("odrcode"));
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				
				OrderVO ovo = new OrderVO();
				ovo.setFk_userid(rs.getString("fk_userid"));
				ovo.setOdrdate(rs.getString("odrdate").substring(0, 10));
				ovo.setRecipient_name(rs.getString("recipient_name"));
				ovo.setRecipient_mobile(rs.getString("recipient_mobile"));
				ovo.setRecipient_postcode(rs.getString("recipient_postcode"));
				ovo.setRecipient_address(rs.getString("recipient_address"));
				ovo.setRecipient_detail_address(rs.getString("recipient_detail_address"));
				ovo.setRecipient_extra_address(rs.getString("recipient_extra_address"));
				ovo.setOdrtotalprice(rs.getInt("odrtotalprice"));
				ovo.setDelivery_cost(rs.getInt("delivery_cost"));
				ovo.setOdrstatus(rs.getInt("odrstatus"));
				ovo.setOdrcode(rs.getString("odrcode"));
				
				OrderDetailVO odvo = new OrderDetailVO();
				odvo.setOdnum(rs.getInt("odnum"));
				odvo.setFk_pnum(rs.getInt("fk_pnum"));
				odvo.setOqty(rs.getInt("oqty"));
				odvo.setOprice(rs.getInt("oprice"));
				
				
				ProductVO pvo = new ProductVO();
				pvo.setPname(rs.getString("pname"));
				pvo.setPimage(rs.getString("pimage"));
				odvo.setPvo(pvo);
				
				ovo.setOdvo(odvo);
				
				orderList.add(ovo);
			}
				
			} finally {
				close();
			}
			
			return orderList;
	}// end of public List<OrderVO> selectOneOrder(Map<String, String> paraMap) throws SQLException--------------

	
	// 주문상세정보에서 배송지 출력하는 메소드
	@Override
	public OrderVO getOrderDetail(String odrcode) throws SQLException {
		
		OrderVO ovo = null;
		
		try {
			conn = ds.getConnection();
			
			String sql = " select odrcode, fk_userid, odrdate, recipient_name, recipient_mobile, recipient_postcode, recipient_address, recipient_detail_address, recipient_extra_address, odrtotalprice, delivery_cost, odrstatus, nvl(recipient_memo, '(배송메모 없음)') recipient_memo "+
						 " from tbl_order "+
						 " where odrcode = ? ";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1,odrcode);
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				ovo = new OrderVO();
				
				ovo.setOdrcode(rs.getString("odrcode"));
				ovo.setFk_userid(rs.getString("fk_userid"));
				ovo.setOdrdate(rs.getString("odrdate"));
				ovo.setRecipient_name(rs.getString("recipient_name"));
				ovo.setRecipient_mobile(aes.decrypt(rs.getString("recipient_mobile")));
				ovo.setRecipient_postcode(rs.getString("recipient_postcode"));
				ovo.setRecipient_address(rs.getString("recipient_address"));
				ovo.setRecipient_detail_address(rs.getString("recipient_detail_address"));
				ovo.setRecipient_extra_address(rs.getString("recipient_extra_address"));
				ovo.setOdrtotalprice(rs.getInt("odrtotalprice"));
				ovo.setDelivery_cost(rs.getInt("delivery_cost"));
				ovo.setOdrstatus(rs.getInt("odrstatus"));
				ovo.setRecipient_memo(rs.getString("recipient_memo"));
				
			}
			
		} catch (UnsupportedEncodingException | GeneralSecurityException e) {
			e.printStackTrace();
		} finally {
			close();
		}

		return ovo;
	}// end of public OrderVO getOrderDetail(String odrcode) throws SQLException 

	

}
