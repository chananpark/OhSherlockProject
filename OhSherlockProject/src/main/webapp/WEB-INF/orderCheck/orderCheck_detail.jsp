<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>


<%@ include file="../header.jsp"%>   

<style type="text/css">
	
	.btn-secondary {
		width: 85px; 
		margin-top: 30px;
		border-style: none; 
		height: 33px;
	}
	
	.btn-secondary:hover {
		border: 2px solid #1E7F15;
		background-color: #1E7F15;
	    color: white;
	}
	
</style>    
    
<script type="text/javascript">

	let odrcode; 

	$(document).ready(function() {
		
		odrcode = "${ovo.odrcode}"; 
		
		
		
	});// end of $(document).ready()-----------------------


	
	function goMyOrderList() {
		location.href = "<%= request.getContextPath() %>${requestScope.goBackURL}";
	} // end of function goMyOrderList()
	
	
	// 환불신청 버튼을 클릭했을시 
	function goRefund() {
		
		location.href = "<%= request.getContextPath() %>/mypage/orderCheck_refund.tea?odrcode="+odrcode+"&goBackURL=${requestScope.goBackURL}";
		
	}// end of $("input.btnRefund").click()-------
	
	// 주문취소 버튼을 클릭했을시
	function goCancel() {
		
	  location.href = "<%= request.getContextPath() %>/mypage/orderCheck_cancel.tea?odrcode="+odrcode+"&goBackURL=${requestScope.goBackURL}";
		
	}// end of $("input.btnRefund").click()-------
	
</script>
    
<div class="container">
  <div class="col-md-12">
  
    <div class="col-md-15">
      <h2 style="font-weight: bold;">주문 상세조회</h2><br>
      <hr style="background-color: black; height: 1.2px;"><br>
      <h5 style="font-weight: bold;">주문번호 ${ovo.odrcode}</h5>
    </div>  
     
    <div>
		<table class="table" style="margin-top: 80px;">
			<colgroup>
	          <col width="250px"/>
	          <col width="400px"/>
	          <col/>
	          <col/>
	          <col/>
	      	</colgroup>
			<thead class="thead-light">
				<tr>
					<th style="text-align: center;">주문일자(주문번호)</th>
					<th style="text-align: center;">제품명</th>
					<th>수량</th>
					<th>&nbsp;&nbsp;&nbsp;가격</th>
					<th>처리상태</th>
				</tr>
			</thead>
			<tbody>
				<c:set var="prodTotalPrice" value="0"/>
				
				<c:forEach var="ovo" items="${requestScope.orderList}">
					<tr>
						<td class="align-middle" style="text-align: center;">${ovo.odrdate}<br>[${ovo.odrcode}]</td>
						<td><img src="<%=request.getContextPath() %>/images/${ovo.odvo.pvo.pimage}" width=100 height=100 />${ovo.odvo.pvo.pname}</td>
						<td class="align-middle">${ovo.odvo.oqty}</td>
						<td class="align-middle">${ovo.odvo.oprice}</td>
						<td class="align-middle"><input name="odrcode" type="hidden" value="${ovo.odrcode}" /></td>
						<c:set var="prodTotalPrice" value="${prodTotalPrice+ovo.odvo.oprice}"/>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>
	
	<div class="priceTotal">
      <table class="table table-active table-borderless">
          <tbody class="text-center" style="font-weight: bold;">
            <tr>
              <td><fmt:formatNumber value="${prodTotalPrice}" pattern="#,###"/>원&nbsp;+&nbsp;<fmt:formatNumber value="${ovo.delivery_cost}" pattern="#,###"/>원(배송비)&nbsp;=&nbsp;<fmt:formatNumber value="${prodTotalPrice+ovo.delivery_cost}" pattern="#,###"/>원</td>
            </tr>
          </tbody>
        </table>
    </div>
    
    <div class="text-center" id="detail" style="display: block;"> <!-- 주문상세 id -->
   <%-- <c:if test="${odrstatus eq 1}"> </c:if>--%>
  	<input type="button" class="btn-secondary btnCancel" onclick="goCancel();" value="주문취소" style="width: 80px;"/>
	  
	  <%-- <c:if test="${odrstatus ne 1}"></c:if> --%>
 	  <input type="button" class="btn-secondary btnRefund" onclick="goRefund();" value="환불신청" style="width: 80px;"/>
 	  
	  <input type="button" class="btn-secondary btnConfirm" value="구매확정" style="margin: 15px; width: 80px;"/>
    </div>
    
	
	<br>
    <hr>
    <br>    
    
    <h5>배송지 정보</h5>
    <table class="table table-bordered mt-4">
         <thead class="thead-light">
            <tr>
               <th>받는 분</th><td>${requestScope.ovo.recipient_name}</td>
            </tr>
            <tr>
               <th>연락처</th><td>${requestScope.ovo.recipient_mobile}</td>
            </tr>
            <tr>
               <th>주소</th><td>${ovo.recipient_address} ${ovo.recipient_detail_address} ${ovo.recipient_extra_address}</td>
            </tr>
            <tr>
               <th>배송메모</th><td>${requestScope.ovo.recipient_memo}</td>
            </tr>
         </thead>
	</table>
    
    <br>
    <hr>
    <br>
    
    
    <h5>결제정보</h5>
	   <div class="paymentTotal mt-4">
	      <table class="table table-active table-borderless">
	          <tbody>
	            <tr>
	              <td class="col col-9 text-left" style="padding-top: 20px; padding-bottom: 0.7px;">총 상품금액</td>
	              <td class="col col-3 text-right" style="padding-top: 20px; padding-bottom: 0.7px;">12,000원</td>
	            </tr>
	            <tr>
	              <td class="col col-9 text-left" style="padding-bottom: 0.7px;">총 할인금액</td>
	              <td class="col col-3 text-right" style="padding-bottom: 0.7px;">0원</td>
	            </tr>
	            <tr>
	              <td class="col col-9 text-left">배송비</td>
	              <td class="col col-3 text-right" style="padding-bottom: 20px;"><fmt:formatNumber value="${ovo.delivery_cost}" pattern="#,###"/>원</td>
	            </tr>
	            <tr style="border-top: 1px solid #d9d9d9;">
	              <td class="col col-9" style="color:#1E7F15; font-weight:bolder; padding-bottom: 0.7px;"><h4>총 결제금액</h4></td>
	              <td class="col col-3 text-right" style="color:#1E7F15; font-weight:bolder; padding-bottom: 0.7px;"><h4><fmt:formatNumber value="${ovo.odrtotalprice}" pattern="#,###"/>원</h4></td>
	            </tr>
	            <tr>
	              <td class="col col-9 text-left" style="padding-top: 0; padding-bottom: 0;">결제일자</td>
	               <td class="col col-9 text-right" style="padding-top: 0; padding-bottom: 20px; font-size: 8pt;">${requestScope.ovo.odrdate}</td>
	            </tr>
	          </tbody>
	        </table>
    	</div>
    	
    <div class="text-center" style="margin-top: 30px;">
	  <input type="button" onclick="goMyOrderList()" class="btn-secondary" value="목록보기" />
    </div>
    
    
  </div>
</div>

<%@ include file="../footer.jsp"%>