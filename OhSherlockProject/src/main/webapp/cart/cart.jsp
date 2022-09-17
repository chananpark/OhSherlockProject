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

<div class="container" id="cartContainer">
	<div class="mb-4">
		<h2 style="font-weight: bold">장바구니</h2>
	</div>
	<div class="cartList">
		<table class="table mt-4">
			<thead class="thead-light">
				<tr>
					<th><input type="checkbox" id="cartSelectAll" name="cartSelectAll" value="cartSelectAll" />
						<label for="cartSelectAll">&nbsp;전체선택</label></th>
					<th colspan="2">제품정보</th>
					<th>수량</th>
					<th>가격</th>
					<th>처리</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td><input type="checkbox" id="cartSelectOne" name="cartSelectOne" value="cartSelectOne"/></td>
					<td><img src="https://www.osulloc.com/upload/kr/ko/adminImage/GL/SU/304_20211015203853590OP.png?quality=80" width="100"/></td>
					<td>스윗 베리 루이보스티</td>
					<td><input style="width:100px" type="number" value="1" min="1" required/></td>
					<td>9,500원</td>
					<td><p><input class="paymentBtn" type="button" value="바로구매"/></p>
					<p><input type="button" value="상품삭제"/></p></td>
				</tr>
				<tr>
					<td><input type="checkbox" id="cartSelectOne" name="cartSelectOne" value="cartSelectOne"/></td>
					<td ><img src="https://www.osulloc.com/upload/kr/ko/adminImage/HB/XA/304_20211026141423508CU.png?quality=80" width="100"/></td>
					<td>러블리 티 박스</td>
					<td><input style="width:100px" type="number" value="1" min="1" required/></td>
					<td>20,000원</td>
					<td><p><input class="paymentBtn" type="button" value="바로구매"/></p>
					<p><input type="button" value="상품삭제"/></p></td>
				</tr>
				<tr>
					<td><input type="checkbox" id="cartSelectOne" name="cartSelectOne" value="cartSelectOne"/></td>
					<td><img src="https://www.osulloc.com/upload/kr/ko/adminImage/KR/TP/304_20191213162107079MN.png?quality=80" width="100"/></td>
					<td>웨딩 그린티 20입</td>
					<td><input style="width:100px" type="number" value="1" min="1" required/></td>
					<td>18,400원</td>
					<td><p><input class="paymentBtn" type="button" value="바로구매"/></p>
					<p><input type="button" value="상품삭제"/></p></td>
				</tr>
			</tbody>
		</table>
	</div>
	
	<div class="cartTotal" >
		<table class="table table-active table-borderless">
		    <tbody class="text-right">
		      <tr>
		        <td class="col col-9 text-left">상품금액</td>
		        <td class="col col-3 text-right">18,000</td>
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