<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>

<style type="text/css">

	div#tblTitle {
		display: flex;
		flex-direction: row;
		justify-content: space-between; 
	}
	
	#addressBtn {
		background-color: #1E7F15;
		color: white;
		height: 30px;
		border-style: none;
		border-radius: 5%;
}

	#idCheck, 
	#emailCheck,
	#btn_emailVerifyCodeCheck,
	#mobileCheck,
	#btn_mobileVerifyCodeCheck	{
		color:#333333;
		height: 30px;
		border-style: none;
		border-radius: 5%;
	} 
	
	#btnRegister {
    width: 126px;
    padding: 12px;
    border: 2px none #1E7F15;
		background-color: #1E7F15;
		opacity:0.8;
		color: white;
		font-size: 22px;
	}
	
	#btnRegister:hover {
		opacity:1;
	}
	
	.mustIn {
	color: red;
	font-weight: bold;
}
</style>    
    
<script type="text/javascript" src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script> 
<script type="text/javascript">

	let b_flag_zipcodeSearch_click = false;
	// "우편번호찾기" 을 클릭했는지 클릭을 안했는지 여부를 알아오기 위한 용도.
	
	let b_flag_idDuplicate_click = false;
	// "아이디중복확인" 을 클릭했는지 클릭을 안했는지 여부를 알아오기 위한 용도.
	
	let b_flag_emailDuplicate_click = false;
	// "이메일중복확인" 을 클릭했는지 클릭을 안했는지 여부를 알아오기 위한 용도.
	
	let b_flag_emailVerifyCode_click = false;
	// "이메일인증코드확인" 을 확인 했는지 알아오기 위한 용도.
	
	let b_flag_mobileDuplicate_click = false;
	// "휴대폰인증" 을 확인 했는지 알아오기 위한 용도.
	
	let randnum6; // 컨트롤러에서 휴대전화 인증 코드 가져오기용
	
	
	let emailTime = 5 * 60;
	
	// 이메일인증타이머반복시켜주는애
	let setTimer;
	
	// 이메일 인증 타이머
	const emailVeriTimer = () => {
		 
        let minutes = parseInt(emailTime / 60);
        let seconds = emailTime % 60;

        minutes = minutes < 10 ? "0" + minutes : minutes;
        seconds = seconds < 10 ? "0" + seconds : seconds;

        $("#emailTimer").text(minutes + ":" + seconds);
		
        if (emailTime-- < 0) {
            alert("인증 시간이 초과되었습니다. 인증 메일을 다시 요청하세요.");
            emailTime = 60 * 5; // 타이머 시간 초기화
            clearInterval(setTimer); // 타이머 삭제
            $("#emailTimer").empty();
	   	    $("div#emailVerify").hide();// 이메일 인증확인란 숨기기
            return;
        }
	}
	
	
	
	$(document).ready(function () {
		
		$("#spinner").hide();
		
		let certifiCode; // 컨트롤러에서 이메일인증코드 가져오기용
		
	  $('span.error').hide();
	  $('input#userid').focus();
	  
	  
		// 휴대전화 인증확인란 숨기기
	  $('div#mobileVerify').hide();
	  $('div#mobileVerifyConfirm').hide();
	  
	  // 이메일 인증확인란 숨기기
	  $('div#emailVerify').hide();
	  $('div#emailVerifyConfirm').hide();
	  

	  // #userid 포커스를 잃어버렸을 경우
	  $('input#userid').blur((e) => {
	    const $target = $(e.target);
	    const regExp = new RegExp(/^.*(?=^.{4,16}$)(?=.*\d)(?=.*[a-z]).*$/g);
	
	    const bool = regExp.test($target.val());
	    const userid = $target.val().trim();
	
	    if (userid != '' && bool) {
	      // 공백이 아닌 글자와 유효성 검사를 통과했을 경우
	      $('table#tblMemberRegister :input').prop('disabled', false);
	
	      $target.parent().find('span.error').hide();
	    } else {
	      // 입력하지 않거나 공백만 입력했을 경우 혹은 유효성 검사가 틀렸을 경우
	      $('table#tblMemberRegister :input').prop('disabled', true);
	      $target.prop('disabled', false);
	
	      $target.parent().find('span.error').show();
	
	      $target.focus();
	    }
	  }); // 아이디가 userid 인 것은 포커스를 잃어버렸을 경우(blur) 이벤트를 처리해주는 것이다.
	
	  // #passwd 포커스를 잃어버렸을 경우
	  $('input#passwd').blur((e) => {
	    const $target = $(e.target);
	
	    const regExp = new RegExp(
	      /^.*(?=^.{8,15}$)(?=.*\d)(?=.*[a-zA-Z])(?=.*[^a-zA-Z0-9]).*$/g,
	    );
	    //  숫자/문자/특수문자 포함 형태의 8~15자리 이내의 암호 정규표현식 객체 생성
	
	    const bool = regExp.test($target.val());
	
	    if (!bool) {
	      // 암호가 정규표현식에 위배된 경우
	      $('table#tblMemberRegister :input').prop('disabled', true);
	      $target.prop('disabled', false);
	
	      $target.parent().find('span.error').show();
	
	      $target.focus();
	    } else {
	      // 암호가 정규표현식에 맞는 경우
	      $('table#tblMemberRegister :input').prop('disabled', false);
	
	      $target.parent().find('span.error').hide();
	    }
	  }); // 아이디가 passwd 인 것은 포커스를 잃어버렸을 경우(blur) 이벤트를 처리해주는 것이다.
	
	  // 비밀번호확인 포커스를 잃어버렸을 경우
	  $('input#passwdCheck').blur((e) => {
	    const $target = $(e.target);
	
	    const passwd = $('input#passwd').val();
	    const passwdCheck = $target.val();
	
	    if (passwd != passwdCheck) {
	      // 암호와 암호확인값이 틀린 경우
	      $('table#tblMemberRegister :input').prop('disabled', true);
	      $target.prop('disabled', false);
	      $('input#passwd').prop('disabled', false);
	
	      $target.parent().find('span.error').show();
	
	      $('input#passwd').focus();
	    } else {
	      // 암호와 암호확인값이 같은 경우
	      $('table#tblMemberRegister :input').prop('disabled', false);
	
	      $target.parent().find('span.error').hide();
	    }
	  }); // 아이디가 passwdCheck 인 것은 포커스를 잃어버렸을 경우(blur) 이벤트를 처리해주는 것이다.
	
	  // 이름 포커스를 잃어버렸을 경우
	  $('input#name').blur((e) => {
	    const $target = $(e.target);
	
	    const name = $target.val().trim();
	    if (name == '') {
	      // 입력하지 않거나 공백만 입력했을 경우
	      $('table#tblMemberRegister :input').prop('disabled', true);
	      $target.prop('disabled', false);
	
	      $target.parent().find('span.error').show();
	
	      $target.focus();
	    } else {
	      // 공백이 아닌 글자를 입력했을 경우
	      $('table#tblMemberRegister :input').prop('disabled', false);
	
	      $target.parent().find('span.error').hide();
	    }
	  }); // 아이디가 name 인 것은 포커스를 잃어버렸을 경우(blur) 이벤트를 처리해주는 것이다.
	
	  // 우편번호 클릭했을때
	  $('button#addressBtn').click(function () {
		  new daum.Postcode({
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
                document.getElementById("detail_address").focus();
            }
	        }).open(); 	
	  }); // 우편번호 찾기 버튼을 클릭했을때-----
	
	  
	  // 휴대폰 번호 입력 했을시
	  $('input#hp2').blur((e) => {
	    const $target = $(e.target);
	
	    const regExp = new RegExp(/^[1-9][0-9]{2,3}$/g);
	    //  숫자 3자리 또는 4자리만 들어오도록 검사해주는 정규표현식 객체 생성
	
	    const bool = regExp.test($target.val());
	
	    if (!bool) {
	      // 국번이 정규표현식에 위배된 경우
	      $('table#tblMemberRegister :input').prop('disabled', true);
	      $target.prop('disabled', false);
	
	      $target.parent().find('span.error').show();
	
	      $target.focus();
	    } else {
	      // 국번이 정규표현식에 맞는 경우
	      $('table#tblMemberRegister :input').prop('disabled', false);
	
	      $target.parent().find('span.error').hide();
	    }
	  }); // 아이디가 hp2 인 것은 포커스를 잃어버렸을 경우(blur) 이벤트를 처리해주는 것이다.
	
	  $('input#hp3').blur((e) => {
	    const $target = $(e.target);
	
	    const regExp = new RegExp(/^\d{4}$/g);
	    //  숫자 4자리만 들어오도록 검사해주는 정규표현식 객체 생성
	
	    const bool = regExp.test($target.val());
	
	    if (!bool) {
	      // 마지막 전화번호 4자리가 정규표현식에 위배된 경우
	      $('table#tblMemberRegister :input').prop('disabled', true);
	      $target.prop('disabled', false);
	
	      $target.parent().find('span.error').show();
	
	      $target.focus();
	    } else {
	      // 마지막 전화번호 4자리가 정규표현식에 맞는 경우
	      $('table#tblMemberRegister :input').prop('disabled', false);
	
	      $target.parent().find('span.error').hide();
	    }
	  }); // 아이디가 hp3 인 것은 포커스를 잃어버렸을 경우(blur) 이벤트를 처리해주는 것이다.
	
	  // 이메일 포커스를 잃어버렸을 경우
	  $('input#email').blur((e) => {
	    const $target = $(e.target);
	
	    const regExp = new RegExp(
	      /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i,
	    );
	    //  이메일 정규표현식 객체 생성
	
	    const bool = regExp.test($target.val());
	
	    if (!bool) {
	      // 이메일이 정규표현식에 위배된 경우
	      $('table#tblMemberRegister :input').prop('disabled', true);
	      $target.prop('disabled', false);
	
	      $target.parent().find('span.error').show();
	
	      $target.focus();
	    } else {
	      // 이메일이 정규표현식에 맞는 경우
	      $('table#tblMemberRegister :input').prop('disabled', false);
	
	      $target.parent().find('span.error').hide();
	    }
	  }); // 아이디가 email 인 것은 포커스를 잃어버렸을 경우(blur) 이벤트를 처리해주는 것이다.
	
	  // "우편번호찾기" 을 클릭했을 때 이벤트 처리하기
	  $('button#addressBtn').click(function () {
	    b_flag_zipcodeSearch_click = true;
	  });
	
	  // 우편번호 입력란에 키보드로 입력할 경우 이벤트 처리하기
	  $("input:text[id='postcode']").keyup(function () {
	    alert('우편번호 입력은 "우편번호찾기" 를 클릭으로만 하셔야 합니다.');
	    $(this).val('');
	  });
	
	  // "아이디중복확인" 을 클릭했을 때 이벤트 처리하기
	  $('button#idCheck').click(function () {
	    b_flag_idDuplicate_click = true;
	
	    $.ajax({
	      url: '<%= ctxPath%>/member/idDuplicateCheck.tea',
	      data: { userid: $('input#userid').val() },
	      type: 'post',
	      success: function (text) {
	        const json = JSON.parse(text);
	
	        if (json.isExists) {
	          // 입력한 userid 가 이미 사용중이라면
	          $('span#idcheckResult')
	            .html(
	              $('input#userid').val() +
	                ' 은 중복된 ID 이므로 사용불가 합니다.',
	            )
	            .css('color', 'red');
	          $('input#userid').val('');
	        } else {
	          // 입력한 userid 가 존재하지 않는 경우라면
	          $('span#idcheckResult')
	            .html($('input#userid').val() + ' 은 사용가능 합니다.')
	            .css('color', 'navy');
	        }
	      },
	
	      error: function (request, status, error) {
	        alert(
	          'code: ' +
	            request.status +
	            '\n' +
	            'message: ' +
	            request.responseText +
	            '\n' +
	            'error: ' +
	            error,
	        );
	      },
	    });
	  }); // end of $("button#idcheck").click(function() {})-------
	  
	// 아이디값이 변경되면 가입하기 버튼을 클릭시 "아이디중복확인" 을 클릭했는지 클릭안했는지를 알아보기위한 용도 초기화 시키기
		$('input#userid').bind('change', () => {
		  b_flag_idDuplicate_click = false;
		});
	  
///////////////////////////////////////////////////////////////////////////////////
	  
	  
		// "휴대폰인증" 을 클릭시 호출되는 함수
		$('button#mobileCheck').click(function () {
			  b_flag_mobileDuplicate_click = true;
			  // 가입하기 버튼을 클릭시 "휴대폰인증" 을 클릭했는지 클릭안했는지 알아보기위한 용도임.

        	$.ajax({
						url:"<%= request.getContextPath()%>/member/mobileVerifyCertification.tea",
						type:"post",
						data:{ mobile: $('#hp1').val()+$('#hp2').val()+$('#hp3').val() },
						dataType:"json",
						success:function(json){
			    			 // console.log(json.randnum);
				 
			    	  randnum6 = json.randnum; 
			    	  
			    	  alert("인증코드가 핸드폰으로 발송되었습니다.");
			    		
				    	// 휴대전화 박스 readonly 처리
				  		$("#hp1").attr("disabled",true); 
				  		$("#hp2").attr("readonly",true); 
				  		$("#hp3").attr("readonly",true); 
			    	  
			    	  // 휴대전화 인증확인란 보이기
			    	  $('div#mobileVerify').show();
			    	  
			    	// 5분
			    	let time =  60 * 5; // 타이머 시간
			    	
		    		// 휴대전화 인증 5분 타이머 함수
		    		const myTimer = () => {
		    		 
		    		        let minutes = parseInt(time / 60);
		    		        let seconds = time % 60;

		    		        minutes = minutes < 10 ? "0" + minutes : minutes;
		    		        seconds = seconds < 10 ? "0" + seconds : seconds;

		    		        $("#mobileTimer").text(minutes + ":" + seconds);
		    				
		    		        if (time-- < 0) {
		    		            alert("인증 시간이 초과되었습니다. 인증 메일을 다시 요청하세요.");
		    		            time = 60 * 5; // 타이머 시간 초기화
		    		            clearInterval(setTimer); // 타이머 삭제
		    		            $("#mobileTimer").empty();
		    			   	    $("div#mobileVerify").hide();// 휴대전화 인증확인란 숨기기
		    		            return;
		    		        }
		    			}
		    		
					   // 5분 타이머 시작
  	    			   myTimer(); // 한번 실행
				       const setTimer = setInterval(myTimer, 1000); // 이후 1초마다 다시 실행
			    		
						},
						
						error: function(e){
			    			alert('인증코드 발송을 실패했습니다. 다시 시도해주세요')
		    		}
					});
		  }); // end of $("button#emailCheck").click(function() {})----------
		
	  
	  //////////////////////////////////////////////////////////////////////////////////////////
	  
	  
	  
		// "이메일중복확인" 을 클릭시 호출되는 함수
		$('button#emailCheck').click(function () {
			  b_flag_emailDuplicate_click = true;
			  // 가입하기 버튼을 클릭시 "이메일중복확인" 을 클릭했는지 클릭안했는지 알아보기위한 용도임.
				
        // 오류메시지 삭제
        $('span#emailCheckResult').empty();
       
			  $.ajax({
			    url: '<%= ctxPath%>/member/emailDuplicateCheck.tea',
			    data: { email: $('input#email').val() },
			    type: 'post',
			    dataType: 'json',
			    success: function (json) {
			      if (json.isExists) {
			        $('span#emailCheckResult')
			          .html(
			            $('input#email').val() +
			              ' 은 중복된 email 이므로 사용불가 합니다.',
			          )
			          .css('color', 'red');
			        $('input#email').val('');
			      } else {
			    	  
			    	  $("#spinner").show();
			    	  
		    		 // 이메일 인증코드 처리 함수 호출
		    	   	 emailVerifyCertification();
			      }
			    },
			    error: function (request, status, error) {
			      alert(
			        'code: ' +
			          request.status +
			          '\n' +
			          'message: ' +
			          request.responseText +
			          '\n' +
			          'error: ' +
			          error,
			      );
			    },
			  });
		  }); // end of $("button#emailCheck").click(function() {})----------
		
		  // 이메일값이 변경되면 가입하기 버튼을 클릭시 "이메일중복확인" 을 클릭했는지 클릭안했는지를 알아보기위한 용도 초기화 시키기
		  $('input#email').bind('change', () => {
		    b_flag_emailDuplicate_click = false; // 중복확인
		    $('input#userEmailVerifyCode').val('');// 인증코드 입력란 초기화
			  $('div#emailVerify').hide();// 인증코드란 숨김
				b_flag_emailVerifyCode_click = false;// 인증코드 확인 
			  $('div#emailVerifyConfirm').hide(); // 인증확인메세지 숨김
		  });
		
		  
		  ////////////////////////////////////////////////////////////////
		
	   // 생년월일 월일란에 날짜 주기
      let yyyy_html = "";  // 생년월일의 년도      
      for(var i=1950; i<=2050; i++) {
          yyyy_html += "<option>"+i+"</option>";
      }
      yyyy_html += "<option selected></option>";
       
       $("select#birthyyyy").html(yyyy_html);
      
       
      let mm_html = '';
      for (var i = 1; i <= 12; i++) {
        if (i < 10) {
          mm_html += '<option>0' + i + '</option>';
        } else {
          mm_html += '<option>' + i + '</option>';
        }
      }
      mm_html += '<option selected></option>';
    
      $('select#birthmm').html(mm_html);
    
      
      let dd_html = '';
      for (var i = 1; i <= 31; i++) {
        if (i < 10) {
          dd_html += '<option>0' + i + '</option>';
        } else {
          dd_html += '<option>' + i + '</option>';
        }
      }
      dd_html += '<option selected></option>';
      
      $('select#birthdd').html(dd_html);
 
	}); // end of $(document).ready(function(){})---------------
	
	
	/////////////////////////////////////////////////////////////
	  

	// 휴대전화 인증 확인 함수
	function mobileVerifyCodeCheck() {
		
		const userRandnum = $("input#userMobileVerifyCode").val();
		
		if( randnum6 == userRandnum ){
			b_flag_mobileDuplicate_click = true;
			$('div#mobileVerify').hide();
			$('div#mobileVerifyConfirm').show();
		}
		else{
			alert("인증번호가 틀렸습니다.");
			b_flag_mobileDuplicate_click = false;
		}
	}
	
	
	// 이메일 인증 처리 함수
	function emailVerifyCertification() {
		
    	// 이메일 인증확인란 나타내기
	 		$('div#emailVerify').show();
    	
    	$.ajax({
	    		url:'<%= ctxPath%>/member/emailVerifyCertification.tea',
	    		data:{ email: $('input#email').val() },
	    		type:'POST',
	    	//	dataType: 'json', // json 값을 들고올때...
	    		success : function(text){
	    			const json = JSON.parse(text);
	    			// console.log(json.certificationCode);
   				 alert("인증코드가 이메일로 발송되었습니다.");
   			 	
		    	  $("#spinner").hide(); // 스피너 숨기기
		  	 	
		    	emailTime = 60*5;
		    	// 이메일 인증 5분 타이머 함수
		      emailVeriTimer();
			    setTimer = setInterval(emailVeriTimer, 1000); // 이후 1초마다 다시 실행
		 
   				 certifiCode = json.certificationCode;
   				 
    		},
    		error: function(e){
    			alert('인증코드 발송을 실패했습니다. 다시 시도해주세요')
    		}
   		});
		
	}// end of function emailVerifyCertification() {} ----------
	
	
	// 이메일 인증코드 확인 함수
	function emailVerifyCodeCheck()	{
		
		const userVerifyCode = $("input#userEmailVerifyCode").val();
		
		// console.log("인증코드 확인 ==> "+certifiCode);
		
		if( certifiCode == userVerifyCode ){
			b_flag_emailVerifyCode_click = true;
			$('div#emailVerify').hide();
			$('div#emailVerifyConfirm').show();
			
		}
		else{
			alert("인증번호가 틀렸습니다.");
			b_flag_emailVerifyCode_click = false;
						clearInterval(setTimer); // 타이머 삭제
						//emailTime = 60*5; // 타이머 시간 초기화
						// input입력내용지우기
						$("#userEmailVerifyCode").val("");
            $("#emailTimer").text("");
            $('div#emailVerifyConfirm').hide();
	   	      $("div#emailVerify").hide();// 이메일 인증확인란 숨기기
            return;
		}
		
	}// end of function emailVerifyCodeCheck(){}---------------
	
	
	//"가입하기" 버튼 클릭시 호출되는 함수
	function goRegister() {
	  // **** 필수입력사항에 모두 입력이 되었는지 검사한다. **** //
	  let b_Flag_required = false;
	
	  const required_list = document.querySelectorAll('input.required');
	  for (let i = 0; i < required_list.length; i++) {
	    const val = required_list[i].value.trim();
	    if (val == '') {
	      alert('*표시된 필수입력사항은 모두 입력하셔야 합니다.');
	      b_Flag_required = true;
	      break;
	    }
	  } // end of for-----------------------
	
	  if (b_Flag_required) {
	    return; // 종료
	  }
	
	  ///////////////////////////////////////////////////////
	  // "우편번호찾기" 을 클릭했는지 여부 알아오기
	  if (!b_flag_zipcodeSearch_click) {
	    // "우편번호찾기" 을 클릭 안 했을 경우
	    alert('우편번호찿기를 클릭하셔서 우편번호를 입력하셔야 합니다.');
	    return; // 종료
	  } else {
	    // "우편번호찾기" 을 클릭을 했을 경우
	
	    const regExp = new RegExp(/^\d{5}$/g);
	    //  숫자 5자리만 들어오도록 검사해주는 정규표현식 객체 생성
	
	    const postcode = $("input:text[id='postcode']").val();
	
	    const bool = regExp.test(postcode);
	
	    if (!bool) {
	      alert('우편번호 형식에 맞지 않습니다.');
	      $("input:text[id='postcode']").val('');
	      b_flag_zipcodeSearch_click = false;
	      return; // 종료
	    }
	  }
	
	  ///////////////////////////////////////////////////////
	
	  // "아이디중복확인" 을 클릭했는지 여부 알아오기
	  if (!b_flag_idDuplicate_click) {
	    // "아이디중복확인" 을 클릭 안 했을 경우
	    alert('아이디중복확인을 클릭하셔야 합니다.');
	    return; // 종료
	  }
	  
	  // "휴대전화인증확인" 을 클릭했는지 여부 알아오기
	  if (!b_flag_mobileDuplicate_click) {
	    // "휴대전화인증확인" 을 클릭 안 했을 경우
	    alert('휴대전화인증을 하셔야 합니다.');
	    return; // 종료
	  } 
	
	  // "이메일중복확인" 을 클릭했는지 여부 알아오기
	  if (!b_flag_emailDuplicate_click ||!b_flag_emailVerifyCode_click ) {
	    // "이메일중복확인" 을 클릭 안 했을 경우
	    alert('이메일 인증확인을 클릭하셔야 합니다.');
	    return; // 종료
	  }
	
	  const checkbox_length = $("input:checkbox[id='agree']:checked").length;
	
	  if (checkbox_length == 0) {
	    alert('이용약관에 동의하셔야 합니다.');
	    return; // 종료
	  }
	
	  // 최종적으로 폼을 보내어 준다.
	  const frm = document.registerFrm;
	  frm.action = '<%=ctxPath%>/member/memberRegister.tea';
	  frm.method = 'post';
	  frm.submit();
	} // end of function goRegister(){}---------------

