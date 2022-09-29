package syj.member.model;

import common.model.*;

import java.io.UnsupportedEncodingException;
import java.security.GeneralSecurityException;
import java.security.NoSuchAlgorithmException;
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

import util.security.AES256;
import util.security.SecretMyKey;
import util.security.Sha256;

public class MemberDAO implements InterMemberDAO {

	private DataSource ds;	// tomcat에서 제공하는 DBCP(DB connection pool) 이다.
	// import javax.sql.DataSource; 로 import 
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	private AES256 aes;
	
	// 생성자
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

	
	// 비밀번호 찾기(아이디, 이메일, 이름을 입력받아서 해당 사용자의 비밀번호를 알려준다.)
	@Override
	public boolean isUserExist(Map<String, String> paraMap) throws SQLException {

		boolean isUserExist = false;
		
		try {
			conn = ds.getConnection();
			
			System.out.println(paraMap.get("userid"));
			
			String sql = " select userid " +
						 " from tbl_member " +
						 " where status = 1 and userid = ? and email = ? and name = ? ";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, paraMap.get("userid") ); // key 값으로 넣어준 name 을 넣어준다.
			pstmt.setString(2, aes.encrypt(paraMap.get("email")) ); // 양방향 암호화 이기 때문에 다시 암호화를 풀어주어야 한다. 
			pstmt.setString(3, paraMap.get("name") );
			
			rs = pstmt.executeQuery();
			
			isUserExist = rs.next();
			System.out.println(isUserExist);
			
		} catch(GeneralSecurityException | UnsupportedEncodingException e) { // 
			e.printStackTrace();
		} finally {
			close();
		}
		
