<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>

<style>
	#cartContainer th, #cartContainer td {
		text-align: center;
		vertical-align: middle;
	}
	
	.paymentBtn {
		background-color: #1E7F15;
		color: white;
	}
	
	#cartContainer .cartList input[type=button] {
		border: none;
		border-radius: 5%;
		height: 30px;
	}
	
	#cartContainer .cartButtons input[type=button] {
		border: none;
		border-radius: 5%;
		height: 35px;
	}
</style>


<script>
	
	$(document).ready(function(){
		
		// 상품 재고의 최대 수량을 스피너에 넣어주는 것 부터 시작		
		const pqty = $("#hidden_pqty").val(); // 상품재고
		
		// 스피너
		$(".spinner").spinner({
         spin: function(event, ui) {
            if(ui.value > 100) {
               $(this).spinner("value", 100);
               return false;
            }
            else if(ui.value < 0) {
               $(this).spinner("value", 0);
               return false;
            }
         }
      });// end of $(".spinner").spinner({});-----------------
		
		// 제품번호의 모든 체크박스가 체크가 되었다가 그 중 하나만 이라도 체크를 해제하면 전체선택 체크박스에도 체크를 해제하도록 한다.
		$(".chkboxpnum").click(function(){
		   
		   var bFlag = false;
		   $(".chkboxpnum").each(function(){
		      var bChecked = $(this).prop("checked");
		      if(!bChecked) {
		         $("#cartSelectAll").prop("checked",false);
		         bFlag = true;
		         return false;
		      }
		   });
		   
		   if(!bFlag) {
		      $("#cartSelectAll").prop("checked",true);
		   }
		   
		});
	
	}); // end of $(document).ready()--------------------------
	
	
	// Function declaration
	// 장바구니 전체 선택하기
	function allCheckBox() {
	
	var bool = $("#cartSelectAll").is(":checked");
	/*
	   $("#allCheckOrNone").is(":checked"); 은
	     선택자 $("#allCheckOrNone") 이 체크되어지면 true를 나타내고,
	     선택자 $("#allCheckOrNone") 이 체크가 해제되어지면 false를 나타내어주는 것이다.
	*/
	
	$(".chkboxpnum").prop("checked", bool);
	}// end of function allCheckBox()-------------------------

</script>

<div class="container" id="cartContainer">
	<div class="mb-4">
		<h2 style="font-weight: bold">장바구니</h2><br>
		<hr style="background-color: black; height: 1.2px;"><br>
	</div>
	<div class="cartList">
		<table class="table mt-4">
			<thead class="thead-light">
				<tr>
					<th>
						<input type="checkbox" id="cartSelectAll" name="cartSelectAll" value="cartSelectAll" onClick="allCheckBox();" />
						<label for="cartSelectAll">전체선택</label>
					</th>
					<th colspan="2">상품정보</th>
					<th>수량</th>
					<th>가격</th>
					<th>처리</th>
				</tr>
			</thead>
			<tbody>
				<c:if test="${empty requestScope.cartList}">
	            	<tr>
	                	<td colspan="6" align="center">
	                    	<span style="font-weight: bold;" class="text-secondary mt-1">
	                        	장바구니에 담긴 상품이 없습니다.
	                      	</span>
	                    </td>   
	               	</tr>
	            </c:if>
	               
	            <c:if test="${not empty requestScope.cartList}">
               		<c:forEach var="cartvo" items="${requestScope.cartList}" varStatus="status"> 
						<tr>
							<td>
								<input type="checkbox" id="pnum${status.index}" name="pnum" value="${cartvo.pnum}" class="chkboxpnum"/>
							</td>
							<td>
								<a href="<%=ctxPath%>/shop/productView.tea?pnum=${cartvo.pnum}">
									<img src="<%=ctxPath%>/images/${cartvo.prod.pimage}" width="100"/>
								</a>
							</td>
							<td>${cartvo.prod.pname}</td>
							<td>
								<input class="spinner oqty" style="width:100px" value="${cartvo.oqty}" min="1" max="${cartvo.prod.pqty}" required/>
							</td>
							<td>
								<fmt:formatNumber value="${cartvo.prod.saleprice}" pattern="###,###" /> 원
								<input type="hidden" name="price" value="${cartvo.prod.price}"/>
								<input type="hidden" name="saleprice" value="${cartvo.prod.saleprice}"/>
							</td>
							<td><p><input class="paymentBtn" type="button" value="바로구매" onclick="goOrder();"/></p>
							<p><input type="button" value="상품삭제" onclick="goDel('${cartvo.cartno}')"/></p></td>
						</tr>
						
						<%-- 재고 알아오는 hidden 태그 --%>
						<input type="hidden" id="hidden_pqty" value="${cartvo.prod.pqty}"/>
					</c:forEach>
				</c:if>
			</tbody>
		</table>
	</div>
	
	<div class="cartTotal" >
		<table class="table table-active table-borderless">
		    <tbody class="text-right">
		      <tr>
		        <td class="col col-9 text-left">상품금액</td>
		        <td class="col col-3 text-right"><fmt:formatNumber value="${requestScope.sumMap.SUMTOTALPRICE}" pattern="###,###" /></td>
		      </tr>
		      <tr>
		        <td class="col col-9 text-left">적립예정찻잎</td>
		        <td class="col col-3 text-right">1,000</td>
		      </tr>
		      <tr>
		        <td class="col col-9 text-left">할인금액</td>
		        <td class="col col-3 text-right text-danger">1,000</td>
		      </tr>
		      <tr>
		        <td class="col col-9 text-left">배송비</td>
		        <td class="col col-3 text-right">2,500</td>
		      </tr>
		      <tr>
		        <td class="col col-9 text-left" style="color:#1E7F15; font-weight:bolder;"><h4>결제예정금액</h4></td>
		        <td class="col col-3 text-right" style="color:#1E7F15; font-weight:bolder"><h4>19,500</h4></td>
		      </tr>
		    </tbody>
		  </table>
	</div>
	
	<div class="cartButtons mt-5">
		<span class="float-right"><input class="paymentBtn" type="button" value="전체상품 주문"/></span>
		<span class="float-right mr-3"><input type="button" value="선택상품 주문"/></span>
		<span class="float-right mr-3"><input type="button" value="장바구니 비우기"/></span>
	</div>
</div>
<%@ include file="../footer.jsp"%>