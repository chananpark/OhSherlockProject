package pca.admin.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.controller.AbstractController;
import pca.cs.model.InterNoticeDAO;
import pca.cs.model.NoticeDAO;
import pca.member.model.InterMemberDAO;
import pca.member.model.MemberDAO;

public class NoticeWriteEnd extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String method = request.getMethod();
		String message;
		String loc;
		
		String subject = request.getParameter("subject");
		String content = request.getParameter("content");
		String file = request.getParameter("file");
		
		if ("post".equalsIgnoreCase(method)) {
			
			InterNoticeDAO ndao = new NoticeDAO();
			
			// 글번호 시퀀스 얻어오기
			int seq = ndao.getSeqNo();
			
			// 공지사항 글작성
			int n = ndao.registerNotice(seq, subject, content, file);
			
			if (n==1) {
				message = "공지사항 등록이 완료되었습니다.";
				// 방금 작성한 글 조회 화면
				loc = request.getContextPath() + "/cs/noticeDetail.tea?noticeNo="+seq;
	
				request.setAttribute("message", message);
				request.setAttribute("loc", loc);
	
				super.setViewPage("/WEB-INF/msg.jsp");
			}
			else {
				message = "공지사항 등록을 실패하였습니다.";
				loc = request.getContextPath() + "javascript:history.back()";
	
				request.setAttribute("message", message);
				request.setAttribute("loc", loc);
	
				super.setViewPage("/WEB-INF/msg.jsp");
			}
		}
		else { // get 방식 접근
			
			message = "잘못된 접근입니다!";
			loc = "javascript:history.back()";

			request.setAttribute("message", message);
			request.setAttribute("loc", loc);

			super.setViewPage("/WEB-INF/msg.jsp");
		}

	}

}