		return isUserExist;
	} // end of public boolean isUserExist(Map<String, String> paraMap) throws SQLException


	//비밀번호 변경하기
	@Override
	public int passwdUpdate(Map<String, String> paraMap) throws SQLException {
		int result = 0;
      
		try {
			conn = ds.getConnection();
         
			String sql = " update tbl_member set passwd = ?, last_passwd_date = sysdate "
					   + " where userid = ? ";
			pstmt = conn.prepareStatement(sql);
         
			pstmt.setString(1, Sha256.encrypt(paraMap.get("passwd")) ); // 암호화해서 데이터베이스에 들어가야한다. 단방향 암호화 
			pstmt.setString(2, paraMap.get("userid"));
         
			result = pstmt.executeUpdate(); // 0 아니면 1이 나와서 result 에 넣어준다.
         
		} finally {
			close();
		}
      
		return result;
	
	}//end of public int passwdUpdate(Map<String, String> paraMap) throws SQLException

	
	// 회원조회에서 특정 조건의 회원 페이징처리해서 보여주기
	// 페이징 처리를 한 모든 회원 또는 검색한 회원 목록 보여주기
	@Override
	public List<MemberVO> selectPagingMember(Map<String, String> paraMap) throws SQLException {
		
		List<MemberVO> memberList = new ArrayList<>();
		
		try {
			conn = ds.getConnection();
			
			String sql = "select userid, name, mobile, idle\n"+
						"from\n"+
						"(\n"+
						"    select rownum AS RNO, userid, name, mobile, idle\n"+
						"    from\n"+
						"    (\n"+
						"        select userid, name, mobile, idle\n"+
						"        from tbl_member\n"+
						"        where userid != 'admin' -- 탈퇴한 회원도 색만 다르게 해서 볼 것이기 때문에 admin만 제외하고 보여준다.\n";
						
				// 이 사이에 검색어를 넣을지 말지에 대해서 결정해야 한다.
				// 맵에 4개가 들어있는데 서치워드 유무에 따라서 검색어를 넣을지 말지를 결정해주면 된다.
				String colname = paraMap.get("searchType");
				String searchWord = paraMap.get("searchWord");
				
				if( "mobile".equals(colname) ) {
					// 검색대상이 이메일인 경우 암호화 해주어야 한다.
					searchWord = aes.encrypt(searchWord); // db 에는 이메일이 암호화 되어서 나온다. 그래서 검색어가 이메일이면 암호화 해야한다.
				}
				
				if( searchWord != null && !searchWord.trim().isEmpty() ) { // 서치워드에 공백을 지우고 동시에 비어있지 않는다면 // 검색어가 있다면
					// !searchWord.trim().isEmpty() 이거만 단독으로 주게되면 nullPonitException 이 떨어진다
					sql += " and " + colname + " like '%' || ? || '%' "; // 컬럼명과 변수명이 들어온다.
					// 위치홀더는 컬럼명이나 테이블명이 올 경우에는 에러발생. 검색어만 들어와야 한다. 테이블명 또는 컬럼명이 변수로 들어올 수 없다.
					// 테이블명 또는 컬럼명이 변수로 들어와야 할 경우에는 변수로 처리해주어야 한다.
				}		
						
				 sql +=	"        order by registerday desc\n"+
						"    )V\n"+
						") T --RNO를 where 절에 사용할 수 없어서 다시 인라인뷰를 사용하여 T 라는 테이블로 간주한다.\n"+
						"where RNO between ? and ? ";
				
//			=== 페이징처리의 공식 ===
//			where RNO between (조회하고자 하는 페이지 번호 * 한페이지당 보여줄 행의 개수) - (한페이지당 보여줄 행의 개수 -1) 
//			              and (조회하고자 하는 페이지 번호 * 한페이지당 보여줄 행의 개수);

			int currentShowPageNo = Integer.parseInt(paraMap.get("currentShowPageNo"));  // 조회하고자 하는 페이지 번호
			int sizePerPage = Integer.parseInt(paraMap.get("sizePerPage")); // 한페이지당 보여줄 행의 개수
			
			pstmt = conn.prepareStatement(sql);
		
			/// 검색어가 있는 경우에 위치홀더 값
			if( searchWord != null && !searchWord.trim().isEmpty() ) {
				pstmt.setString(1, searchWord);
				pstmt.setInt(2, (currentShowPageNo*sizePerPage) - (sizePerPage-1) );
				pstmt.setInt(3, (currentShowPageNo*sizePerPage) );
			} else {
				// 페이징 처리 공식
				// 검색어가 없는 경우의 위치홀더 값
				pstmt.setInt(1, (currentShowPageNo*sizePerPage) - (sizePerPage-1) );
				pstmt.setInt(2, (currentShowPageNo*sizePerPage) );
			}
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				
				MemberVO mvo = new MemberVO();
				mvo.setUserid(rs.getString(1)); // sql 문 첫번째가 userid
				mvo.setName(rs.getString(2));
				mvo.setMobile(aes.decrypt(rs.getString(3)) ); // 복호화
				mvo.setIdle(rs.getInt(4)); 
				
				memberList.add(mvo); // 리스트에 담아준다.
				
			} // end of while
			
		} catch(GeneralSecurityException | UnsupportedEncodingException e) { // 
			e.printStackTrace();
		} finally {
			close();
		}
		
		return memberList;
	} // end of public List<MemberVO> selectPagingMember(Map<String, String> paraMap) throws SQLException

		
		
	// 페이징 처리를 위한 검색 유무에 따른 회원 수에 대한 페이지 출력하기
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
			e.printStackTrace();
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		} catch (GeneralSecurityException e) {
			e.printStackTrace();
		} finally {
			close();
		}
		
		return totalPage;
			
	} // end of public int getTotalPage(Map<String, String> paraMap) throws SQLException

	
	// 관리자 회원 목록에서 회원 상세조회
	@Override
	public MemberVO member_list_detail(Map<String, String> paraMap) throws SQLException {
		
		MemberVO member = null;
	
		try {
			conn = ds.getConnection();
					
			String sql = "select userid, name, mobile, email, postcode, (address || ' ' || detail_address || ' ' || extra_address) as address, birthday, gender, coin, point, registerday\n"+
					     "from tbl_member\n"+
						 "where userid = ? ";
			
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, paraMap.get("userid"));
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				
				// select 해서 가져올 게 있냐
				member = new MemberVO();
				
				member.setUserid(rs.getString(1));
				member.setName(rs.getString(2));
				member.setMobile(aes.decrypt(rs.getString(3)) ); // 복호화
				member.setEmail(aes.decrypt(rs.getString(4)) ); // 복호화
	            member.setPostcode(rs.getString(5));
	            member.setAddress(rs.getString(6));
	            member.setBirthday(rs.getString(7));
	            member.setGender(rs.getString(8));
	            member.setCoin(rs.getInt(9));
	            member.setPoint(rs.getInt(10));
	            member.setRegisterday(rs.getString(11));
				
			} // end of if(rs.next())
			
			
		} catch(GeneralSecurityException | UnsupportedEncodingException e) { // 
			e.printStackTrace();
		} finally {
			close();
		}
	
		return member;
	} // end of public MemberVO member_list_detail(Map<String, String> paraMap) throws SQLException

	
	
} // end of MemberDAO
