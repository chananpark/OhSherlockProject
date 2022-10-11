<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>     

<style type="text/css">
		
	#order_member_info td:nth-child(odd) {
	  background-color: #f2f2f2;
	  font-weight: bold;
	}
	
	.btn {
		background-color: #1E7F15;
		color: white;
	}
	
</style>

<script>

$(()=>{
	
	if (${not empty ovo.odrtotalprice} && ${not empty ovo.delivery_cost}) {
		sum = Number(${ovo.odrtotalprice}) + Number(${ovo.delivery_cost});
		sum = sum.toLocaleString('en');
		$("#sum").text(sum);
	}

	goBackURL = "${requestScope.goBackURL}";
	goBackURL = goBackURL.replace(/ /gi,"&");
});
</script>

<div class="container">
	
	<h2 class="text-left" style="font-weight:bold; margin: 10px 0 0 10px;">주문 상세 내역</h2><br>
	<hr class="mb-5" style="background-color: black; height: 1.2px;">
    
    <h5 class="text-left" style="font-weight:bold; width:90%; margin: 0 auto;">주문 정보</h5>
	<c:if test="${not empty ovo }">
	<table class="table mt-4 mb-5 prodList text-left" id="order_member_info" style="width:90%; margin: 0 auto;">
		<tbody>
			<tr>
				<td class="col-4">주문번호</td>
				<td class="col-8">${ovo.odrcode }</td>
			</tr>
			<tr>
				<td class="col-4">주문일자</td>
				<td class="col-8">${ovo.odrdate }</td>
			</tr>
			<tr>
				<td class="col-4">주문자 아이디</td>
				<td class="col-8">${ovo.fk_userid }</td>
			</tr>
			<tr>
				<td class="col-4">주문자 성명</td>
				<td class="col-8">${ovo.mvo.name }</td>
			</tr>
			<tr>
				<td class="col-4">주문자 연락처</td>
				<td class="col-8">${ovo.mvo.mobile }</td>
			</tr>
			<tr> 
				<td class="col-4">주문자 이메일</td>
				<td class="col-8">${ovo.mvo.email }</td>
			</tr>
			<tr><td style="background-color: transparent; border-style: none;"></td></tr>
			<tr>
				<td class="col-4">수령자 성명</td>
				<td class="col-8">${ovo.recipient_name }</td>
			</tr>
			<tr>
				<td class="col-4">수령자 연락처</td>
				<td class="col-8">${ovo.recipient_mobile }</td>
			</tr>
			<tr>
				<td class="col-4">수령자 우편번호</td>
				<td class="col-8">${ovo.recipient_postcode }</td>
			</tr>
			<tr>
				<td class="col-4">수령자 주소</td>
				<td class="col-8">${ovo.recipient_address } ${ovo.recipient_detail_address } ${ovo.recipient_extra_address }</td>
			</tr>
			<tr><td style="background-color: transparent; border-style: none;"></td></tr>
			<tr>
				<td class="col-4">주문금액</td>
				<td class="col-8"><fmt:formatNumber value="${ovo.odrtotalprice}" pattern="#,###"/>원</td>
			</tr>
			<tr>
				<td class="col-4">적립금</td>
				<td class="col-8">찻잎 <fmt:formatNumber value="${ovo.odrtotalpoint}" pattern="#,###"/>개</td>
			</tr>
			<tr>
				<td class="col-4">배송비</td>
				<td class="col-8"><fmt:formatNumber value="${ovo.delivery_cost}" pattern="#,###"/>원</td>
			</tr>
			<tr>
				<td class="col-4">주문 처리 상태</td>
				<td class="col-8">
				<c:choose>
					<c:when test="${ovo.odrstatus == '1' }">
						결제완료(배송대기)
					</c:when>
					<c:when test="${ovo.odrstatus == '2' }">
						배송중
					</c:when>
					<c:when test="${ovo.odrstatus == '3' }">
						배송완료
						<tr>
						<td>배송일자</td>
						<td>${ovo.delivery_date}</td>
						</tr>
					</c:when>
					<c:when test="${ovo.odrstatus == '4' }">
						주문취소
					</c:when>
					<c:when test="${ovo.odrstatus == '5' }">
						환불
					</c:when>
				</c:choose>
				</td>
			</tr>

		</tbody>
	</table>

	<h5 class="text-left" style="font-weight:bold; width:90%; margin: 0 auto;">주문 상품</h5>
	<table class="table mt-4 mb-5 prodList text-left" id="order_prod_info" style="width:90%; margin: 0 auto;">
		<thead style="background-color:#f2f2f2;">
			<tr class="row m-auto text-center">
				<th class="col col-2">상품코드</th>
				<th class="col col-2">상품명</th>
				<th class="col col-2">수량</th>
				<th class="col col-2">가격</th>
				<th class="col col-2">적립금</th>
				<th class="col col-2">처리상태</th>
			</tr>
		</thead>
		<tbody>
		<c:if test="${not empty orderPrdList}">
		<c:forEach items="${orderPrdList }" var="odvo">
			<tr class="row m-auto text-center">
				<td class="col col-2">${odvo.fk_pnum}</td>
				<td class="col col-2">${odvo.pvo.pname}</td>
				<td class="col col-2"><fmt:formatNumber value="${odvo.oqty}" pattern="#,###"/>개</td>
				<td class="col col-2"><fmt:formatNumber value="${odvo.oprice}" pattern="#,###"/>원</td>
				<td class="col col-2">찻잎 <fmt:formatNumber value="${odvo.opoint}" pattern="#,###"/>개</td>
				<td class="col col-2">
				<c:choose>
					<c:when test="${odvo.refund == 1}">
						<span class="text-danger">
						환불완료
						</span>
					</c:when>
					<c:when test="${odvo.refund == -1}">
						<span class="text-danger">
						환불요청
						</span>
					</c:when>
					<c:when test="${odvo.cancel == 1}">
						<span class="text-muted">
						주문취소
						</span>
					</c:when>
					<c:otherwise>
						<span class="text-success">
						정상처리
						</span>
					</c:otherwise>
				</c:choose>
				</td>
			</tr>
		</c:forEach>
		</c:if>
		</tbody>
		<tfoot>
			<tr>
				<td colspan="6" style="text-align:right;" class="bg-light">
				<span><fmt:formatNumber value="${ovo.odrtotalprice}" pattern="#,###"/> 원</span>
				(상품결제금액)
				+
				<span><fmt:formatNumber value="${ovo.delivery_cost}" pattern="#,###"/> 원</span>
				(배송비)
				= 총
				<span id="sum" style="color: #1E7F15; font-weight:bold"></span>
				원</td>
			</tr>
			<c:if test="${refundSum > 0 }">
				<tr>
				<td colspan="6" style="text-align:right;" class="bg-light">
				환불금액 = 
				<span class="text-danger font-weight-bold"><fmt:formatNumber value="${refundSum}" pattern="#,###"/></span>
				원
				</td>
				</tr>
			</c:if>
			
		</tfoot>
	</table>
	</c:if>
	<c:if test="${empty ovo }">해당 주문 내역이 없습니다.</c:if>
	<div class="text-right" style="width:90%; margin: 0 auto;">	
		<button type="button" class="btn rounded" onclick="location.href='<%= ctxPath %>'+goBackURL">목록보기</button>
	</div>
</div>
<%@ include file="../footer.jsp"%>
    
