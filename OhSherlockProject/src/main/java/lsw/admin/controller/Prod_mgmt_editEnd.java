package lsw.admin.controller;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

import common.controller.AbstractController;
import common.model.ProductVO;
import lsw.admin.model.InterProductDAO;
import lsw.admin.model.ProductDAO;

public class Prod_mgmt_editEnd extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		String method = request.getMethod(); // "GET" 또는 "POST"
		HttpSession session = request.getSession();
		
		if("POST".equalsIgnoreCase(method)) {
			// 수정 확인 버튼을 눌러서 post를 했다라면
			MultipartRequest mtrequest = null;// request기능에 더해서 파일 업로드 다운로드 기능을 할 수 있다.
			
			ServletContext svlCtx = session.getServletContext();
			String uploadFileDir = svlCtx.getRealPath("/images");
			System.out.println("=== 첨부되어지는 이미지 파일이 올라가는 절대경로 uploadFileDir ==> " + uploadFileDir); 
			
			// === 파일을 업로드 해준다. ===
			
			try {
				mtrequest = new MultipartRequest(request, uploadFileDir, 10*1024*1024, "UTF-8", new DefaultFileRenamePolicy()); // 같은 파일 이름을 가졌을경우 중복 방지를 위해서 숫자를 생성해줌. 
			}catch (IOException e) {
				request.setAttribute("message", "업로드 되어질 경로가 잘못되었거나 또는 최대용량 10MB를 초과했으므로 파일업로드 실패함!!");
	            request.setAttribute("loc", request.getContextPath()+"/admin/prod_mgmt_register.tea"); 
	              
	            super.setViewPage("/WEB-INF/msg.jsp");
	            return; // 종료
			}
				
			int pnum = Integer.parseInt(mtrequest.getParameter("pnum")) ;
			String fk_cnum = mtrequest.getParameter("fk_cnum");
			String pname = mtrequest.getParameter("pname");
			
			String pimage = mtrequest.getFilesystemName("pimage");
		
		    String pqty = mtrequest.getParameter("pqty");
            String price = mtrequest.getParameter("price");
            String saleprice = mtrequest.getParameter("saleprice");
            String fk_snum = mtrequest.getParameter("fk_snum");
            
           // !!!! 크로스 사이트 스크립트 공격에 대응하는 안전한 코드(시큐어코드) 작성하기 !!!! // 
           String psummary = mtrequest.getParameter("psummary");
           psummary = psummary.replaceAll("<", "&lt;");
           psummary = psummary.replaceAll(">", "&gt;");
           psummary = psummary.replaceAll("\r\n", "<br>");
           
           // !!!! 크로스 사이트 스크립트 공격에 대응하는 안전한 코드(시큐어코드) 작성하기 !!!! // 
           String pcontent = mtrequest.getParameter("pcontent");
           pcontent = pcontent.replaceAll("<", "&lt;");
           pcontent = pcontent.replaceAll(">", "&gt;");
           pcontent = pcontent.replaceAll("\r\n", "<br>");
           
           String point = mtrequest.getParameter("point");
           
           InterProductDAO pdao = new ProductDAO();
           
           ProductVO pvo = new ProductVO(); 
           pvo.setFk_cnum(Integer.parseInt(fk_cnum));

           if(!fk_snum.trim().isEmpty()) {
              pvo.setFk_snum(Integer.parseInt(fk_snum));
           }
           pvo.setPnum(pnum);
           pvo.setPname(pname);
           pvo.setPsummary(psummary);
           pvo.setPcontent(pcontent);
           pvo.setPqty(Integer.parseInt(pqty));
           pvo.setPrice(Integer.parseInt(price));
           pvo.setSaleprice(Integer.parseInt(saleprice));
           pvo.setPoint(Integer.parseInt(point));
           pvo.setPimage(pimage);
           
           String message = "";
           String loc = "";
           
           try {
	           // tbl_product 테이블에 제품정보 insert 하기
	           pdao.productUpdate(pvo);
	           
	           // === 추가이미지파일이 있다라면 tbl_product_imagefile 테이블에 제품의 추가이미지 파일명 insert 해주기 === //
	           String str_attachCount = mtrequest.getParameter("attachCount");
	           // str_attachCount 이 추가이미지 파일의 개수이다. "" "0"~"10" 이 들어온다.
	           
	           int attachCount = 0;
	           
	           if(!"".equals(str_attachCount)) {
	        	   attachCount = Integer.parseInt(str_attachCount);
	           }
	           
	           // 첨부파일의 파일명(파일서버에 업로드 되어진 실제파일명) 알아오기
	           for(int i=0; i<attachCount; i++) {
	        	   String attachFileName = mtrequest.getFilesystemName("attach"+i);
	        	   
	        	   pdao.product_imagefile_Insert(pnum, attachFileName);
	        	   							  // pnum 은 위에서 채번해온 제품번호이다.

	           }// end of for -----------
	           
	       //  *** 현재 페이지를 돌아갈 페이지(goBackURL)로 주소 지정하기 *** //
				String goBackURL = request.getParameter("goBackURL");
		//		System.out.println("확인용 : " + goBackURL); 

			   request.setAttribute("goBackURL", goBackURL); // 공백이 있는 상태 그대로 전달해준다.
			   
	           message = "제품수정 성공!!";
	           loc = request.getContextPath()+"/admin/prod_mgmt_list.tea";
	           
           }catch(SQLException e) {
        	   e.printStackTrace();
        	   message = "제품수정 실패!!";
	           loc = request.getContextPath()+"/admin/prod_mgmt_edit.jsp";
           }
           request.setAttribute("message", message);
           request.setAttribute("loc", loc);
           
           // super.setRedirect(false);
           super.setViewPage("/WEB-INF/msg.jsp");
		}
		else {
			// POST 방식이 아니라면
			
			String message = "비정상적인 경로로 접근했습니다!!";
	        String loc = "javascript:history.back()";
	         
	        request.setAttribute("message", message);
	        request.setAttribute("loc", loc);
	         
	     // super.setRedirect(false);  
	        super.setViewPage("/WEB-INF/msg.jsp");
						
		}
		
	}

}
