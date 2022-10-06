package kcy.mypage.model;

import java.io.UnsupportedEncodingException;
import java.security.GeneralSecurityException;
import java.security.NoSuchAlgorithmException;
import java.sql.*;
import java.util.*;

import javax.naming.*;
import javax.sql.DataSource;

import common.model.CoinVO;
import common.model.MemberVO;
import common.model.PointVO;
import util.security.AES256;
import util.security.SecretMyKey;
import util.security.Sha256;

public class MemberDAO implements InterMemberDAO {

	private DataSource ds;
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;

	private AES256 aes; // 양방향 암호화 초기화

	// 생성자 (프로젝트용)
	public MemberDAO() {
		try {
			Context initContext = new InitialContext();
			Context envContext = (Context) initContext.lookup("java:/comp/env");
			ds = (DataSource) envContext.lookup("jdbc/myprjoracle");

			aes = new AES256(SecretMyKey.KEY);
			// SecretMyKey.KEY: 우리가 만든 비밀키

		} catch (NamingException e) {
			e.printStackTrace();
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
	}

	// 사용한 자원을 반납하는 close() 메소드 생성하기
	private void close() {

		try {

			if (rs != null) {
				rs.close();
				rs = null;
			}
			if (pstmt != null) {
				pstmt.close();
				pstmt = null;
			}
			if (conn != null) {
				conn.close();
				conn = null;
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}

	}

	// 아이디 찾기(성명, 이메일을 입력받아서 해당 사용자의 아이디를 알려준다)
	@Override
	public String idFind(Map<String, String> paraMap) throws SQLException {

		String userid = null;

		try {
			conn = ds.getConnection();

			String sql = " select userid " + " from tbl_member " + " where status = 1 and name = ? and email = ? "; // status(회원탈퇴유무)
																													// 1:
																													// 사용가능(가입중)

			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, paraMap.get("name"));
			pstmt.setString(2, aes.encrypt(paraMap.get("email")));

			rs = pstmt.executeQuery();

			if (rs.next()) {
				userid = rs.getString(1);
			}

		} catch (GeneralSecurityException | UnsupportedEncodingException e) { // "|" 는 또는 이라는 의미임.
			e.printStackTrace();
		} finally {
			close();
		}

		return userid;
	}// end of public String idFind(Map<String, String> paraMap) throws
		// SQLException------------

	// 회원의 coin 및 포인트 변경하기 및 내역 inser하기
	@Override
	public int coinUpdate(Map<String, String> paraMap) throws SQLException {

		int result = 0;

		try {
			conn = ds.getConnection();

			String sql = " update tbl_member set coin = coin + ? , point = point + ? " + " where userid = ? ";

			pstmt = conn.prepareStatement(sql);

			pstmt.setInt(1, Integer.parseInt(paraMap.get("coinmoney")));
			pstmt.setInt(2, (int) (Integer.parseInt(paraMap.get("coinmoney")) * 0.01)); // 300000 * 0.01 ==> 3000.0 ==>
																						// (int)3000.0 ==> 3000
			pstmt.setString(3, paraMap.get("userid"));

			result = pstmt.executeUpdate();

			if (result == 1) {
				// insert하는 코드

				/*
				 * sql = " insert all   "+
				 * " into tbl_coin_history(COINNO, FK_USERID, COIN_AMOUNT) values(seq_coin_history.nextval, ?, ? )   "
				 * +
				 * " into tbl_point_history(POINTNO, FK_USERID, POINT_AMOUNT) values(seq_point_history.nextval, ?, ? )  "
				 * + " select  * "+ " from dual ";
				 * 
				 * 
				 * pstmt = conn.prepareStatement(sql);
				 * 
				 * pstmt.setString(1, paraMap.get("userid")); pstmt.setInt(2,
				 * Integer.parseInt(paraMap.get("coinmoney"))); pstmt.setString(3,
				 * paraMap.get("userid")); pstmt.setInt(4,
				 * (int)(Integer.parseInt(paraMap.get("coinmoney")) * 0.01) );
				 * 
				 * result = pstmt.executeUpdate();
				 */

				sql = " insert into tbl_coin_history(COINNO, FK_USERID, COIN_AMOUNT) "
						+ " values(seq_coin_history.nextval, ?, ? ) ";

				pstmt = conn.prepareStatement(sql);

				pstmt.setString(1, paraMap.get("userid"));
				pstmt.setInt(2, Integer.parseInt(paraMap.get("coinmoney")));

				result = pstmt.executeUpdate();

				sql = " insert into tbl_point_history(POINTNO, FK_USERID, POINT_AMOUNT) "
						+ " values(seq_point_history.nextval, ?, ? ) ";

				pstmt = conn.prepareStatement(sql);

				pstmt.setString(1, paraMap.get("userid"));
				pstmt.setInt(2, (int) (Integer.parseInt(paraMap.get("coinmoney")) * 0.01));

				result = pstmt.executeUpdate();

			}

		} finally {
			close();
		}

		return result;
	}// end of public int coinUpdate(Map<String, String> paraMap) throws
		// SQLException-------

	// 페이징 처리를 한 모든 예치금 내역 보여주기, 특정기간 예치금 보여주기
	@Override
	public List<CoinVO> selectPagingCoin(Map<String, String> paraMap) throws SQLException {

		List<CoinVO> coin_history = new ArrayList<>();

		String userid = paraMap.get("userid");

		try {

			conn = ds.getConnection();

			String sql = " select COINNO, FK_USERID,  COIN_DATE, COIN_AMOUNT " + "  from " + "    (  "
					+ "        select rownum AS RNO, COINNO, FK_USERID,  COIN_DATE, COIN_AMOUNT " + "        from "
					+ "        ( " + "           select COINNO, FK_USERID,  COIN_DATE, COIN_AMOUNT "
					+ "           from tbl_coin_history ";

			String date1 = paraMap.get("date1");
			String date2 = paraMap.get("date2");

			sql += " where FK_USERID = ? ";

			if (date1 != null && date2 != null) {

				sql += " and COIN_DATE BETWEEN to_date( ?, 'yyyy-mm-dd') and to_date(?, 'yyyy-mm-dd')  ";

			}

			sql += " order by COIN_DATE desc " + "        ) V   " + "    )T " + "  where RNO between ? and ? ";

			int currentShowPageNo = Integer.parseInt(paraMap.get("currentShowPageNo")); // 조회하고자 하는 페이지 번호
			int sizePerPage = Integer.parseInt(paraMap.get("sizePerPage")); // 한페이지당 보여줄 행의 개수

			pstmt = conn.prepareStatement(sql);

			if (date1 != null && date2 != null) {
				pstmt.setString(1, paraMap.get("userid"));
				pstmt.setString(2, paraMap.get("date1"));
				pstmt.setString(3, paraMap.get("date2"));
				pstmt.setInt(4, (currentShowPageNo * sizePerPage) - (sizePerPage - 1)); // 공식
				pstmt.setInt(5, (currentShowPageNo * sizePerPage)); // 공식
			} else {
				pstmt.setString(1, paraMap.get("userid"));
				pstmt.setInt(2, (currentShowPageNo * sizePerPage) - (sizePerPage - 1)); // 공식
				pstmt.setInt(3, (currentShowPageNo * sizePerPage)); // 공식
			}

			rs = pstmt.executeQuery();

			while (rs.next()) {

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

	// 예치금 페이징 처리에 대한 페이지 출력하기
	@Override
	public int getTotalPage(Map<String, String> paraMap) throws SQLException {

		int totalPage = 0;

		String userid = paraMap.get("userid");

		try {
			conn = ds.getConnection();

			String sql = " select ceil(count(*)/?) " + " from tbl_coin_history" + " where FK_USERID = ? ";

			String date1 = paraMap.get("date1");
			String date2 = paraMap.get("date2");

			if (date1 != null && date2 != null) {

				sql += " and COIN_DATE BETWEEN to_date( ?, 'yyyy-mm-dd') and to_date(?, 'yyyy-mm-dd')  ";

			}

			pstmt = conn.prepareStatement(sql);

			if (date1 != null && date2 != null) {
				pstmt.setInt(1, Integer.parseInt(paraMap.get("sizePerPage")));
				pstmt.setString(2, paraMap.get("userid"));
				pstmt.setString(3, paraMap.get("date1"));
				pstmt.setString(4, paraMap.get("date2"));
			} else {
				pstmt.setInt(1, Integer.parseInt(paraMap.get("sizePerPage")));
				pstmt.setString(2, paraMap.get("userid"));
			}

			rs = pstmt.executeQuery();
			rs.next();
			totalPage = rs.getInt(1);

		} finally {
			close();
		}

		return totalPage;

	}// end of 페이징 처리에 대한 페이지 출력하기 ---------------------------------------

	// 페이징 처리를 한 모든 포인트 내역 보여주기
	@Override
	public List<PointVO> selectPagingPoint(Map<String, String> paraMap) throws SQLException {

		List<PointVO> point_history = new ArrayList<>();

		try {
			conn = ds.getConnection();

			String sql = " select POINTNO, FK_USERID,  POINT_DATE, POINT_AMOUNT " + "  from " + "    (  "
					+ "        select rownum AS RNO, POINTNO, FK_USERID,  POINT_DATE, POINT_AMOUNT " + "        from "
					+ "        ( " + "           select POINTNO, FK_USERID,  POINT_DATE, POINT_AMOUNT "
					+ "           from tbl_point_history ";

			String date1 = paraMap.get("date1");
			String date2 = paraMap.get("date2");

			if (date1 != null && date2 != null) {

				sql += " WHERE POINT_DATE BETWEEN to_date( ?, 'yyyy-mm-dd') and to_date(?, 'yyyy-mm-dd')  ";

			}

			sql += " order by POINTNO desc " + "        ) V   " + "    )T " + "  where RNO between ? and ? ";

			int currentShowPageNo = Integer.parseInt(paraMap.get("currentShowPageNo")); // 조회하고자 하는 페이지 번호
			int sizePerPage = Integer.parseInt(paraMap.get("sizePerPage")); // 한페이지당 보여줄 행의 개수

			pstmt = conn.prepareStatement(sql);

			if (date1 != null && date2 != null) {
				pstmt.setString(1, paraMap.get("date1"));
				pstmt.setString(2, paraMap.get("date2"));
				pstmt.setInt(3, (currentShowPageNo * sizePerPage) - (sizePerPage - 1)); // 공식
				pstmt.setInt(4, (currentShowPageNo * sizePerPage)); // 공식
			} else {
				pstmt.setInt(1, (currentShowPageNo * sizePerPage) - (sizePerPage - 1)); // 공식
				pstmt.setInt(2, (currentShowPageNo * sizePerPage)); // 공식
			}

			rs = pstmt.executeQuery();

			while (rs.next()) {

				PointVO pvo = new PointVO();
				pvo.setPointno(rs.getInt(1));
				pvo.setFk_userid(rs.getString(2));
				pvo.setPoint_date(rs.getString(3));
				pvo.setPoint_amount(rs.getInt(4));

				point_history.add(pvo); // 리스트에 담아준다.

			} // end of while

		} finally {
			close();
		}

		return point_history;

	}// end of 페이징 처리를 한 모든 포인트 내역 보여주기
		// --------------------------------------------------

	// 포인트 페이징 처리에 대한 페이지 출력하기
	@Override
	public int getPointTotalPage(Map<String, String> paraMap) throws SQLException {

		int point_totalPage = 0;

		try {
			conn = ds.getConnection();

			String sql = " select ceil(count(*)/?) " + " from tbl_point_history ";

			String date1 = paraMap.get("date1");
			String date2 = paraMap.get("date2");

			if (date1 != null && date2 != null) {

				sql += " WHERE COIN_DATE BETWEEN to_date( ?, 'yyyy-mm-dd') and to_date(?, 'yyyy-mm-dd')  ";

			}

			pstmt = conn.prepareStatement(sql);

			if (date1 != null && date2 != null) {
				pstmt.setInt(1, Integer.parseInt(paraMap.get("sizePerPage")));
				pstmt.setString(2, paraMap.get("date1"));
				pstmt.setString(3, paraMap.get("date2"));
			} else {
				pstmt.setInt(1, Integer.parseInt(paraMap.get("sizePerPage")));
			}

			rs = pstmt.executeQuery();
			rs.next();
			point_totalPage = rs.getInt(1);

		} finally {
			close();
		}

		return point_totalPage;

	}// end of 포인트 페이징 처리에 대한 페이지 출력하기 --------------------------------------

}