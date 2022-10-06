<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>

<style>
 div#activate_box, div#div_activateResult {
	width: 700px;
} 

/* 확인, 인증 버튼 */
div#btnSubmit>input, div#btnConfirm>input{
	width: 100%;
	padding: 12px;
	border: 1px solid gray;
	margin: 5px 0;
	opacity: 0.85;
	font-size: 17px;
	line-height: 20px;
}

div#btnConfirm>input:hover, div#btnSubmit>input:hover {
	opacity: 1;
}

/* 버튼 */
input[type='button'] {
	height: 45px;
	border-radius: 90px;
	background-color: #1E7F15;
	color: white;
	cursor: pointer;
}

#div_activateResult {
	text-align: center;
	font-size:14pt;
}

#date_div{
	background-color: #f9fef6;
	border-radius: 2%;
}

</style>


<script>

// 타이머 시간
let time = 60 * 5;

$(document).ready(function(){
	
	$("#spinner").hide();
	
	// 확인버튼 클릭시
   $("#btnActivate").click(function(){
	   $("#spinner").show();
		const frm = document.activateFrm;
		frm.action = "<%=ctxPath%>/login/activate.tea"; 
		// 메일을 보내주는 컨트롤러
		frm.method = "POST";
		frm.submit();
	});

	const method = "${requestScope.method}";
	// post 방식으로 접근한 경우
	 if(method == "POST"){
		// 결과부분 출력
	    $("div#div_activateResult").show();
	   
	    // 메일 발송 성공시
		if(${requestScope.sendMailSuccess == true}) {
			$("#spinner").hide();
			// 5분 타이머 함수
			const myTimer = () => {
			    
			        let minutes = parseInt(time / 60);
			        let seconds = time % 60;
	
			        minutes = minutes < 10 ? "0" + minutes : minutes;
			        seconds = seconds < 10 ? "0" + seconds : seconds;
	
			        $("#timer").text(minutes + ":" + seconds);
					
			        if (time-- < 0) {
			            alert("인증 시간이 초과되었습니다. 인증 메일을 다시 요청하세요.");
			            time = 60 * 5; // 타이머 시간 초기화
			            clearInterval(setTimer); // 타이머 삭제
			            $("#timer").empty();
				   	    $("div#div_activateResult").hide();
				   	 	$("div#div_activateResult>div.jumbotron").hide();
			            return;
			        }
				}
			
		   // 5분 타이머 시작
		   myTimer();
	       const setTimer = setInterval(myTimer, 1000);

        }
	 } 
	 
	 // get방식으로 접근한 경우 인증창 숨기기
	 else{
	     $("div#div_activateResult").hide();
	     $("div#div_activateResult>div.jumbotron").hide();
	     
	     if(${verifyFail eq true}) {
	    	 alert("인증코드가 다릅니다. 인증코드를 다시 발급받으세요.");
	    	 time = 60 * 5; // 타이머 시간 초기화
             clearInterval(setTimer); // 타이머 삭제
             $("#timer").empty();
	     }
	 }
	
	 // 인증하기 버튼 클릭시 인증코드 확인
	 $("#btnConfirmCode").click(function(){
		 const input_confirmCode = $("#input_confirmCode").val().trim();
		 
		 if(input_confirmCode != "")
		 	verifyCode();
		 else
			 alert("인증코드를 입력하세요!");
	 });
	 
   
});


function verifyCode(){
	
    const frm = document.authFrm;
    
 	// 입력한 인증코드를 히든폼에 넣어준다.
    frm.userAuthentiCode.value = $("input#input_confirmCode").val(); 
    
	// 히든폼의 데이터를 전송	 	
    frm.action = "<%=ctxPath%>/login/verifyCode.tea"; 
    frm.method = "POST";
    frm.submit();

    }


</script>

<div class="container">
	<div id="activate_box" class="d-flex flex-column m-auto">
		<div id="activate_title">
			<h2 style="text-align: center; font-size: 30px; line-height: 40px; font-weight: bold;"> 휴면 해제</h2>
		</div>

		<div class="jumbotron mt-2">
			<p><span class="h4 font-weight-bold" style="color:#1E7F15">${userid}</span> 회원님은 현재 휴면상태입니다.</p>
			<div id="date_div" class="px-4 pt-3 pb-1 mb-3 font-weight-bold">
				<p>마지막 접속일: ${last_login_date}</p>
				<p>휴면 전환일: ${idleDate}</p>
			</div>
			
			<p>휴면 해제를 위해서는 본인인증이 필요합니다.</p>
			<p>가입 시 등록하신 이메일(<span class="font-weight-bold" style="color:#1E7F15">${email}</span>)로 인증코드가 발송됩니다.</p>
			<div id="btnSubmit" class="d-flex flex-column">
				<input type="button" class="btn" value="확인" id="btnActivate" />
			</div>
			
			<div id="spinner" class="row justify-content-center mt-4 mb-0"><span class="spinner-border text-success"></span></div>
		</div>
	</div>
				
	<form name="activateFrm">
			<input type="hidden" name="userid" value="${userid}"/>	
			<input type="hidden" name="email" value="${email}"/>	
			<input type="hidden" name="last_login_date" value="${last_login_date}"/>	
			<input type="hidden" name="idleDate" value="${idleDate}"/>	
	</form>
			
	<div id="div_activateResult" class="d-flex flex-column m-auto">
		<div class="jumbotron mt-2">
			<%-- 메일 발송 성공 시 --%>
			<c:if test="${requestScope.sendMailSuccess eq true}">
				<span style="font-size:11pt">인증코드가 ${email}로 발송되었습니다.</span>
				<br>
				<span style="font-size:11pt">인증코드를 입력해주세요.</span>
				<span id="timer" class="text-danger font-weight-bold"></span>

				<br>
				<input type="text" name="input_confirmCode" id="input_confirmCode" class="mt-3" required />
				
				<div id="btnConfirm" class="d-flex flex-column mt-3">
					<input type="button" class="btn" id="btnConfirmCode" value="인증하기" />
				</div>
			</c:if>
			<%-- 메일 발송 실패 시 --%>
			<c:if test="${requestScope.sendMailSuccess eq false}">
				<span class="text-danger text-center">메일 발송이 실패하였습니다.</span>
				<br>
			</c:if>
		</div>
	</div>
		
</div>

<%-- 인증하기 form  --%>
<form name="authFrm">
	<%-- 위의 form 은 get 방식이기 때문에 히든 폼을 post 방식으로 보내준다. --%>
	<input type="hidden" name="userid" value="${userid}"/> 
	<input type="hidden" name="email" value="${email}"/>	
	<input type="hidden" name="last_login_date" value="${last_login_date}"/>	
	<input type="hidden" name="idleDate" value="${idleDate}"/>	
	<input type="hidden" name="userAuthentiCode" />
	<%-- 사용자가 입력한 코드 받아오기, 받아서 인증하기 form을 넘겨줄 것이다. --%>
</form>

<%@ include file="../footer.jsp"%>