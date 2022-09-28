<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<% String ctxPath = request.getContextPath(); %>    
    
<!-- Required meta tags -->
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    
<!-- Bootstrap CSS -->
<link rel="stylesheet" type="text/css" href="<%= ctxPath%>/bootstrap-4.6.0-dist/css/bootstrap.min.css" > 
    
<!-- 직접 만든 CSS -->
<link rel="stylesheet" type="text/css" href="<%= ctxPath%>/css/style.css" />

<!-- Optional JavaScript -->
<script type="text/javascript" src="<%= ctxPath%>/js/jquery-3.6.0.min.js"></script>                          
<script type="text/javascript" src="<%= ctxPath%>/bootstrap-4.6.0-dist/js/bootstrap.bundle.min.js" ></script>
    
 <style type="text/css">
 
      * {
        font-family: 'Gowun Dodum', sans-serif;
      } 
       
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
        border-style: none;;
        border-radius: 90px;
        background-color: #1E7F15;
        color: white;
        cursor: pointer;
      }
      
      #div_findResult {
      	margin-top: 30px;
      	font-weight: bold;
      	font-size: 13pt; 
      }
      
      .findResult {
      	color: #1E7F15; 
      	font-size: 14pt; 
      	font-weight: bold;
      }      
      
      
</style>

<script type="text/javascript">

	$(document).ready(function(){
		
		$("span.error").hide();       
		$("input#name").focus();
	    
		
		$("input#name").blur( (e)=>{
			
			const $target = $(e.target); 
			
			const name = $target.val().trim();  
			if(name == "") {
				// 입력하지 않거나 공백만 입력했을 경우
				$("div#input_idFind :input").prop("disabled", true);  // 모든 input태그 비활성화
				$target.prop("disabled", false); 
				
				$target.next().show();  // 에러메시지
				$target.focus();
			}
			else {
				// 공백이 아닌 글자를 입력했을 경우
				$("div#input_idFind :input").prop("disabled", false);  // 모든 input태그 활성화 
				$target.next().hide();
			}
			
		} );
		
		
		$("input#email").blur( (e)=>{
			
			const $target = $(e.target);
			
			const regExp = new RegExp(/^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i);
			
			const bool = regExp.test($target.val());  // 정규표현식에 맞는지 검사한다.
			
			if(!bool) {
				// 이메일이 정규표현식에 위배된 경우
				$("div#input_idFind :input").prop("disabled", true);  
				$target.prop("disabled", false);
				
		        $target.next().show();  
				$target.focus();  
			}
			else {
				// 이메일이 정규표현식에 맞는 경우
				$("table#tblMemberRegister :input").prop("disabled", false);  
				
				$target.next().hide();  
			}
			
		} );
		
		
		
		$("button#btnFind").click(function(){
			
			const frm = document.idFindFrm;
			frm.action = "<%= ctxPath%>/login/idFind.tea";
			frm.method = "post";  
			frm.submit();    // post 방식으로 IdFind.java 서블릿에 전송
		});
		
		
		const method = "${requestScope.method}"; 
		
		if(method == "GET") {
			$("div#div_findResult").hide(); 
		}
		
		else if(method == "POST") {   // 입력한 값을 보여줌.
			$("input#name").val("${requestScope.name}");  
			$("input#email").val("${requestScope.email}");
		}
		
	});// end of $(document).ready(function(){})-------------------------------------
	
	
	// 아이디 찾기 모달창에 입력한 input 태그 value 값 초기화 시키기
	function func_form_reset_empty() {  // 아이디 및 이메일 입력값 비워주는 메소드
		document.querySelector("form[name='idFindFrm']").reset();  // 해당 form 태그 초기화시키기
		$("div#div_findResult > p.text-center").empty();           // 결과값 비우기
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
        <span class="error" style="color: #df2020;">이름을 입력하지 않으셨습니다.</span>
        <input type="text" name="email" id="email" placeholder="이메일" autocomplete="off" required />
        <span class="error" style="color: #df2020;">이메일 형식에 맞지 않습니다.</span>
      </div>

      <div id="btn_idFind" class="d-flex flex-column">
        <button type="button" class="btn btn-dark" id="btnFind" style="margin-top: 4px;">찾기</button>
      </div>
    </div>
    
    <c:if test="${requestScope.userid ne 'fail'}">
         <div class="my-30" id="div_findResult">
		    <p class="text-center">
		       ${requestScope.name} 님의 아이디는 <span class="findResult">${requestScope.userid}</span> 입니다.
		    </p>
	     </div>
    </c:if>
      
    <c:if test="${requestScope.userid eq 'fail'}">
         <div class="my-30" id="div_findResult">
		    <p class="text-center">
		       <span>입력하신 정보로는 검색이 되지 않습니다. <br>확인후 다시 진행해 주시기 바랍니다.</span>
		    </p>
	     </div>
    </c:if>
    
    
    
  </form>
</div>

 