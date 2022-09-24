<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>    
    
<style>

	.listView {
		width: 90px; 
		margin: 15px; 
		border-style: none; 
		height: 30px;
		font-size: 14px;
	}
	
	.btn-secondary:hover {
		border: 2px none #1E7F15;
		background-color: #1E7F15;
	    color: white;
	}
	
</style>       
    
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
      <div style="font-weight: bold; font-size: 20px;">${noticeDetail.noticeSubject}</div><br>
      	<div class="row">
	      <div class="col" style="font-weight: normal; font-size: 15.5px; margin-bottom: 10px;"><fmt:formatDate pattern="yyyy.MM.dd" value="${noticeDetail.noticeDate}"/></div>
	      <div class="col text-right" style="font-weight: normal; font-size: 15.5px; margin-bottom: 10px;">조회수: ${noticeDetail.noticeHit}</div>
    	</div>
    </div>
    
	<%-- 글수정, 삭제 버튼은 관리자 계정에서만 보임 --%>

    <hr style="border-top: solid 1.2px black">
    <div class="text-right" id="noticeFiles">
	    <c:if test="${not empty noticeDetail.noticeFile}">
	    	첨부파일: ${noticeDetail.noticeFile}
	    </c:if>
	    <c:if test="${empty noticeDetail.noticeFile}">
	    	&nbsp;
	    </c:if>
    </div>
    
    <div class="col text-left">
      <div style="font-size: 20px;">
	      ${noticeDetail.noticeContent}
	  </div>
    </div>
	
  	<div class="text-right" style="display: block; margin-top: 30px;"> 
	  <a href="<%=ctxPath%>/cs/notice.tea"><input type="button" class="btn-secondary listView" value="목록보기" /></a>
    </div>
	
	
</div>

<%@ include file="../footer.jsp"%>