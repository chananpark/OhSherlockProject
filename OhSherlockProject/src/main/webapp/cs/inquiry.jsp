<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>    
    
<style>

	* {box-sizing: border-box;}
	
	/* 문의 입력 css 외부에서 받아온 것 */ 
	#inquiry input[type=text], #inquiry select, #inquiry textarea {
	  width: 100%;
	  padding: 12px;
	  border: 1px solid #ccc;
	  border-radius: 4px;
	  box-sizing: border-box;
	  margin-top: 6px;
	  margin-bottom: 16px;
	  resize: vertical;
	}
	
	.writeBtns  {
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
	
	#inquiry input[type=submit]:hover {
	  background-color: #45a049;
	}
	
	#inquiry .container {
	  border-radius: 5px;
	  padding: 20px;
	}

	#inquiry #qnaFrm {
		padding: 3%;
	}

</style>       
    
<div class="container" id="inquiry">

	<div class="titleZone row">
		<h2 class="col text-left" style="font-weight: bold">1:1문의</h2>
		<br>
		<div class="col text-right">
			<span style="font-weight: bold; font-size: 20px;">02-336-8546</span><br>
			<span style="font-weight: normal; font-size: 15.5px;">평일 09:30
				~ 18:00 (점심시간 12:30 ~ 13:30)<br>주말 및 공휴일 휴무
			</span>
		</div>
	</div>
	<hr style="background-color: black; height: 1.2px;">
	<br>
	
	<div class="bg-light" style="padding: 3%;">
		문의사항을 남겨주시면 빠른 시간내에 답변을 드리도록 하겠습니다.
		<br><br>
		· 이메일, 핸드폰번호를 변경하려면 회원정보수정 페이지에서 변경해주세요.<br>
		· 문의하시기 전 FAQ를 참고해주세요.<br>
		· 한번 등록한 상담내용은 수정이 불가능합니다.<br>
		· 수정을 원하시는 경우 삭제 후 재등록하셔야 합니다.<br>
		· 고객상담센터 답변가능시간 오전 9시~오후 6시(토/일/공휴일 제외)
	</div>
	
	<form action="" name="qnaFrm" id="qnaFrm">
		<label for="qnatype">문의유형<span class="text-danger">*</span></label>
		<select id="qnatype" name="qnatype">
			<option value="australia">회원/포인트</option>
			<option value="canada">취소/환불/교환</option>
			<option value="usa">기타</option>
		</select>
	
		<label for="title">제목<span class="text-danger">*</span></label>
		<input type="text" id="title" name="title" placeholder="제목을 입력하세요.">
		
		<label for="content">내용<span class="text-danger">*</span></label>
		<textarea id="content" name="content" placeholder="문의 내용을 입력하세요." style="height:200px"></textarea>
		
		<label for="photo" style="margin: 6px 20px 16px 0;">사진 첨부</label><input type="file" id="photo" name="photo">
		<br>
		
		<hr>
		
		<input type="checkbox" id="answer_email" name="answer_email" />
		<label for="answer_email" style="margin-top: 16px;">답변 완료 시 이메일로 받으시겠습니까?<span>(이메일: hello@gmail.com)</span></label>
		<br>
		
		<input type="checkbox" id="answer_sms" name="answer_sms" />
		<label for="answer_sms" >답변 완료 시 SMS로 받으시겠습니까?<span>(연락처: 010-1234-1234)</span></label>
		
		<div class="text-right" style="margin-top: 30px;">
	    	<input type="button" class="writeBtns" value="취소" style="margin-right: 0" />&nbsp;
	      	<input type="button" class="btn-secondary writeBtns" value="등록" style="margin-left: 5px;" />
   		</div>
	</form>
	

</div>

<%@ include file="../footer.jsp"%>