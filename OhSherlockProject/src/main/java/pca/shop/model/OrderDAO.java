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
			
			String sql = "select odrcode, fk_userid, odrdate, odrtotalprice, odrstatus, fk_pnum, oprice, pname, refund, cancel, odnum "+
					 " from (select rownum as rno, odrcode, fk_userid, odrdate, odrtotalprice, odrstatus, fk_pnum, oprice, pname, refund, cancel, odnum "+
					 " from (select odrcode, fk_userid, odrdate, odrtotalprice, odrstatus, fk_pnum, oprice, pname, refund, cancel, odnum "+
					 " from (select odrcode, fk_userid, odrdate, odrtotalprice, odrstatus, fk_pnum, oprice, refund, cancel, odnum "+
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
				odvo.setOdnum(rs.getInt(11));
				
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

	// 주문 발송 처리하기
	@Override
	public int sendDelivery(String odrcodes) throws SQLException {
		int n = 0;
		try {
			conn = ds.getConnection();
			
			String[] odrcodeArr = odrcodes.split("\\,");
			odrcodes = String.join("','", odrcodeArr);
			odrcodes = "'"+odrcodes+"'";
			
			String sql = "update tbl_order set odrstatus = 2 where odrcode in (" + odrcodes + ")";
			pstmt = conn.prepareStatement(sql);
			n = pstmt.executeUpdate();
			
		} finally {
			close();
		}
		return n;
	}

	// 주문 배송완료 처리하기
	@Override
	public int completeDelivery(String odrcodes) throws SQLException {
		int n = 0;
		try {
			conn = ds.getConnection();
			
			String[] odrcodeArr = odrcodes.split("\\,");
			odrcodes = String.join("','", odrcodeArr);
			odrcodes = "'"+odrcodes+"'";
			
			String sql = "update tbl_order set odrstatus = 3, delivery_date = sysdate where odrcode in (" + odrcodes + ")";
			pstmt = conn.prepareStatement(sql);
			n = pstmt.executeUpdate();
			
		} finally {
			close();
		}
		return n;
	}

	// 환불처리하기
	@Override
	public int refundOrder(Map<String, Object> paraMap) throws SQLException {
		int n = 0;
		int result = 0;
		int afterRefund = 0; // 전체 주문금액 - 환불금액
		int refundAmount = 0; // 주문자에게 환불될 금액
		int usedPoint = 0; // 결제시 사용한 적립금
		
		String[] odnumArr = (String[]) paraMap.get("odnumArr");
		String[] useridArr = (String[]) paraMap.get("useridArr");
		String[] odrcodeArr = (String[]) paraMap.get("odrcodeArr");
		String[] opriceArr = (String[]) paraMap.get("opriceArr");
		int length = odnumArr.length; 
		
		try {
			conn = ds.getConnection();
			conn.setAutoCommit(false); // 수동커밋
			String sql;
			
			for (int i = 0; i < length; i++) {
				
				// odnum에 해당하는 환불상태 컬럼 바꾸기
				sql = "update tbl_order_detail set refund = 1 where odnum = ?";
				
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, odnumArr[i]);
				n = pstmt.executeUpdate();
				
				// 예치금으로 환불
				if (n == 1) {
				
					// 환불금액 계산
					sql = "select odrtotalprice - ? from tbl_order where odrcode = ?";
					pstmt = conn.prepareStatement(sql);
					pstmt.setString(1, opriceArr[i]);
					pstmt.setString(2, odrcodeArr[i]);
					rs = pstmt.executeQuery();
					
					rs.next();
					
					afterRefund = (rs.getInt(1)); // 전체 주문금액 - 환불금액
					
					// 전체 주문금액 - 환불금액 >= 30000이라면 환불금액 - 2500(반품배송비)
					if (afterRefund >= 30000) {
						refundAmount = Integer.parseInt(opriceArr[i]) - 2500;
					}
					
					// 전체 주문금액 - 환불금액 < 30000이라면 환불금액 - 2500(반품배송비) - 2500(최초배송비)
					else {
						refundAmount = Integer.parseInt(opriceArr[i]) - 5000;
					}
					
					// 만약 결제시 적립금을 사용하여 결제하였다면 환불금에서 적립금만큼 차감

					// 적립금 사용 여부
					sql = "select odrusedpoint from tbl_order where odrcode = ?";
					pstmt = conn.prepareStatement(sql);
					pstmt.setString(1, odrcodeArr[i]);
					rs = pstmt.executeQuery();
					
					rs.next();
					
					usedPoint = rs.getInt(1);
					
					// 적립금을 사용했다면
					if (usedPoint > 0) {
						refundAmount -= usedPoint;
					}
					
					sql = "update tbl_member set coin = coin + ? where userid = ?";
					pstmt = conn.prepareStatement(sql);
					pstmt.setInt(1, refundAmount);
					pstmt.setString(2, useridArr[i]);
					n = pstmt.executeUpdate();
					
					// 예치금 내역 삽입
					if (n == 1) {
						sql = "insert into tbl_coin_history(coinno, fk_userid, coin_amount)"
								+ " values(seq_coin_history.nextval, ?, ?)";
						pstmt = conn.prepareStatement(sql);
						pstmt.setString(1, useridArr[i]);
						pstmt.setInt(2, refundAmount);
						n = pstmt.executeUpdate();
					
						// 적립금 반환/차감
						if (n==1) {
							
							// 적립금를 사용하여 결제했으면 사용된 적립금 반환
							if (usedPoint > 0) {
								// 일부 환불하는 경우
								if (afterRefund>0) {
									// 전체 주문금액
									int odrtotalprice = afterRefund + Integer.parseInt(opriceArr[i]);
									// 전체 주문금액에서 환불금액이 차지하는 비율
									float portion = (float) ((Integer.parseInt(opriceArr[i])*1.0 / odrtotalprice));
									usedPoint = (int) (usedPoint * portion);
								}
								
								sql = "update tbl_member set point = point + ? where userid = ?";
								pstmt = conn.prepareStatement(sql);
								pstmt.setInt(1, usedPoint);
								pstmt.setString(2, useridArr[i]);
								n = pstmt.executeUpdate();
								
								// 적립금 내역 삽입
								if (n==1) {
									sql = "insert into tbl_point_history(pointno, fk_userid, point_amount)"
											+ " values(seq_point_history.nextval, ?, ?)";
									pstmt = conn.prepareStatement(sql);
									pstmt.setString(1, useridArr[i]);
									pstmt.setInt(2, usedPoint);
									n = pstmt.executeUpdate();
								}
							} 
							// 적립금를 사용하여 결제하지 않았으면 적립된 적립금 수거
							else {
								int rollbackPoint = 0;
								// 일부 환불하는 경우
								if (afterRefund>0) {
									int odrtotalprice = afterRefund + Integer.parseInt(opriceArr[i]);
									// 전체 주문금액에서 환불금액이 차지하는 비율
									float portion = (float) ((Integer.parseInt(opriceArr[i])*1.0 / odrtotalprice));
									rollbackPoint = (int) (odrtotalprice * portion) / 100;
								}
								// 전체 환불하는 경우
								else {
									rollbackPoint = Integer.parseInt(opriceArr[i])/100;
								}
								
								sql = "update tbl_member set point = point - ? where userid = ?";
								pstmt = conn.prepareStatement(sql);
								pstmt.setInt(1, rollbackPoint);
								pstmt.setString(2, useridArr[i]);
								n = pstmt.executeUpdate();
								
								// 적립금 내역 삽입
								if (n==1) {
									
									rollbackPoint = (-1) * rollbackPoint ;
									
									sql = "insert into tbl_point_history(pointno, fk_userid, point_amount)"
											+ " values(seq_point_history.nextval, ?, ?)";
									pstmt = conn.prepareStatement(sql);
									pstmt.setString(1, useridArr[i]);
									pstmt.setInt(2, rollbackPoint);
									n = pstmt.executeUpdate();
									
								}
							}
							if (n==1)
								result += 1;
						}
					}
				}
			} // end of for
			
			if (result == odnumArr.length)
				conn.commit();
			
			
		} catch(SQLException e) {
			conn.rollback();
			
		} finally {
			conn.setAutoCommit(true); // 자동커밋
			close();
		}
		return result;
	}

	// 주문번호 시퀀스 채번
	@Override
	public int getSeq_tbl_order() throws SQLException {
		int seq = 0;

	    try {
	        conn = ds.getConnection();

	        String sql = " select seq_tbl_order.nextval AS seq "
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

	// 주문하기 트랜잭션
	@Override
	public int completeOrder(Map<String, Object> paraMap) throws SQLException {

		int nSuccess = 0;
		int n1=0, n2=0, n3=0, n4=0, n5=0, n6=0;

		String[] pnumArr = (String[]) paraMap.get("pnumArr"); // 제품번호
        String[] oqtyArr = (String[]) paraMap.get("oqtyArr"); // 주문량
        String[] totalPriceArr = (String[]) paraMap.get("totalPriceArr"); // 주문금액 

	    try {
	        conn = ds.getConnection();

	        conn.setAutoCommit(false); // 수동커밋

	        // tbl_order 테이블 insert
	        String sql = " insert into tbl_order(odrcode, fk_userid, recipient_name, recipient_mobile, "
	        		+ "recipient_postcode, recipient_address, recipient_detail_address, recipient_extra_address,"
	        		+ " odrtotalprice, delivery_cost, odrtotalpoint, recipient_memo)"
                   + " values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) ";

	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, (String) paraMap.get("odrcode"));
	        pstmt.setString(2, (String) paraMap.get("userid"));
	        pstmt.setString(3, (String) paraMap.get("recipient_name"));
	        pstmt.setString(4, (String) paraMap.get("recipient_mobile"));
	        pstmt.setString(5, (String) paraMap.get("recipient_postcode"));
	        pstmt.setString(6, (String) paraMap.get("recipient_address"));
	        pstmt.setString(7, (String) paraMap.get("recipient_detail_address"));
	        pstmt.setString(8, (String) paraMap.get("recipient_extra_address"));
	        pstmt.setString(9, (String) paraMap.get("sumtotalPrice"));
	        pstmt.setString(10, (String) paraMap.get("delivery_cost"));
	        pstmt.setInt(11, (int) paraMap.get("odrtotalpoint"));
	        pstmt.setString(12, (String) paraMap.get("recipient_memo"));

	        n1 = pstmt.executeUpdate();

	        // tbl_order_detail에 insert
	        if(n1 == 1) {
	        		        		            
	            int cnt = 0;
	            for(int i=0; i<pnumArr.length; i++) {
	                sql = " insert into tbl_order_detail(odnum, fk_odrcode, fk_pnum, oqty, oprice, opoint) " 
	                    + " values(seq_tbl_order_detail.nextval, ?, to_number(?), to_number(?), to_number(?), ?) ";

	                pstmt = conn.prepareStatement(sql);
	                pstmt.setString(1, (String) paraMap.get("odrcode"));
	                pstmt.setString(2, pnumArr[i]);
	                pstmt.setString(3, oqtyArr[i]);
	                pstmt.setString(4, totalPriceArr[i]);
	                
	                int opoint = 0;
	                // 적립금 사용하지 않았을 시 물건의 1% 적립
	    	        if(Integer.parseInt((String)paraMap.get("odrusedpoint")) == 0) {
	    	        	opoint = Integer.parseInt(totalPriceArr[i]) / 100;
	    	        }
	    	        
	                pstmt.setInt(5, opoint);

	                pstmt.executeUpdate();

	                cnt++;
	            }

	            if(cnt == pnumArr.length) {
	                n2 = 1;
	            }
	        }

	    //	4. 제품 테이블에서 주문량만큼 재고 감소 처리
	        if(n2 == 1) {
	            

	            int cnt = 0;
	            for(int i=0; i<pnumArr.length; i++) {
	                sql = " update tbl_product set pqty = pqty - ? "
	                    + " where pnum = ? ";

	                pstmt = conn.prepareStatement(sql);
	                pstmt.setInt(1, Integer.parseInt(oqtyArr[i]) );
	                pstmt.setString(2, pnumArr[i]);

	                pstmt.executeUpdate();
	                cnt++;
	            }

	            if(cnt == pnumArr.length) {
	                n3 = 1;
	            }
	        }
	        
	        
	    // 5. 장바구니 테이블에서 cartnojoin 값에 해당하는 행들을 삭제 
	       if(paraMap.get("cartnojoin") != null && n3==1) {
	           String cartnojoin = (String) paraMap.get("cartnojoin");

	           sql = " delete from tbl_cart"
	               + " where cartno in ("+ cartnojoin +") ";
	           // in 절은 위치홀더 사용불가 => 변수로 처리해야 함 

	           pstmt = conn.prepareStatement(sql);
	           n4 = pstmt.executeUpdate();
	       }

	       if( paraMap.get("cartnojoin") == null && n3==1 ) {
	           // 제품 상세정보 페이지에서 바로주문하기를 한 경우
	           n4 = 1;
	       }
	       
	       
	    // 예치금결제시 예치금 감소, 적립금 사용시 적립금 감소, 적립금 미사용시 적립금 증가 + 내역 테이블에 insert
	       if(n4 > 0) {
	    	   
	    	   String paymentMethod = (String)paraMap.get("paymentMethod");
	    	   
	    	  // 예치금결제시
	    	   if(paymentMethod.equals("coin")) {
	    		   sql = " update tbl_member set coin = coin - ? "
	    	               + " where userid = ? ";

	    	           pstmt = conn.prepareStatement(sql);

	    	           pstmt.setInt(1, Integer.parseInt((String)paraMap.get("totalPaymentAmount")));
	    	           pstmt.setString(2, (String) paraMap.get("userid"));

	    	           n5 = pstmt.executeUpdate();
	    	           
	    	           // 예치금 내역 insert
	    	           if(n5 == 1) {
	    	        	   sql = "insert into tbl_coin_history(coinno, fk_userid, coin_amount)"
									+ " values(seq_coin_history.nextval, ?, ?)";
							pstmt = conn.prepareStatement(sql);
							pstmt.setString(1, (String) paraMap.get("userid"));
							pstmt.setString(2, (String)paraMap.get("totalPaymentAmount"));
							n6 = pstmt.executeUpdate();
	    	           }
	    	   }

	    	   
	    	   int odrusedpoint = Integer.parseInt((String)paraMap.get("odrusedpoint"));
		    	// 적립금 사용시
	   	        if(odrusedpoint > 0) {
	   	        	sql = " update tbl_member set point = point - ? "
		    	               + " where userid = ? ";

    	            pstmt = conn.prepareStatement(sql);
 
    	            pstmt.setInt(1, odrusedpoint );
    	            pstmt.setString(2, (String) paraMap.get("userid"));

		    	     n5 = pstmt.executeUpdate();
		    	     // 적립금 내역 insert
		    	     if(n5 == 1) {
		    	    	 sql = "insert into tbl_point_history(pointno, fk_userid, point_amount)"
									+ " values(seq_point_history.nextval, ?, ?)";
							pstmt = conn.prepareStatement(sql);
							pstmt.setString(1, (String) paraMap.get("userid"));
							pstmt.setInt(2, odrusedpoint*(-1));
							n6 = pstmt.executeUpdate();
		    	     }
	   	        }else {
	   	        	// 적립금 미사용시
	   	        	sql = " update tbl_member set point = point + ? "
		    	               + " where userid = ? ";

    	            pstmt = conn.prepareStatement(sql);
 
    	            pstmt.setInt(1, Integer.parseInt((String) paraMap.get("sumtotalPrice"))/ 100);
    	            pstmt.setString(2, (String) paraMap.get("userid"));

    	            n5 = pstmt.executeUpdate();
		    	     
		    	    // 적립금 내역 insert
		    	    if(n5 == 1) {
		    	    	sql = "insert into tbl_point_history(pointno, fk_userid, point_amount)"
								+ " values(seq_point_history.nextval, ?, ?)";
						pstmt = conn.prepareStatement(sql);
						pstmt.setString(1,  (String) paraMap.get("userid"));
						pstmt.setInt(2, Integer.parseInt((String) paraMap.get("sumtotalPrice"))/ 100);
						n6 = pstmt.executeUpdate();   
		    	    }
	   	        }
		    	  
	           
	       }

	    // 7. 모든 처리 성공시 commit
	       if(n1*n2*n3*n4*n5*n6 > 0) {
	           conn.commit();
	           conn.setAutoCommit(true); // 자동커밋으로 전환 
	           nSuccess = 1;
	       }

	    } catch(SQLException e) {
	        conn.rollback();
	        conn.setAutoCommit(true); // 자동커밋으로 전환 
	        nSuccess = 0;
	        e.printStackTrace();

	    } finally {
	        close();
	    }

	    return nSuccess;
		
	}

}
