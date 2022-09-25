package pca.cs.model;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import common.model.MemberVO;
import common.model.NoticeVO;

public interface InterNoticeDAO {
	
	// 공지사항 목록
	List<NoticeVO> showNoticeList() throws SQLException;

	// 공지글 내용 조회 + 조회수 증가
	NoticeVO showNoticeDetail(Map<String, String> paraMap) throws SQLException;

	// 공지사항 등록 전 시퀀스(글번호) 얻어오기
	String getSeqNo() throws SQLException;

	// 공지사항 등록(관리자)
	int registerNotice(Map<String, String> paraMap) throws SQLException;

	// 공지사항 삭제(관리자)
	int noticeDelete(String noticeNo) throws SQLException;

	// 공지사항 수정(관리자)
	int noticeUpdate(Map<String, String> paraMap) throws SQLException;

}
