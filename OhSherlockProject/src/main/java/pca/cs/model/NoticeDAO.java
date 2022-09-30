package pca.cs.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import common.model.NoticeVO;

public class NoticeDAO implements InterNoticeDAO {
	
	private DataSource ds;  // DataSource ds 는 아파치톰캣이 제공하는 DBCP(DB Connection Pool) 이다.  
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	 
	// 생성자
	public NoticeDAO() {
		
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

	// 페이징 처리하여 공지사항 글목록 가져오기
	@Override
	public List<NoticeVO> showNoticeList(Map<String, String> paraMap) throws SQLException {
		
		List<NoticeVO> noticeList = new ArrayList<>();
		
		try {
			conn = ds.getConnection();

			String sql = "select noticeNo, noticeSubject, noticeContent, noticeHit, noticeDate from "
					+ " (select rownum as rno, noticeNo, noticeSubject, noticeContent, noticeHit, noticeDate from "
					+ " (select noticeNo, noticeSubject, noticeContent, noticeHit, noticeDate from "
					+ "tbl_notice ";
			
			String colname = paraMap.get("searchType");
			String searchWord = paraMap.get("searchWord");

			// 검색어가 있다면
			if (searchWord != null && !searchWord.trim().isEmpty()) {
				
				// 제목 검색의경우
				if(colname.equals("noticeSubject"))
					sql += " where " + colname + " like '%' || ? || '%'";
				
				// 글번호 검색의 경우
				else
					sql += " where " + colname + " = ?";
			}
			
			sql += " order by 1 desc) V "
				+ ") T "
				+ " where RNO between ? and ?";
			
			// 페이징처리
			
			int currentShowPageNo = Integer.parseInt(paraMap.get("currentShowPageNo"));  // 조회하고자 하는 페이지 번호
			int sizePerPage = 10; // 한페이지당 보여줄 행의 개수
			
			pstmt = conn.prepareStatement(sql);
			
			/// 검색어가 있는 경우
			if( searchWord != null && !searchWord.trim().isEmpty() ) {
				pstmt.setString(1, searchWord);
				pstmt.setInt(2, (currentShowPageNo*sizePerPage) - (sizePerPage-1) );
				pstmt.setInt(3, (currentShowPageNo*sizePerPage) );
			} else {
				// 검색어가 없는 경우
				pstmt.setInt(1, (currentShowPageNo*sizePerPage) - (sizePerPage-1) );
				pstmt.setInt(2, (currentShowPageNo*sizePerPage) );
			}
			rs = pstmt.executeQuery();

			while (rs.next()) {
				NoticeVO notice = new NoticeVO();
				notice.setNoticeNo(rs.getInt(1));
				notice.setNoticeSubject(rs.getString(2));
				notice.setNoticeContent(rs.getString(3));
				notice.setNoticeHit(rs.getInt(4));
				notice.setNoticeDate(rs.getDate(5));
				
				Date now = new Date();
				SimpleDateFormat df = new SimpleDateFormat("yyyyMMdd");
				int nowDate = Integer.parseInt(df.format(now)); // 현재 날짜
				int regDate = Integer.parseInt(df.format(notice.getNoticeDate())); // 공지 등록 날짜
				
				if ((nowDate - regDate) < 7) {
					notice.setFresh(true); // 등록된지 7일 이내의 글이라면 최신글
				}else {
					notice.setFresh(false);
				}
				
				noticeList.add(notice);
			}

		} finally {
			close();
		}		
		
		return noticeList;
	}

	@Override
	public NoticeVO showNoticeDetail(Map<String, String> paraMap) throws SQLException {
		NoticeVO nvo = new NoticeVO();
		
		try {
			conn = ds.getConnection();

			String sql = "select noticeSubject, noticeContent, noticeHit, noticeDate, noticeFile from tbl_notice where noticeNo = ?";

			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, paraMap.get("noticeNo"));
			rs = pstmt.executeQuery();

			if (rs.next()) {
				nvo.setNoticeSubject(rs.getString(1));
				nvo.setNoticeContent(rs.getString(2));
				nvo.setNoticeHit(rs.getInt(3));
				nvo.setNoticeDate(rs.getDate(4));
				nvo.setNoticeFile(rs.getString(5));
				nvo.setNoticeNo(Integer.parseInt(paraMap.get("noticeNo")));
				
				// 조회수 증가시키기
				// 로그인 안 한 상태이거나 일반유저로 로그인한 경우
				if (!paraMap.get("userid").equals("admin")) {
					sql = "update tbl_notice set noticeHit = noticeHit + 1 where noticeNo = ?";
					
					pstmt = conn.prepareStatement(sql);
					pstmt.setString(1, paraMap.get("noticeNo"));
					int n = pstmt.executeUpdate();
					
					if (n != 1) {
						throw new SQLException("조회수 증가 실패");
					}
				}
			}

		} finally {
			close();
		}	
		
		return nvo;
	}

	@Override
	public String getSeqNo() throws SQLException {

		String seq = "";

		try {
			conn = ds.getConnection();

			String sql = "select seq_notice.nextval from dual";

			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			rs.next();
			seq = rs.getString(1);

		} finally {
			close();
		}
		return seq;
	}

	@Override
	public int registerNotice(Map<String, String> paraMap) throws SQLException {
		int n = 0;

		try {
			conn = ds.getConnection();

			String sql = "insert into tbl_notice(noticeNo, noticeSubject, noticeContent)\n"+
					"values(?, ?, ?)";

			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, paraMap.get("seq"));
			pstmt.setString(2, paraMap.get("subject"));
			pstmt.setString(3, paraMap.get("content"));
			n = pstmt.executeUpdate();

		} finally {
			close();
		}	
		
		return n;
	}

	@Override
	public int noticeDelete(String noticeNo) throws SQLException {
		int n = 0;
		
		try {
			conn = ds.getConnection();

			String sql = "delete from tbl_notice where noticeNo = ?";

			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, noticeNo);
			n = pstmt.executeUpdate();

		} finally {
			close();
		}	
		
		return n;
	}

	@Override
	public int noticeUpdate(Map<String, String> paraMap) throws SQLException {
		int n = 0;

		String noticeNo = paraMap.get("noticeNo");
		String noticeSubject = paraMap.get("noticeSubject");
		String noticeContent = paraMap.get("noticeContent");
		
		try {
			conn = ds.getConnection();

			String sql = "update tbl_notice set noticeSubject = ?, noticeContent = ? where noticeNo = ?";

			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, noticeSubject);
			pstmt.setString(2, noticeContent);
			pstmt.setString(3, noticeNo);
			n = pstmt.executeUpdate();

		} finally {
			close();
		}

		return n;
	}

	// 공지사항 전체 페이지 수 알아오기
	@Override
	public int getTotalPage(Map<String, String> paraMap) throws SQLException {
		int totalPage = 0;

		try {
			conn = ds.getConnection();

			String sql = "select ceil(count(*)/?) from tbl_notice";

			String colname = paraMap.get("searchType");
			String searchWord = paraMap.get("searchWord");

			// 검색어가 있다면
			if (searchWord != null && !searchWord.trim().isEmpty()) {
				
				// 제목 검색의경우
				if(colname.equals("noticeSubject"))
					sql += " where " + colname + " like '%' || ? || '%'";
				
				// 글번호 검색의 경우
				else
					sql += " where " + colname + " = ?";
			}

			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, 10);

			// 검색어가 있다면 검색어로 두번째 위치홀더 채우기
			if (searchWord != null && !searchWord.trim().isEmpty()) {
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

}
