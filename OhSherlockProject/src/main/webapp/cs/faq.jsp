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
</style>       
    
<script>
	
	$(document).ready(()=>{
		$(".faqContainer .btn-group button").click(function(e){
			$(e.target).toggleClass("btnColor");
		});
		
		$(".faqContainer .btn-group button#btnAll").click();
	});

</script>
    
    
<div class="container faqContainer">

	<h2 style="font-weight:bold">자주묻는질문</h2><br>
		<hr style="background-color: black; height: 1.2px;"><br>

	<div class="row">
		<div class="btn-group col-12 text-center mb-4">
			<button type="button" class="btn" id="btnAll">전체</button>
			<button type="button" class="btn" id="btnOp">운영</button>
			<button type="button" class="btn" id="btnProd">상품</button>
			<button type="button" class="btn" id="btnOrder">주문</button>
			<button type="button" class="btn" id="btnDlv">배송</button>
			<button type="button" class="btn" id="btnMbr">회원</button>
			<button type="button" class="btn" id="btnElse">기타</button>
		</div>
	</div>

	<iframe id="iframe_idFind" style="border: none; width: 100%; height: 350px;" 
	src="<%=ctxPath %>/cs/faqContent.jsp"></iframe>
</div>

<%@ include file="../footer.jsp"%>