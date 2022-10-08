package pca.cs.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

import common.controller.AbstractController;
import pca.cs.model.InterNoticeDAO;
import pca.cs.model.NoticeDAO;

public class NoticeUpdateEnd extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		String method = request.getMethod();

		String message;
		String loc;

		if ("post".equalsIgnoreCase(method)) {
			
			// MultipartRequest 객체 생성
	        MultipartRequest mtrequest = null;
	        
	        // 첨부파일 저장경로 설정
	        HttpSession session = request.getSession();
	        ServletContext svlCtx = session.getServletContext();
	        String uploadFileDir = svlCtx.getRealPath("/images");
	        
	        // 파일 업로드
	        try {
	            mtrequest = new MultipartRequest(request, uploadFileDir, 10*1024*1024, "UTF-8", new DefaultFileRenamePolicy());
	        } catch(IOException e) {
	            request.setAttribute("message", "업로드 경로 오류 또는 최대용량 10MB 초과로 파일업로드 실패하였습니다.");
	            request.setAttribute("loc", request.getContextPath()+"/cs/noticeUpdate.tea"); 

	            super.setViewPage("/WEB-INF/msg.jsp");
	            return;
	        }

	        // 글번호
			String noticeNo = mtrequest.getParameter("noticeNo");
			// 사진파일 서버상 파일명
	        String noticeImage = mtrequest.getFilesystemName("noticeImage");
	        
	        // 첨부파일 서버상 파일명
	        String systemFileName = mtrequest.getFilesystemName("noticeFile");

			// 첨부파일 업로드 당시 파일명
	        String originFileName = mtrequest.getOriginalFileName("noticeFile");
	        
	        // 제목
			String noticeSubject = mtrequest.getParameter("noticeSubject");
			
			// 내용
			String noticeContent = mtrequest.getParameter("noticeContent");
			noticeContent = noticeContent.replaceAll("<", "&lt;");
			noticeContent = noticeContent.replaceAll(">", "&gt;");
			noticeContent = noticeContent.replace("\r\n","<br>");
			Map<String, String> paraMap = new HashMap<>();
			paraMap.put("noticeNo", noticeNo);
			paraMap.put("noticeSubject", noticeSubject);
			paraMap.put("noticeContent", noticeContent);
			paraMap.put("noticeImage", noticeImage);
			paraMap.put("systemFileName", systemFileName);
			paraMap.put("originFileName", originFileName);
			
			InterNoticeDAO ndao = new NoticeDAO();
			int n = ndao.noticeUpdate(paraMap);

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

			message = "잘못된 접근입니다!";
			loc = request.getContextPath() + "/index.tea";

			request.setAttribute("message", message);
			request.setAttribute("loc", loc);

			super.setViewPage("/WEB-INF/msg.jsp");
		}

	}

}
