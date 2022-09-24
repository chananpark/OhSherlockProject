package pca.cs.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import common.controller.AbstractController;
import common.model.MemberVO;
import common.model.NoticeVO;
import pca.cs.model.InterNoticeDAO;
import pca.cs.model.NoticeDAO;

public class NoticeDetail extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		String noticeNo = request.getParameter("noticeNo");
		
		HttpSession session = request.getSession();
		MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
		
		InterNoticeDAO ndao = new NoticeDAO();

		NoticeVO noticeDetail = ndao.showNoticeDetail(noticeNo, loginuser);
		
		if (noticeDetail != null) {
			request.setAttribute("noticeDetail", noticeDetail);
		}

		super.setViewPage("/WEB-INF/cs/notice_detail.jsp");

	}

}
