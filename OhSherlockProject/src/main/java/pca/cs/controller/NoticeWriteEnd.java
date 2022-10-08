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

public class NoticeWriteEnd extends AbstractController {

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
	            request.setAttribute("loc", request.getContextPath()+"/cs/noticeWrite.tea"); 

	            super.setViewPage("/WEB-INF/msg.jsp");
	            return;
	        }
	        
	        // 사진파일 서버상 파일명
	        String noticeImage = mtrequest.getFilesystemName("noticeImage");
	        
	        // 첨부파일 서버상 파일명
	        String systemFileName = mtrequest.getFilesystemName("noticeFile");

			// 첨부파일 업로드 당시 파일명
	        String originFileName = mtrequest.getOriginalFileName("noticeFile");
	        
	        // 제목
			String subject = mtrequest.getParameter("subject");
			
			// 내용
			String content = mtrequest.getParameter("content");
			content = content.replaceAll("<", "&lt;");
			content = content.replaceAll(">", "&gt;");
			content = content.replace("\r\n","<br>");
			
			InterNoticeDAO ndao = new NoticeDAO();
			
			// 글번호 시퀀스 얻어오기
			String seq = ndao.getSeqNo();
			
			Map<String, String> paraMap = new HashMap<>();
			paraMap.put("seq", seq);
			paraMap.put("subject", subject);
			paraMap.put("content", content);
			paraMap.put("noticeImage", noticeImage);
			paraMap.put("systemFileName", systemFileName);
			paraMap.put("originFileName", originFileName);
			
			// 공지사항 글작성
			int n = ndao.registerNotice(paraMap);
			
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
				loc = request.getContextPath() + "/cs/notice.tea";
	
				request.setAttribute("message", message);
				request.setAttribute("loc", loc);
	
				super.setViewPage("/WEB-INF/msg.jsp");
			}
		}
		else { // get 방식 접근
			
			message = "잘못된 접근입니다!";
			loc = request.getContextPath() +  "/index.tea";
			
			request.setAttribute("message", message);
			request.setAttribute("loc", loc);

			super.setViewPage("/WEB-INF/msg.jsp");
		}

	}

}