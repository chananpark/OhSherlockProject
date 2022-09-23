<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>
<h5 style="font-weight: bold">구매정보</h5>

<div style="overflow-x: auto;">
	<table class="table mt-4 prodList text-center" id="order_list">
		<thead style="background-color: #f2f2f2;">
			<tr>
				<th class="col-3">주문일자</th>
				<th class="col-3">주문번호</th>
				<th class="col-3">주문금액</th>
				<th class="col-3">주문상세</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td>2022.09.20</td>
				<td>20220913-0023355</td>
				<td>35,000원</td>
				<td><input type="button" value="조회" id="orderDetailBtn"
					onclick="goOrderDetailPop();" /></td>
			</tr>
			<tr>
				<td>2022.09.20</td>
				<td>20220913-0023355</td>
				<td>35,000원</td>
				<td><input type="button" value="조회" id="orderDetailBtn" /></td>
			</tr>
			<tr>
				<td>2022.09.20</td>
				<td>20220913-0023355</td>
				<td>35,000원</td>
				<td><input type="button" value="조회" id="orderDetailBtn" /></td>
			</tr>
			<tr>
				<td>2022.09.20</td>
				<td>20220913-0023355</td>
				<td>35,000원</td>
				<td><input type="button" value="조회" id="orderDetailBtn" /></td>
			</tr>
			<tr>
				<td>2022.09.20</td>
				<td>20220913-0023355</td>
				<td>35,000원</td>
				<td><input type="button" value="조회" id="orderDetailBtn" /></td>
			</tr>
			<tr>
				<td>2022.09.20</td>
				<td>20220913-0023355</td>
				<td>35,000원</td>
				<td><input type="button" value="조회" id="orderDetailBtn" /></td>
			</tr>

		</tbody>
	</table>
</div>
<%@ include file="../footer.jsp"%>