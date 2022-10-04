<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ include file="../header.jsp"%>
<%@ page import="javax.servlet.http.HttpServletRequest" %>  
  
<style type="text/css">

	div#tblTitle {
		display: flex;
		flex-direction: row;
		justify-content: space-between;
	}
	
	.error {
		color: red;
	}
	
	#addressBtn {
		background-color: #1E7F15;
		color: white;
		height: 30px;
		border-style: none;
		border-radius: 5%;
	}

	#phoneCheck, 
	#mobileCheckBtn,
	#mobileCodeCheckBtn,
	#emailCheckBtn, 
	#emailCodeCheckBtn {
		color:#333333;
		height: 30px;
		border-style: none;
		border-radius: 5%;
	} 

	#emailCodeConfirm {
		margin-top: 6px;
	}

	.btn-light {
		width: 85px; 
		color: #1a1a1a; 
		border-style: none; 
		height: 33px;
	}
	
	.btn-secondary {
		width: 85px; 
		margin: 15px; 
		border-style: none; 
		height: 33px;
	}
	
	.btn-secondary:hover {
		border: 2px none #1E7F15;
		background-color: #1E7F15;
	    color: white;
	}
	
	.mustIn {
		color: red;
		font-weight: bold;
	}

</style>    
   
<script type="text/javascript" src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>  <!-- src 경로는 daum에서 준 우편번호찾기 사이트이다. -->
<script type="text/javascript">

	//타이머 시간
	let time = 60 * 5; 

	// "우편번호찾기" 를 클릭했는지 클릭을 안했는지 여부를 알아오기 위한 용도.
	let b_flag_addressBtn_click = false;  // 초기값을 false 로 줌. 
	
	// 휴대전화 변경했는지 알아오기 위한 용도
	let b_flag_mobile_update = false;
	
	// "휴대전화 인증하기" 을 클릭했는지 클릭을 안했는지 여부를 알아오기 위한 용도.
	let b_flag_mobileCheckBtn_click = false;
	
	// "휴대전화 인증코드확인" 을 확인 했는지 알아오기 위한 용도.
	let b_flag_mobileVerifyCode_click = false;
	
	// 이베일 변경했는지 알아오기 위한 용도
	let b_flag_email_update = false;
	
	// "이메일 인증하기" 을 클릭했는지 클릭을 안했는지 여부를 알아오기 위한 용도.
	let b_flag_emailCheckBtn_click = false;

	// "이메일 인증코드확인" 을 확인 했는지 알아오기 위한 용도.
	let b_flag_emailVerifyCode_click = false;
	
	// 휴대폰 인증번호
	let smsCertificationCode = "";
	
	// 이메일 인증번호
	let certificationCode = "";
	
	
	$(document).ready(function(){
		
		$("span.error").hide();             // 에러메시지를 숨기고 시작한다.
		$("div#mobileVerify").hide();       // 휴대전화 인증하기 클릭시 인증란을 숨기고 시작한다.
		$("span#mobileCodeConfirm").hide(); // 휴대전화 인증결과도 숨기고 시작한다.
		$("div#emailVerify").hide();        // 이메일 인증하기 클릭시 인증란을 숨기고 시작한다.
		$("span#emailCodeConfirm").hide();  // 이메일 인증결과도 숨기고 시작한다.
		$("#spinner").hide();               // 휴대전화 스피너 숨기고 시작한다.
		$("#spinner2").hide();              // 이메일 스피너 숨기고 시작한다.
	
		
		// 비밀번호
		$("input#passwd").change( (e)=>{  // 포커스를 잃을 때 발생하는 이벤트
			if($(e.target).val().trim() !="") {
				const $target = $(e.target);
			
				const regExp = new RegExp(/^.*(?=^.{8,15}$)(?=.*\d)(?=.*[a-zA-Z])(?=.*[^a-zA-Z0-9]).*$/g);  
				// 숫자/문자/특수문자 포함 형태의 8~15자리 이내의 암호 정규표현식 객체 생성
				
				const bool = regExp.test($target.val());  // 이벤트 발생값을 정규표현식에 맞는지 검사
				
				if(!bool) {  
					// 암호가 정규표현식에 위배된 경우
	
					$("table#tblMemberRegister :input").prop("disabled", true);  
					$target.prop("disabled", false);
					
					$target.parent().find("span.error").show(); 
					$target.focus(); 
				}
				else {  
					// 암호가 정규표현식에 맞는 경우
					
					$("table#tblMemberRegister :input").prop("disabled", false); 
					$target.parent().find("span.error").hide();  
				}
			} else{
				const $target = $(e.target);
				$target.parent().find("span.error").hide();
			}
			
		} );// 아이디가 passwd 인 것은 포커스를 잃어버렸을 경우(blur) 이벤트를 처리해주는 것이다.
		
		
		// 비밀번호 확인 
		$("input#pwdcheck").change( (e)=>{  
			if($(e.target).val().trim() !="") {
				const $target = $(e.target); 
				
				const passwd = $("input#passwd").val();  // 비밀번호의 값
				const pwdcheck = $target.val();          // 이벤트 발생된 곳의 값
				
				if(passwd != pwdcheck) {  
					// 암호와 암호확인값이 틀린 경우
					
					$("table#tblMemberRegister :input").prop("disabled", true);  
					$target.prop("disabled", false);            // 이벤트 발생된 곳의 input태그 활성화시킴.
					$("input#passwd").prop("disabled", false);  // 비밀번호 입력란의 input태그 활성화시킴.
					
					
					$target.parent().find("span.error").show();
					$("input#passwd").focus(); 
				}
				else {  
					// 암호와 암호확인값이 같은 경우
					
					$("table#tblMemberRegister :input").prop("disabled", false);
					$target.parent().find("span.error").hide();
				}
			} else{
				const $target = $(e.target);
				$target.parent().find("span.error").hide();
			}
		} );// 아이디가 pwdcheck 인 것은 포커스를 잃어버렸을 경우(blur) 이벤트를 처리해주는 것이다.
		
		
		// 이름
		$("input#name").blur( (e) => { 
			
			const $target = $(e.target); 
			
			const name = $target.val().trim();
			if(name == "") {  // 공백인 경우
				
				$("table#tblMemberUpdate :input").prop("disabled", true);  // 모든 input태그 비활성화
				$target.prop("disabled", false);  // 성명 입력란만 활성화
				
				$target.parent().find("span.error").show();  // 에러메시지
			    $target.focus();  
			}
			else {  // 공백이 아닌 경우
				
				$("table#tblMemberUpdate :input").prop("disabled", false);  // 모든 input태그 활성화
				$target.parent().find("span.error").hide(); //  에러메시지 숨김
			}
			
		});// 아이디가 name 인 것은 포커스를 잃어버렸을 경우(blur) 이벤트를 처리해주는 것이다.
		
		
		// 우편번호찾기 버튼 클릭시
		$("button#addressBtn").click(function(){
			
			new daum.Postcode({   // 다음사이트에서 제공하는 "우편번호찾기" 코드
	            oncomplete: function(data) {
	                // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

	                // 각 주소의 노출 규칙에 따라 주소를 조합한다.
	                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
	                let addr = ''; // 주소 변수
	                let extraAddr = ''; // 참고항목 변수

	                //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
	                if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
	                    addr = data.roadAddress;
	                } else { // 사용자가 지번 주소를 선택했을 경우(J)
	                    addr = data.jibunAddress;
	                }

	                // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
	                if(data.userSelectedType === 'R'){
	                    // 법정동명이 있을 경우 추가한다. (법정리는 제외)
	                    // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
	                    if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
	                        extraAddr += data.bname;
	                    }
	                    // 건물명이 있고, 공동주택일 경우 추가한다.
	                    if(data.buildingName !== '' && data.apartment === 'Y'){
	                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
	                    }
	                    // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
	                    if(extraAddr !== ''){
	                        extraAddr = ' (' + extraAddr + ')';
	                    }
	                    // 조합된 참고항목을 해당 필드에 넣는다.
	                    document.getElementById("extra_address").value = extraAddr;
	                
	                } else {
	                    document.getElementById("extra_address").value = '';
	                }

	                // 우편번호와 주소 정보를 해당 필드에 넣는다.
	                document.getElementById('postcode').value = data.zonecode;
	                document.getElementById("address").value = addr;
	                // 커서를 상세주소 필드로 이동한다.
	                document.getElementById("detail_address").focus();  // 본인이 직접 입력해야하는 부분
	            }
	        }).open();
			
		});

		
		// 우편번호, 주소, 추가주소 입력란 클릭시 알림메시지 띄우기
        $("input#postcode, input#address, input#extra_address").bind("click", () => {
        	
   	        alert("우편번호찾기를 클릭하셔서 주소를 입력하세요.");
        
        });
   	    
     	// 생년월일 월일란에 날짜 주기
	 	let yyyy_html = "";  // 생년월일의 년도   	
		for(var i=1950; i<=2010; i++) {
			yyyy_html += "<option>"+i+"</option>";
		}
		yyyy_html += '<option selected></option>';
		$("select#birthyyyy").html(yyyy_html); 
		

		var birthyyyy = ${fn:substring(requestScope.loginuser.birthday, 0, 4)};
		$("select[name='birthyyyy']").val(birthyyyy);

		
        let mm_html = "";  // 생년월일의 월
		for(var i=1; i<=12; i++) {
			if(i<10) {  // 10 보다 적으면 숫자앞에 0 붙이기
				mm_html += "<option>0"+i+"</option>";
			}else {
				mm_html += "<option>"+i+"</option>";
			}
		}
		mm_html += '<option selected></option>';
		$("select#birthmm").html(mm_html);

		var birthmm = ${fn:substring(requestScope.loginuser.birthday, 4, 6)};
		
		if(birthmm < 10) {
			birthmm = "0" + birthmm;
		}
		
		$("select[name='birthmm']").val(birthmm);
		
		let dd_html = "";  // 생년월일의 일
		for(var i=1; i<=31; i++) {
			if(i<10) {  // 10 보다 적으면 숫자앞에 0 붙이기
				dd_html += "<option>0"+i+"</option>";
			}
			else {
				dd_html += "<option>"+i+"</option>";
			}
		}
		dd_html += '<option selected></option>';
		$("select#birthdd").html(dd_html);
		
		var birthdd = ${fn:substring(requestScope.loginuser.birthday, 6, 8)}; 
		if(birthdd < 10) {
			birthdd = "0" + birthdd;
		}
		
		$("select[name='birthdd']").val(birthdd);
		

		// 연락처 넣어주기
		<c:set var="hp_1" value="${sessionScope.loginuser.mobile}"/>
		let hp1 = ${ fn:substring(hp_1, 1, 3) };
		
		if(hp1 < 20) {
			hp1 = "0" + hp1;
		}
		$("select[name='hp1'] option[value='" + hp1 + "']").attr('selected', 'selected');
		
		
		$("input#hp2").blur( (e)=>{
			
			const $target = $(e.target);
			
			const regExp = new RegExp(/^[1-9][0-9]{2,3}$/g);  
			// 숫자 3자리 또는 4자리만 들어오도록 검사해주는 정규표현식 객체 생성
			
			const bool = regExp.test($target.val());  // 이벤트 발생값을 정규표현식에 맞는지 검사한다.
			
			if(!bool) {
				// 국번이 정규표현식에 위배된 경우
				$("table#tblMemberRegister :input").prop("disabled", true);  
				$target.prop("disabled", false);
				
				$target.parent().find("span.error").show();
				$target.focus();  
			}
			else {  // 국번이 정규표현식에 맞는 경우
				
				$("table#tblMemberRegister :input").prop("disabled", false);
				$target.parent().find("span.error").hide();
			}
			
		} );// 아이디가 hp2 인 것은 포커스를 잃어버렸을 경우(blur) 이벤트를 처리해주는 것이다.
		
		
		$("input#hp3").blur( (e)=>{
			
			const $target = $(e.target);
			
			const regExp = /^\d{4}$/g;   
			// 네글자는 0-9까지 가능함.  여기서 \d == [0-9] 동일함.  // 숫자 4자리만 들어오도록 검사해주는 정규표현식 객체 생성
			
			const bool = regExp.test($target.val());  // 이벤트 발생값을 정규표현식에 맞는지 검사한다.
			
			if(!bool) {  
				// 마지막 전화번호 4자리가 정규표현식에 위배된 경우
				
				$("table#tblMemberRegister :input").prop("disabled", true);  
				$target.prop("disabled", false);
				
				$target.parent().find("span.error").show();
				$target.focus(); 
			}
			else {  
				// 마지막 전화번호 4자리가 정규표현식에 맞는 경우
				
				$("table#tblMemberRegister :input").prop("disabled", false);
				$target.parent().find("span.error").hide();
			}
			
		} );// 아이디가 hp3 인 것은 포커스를 잃어버렸을 경우(blur) 이벤트를 처리해주는 것이다.
		
		 
		// 휴대전화 인증하기 클릭했을 경우
	    $("button#mobileCheckBtn").click(function(e){
	         
	    	b_flag_mobileCheckBtn_click = true;   // 휴대전화 "인증하기" 을 클릭했을 때만 true 가 나온다. 버튼 클릭 여부를 알아보기위한 용도임.
	    	
	         $("#spinner").show();
	         
	         let dataObj;
	         let total = "" + $("#hp1").val() + $("#hp2").val() + $("#hp3").val();
	          
	         dataObj = {"mobile":total};     // java에서 getParameter 해올 값 : 실제로 입력한 문자 내용 
	      
	         $.ajax({
	            url: "<%= ctxPath%>/member/smsSend_2.tea",
	            type: "POST",
	            data: dataObj, 
	            dataType: "json",
	            success:function(json){
	               // json 은 {"group_id":"R2GLXUuyhgtfliqt","success_count":1,"error_count":0,"certificationCode":"596150"} 처럼된다.
	               
	               if(json.success_count == 1) {
	                  $("#spinner").hide();  // 스피너 숨기기
	                  
	                  alert("인증번호가 문자로 전송되었습니다.");
	              //  console.log("인증코드 확인 => " + json.certificationCode);
	                  smsCertificationCode = json.certificationCode;
	                  
	                  // 5분 타이머 함수
	                     const myTimer = () => {
	                          
	                          let minutes = parseInt(time / 60);
	                          let seconds = time % 60;

	                          minutes = minutes < 10 ? "0" + minutes : minutes;
	                          seconds = seconds < 10 ? "0" + seconds : seconds;

	                          $("#timer").text(minutes + ":" + seconds);
	                        
	                          if (time-- < 0) {
	                              alert("인증 시간이 초과되었습니다. 인증 문자를 다시 요청하세요.");
	                              clearInterval(setTimer); // 타이머 삭제
	                              $("#timer").hide();
	                              return;
	                          }
	                     } 
	                     
	                     // 5분 타이머 시작
	                     const setTimer = setInterval(myTimer, 1000);
	                     
	                     // 휴대전화 인증코드입력란 및 인증확인버튼 보여주기
	                   $("div#mobileVerify").show();
	                   
		               } else if(json.error_count != 0) {
	                  		alert("인증코드 전송을 실패했습니다. 다시 시도해주세요.");
	     	           }
	               
		            },
                    error: function(request, status, error){
                    	alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
    		            }
			    });
	 	    	      
	    });// end of $("button#mobileCheckBtn").click(function(e){}---------------
		
	 	// 휴대전화값이 변경되면 수정 버튼을 클릭시 "휴대전화 인증하기" 을 클릭했는지 클릭안했는지를 알아보기위한 용도 초기화 시키기 
        $("select#hp1, input#hp2, input#hp3").bind("change", () => {  // 휴대전화이 바뀌면 값을 초기화시키고 false 됨.
        	
        	if(!b_flag_mobileCheckBtn_click) { // 인증하기 버튼 클릭 안했을시
	   	        alert("휴대전화 인증하기를 클릭하셔야 합니다.");
	   	   		$("#editCompletion").prop("disabled", true); // 수정버튼 비활성화
        	}
        
        });
	    		
	    		
		// 이메일
		$("input#email").blur( (e)=>{
			
			const $target = $(e.target);
			
			const regExp = new RegExp(/^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i);   
			// 이메일 정규표현식 객체 생성
			
			const bool = regExp.test($target.val());  // 이벤트 발생값을 정규표현식에 맞는지 검사한다.
			
			if(!bool) {
				// 이메일이 정규표현식에 위배된 경우
				$("table#tblMemberRegister :input").prop("disabled", true); 
				$target.prop("disabled", false);
				
				$target.parent().find("span.error").show();
				$target.focus();  
			}
			else {  // 이메일이 정규표현식에 맞는 경우
				
				$("table#tblMemberRegister :input").prop("disabled", false);
				$target.parent().find("span.error").hide();
			}
			
		});// 아이디가 email 인 것은 포커스를 잃어버렸을 경우(blur) 이벤트를 처리해주는 것이다.
		
		// 이메일값이 변경되면 수정 버튼을 클릭시 "이메일 인증하기" 을 클릭했는지 클릭안했는지를 알아보기위한 용도.
        $("input#email").bind("change", () => {  // 이메일값이 바뀌면 값을 초기화시키고 false 됨. 
        	
        	if(!b_flag_emailCheckBtn_click) { // 인증하기 버튼 클릭 안했을시
	   	   		alert("이메일 인증하기를 클릭하셔야 합니다.");
	   	   		$("#editCompletion").prop("disabled", true); // 수정버튼 비활성화
        	}
        
        });
		
	});// end of $(document).ready(function(){})---------------------------
	
	
	
	// >>> Function Declaration <<< //
	// 휴대전화 인증확인하기
	function mobileVerifyCodeCheck() {
		
		const userVerifyCode = $("input#mobileCode").val();

			if(smsCertificationCode == userVerifyCode){
				b_flag_mobileVerifyCode_click = true; // 인증확인 버튼 클릭함.
				$('div#mobileVerify').hide();        // 휴대전화 인증코드입력란 및 인증확인버튼 숨기기
				$('span#mobileCodeConfirm').show();  // 인증결과 보여준다.
				$("#editCompletion").prop("disabled", false); // 수정버튼 활성화
			}
			else{
				alert("인증번호가 틀렸습니다. 인증하기 버튼을 눌러 인증코드를 다시 발급받으세요.");
				b_flag_mobileVerifyCode_click = false;  // 휴대전화 인증확인 버튼 초기화
				$("input#mobileCode").val("");       // 인증코드 입력란 비우기
				$("div#mobileVerify").hide();        // 인증코드 입력란과 인증확인버튼 숨기고 시작한다.
				$("span#mobileCodeConfirm").hide();  // 인증결과도 숨기고 시작한다.
			}
			
	}
	
	
	// 이메일 "인증하기" 을 클릭시 호출되는 함수
	function isEmailCheck() {
		
		b_flag_emailCheckBtn_click = true;   // 이메일 "인증하기" 을 클릭했을 때만 true 가 나온다. "이메일중복확인" 을 클릭했는지 여부 알아보기위한 용도임.
		
		
		$.ajax({  // jQuery 방식. 
			url:"<%= ctxPath%>/member/emailDuplicateCheck_2.tea", 
			data:{"email":$("input#email").val()
				 ,"userid":"${sessionScope.loginuser.userid}"},
			type:"post",      
			dataType:"json",  
		    //	async:true,   // async:true  가 비동기 방식을 말한다. async 을 생략하면 기본값이 비동기 방식인 async:true 이다. 즉, 생략가능함. (예: 맛집에 대기 걸어놓고 다른 관광지 보고 차례되면 다시 돌아옴.)
		         		      // async:false 가 동기 방식이다. 지도를 할때는 반드시 동기방식인 async:false 을 사용해야만 지도가 올바르게 나온다. (예: 맛집에서만 계속 줄서서 기다리다가 먹고, 다른 관광지로 이동함. 시간이 오래 걸림.)
			success:function(json){
				
				if(json.isExists) {
					// 입력한 email 이 이미 사용중이라면 (isExists == true)
					$("span#emailCheckResult").html($("input#email").val()+" 은 중복된 email 이므로 사용불가 합니다.").css("color", "red");
   	 				// $("input#userid").val("");  // 입력란에서 입력한 ID 값을 비워버리기
				}
				else {
					// 입력한 email 이 이미 DB 테이블에 존재하지 않는 경우라면
					$("span#emailCheckResult").html($("input#email").val()+" 은 사용가능합니다.").css("color", "navy");
					$("#spinner2").show();
					sendEmail(); // 이메일 인증코드 발송 함수 호출
				}
				
			},
			
			error:function(request, status, error){
                alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);  // 뭔가 잘못되어지면 alert 로 찍어본다.
            }
			
		});
		
	}// end of function isEmailCheck()-----------------------
	
	
	// 이메일 인증코드 발송 함수
	function sendEmail() {
		
		$.ajax({
    		url:'<%= ctxPath%>/member/sendEmailCode_2.tea',
    		data:{"email":$("input#email").val()
				 ,"userid":"${sessionScope.loginuser.userid}"},
    		type:'POST',
    		dataType:"json",
    		success:function(json){
    			$("#spinner2").hide();
    			if(json.sendMailSuccess){
					alert("인증코드가 이메일로 발송되었습니다.");
	    			certificationCode = json.certificationCode;
	    			
	    			// 5분 타이머 함수
	    	         const myTimer = () => {
	    	             
	    	             let minutes = parseInt(time / 60);
	    	             let seconds = time % 60;

	    	             minutes = minutes < 10 ? "0" + minutes : minutes;
	    	             seconds = seconds < 10 ? "0" + seconds : seconds;

	    	             $("#timer2").text(minutes + ":" + seconds);
	    	           
	    	             if (time-- < 0) {
	    	                 alert("인증 시간이 초과되었습니다. 인증 메일을 다시 요청하세요.");
	    	                 clearInterval(setTimer); // 타이머 삭제
	    	                 $("#timer2").hide();
	    	                 return;
	    	             }
	    	        }
	    	         
	    	         // 5분 타이머 시작
	    	         const setTimer = setInterval(myTimer, 1000);
	    			 $("div#emailVerify").show();
    			}
    			else
    				alert("인증코드 발송을 실패했습니다. 다시 시도해주세요.");
    		},
	    		error:function(request, status, error){
	                alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);  // 뭔가 잘못되어지면 alert 로 찍어본다.
	            }
			});

	}
	
	
	// 이메일 인증확인하기
	function emailVerifyCodeCheck() {
		
		const userVerifyCode = $("input#emailCode").val();

			if(certificationCode == userVerifyCode){
				b_flag_emailVerifyCode_click = true;
				$('div#emailVerify').hide();
				$('span#emailCodeConfirm').show();
				$("#editCompletion").prop("disabled", false); // 수정버튼 활성화
			}
			else{
				alert("인증번호가 틀렸습니다. 인증하기 버튼을 눌러 인증코드를 다시 발급받으세요.");
				b_flag_emailVerifyCode_click = false;
				$("input#emailCode").val("");
				$("div#emailVerify").hide();  // 처음에는 인증하기 클릭시 인증란을 숨기고 시작한다.
				$("span#emailCodeConfirm").hide();  // 인증결과도 숨기고 시작한다.
			}
	}
	
	
	// "취소" 버튼 클릭시 호출되는 함수
    function cancel() {
       location.href= "<%= ctxPath%>/mypage/mypage.tea"; 
    }
	
	// "수정" 버튼 클릭시 호출되는 함수
	function goEdit() {
		
		// 이름은 필수입력 사항이다.
		let b_Flag_requiredInfo = false;  // 초기값 false 줌.
		
		if($("input.requiredInfo").val() == "") {
			b_Flag_requiredInfo = true;  // 입력란에 값이 비어있으면 true 를 준다.
			return false;  // break; 라는 뜻이다.
		}
	 	
		if(b_Flag_requiredInfo) {  // 입력란에 값이 있으면 false 를 준다.
			return; // 종료
		}
		
		
		
	 	const frm = document.editFrm;
	 	frm.action = "<%= ctxPath%>/member/memberEditEnd.tea"; 
	 	frm.method = "post";
	 	frm.submit();
	 	
	 	
	}// end of function goEdit()-----------------------
	
	
