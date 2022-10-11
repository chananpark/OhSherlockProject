<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>    
        
<style>

	* {box-sizing: border-box;}
		
	.clickedBtn {
		background-color: rgb(226, 230, 234) !important;
	}
	
	.page-link {
	  color: #666666; 
	  background-color: #fff;
	  border: 1px solid #ccc; 
	}
	
	.page-item.active .page-link {
	 z-index: 1;
	 color: white;
	 border-color: #1E7F15;
	 background-color: #1E7F15; 
	 
	}
	
	.page-link:focus, .page-link:hover {
	  color: #1E7F15;
	  background-color: #fafafa; 
	  border-color: #1E7F15;
	}
	
	.btn-secondary {
		width: 80px; 
		margin: 15px; 
		border-style: none; 
		height: 30px;
		font-size: 14px;
	}
	
	.btn-secondary:hover {
		border: none;
		background-color: #1E7F15;
	    color: white;
	}
	
	/* 기간 탭 기본 css 시작 */
	#btnClass .tablink {
		background-color: white;
		color: black;
		float: left;
		border: none;
		outline: none;
		padding: 14px 0px;
		font-size: 17px;
		width: 11%;
	}
	
	#btnClass .tablink:hover {
		background-color: #e9ecef;
		
	}
	
	a, a:hover, a:link, a:visited {
		color: black;
		text-decoration: none;
	}

	
</style>       
    
<script>

$(document).ready(()=>{
	const answered = '${inquiry_answered}';
	
	$(".answerBtn[value="+answered+"]").addClass('clickedBtn');
	
	let answered_yn;
	if(answered == 0)
		answered_yn = '미답변';
	else
		answered_yn = '답변완료';
	
	$(".answered_yn").text(answered_yn);
	
	$(".answerBtn").click((e)=>{
		const answerFrm = document.answerFrm;
		answerFrm.inquiry_answered.value=$(e.target).val();
		answerFrm.action = "inquiry.tea";
		answerFrm.method = "GET";
		answerFrm.submit();
	});
	
});

	
</script>
	<div class="container" id="inquiry">

	<div class="titleZone row">
		<h2 class="col text-left" style="font-weight: bold">1:1 문의</h2>
		<br>
		<div class="col text-right">
			<span style="font-weight: bold; font-size: 20px;">02-336-8546</span><br>
			<span style="font-weight: normal; font-size: 15.5px;">평일 09:30
				~ 18:00 (점심시간 12:30 ~ 13:30)<br>주말 및 공휴일 휴무
			</span>
		</div>
	</div>
	
	<hr style="background-color: black; height: 1.2px; margin-bottom: 55px;">
	
	
	<%-- 탭 버튼 --%>
	 <div class="row bg-light" style="height: 67px; width: 27%; margin: auto; justify-content: center;">
		  <button value="0" type="button" class="answerBtn btn btn-light col col-6">미답변</button>
		  <button value="1" type="button" class="answerBtn btn btn-light col col-6">답변완료</button>
	</div>
	
	<form name="answerFrm">
		<input type="hidden" name="inquiry_answered" value=""/>
	</form>
	
	<br>
	<div style="margin-top: 10px;">총 <span id="inquiryCount">${totalInquiries }</span>건의 <span class="answered_yn"></span> 문의 내역이 있습니다.</div>
<table class="table mt-2 text-center">
			<thead class="thead-light">
				<tr class="row">
					<th class="col col-2">문의유형</th>
					<th class="col col-6">제목</th>
					<th class="col col-2">글쓴이</th>
					<th class="col col-2">등록일</th>
				</tr>
			</thead>
			<tbody>
			<c:if test="${not empty inquiryList}">
				<c:forEach items="${inquiryList}" var="ivo">
					<tr class="row">
						<td class="col col-2">
						<c:choose>
							<c:when test="${ivo.inquiry_type == 'product'}">상품문의</c:when>
							<c:when test="${ivo.inquiry_type == 'delivery'}">배송문의</c:when>
							<c:when test="${ivo.inquiry_type == 'coin_point'}">예치금/적립금</c:when>
							<c:when test="${ivo.inquiry_type == 'cancle'}">취소/환불/교환</c:when>
							<c:when test="${ivo.inquiry_type == 'member'}">회원</c:when>
							<c:otherwise>기타</c:otherwise>
						</c:choose>
						</td>
						<td class="col col-6">
							<a href="<%=ctxPath%>/cs/inquiryReply.tea?inquiry_no=${ivo.inquiry_no}">${ivo.inquiry_subject}</a>
							</td>
						<td class="col col-2">${ivo.fk_userid}</td>
						<td class="col col-2">${ivo.inquiry_date}</td>
					</tr>
				</c:forEach>
			</c:if>
			<c:if test="${empty inquiryList}">
				<tr>
					<td class="pt-5" colspan="4">
						<span class="answered_yn"></span> 문의 내역이 없습니다.
					</td>
				</tr>
				
			</c:if>
			</tbody>
		</table>
			

	<nav aria-label="Page navigation example" style="margin-top: 60px;">
		<ul class="pagination justify-content-center">${pageBar}</ul>
	</nav>
	
</div>

<%@ include file="../footer.jsp"%>