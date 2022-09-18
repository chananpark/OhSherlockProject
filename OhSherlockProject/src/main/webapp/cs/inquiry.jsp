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

</style>       
    
<div class="container">

	<h2 style="font-weight:bold">1:1 문의</h2><br>
		<hr style="background-color: black; height: 1.2px;"><br>
		<table class="table mt-4">
			<thead class="thead-light">
				<tr>
					<th>매장유형</th>
					<th>지점이름</th>
					<th>상세주소</th>
					<th>전화번호</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td style="display:none" class="storeNo">1</td>
					<td>티하우스</td>
					<td>서울 서교동 쌍용점</td>
					<td>서울특별시 마포구 서교동 447-5</td>
					<td>02-336-8546</td>
				</tr>
				<tr>
					<td style="display:none" class="storeNo">2</td>
					<td>티뮤지엄</td>
					<td>제주도 한라산 오름점</td>
					<td>제주특별자치도 서귀포시 안덕면 창천리 564 제주특별자치도</td>
					<td>064-794-5312</td>
				</tr>
				<tr>
					<td style="display:none" class="storeNo">3</td>
					<td>면세점</td>
					<td>프랑스 파리 에펠탑점</td>
					<td>Champ de Mars, 5 Av. Anatole France, 75007 Paris</td>
					<td>+ 33 7 66 89 27 49</td>
				</tr>
				<tr>
					<td style="display:none" class="storeNo">4</td>
					<td>백화점</td>
					<td>미국 뉴욕 센트럴파크점</td>
					<td>Manhattan, New York City, United States</td>
					<td>+1 212-310-6600</td>
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
</div>

<%@ include file="../footer.jsp"%>