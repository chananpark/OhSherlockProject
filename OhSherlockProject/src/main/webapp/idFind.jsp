<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<% String ctxPath = request.getContextPath(); %>    
    
<!-- Required meta tags -->
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    
<!-- Bootstrap CSS -->
<link rel="stylesheet" type="text/css" href="<%= ctxPath%>/bootstrap-4.6.0-dist/css/bootstrap.min.css" > 
    
<!-- 직접 만든 CSS -->
<link rel="stylesheet" type="text/css" href="<%= ctxPath%>/css/style.css" />    <!-- /MyMVC/src/main/webapp/css/style.css 파일 경로 -->

<!-- Optional JavaScript -->
<script type="text/javascript" src="<%= ctxPath%>/js/jquery-3.6.0.min.js"></script>                            <!-- jquery 문법 -->
<script type="text/javascript" src="<%= ctxPath%>/bootstrap-4.6.0-dist/js/bootstrap.bundle.min.js" ></script>  <!-- bootstrap 문법 -->
    
 <style type="text/css">
      
      /* 아이디찾기 내용 전체 */
      div#idFind_box {
        width: 380px;
      }

      /* 이름, 이메일 박스랑 확인 버튼 */
      div#input_idFind > input,
      div#btn_idFind > input {
        width: 100%;
        padding: 12px;
        border: 1px solid gray;
        margin: 5px 0;
        opacity: 0.85;
        font-size: 17px;
        line-height: 20px;
      }

      div#input_idFind > input:hover,
      div#btn_idFind > input:hover {
        opacity: 1;
      }

      /* 이름, 이메일 박스 */
      div#input_idFind > input {
        border-radius: 4px;
      }

      /* 찾기 버튼 */
      div#btn_idFind > button[type='button'] {
        height: 45px;
        border-radius: 90px;
        background-color: #1E7F15;
        color: white;
        cursor: pointer;
      }
</style>

<script type="text/javascript">

	$(document).ready(function(){
	    
		$("button#btnFind").click(function(){
			
			// 성명 및 e메일에 대한 유효성 검사(정규표현식)
			
			$("input#input_idFind").blur( (e)=>{  // 포커스를 잃을 때 발생하는 이벤트
			
			const $target = $(e.target); 
			
			const userid = $target.val().trim();  // 이벤트 발생된 곳의 값(공백제거)
			if(userid == "") {
				// 입력하지 않거나 공백만 입력했을 경우
				$("table#tblMemberRegister :input").prop("disabled", true);  // table#tblMemberRegister 태그에 있는 :input(모든 input태그) 은 입력못하도록 비활성화시킴.
				$target.prop("disabled", false);  // 이벤트 발생된 곳의 input태그만 활성화시킴.
				
			//	$target.next().show();  // "span.error" 인 에러메시지(형제태그로 접근)
			//	또는
				$target.parent().find("span.error").show();  // "span.error" 인 에러메시지(부모태그로 접근)
			
				$target.focus();  // 마우스커서 둔다.
			}
			else {
				// 공백이 아닌 글자를 입력했을 경우
				$("table#tblMemberRegister :input").prop("disabled", false);  // table#tblMemberRegister 태그에 있는 :input(모든 input태그) 은 활성화시킴.
				
			//	$target.next().hide();  // "span.error" 인 에러메시지(형제태그로 접근)
			//	또는
				$target.parent().find("span.error").hide();  // "span.error" 인 에러메시지(부모태그로 접근)
			}
			
		} );// 아이디가 userid 인 것은 포커스를 잃어버렸을 경우(blur) 이벤트를 처리해주는 것이다.
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			const frm = document.idFindFrm;
			frm.action = "<%= ctxPath%>/login/idFind.tea";
			frm.method = "post";  // 이름 및 이메일 값이 보이지 않도록 post 방식
			frm.submit();         // post 방식으로 IdFind.java 서블릿에 전송
		});
		
		
		const method = "${requestScope.method}";  //  무조건 문자열타입으로 해줘야함. 반드시 쌍따옴표 ""
		
		if(method == "GET") {
			$("div#div_findResult").hide(); // 결과물 숨김.
		}
		
		else if(method == "POST") {  // 결과물 보여줌. 아이디찾기 입력란에 올바르게 또는 잘못 적었는지 확인할 수 있도록 입력한 값을 보여줌.
			$("input#name").val("${requestScope.name}");   // 문자열이므로 반드시 쌍따옴표 ""
			$("input#email").val("${requestScope.email}");
		}
		
	});// end of $(document).ready(function(){})-------------------------------------
	
	
	// 아이디 찾기 모달창에 입력한 input 태그 value 값 초기화 시키기
	function func_form_reset_empty() {  // 아이디 및 이메일 입력값 비워주는 메소드
		document.querySelector("form[name='idFindFrm']").reset();  // 해당 form 태그 초기화시키기
		$("div#div_findResult > p.text-center").empty();           // 결과값(입력한 아이디값이 존재하는지 유무) 비우기
	}

</script>




<div class="container">
  <form name="idFindFrm">
  
    <div id="idFind_box" class="d-flex flex-column m-auto">
      <div id="idFind_title">
        <h2 style=" text-align: center; font-size: 30px; line-height: 40px; font-weight: bold;">FIND ID</h2>
      </div>

      <div id="input_idFind" class="d-flex flex-column">
        <input type="text" name="name" id="name" placeholder="이름" autocomplete="off" required />
        <input type="text" name="email" id="email" placeholder="이메일" autocomplete="off" required />
      </div>

      <div id="btn_idFind" class="d-flex flex-column">
        <button type="button" class="btn btn-dark" id="btnFind">찾기</button>
      </div>
    </div>
    
    <div class="my-30" id="div_findResult">
	    <p class="text-center">
	       ID : <span style="color: red; font-size: 16pt; font-weight: bold;">${requestScope.userid}</span>
	    </p>
   </div>
    
  </form>
</div>

 