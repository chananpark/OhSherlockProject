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
	
	#inquiry .writeBtns  {
      width: 80px; 
      margin: 15px; 
      border-style: none; 
      height: 30px;
      font-size: 14px;
   }
   
   #inquiry .btn-secondary:hover {
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

	#inquiry #inquiryFrm {
		padding: 3%;
	}

</style>       
    
<script>
	
	$(document).ready(()=>{
		
		$("#btnSubmit").click(()=>{
			const frm = document.inquiryFrm;
			
			const inquiry_type = $("select[id='inquiry_type']").val();
			
			if(inquiry_type == ""){
				alert("문의유형을 선택하세요!");
				return;
			}
			
			if($("#inquiry_subject").val().trim() == ""){
				alert("제목을 입력하세요!");
				return;
			}
			
			if($("#inquiry_content").val().trim() == ""){
				alert("문의 내용을 입력하세요!");
				return;
			}
			
			frm.action="<%=ctxPath%>/cs/inquiry.tea";
			frm.method="post";
			frm.submit();
			
		});
		
		$("#btnCancel").click(()=>{
			const doCancle = confirm("1:1 문의 작성을 취소하시겠습니까?");
			if(doCancle){
				alert("1:1 문의 작성을 취소하셨습니다.");
				location.href="javascript:history.back()";
			}
		});
		
	});
	
</script>

<div class="container" id="inquiry">

	<div class="titleZone row">
		<h2 class="col text-left" style="font-weight: bold">1:1 문의</h2>
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
	
	<form action="" name="inquiryFrm" id="inquiryFrm">
		<label for="inquiry_type">문의유형<span class="text-danger">*</span></label>
		<select id="inquiry_type" name="inquiry_type">
			<option value="">문의유형을 선택해주세요</option>
			<option value="product">상품문의</option>
			<option value="delivery">배송문의</option>
			<option value="coin_point">예치금/적립금</option>
			<option value="cancle">취소/환불/교환</option>
			<option value="member">회원</option>
			<option value="others">기타</option>
		</select>
	
		<label for="inquiry_subject">제목<span class="text-danger">*</span></label>
		<input type="text" id="inquiry_subject" name="inquiry_subject" placeholder="제목을 입력하세요.">
		
		<label for="inquiry_content">문의 내용<span class="text-danger">*</span></label>
		<textarea id="inquiry_content" name="inquiry_content" placeholder="문의 내용을 입력하세요." style="height:200px"></textarea>
		
		<%--
		<label for="photo" style="margin: 6px 20px 16px 0;">사진 첨부</label><input type="file" id="photo" name="photo">
		<br>
		--%>
		<hr>
		
		<input type="checkbox" id="inquiry_email" name="inquiry_email"/>
		<label for="inquiry_email" style="margin-top: 16px;">답변 완료 시 이메일로 받으시겠습니까?<span>&nbsp;(이메일: ${loginuser.email })</span></label>
		<br>
		
		<input type="checkbox" id="inquiry_sms" name="inquiry_sms"/>
		<label for="inquiry_sms">답변 완료 시 SMS로 받으시겠습니까?<span>&nbsp;(연락처: ${loginuser.mobile })</span></label>
		
		<div class="text-right" style="margin-top: 30px;">
	    	<input type="button" class="writeBtns" id="btnCancel" value="취소" style="margin-right: 0" />&nbsp;
	      	<input type="button" class="btn-secondary writeBtns" id="btnSubmit" value="등록" style="margin-left: 5px;" />
   		</div>
	</form>
	

</div>

<%@ include file="../footer.jsp"%>