<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>


<%@ include file="header.jsp"%>

<!-- 직접 만든 CSS -->
<link rel="stylesheet" type="text/css" href="./css/style_yeeun.css" />    <!-- /MyMVC/src/main/webapp/css/style.css 파일 경로 -->
    
<style type="text/css">

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
  <div class="col-md-12">
  
    <div class="col-md-15">
      <h2 style="font-weight: bold;">주문조회</h2><br>
      <hr style="background-color: black; height: 1.2px;"><br>
      <h5 style="font-weight: bold;">최근 주문내역</h5>
    </div>  
    
    <div class="row bg-light" style="height: 80px; margin-top: 55px;">
	    <div class="btn-group" role="group" aria-label="Basic example" style="float: left;">
		  <button type="button" class="btn btn-light" style="padding-left: 130px;">1개월</button>
		  <span class="btn btn-light" style="color: gray; margin-top: 20px;">|</span>
		  <button type="button" class="btn btn-light">3개월</button>
		  <span class="btn btn-light" style="color: gray; margin-top: 20px;"">|</span>
		  <button type="button" class="btn btn-light">6개월</button>
		  <span class="btn btn-light" style="color: gray; margin-top: 20px;"">|</span>
		  <button type="button" class="btn btn-light" style="padding-right: 50px;">12개월</button>
		</div>
	    
	    <div class="date" style="float: left; margin-top: 25px;">
			<input class="fText hasDatepicker" readonly="readonly" size="15" value="2022-08-17" type="text" style="margin-left: 30px; text-align: center;"><button type="button" class="ui-datepicker-trigger" ><img src="//img.echosting.cafe24.com/skin/admin_ko_KR/myshop/ico_cal.gif" alt="..." title="..."></button>
			<span class="bar">~</span>
			<input class="fText hasDatepicker" readonly="readonly" size="15" value="2022-09-16" type="text" style="text-align: center;"><button type="button" class="ui-datepicker-trigger" ><img src="//img.echosting.cafe24.com/skin/admin_ko_KR/myshop/ico_cal.gif" alt="..." title="..."></button>				
			<input type="button" value="조회" style="margin-left: 10px; width: 80px;"/>
		</div>
    </div>
    
     
    <div>
		<table class="table" style="margin-top: 80px;">
			<colgroup>
	          <col width="250px"/>
	          <col width="400px"/>
	          <col/>
	          <col/>
	          <col/>
	      	</colgroup>
			<thead class="thead-light">
				<tr>
					<th style="text-align: center;">주문일자(주문번호)</th>
					<th style="text-align: center;">제품명</th>
					<th>수량</th>
					<th>&nbsp;&nbsp;&nbsp;가격</th>
					<th>처리상태</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td class="align-middle" style="text-align: center;">2022.09.13<br>[20220913-0023355]</td>  <!-- 주문번호를 누르면 주문 상세 페이지로 이동 -->
					<td><img src="<%= ctxPath%>/images/그린티라떼더블샷.png" width=100 height=100>그린티 라떼 더블샷</td>
					<td class="align-middle">&nbsp;1</td>
					<td class="align-middle">12,000원</td>
					<td class="align-middle">결제완료</td>
				</tr>
				<tr>
					<td class="align-middle" style="text-align: center;">2022.08.15<br>[20220815-0013805]</td>
					<td><img src="<%= ctxPath%>/images/녹차 밀크 스프레드 세트.png" width=100 height=100>녹차 밀크 스프레드 세트</td>
					<td class="align-middle">&nbsp;1</td>
					<td class="align-middle">20,000원</td>
					<td class="align-middle">주문취소</td>
				</tr>
				<tr>
					<td class="align-middle" style="text-align: center;">2021.12.24<br>[20211224-0004320]</td>
					<td><img src="<%= ctxPath%>/images/베스트 블렌디드 티백 박스.png" width=100 height=100>베스트 블렌디드 티백 박스</td>
					<td class="align-middle">&nbsp;1</td>
					<td class="align-middle">29,500원</td>
					<td class="align-middle">구매확정</td>
				</tr>
			</tbody>
		</table>
	</div>
	
	<br>
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
</div>

<%@ include file="footer.jsp"%>
