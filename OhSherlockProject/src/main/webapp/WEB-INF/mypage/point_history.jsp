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

.money_date{

	position: relative;
	left: 56%;         
	padding-bottom: 1%;  
}

.page-link {
	  color: #666666; 
	  background-color: #fff;
	  border: 1px solid #ccc; 
	}
	
.page-link:focus, .page-link:hover {
	  color: #1E7F15;
	  background-color: #fafafa; 
	  border-color: #1E7F15;
	}	

</style>

<script type="text/javascript">


	$(document).ready(function(){
		
		
			$("#dateSearch").on('click',function(e){
				const dateFrm = document.dateFrm;
				dateFrm.action="coin_history.tea";
				dateFrm.method = "get";
				dateFrm.submit();
			});
			
			
			
	});
	
		
	

	
	function gosizePerPage() {
		
		const sizeFrm = document.sizeFrm;
		sizeFrm.sizePerPage.value = $("#sizePerPage").val();
		sizeFrm.action="point_history.tea";
		sizeFrm.method = "get";
		sizeFrm.submit();
	}


 
</script>



<div class="container mypage">
	<h2 style="font-weight: bold; margin-bottom: 20px;">적립금내역</h2>
	
	<div class="card border-0">   
	   <div class="card-body" style="border: solid 2px gray; border-radius: 15px; height: 100px;">             
	      <i class="fab fa-envira" style="font-size: 40px; float: left; padding-right: 10px;"></i>             
	      <h3 style="padding-top: 5px;">사용 가능한 찻잎</h3>           
	      <h1 style="float: right; font-weight: bold; color: #1E7F15; position: relative; top: -45px;"><fmt:formatNumber value="${(sessionScope.loginuser).point}" pattern="###,###찻잎" /></h1>        
	   </div> 
    </div>
    
    <form name="dateFrm" style="float: left; margin-top: 25px;">
	<input type="date" id="date1" name="date1">
	~
	<input type="date" id="date2" name="date2"> 
	<button id="dateSearch" type="submit" >조회</button> 
	</form>
	
	
	<form name="sizeFrm"><input type="hidden" name="sizePerPage" value=""/></form>
	
		<div class="text-right" style="margin-top: 20px;"> 
			<select id="sizePerPage" name="sizePerPage" onchange="gosizePerPage()"> <%-- 값이 변하면 여기의 name에 담아준다. 여기다 담은 name을 goSearch에서 action 으로 보내준다. --%>
				<option value="10">페이지당 예치금 내역</option>  
				<option value="10">10</option> 
				<option value="5">5</option>  
				<option value="3">3</option>
			</select>
		</div>

	
	<div class="orderIf">
		<table class="table mt-4 text-center"> 
			<thead class="thead-light"> 
				<tr>
					<th>일자</th>
					<th>내역</th>
					<th>적립/사용</th>
				</tr>
			</thead> 
	  <tbody>
				<c:forEach var="pvo" items="${requestScope.point_history}"> 
					<tr class="pointInfo">
						<td name="name">${pvo.point_date}</td>
						<td name="mobile">${pvo.point_amount}</td> 
						<td name="idle"> 
							<c:choose>
								<c:when test="${pvo.point_amount < 0}">사용</c:when> 
								<c:otherwise>적립</c:otherwise>
							</c:choose>
						</td>
					</tr> 
				</c:forEach>
			</tbody>
		</table>
	</div>
	
	
	
	
	
    <nav aria-label="Page navigation example" style="margin-top: 60px;">
		<ul class="pagination justify-content-center" style="margin:auto;">${requestScope.pageBar}</ul>
	</nav>
	
</div>
 <%@ include file="../footer.jsp"%>