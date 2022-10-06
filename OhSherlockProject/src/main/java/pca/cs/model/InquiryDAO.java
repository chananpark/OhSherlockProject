package pca.cs.model;

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

import common.model.InquiryReplyVO;
import common.model.InquiryVO;
import common.model.NoticeVO;

public class InquiryDAO implements InterInquiryDAO {
	
	private DataSource ds;  // DataSource ds 는 아파치톰캣이 제공하는 DBCP(DB Connection Pool) 이다.  
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	 
	// 생성자
	public InquiryDAO() {
		
		try {
			Context initContext = new InitialContext();
		    Context envContext  = (Context)initContext.lookup("java:/comp/env");
		    ds = (DataSource)envContext.lookup("jdbc/myprjoracle");
		    
		    //aes = new AES256(SecretMyKey.KEY);
		    
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
	// 1:1 문의글 시퀀스 생성하기
	private int getinquiryNo() throws SQLException {

		int seq = 0;
		try {
			conn = ds.getConnection();
			String sql = "select seq_inquiry.nextval from dual";
	
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			rs.next();
			seq = rs.getInt(1);
		}finally {
			close();
		}
		return seq;
	}

	// 1:1 문의 등록하기
	@Override
	public int makeInquiry(InquiryVO ivo) throws SQLException {
		int n = 0;
		int inquiryNo = getinquiryNo();
		
		try {
			conn = ds.getConnection();
			
			String sql = "insert into tbl_inquiry(inquiry_no, fk_userid, inquiry_type, "
					+ "inquiry_subject, inquiry_content, inquiry_email, inquiry_sms)\r\n"
					+ "values(?, ?, ?, ?, ?, ?, ?)";
			
			pstmt = conn.prepareStatement(sql);

			
			pstmt.setInt(1, inquiryNo);
			pstmt.setString(2, ivo.getFk_userid());
			pstmt.setString(3, ivo.getInquiry_type());
			pstmt.setString(4, ivo.getInquiry_subject());
			pstmt.setString(5, ivo.getInquiry_content());
			pstmt.setInt(6, ivo.getInquiry_email());
			pstmt.setInt(7, ivo.getInquiry_sms());

			n = pstmt.executeUpdate();
			
		}finally {
			close();
		}

		return n;
	}

	// 문의 개수 조회
	@Override
	public int countInquiry(Map<String, String> paraMap) throws SQLException {
	    int totalCount = 0;

	    try {
	        conn = ds.getConnection();

	        String sql = "select count(*) from tbl_inquiry where fk_userid = ? and inquiry_date between ? and to_date(? ||' 23:59:59', 'yyyy-mm-dd hh24:mi:ss')";

	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, paraMap.get("userid"));
	        pstmt.setString(2, paraMap.get("startDate"));
	        pstmt.setString(3, paraMap.get("endDate"));

	        rs = pstmt.executeQuery();

	        rs.next();

	        totalCount = rs.getInt(1);


	    } finally {
	        close();
	    }
	    return totalCount;
	}

	// 문의 내역 조회
	@Override
	public List<InquiryVO> showMyInquiryList(Map<String, String> paraMap) throws SQLException {
		List<InquiryVO> inquiryList = new ArrayList<>();
		
		String userid = paraMap.get("userid");
		String startDate = paraMap.get("startDate");
		String endDate = paraMap.get("endDate");
		String lead = paraMap.get("lead");
		String last = paraMap.get("last");

		try {
			conn = ds.getConnection();

			String sql = "select INQUIRY_NO , INQUIRY_TYPE , INQUIRY_SUBJECT , INQUIRY_DATE , INQUIRY_ANSWERED\n"+
					"from\n"+
					"(\n"+
					"select row_number() over(order by INQUIRY_DATE desc) as rno,\n"+
					"INQUIRY_NO , INQUIRY_TYPE , INQUIRY_SUBJECT , INQUIRY_CONTENT , INQUIRY_DATE , INQUIRY_ANSWERED\n"+
					"from tbl_inquiry\n"+
					"where fk_userid = ? AND inquiry_date between ? and to_date(? ||' 23:59:59', 'yyyy-mm-dd hh24:mi:ss')\n"+
					")\n"+
					"where rno between ? and ?";

			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userid);
			pstmt.setString(2, startDate);
			pstmt.setString(3, endDate);
			pstmt.setString(4, lead);
			pstmt.setString(5, last);
			
			rs = pstmt.executeQuery();

			while (rs.next()) {
				InquiryVO ivo = new InquiryVO();
				ivo.setInquiry_no(rs.getInt(1));
				ivo.setInquiry_type(rs.getString(2));
				ivo.setInquiry_subject(rs.getString(3));
				ivo.setInquiry_date(rs.getString(4).substring(0,10));
				ivo.setInquiry_answered(rs.getInt(5));
				ivo.setFk_userid(userid);

				inquiryList.add(ivo);
			}

		} finally {
			close();
		}

		return inquiryList;
	}

