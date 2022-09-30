package kcy.mypage.model;

import java.io.UnsupportedEncodingException;
import java.security.GeneralSecurityException;
import java.security.NoSuchAlgorithmException;
import java.sql.*;
import java.util.*;

import javax.naming.*;
import javax.sql.DataSource;

import common.model.MemberVO;
import util.security.AES256;
import util.security.SecretMyKey;
import util.security.Sha256;

public class MemberDAO implements InterMemberDAO {

   private DataSource ds;             
   private Connection conn;         
   private PreparedStatement pstmt; 
   private ResultSet rs;            
   
   private AES256 aes;   // 양방향 암호화 초기화
   
   // 생성자 (프로젝트용)
   public MemberDAO() {	
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

	
	// 아이디 찾기(성명, 이메일을 입력받아서 해당 사용자의 아이디를 알려준다)
	@Override
	public String idFind(Map<String, String> paraMap) throws SQLException {
		
		String userid = null; 
		
		try {
			conn = ds.getConnection(); 
			
			String sql = " select userid "
					   + " from tbl_member "
					   + " where status = 1 and name = ? and email = ? ";  // status(회원탈퇴유무) 1: 사용가능(가입중)
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, paraMap.get("name") );               
			pstmt.setString(2, aes.encrypt(paraMap.get("email")) );  
			
			rs = pstmt.executeQuery();  
			
			if(rs.next()) {
				userid = rs.getString(1);
			}
			
		} catch(GeneralSecurityException | UnsupportedEncodingException e) {  // "|" 는 또는 이라는 의미임.
			e.printStackTrace();
		} finally {
			close();
		}
		
		return userid;
	}// end of public String idFind(Map<String, String> paraMap) throws SQLException------------


	// 회원의 coin 및 포인트 변경하기 및 내역 inser하기
		@Override
		public int coinUpdate(Map<String, String> paraMap) throws SQLException {

	        int result = 0;
	        
	        try {
				 conn = ds.getConnection();
				 
				 String sql = " update tbl_member set coin = coin + ? , point = point + ? "
				 		    + " where userid = ? ";
				 
				 pstmt = conn.prepareStatement(sql);
				 
				 pstmt.setInt(1, Integer.parseInt(paraMap.get("coinmoney")) );
				 pstmt.setInt(2, (int)(Integer.parseInt(paraMap.get("coinmoney")) * 0.01) );  // 300000 * 0.01 ==> 3000.0 ==> (int)3000.0 ==> 3000
				 pstmt.setString(3, paraMap.get("userid"));
				 
				 result = pstmt.executeUpdate();
				 
				 if(result==1) {
					 // insert하는 코드
					 
					sql = " insert into tbl_coin_history(COINNO, FK_USERID, COIN_AMOUNT) "
					    + " values(seq_coin_history.nextval, ?, ? ) ";
					
					pstmt = conn.prepareStatement(sql);
					
					pstmt.setString(1, paraMap.get("userid"));
					pstmt.setInt(2, Integer.parseInt(paraMap.get("coinmoney")));
					
					result = pstmt.executeUpdate();
					 
				 }
				 
			} finally {
				close();
			}
	        
			return result;
		}// end of public int coinUpdate(Map<String, String> paraMap) throws SQLException-------  


		// 페이징 처리를 한 모든 예치금 내역 보여주기
		@Override
		public List<CoinVO> selectPagingCoin(Map<String, String> paraMap) throws SQLException  {

			List<CoinVO> coin_history = new ArrayList<>();
			
			try {
				 conn = ds.getConnection();
				 
				 String sql = " select COINNO, FK_USERID,  COIN_DATE, COIN_AMOUNT "+
							 "  from "+
							 "    (  "+
							 "        select rownum AS RNO, COINNO, FK_USERID,  COIN_DATE, COIN_AMOUNT "+
							 "        from "+
							 "        ( "+
							 "           select COINNO, FK_USERID,  COIN_DATE, COIN_AMOUNT "+
							 "           from tbl_coin_history "+
							 "           order by COIN_DATE desc "+
							 "        ) V   "+
							 "    )T "+
							 "  where RNO between ? and ? ";
				 
				 int currentShowPageNo = Integer.parseInt(paraMap.get("currentShowPageNo"));  // 조회하고자 하는 페이지 번호
				 int sizePerPage = Integer.parseInt(paraMap.get("sizePerPage")); // 한페이지당 보여줄 행의 개수
					
				 pstmt = conn.prepareStatement(sql);
				 
				 pstmt.setInt(1, (currentShowPageNo*sizePerPage) - (sizePerPage-1) );
				 pstmt.setInt(2, (currentShowPageNo*sizePerPage) );
				 
				 rs = pstmt.executeQuery();
				 
				 while(rs.next()) {
						
					 	CoinVO cvo = new CoinVO();
					 	cvo.setCoinno(rs.getInt(1));
					 	cvo.setFk_userid(rs.getString(2));
					 	cvo.setCoin_date(rs.getString(3));
					 	cvo.setCoin_amount(rs.getInt(4));
						
					 	coin_history.add(cvo); // 리스트에 담아준다.
						
					} // end of while
				 
				 
			} finally {
				close();
			}
			
			return coin_history;
			
		}// end of 페이징 처리를 한 모든 예치금 내역 보여주기 --------------------------------


		/*
		// 페이징 처리에 대한 페이지 출력하기
		@Override
		public int getTotalPage(Map<String, String> paraMap) throws SQLException {
			
			
			int totalPage = 0;
			
			try {
				conn = ds.getConnection();
				
				String sql = " select ceil(count(*)/?) "
							+ " from tbl_member "
							+ " where userid != 'admin' ";
				
				String colname = paraMap.get("searchType");
				String searchWord = paraMap.get("searchWord");
				
				// 맵에는 서치월드와 서치타입이 있는데 서치타입은 default가 회원명이기 때문에 무조건 여기로 보내준다. 
				// 디비에서도 검색어가 있는지 없는지에 대해서 알기 위해서는 서치 워드의 유무를 본다.
				
				if( "mobile".equals(colname) ) {
					searchWord = aes.encrypt(searchWord); // db 에는 이메일이 암호화 되어서 나온다.
				}
				
				if( searchWord != null && !searchWord.trim().isEmpty() ) { // 서치워드에 공백을 지우고 동시에 비어있지 않는다면
					// !searchWord.trim().isEmpty() 이거만 단독으로 주게되면 nullPonitException 이 떨어진다
					sql += " and "+ colname +" like '%' || ? || '%' "; 
					// 위치홀더는 컬럼명이나 테이블명이 올 경우에는 에러발생. 검색어만 들어와야 한다. 테이블명 또는 컬럼명이 변수로 들어올 수 없다.
					// 테이블명 또는 컬럼명이 변수로 들어와야 할 경우에는 변수로 처리해주어야 한다.
				}
				
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, Integer.parseInt(paraMap.get("sizePerPage")));
				
				if( searchWord != null && !searchWord.trim().isEmpty() ) {
					// 검색이 있다면
					pstmt.setString(2, searchWord); // 두번째 위치홀더 자리엔 searchWord를 넣어주어야 한다.
					
				}
				
				rs = pstmt.executeQuery();
				rs.next();
				totalPage = rs.getInt(1);
				
			} catch (NoSuchAlgorithmException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (UnsupportedEncodingException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (GeneralSecurityException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} finally {
				close();
			}
			
			return totalPage;
			
			
		}
*/

		
		
		
		
	
}