</script>
    
    
<div class="container">
  <div class="col-md-12">
  
    <div class="col-md-15">
      <h2 style="font-weight: bold;">회원가입</h2>
      <br>
      <hr style="background-color: black; height: 1.2px;"><br>
    </div>  

    <br><br>
    
  <div id="tblTitle">
	  <h5>회원정보입력</h5>
	  <div style="font-size: 14px; margin-top: 11px; padding-right: 10px;"><span class="mustIn">* </span>필수입력사항</div>
  </div>  
  
	<div class="collapse show">
	<form name="registerFrm">
		<table id="tblMemberRegister" class="table table-bordered mt-2 orderInfo">
			<colgroup>
	          <col width="180px"/>
	          <col />
     	</colgroup>
			<thead class="thead-light">
				<tr>
					<th>아이디
						<span class="mustIn">*</span>
					</th>
					<td>
						<input id="userid" type="text" class="required" name="userid"
						size="50" placeholder="(영문소문자/숫자,4~16자)" />
						<button type="button" id="idCheck">중복확인</button>
						<span id="idcheckResult"></span>
						<span class="error" style="color: red">아이디는 영문소문자/숫자로 된 4~16자로 입력하세요.</span>
    	  	</td>
					 
				</tr>
				<tr>
					<th>비밀번호<span class="mustIn">*</span></th>
					<td><input id="passwd" type="password" class="required" name="passwd"
						size="50" placeholder="(영문 대소문자/숫자/특수문자 포함, 8~15자)" />
					<span class="error" style="color: red">비밀번호는 대소문자/숫자/특수문자 포함 8자~15자로 입력하세요.</span>
					</td>
				</tr>
				<tr>
					<th>비밀번호확인<span class="mustIn">*</span></th>
					<td><input id="passwdCheck" type="password" class="required" name="passwdCheck"
						size="50" placeholder="(비밀번호 확인)" />
						<span class="error" style="color: red">암호가 일치하지 않습니다.</span>
					</td>
				</tr>
				<tr>
					<th>이름<span class="mustIn">*</span></th>
					<td><input id="name" type="text" class="required" name="name" 
						size="50"/></td>
				</tr>
				
				<tr>
					<th style="vertical-align: middle">주소<span class="mustIn">*</span></th>
					<td class="border-0">
						<input class="addressInput mt-2 required" type="text" id="postcode" name="postcode" size="20" placeholder="우편번호" />
						<button type="button" id="addressBtn">우편번호찾기</button>
						<span class="error" style="color: red">우편번호 형식이 아닙니다.</span> <br> 
						<input class="addressInput mt-2 " type="text" id="address" name="address" size="50" placeholder="주소"/><br>
						<input class="addressInput mt-2 " type="text" id="extra_address" name="extra_address" size="50" /><br>
						<input class="addressInput mt-2 " type="text" id="detail_address" name="detail_address" size="50" placeholder="상세주소" /> 
						<span class="error" style="color: red">주소를 입력하세요</span></td>
					</tr>
					
				<tr>
					<th>휴대전화<span class="mustIn">*</span></th>
					<td>
						<select id="hp1" name="hp1">
               <option value="010">010</option>
               <option value="011">011</option>
               <option value="016">016</option>
               <option value="017">017</option>
               <option value="018">018</option>
               <option value="019">019</option>
            </select>&nbsp;-&nbsp;
				    <input type="text" id="hp2" name="hp2" class="required" size="6" maxlength="4" />&nbsp;-&nbsp;
				    <input type="text" id="hp3" name="hp3" class="required" size="6" maxlength="4" />
				    <button type="button" id="mobileCheck">인증하기</button>
				    <div id="mobileVerify">
							<input id="userMobileVerifyCode" type="text" name="mobileVerifyCode" class="mt-2" size="20"/>
							<button type="button" id="btn_mobileVerifyCodeCheck" onclick="mobileVerifyCodeCheck();">인증확인</button>
							<span id="mobileTimer" class="text-danger"></span>
						</div>
						<div id="mobileVerifyConfirm">휴대전화 인증이 확인되었습니다.</div>
					</td>
				</tr>
				
				<tr>
					<th style="vertical-align: middle">이메일<span class="mustIn">*</span></th>
					<td>
						<input id="email" type="text" class="required" name="email" size="50" />
						<button type="button" id="emailCheck">인증하기</button>
						<span id="spinner" class="spinner-border text-success"></span>
						<span id="emailCheckResult"></span>
						<span class="error" style="color: red">이메일 형식에 맞지 않습니다.</span>
						<br>
						<div id="emailVerify">
							<input id="userEmailVerifyCode" type="text" name="emailVerifyCode" class="mt-2" size="20"/>
							<button type="button" id="btn_emailVerifyCodeCheck" onclick="emailVerifyCodeCheck();">인증확인</button>
							<span id="emailTimer" class="text-danger"></span>
						</div>
						<div id="emailVerifyConfirm">이메일 인증이 확인되었습니다.</div>
					</td>
				</tr>
				
			</thead>
		</table>
	
	</div>    
    
    <br><br>
    
    <h5>추가정보</h5>
    <div class="collapse show">
		<table class="table table-bordered mt-2 orderInfo">
			<colgroup>
	          <col width="180px"/>
	          <col />
     	</colgroup>
     	
			<thead class="thead-light">
			<tr>
			<th style="background-color: white;">성별</th>
			<td >
			   <input type="radio" id="none" name="gender" value="0" checked/><label for="none" style="margin-left: 1%;">선택안함</label>
			   <input type="radio" id="male" name="gender" value="1" style="margin-left: 5%;"/><label for="male" style="margin-left: 1%;">남자</label>
			   <input type="radio" id="female" name="gender" value="2" style="margin-left: 5%;" /><label for="female" style="margin-left: 1%;">여자</label>
			</td>
		</tr>
		
		<tr>
      <th style="background-color: white;">생년월일</th>
      <td >
         <select  id="birthyyyy" name="birthyyyy" style="width: 80px; padding: 5px;"></select> 년
          <select id="birthmm" name="birthmm" style="margin-left: 2%; width: 60px; padding: 5px;">
          </select> 월
          <select id="birthdd" name="birthdd" style="margin-left: 2%; width: 60px; padding: 5px;">
         </select> 일
      </td>
    </tr>

			</thead>
		</table>
	</form>
	</div>
	  
	  
	  <br><br>
	  
		<h5>이용약관</h5>
    <div class="collapse show">
		<table class="table table-bordered mt-2 orderInfo">
			<colgroup>
	          <col width="180px"/>
	          <col />
     	</colgroup>
			<thead class="thead-light">
				<tr>
					<td colspan="2" style="text-align: center; vertical-align: middle;">
						<iframe src="<%=ctxPath %>/iframeAgree/registerAgree.html" width="85%" height="150px" class="box" ></iframe></iframe>
					</td>
				</tr>
				<tr>
					<td colspan="2">
					<div style="text-align:right;">					
						<label for="agree">이용약관에 동의하십니까?</label>&nbsp;&nbsp;
						<input type="checkbox" id="agree" /> 동의함
					</div>
					</td>
				</tr>
		
			</thead>
		
		</table>
	</div>

   <br><br>
   
   <div class="text-center" id="register" style="display: block;"> 
  	<input type="button" id="btnRegister" onclick="goRegister()" value="가입하기" />
   </div>
    
  </div>
</div>

<%@ include file="../footer.jsp"%>
