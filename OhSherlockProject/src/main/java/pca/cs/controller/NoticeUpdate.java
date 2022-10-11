package pca.cs.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.controller.AbstractController;

public class NoticeUpdate extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		String method = request.getMethod();

		if ("post".equalsIgnoreCase(method)) {
			String noticeNo = request.getParameter("noticeNo");
			String noticeSubject = request.getParameter("noticeSubject");
			String noticeContent = request.getParameter("noticeContent");
			String oldNoticeImage = request.getParameter("noticeImage");
			String oldOriginFileName = request.getParameter("originFileName");
			String oldSystemFileName = request.getParameter("systemFileName");
			noticeContent = noticeContent.replace("<br>","\n");
			
			// 수정하기 전 내용
			request.setAttribute("noticeNo", noticeNo);
			request.setAttribute("noticeSubject", noticeSubject);
			request.setAttribute("noticeContent", noticeContent);
			request.setAttribute("oldNoticeImage", oldNoticeImage);
			request.setAttribute("oldOriginFileName", oldOriginFileName);
			request.setAttribute("oldSystemFileName", oldSystemFileName);
			
			super.setViewPage("/WEB-INF/admin/noticeUpdate_admin.jsp");
		} else {

			String message = "잘못된 접근입니다!";
			String loc = request.getContextPath() + "/index.tea";

			request.setAttribute("message", message);
			request.setAttribute("loc", loc);

			super.setViewPage("/WEB-INF/msg.jsp");
		}

	}

}
