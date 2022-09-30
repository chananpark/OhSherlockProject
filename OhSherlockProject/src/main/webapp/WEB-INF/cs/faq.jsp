<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>    
    
<style>
.faqContainer .page-link {
	color: #666666;
	background-color: #fff;
	border: 1px solid #ccc;
}

.faqContainer .page-item.active .page-link {
	z-index: 1;
	color: #1E7F15;
	border-color: #1E7F15;
}

.faqContainer .page-link:focus, .page-link:hover {
	color: #1E7F15;
	background-color: #fafafa;
	border-color: #1E7F15;
}

.faqContainer .btn-group{
	width:80%;
	height: 50px;
}
.faqContainer .btn-group button{
	border: solid 1px gray;
	border-collapse: collapse;
}

.btnColor {
	color: white;
	background-color: #1E7F15;
}

.btn:focus,.btn:active {
   outline: none !important;
   box-shadow: none;
}

#faqRegister > input[type=button]{
	border-style: none;
	background-color: #1E7F15;
	color: white;
	height: 40px;
	padding: 0 10px;
}

#btngroup > button { 
	font-weight:bold;
}
.accordion {
	font-family: 'Gowun Dodum', sans-serif;
}

#faqAccordion button {
	color: black;
	text-decoration: none;
}

#faqAccordion button:hover {
	cursor: pointer;
	color: #1E7F15;
}

#faqAccordion .btn:focus, #faqAccordion .btn:active {
   outline: none !important;
   box-shadow: none;
}

</style>       
    
<script>
	
	$(document).ready(()=>{
		
		<%-- 클릭이벤트 바인딩 --%>
		$(".faqContainer .btn-group button").click(function(e){
			$(".faqContainer .btn-group button").removeClass("btnColor");
			$(e.target).addClass("btnColor");
		});
		
		$(".faqContainer .btn-group button#all").click();
		
		<%-- 세션에 저장된 userid가 admin(관리자)일 때만 질문 추가 등록 버튼을 노출시킨다.--%>
		$("#faqRegister").hide();
		
		if ("${sessionScope.loginuser.userid}" == 'admin' && "${sessionScope.loginuser.userid}" != null) {
			$("#faqRegister").show();
		}
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////
		// 질문 추가 등록 클릭 시 이벤트
		$("#faqRegister").click(()=>{
			 location.href = "<%=ctxPath%>/cs/faqRegister.tea";
		});
		
		
		
		
	}); // end of $(document).ready
	
	<%-- 세션에 저장된 userid가 admin(관리자)일 때만 수정/삭제 버튼을 노출시킨다.--%>
	$(function() {
		$(".adminOnlyBtns").hide();
		
		if ("${sessionScope.loginuser.userid}" == 'admin' && "${sessionScope.loginuser.userid}" != null) {
			$(".adminOnlyBtns").show();
		}
	});
	
	// 질문 수정하기 버튼 클릭 시 이벤트
	function faqEdit_click(faq_num) {
		location.href = "<%=ctxPath%>/cs/faqEdit.tea?faq_num="+faq_num;
	} // end of function faqEdit_click(faq_num)
	
	// 질문 삭제하기 버튼 클릭 시 이벤트
	function faqDelete_click(faq_num) {
		if (confirm("정말 삭제하시겠습니까??") == true){    //확인
			console.log(faq_num);
			location.href = "<%=request.getContextPath() %>/cs/faqDelete.tea?faq_num="+faq_num; 
		}else{   //취소
		    return false;
		}
	} // end of function faqDelete_click(faq_num)
	
	// 각 카테고리 버튼을 클릭했을 경우의 메소드
	function click_category(selectid) {
		let html = "";
		
		// 페이지는 그대로 있으면서 데이터에서 상품을 가져와서 ajax 로 뿌려준다.
		$.ajax({
			url: "<%= request.getContextPath() %>/cs/faqContentJSON.tea",
		//	type: "GET",
			data: {"selectid":selectid}, 	 
			dataType: "JSON", // 성공하면 JSON 형태로 넣어주어야 한다.
			success: function(json){ // 올바르게 값을 가져왔으면 버튼의 값을 바꿔준다.
				
				if( json.length == 0 ) { 
					html += " "; // 나중에 적어줘야하는데 여기 적어주면 에러나니까 그냥 자주묻는 질문은 무조건 다 나오는 걸로 하는 건 어떤지..?
	                
	                // HIT 상품 결과를 출력하기
	                $("div#faqAccordion").html(html);
	                
				} else if( json.length > 0 ) {	
					// 상품이 있는 경우
					$.each(json, function(index, item){ 
						
						html += "<div class='card'>" + 
								"	<div class='card-header' id='heading"+item.faq_num+"'>" +								
								"		<h2 class='mb-0'>" +
								"			<button class='btn btn-link' type='button' data-toggle='collapse' data-target='#collapse"+item.faq_num+"' aria-expanded='true' aria-controls='collapseOne'>" + 
											item.faq_subject +
								"			</button>" +
								"		</h2>" +
								"	</div>";
							
					// 전체에서만 아코디온 닫아주고 다른 부분에서는 펼쳐주는 조건문
					if( selectid != "all"){
						html += "	<div id='collapse"+item.faq_num+"' class='collapse show' aria-labelledby='heading"+item.faq_num+"'data-parent='#faqAccordion'>";
					} else {
						html += "	<div id='collapse"+item.faq_num+"' class='collapse' aria-labelledby='heading"+item.faq_num+"'data-parent='#faqAccordion'>";
					}
						
						html += "		<div class='card-body'>" +
								 item.faq_content;
						
					// 관리자로 로그인 했을 경우만 수정, 삭제버튼 보여주기
					if(${sessionScope.loginuser.userid == 'admin' && not empty sessionScope.loginuser.userid}) {
						html += "<div class='text-right adminOnlyBtns mb-1'> " +
		                  		"	<input id='faqEdit' type='button' value='수정' style='border-style: none;' onclick='faqEdit_click("+item.faq_num+")'/>" +
								"	<input id='faqdelete' class='btn-dark' type='button' value='삭제' style='border-style: none;' onclick='faqDelete_click("+item.faq_num+")'/> " +
		               			"</div>";
					} else {
						html += " ";
					}
							
						html += "		</div>" +
								"	</div>" +
								"</div>";
						
					});  // end of $.each(json, function(index, item)		
					
					// HIT 상품 결과를 출력하기
					$("div#faqAccordion").html(html); // html 을 기존의 코드에 덮어씌우는 것이기 때문에 뒤에 쌓아주는 append 를 사용한다.
							
				} // end of 상품이 있는 경우와 없는 경우이 if-else
			},  // end of success
			
			error: function(request, status, error){
	        	alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
	        }
		}); // end of ajax
		
		
	} // end of function click_category()
	
	
