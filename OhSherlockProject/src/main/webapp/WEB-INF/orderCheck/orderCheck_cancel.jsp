<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ include file="../header.jsp"%>   
    
<style type="text/css">
	
	#exchangeContainer th, #exchangeContainer td {
		text-align: center;
		vertical-align: middle;
	}
	
	span.star {
		color: red;
		font-weight: bold;
		font-size: 13pt;
	}
	
	.form-select {
		width: 200px;
		text-align: left;
	}
	
	.exchangeNotice td {
		font-size: 14px;
	}
	
	.btn-light {
		width: 85px; 
		color: #1a1a1a; 
		border-style: none; 
		height: 33px;
	}
	
	.btn-secondary {
		width: 85px; 
		margin: 15px; 
		border-style: none; 
		height: 33px;
	}
	
	.btn-secondary:hover {
		border: 2px none #1E7F15;
		background-color: #1E7F15;
	    color: white;
	}
	
</style>    
 <script type="text/javascript">

	

 $(document).ready(function() {

		// 제품번호의 모든 체크박스가 체크가 되었다가 그 중 하나만 이라도 체크를 해제하면 전체선택 체크박스에도 체크를 해제하도록 한다.
		$(".chkboxodnum").click(function(){
			   
		   var bFlag = false;
		   $(".chkboxodnum").each(function(){
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
	
	
 });// end of $(document).ready()-----------------------
	
	// 장바구니 전체 선택하기
	function allCheckBox() {
	
		var bool = $("#cartSelectAll").is(":checked");
		
		$(".chkboxodnum").prop("checked", bool);
	}// end of function allCheckBox()-------------------------
	
	
	function clickCheckBox(frm) {

  	var totalSalePriceSum = 0;
  		
		var count = frm.odnum.length;
		if(count == undefined) count = 1;
		
		if( count == 1) {
			if( frm.odnum.checked == true ){
				totalSalePriceSum = parseInt( (frm.oprice.value)*(frm.oqty.value) );
			}	
		} else if (count > 1) {
		
		  	for(var i=0; i < count; i++ ){
		  		if( frm.odnum[i].checked == true ){
	  				totalSalePriceSum += parseInt( (frm.oprice[i].value)*(frm.oqty[i].value) );
	      		}
			}
	  	
		}
		
		$("#sumPrice").html(totalSalePriceSum.toLocaleString('en')+"원");
		
		totalSalePriceSum = Number(totalSalePriceSum) + Number($("#delivery_cost").val());
		
		$("h4#refundMoney").html(totalSalePriceSum.toLocaleString('en')+"원");
		
 	} // end of function clickCheckBox(this)

	// 이전 버튼을 클릭하면 
	function goback() {
		
		location.href = "<%= request.getContextPath() %>${requestScope.goBackURL}";
	}
	  
	function goCancel() {
		
		
						///// == 체크박스의 체크된 갯수(checked 속성이용) == /////
			    	const checkCnt = $("input:checkbox[name='odnum']:checked").length;
			    
				   	if(checkCnt < 1) {
				       	alert("취소하실 제품을 선택하세요.");
				       	return; // 종료 
				    } 			
				   	
				   	const hidden_select = $("#select").val();
					
					if(hidden_select == "") {
						alert("취소사유를 선택해주세요.");
						return;
					}
					
					$("#hidden_select").val(hidden_select);
					
	         const allCnt = $("input:checkbox[name='odnum']").length; // 모든 체크박스의 개수
	         
	         const odnumArr = new Array(); // 제품번호 // DB에 넣기 위해서 받아오는데, 상품이 여러개 일 수 있으니 배열로 받아온다
	    
	         for(var i=0; i<allCnt; i++) {
	             if( $("input:checkbox[name='odnum']").eq(i).is(":checked") ) { // .eq(i) 첫번째 체크박스가 체크되어져 있다면 꺼내온다.
	            	 odnumArr.push( $("input:checkbox[name='odnum']").eq(i).val() ); // 체크박스의 value 값 ${cartvo.pnum} 
	            	}
	         }// end of for---------------------------
	         
	         const odnumjoin = odnumArr.join();
	         
	         $("input#odnumjoin").val(odnumjoin);
	         // alert(odnumArr);
	         var bool = confirm("선택하신 상품을 주문취소 하시겠습니까?");
	          
	         if(bool) {
	        	// 최종적으로 폼을 보내어 준다.
		   		  const frm = document.cancelFrm;
		   		  frm.action = '<%=ctxPath%>/mypage/orderCheck_cancel.tea';
		   		  frm.method = 'POST';
		   		  frm.submit();
	         }
	   	
	}// end of function goRefund() 	
 	
 	
</script> 
<form name="cancelFrm">
<div class="container">
  <div class="col-md-12">
  
    <div class="col-md-15">
      <h2 style="font-weight: bold;">주문 취소</h2><br>
      <hr style="background-color: black; height: 1.2px;"><br>
      <h5 style="font-weight: bold;">주문번호 ${ovo.odrcode}</h5>
    </div>  
     
    <div id="exchangeContainer">
		<table class="table" style="margin-top: 80px;">
			<colgroup>
	          <col/>
	          <col width="175px"/>
	          <col width="380px"/>
	          <col/>
	          <col/>
	      	</colgroup>
			<thead class="thead-light">
				<tr>
					<th><input type="checkbox" id="cartSelectAll" name="cartSelectAll" value="cartSelectAll" onClick="allCheckBox('${ovo.odvo.odnum}'); clickCheckBox(this.form);" />
						<label for="cartSelectAll">&nbsp;전체선택</label></th>
					<th style="text-align: center;">주문일자(주문번호)</th>
					<th style="text-align: center;">제품명</th>
					<th>수량</th>  <%-- 수량은 내가 선택한 개수 내에서만 선택 가능. -> 예: 3개를 주문했다면 1~3개 중 몇개를 교환할지 선택가능함. --%>
					<th>&nbsp;&nbsp;&nbsp;가격</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="ovo" items="${requestScope.orderList}" varStatus="status">
					<tr>
						<td><input type="checkbox" class="chkboxodnum" id="odnum${status.index}" name="odnum" value="${ovo.odvo.odnum}" onclick="clickCheckBox(this.form)"></td>
						<td class="align-middle" style="text-align: center;">${ovo.odrdate}<br>[${ovo.odrcode}]</td>
						<td><img src="<%=request.getContextPath() %>/images/${ovo.odvo.pvo.pimage}" width=100 height=100>${ovo.odvo.pvo.pname}</td>
						<td>${ovo.odvo.oqty}</td>
						<td class="align-middle"><fmt:formatNumber value="${ovo.odvo.oprice}" pattern="#,###"/>원</td>
					</tr>
					<input type="hidden" name="oprice" value="${ovo.odvo.oprice}"/>
					<input type="hidden" name="oqty" value="${ovo.odvo.oqty}"/>
					<input type="hidden" id="odnumjoin" name="odnumjoin" value="" />
				</c:forEach>
			</tbody>
		</table>
	</div>
	<br>
    <hr>
	
	
	<br>
    <br>  
    
    <h5>취소사유 선택</h5>
    <table class="table table-bordered mt-4">
    	<colgroup>
	          <col width="180px"/>
	          <col />
      	</colgroup>
        <tbody class="thead-light">
          <tr>
             <th>사유</th>
             <td><span class="star">*&nbsp;</span>
               <select class="form-select form-select-sm" aria-label=".form-select-sm example" name="select" id="select">
								  <option value="" selected>&nbsp;사유를 선택해주세요</option>
								  <option value="고객단순변심">&nbsp;고객단순변심</option>
								  <option value="주문착오">&nbsp;주문착오</option>
								  <option value="배송지연">&nbsp;배송지연</option>
               </select>
               <input type="hidden" name="hidden_select" id="hidden_select" value="" />
	  		 		</td>
          </tr>
        </tbody>
    </table>

    <br><br>

	<h5>환불정보</h5>
    <div class="paymentTotal mt-4">
      <table class="table table-active table-borderless">
          <tbody>
            <tr>
              <td class="col col-9 text-left" style="padding-top: 20px; padding-bottom: 0.7px;">총 상품금액</td>
              <td class="col col-3 text-right" style="padding-top: 20px; padding-bottom: 0.7px;"><span id="sumPrice">0원</span></td>
            </tr>
            <tr>
              <td class="col col-9 text-left">배송비</td>
              <td class="col col-3 text-right" style="padding-bottom: 20px;">
              	<fmt:formatNumber value="${ovo.delivery_cost}" pattern="#,###"/>원
            		<input type="hidden" name="delivery_cost" id="delivery_cost" value="${ovo.delivery_cost}" />
             	</td>
            </tr>
            <tr style="border-top: 1px solid #d9d9d9;">
              <td class="col col-9" style="color:#1E7F15; font-weight:bolder; padding-bottom: 15px;"><h4>총 환불예정금액</h4></td>
              <td class="col col-3 text-right" style="color:#1E7F15; font-weight:bolder; padding-bottom: 15px;"><h4 id="refundMoney">0원</h4></td>  
            </tr>
          </tbody>
        </table>
   	</div>
    
	<br><br>
    	
    <div class="exchangeNotice">
      <table class="table table-active table-borderless">
          <thead style="font-weight: bold;">
            <tr>
              <th>주문취소 안내</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td style="padding: 3px 12px 5px 12px;">·&nbsp;입금 후 취소시 모든 환불은 예치금 적립으로 처리되오니 유의하여 주시기 바랍니다.</td>   <%-- API 배운 후 코멘트 수정 필요 --%>
            </tr>
            <tr>
              <td style="padding: 3px 12px 5px 12px;">·&nbsp;취소대기중 상태의 경우 이미 배송을 했거나 포장을 완료한 경우에 따라 취소가 불가능할 수 있습니다.</td>
            </tr>
            <tr>
              <td style="padding: 3px 12px 12px 12px;">·&nbsp;부분취소가 불가합니다. 취소 후 재주문 부탁드립니다.</td>
            </tr>
          </tbody>
        </table>
    </div>		
    	
    <div class="text-center" id="detail" style="display: block; margin-top: 40px;"> <!-- 주문상세 id -->
	  <input type="button" class="btn-light" value="이전" onclick="goback()"  />
	  <input type="button" class="btn-secondary" value="취소신청" onclick="goCancel()"/>
    </div>
    
  </div>
</div>
 </form>   

<%@ include file="../footer.jsp"%>
