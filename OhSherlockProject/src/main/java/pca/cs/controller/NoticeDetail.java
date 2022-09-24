package pca.cs.controller;

import java.util.HashMap;
import java.util.Map;

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
		String userid = loginuser!=null? loginuser.getUserid(): "notLogined";
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("noticeNo", noticeNo);
		paraMap.put("userid", userid);
		
		InterNoticeDAO ndao = new NoticeDAO();

		NoticeVO nvo = ndao.showNoticeDetail(paraMap);
		
		if (nvo != null) {
			request.setAttribute("nvo", nvo);
		}

		super.setViewPage("/WEB-INF/cs/notice_detail.jsp");

	}

}
