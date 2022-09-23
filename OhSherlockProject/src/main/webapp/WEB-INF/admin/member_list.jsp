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
	
	.page-link {
	  color: #666666; 
	  background-color: #fff;
	  border: 1px solid #ccc; 
	}
	
	.page-item.active .page-link {
	 z-index: 1;
	 color: #1E7F15;
	 border-color: #1E7F15;
	 
	}
	
	.page-link:focus, .page-link:hover {
	  color: #1E7F15;
	  background-color: #fafafa; 
	  border-color: #1E7F15;
	}
	
	/*
	table {
	  border-collapse: collapse;
	  border-spacing: 0;
	  width: 100%;
	  border: 1px solid #ddd;
	}
	
	th {
	  text-align: left;
	  padding: 8px;
	}
	
	td {
		text-align: left;
		padding: 8px;
	}
	*/
	
	table > tbody > tr:hover {
		background-color: #f1f1f1;
		color: black;
		cursor: pointer;		
	}
	
</style>

<script type="text/javascript">

	$(document).ready(function(){
		
		// 각 행을 클릭했을 때 해당하는 행의 회원 상세 조회 보여주기
		$("tbody > tr").click(function(e){
			
			const $target = $(e.target); // <td> 태그 이다. 왜냐하면 tr 속에 td가 있기 때문에
		//	console.log("확인용 : "+ $target.html());
			
			// 클릭한 tr의 userid 알아오기
			const userid = $target.parent().find("td[name='userid']").text(); 
		//	console.log("확인용 : "+ seq);
			 
		//	location.href = "personDetail.do?seq="+seq; // 상대경로 없이 맨 뒤에만 바뀐다
			// 클릭했을 때 연결해줄 링크
			
		//	location.href = "<%= request.getContextPath() %>/admin/member_list_detail.jsp"; 
		}); // end of $("tbody > tr").click(function()
			
				
		// select 태그에 대한 이벤트는 클릭이 아니라 change 이다
		// select 를 선택할 때의 이벤트
		$("select#sizePerPage").bind("change", function(){
			goSearch();
		});
		
		// select로 선택한 한 페이지에 출력될 회원수를 선택에 따라 값이 변하지 않고 유지하기(10명이면 10, 5명이면 5)
		if(${requestScope.sizePerPage} != null) { // 또는 "${requestScope.sizePerPage}" != "" // url에 null 이외의 것이 들어왔다면
			$("select#sizePerPage").val("${requestScope.sizePerPage}");
		}
		
				
	}); // end of $(document).ready
		
	
	// == Function Declaration 함수선언 == 
	
	// select로 선택한 한 페이지에 출력될 회원수가 선택에 따라서 다르게 출력해주는 함수	
	function goSearch() {
		const frm = document.memberFrm;
		frm.action = "member_list.tea"; // 자기가 자기한테 가는거라 그대로 상대경로 이다.
		frm.method = "GET";
		frm.submit();
	} // end of function goSearch() 
	
</script>

<div class="container" id="member_list">

   	<h2 class="col text-left" style="font-weight:bold">회원조회</h2><br>
	<hr style="background-color: black; height: 1.2px;"><br>
  
	<form name="memberFrm">
	
	  	<div class="text-right">
			<select id="sizePerPage" name="sizePerPage"> <%-- 값이 변하면 여기의 name에 담아준다. 여기다 담은 name을 goSearch에서 action 으로 보내준다. --%>
				<option value="10">페이지당 회원명수</option>
				<option value="10">10</option>
				<option value="30">30</option>
				<option value="50">50</option>
			</select>
	  		<select id="searchType" name="searchType">
				<option value="name">회원명</option> 
				<option value="userid">아이디</option>
				<option value="mobile">연락처</option>
		    </select>
		    
		  	<input type="text" name="searchWord" placeholder="검색어를 입력하세요"/>&nbsp;
		  	<input type="text" style="display: none;" />
		  	<button type="button" onclick="goSearch();"><i class="fas fa-search"></i></button>
	  	</div>
	  	
  	</form>
  	
  	<div style="overflow-x:auto;">
	  	<table class="table mt-4 prodList text-center" >
			<thead class="thead-light">
				<tr>
					<th class="col-3">아이디</th>
					<th class="col-3">이름</th>
					<th class="col-3">연락처</th>
					<th class="col-3">휴면계정여부</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="mvo" items="${requestScope.memberList}">
					<tr>
						<td name="userid" >${mvo.userid}</td>
						<td name="name">${mvo.name}</td>
						<td name="mobile">${mvo.mobile}</td>
						<td name="idle">
							<c:choose>
								<c:when test="${mvo.idle eq '0'}">활동</c:when>
								<c:otherwise>휴면</c:otherwise>
							</c:choose>
						</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>
		
		
		<nav aria-label="Page navigation example" style="margin-top: 60px;">
		<ul class="pagination justify-content-center">
			<li class="page-item">
				<a class="page-link" href="#" aria-label="Previous"> <span aria-hidden="true">&laquo;</span></a>
			</li>
			<li class="page-item"><a class="page-link" href="#">1</a></li>
			<li class="page-item"><a class="page-link" href="#">2</a></li>
			<li class="page-item"><a class="page-link" href="#">3</a></li>
			<li class="page-item"><a class="page-link" href="#"
				aria-label="Next"> <span aria-hidden="true">&raquo;</span>
			</a></li>
		</ul>
	</nav>
</div>







<%@ include file="../footer.jsp"%>