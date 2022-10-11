package pca.shop.model;

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
	
	// 총 페이지수 계산
	@Override
	public int getTotalPage(Map<String, String> paraMap) throws SQLException {

		int totalPage = 0;
		
		try {
			conn = ds.getConnection();
			
			String orderstatus = paraMap.get("odrstatus");
			
			String sql;
			
			switch (orderstatus) {
			case "1":
				// 배송대기&&취소x
				sql = "select ceil(count(*)/?) from tbl_order a where not exists "
						+ " (select '1' from tbl_order_detail b where a.odrcode = b.fk_odrcode and cancel = 0) "
						+ " and odrstatus = " +orderstatus;
				break;
				
			case "2":
				// 배송중
				sql = "select ceil(count(*)/?) from tbl_order where odrstatus = " +orderstatus;
				break;
				
			case "3":
				// 주문종결&&환불x || 주문종결&&환불o || 주문종결&&주문취소
				sql = "select ceil(count(*)/?) from tbl_order a where exists "
						+ " (select '1' from tbl_order_detail b where a.odrcode = b.fk_odrcode and refund = 0 or refund = 1 or cancel = 1) "
						+ " and odrstatus = " +orderstatus;
				break;
			default:
				// 환불요청
				sql = "select ceil(count(*)/?) from tbl_order a where exists "
						+ "(select '1' from tbl_order_detail b where a.odrcode = b.fk_odrcode and refund = -1) ";
				break;
			}
			String colname = paraMap.get("searchType");
			String searchWord = paraMap.get("searchWord");
			
			// 검색어가 있다면
			if(!searchWord.trim().isEmpty()) {
				
				sql += " and " + colname + " like '%' || ? || '%'";
			}
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1,Integer.parseInt(paraMap.get("sizePerPage")));
			
			// 검색어가 있다면
			if(!searchWord.trim().isEmpty()) {
				pstmt.setString(2, searchWord);
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
			
			String orderstatus = paraMap.get("odrstatus");
			
			String sql = "select odrcode, fk_userid, odrdate, odrtotalprice, odrstatus, fk_pnum, oprice, pname, refund, cancel "+
					 " from (select rownum as rno, odrcode, fk_userid, odrdate, odrtotalprice, odrstatus, fk_pnum, oprice, pname, refund, cancel "+
					 " from (select odrcode, fk_userid, odrdate, odrtotalprice, odrstatus, fk_pnum, oprice, pname, refund, cancel "+
					 " from (select odrcode, fk_userid, odrdate, odrtotalprice, odrstatus, fk_pnum, oprice, refund, cancel "+
					 " from tbl_order join tbl_order_detail";
			
			switch (orderstatus) {
			case "1":
				// 배송대기&&취소x
				sql += " on odrcode = fk_odrcode where cancel = 0 and odrstatus = " + orderstatus +")"
						+ " join tbl_product on pnum = fk_pnum";
				break;
				
			case "2":
				// 배송중
				sql += " on odrcode = fk_odrcode where odrstatus = " + orderstatus +")"
						+ " join tbl_product on pnum = fk_pnum";
				break;
				
			case "3":
				// 주문종결&&환불x || 주문종결&&환불o || 주문종결&&주문취소
				sql += " on odrcode = fk_odrcode where (refund = 0 or refund = 1 or cancel = 1) and odrstatus = " + orderstatus +")"
						+ " join tbl_product on pnum = fk_pnum";
				break;
			default:
				// 환불요청
				sql += " on odrcode = fk_odrcode where refund = -1)"
						+ " join tbl_product on pnum = fk_pnum";
				break;
			}
			
			String colname = paraMap.get("searchType");
			String searchWord = paraMap.get("searchWord");
		
			// 검색어가 있다면
			if(searchWord != null && !searchWord.trim().isEmpty()) {
				sql += " and " + colname + " like '%' || ? || '%' ";
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
				pstmt.setString(1, searchWord);
				pstmt.setInt(2, (currentShowPageNo * sizePerPage) - (sizePerPage - 1));
				pstmt.setInt(3, (currentShowPageNo * sizePerPage));
			} else { // 검색어가 없다면
				pstmt.setInt(1, (currentShowPageNo * sizePerPage) - (sizePerPage - 1));
				pstmt.setInt(2, (currentShowPageNo * sizePerPage));
			}
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				OrderVO ovo = new OrderVO(rs.getString(1), rs.getString(2), rs.getString(3).substring(0, 10), 
						rs.getInt(4), rs.getInt(5));
				
				OrderDetailVO odvo = new OrderDetailVO();
				odvo.setFk_pnum(rs.getInt(6));
				odvo.setOprice(rs.getInt(7));
				odvo.setRefund(rs.getInt(9));
				odvo.setCancel(rs.getInt(10));
				
				ProductVO pvo = new ProductVO();
				pvo.setPname(rs.getString(8));
				odvo.setPvo(pvo);
				
				ovo.setOdvo(odvo);
				
				orderList.add(ovo);
			}
			
		} finally {
			close();
		}
		
		return orderList;
		
	}

	// 주문 상세정보 가져오기
	@Override
	public OrderVO getOrderDetail(String odrcode) throws SQLException {
		
		OrderVO ovo = null;
		
		try {
			conn = ds.getConnection();
			
			// 주문정보 가져오기
			String sql = "select odrcode, fk_userid, odrdate, recipient_name, recipient_mobile, recipient_postcode, "
					+ "recipient_address, recipient_detail_address, recipient_extra_address, "
					+ "odrtotalprice, odrtotalpoint, delivery_cost, odrstatus, delivery_date, "
					+ "name, mobile, email "
					+ "from tbl_order join tbl_member "
					+ "on fk_userid = userid "
					+ "where odrcode = ?";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, odrcode);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				
				ovo = new OrderVO(rs.getString(1), rs.getString(2), rs.getString(3), 
						rs.getString(4), aes.decrypt(rs.getString(5)), rs.getString(6), rs.getString(7), rs.getString(8), rs.getString(9)
						, rs.getInt(10), rs.getInt(11), rs.getInt(12), rs.getInt(13), rs.getString(14));
				
				MemberVO mvo = new MemberVO();
				mvo.setName(rs.getString(15));
				mvo.setMobile(aes.decrypt(rs.getString(16)));
				mvo.setEmail(aes.decrypt(rs.getString(16)));
				
				ovo.setMvo(mvo);
			}
			
		} catch (UnsupportedEncodingException | GeneralSecurityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			close();
		}
		
		return ovo;
	}

	// 주문 상품 목록 가져오기
	@Override
	public List<OrderDetailVO> getOrderPrdDetail(String odrcode) throws SQLException {
		List<OrderDetailVO> orderPrdList = new ArrayList<>();

		try {
			conn = ds.getConnection();

			String sql = "select odnum, fk_odrcode, fk_pnum, oqty, oprice, opoint, refund, cancel, refund_reason, cancel_reason, pname\n"+
					"from tbl_order_detail join tbl_product\n"+
					"on fk_pnum = pnum\n"+
					"where fk_odrcode = ?";

			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, odrcode);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				OrderDetailVO odvo = new OrderDetailVO();
				odvo = new OrderDetailVO(rs.getInt(1), rs.getString(2), rs.getInt(3), 
						rs.getInt(4), rs.getInt(5), rs.getInt(6), rs.getInt(7), rs.getInt(8), rs.getString(9), rs.getString(10));
				
				ProductVO pvo = new ProductVO();
				pvo.setPname(rs.getString(11));
				odvo.setPvo(pvo);
				
				orderPrdList.add(odvo);
			}

		} finally {
			close();
		}

		return orderPrdList;
	}

}
