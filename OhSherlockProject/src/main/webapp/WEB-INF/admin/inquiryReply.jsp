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

.inquiryContent {
	border: 1px solid gray;
	border-radius: 1%;
	min-height: 150px;
	max-height: 250;
	overflow: auto;
	background-color: white;
}

#inquiryText, #replyText {
	display: inline-block;
	background-color: #1E7F15;
	color: white;
}

#replyTitle td {
	/* border: 1px solid black; */
	padding: 10px 30px;
	width: 100%;
	background-color: #999999;
	color: white
}

.btn-secondary {
	border-style: none;
}

.btn-secondary:hover {
	background-color: #1E7F15;
	color: white;
}

</style>

<script>

	let mobile;

	$(()=>{

		
		$("#replyBtn").click(()=>{
			if ($("#inquiry_reply_content").val().trim() == ""){
				alert("답변을 작성하세요!");
				$("#inquiry_reply_content").focus();
				return;
			}
			const bool = confirm('1:1 문의 답변을 등록하시겠습니까?');
			
			if (bool) {
				const inquiry_no = '${ivo.inquiry_no}';
				const inquiry_reply_content = $('#inquiry_reply_content').val();
				
				// 답변 등록
				$.ajax({
					url:"<%=ctxPath%>/cs/inquiryReply.tea",
					type:"post",
					data:{"inquiry_no":inquiry_no, "inquiry_reply_content":inquiry_reply_content},
					dataType:"JSON",
					success:function(json){
						if(json.success){ // 답변 등록 성공
							alert("1:1 문의 답변 등록 완료");
						
		  	         		// 이메일 발송을 요청하였으면
		  	         		if (${ivo.inquiry_email == 1}){
		  	         			$('#myModal').modal('show');
		  	         			sendMailAlert();
		  	         		} 
		  	         		// 문자 발송만 요청하였으면
		  	         		else if (${ivo.inquiry_sms == 1}) {
		  	         			$('#myModal').modal('show');
			         			sendSMSAlert();
		  	  	         	}
		  	         		// 알림을 요청하지 않았으면
		  	         		else {
		  	         			// 페이지 새로고침
		  	  	         		location.href="javascript:location.reload(true)";
		  	         		}
						}
					},
					error: function(request, status, error){
			            alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			        }
				});
			} else {
				alert("1:1 문의 답변 작성을 취소하셨습니다.");
				return;
			}
		});
		
		$("#showList").click(()=>{
			const goBackURLInquiry = sessionStorage.getItem("goBackURLInquiry");
			location.href="<%=ctxPath%>"+goBackURLInquiry;
		});
		
	});
	
	// 메일 알림 보내기
	function sendMailAlert() {
		
		const userid = '${ivo.fk_userid}';
		const inquiry_subject = '${ivo.inquiry_subject}';
		
		$.ajax({
			url:"<%=ctxPath%>/cs/sendMailAlert.tea",
			type:"post",
			data:{"userid":userid, "inquiry_subject":inquiry_subject},
			dataType:"JSON",
			success:function(json){
				if(json.success){
					// 문자 발송도 요청하였으면
  	         		if (${ivo.inquiry_sms == 1}) {
	         			sendSMSAlert();
  	  	         	} else {
  	  	         		// 페이지 새로고침
  	  	         		location.href="javascript:location.reload(true)";
  	  	         	}
				}
			},
			error: function(request, status, error){
	            alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
	        }
		});
	}
	
	// 핸드폰 알림 보내기
	function sendSMSAlert() {
		
		const userid = '${ivo.fk_userid}';
		
		const smsContent = '[오!셜록] 고객님의 1:1 문의 [${ivo.inquiry_subject}]에 답변이 등록되었습니다.';
		$.ajax({
			url:"<%=ctxPath%>/cs/sendSMSAlert.tea",
			type:"post",
			data:{"userid":userid, "smsContent":smsContent},
			dataType:"JSON",
			success:function(json){
					// 페이지 새로고침
	  	         	location.href="javascript:location.reload(true)";
			},
			error: function(request, status, error){
	            alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
	        }
		});
	}
</script>

<div class="container">

	<%-- 관리자가 사용자의 1:1문의에 댓글을 달아주는 페이지입니다.--%>

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

	<div class="col text-left">
		<div style="font-weight: bold; font-size: 20px;">${ivo.inquiry_subject}</div>
		<br>
		<div style="font-weight: normal; font-size: 15.5px; margin-bottom: 10px;">${ivo.inquiry_date}</div>
	</div>

	<div class="col text-left inquiryContent jumbotron mt-4 pt-4">
	<p class="text-right">작성자: ${ivo.fk_userid}</p>
	<hr>
	<p class="mt-4">${ivo.inquiry_content}</p>
	</div>

	<%-- 미답변시 답변작성 페이지 --%>
	<c:if test="${empty ivo.irevo}">
		<label class="mt-4" for="reply">답변<span class="text-danger">*</span></label><br>
		<textarea id="inquiry_reply_content" name="inquiry_reply_content" placeholder="답변은 한 번 작성하면 수정/삭제가 불가하니 신중하게 작성하시기 바랍니다." style="height:200px; width:100%; padding:2%;"></textarea>
	
		<div class="text-right" style="display: block; margin-top: 30px;">
			<input type="button" id="replyBtn" class="btn-secondary writeReply py-2 px-3 rounded" value="답변작성" />
		</div>
	</c:if>
	
	<%-- 답변완료시 답변확인 페이지 --%>
	<c:if test="${not empty ivo.irevo}">
	
		<div class="col text-left pt-4">
		<div style="font-weight: bold; font-size: 20px;">RE:&nbsp;${ivo.inquiry_subject}</div>
		<br>
		<div
			style="font-weight: normal; font-size: 15.5px; margin-bottom: 10px;">${ivo.irevo.inquiry_reply_date}</div>
		</div>

		<div class="col text-left inquiryContent jumbotron mt-4">
		${ivo.irevo.inquiry_reply_content}
		</div>	
		
	  	<div class="text-right" style="display: block; margin-top: 30px;"> 
	    <input type="button" id="showList" class="btn-secondary listView rounded" value="목록보기" />
        </div>
	</c:if>

	<%-- 알림 전송 표시 모달 --%>
	<div class="modal fade" id="myModal">
		<div class="modal-dialog">
			<div class="modal-content">

				<div class="modal-body">고객에게 답변 알림 전송 중..</div>
			</div>
		</div>
	</div>
</div>

<%@ include file="../footer.jsp"%>