</script>
    
<div class="container">
  <form name="editFrm">
  
    <div class="col-md-15">
		<h2 style="font-weight: bold;">회원정보수정</h2>
		<br>
		<hr style="background-color: black; height: 1.2px;"><br>
    </div>  

    <br><br>
    
	<div id="tblTitle">
		<h5>회원정보</h5>
	</div>    
  
	<div class="collapse show">
		<table class="table table-bordered mt-2 orderInfo">
			<colgroup>
	          <col width="180px"/>
	          <col />
     		</colgroup>
			<thead class="thead-light">
				<tr>
					<th>아이디</th>
					<td>
						<input type="text" name="userid" value="${sessionScope.loginuser.userid}" readonly />
					</td>
				</tr>
				<tr>
					<th>비밀번호</th>
					<td>
						<input type="password" name="passwd" id="passwd" size="50" placeholder="(영문자/숫자/특수문자 포함, 8자~15자)" />
						<span class="error" style="color: red">비밀번호는 영문자/숫자/특수문자 포함 8자~15자로 입력하세요.</span>
					</td>
				</tr>
				<tr>
					<th>비밀번호 확인</th>
					<td>
						<input type="password" id="pwdcheck" size="50" placeholder="(영문자/숫자/특수문자 포함, 8자~15자)" />
						<span class="error" style="color: red">비밀번호가 일치하지 않습니다.</span>
					</td>
				</tr>
				<tr>
					<th>이름</th>
					<td>
						<input type="text" name="name" id="name" size="50" value="${sessionScope.loginuser.name}" class="requiredInfo" required /> 		                
						<span class="error">이름은 필수입력 사항입니다.</span>
					</td>
				</tr>
		         <tr>
					<th style="vertical-align: middle">주소</th>
					<td class="border-0">
						<input class="addressInput mt-2" type="text" id="postcode" name="postcode" value="${sessionScope.loginuser.postcode}" size="20" maxlength="5" readonly />
						<button type="button" id="addressBtn">우편번호찾기</button>
						<span class="error" style="color: red">우편번호 형식이 아닙니다.</span><br> 
						<input class="addressInput mt-2" type="text" id="address" name="address" value="${sessionScope.loginuser.address}" size="50" readonly /><br/>
		                <input class="addressInput mt-2" type="text" id="extra_address" name="extra_address" value="${sessionScope.loginuser.extra_address}" size="50" readonly /><br>
		                <input class="addressInput mt-2" type="text" id="detail_address" name="detail_address" value="${sessionScope.loginuser.detail_address}" size="50" />
						<span class="error" style="color: red">주소를 입력하세요.</span>
					</td>
				</tr>
				<tr>
					<th>생년월일</th>
					<td>
					   <select id="birthyyyy" name="birthyyyy" style="width: 80px; padding: 3px;"></select> 년
					   <select id="birthmm" name="birthmm" style="margin-left: 2%; width: 80px; padding: 3px;"></select> 월
					   <select id="birthdd" name="birthdd" style="margin-left: 2%; width: 80px; padding: 3px;"></select> 일
					</td>
				</tr>
				<tr>
					<th style="vertical-align: middle">휴대전화</th>
					<td>
		                <select id="hp1" name="hp1" style="width: 80px; padding: 3px;">
		                	<option value="010">010</option>
			                <option value="011">011</option>
			                <option value="016">016</option>
			                <option value="017">017</option>
			                <option value="018">018</option>
			                <option value="019">019</option>
		                </select>&nbsp;-&nbsp;
		                <input type="text" id="hp2" name="hp2" maxlength="4" value="${ fn:substring(sessionScope.loginuser.mobile, 3, 7) }" style="width: 80px; padding: 3px;"/>&nbsp;-&nbsp; <%-- 휴대폰 중간번호 4자리 --%>
		                <input type="text" id="hp3" name="hp3" maxlength="4" value="${ fn:substring(sessionScope.loginuser.mobile, 7, 11) }" style="width: 80px; padding: 3px;"/>             <%-- 휴대폰 마지막번호 4자리 --%>
			            <button type="button" id="mobileCheckBtn" style="cursor: pointer;">인증하기</button>
			            <span id="spinner" class="spinner-border text-success"></span>
			            <span class="error" style="color: red">휴대폰 형식이 아닙니다.</span>
			            <br>
			            <div id="mobileVerify">
							<input type="text" name="mobileCode" id="mobileCode"  class="mt-2" size="20"/>
							<button type="button" id="mobileCodeCheckBtn" onclick="mobileVerifyCodeCheck();">인증확인</button>
							<span id="timer" style="color: red"></span>
						</div>
						<span id="mobileCodeConfirm">휴대폰 인증이 확인되었습니다.</span>
					</td>
				</tr>
				<tr>
					<th style="vertical-align: middle">이메일</th>
					<td>
						<input type="text" name="email" id="email" size="50" value="${sessionScope.loginuser.email}" /> 
		                <button type="button" id="emailCheckBtn" style="cursor: pointer;" onclick="isEmailCheck();">인증하기</button>
		                <span id="emailCheckResult"></span>
		                <span id="spinner2" class="spinner-border text-success"></span>
		                <span class="error" style="color: red">이메일 형식에 맞지 않습니다.</span>
		                <br>
						<div id="emailVerify">
							<input type="text" name="emailCode" id="emailCode"  class="mt-2" size="20"/>
							<button type="button" id="emailCodeCheckBtn" onclick="emailVerifyCodeCheck();">인증확인</button>
							<span id="timer2" style="color: red"></span>
						</div>
						<span id="emailCodeConfirm">이메일 인증이 확인되었습니다.</span>
					</td>
				</tr>
			</thead>
		</table>

    <br><br>
    	
	    <div class="text-center" id="detail" style="display: block; margin-top: 40px;">
		  <input type="button" class="btn btn-light" id="btnUpdate" onClick="cancel();" value="취소" />
		  <input type="button" id="editCompletion" class="btn btn-secondary" onClick="goEdit();" value="수정" />
	    </div>
    </div>
    
  </form>
</div>

 <%-- 인증하기 form  --%>
<form name="verifyCertificationFrm">
	<%-- 위의 form 은 get 방식이기 때문에 히든 폼을 post 방식으로 보내준다. --%>
	<input type="hidden" name="userCertificationCode" /> <%-- 사용자가 입력한 코드 받아오기, 받아서 인증하기 form을 넘겨줄 것이다. --%>
</form>

<%@ include file="../footer.jsp"%>
