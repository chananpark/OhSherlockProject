<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>    
    
<style>

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

	.badge {
		background-color: #1E7F15; 
		color: white; 
		font-weight: bold;
	}
	
	.btn-secondary {
		width: 80px; 
		margin: 15px; 
		border-style: none; 
		height: 30px;
		font-size: 14px;
	}
	
	.btn-secondary:hover {
		border: 2px none #1E7F15;
		background-color: #1E7F15;
	    color: white;
	}
	
</style>       
    
<div class="container">

	<div class="titleZone row">
      <h2 class="col text-left" style="font-weight:bold">공지사항</h2><br>
      <div class="col text-right">
         <span style="font-weight: bold; font-size: 20px;">02-336-8546</span><br>
         <span style="font-weight: normal; font-size: 15.5px;">평일 09:30 ~ 18:00 (점심시간 12:30 ~ 13:30)<br>주말 및 공휴일 휴무</span>
       </div>
   </div>
   <hr style="background-color: black; height: 1.2px;"><br>
   
		<table class="table mt-4 text-center">
			<thead class="thead-light">
				<tr>
					<th>번호</th>
					<th>제목</th>
					<th>등록일</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td style="class=storeNo">4</td>
					<td><span class="badge badge-pill">new</span>&nbsp;&nbsp;교환/반품 전 필독 사항</td>
					<td>2022.09.02</td>
				</tr>
				<tr>
					<td style="class=storeNo">3</td>
					<td>4월 다다일상 베이직/홈카페 배송 지연 안내</td>
					<td>2022.04.12</td>
				</tr>
				<tr>
					<td style="class=storeNo">2</td>
					<td>오!셜록 개인정보 처리방침 변경 고지</td>
					<td>2022.03.17</td>
				</tr>
				<tr>
					<td style="class=storeNo">1</td>
					<td>CJ대한통운 파업 종료 및 배송지연, 정상화 안내</td>
					<td>2022.03.10</td>
				</tr>
			</tbody>
		</table>
			

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
	
	<div class="text-right" id="detail" style="display: block; margin-top: 15px;"> <%-- 글쓰기 버튼은 관리자 계정에서만 보임 --%>
	  <input type="button" class="btn-secondary" value="글쓰기" />
    </div>
	
	
</div>

<%@ include file="../footer.jsp"%>