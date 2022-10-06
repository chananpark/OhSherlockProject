package pca.member.model;

import java.io.UnsupportedEncodingException;
import java.security.GeneralSecurityException;
import java.sql.*;
import java.util.Map;

import javax.naming.*;
import javax.sql.DataSource;

import common.model.MemberVO;
import util.security.AES256;
import util.security.SecretMyKey;
import util.security.Sha256;

public class MemberDAO implements InterMemberDAO {

	private DataSource ds;  // DataSource ds 는 아파치톰캣이 제공하는 DBCP(DB Connection Pool) 이다.  
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
		    
		} catch(NamingException e) {
			e.printStackTrace();
		} catch(UnsupportedEncodingException e) {
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

	// 로그인 처리 메소드
	@Override
	public MemberVO selectOneMember(Map<String, String> paraMap) throws SQLException {

		MemberVO member = null;

		try {
			conn = ds.getConnection();

			String sql = "select userid, name, email, mobile, postcode, address, detail_address, extra_address, gender,       \n"+
					"birthyyyy, birthmm, birthdd, coin, point, registerday,        \n"+
					"passwd_change_gap, nvl(last_login_gap, months_between(sysdate, registerday)) as last_login_gap, last_login_date\n"+
					"from\n"+
					"(select userid, name, email, mobile, postcode, address, detail_address, extra_address, gender     \n"+
					", substr(birthday,1,4) AS birthyyyy, substr(birthday,6,2) AS birthmm, substr(birthday,9) AS birthdd     \n"+
					", coin, point, to_char(registerday, 'yyyy-mm-dd') AS registerday     \n"+
					", trunc( months_between(sysdate, last_passwd_date) ) AS passwd_change_gap\n"+
					"from tbl_member\n"+
					"where status = 1 and userid = ? and passwd = ?) M\n"+
					"cross join\n"+
					"(select max(logindate) as last_login_date, trunc(months_between(sysdate, max(logindate))) as last_login_gap\n"+
					"from tbl_login_history\n"+
					"where fk_userid = ?) H";

			pstmt = conn.prepareStatement(sql);

			pstmt.setString(1, paraMap.get("userid"));
			pstmt.setString(2, Sha256.encrypt(paraMap.get("passwd")));
			pstmt.setString(3, paraMap.get("userid"));

			rs = pstmt.executeQuery();

			if (rs.next()) {
				
				member = new MemberVO();

				member.setUserid(rs.getString(1));
				member.setName(rs.getString(2));
				member.setEmail(aes.decrypt(rs.getString(3))); // 복호화
				member.setMobile(aes.decrypt(rs.getString(4))); // 복호화
				member.setPostcode(rs.getString(5));
				member.setAddress(rs.getString(6));
				member.setDetail_address(rs.getString(7));
				member.setExtra_address(rs.getString(8));
				member.setGender(rs.getString(9));
				member.setBirthday(rs.getString(10) + rs.getString(11) + rs.getString(12));
				member.setCoin(rs.getInt(13));
				member.setPoint(rs.getInt(14));
				member.setRegisterday(rs.getString(15));

				if (rs.getInt(16) >= 3) {
					// 마지막으로 비밀번호를 변경한 날짜가 3개월이 지났으면 
					member.setPasswdChangeRequired(true); // 비밀번호 변경 필요함
				}

				if (rs.getInt(17) >= 12) {
					// 마지막으로 로그인한지 1년이 지났으면 휴면으로 지정
					member.setIdle(1);
					
					// 마지막 로그인 날짜
					member.setLast_login_date(rs.getString(18));

					// tbl_member 테이블에 휴면 상태 update
					sql = " update tbl_member set idle = 1 " + " where userid = ? ";

					pstmt = conn.prepareStatement(sql);
					pstmt.setString(1, paraMap.get("userid"));

					pstmt.executeUpdate();
				}

				// tbl_login_history(로그인기록) 테이블에 insert
				if (member.getIdle() != 1 && rs.getInt(16) < 3) { // 휴면 회원이 아니고 비번 변경 3개월 지나지 않았으면
					sql = " insert into tbl_login_history(fk_userid, clientip) " + " values(?, ?) ";

					pstmt = conn.prepareStatement(sql);
					pstmt.setString(1, paraMap.get("userid"));
					pstmt.setString(2, paraMap.get("clientip"));

					pstmt.executeUpdate();
				}

			}

		} catch (GeneralSecurityException | UnsupportedEncodingException e) {
			e.printStackTrace();
		} finally {
			close();
		}

		return member;
	}

	// 휴면 상태 풀어주기
	@Override
	public int activateMember(String userid, String clientip){
		int result = 0;
		
		try {
			conn = ds.getConnection();
			conn.setAutoCommit(false); // 오토커밋 해제
			
			String sql = "update tbl_member set idle = 0 where userid = ?";

			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userid);
			result = pstmt.executeUpdate();
			
			if (result == 1) {
			// 로그인 이력테이블에 오늘자로 insert해주기
				
				sql = " insert into tbl_login_history(fk_userid, clientip) " + " values(?, ?) ";

				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, userid);
				pstmt.setString(2, clientip);

				result = pstmt.executeUpdate();
				conn.commit(); // 커밋
			
			}
		} catch (SQLException e) {
			try {
				conn.rollback();
			} catch (SQLException e1) {
				e1.printStackTrace(); // 예외 발생시 롤백
			}
		} finally {
			try {
				conn.setAutoCommit(true); // 오토커밋 설정
			} catch (SQLException e) {
				e.printStackTrace();
			}
			close();
		}
		return result;
	}

}
