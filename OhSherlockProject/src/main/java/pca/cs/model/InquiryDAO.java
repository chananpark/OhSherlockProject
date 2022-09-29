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

	@Override
	public int getTotalPage(Map<String, String> paraMap) throws SQLException {
		int totalPage = 0;
		
		String userid = paraMap.get("userid");
		String startDate = paraMap.get("startDate");
		String endDate = paraMap.get("endDate");
		int sizePerPage = Integer.parseInt(paraMap.get("sizePerPage")); // 한페이지당 보여줄 행의 개수

		try {
			conn = ds.getConnection();

			String sql = "select ceil(count(*)/?) from tbl_inquiry where fk_userid = ? and inquiry_date between ? and ?";

			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, sizePerPage);
			pstmt.setString(2, userid);
			pstmt.setString(3, startDate);
			pstmt.setString(4, endDate);
			
			rs = pstmt.executeQuery();
			rs.next();
			totalPage = rs.getInt(1);

		} finally {
			close();
		}

		return totalPage;
	}

	@Override
	public List<InquiryVO> showMyInquiryList(Map<String, String> paraMap) throws SQLException {
		List<InquiryVO> inquiryList = new ArrayList<>();
		
		String userid = paraMap.get("userid");
		String startDate = paraMap.get("startDate");
		String endDate = paraMap.get("endDate");

		int currentShowPageNo = Integer.parseInt(paraMap.get("currentShowPageNo")); // 조회하고자 하는 페이지 번호
		int sizePerPage = Integer.parseInt(paraMap.get("sizePerPage")); // 한페이지당 보여줄 행의 개수

		try {
			conn = ds.getConnection();

			String sql = "\n"+
					"SELECT\n"+
					"    inquiry_no,\n"+
					"    inquiry_type,\n"+
					"    inquiry_subject,\n"+
					"    inquiry_content,\n"+
					"    inquiry_date,\n"+
					"    inquiry_answered\n"+
					"FROM \n"+
					"(select rownum AS RNO , INQUIRY_NO , INQUIRY_TYPE , INQUIRY_SUBJECT , INQUIRY_CONTENT , INQUIRY_DATE , INQUIRY_ANSWERED\n"+
					"FROM\n"+
					"    (\n"+
					"        SELECT\n"+
					"            inquiry_no,\n"+
					"            inquiry_type,\n"+
					"            inquiry_subject,\n"+
					"            inquiry_content,\n"+
					"            inquiry_date,\n"+
					"            inquiry_answered\n"+
					"        FROM\n"+
					"            tbl_inquiry\n"+
					"        WHERE\n"+
					"                fk_userid = ?\n"+
					"            AND inquiry_date BETWEEN ? and ?\n"+
					"        ORDER BY\n"+
					"            1 DESC\n"+
					"    ) v ) t\n"+
					"WHERE\n"+
					"    rno BETWEEN ? AND ?";

			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userid);
			pstmt.setString(2, startDate);
			pstmt.setString(3, endDate);
			pstmt.setInt(4, (currentShowPageNo*sizePerPage) - (sizePerPage-1));
			pstmt.setInt(5, (currentShowPageNo*sizePerPage));
			
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
