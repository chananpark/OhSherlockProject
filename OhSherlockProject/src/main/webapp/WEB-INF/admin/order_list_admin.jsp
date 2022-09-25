<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	
<%@ include file="../header.jsp"%>  

<style>
	button {
		border-style: none;
	}
	
	input[type=button] {
		border-style: none;
	}
	
</style>

<script type="text/javascript">

	$(document).ready(function(){
		
		
	}); // end of $(document).ready
	
	// 주문 상세 조회 팝업창
	// 이거 만드는 사람이 파라미터로 클릭한 주문번호 받아와야 해요~~~
	function goOrderDetailPop() {
		
		// 주문 상세 조회 선택 팝업창 띄우기
		const url = "<%= request.getContextPath() %>/order_list_admin_detail.jsp"; 
		// 마지막의 userid 는 변수
		
		window.open(url, "order_detail", 
					"left=350px, top=100px, width=1000px, height=700px");
		
	} // end of function goOrderDetailPop()
		
</script>

<div class="container" id="order_list">

	<h2 class="col text-left" style="font-weight:bold">주문정보</h2><br>
	<hr style="background-color: black; height: 1.2px;"><br>
	
	<%-- 폼태그 어디서 부터 잡아와야 할지 모르겠어서 일단 검색바까지만 잡았지만 수업 듣고 폼태그 위치 적절하게 옮겨주세요 --%>
	<form name="orderFrm">
	
	  	<div class="text-right">
	  		
			
			<select id="sizePerPage" name="sizePerPage"> <%-- 값이 변하면 여기의 name에 담아준다. 여기다 담은 name을 goSearch에서 action 으로 보내준다. --%>
				<option value="10">페이지당 주문건수</option>
				<option value="10">10</option>
				<option value="30">30</option>
				<option value="50">50</option>
			</select>
	  		<select id="searchType" name="searchType">
				<option value="userid">주문자명</option>
				<option value="name">주문번호</option> 
		    </select>
		  	<input type="text" name="searchWord" placeholder="검색어를 입력하세요"/>&nbsp;
		  	<input type="text" style="display: none;" />
		  	<button type="button" onclick="goSearch();"><i class="fas fa-search"></i></button>
	  	</div>
	  	
	  	<div class="text-right mt-3">
			<input type="checkbox"/><label>전체선택(배송하기)</label>
			<input type="button" value="배송하기"/>
			<input type="checkbox" class="ml-3"/><label>전체선택(배송완료)</label>
			<input type="button" value="배송완료" />
		</div>
		
  	</form>
  	
  	<div style="overflow-x:auto;">
	  	<table class="table mt-4 prodList text-center" >
			<thead class="thead-light">
				<tr>
					<th class="col-2">주문일자</th>
					<th class="col-2">주문번호</th>
					<th class="col-2">주문자명</th>
					<th class="col-2">주문금액</th>
					<th class="col-2">주문상세</th>
					<th class="col-2">배송상태</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td>2022.09.20</td>
					<td>20220913-0023355</td>
					<td>이순신</td>
					<td>35,000원</td>
					<td>
						<input type="button" value="조회" id="orderDetailBtn" onclick="goOrderDetailPop();" />
					</td>
					<td>
						<input type="checkbox" /><label >배송하기</label>
						<input type="checkbox" /><label >배송완료</label>
					</td>
				</tr>
				<tr>
					<td>2022.09.20</td>
					<td>20220913-0023355</td>
					<td>이순신</td>
					<td>35,000원</td>
					<td>
						<input type="button" value="조회" id="orderDetailBtn" onclick="goOrderDetailPop();" />
					</td>
					<td>
						<input type="checkbox" /><label >배송하기</label>
						<input type="checkbox" /><label >배송완료</label>
					</td>
				</tr>
				<tr>
					<td>2022.09.20</td>
					<td>20220913-0023355</td>
					<td>이순신</td>
					<td>35,000원</td>
					<td>
						<input type="button" value="조회" id="orderDetailBtn" onclick="goOrderDetailPop();" />
					</td>
					<td>
						<input type="checkbox" /><label >배송하기</label>
						<input type="checkbox" /><label >배송완료</label>
					</td>
				</tr>
				<tr>
					<td>2022.09.20</td>
					<td>20220913-0023355</td>
					<td>이순신</td>
					<td>35,000원</td>
					<td>
						<input type="button" value="조회" id="orderDetailBtn" onclick="goOrderDetailPop();" />
					</td>
					<td>
						<input type="checkbox" /><label >배송하기</label>
						<input type="checkbox" /><label >배송완료</label>
					</td>
				</tr>
				
			</tbody>
		</table>
	</div>
		
		<nav aria-label="Page navigation example" style="margin-top: 60px;">
		<ul class="pagination justify-content-center">
			<li class="page-item">
				<a class="page-link" href="#" aria-label="Previous"> <span aria-hidden="true">&laquo;</span></a>
			</li>
			<li class="page-item">
				<a class="page-link" href="#">${requestScope.pageBar}</a>
			</li>
			<li class="page-item">
				<a class="page-link" href="#" aria-label="Next">
					<span aria-hidden="true">&raquo;</span>
				</a>
			</li>
		</ul>
	</nav>

</div>

<%@ include file="../footer.jsp"%>