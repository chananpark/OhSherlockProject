<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

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
	
	#check_all{
	
		font-weight: bold;
		
	}
	
</style>

<div class="container" id="cartContainer">
<i class="fas fa-coins" style="font-size: 40px; float: left; padding-right: 10px;"></i>  
	<h2 style="font-weight: bold">찜목록</h2><br>
      <hr style="background-color: black; height: 1.2px;"> 
	
	<div>
		<span id="check_all">전체 <span style="color:#1E7F15; ">3</span>개</span> ｜ 좋아요 상품은 최대 <span style="color:#1E7F15; font-weight: bold;">90일간</span> 보관됩니다.
	</div>
	
	<br>
	
	<div class="cartList">
		<table class="table mt-4">
			<thead class="thead-light">
				<tr>
					<th><input type="checkbox" id="cartSelectAll" name="cartSelectAll" value="cartSelectAll" />
						<label for="cartSelectAll">&nbsp;전체선택</label></th>
					<th colspan="2">제품정보</th>
					<th>가격</th>
					<th>처리</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td><input type="checkbox" id="cartSelectOne" name="cartSelectOne" value="cartSelectOne"/></td>
					<td><img src="https://www.osulloc.com/upload/kr/ko/adminImage/GL/SU/304_20211015203853590OP.png?quality=80" width="100"/></td>
					<td>스윗 베리 루이보스티</td>
					<td>9,500원</td>
					<td><p><input class="paymentBtn" type="button" value="장바구니"/></p>
					<p><input type="button" value="상품삭제"/></p></td>
				</tr>
				<tr>
					<td><input type="checkbox" id="cartSelectOne" name="cartSelectOne" value="cartSelectOne"/></td>
					<td ><img src="https://www.osulloc.com/upload/kr/ko/adminImage/HB/XA/304_20211026141423508CU.png?quality=80" width="100"/></td>
					<td>러블리 티 박스</td>
					<td>20,000원</td>
					<td><p><input class="paymentBtn" type="button" value="장바구니"/></p>
					<p><input type="button" value="상품삭제"/></p></td>
				</tr>
				<tr>
					<td><input type="checkbox" id="cartSelectOne" name="cartSelectOne" value="cartSelectOne"/></td>
					<td><img src="https://www.osulloc.com/upload/kr/ko/adminImage/KR/TP/304_20191213162107079MN.png?quality=80" width="100"/></td>
					<td>웨딩 그린티 20입</td>
					<td>18,400원</td>
					<td><p><input class="paymentBtn" type="button" value="장바구니"/></p>
					<p><input type="button" value="상품삭제"/></p></td>
				</tr>
			</tbody>
		</table>
	</div>
	
	
	<div class="cartButtons mt-5">
		<span class="float-right"><input class="paymentBtn" type="button" value="선택삭제"/></span>
	</div>
</div>
