package pca.cs.model;

import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.naming.*;
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


	@Override
	public List<NoticeVO> showNoticeList() throws SQLException {
		
		List<NoticeVO> noticeList = new ArrayList<>();
		
		try {
			conn = ds.getConnection();

			String sql = "select noticeNo, noticeSubject, noticeContent, noticeHit, noticeDate, noticeFile from tbl_notice "
					+ "order by 1 desc";

			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				NoticeVO notice = new NoticeVO();
				notice.setNoticeNo(rs.getInt(1));
				notice.setNoticeSubject(rs.getString(2));
				notice.setNoticeContent(rs.getString(3));
				notice.setNoticeHit(rs.getInt(4));
				notice.setNoticeDate(rs.getDate(5));
				notice.setNoticeFile(rs.getString(6));
				
				Date now = new Date();
				SimpleDateFormat df = new SimpleDateFormat("yyyyMMdd");
				int nowDate = Integer.parseInt(df.format(now)); // 현재 날짜
				int regDate = Integer.parseInt(df.format(notice.getNoticeDate())); // 공지 등록 날짜
				
				if ((nowDate - regDate) < 7) {
					notice.setFresh(true); // 등록된지 7일 이내의 글이라면 최신글
				}
				
				noticeList.add(notice);
			}

		} finally {
			close();
		}		
		
		return noticeList;
	}

}
