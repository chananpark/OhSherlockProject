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
	}
	
	#cartContainer .cartButtons input[type=button] {
		border: none;
	}
</style>


<script>

	$(document).ready(function(){
		
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
	
	
	// === 장바구니 현재주문수량 수정하기 === // 
   	function goOqtyEdit(obj) {
      
		// 클릭한 수정버튼의 index 알아오기
		const index = $("button.updateBtn").index(obj); 
      
   		// 수정해야할 장바구니 번호
   		const cartno = $("input.cartno").eq(index).val(); 

  		// 수정해야할 장바구니 개수
  		const oqty = $("input.oqty").eq(index).val();
      
  		// 숫자만 체크하는 정규표현식
  		const regExp = /^[0-9]+$/g; 
  		const bool = regExp.test(oqty);
   
   		if(!bool) {
		    alert("수정하시려는 수량은 0개 이상이어야 합니다.");
        	location.href="cart.tea";
         	return;
      	}
   		
		if(oqty == "0") {
        	goDel(cartno);
      	}
      	else {
        	$.ajax({
            	url:"<%= request.getContextPath()%>/cart/cartEdit.tea",
               	type:"POST",
               	data:{"cartno":cartno,
                      "oqty":oqty},
               	dataType:"JSON",
               	success:function(json){
               		// {n:1}
                	if(json.n == 1) {
                    	alert("주문수량이 정상적으로 변경되었습니다.");   
                     	location.href = "cart.tea";
                  	}
               	},
               	error: function(request, status, error){
                	alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
               	}
			});
      	}
 
	}// end of function goOqtyEdit(obj)-----------------
	
	
	// === 장바구니에서 특정 제품을 비우기 === //  
	function goDel(cartno) {
      
    	const $target = $(event.target);
		const bool = confirm("선택하신 상품을 장바구니에서 삭제하시겠습니까?");
		
    	if(bool) {
        
    		$.ajax({
        		url:"<%= request.getContextPath()%>/cart/cartDel.tea",
            	type:"POST",
            	data:{"cartno":cartno},
	            dataType:"JSON",
	            success:function(json){
            		// {n:1} 의 객체 상태로 넘어온다.
            	
               		if(json.n == 1) { 
						// 다시 장바구니 목록을 보여준다.
               			location.href = "cart.tea"; // 장바구니 보기는 페이징처리를 안함.
               		}
            	},
           		error: function(request, status, error){
               		alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
            	}
			});
         
		}
    	else {
    		alert("선택하신 상품 삭제를 취소하셨습니다.");
    	}
      
  	}// end of function goDel(cartno)---------------------------

  	// 체크박스 클릭했을 때 총합 알아오기
  	function clickCheckBox(frm) {

  		var totalSalePriceSum = 0;
  		var totalPointSum = 0;
  		var totalDiscountSum = 0;
  		
		var count = frm.pnum.length;
	  	for(var i=0; i < count; i++ ){
	  		if( frm.pnum[i].checked == true ){
  				totalSalePriceSum += parseInt(frm.saleprice[i].value);
  				totalPointSum += parseInt(frm.point[i].value);
  				totalDiscountSum += (parseInt(frm.price[i].value) - parseInt(frm.saleprice[i].value));
      		}
		}
	  	
		
		$("#ValTotalPrice").html(totalSalePriceSum.toLocaleString('en'));
		$("#ValTotalPoint").html(totalPointSum.toLocaleString('en'));
		$("#ValTotalDiscount").html(totalDiscountSum.toLocaleString('en'));
 		
 	} // end of function clickCheckBox(this)
  	
 	
 	// 장바구니 선택상품 삭제하기
    function goSelectDel() {
        
    	const allCnt = $("input:checkbox[name='pnum']").length; // 전체 체크박스의 개수(체크여부 상관없음)
      
      	const cartnoArr = new Array();  // 장바구니목록번호 배열
      
      	for(var i=0; i<allCnt; i++) { 
         
        	if($("input:checkbox[name='pnum']").eq(i).is(":checked")) {  // 전체 체크박스 배열중에서 한개를 끄집어온 것이 체크가 되었다면
        		cartnoArr.push( $("input.cartno").eq(i).val() );         // 체크된 체크박스의 찜번호값을 찜목록번호배열에 쌓아둔다.
         	}

      	}// end of for------------------------------------
      
      	const cartnojoin =  cartnoArr.join(); // 배열을 문자열로 합쳐주는 것. ["1","2"] -> ["1,2"]
      
      	if(cartnojoin != "") {
    	  
	    	const bool = confirm("선택한 상품을 삭제하시겠습니까?");
	      
	      	if(bool) {
	         
	        	$.ajax({
		            url:"<%= request.getContextPath()%>/cart/cartSelectDel.tea",
		            type:"POST",
		            data:{"cartnojoin":cartnojoin},
		            dataType:"JSON",
		            success:function(json) {
	                	console.log("확인: "+json.n);
		               	if(json.n == 1) { 
		                	location.href = "cart.tea"; // 삭제가 반영된 찜목록을 보여준다. 찜목록은 페이징처리를 안함.
		               	}
             		},
		            error: function(request, status, error){
		               alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
		            }
	        	});
			}
    	  
     	}
     	else {
     		alert("선택한 상품이 없습니다.");
		}
      
	}// end of function goSelectDel() {}------------------- 
   
  	
</script>

<form name="cartFrm">
	
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
						<input type="checkbox" id="cartSelectAll" name="cartSelectAll" value="cartSelectAll" onClick="allCheckBox('${cartvo.cartno}'); clickCheckBox(this.form);" />
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
								<input type="checkbox" id="pnum${status.index}" name="pnum" value="${cartvo.pnum}" class="chkboxpnum" onclick="clickCheckBox(this.form)"/>
							</td>
							<td>
								<a href="<%=ctxPath%>/shop/productView.tea?pnum=${cartvo.pnum}">
									<img src="<%=ctxPath%>/images/${cartvo.prod.pimage}" width="100"/>
								</a>
							</td>
							<td class="cart_pname">${cartvo.prod.pname}</td>
							<td>
								<input class="spinner oqty" style="width:50px" value="${cartvo.oqty}"  required/>
								<button type="button" class="updateBtn btn bg-light text-dark p-2" style="width:50px" onclick="goOqtyEdit(this)" >수정</button>
	 						</td>
							<td>
								<fmt:formatNumber value="${cartvo.prod.saleprice*cartvo.oqty}" pattern="###,###" /> 원
							</td>
							<td>
								<p><input class="paymentBtn btn" type="button" value="바로구매" onclick="goOrder();"/></p>
								<p><input class="btn bg-light text-dark" type="button" value="상품삭제" onclick="goDel('${cartvo.cartno}')"/></p>
							</td>
						</tr>
						
						<%-- 히든태그 목록 --%>
						<input type="hidden" id="hidden_cartno" class="cartno" value="${cartvo.cartno}" /> 
						<input type="hidden" id="hidden_pnum" value="${cartvo.pnum}" />
						<input type="hidden" id="hidden_pqty" value="${cartvo.prod.pqty}" />
						<input type="hidden" id="hidden_price" name="price" value="${cartvo.prod.price}"/>
						<input type="hidden" id="hidden_saleprice" name="saleprice" value="${cartvo.prod.saleprice}"/>
						<input type="hidden" id="hidden_point" name="point" value="${cartvo.prod.point}" />
						
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
		        <td class="col col-3 text-right"><span id="ValTotalPrice">0</span></td>
		      </tr>
		      <tr>
		        <td class="col col-9 text-left">적립예정찻잎</td>
		        <td class="col col-3 text-right"><span id="ValTotalPoint">0</span></td>
		      </tr>
		      <tr>
		        <td class="col col-9 text-left">할인금액</td>
		        <td class="col col-3 text-right text-danger"><span id="ValTotalDiscount">0</span></td>
		      </tr>
		      <tr>
		        <td class="col col-9 text-left">배송비</td>
		        <td class="col col-3 text-right">
		        	<c:if test="${requestScope.sumMap.SUMTOTALPRICE >= 30000}">
		        		배송비 무료
		        	</c:if>
		        	<c:if test="${requestScope.sumMap.SUMTOTALPRICE < 30000}">
		        		2,500
		        	</c:if>
		        </td>
		      </tr>
		      <tr>
		        <td class="col col-9 text-left" style="color:#1E7F15; font-weight:bolder;"><h4>결제예정금액</h4></td>
		        <td class="col col-3 text-right" style="color:#1E7F15; font-weight:bolder">
		        	<h4>
		        		<c:if test="${requestScope.sumMap.SUMTOTALPRICE >= 30000}">
			        		<fmt:formatNumber value="${requestScope.sumMap.SUMTOTALPRICE}" pattern="###,###" />
			        	</c:if>
			        	<c:if test="${requestScope.sumMap.SUMTOTALPRICE < 30000}">
			        		<fmt:formatNumber value="${requestScope.sumMap.SUMTOTALPRICE + 2500}" pattern="###,###" />
			        	</c:if>
	        		</h4>
	        	</td>
		      </tr>
		    </tbody>
		  </table>
	</div>
	
	<div class="cartButtons mt-5">
		<span class="float-right"><input class="paymentBtn btn" type="button" value="전체상품 주문"/></span>
		<span class="float-right mr-3"><input type="button" class="btn bg-light text-dark" value="선택상품 주문"/></span>
		<span class="float-right mr-3"><input type="button" class="btn bg-light text-dark" value="선택상품 삭제" onclick="goSelectDel();"/></span>
	</div>
</div>
</form>
<%@ include file="../footer.jsp"%>