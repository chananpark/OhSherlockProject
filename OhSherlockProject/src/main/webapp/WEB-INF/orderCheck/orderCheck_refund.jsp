<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>


<%@ include file="../header.jsp"%>   

<!-- 직접 만든 CSS -->
<link rel="stylesheet" type="text/css" href="./css/style_yeeun.css" />    <!-- /MyMVC/src/main/webapp/css/style.css 파일 경로 -->
    
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
    
    
<div class="container">
  <div class="col-md-12">
  
    <div class="col-md-15">
      <h2 style="font-weight: bold;">반품 신청</h2><br>
      <hr style="background-color: black; height: 1.2px;"><br>
      <h5 style="font-weight: bold;">주문번호 2061457780</h5>
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
					<th><input type="checkbox" id="cartSelectAll" name="cartSelectAll" value="cartSelectAll" />
						<label for="cartSelectAll">&nbsp;전체선택</label></th>
					<th style="text-align: center;">주문일자(주문번호)</th>
					<th style="text-align: center;">제품명</th>
					<th>수량</th>  <%-- 수량은 내가 선택한 개수 내에서만 선택 가능. -> 예: 3개를 주문했다면 1~3개 중 몇개를 교환할지 선택가능함. --%>
					<th>&nbsp;&nbsp;&nbsp;가격</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td><input type="checkbox" id="cartSelectOne" name="cartSelectOne" value="cartSelectOne"/></td>
					<td class="align-middle" style="text-align: center;">2022.09.13<br>[20220913-0023355]</td>
					<td><img src="<%= ctxPath%>/images/그린티라떼더블샷.png" width=100 height=100>그린티 라떼 더블샷</td>
					<td><input style="width:100px" type="number" value="1" min="1" max="50" required/></td>
					<td class="align-middle">12,000원</td>
				</tr>
			</tbody>
		</table>
	</div>
	
	<br>
    <hr>
    <br>  
    
    <h5>반품사유 선택</h5>
    <table class="table table-bordered mt-4">
    	<colgroup>
	          <col width="180px"/>
	          <col />
      	</colgroup>
        <tbody class="thead-light">
          <tr>
             <th>사유</th>
             <td><span class="star">*&nbsp;</span>
               <select class="form-select form-select-sm" aria-label=".form-select-sm example">
				  <option selected>&nbsp;사유를 선택해주세요</option>
				  <option value="1">&nbsp;고객단순변심</option>
				  <option value="1">&nbsp;상품불만족</option>
				  <option value="1">&nbsp;상품불량</option>
				  <option value="2">&nbsp;상품파손</option>
				  <option value="3">&nbsp;오배송</option>
               </select>
	  		 </td>
          </tr>
        </tbody>
    </table>

    <br><br>
    
    <h5>회수지 정보</h5>  <%-- 실제 배송된 정보 db에서 가져오기 --%>
	<div id="deliveryAddr" class="collapse show">
		<table class="table table-bordered mt-2 orderInfo">
			<colgroup>
	          <col width="180px"/>
	          <col />
	      	</colgroup>
			<thead class="thead-light">
				<tr>
					<th>보내는 분</th>
					<td><span class="star">*&nbsp;&nbsp;</span><input id="deliveryMemo" type="text" name="deliveryMemo"
						size="40" placeholder="이순신" /></td>
				</tr>
				<tr>
					<th>연락처</th>
					<td><span class="star">*&nbsp;&nbsp;</span><input id="deliveryMemo" type="text" name="deliveryMemo"
						size="40" placeholder="010-1111-2222" /></td>
				</tr>
				<tr>
					<th style="vertical-align: middle">주소</th>
					<td class="border-0">
						<span class="star">*&nbsp;</span>
						<input class="addressInput mt-2"
						type="text" id="address" name="address" size="20"
						placeholder="01234" />
						<button type="button" id="addressBtn">우편번호찾기</button> <br> 
						<input class="addressInput mt-2" type="text" id="extraAddress"
						name="extraAddress" size="40" placeholder="서울 마포구 동교로 332 (동교동, 거북아파트)" style="margin-left: 19px;" /><br> 
						<input class="addressInput mt-2" type="text" id="detailAddress"
						name="detailAddress" size="40" placeholder="101동 1107호" style="margin-left: 19px;" /> 
					</td>
				</tr>
				<tr>
					<th>배송메모</th>
					<td><input id="deliveryMemo" type="text" name="deliveryMemo"
						size="40" placeholder="부재시 경비실에 맡겨주세요" style="margin-left: 19px;" /></td>
				</tr>
			</thead>
		</table>
	</div>    
    
    <br><br>

	<h5>환불정보</h5>
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
	              <td class="col col-9" style="color:#1E7F15; font-weight:bolder; padding-bottom: 15px;"><h4>총 환불예정금액</h4></td>
	              <td class="col col-3 text-right" style="color:#1E7F15; font-weight:bolder; padding-bottom: 15px;"><h4>9,500</h4></td>  
	            </tr>
	          </tbody>
	        </table>
    	</div>

	<br><br>
    
    <div class="exchangeNotice">
      <table class="table table-active table-borderless">
          <thead style="font-weight: bold;">
            <tr>
              <th>반품사항 안내</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td style="padding: 3px 12px 5px 12px;">·&nbsp;모든 환불은 예치금 적립으로 처리되오니 유의하여 주시기 바랍니다.</td>
            </tr>
            <tr>
              <td style="padding: 15px 15px 10px; 15px; font-size: 16px;">아래의 경우 반품이 처리되지 않을 수 있습니다.</td>
            </tr>
            <tr>
              <td style="padding: 3px 12px 5px 12px;">·&nbsp;고객단순변심, 상품불만족 등 고객 귀책 사유로 반품 신청시 반품 택배비가 입금 또는 동봉이 되지 않거나 확인이 어려운 경우</td>
            </tr>
            <tr>
              <td style="padding: 3px 12px 5px 12px;">·&nbsp;고객단순변심, 상품불만족 등 고객 귀책 사유로 반품 신청시 상품포장 개봉, 상품포장 개봉, 상품사용으로 상품의 가치가 훼손된 경우</td>
            </tr>
            <tr>
              <td style="padding: 3px 12px 12px 12px;">·&nbsp;고객단순변심, 상품불만족 등 고객 귀책 사유로 반품 신청시 시간경과에 따라 재판매가 어려운 상품의 경우</td>
            </tr>
          </tbody>
        </table>
    </div>	
    
    <span class="input_button checkbox">
	    <input type="checkbox" id="returnagree" name="returnagree" />
	    <label for="returnagree">&nbsp;반품사항 안내를 확인하였습니다.</label>
    </span>
    	
    	
    <div class="text-center" id="detail" style="display: block; margin-top: 40px;"> <!-- 주문상세 id -->
	  <input type="button" class="btn-light" value="이전" />
	  <input type="button" class="btn-secondary" value="반품신청" />
    </div>
    
    
  </div>
</div>

<%@ include file="../footer.jsp"%>
