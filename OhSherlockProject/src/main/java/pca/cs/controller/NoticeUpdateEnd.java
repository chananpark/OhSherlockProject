package pca.cs.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.controller.AbstractController;
import pca.cs.model.InterNoticeDAO;
import pca.cs.model.NoticeDAO;

public class NoticeUpdateEnd extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		String method = request.getMethod();

		if ("post".equalsIgnoreCase(method)) {

			String noticeNo = request.getParameter("noticeNo");
			String noticeSubject = request.getParameter("noticeSubject");
			String noticeContent = request.getParameter("noticeContent");

			Map<String, String> paraMap = new HashMap<>();
			paraMap.put("noticeNo", noticeNo);
			paraMap.put("noticeSubject", noticeSubject);
			paraMap.put("noticeContent", noticeContent);
			
			InterNoticeDAO ndao = new NoticeDAO();
			int n = ndao.noticeUpdate(paraMap);

			String message;
			String loc;

			if (n == 1) {
				message = "공지사항 수정이 완료되었습니다.";
				loc = request.getContextPath() + "/cs/noticeDetail.tea?noticeNo="+noticeNo;

				request.setAttribute("message", message);
				request.setAttribute("loc", loc);

				super.setViewPage("/WEB-INF/msg.jsp");
			} else {
				message = "공지사항 수정을 실패하였습니다.";
				loc = request.getContextPath() + "/cs/notice.tea";

				request.setAttribute("message", message);
				request.setAttribute("loc", loc);

				super.setViewPage("/WEB-INF/msg.jsp");
			}

		} else { // get 방식 접근

			String message = "잘못된 접근입니다!";
			String loc = request.getContextPath() + "/index.tea";

			request.setAttribute("message", message);
			request.setAttribute("loc", loc);

			super.setViewPage("/WEB-INF/msg.jsp");
		}

	}

}
