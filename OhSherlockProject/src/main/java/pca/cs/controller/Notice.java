package pca.cs.controller;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.controller.AbstractController;
import common.model.NoticeVO;
import pca.cs.model.InterNoticeDAO;
import pca.cs.model.NoticeDAO;

public class Notice extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		InterNoticeDAO ndao = new NoticeDAO();
		
		List<NoticeVO> noticeList = new ArrayList<>();
		noticeList = ndao.showNoticeList();
		
		if (noticeList.size() > 0) {
			request.setAttribute("noticeList", noticeList);
		}
		
		/*
		 * Date now = new Date(); SimpleDateFormat df = new
		 * SimpleDateFormat("yyyyMMdd"); String nowDate = df.format(now); // 현재날짜
		 */		
		
		super.setViewPage("/WEB-INF/cs/notice.jsp");
		
	}

}