	// 자신의 문의 글내용+답변내용 조회
	@Override
	public InquiryVO showMyInquiryDetail(String inquiry_no) throws SQLException {
		InquiryVO ivo = null;

		try {
			conn = ds.getConnection();

			String sql = "select inquiry_type, inquiry_subject, "+
			" inquiry_content, inquiry_date, inquiry_answered "+
			" from tbl_inquiry "+
			" where inquiry_no = ?";

			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, inquiry_no);
			
			rs = pstmt.executeQuery();

			if (rs.next()) {
				ivo = new InquiryVO();
				
				ivo.setInquiry_type(rs.getString(1));
				ivo.setInquiry_subject(rs.getString(2));
				ivo.setInquiry_content(rs.getString(3));
				ivo.setInquiry_date(rs.getString(4).substring(0,10));
				ivo.setInquiry_answered(rs.getInt(5));
				
				// 답변이 있으면
				if(ivo.getInquiry_answered() == 1) {
					
					sql = "select inquiry_reply_date, inquiry_reply_content from tbl_inquiry_reply "
							+ " where fk_inquiry_no = ?";
					
					pstmt = conn.prepareStatement(sql);
					pstmt.setString(1, inquiry_no);
					
					rs = pstmt.executeQuery();
					if (rs.next()) {
						InquiryReplyVO irevo = new InquiryReplyVO();
						irevo.setInquiry_reply_date(rs.getString(1).substring(0,10));
						irevo.setInquiry_reply_content(rs.getString(2));
						ivo.setIrevo(irevo);
					}
				}
			}

		} finally {
			close();
		}

