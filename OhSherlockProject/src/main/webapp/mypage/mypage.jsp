<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>
<%@ include file="../sidebar.jsp"%> 

<style>

.mysidebar .nav-link {
	/* border:solid 1px red; */
	width: 500px;
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
	margin-left: 70px;  
	width: 100px; 
	float: left;
}  

/* .myIndex{	
	margin-top: 5%;     
	margin-left: 4%;  
	width: 100px; 
	float: left; 
} */

.mypage {
	position: relative; /* 원래있던 자신의 위치를 기준으로 한 상대위치 값을 지정한다. 자주사용한다.!! */
	left: 60px;  /* 가로위치값 */
}

.mpComment {
	font-size: 15px; 
	font-weight: bold;
}


.infoUpdate {
	width: 20%;
	margin-left: 15px;
	background-color: #1E7F15;
	color: white;
}

.viewBtns {
	border: 1px; 
	solid gray; 
	width: 50px; 
	height: 30px;
}

.orderIf td {
	vertical-align: middle;
}



</style>

<div class="container mypage">
	<h2 style="font-weight: bold; margin-bottom: 20px;">마이페이지</h2>
	
	<div class="card border-0">  
	   <div class="card-body" style="background-color: #cccccc;">  
	      <i style='font-size:48px; float: left; padding: 0 2%;' class='fas'>&#xf508;</i>     
	      <h5 class="card-title mpComment">&nbsp;&nbsp;&nbsp;&nbsp;홍길동님,  안녕하세요.</h5>   
	      <button type="button" class="btn infoUpdate">회원정보 수정</button>  
	   </div>
    </div>

    <br><br><br>
	<div>
	   <span style="font-weight: bold; font-size: 15pt;">최근 주문정보</span>
	   <span>(최근 1개월)</span>
	   <span style="float: right;">더보기&nbsp;></span>
	</div>

	<div class="orderIf">
		<table class="table mt-4 text-center"> 
			<thead class="thead-light"> 
				<tr>
					<th>날짜</th>
					<th>상품명</th>
					<th>결제금액</th>
					<th>배송현황</th>
				</tr>
			</thead> 
			<tbody>
				<tr>
					<td>2022.09.05</td>
					<td>프리미엄 티 컬렉션</td>
					<td>28,000원</td> 
					<td><input type="button" class="viewBtns" value="조회" /></td>
				</tr>
				<tr>
					<td>2022.01.20</td>
					<td>러블리 티 박스</td>
					<td>20,000원</td> 
					<td><input type="button" class="viewBtns" value="조회" /></td> 
				</tr>
				<tr>
					<td>2021.12.22</td>
					<td>에브리데이 텀블러 키트</td>
					<td>36,500원</td> 
					<td><input type="button" class="viewBtns" value="조회" /></td> 
				</tr>
			</tbody>
		</table>
	</div>
	
	
    <br>
	<div>
	   <span style="font-weight: bold; font-size: 15pt;">최근 문의내역</span>
	   <span style="float: right;">더보기&nbsp;></span>
	</div>

	<div>
		<table class="table mt-4 text-center"> 
			<thead class="thead-light"> 
				<tr>
					<th>날짜</th>
					<th>제목</th>
					<th>문의유형</th>
				</tr>
			</thead> 
			<tbody>
				<tr>
					<td>2022.09.06</td>
					<td>배송문의</td>
					<td>기타</td> 
				</tr>
				<tr>
					<td>2022.01.20</td>
					<td>주문취소/배송전변경 문의</td>
					<td>취소/환불/교환</td> 
				</tr>
				<tr>
					<td>2021.12.26</td>
					<td>교환/반품문의</td>
					<td>취소/환불/교환</td> 
				</tr>
			</tbody>
		</table>
	</div>
	
    
	
</div>
 <%@ include file="../footer.jsp"%>