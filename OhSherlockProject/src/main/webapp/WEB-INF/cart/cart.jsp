<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>

<style>
	#cartContainer th, #cartContainer td {
		text-align: center;
		vertical-align: middle;
	}
	
	#orderBtn {
		background-color: #1E7F15;
		color: white;
	}
	
	#cartContainer .cartList input[type=button] {
		border: none;
	}
	
	#cartContainer .cartButtons input[type=button] {
		border: none;
	}
	
	a {
		text-decoration: none;
	}
	
	a:link {
		text-decoration: none;
	}
	
	a:hover  {
		text-decoration: none;
	}
	
	a:visited  {
		text-decoration: none;
		color: black;
	}
</style>


<script>

	$(document).ready(function(){
		
		// 스피너
		$(".spinner").spinner({
        	spin: function(event, ui) {
	            if(ui.value > 50) {
	            	$(this).spinner("value", 50);
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
      
       // 장바구니에 담긴 상품의 재고
       const pqty = $("input.pqty").eq(index).val();
          
       
       if(!bool) {
        alert("수정하시려는 수량은 0개 이상이어야 합니다.");
         location.href="cart.tea";
          return;
       }
       
       if( Number(oqty) > Number(pqty) ) {
          alert("수정하시려는 수량이 상품 재고보다 많습니다.");
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

  	// 체크박스 클릭했을 때 총합 보여주기
  	function clickCheckBox(frm) {
  		$("#DeliveryPrice").html('0');
  		
  		var totalSalePriceSum = 0;
  		var totalPointSum = 0;
  		var totalDiscountSum = 0;
  		
		var count = frm.pnum.length;
		if(count == undefined) count = 1;
		
		if( count == 1) {
			if( frm.pnum.checked == true ){
				totalSalePriceSum = parseInt( (frm.saleprice.value)*(frm.oqty.value) );
				totalPointSum += parseInt( (frm.point.value)*(frm.oqty.value) );
				totalDiscountSum += (parseInt( (frm.price.value)*(frm.oqty.value)) - parseInt( (frm.saleprice.value)*(frm.oqty.value) ));
			}	
		} else if (count > 1) {
		
		  	for(var i=0; i < count; i++ ){
		  		if( frm.pnum[i].checked == true ){
	  				totalSalePriceSum += parseInt( (frm.saleprice[i].value)*(frm.oqty[i].value) );
	  				totalPointSum += parseInt( (frm.point[i].value)*(frm.oqty[i].value) );
	  				totalDiscountSum += (parseInt( (frm.price[i].value)*(frm.oqty[i].value)) - parseInt( (frm.saleprice[i].value)*(frm.oqty[i].value) ));
	      		}
			}
	  	
		}
		
		$("#ValTotalPrice").html(totalSalePriceSum.toLocaleString('en')+"원");
		$("#ValTotalPoint").html(totalPointSum.toLocaleString('en')+"찻잎");
		$("#ValTotalDiscount").html(totalDiscountSum.toLocaleString('en')+"원");
		
		if( totalSalePriceSum >= 30000 ) {
			$("#DeliveryPrice").html('배송비 무료');
			$("#TotalOrderPrice").html(totalSalePriceSum.toLocaleString('en')+"원")
		} else if( totalSalePriceSum < 30000 && totalSalePriceSum > 0 ) {
			$("#DeliveryPrice").html('2,500원');
			$("#TotalOrderPrice").html((totalSalePriceSum+2500).toLocaleString('en')+"원")
		} else {
			$("#DeliveryPrice").html('0원');
			$("#TotalOrderPrice").html('0원');
		}
		
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
   
	
	// 체크박스에 선택한 상품만 주문
	function goChkOrder() {
		///// == 체크박스의 체크된 갯수(checked 속성이용) == /////
       	const checkCnt = $("input:checkbox[name='pnum']:checked").length;
       
      	if(checkCnt < 1) {
          	alert("주문하실 제품을 선택하세요.");
          	return; // 종료 
       	} else {
        	//// == 체크박스에서 체크된 value값(checked 속성이용) == ////
            ///  == 체크가 된 것만 값을 읽어와서 배열에 넣어준다. /// 
            // 다수의 상품을 보내는 것이기 때문에 java 에서 getParameterValues로 받아와야 한다.
            
            const allCnt = $("input:checkbox[name=pnum]").length; // 모든 체크박스의 개수
            
            const pnumArr = new Array(); // 제품번호 // DB에 넣기 위해서 받아오는데, 상품이 여러개 일 수 있으니 배열로 받아온다
            const pnameArr = new Array(); 
            const oqtyArr = new Array(); // 제품수량
            const cartnoArr = new Array(); // 장바구니번호
            const imageArr = new Array(); // 상품 이미지
            const totalOriginalPriceArr = new Array(); // 전체 가격
            const totalPriceArr = new Array(); // 전체 가격
            const totalPointArr = new Array(); // 전체 포인트
            
           
            for(var i=0; i<allCnt; i++) {
                if( $("input:checkbox[name=pnum]").eq(i).is(":checked") ) { // .eq(i) 첫번째 체크박스가 체크되어져 있다면 꺼내온다.
					pnumArr.push( $("input:checkbox[name=pnum]").eq(i).val() ); // 체크박스의 value 값 ${cartvo.pnum} 
					pnameArr.push( $("input.pname").eq(i).val() ); 
					oqtyArr.push( $("input.oqty").eq(i).val() ); // input 태그의 oqty의 value 값은 ${cartvo.oqty} 이다.
					cartnoArr.push( $("input.cartno").eq(i).val() ); // input 태그의 cartno의 값은 ${cartvo.cartno} 이다.
					imageArr.push( $("input.images").eq(i).val() ); 
					totalPriceArr.push( $("input.totalPrice").eq(i).val() ); // fmt 으로 값을 찍어주기만 하고, input 태그는 hidden 타입으로 감추어서 ajax 로 넘겨준다. ${cartvo.prod.totalPrice} 
					totalPointArr.push( $("input.totalPoint").eq(i).val() );
					totalOriginalPriceArr.push( $("input.price").eq(i).val() );
               	}
            }// end of for---------------------------
               
            const pnumjoin = pnumArr.join();
            const pnamejoin = pnameArr.join();
            const oqtyjoin = oqtyArr.join();
            const cartnojoin = cartnoArr.join();
            const imagejoin = imageArr.join();
            const totalPricejoin = totalPriceArr.join();

            let sumtotalPrice = 0;
            for(var i=0; i<totalPriceArr.length; i++) {
            	sumtotalPrice += Number(totalPriceArr[i]); // string 으로 받아오기 때문에 단순한 문자열 결합이 된다. 따라서 int로 값을 바꾸고 값을 더해야한다.
            }

            let sumtotalOriginalPrice = 0;
            for(var i=0; i<totalOriginalPriceArr.length; i++) {
            	sumtotalOriginalPrice += Number(totalOriginalPriceArr[i]);
            }

            let sumtotalPoint = 0;
            for(var i=0; i<totalPointArr.length; i++) {
            	sumtotalPoint += Number(totalPointArr[i]);
            }
            
            const str_sumtotalPrice = sumtotalPrice.toLocaleString('en'); // 자바스크립트에서 숫자 3자리마다 콤마 찍어주기  
                   
           	var bool = confirm("총주문액 : "+str_sumtotalPrice+"원 결제하시겠습니까?");
              
            if(bool) {
            	$("#pnumjoin").val(pnumjoin);
            	$("#pnamejoin").val(pnamejoin);
    			$("#oqtyjoin").val(oqtyjoin);
    			$("#cartnojoin").val(cartnojoin);
    			$("#imagejoin").val(imagejoin);
    			$("#totalPricejoin").val(totalPricejoin);
    			$("#sumtotalPrice").val(sumtotalPrice);
    			$("#sumtotalOriginalPrice").val(sumtotalOriginalPrice);
    			$("#sumtotalPoint").val(sumtotalPoint);
    			
    			const frm = document.cartFrm;
    			
    			frm.method = "POST"; 
    			frm.action = "<%=request.getContextPath()%>/shop/orderPayment.tea";
    			frm.submit();
            }
		} // end of if(checkCnt < 1) - else 
	} // end of function goChkOrder()
	
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
							<td class="cart_pname">
								<a href="<%=ctxPath%>/shop/productView.tea?pnum=${cartvo.pnum}" style="color:black;">${cartvo.prod.pname}</a>
							</td>
							<td>
								<input class="spinner oqty" style="width:50px" name="oqty" value="${cartvo.oqty}"  required/>
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
						<input type="hidden" class="pname" value="${cartvo.prod.pname}" />
						<input type="hidden" class="images" value="${cartvo.prod.pimage}" />
						<input type="hidden" id="hidden_pqty" class="pqty" value="${cartvo.prod.pqty}" />
						<input type="hidden" id="hidden_price" name="price" class="price" value="${cartvo.prod.price}"/>
						<input type="hidden" id="hidden_saleprice"  name="saleprice" value="${cartvo.prod.saleprice}"/>
						<input type="hidden" id="hidden_point" name="point" value="${cartvo.prod.point}" />
						<input type="hidden" class="totalPrice" value="${cartvo.prod.totalPrice}" />
						<input type="hidden" class="totalPoint" value="${cartvo.prod.totalPoint}" />
						<input type="hidden" id="pnumjoin" name="pnumjoin" value="" />
						<input type="hidden" id="pnamejoin" name="pnamejoin" value="" />
						<input type="hidden" id="oqtyjoin" name="oqtyjoin" value="" />
						<input type="hidden" id="cartnojoin" name="cartnojoin" value="" />
						<input type="hidden" id="imagejoin" name="imagejoin" value="" />
						<input type="hidden" id="totalPricejoin" name="totalPricejoin" value="" />
						<input type="hidden" id="sumtotalOriginalPrice" name="sumtotalOriginalPrice" value="" />
						<input type="hidden" id="sumtotalPrice" name="sumtotalPrice" value="" />
						<input type="hidden" id="sumtotalPoint" name="sumtotalPoint" value="" />
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
		        <td class="col col-3 text-right"><span id="ValTotalPrice">0원</span></td>
		      </tr>
		      <tr>
		        <td class="col col-9 text-left">적립예정찻잎</td>
		        <td class="col col-3 text-right"><span id="ValTotalPoint">0찻잎</span></td>
		      </tr>
		      <tr>
		        <td class="col col-9 text-left">할인금액</td>
		        <td class="col col-3 text-right text-danger"><span id="ValTotalDiscount">0원</span></td>
		      </tr>
		      <tr>
		        <td class="col col-9 text-left">배송비</td>
		        <td class="col col-3 text-right"><span id="DeliveryPrice">0원</span></td>
		      </tr>
		      <tr>
		        <td class="col col-9 text-left" style="color:#1E7F15; font-weight:bolder;"><h4>결제예정금액</h4></td>
		        <td class="col col-3 text-right" style="color:#1E7F15; font-weight:bolder">
		        	<h4><span id="TotalOrderPrice">0원</span></h4>
	        	</td>
		      </tr>
		    </tbody>
		  </table>
	</div>
	
	<div class="cartButtons mt-5">
		<span class="float-right mr-3"><input type="button" class="btn" id="orderBtn" value="선택상품 주문" onclick="goChkOrder()"/></span>
		<span class="float-right mr-3"><input type="button" class="btn bg-light text-dark" value="선택상품 삭제" onclick="goSelectDel();"/></span>
	</div>
</div>
</form>
<%@ include file="../footer.jsp"%>