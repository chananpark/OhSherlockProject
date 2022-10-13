<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<% String ctxPath = request.getContextPath(); %>    
 
<!-- Bootstrap CSS -->
<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/bootstrap-4.6.0-dist/css/bootstrap.min.css">

<!-- Font Awesome 5 Icons -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

<!-- 폰트 목록 -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Nanum+Gothic:wght@700&display=swap" rel="stylesheet">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Gowun+Dodum&family=Nanum+Gothic:wght@700&display=swap" rel="stylesheet">

<!-- Optional JavaScript -->
<script type="text/javascript" src="<%=ctxPath%>/js/jquery-3.6.0.min.js"></script>
<script type="text/javascript" src="<%=ctxPath%>/bootstrap-4.6.0-dist/js/bootstrap.bundle.min.js"></script>

<!-- jQueryUI CSS 및 JS -->
<link rel="stylesheet" type="text/css" href="<%= ctxPath%>/jquery-ui-1.13.1.custom/jquery-ui.min.css" />
<script type="text/javascript" src="<%= ctxPath%>/jquery-ui-1.13.1.custom/jquery-ui.min.js"></script>

<script type="text/javascript">

</script>

<style type="text/css">
	
	* {
		font-family: 'Gowun Dodum', sans-serif;
	}
	
	/* 아이디찾기 내용 전체 */
      div#passwdFind_box, #input_confirmCode {
        width: 380px;
      }

      /* 이름, 이메일 박스랑 확인 버튼 */
      div#input_passwdFind > input,
      div#btn_passwdFind > input  {
        width: 100%;
        padding: 12px;
        border: 1px solid gray;
        margin: 5px 0;
        opacity: 0.85;
        font-size: 17px;
        line-height: 20px;
      }
      
      #input_confirmCode {
      	padding: 12px;
        border: 1px solid gray;
        margin: 5px 0;
        opacity: 0.85;
        font-size: 17px;
        line-height: 20px;
      }

      div#input_passwdFind > input:hover,
      div#btn_passwdFind > input:hover {
        opacity: 1;
      }

      /* 이름, 이메일 박스 */
      div#input_passwdFind > input, #input_confirmCode {
        border-radius: 4px;
      }

      /* 확인 버튼 */
      div#btn_passwdFind > input[type='button'] {
        height: 45px;
        border-radius: 90px;
        background-color: #1E7F15;
        color: white;
        cursor: pointer;
      }
      
      /* 인증코드 입력창*/
	  #div_certification {
	  	text-align: center;
	  }	
	  
	  .loader {
		  border: 5px solid #f3f3f3;
		  border-radius: 50%;
		  border-top: 5px solid  #1E7F15 ;
		  width: 25px;
		  height: 25px;
		  -webkit-animation: spin 2s linear infinite; /* Safari */
		  animation: spin 2s linear infinite;
		}
		
		/* Safari */
		@-webkit-keyframes spin {
		  0% { -webkit-transform: rotate(0deg); }
		  100% { -webkit-transform: rotate(360deg); }
		}
		
		@keyframes spin {
		  0% { transform: rotate(0deg); }
		  100% { transform: rotate(360deg); }
		}

	
</style>
 

