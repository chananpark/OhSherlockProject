<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>


<div class="container" id="cartContainer">
	<div class="mb-4">
		<h2 style="font-weight: bold">장바구니</h2>
	</div>
	<div>
		<table class="table mt-4">
			<thead class="thead-light">
				<tr>
					<th><input type="checkbox" id="cartSelectAll" name="cartSelectAll" value="cartSelectAll" />
						<label for="cartSelectAll">&nbsp;전체선택</label></th>
					<th></th>
					<th>제품명</th>
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
					<td><input type="number" value="1" min="1" required/></td>
					<td>9,500원</td>
					<td><p><input type="button" value="바로구매"/></p>
					<p><input type="button" value="상품삭제"/></p></td>
				</tr>
				<tr>
					<td><input type="checkbox" id="cartSelectOne" name="cartSelectOne" value="cartSelectOne"/></td>
					<td><img src="https://www.osulloc.com/upload/kr/ko/adminImage/HB/XA/304_20211026141423508CU.png?quality=80" width="100"/></td>
					<td>러블리 티 박스</td>
					<td><input type="number" value="1" min="1" required/></td>
					<td>20,000원</td>
					<td><p><input type="button" value="바로구매"/></p>
					<p><input type="button" value="상품삭제"/></p></td>
				</tr>
				<tr>
					<td><input type="checkbox" id="cartSelectOne" name="cartSelectOne" value="cartSelectOne"/></td>
					<td><img src="https://www.osulloc.com/upload/kr/ko/adminImage/KR/TP/304_20191213162107079MN.png?quality=80" width="100"/></td>
					<td>웨딩 그린티 20입</td>
					<td><input type="number" value="1" min="1" required/></td>
					<td>18,400원</td>
					<td><p><input type="button" value="바로구매"/></p>
					<p><input type="button" value="상품삭제"/></p></td>
				</tr>
			</tbody>
		</table>
	</div>
</div>
<%@ include file="../footer.jsp"%>