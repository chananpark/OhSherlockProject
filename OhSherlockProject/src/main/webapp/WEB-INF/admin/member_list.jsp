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
		
		$("tbody > tr").click(function(e){

			/*
			// 회원번호 값을 알아야만 db에 보내서, 클릭한 정보를 알아올 수 있다.
			
			const $target = $(e.target); // <td> 태그 이다. 왜냐하면 tr 속에 td가 있기 때문에
		//	console.log("확인용 : "+ $target.html());
			
			// td의 한단계 위로 올라가서 span 태그를 찾아오면 seq 가 나온다.
			const seq = $target.parent().find("span").text(); // 회원 번호 // 클릭해온 곳의 부모에 있는 span 태그의 text만 긁어오면 그것이 회원번호 이다. 
			console.log("확인용 : "+ seq);
			 
			location.href = "personDetail.do?seq="+seq; // 상대경로 없이 맨 뒤에만 바뀐다
			// 클릭했을 때 연결해줄 링크
			*/
			
			location.href = "<%= request.getContextPath() %>/admin/member_list_detail.jsp"; 
			
		}); // end of $("tbody > tr").click(function()
		
	}); // end of $(document).ready
		
</script>

<div class="container" id="member_list">

   <h2 class="col text-left" style="font-weight:bold">회원조회</h2><br>
   <hr style="background-color: black; height: 1.2px;"><br>
  
  	<div class="text-right">
	  	<input type="text" placeholder="회원명을 입력하세요"/>&nbsp;
	  	<button type="button"><i class="fas fa-search"></i></button>
  	</div>
  	
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
					<tr>
						<td>leess</td>
						<td>이순신</td>
						<td>010-1234-1234</td>
						<td>휴면</td>
					</tr>
					<tr>
						<td>eomjh</td>
						<td>엄정화</td>
						<td>010-3456-1234</td>
						<td>활동</td>
					</tr>
					<tr>
						<td>eomjh</td>
						<td>엄정화</td>
						<td>010-3456-1234</td>
						<td>활동</td>
					</tr>
					<tr>
						<td>eomjh</td>
						<td>엄정화</td>
						<td>010-3456-1234</td>
						<td>활동</td>
					</tr>
					<tr>
						<td>eomjh</td>
						<td>엄정화</td>
						<td>010-3456-1234</td>
						<td>활동</td>
					</tr>
					<tr>
						<td>eomjh</td>
						<td>엄정화</td>
						<td>010-3456-1234</td>
						<td>활동</td>
					</tr>
					
				</tbody>
			</table>
		</div>
		
		
		<nav aria-label="Page navigation example" style="margin-top: 60px;">
		<ul class="pagination justify-content-center">
			<li class="page-item"><a class="page-link" href="#"
				aria-label="Previous"> <span aria-hidden="true">&laquo;</span>
			</a></li>
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