package pca.cs.controller;

import java.io.File;
import java.io.FileInputStream;
import java.net.URLEncoder;
import java.sql.SQLException;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import common.controller.AbstractController;
import pca.cs.model.InterNoticeDAO;
import pca.cs.model.NoticeDAO;

public class FileDownload extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		String noticeNo = request.getParameter("noticeNo");

		try {
			HttpSession session = request.getSession();

			ServletContext svlCtx = session.getServletContext();
			// 클라이언트가 다운로드할 파일의 경로
			String uploadFileDir = svlCtx.getRealPath("/images");

			// 파일서버에 업로드된 첨부파일명 및 오리지널 파일명 알아오기
			InterNoticeDAO ndao = new NoticeDAO();
			Map<String, String> map = ndao.getFileName(noticeNo);

			String filePath = uploadFileDir + "\\" + map.get("systemFileName");

			// File 객체생성하기
			File file = new File(filePath);

			// MIME TYPE 설정하기
			String mimeType = svlCtx.getMimeType(filePath);

			if (mimeType == null) {
				mimeType = "application/octet-stream";
				// 일반적으로 잘 알려지지 않은 모든 종류의 이진 데이터
			}
			// 응답 객체의 타입을 해당 파일의 타입으로 설정한다.
			response.setContentType(mimeType);

			// 오리지널 파일명 알아와서 설정해주기
			String originFileName = map.get("originFileName");
			// map.get("prdmanual_orginFileName")은 파일을 업로드 할때 당시의 파일명임

			// 다운로드되는 파일의 encoding 및 파일명 설정
			String downloadFileName = "";
			String header = request.getHeader("User-Agent");

			if (header.contains("Edge")) {
				downloadFileName = URLEncoder.encode(originFileName, "UTF-8").replaceAll("\\+", "%20");
				response.setHeader("Content-Disposition", "attachment;filename=" + downloadFileName);
			} else if (header.contains("MSIE") || header.contains("Trident")) { // IE 11버전부터는 Trident로 변경됨.
				downloadFileName = URLEncoder.encode(originFileName, "UTF-8").replaceAll("\\+", "%20");
				response.setHeader("Content-Disposition", "attachment;filename=" + downloadFileName);
			} else if (header.contains("Chrome")) {
				downloadFileName = new String(originFileName.getBytes("UTF-8"), "ISO-8859-1");
				response.setHeader("Content-Disposition", "attachment; filename=" + downloadFileName);
			} else if (header.contains("Opera")) {
				downloadFileName = new String(originFileName.getBytes("UTF-8"), "ISO-8859-1");
				response.setHeader("Content-Disposition", "attachment; filename=" + downloadFileName);
			} else if (header.contains("Firefox")) {
				downloadFileName = new String(originFileName.getBytes("UTF-8"), "ISO-8859-1");
				response.setHeader("Content-Disposition", "attachment; filename=" + downloadFileName);
			}

			// 다운로드 요청 파일을 읽어서 클라이언트로 파일 전송하기

			// 1byte 기반 파일 입력 노드스트림 생성
			FileInputStream finStream = new FileInputStream(file);

			// 1byte 기반 파일 출력 노드스트림 생성
			ServletOutputStream srvOutStream = response.getOutputStream();
			// ServletOutputStream 은 바이너리 데이터를 웹 브라우저로 전송할 때 사용함.

			byte arrb[] = new byte[4096]; // 파일을 한번에 읽어오는 크기
			int data = 0;
			while ((data = finStream.read(arrb, 0, arrb.length)) != -1) {
				srvOutStream.write(arrb, 0, data); // 출력스트림에 써준다
			}

			// 쌓아둔것을 밖으로 내보낸다.
			srvOutStream.flush();

			srvOutStream.close();
			finStream.close();

		} catch (SQLException e) {
			e.printStackTrace();
			super.setRedirect(true);   
		    super.setViewPage(request.getContextPath()+"/error.tea");
		}

	}

}