		return ivo;
	}
	
	// 관리자 1:1 문의 전체 글 수 가져오기
	@Override
	public int getTotalInquiries(String inquiry_answered) throws SQLException {
		int totalInquiries = 0;

		try {
			conn = ds.getConnection();

			String sql = "select count(*) from tbl_inquiry where inquiry_answered = ?";

			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, inquiry_answered);
			rs = pstmt.executeQuery();
			rs.next();
			totalInquiries = rs.getInt(1);

		} finally {
			close();
		}

		return totalInquiries;
	}

	// 페이징 처리하여 모든 회원들의 1:1문의 목록 가져오기
	@Override
	public List<InquiryVO> showInquiryList(Map<String, String> paraMap) throws SQLException {

		List<InquiryVO> inquiryList = new ArrayList<>();
				
		try {
			conn = ds.getConnection();

			String sql = "SELECT inquiry_no, inquiry_type, inquiry_subject, inquiry_content, inquiry_date, fk_userid "+
					" FROM ( SELECT ROWNUM AS rno, inquiry_no, inquiry_type, inquiry_subject, inquiry_content, inquiry_date, fk_userid "+
					" FROM ( SELECT inquiry_no, inquiry_type, inquiry_subject, inquiry_content, inquiry_date, fk_userid "+
					" FROM tbl_inquiry WHERE inquiry_answered = ? ORDER BY 1 DESC ) v ) t\n"+
					" WHERE rno BETWEEN ? AND ?";
			
			// 페이징처리
			int currentShowPageNo = Integer.parseInt(paraMap.get("currentShowPageNo"));  // 조회하고자 하는 페이지 번호
			int sizePerPage = 7; // 한페이지당 보여줄 행의 개수
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, paraMap.get("inquiry_answered"));
			pstmt.setInt(2, (currentShowPageNo*sizePerPage) - (sizePerPage-1) );
			pstmt.setInt(3, (currentShowPageNo*sizePerPage) );
			
			rs = pstmt.executeQuery();

			while (rs.next()) {
				InquiryVO ivo = new InquiryVO();
				ivo.setInquiry_no(rs.getInt(1));
				ivo.setInquiry_type(rs.getString(2));
				ivo.setInquiry_subject(rs.getString(3));
				ivo.setInquiry_content(rs.getString(4));
				ivo.setInquiry_date(rs.getString(5).substring(0, 10));
				ivo.setFk_userid(rs.getString(6));
				
				inquiryList.add(ivo);
			}

		} finally {
			close();
		}		
		
		return inquiryList;
	}

	// 관리자 1:1 문의글 내용 조회
	@Override
	public InquiryVO showInquiryDetail(String inquiry_no) throws SQLException {
		InquiryVO ivo = new InquiryVO();
		
		try {
			conn = ds.getConnection();

			String sql = "SELECT fk_userid, inquiry_type, inquiry_subject, inquiry_content, "
					+ " inquiry_date, inquiry_email, inquiry_sms, inquiry_answered "
					+ " FROM tbl_inquiry WHERE inquiry_no = ?";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, inquiry_no);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				ivo.setFk_userid(rs.getString(1));
				ivo.setInquiry_type(rs.getString(2));
				ivo.setInquiry_subject(rs.getString(3));
				ivo.setInquiry_content(rs.getString(4));
				ivo.setInquiry_date(rs.getString(5).substring(0,10));
				ivo.setInquiry_email(rs.getInt(6));
				ivo.setInquiry_sms(rs.getInt(7));
				ivo.setInquiry_answered(rs.getInt(8));
				ivo.setInquiry_no(Integer.parseInt(inquiry_no));
				
				// 답변이 있으면
				if(ivo.getInquiry_answered() == 1) {
					
					sql = "select inquiry_reply_date, inquiry_reply_content from tbl_inquiry_reply "
							+ " where fk_inquiry_no = ?";
					
					pstmt = conn.prepareStatement(sql);
					pstmt.setString(1, inquiry_no);
					
					rs = pstmt.executeQuery();
					
					if (rs.next()) {
						InquiryReplyVO irevo = new InquiryReplyVO();
						irevo.setInquiry_reply_date(rs.getString(1).substring(0,10));
						irevo.setInquiry_reply_content(rs.getString(2));
						ivo.setIrevo(irevo);
					}
				}
			}

		} finally {
			close();
		}	
		
		return ivo;
	}

	// 1:1 문의글 답변 시퀀스 생성하기
	private String getInquiry_reply_no() throws SQLException {

		String seq_inquiry_reply_no="";
		try {
			conn = ds.getConnection();
			String sql = "select seq_inquiry_reply_no.nextval from dual";
	
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			rs.next();
			seq_inquiry_reply_no = rs.getString(1);
		}finally {
			close();
		}
		return seq_inquiry_reply_no;
	}

	// 1:1 문의 답변 작성
	@Override
	public int writeReply(Map<String, String> paraMap){
		String inquiry_no = paraMap.get("inquiry_no");
		String inquiry_reply_content = paraMap.get("inquiry_reply_content");
		
		int n = 0;
		try {
			// 시퀀스 얻어옴
			String seq_inquiry_reply_no = getInquiry_reply_no();
			
			conn = ds.getConnection();
			conn.setAutoCommit(false); // 오토커밋 해제
			
			String sql = "insert into tbl_inquiry_reply(inquiry_reply_no, fk_inquiry_no, inquiry_reply_content)\n"+
					"values(?, ?, ?)";

			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, seq_inquiry_reply_no);
			pstmt.setString(2, inquiry_no);
			pstmt.setString(3, inquiry_reply_content);
			n = pstmt.executeUpdate();
			
			if (n==1) { // 문의글의 답변여부 컬럼 업데이트하기
				sql = "update tbl_inquiry set inquiry_answered = 1 where inquiry_no = ?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, inquiry_no);
				n = pstmt.executeUpdate();
				conn.commit(); // 커밋
			}

		} catch(SQLException e){
			try {
				conn.rollback();
			} catch (SQLException e1) {
				e1.printStackTrace(); // 예외 발생시 롤백
			}
		}
			finally {
				try {
					conn.setAutoCommit(true); // 오토커밋 설정
				} catch (SQLException e) {
					e.printStackTrace();
				} 
			close();
		}	
		
		return n;
	}
}
