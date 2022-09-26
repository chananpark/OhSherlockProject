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

<div class="container mypage">
	<h2 style="font-weight: bold; margin-bottom: 20px;">적립금내역</h2>
	
	<div class="card border-0">   
	   <div class="card-body" style="border: solid 2px gray; border-radius: 15px; height: 100px;">             
	      <i class="fab fa-envira" style="font-size: 40px; float: left; padding-right: 10px;"></i>             
	      <h3 style="padding-top: 5px;">사용 가능한 적립금</h3>           
	      <h1 style="float: right; font-weight: bold; color: #1E7F15; position: relative; top: -45px;">540p</h1>        
	   </div> 
    </div>
    
    <div class="money_date" style="float: left; margin-top: 25px;">
		<input class="fText hasDatepicker" readonly="readonly" size="15" value="2022-08-17" type="text" style="margin-left: 30px; text-align: center;"><button type="button" class="ui-datepicker-trigger" ><img src="//img.echosting.cafe24.com/skin/admin_ko_KR/myshop/ico_cal.gif" alt="..." title="..."></button>
		<span class="bar">~</span>
		<input class="fText hasDatepicker" readonly="readonly" size="15" value="2022-09-16" type="text" style="text-align: center;"><button type="button" class="ui-datepicker-trigger" ><img src="//img.echosting.cafe24.com/skin/admin_ko_KR/myshop/ico_cal.gif" alt="..." title="..."></button>				
		<input type="button" value="조회" style="margin-left: 10px; width: 80px;"/>
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
				<tr>
					<td>2022.09.07</td>
					<td>주문적립 (주문번호: Y220905204715)</td>
					<td>+140p</td> 
				</tr>
				<tr>
					<td>2022.01.22</td>
					<td>주문적립 (주문번호: Y220120174219)</td>
					<td>+100p</td> 
				</tr>
				<tr>
					<td>2021.12.26</td>
					<td>주문취소/반품으로 인한 사용 취소 (주문번호: Y211224124013)</td>
					<td>+200p</td> 
				</tr>
				<tr>
					<td>2021.12.24</td>
					<td>주문시사용 (주문번호: Y211224124013)</td>
					<td>-200p</td> 
				</tr>
				<tr>
					<td>2021.12.03</td>
					<td>주문적립 (주문번호: Y211203253012)</td>
					<td>+150p</td> 
				</tr>
				<tr>
					<td>2021.12.01</td>
					<td>주문시사용 (주문번호: Y211201253012)</td>
					<td>-1000p</td> 
				</tr>
				<tr>
					<td>2021.06.28</td>
					<td>주문적립 (주문번호: Y210626210410)</td>
					<td>+500p</td> 
				</tr>
				<tr>
					<td>2021.03.28</td>
					<td>주문적립 (주문번호: Y210326092018)</td>
					<td>+650p</td> 
				</tr>
			</tbody>
		</table>
	</div>
	
    <nav aria-label="Page navigation example" style="margin-top: 60px;">
	  <ul class="pagination justify-content-center">
	    <li class="page-item">
	      <a class="page-link" href="#" aria-label="Previous">
	        <span aria-hidden="true">&laquo;</span>
	      </a>
	    </li>
	    <li class="page-item"><a class="page-link" href="#">1</a></li>
	    <li class="page-item"><a class="page-link" href="#">2</a></li>
	    <li class="page-item"><a class="page-link" href="#">3</a></li>
	    <li class="page-item">
	      <a class="page-link" href="#" aria-label="Next">
	        <span aria-hidden="true">&raquo;</span>
	      </a>
	    </li>
	  </ul>
	</nav>
	
</div>
 <%@ include file="../footer.jsp"%>