</script>
    
    
<div class="container faqContainer">

	<div class="titleZone row">
		<h2 class="col text-left" style="font-weight: bold">자주묻는질문</h2>
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
	<%-- 특정 버튼 클릭했을때 버튼 아이디를 request영역에 담아서 요청을 보내고
		거기에 해당하는 글들을 db에서 가져온 뒤 faqContent.jsp에 보여준다. --%>
 
	<div class="row">
		<div id="btngroup" class="btn-group col-12 text-center mb-4">
			<button type="button" class="btn" id="all" onclick="click_category('all')">전체</button>
			<button type="button" class="btn" id="operation" onclick="click_category('operation')">운영</button>
			<button type="button" class="btn" id="product" onclick="click_category('product')">상품</button>
			<button type="button" class="btn" id="order" onclick="click_category('order')">주문</button>
			<button type="button" class="btn" id="delivery" onclick="click_category('delivery')">배송</button>
			<button type="button" class="btn" id="member" onclick="click_category('member')">회원</button>
			<button type="button" class="btn" id="else" onclick="click_category('else')">기타</button>
		</div>
	</div>

	
	<%-- 아코디온 시작 --%>
	<div class="accordion" id="faqAccordion" style="border: none; width: 100%; margin-bottom:100px;"></div>
	<%-- 아코디온 끝 --%>
	
	<%-- 로그인 된 사용자가 관리자일 경우에만 나타나도록 함 --%>
	<c:if test="${sessionScope.loginuser ne null and loginuser.userid eq 'admin' }">
		<div class="text-right" id="faqRegister">
			<input type="button" value="질문 추가 등록" class="btn"/>
		</div>
	</c:if>		
	
</div>

<%@ include file="../footer.jsp"%>