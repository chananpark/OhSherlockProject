<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>


<%@ include file="../header.jsp"%>   

<!-- 직접 만든 CSS -->
<link rel="stylesheet" type="text/css" href="./css/style_yeeun.css" />    <!-- /MyMVC/src/main/webapp/css/style.css 파일 경로 -->
    
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
    
    
<div class="container">
  <div class="col-md-12">
  
    <div class="col-md-15">
      <h2 style="font-weight: bold;">주문 상세조회</h2><br>
      <hr style="background-color: black; height: 1.2px;"><br>
      <h5 style="font-weight: bold;">주문번호 2061457780</h5>
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
				<tr>
					<td class="align-middle" style="text-align: center;">2022.09.13<br>[20220913-0023355]</td>
					<td><img src="<%= ctxPath%>/images/그린티라떼더블샷.png" width=100 height=100>그린티 라떼 더블샷</td>
					<td class="align-middle">&nbsp;1</td>
					<td class="align-middle">12,000원</td>
					<td class="align-middle">결제완료</td>
				</tr>
			</tbody>
		</table>
	</div>
	
	<div class="priceTotal">
      <table class="table table-active table-borderless">
          <tbody class="text-center" style="font-weight: bold;">
            <tr>
              <td>12,000원&nbsp;+&nbsp;2,500원(배송비)&nbsp;=&nbsp;14,500원</td>
            </tr>
          </tbody>
        </table>
    </div>
	
    <div class="text-center" id="detail" style="display: block;"> <!-- 주문상세 id -->
	  <input type="button" class="btn-secondary" value="주문취소" style="width: 80px;"/>
	  <input type="button" class="btn-secondary" value="구매확정" style="margin: 15px; width: 80px;"/>
    </div>
    
    <div class="text-center" id="completion" style="display: none;"> <!-- 구매확정 id -->
	  <input type="button" class="btn-secondary" value="교환신청" style="width: 80px;"/>
	  <input type="button" class="btn-secondary" value="반품신청" style="margin: 15px; width: 80px;"/>
    </div>
	
	<br>
    <hr>
    <br>    
    
    <h5>배송지 정보</h5>
    <table class="table table-bordered mt-4">
         <thead class="thead-light">
            <tr>
               <th>받는 분</th><td>이순신</td>
            </tr>
            <tr>
               <th>연락처</th><td>010-1111-2222</td>
            </tr>
            <tr>
               <th>주소</th><td>01234 서울 마포구 동교로 332 (동교동, 거북아파트) 101동 1107호</td>
            </tr>
            <tr>
               <th>배송메모</th><td>부재시 경비실에 맡겨주세요</td>
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
	              <td class="col col-9 text-left" style="padding-bottom: 0.7px;">└&nbsp;적립금 및 예치금 결제</td>
	              <td class="col col-3 text-right" style="padding-bottom: 0.7px;">0원</td>
	            </tr>
	            <tr>
	              <td class="col col-9 text-left">배송비</td>
	              <td class="col col-3 text-right" style="padding-bottom: 20px;">2,500원</td>
	            </tr>
	            <tr style="border-top: 1px solid #d9d9d9;">
	              <td class="col col-9" style="color:#1E7F15; font-weight:bolder; padding-bottom: 0.7px;"><h4>총 결제금액</h4></td>
	              <td class="col col-3 text-right" style="color:#1E7F15; font-weight:bolder; padding-bottom: 0.7px;"><h4>14,500</h4></td>
	            </tr>
	            <tr>
	              <td class="col col-9 text-left" style="padding-top: 0; padding-bottom: 0;">결제수단</td>
	              <td class="col col-3 text-right" style="padding-top: 0; padding-bottom: 0;">신용카드</td>
	            </tr>
	            <tr>
	              <td class="col col-9 text-left" style="padding-top: 0; padding-bottom: 20px;"></td>
	              <td class="col col-9 text-right" style="padding-top: 0; padding-bottom: 20px; font-size: 8pt;">2022.09.14 15:40</td>
	            </tr>
	          </tbody>
	        </table>
    	</div>
    	
    <div class="text-center" style="margin-top: 30px;">
	  <input type="button" class="btn-secondary" value="목록보기" />
    </div>
    
    
  </div>
</div>

<%@ include file="../footer.jsp"%>