package pca.cs.model;

import java.sql.SQLException;
import java.util.List;

import common.model.MemberVO;
import common.model.NoticeVO;

public interface InterNoticeDAO {
	
	// 공지사항 목록
	List<NoticeVO> showNoticeList() throws SQLException;

	// 공지글 내용 조회 + 조회수 증가
	NoticeVO showNoticeDetail(String noticeNo, MemberVO loginuser) throws SQLException;

	// 공지사항 등록 전 시퀀스(글번호) 얻어오기
	int getSeqNo() throws SQLException;

	// 공지사항 등록(관리자)
	int registerNotice(int seq, String subject, String content, String file) throws SQLException;


	/*
	 * Board_noticeDTO noticeVeiwcount2(Map<String, String> paraMap); // 글조회 메소드
	 * 
	 * int noticeVeiwcount(Map<String, String> paraMap); //글조회&조회수 올려주는 메소드
	 * 
	 * int writeNotice(Board_noticeDTO bndto);// 공지게시판 글쓰기 메소드
	 * 
	 * int updateNoticeBoard(Map<String, String> paraMap); // 공지게시판 글 수정 메소드
	 * 
	 * int deleteNoticeBoard(Map<String, String> paraMap); //골지게시판 글 삭제 메소드
	 */}
