<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>    

<style>
	button {
		border-style: none;
	}
	
	input[type=button] {
		border-style: none;
	}
	
	.page-link {
	  color: #666666; 
	  background-color: #fff;
	  border: 1px solid #ccc; 
	}
	
	.page-item.active .page-link {
	 z-index: 1;
	 color: #1E7F15;
	 border-color: #1E7F15;
	 
	}
	
	.page-link:focus, .page-link:hover {
	  color: #1E7F15;
	  background-color: #fafafa; 
	  border-color: #1E7F15;
	}
	
</style>

<script type="text/javascript">


	$(document).ready(function(){

		// 신규 상품 등록 버튼 클릭할때
		$("input#btn_goProdRegister").click(function() {
			//=== 신규 상품 등록 === //
			location.href = "<%= ctxPath%>/admin/prod_mgmt_register.tea";
		});
    
		
		//=== 상품 정보 수정 === //



    
 });// end of $(document).ready(function(){})-----------------------------

 


</script>

<div class="container">

   <h2 class="col text-left" style="font-weight:bold">상품관리</h2><br>
   <hr style="background-color: black; height: 1.2px;"><br>
  
  	<div class="text-right">
	  	<input type="text" placeholder="상품코드를 입력하세요"/>&nbsp;
	  	<button type="button"><i class="fas fa-search"></i></button>
  	</div>
  	
  	
  	<table class="table mt-4 prodList text-center">
			<thead class="thead-light">
				<tr>
					<th>상품코드</th>
					<th>상품명</th>
					<th>가격</th>
					<th>할인가격</th>
					<th>재고</th>
					<th>처리</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="pvo" items="${requestScope.productList}">
					<tr>
						<td name="p_code" >${pvo.p_code}</td>
						<td name="p_name">${pvo.p_name}</td>
						<td name="p_price">${pvo.p_price}</td>
						<td name="p_discount_rate">${pvo.p_discount_rate}</td>
						<td name="p_stock">${pvo.p_stock}</td>
						<td>
						<div class="adminOnlyBtns mb-1">
							<input type="button" value="수정" /> 
						</div>
						</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
		
		 <div class="text-right" style="margin-top: 50px;">
	      	<input type="button" id="btn_goProdRegister" class="writeBtns" value="신규 상품 등록" style="margin-left: 5px; background-color: #1E7F15; color:white;" />
		</div>
  
		
		<nav aria-label="Page navigation example" style="margin-top: 60px;">
		<ul class="pagination justify-content-center">
			<li class="page-item"><a class="page-link" href="#"
				aria-label="Previous"> <span aria-hidden="true">&laquo;</span>
			</a></li>
			<li class="page-item"><a class="page-link" href="#">1</a></li>
			<li class="page-item"><a class="page-link" href="#">2</a></li>
			<li class="page-item"><a class="page-link" href="#">3</a></li>
			<li class="page-item"><a class="page-link" href="#"	aria-label="Next"> <span aria-hidden="true">&raquo;</span>
			</a></li>
		</ul>
	</nav>
</div>

<%@ include file="../footer.jsp"%>