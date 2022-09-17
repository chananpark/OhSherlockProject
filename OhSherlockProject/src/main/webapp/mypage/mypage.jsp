<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>
<%@ include file="../sidebar.jsp"%> 

<style>

.mysidebar .nav-link {
	/* border:solid 1px red; */
    padding: 0 0 3px 0;
    font-size: 13px;       
    color: #404040; 
}
  
.mysidebar #nav02{
	/* border:solid 1px red; */
	padding: 10px 0 0 0;
} 
 
.mysidebar .title{
	/* border:solid 1px red; */
	font-family: 'Nanum Gothic', sans-serif;
	padding-top: 5%;      
	font-size: 18px;       
    color: #404040; 
} 

.mysidebar{
font-family: 'Gowun Dodum', sans-serif;
	position: alsolute;
	/* margin-top: 60px;    */  
	margin-left: 60px;  
	width: 100px; 
	float: left;
}  

/* .myIndex{	
	margin-top: 5%;     
	margin-left: 4%;  
	width: 100px; 
	float: left; 
} */

</style>

<div class="container mypage">
	<h2 style="font-weight: bold">마이페이지</h2>
	
	<div class="card border-0">  
    <div class="card-body" style="background-color: #cccccc;">  
      <i style='font-size:48px; float: left; padding: 0 2%;' class='fas'>&#xf508;</i>     
      <h5 class="card-title" style="font-size: 15px; font-weight: bold;">홍길동님,  안녕하세요.</h5>   
      <button type="button" class="btn btn-success" style="width: 20%;">회원정보 수정</button>  
    </div>
  </div>

	<div >
		<table class="table mt-4" style="text-align: center;"> 
			<thead class="thead-light"> 
				<tr>
					<th>날짜</th>
					<th>상품명</th>
					<th>결제금액 </th>
					<th>배송현황</th>
				</tr>
			</thead> 
			<tbody>
				<tr>
					<td>2022.09.05</td>
					<td>프리미엄 티 컬렉션 </td>
					<td>28,000원</td> 
					<td><p><input type="button" value="조회"/></p> 
				</tr>
				<tr>
					<td>2022.01.20</td>
					<td>러블리 티 박스</td>
					<td>28,000원</td> 
					<td><p><input type="button" value="조회"/></p> 
				</tr>
				<tr>
					<td>2022.09.05</td>
					<td>프리미엄 티 컬렉션 </td>
					<td>28,000원</td> 
					<td><p><input type="button" value="조회"/></p> 
				</tr>
			</tbody>
		</table>
	</div>
 </div>
 <%@ include file="../footer.jsp"%>