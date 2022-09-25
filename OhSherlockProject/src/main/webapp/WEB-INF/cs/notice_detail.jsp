<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>    
    
<style>

	input[type="button"] {
		border-style: none;
	}

	.listView {
		width: 90px; 
		margin: 15px; 
		border-style: none; 
		height: 30px;
		font-size: 14px;
	}
	
	.btn-secondary:hover {
		background-color: #1E7F15;
	    color: white;
	}
	
</style>     

<script>

	$(document).ready(()=>{
		const frm = document.noticeFrm;
		
		// 글 수정
		$("#noticeUpdate").click(()=>{
			frm.action="<%=ctxPath%>/cs/noticeUpdate.tea";
	    	frm.method="POST";
	    	frm.submit();
		});
		
		// 글 삭제
		$("#noticeDelete").click(()=>{
			const bool = confirm("정말로 삭제하시겠습니까?");
			
			if(bool){
		    	frm.action="<%=ctxPath%>/cs/noticeDelete.tea";
		    	frm.method="POST";
		    	frm.submit();
			}
			else
				return;
		});
	});
	
</script>  
    
<div class="container">

	<div class="titleZone row">
      <h2 class="col text-left" style="font-weight:bold">공지사항</h2><br>
      <div class="col text-right">
         <span style="font-weight: bold; font-size: 20px;">02-336-8546</span><br>
         <span style="font-weight: normal; font-size: 15.5px;">평일 09:30 ~ 18:00 (점심시간 12:30 ~ 13:30)<br>주말 및 공휴일 휴무</span>
       </div>
    </div>
    <hr style="background-color: black; height: 1.2px;"><br>
   
	    <div class="col text-left">
	      <div style="font-weight: bold; font-size: 20px;">${nvo.noticeSubject}</div><br>
	      	<div class="row">
		      <div class="col" style="font-weight: normal; font-size: 15.5px; margin-bottom: 10px;"><fmt:formatDate pattern="yyyy.MM.dd" value="${nvo.noticeDate}"/></div>
		      <div class="col text-right" style="font-weight: normal; font-size: 15.5px; margin-bottom: 10px;">조회수: ${nvo.noticeHit}</div>
	    	</div>
	    </div>
	
	    <hr style="border-top: solid 1.2px black">
	    
	    <div class="col text-left">
	      <div style="font-size: 17px; padding: 15px 0;">${nvo.noticeContent}</div>
	    </div>
	    
   <form name="noticeFrm" >
	    <input type="hidden" name="noticeNo" value="${nvo.noticeNo}"/>
	    <input type="hidden" name="noticeSubject" value="${nvo.noticeSubject}"/>
	    <input type="hidden" name="noticeContent" value="${nvo.noticeContent}"/>
    </form>
    
	<%-- 글수정, 삭제 버튼은 관리자 계정에서만 보임 --%>
	<c:if test="${sessionScope.loginuser ne null and loginuser.userid eq 'admin' }">
		<div class="text-right" style="margin-top: 30px;">
		   <input type="button" class="rounded" id="noticeUpdate" value="수정" style="margin-right: 0" />&nbsp;
		   <input type="button" class="btn-secondary rounded" id="noticeDelete" value="삭제" style="margin-left: 5px;" />
		</div>
	</c:if>	
	
    <hr style="border-top: solid 1.2px black">
  	<div class="text-right" style="display: block; margin-top: 30px;"> 
	  <a href="<%=ctxPath%>/cs/notice.tea"><input type="button" class="btn-secondary listView rounded" value="목록보기" /></a>
    </div>
	
</div>


<%@ include file="../footer.jsp"%>