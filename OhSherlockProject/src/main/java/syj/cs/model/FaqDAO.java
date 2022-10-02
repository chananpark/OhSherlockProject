package syj.cs.model;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import common.model.FaqVO;

public class FaqDAO implements InterFaqDAO {

	private DataSource ds;  // DataSource ds 는 아파치톰캣이 제공하는 DBCP(DB Connection Pool) 이다.  
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	 
	// 생성자
	public FaqDAO() {
		
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

	//////////////////////////////////////////////////////////////////////////
	
	// 자주묻는질문 공지사항 작성하기
	@Override
	public int registerFaq(Map<String, String> paraMap) throws SQLException {
		
		int n = 0;

		try {
			conn = ds.getConnection();

			String sql = " insert into tbl_faq(faq_num, faq_category, faq_subject, faq_content) "+
						 " values(seq_faq.nextval, ?, ?, ?) ";

			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, paraMap.get("faq_category"));
			pstmt.setString(2, paraMap.get("title"));
			pstmt.setString(3, paraMap.get("content"));
			n = pstmt.executeUpdate();

		} finally {
			close();
		}	
		
		return n;
	} // end of public int registerFaq(Map<String, String> paraMap) throws SQLException

	
	
	// 자주묻는질문 버튼아이디에 따른 리스트 select 해오기
	@Override
	public List<FaqVO> selectFaqList(Map<String, String> paraMap) throws SQLException {

		List<FaqVO> faqList = new ArrayList<>();
		
		try {

			conn = ds.getConnection();
			
			String sql = "select faq_num, faq_category, faq_subject, faq_content "+
						"from tbl_faq ";
			
			String selectid = paraMap.get("selectid");
			
			if( !("all".equals(selectid)) ) {
				// faq_category 가 선택되어질 경우의 sql 문
				sql += " where faq_category = ? ";
			}
			
			pstmt = conn.prepareStatement(sql);
			
			// 만일 faq_category 가 all 이 아닌 경우에만 위치홀더에 값을 세팅해준다.
			if( !("all".equals(selectid)) ) {
				pstmt.setString(1, selectid);
			} 
			
			rs = pstmt.executeQuery();
			
			// 복수개의 행 출력
			while(rs.next()) {
				
				FaqVO fvo = new FaqVO();
				
				fvo.setFaq_num(rs.getInt(1)); // 질문번호
				fvo.setFaq_category(rs.getString(2)); // 카테고리
				fvo.setFaq_subject(rs.getString(3)); // 질문제목
				fvo.setFaq_content(rs.getString(4)); // 질문답변

				faqList.add(fvo);
				
			} // end of while
			
		} finally {
			close();
		}

		return faqList;
	} // end of public List<FaqVO> selectFaqList(Map<String, String> paraMap) throws SQLException

	
	// 기존의 faq 내용을 faqEdit_admin.jsp 단에 뿌려주기
	@Override
	public FaqVO faqEditSelect(String faq_num) throws SQLException {

		FaqVO fvo = new FaqVO();
		
		try {

			conn = ds.getConnection();
			
			String sql = "select faq_num, faq_category, faq_subject, faq_content\n"+
						"from tbl_faq\n"+
						"where faq_num = ? ";
			
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, faq_num);
			
			rs = pstmt.executeQuery();
			
			// 복수개의 행 출력
			while(rs.next()) {
				
				fvo = new FaqVO();
				
				fvo.setFaq_num(rs.getInt(1)); // 질문번호
				fvo.setFaq_category(rs.getString(2)); // 카테고리
				fvo.setFaq_subject(rs.getString(3)); // 질문제목
				fvo.setFaq_content(rs.getString(4)); // 질문답변
				
				
			} // end of while
			
		} finally {
			close();
		}

		return fvo;
	
	} // end of public FaqVO faqEditSelect(String faq_num) throws SQLException

	
	// 수정된 FAQ DB에 업데이트 해주는 메소드
	@Override
	public int faqEditUpdate(Map<String, String> paraMap) throws SQLException {

		int result = 0;
	      
		try {
			conn = ds.getConnection();
         
			String sql = " update tbl_faq "
						+ " set	faq_category = ?, "
						+ "  	faq_subject = ?, "
						+ "		faq_content = ? "
						+ " where faq_num = ? ";
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, paraMap.get("faq_category"));
			pstmt.setString(2, paraMap.get("title"));
			pstmt.setString(3, paraMap.get("content"));
			pstmt.setString(4, paraMap.get("faq_num"));

			result = pstmt.executeUpdate(); // 0 아니면 1이 나와서 result 에 넣어준다.
         
		} finally {
			close();
		}
      
		return result;
	} // end of public int faqEditUpdate(Map<String, String> paraMap) throws SQLException

	
	// 자주묻는질문 삭제하기
	@Override
	public int faqDelete(String faq_num) throws SQLException {

		int result = 0;
	      
		try {
			conn = ds.getConnection();
         
			String sql = " delete tbl_faq where faq_num = ? ";
			
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, faq_num);

			result = pstmt.executeUpdate(); // 0 아니면 1이 나와서 result 에 넣어준다.
         
		} finally {
			close();
		}
      
		return result;
	
	} // end of public int faqDelete(String faq_num)

	
	
	
	
	
	
	
	
	
	
}