<script>

	let time =  60 * 5;
	
	$(document).ready(function(){
		
		$("span.error").hide();
		$("span.loader").hide();
		
		// email 형식에 맞게 입력 받아오기
		$("input[name='email']").blur( (e)=>{
			const $target = $(e.target);
			
			const regExp = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i;
			// 또는
//			const regExp = new RegExp(/^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i); 
			// 이메일 정규 표현식 객체 생성
			
			const bool = regExp.test($target.val()); // passwd(타켓) 에 대한 암호의 값을 정규표현식에 넣는다. 
			
			
			if(!bool) { 
				// 이메일이 정규표현식에 위배된 경우
				
				// 테이블 속에 있는 모든 input 태그는 못쓰게 만든다.
				$("form#pwdFindFrm :input").prop("disabled", true);  
				// 이벤트가 일어난 이메일만은 활성화 시켜주겠다.
				$target.prop("disabled", false); 
				
//				$target.next().show();
				// target은 input 이고 input 의 형제인 span 태그의 class가 error인 것을 찾아도 된다. 
				// 또는
				$target.parent().find("span.error").show();
				
				$target.focus();
				
			} else {
				// 이메일이 정규표현식에 맞는 경우
				$("form#pwdFindFrm :input").prop("disabled", false); // 다시 입력창을  활성화 시켜준다.
				
//				$target.next().hide();
				// target은 input 이고 input 의 형제인 span 태그의 class가 error인 것을 찾아도 된다. 
				// 또는
				$target.parent().find("span.error").hide();
			}
		}); // 아이디가 email인 것이 포커스를 잃어버렸을 경우(blur) 이벤트를 처리해주기
		
		
		//  비밀번호 찾기 버튼 클릭했을 때 이벤트
		$("input#passwdFind_input").click(function(){
			findPasswd_submit();
			
		}); // end of $("button#btn_passwdFind").click
		
		// 이메일 입력란에서 엔터쳤을 경우에 비밀번호 찾기 버튼과 같은 효과 주기
		$("input[name='email']").bind("keydown", function(event){
			if(event.keyCode == 13) { // 암호 입력란에서 엔터(13)를 했을 경우
				findPasswd_submit(); 
			}
		}); // end of $("input[name='email']").bind("keydown", function(event)
		
				
				
		const method = "${requestScope.method}";
	    if(method == "POST"){
	        // input에 입력한 userid와 email을 찾기 버튼을 눌러도 그대로 유지
	        $("input[name='userid']").val("${requestScope.userid}"); // ★★★★★★ 쌍따옴표 필수!!!!!!!!!! 
			$("input[name='email']").val("${requestScope.email}");
			$("input[name='name']").val("${requestScope.name}");
	        
			$("span.loader").hide();
			// 인증코드 발송되었다는 문구 출력
	    	$("div#div_findResult").show();
			
			if(${requestScope.sendMailSuccess == true}) { // 실제로 메일이 제대로 갔다면
				// 찾기 버튼 숨기기
				$("#passwdFind_input").hide();
			
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
		                     $("div#div_findResult").hide();
		     	             $("#passwdFind_input").show();
		                     return;
		                 }
		            }
		         
		         // 5분 타이머 시작
		          const setTimer = setInterval(myTimer, 1000);

		        }
		    } 
	    else{
	        $("div#div_findResult").hide();
	    }
	    
	    
	    // 인증하기
	    $("button#btnConfirmCode").click(function(){
	    	
	    	// ? 를 달면 get 방식, 아니면 post 방식. 여기서는 post 방식으로 넘겨준다.
	    	const frm = document.verifyCertificationFrm;
	    	frm.userid.value = $("input[name='userid']").val(); // 입력한 userid 값을 히든폼에 넣어준다.
	    	frm.userCertificationCode.value = $("input#input_confirmCode").val(); // 입력 받아온 값을 히든 frm 에 넣어준다
	    	
	    	frm.action = "<%= ctxPath %>/login/verifyCertification.tea"; 
	    	// 여기서 update 를 해주는 것이다
	    	frm.method = "POST";
	   		frm.submit();
	    	
	    	// 인증하기를 누르면 누구의 암호를 바꿔야하는지 select로 가져와야한다. 
	    	
	    });
	    
	}); // end of $(document).ready(function()

	
	// 비밀번호 찾기 확인 버튼 클릭시 호출되는 함수
	function findPasswd_submit(){
		const useridVal = $("input[name='userid']").val().trim();
		const emailVal = $("input[name='email']").val().trim();
		const nameVal = $("input[name='name']").val().trim();

		// 이름, 이메일, 아이디가 공백일 때 
		if( useridVal != "" && emailVal != "" && nameVal != "") {
			
			$("span.loader").show();
			// 올바르게 입력할 경우
			const frm = document.pwdFindFrm;
			// 다 올바르게 입력했다면 보내준다.
			frm.action = "<%= ctxPath %>/login/passwdFind.tea"; 
			frm.method = "POST";
			frm.submit();
			
		} else {
			// 올바르게 입력하지 않은 경우
			alert("정보를 모두 입력하세요!");
			return;
		} // end of if-else
		
	} // end of function findPasswd_submit()
	

</script>
      
<div class="container">
	<form name="pwdFindFrm" id="pwdFindFrm">
       	<div id="passwdFind_box" class="d-flex flex-column m-auto">
       		<div id="passwdFind_title" style="display:inline-block;">
       			<h2 style="text-align: center; font-size: 30px; line-height: 40px; font-weight: bold; " > 
       				FIND P/W 
       				<span class="loader" style="display:inline-block;"></span>
     			</h2>
       		</div>
          	<div id="input_passwdFind" class="d-flex flex-column">
				<input type="text" name="name" placeholder="이름" autocomplete="off" required />
				<input type="text" name="userid" placeholder="아이디" autocomplete="off" required />
				<input type="text" name="email" placeholder="이메일" autocomplete="off" required />
				<span class="error text-danger">이메일 형식에 맞지 않습니다.</span>
         	</div>
          
          	<div id="btn_passwdFind" class="d-flex flex-column">
            	<input type="button" class="btn" value="찾기" id="passwdFind_input"/>
          	</div>
      		</div>
       
       	<div class="my-3" id="div_findResult">
			<p class="text-center">
				<%-- get으로 들어올 경우 --%>
				<c:if test="${requestScope.isUserExist eq false}">
					<span style="color: red;">사용자 정보가 없습니다.</span> <%-- 회원으로 존재하지 않는 경우(false) 사용자 정보가 없습니다 라고 출력 --%>
				</c:if>
				
				<%-- post 로 들어온 경우 --%>
				<c:if test="${requestScope.isUserExist eq true && requestScope.sendMailSuccess == true}">
					<div id="div_certification">
						<hr style="border: solid 1px gray; background-color: gray;">
						<span >인증코드가 ${requestScope.email}로 발송되었습니다.</span><br>
			            <span >인증코드를 입력해주세요. </span><span id="timer" class="text-danger" style="font-weight:bold;"></span><%-- 타이머 출력 --%>
			            <input type="text" name="input_confirmCode" id="input_confirmCode" autocomplete="off" placeholder="인증코드" required />
			            <br><br>
			            <button type="button" class="btn btn-secondary justify-content-end" id="btnConfirmCode">인증하기</button>
		            </div>
				</c:if>
				
				<%-- user는 존재하지만 메일이 제대로 전송되지 못한 경우 --%>
				<c:if test="${requestScope.isUserExist eq true && requestScope.sendMailSuccess == false}">
					<span style="font-size: 10pt; color: red;">메일 발송이 실패하였습니다.</span><br>
				</c:if>
			</p>
 			</div>
	</form>
</div>



 <%-- 인증하기 form  --%>
<form name="verifyCertificationFrm">
	<%-- 위의 form 은 get 방식이기 때문에 히든 폼을 post 방식으로 보내준다. --%>
	<input type="hidden" name="userid"/> 
	<input type="hidden" name="userCertificationCode"/> <%-- 사용자가 입력한 코드 받아오기, 받아서 인증하기 form을 넘겨줄 것이다. --%>
</form>





