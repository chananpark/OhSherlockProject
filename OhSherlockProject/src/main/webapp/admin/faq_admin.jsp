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

#faqRegister{
	border-style: none;
	background-color: #1E7F15;
	color: white;
	height: 40px;
}
</style>       
    
<script>
	
	$(document).ready(()=>{
		$(".faqContainer .btn-group button").click(function(e){
			$(".faqContainer .btn-group button").removeClass("btnColor");
			$(e.target).addClass("btnColor");
		});
		
		$(".faqContainer .btn-group button#all").click();
	});
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
		<div class="btn-group col-12 text-center mb-4">
			<button type="button" class="btn" id="all">전체</button>
			<button type="button" class="btn" id="operation">운영</button>
			<button type="button" class="btn" id="product">상품</button>
			<button type="button" class="btn" id="order">주문</button>
			<button type="button" class="btn" id="delivery">배송</button>
			<button type="button" class="btn" id="member">회원</button>
			<button type="button" class="btn" id="else">기타</button>
		</div>
	</div>

	<iframe id="iframe_idFind" style="border: none; width: 100%; height: 350px;" 
	src="<%=ctxPath %>/admin/faqContent_admin.jsp"></iframe>
	
	<div class="text-right"><input type="button" id="faqRegister" value="질문 추가 등록"/></div>
</div>

<%@ include file="../footer.jsp"%>