<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>


<style>
div#activate_box {
	width: 380px;
}

/* 이름, 이메일 박스랑 확인 버튼 */
div#input_activate>input, div#btnSubmit>input {
	width: 100%;
	padding: 12px;
	border: 1px solid gray;
	margin: 5px 0;
	opacity: 0.85;
	font-size: 17px;
	line-height: 20px;
}

div#input_activate>input:hover, div#btnSubmit>input:hover {
	opacity: 1;
}

div#input_activate>input {
	border-radius: 4px;
}

/* 확인 버튼 */
div#btnSubmit>input[type='button'] {
	height: 45px;
	border-radius: 90px;
	background-color: #1E7F15;
	color: white;
	cursor: pointer;
}

#div_activateResult {
	text-align: center;
}
</style>


<script>

// 타이머 시간
let time = 60 * 5;

$(document).ready(function(){
	$("span.error").hide();
	
	$("input#email").blur( (e)=>{
		
		const $target = $(e.target);
		
        // 이메일 정규표현식 
		const regExp = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i;  
        
        const bool = regExp.test($target.val());
		
		if(!bool) {
			// 이메일이 정규표현식에 위배된 경우  
			$("input").prop("disabled", true);
			$target.prop("disabled", false);
			
		    $target.parent().find("span.error").show();
			$target.focus();
		}
		else {
			// 이메일이 정규표현식에 맞는 경우 
			$("input").prop("disabled", false);			
		    $target.parent().find("span.error").hide();
		}
		
	});
   
   $("input#btnActivate").click(function(){
      
      const useridVal = $("input[name='userid']").val().trim();
      const emailVal = $("input[name='email']").val().trim();
      const nameVal = $("input[name='name']").val().trim();

      if(useridVal != "" && emailVal != ""){
			const frm = document.activateFrm;
			frm.action = "<%=ctxPath%>/login/activate.tea"; 
			// 메일을 보내주는 컨트롤러
			frm.method = "POST";
			frm.submit();
		} else {
	      // 올바르게 입력하지 않은 경우
	      alert("정보를 모두 입력하세요!");
	      return;
	   } 
	});


	const method = "${requestScope.method}";
	// post 방식으로 접근한 경우
	 if(method == "POST"){
	     // input에 입력한 userid, 이름, email 그대로 유지
		$("input#userid").val("${requestScope.userid}"); 
		$("input#email").val("${requestScope.email}");
		$("input#name").val("${requestScope.name}");
	
	   // 인증코드 발송되었다는 문구 출력
	    $("div#div_activateResult").show();
	   
	   // 메일 발송 성공시
	   if(${requestScope.sendMailSuccess == true}) {

			// 5분 타이머 함수
			const myTimer = () => {
			    
			        let minutes = parseInt(time / 60);
			        let seconds = time % 60;
	
			        minutes = minutes < 10 ? "0" + minutes : minutes;
			        seconds = seconds < 10 ? "0" + seconds : seconds;
	
			        $("#timer").text(minutes + ":" + seconds);
					
			        if (time-- < 0) {
			            alert("인증 시간이 초과되었습니다. 인증 메일을 다시 요청하세요.");
			            clearInterval(setTimer); // 타이머 삭제
			            $("div#div_activateResult").hide();
			            return;
			        }
			}
			
		   // 5분 타이머 시작
	       const setTimer = setInterval(myTimer, 1000);

        }
	 } 
	 
	 // get방식으로 접근한 경우 인증결과창 숨기기
	 else{
	     $("div#div_activateResult").hide();
	 }
	
	 // 인증하기 버튼 클릭시 인증코드 확인
	 $("button#btnConfirmCode").click(function(){
		 verifyCode();
	 });
	 
	 // 이메일 입력 후 엔터 시 인증코드 확인
	 $("input#email").bind("keydown", function(event){
		 if(event.keyCode == 13) { 
			 verifyCode();
		 }
	 });
   
});


function verifyCode(){
	
    const frm = document.authFrm;
 	// 입력한 userid 값을 히든폼에 넣어준다.
    frm.userid.value = $("input#userid").val(); 
 	// 입력한 인증코드를 히든폼에 넣어준다.
    frm.userAuthentiCode.value = $("input#input_confirmCode").val(); 
    
	// 히든폼의 데이터를 전송	 	
    frm.action = "<%=ctxPath%>/login/verifyCode.tea"; 
    frm.method = "POST";
    frm.submit();

    }


</script>

<div class="container">
	<form name="activateFrm">
		<div id="activate_box" class="d-flex flex-column m-auto">
			<div id="activate_title">
				<h2
					style="text-align: center; font-size: 30px; line-height: 40px; font-weight: bold;">
					휴면 해제</h2>
			</div>

			<div id="input_activate" class="d-flex flex-column">
				<input type="text" id="userid" name="userid" placeholder="아이디"
					autocomplete="off" required /> <input type="text" id="name"
					name="name" placeholder="이름" autocomplete="off" required /> <input
					type="text" id="email" name="email" placeholder="이메일"
					autocomplete="off" required /> <span
					class="error text-danger text-center">이메일 형식에 맞지 않습니다.</span>
			</div>

			<div id="btnSubmit" class="d-flex flex-column">
				<input type="button" class="btn" value="확인" id="btnActivate" />
			</div>
		</div>

		<div class="my-3" id="div_activateResult">
			<p class="text-center">
				<%-- 메일 발송 성공 시 --%>
				<c:if test="${requestScope.sendMailSuccess eq true}">
					<span style="font-size: 10pt;">인증코드가 ${requestScope.email}로
						발송되었습니다.</span>
					<br>
					<span style="font-size: 10pt;">인증코드를 입력해주세요.</span>

					<span id="timer" class="text-danger"></span>

					<br>
					<input type="text" name="input_confirmCode" id="input_confirmCode"
						required />
					<br>
					<br>
					<button type="button" class="btn btn-info" id="btnConfirmCode">인증하기</button>
				</c:if>

				<%-- 메일 발송 실패 시 --%>
				<c:if test="${requestScope.sendMailSuccess eq false}">
					<span class="text-danger text-center">메일 발송이 실패하였습니다.</span>
					<br>
				</c:if>
			</p>
		</div>
	</form>
</div>

<%-- 인증하기 form  --%>
<form name="authFrm">
	<%-- 위의 form 은 get 방식이기 때문에 히든 폼을 post 방식으로 보내준다. --%>
	<input type="hidden" name="userid" /> <input type="hidden"
		name="userAuthentiCode" />
	<%-- 사용자가 입력한 코드 받아오기, 받아서 인증하기 form을 넘겨줄 것이다. --%>
</form>

<%@ include file="../footer.jsp"%>