<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>    
    
<style>

	/* 공지사항 입력 css 외부에서 받아온 것 */ 
	#ntUpdate input[type=text], #ntUpdate select, #ntUpdate textarea {
		width: 100%;
		padding: 12px;
		border: 1px solid #ccc;
		border-radius: 4px;
		box-sizing: border-box;
		margin-top: 6px;
		margin-bottom: 16px;
		resize: vertical;
	}

	input[type="button"]  {
		width: 80px; 
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

<script>
	$(document).ready(()=>{
		
		$("#updateBtn").click(()=>{
			
			const noticeSubject = $("#noticeSubject").val().trim();
			const noticeContent = $("#noticeContent").val().trim();
			
			if (noticeSubject == ""){
				alert("제목을 입력하세요!");
				return;
			}
			
			if (noticeContent == ""){
				alert("내용을 입력하세요!");
				return;
			}
				
			const frm = document.ntUpdate;
			frm.enctype="multipart/form-data";
			frm.action="<%=ctxPath%>/cs/noticeUpdateEnd.tea";
	    	frm.method="POST";
	    	frm.submit();
		});
	});

	function goCancel(){
		const doCancle = confirm("공지사항 수정을 취소하시겠습니까?");
		if(doCancle){
			alert("공지사항 수정을 취소하셨습니다.");
			location.href="javascript:history.back()";
		}
	}
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
   
    <h5 style="font-weight: bold;">게시글 수정하기</h5>
    <hr>
   
   
    <form action="" name="ntUpdate" id="ntUpdate">
    	<input type="hidden" name="noticeNo" value="${noticeNo}"/>
    	<input type="hidden" name="oldNoticeImage" value="${oldNoticeImage}"/>
    	<input type="hidden" name="oldOriginFileName" value="${oldOriginFileName}"/>
    	<input type="hidden" name="oldSystemFileName" value="${oldSystemFileName}"/>
		<label for="noticeSubject">제목<span class="text-danger">*</span></label>
		<input type="text" id="noticeSubject" name="noticeSubject" value="${noticeSubject}">
		
		<label for="noticeContent">내용<span class="text-danger">*</span></label>
		<textarea id="noticeContent" name="noticeContent" style="height:200px">${noticeContent}</textarea>

		<label for="file" style="margin: 6px 20px 16px 0;">사진 첨부</label><input type="file" name="noticeImage">
		<br>
		<c:if test="${not empty oldNoticeImage}">
		<input type="checkbox" name="deleteImg" id="deleteImg"><label for ="deleteImg">&nbsp;기존 첨부 사진(${oldNoticeImage}) 삭제하기</label>
		<br>
		</c:if>
		<label for="file" style="margin: 6px 20px 16px 0;">파일 첨부</label><input type="file" name="noticeFile">		
		<br>
		<c:if test="${not empty oldOriginFileName}">
		<input type="checkbox" name="deleteFile" id="deleteFile"><label for ="deleteFile">&nbsp;기존 첨부 파일(${oldOriginFileName}) 삭제하기</label>
		</c:if>
		<hr>
		
		<div class="text-right" style="margin-top: 30px;">
			<input class="rounded" type="button" value="취소" onclick="goCancel();" style="margin-right:0"/>&nbsp;
		   	<input class="rounded btn-secondary" type="button" id="updateBtn" value="수정" style="margin-left: 5px;" />
		</div>
	</form>
	
</div>

<%@ include file="../footer.jsp"%>