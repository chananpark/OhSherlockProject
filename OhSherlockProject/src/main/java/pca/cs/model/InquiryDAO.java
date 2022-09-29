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

			String sql = "select INQUIRY_NO , INQUIRY_TYPE , INQUIRY_SUBJECT , INQUIRY_CONTENT , INQUIRY_DATE , INQUIRY_ANSWERED\n"+
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
				ivo.setInquiry_content(rs.getString(4));
				ivo.setInquiry_date(rs.getString(5).substring(0,10));
				ivo.setInquiry_answered(rs.getInt(6));

				inquiryList.add(ivo);
			}

		} finally {
			close();
		}

		return inquiryList;
	}


}
