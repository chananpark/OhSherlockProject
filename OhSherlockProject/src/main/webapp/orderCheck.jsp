<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>


<%@ include file="header.jsp"%>

<!-- 직접 만든 CSS -->
<link rel="stylesheet" type="text/css" href="./css/style_yeeun.css" />    <!-- /MyMVC/src/main/webapp/css/style.css 파일 경로 -->

<style type="text/css">

	.fakeimg {
    	height: 200px;
    	background: #aaa;
	}
	
</style>
    
<div class="container">
  <div class="col-md-12">
  
    
    <div class="col-md">
      <h2 style="font-weight: bold;">주문조회</h2><br>
      <hr style="background-color: black; height: 1.2px;">
      <h5 style="font-weight: bold;">최근 주문내역</h5>
    </div>  
    
    <div class="btn-group" role="group" aria-label="Basic example">
	  <button type="button" class="btn btn-light">1개월</button>
	  <span class="btn btn-light" style="color: gray;">|</span>
	  <button type="button" class="btn btn-light">3개월</button>
	  <span class="btn btn-light" style="color: gray;">|</span>
	  <button type="button" class="btn btn-light">6개월</button>
	  <span class="btn btn-light" style="color: gray;">|</span>
	  <button type="button" class="btn btn-light">12개월</button>
	</div>
    
    <div class="date">
				<input id="history_start_date" name="history_start_date" class="fText hasDatepicker" readonly="readonly" size="10" value="2022-03-20" type="text">
				<span class="bar">~</span><input id="history_end_date" name="history_end_date" class="fText hasDatepicker" readonly="readonly" size="10" value="2022-09-16" type="text"><button type="button" class="ui-datepicker-trigger"><img src="//img.echosting.cafe24.com/skin/admin_ko_KR/myshop/ico_cal.gif" alt="..." title="..."></button>				
				<input id="order_search_btn" type="image" src="/_wisa/img/mypage/order_search.png" class="btn">
			&nbsp;</div>
    
    <table>
      <tr>
         <td style="width: 80%; text-align: left;">
            <input type="text" id="fromDate">&nbsp;&nbsp; 
            ~&nbsp;&nbsp; <input type="text" id="toDate">
         </td>
      </tr>
    </table>
     
    <div>
		<table class="table mt-5">
			<thead class="thead-light">
				<tr>
					<th>주문일자(주문번호)</th>
					<th></th>
					<th>제품명</th>
					<th>수량</th>
					<th>가격</th>
					<th>처리</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td class="align-middle">2022.09.13<br>[20220913-0023355]</td>
					<td><img src="<%= ctxPath%>/images/그린티라떼더블샷.png" width=100 height=100></td>
					<td class="align-middle">그린티 라떼 더블샷</td>
					<td class="align-middle">1</td>
					<td class="align-middle">12,000원</td>
					<td class="align-middle">결제완료</td>
				</tr>
				<tr>
					<td class="align-middle">2022.09.13<br>[20220913-0023355]</td>
					<td><img src="<%= ctxPath%>/images/그린티라떼더블샷.png" width=100 height=100></td>
					<td class="align-middle">그린티 라떼 더블샷</td>
					<td class="align-middle">1</td>
					<td class="align-middle">12,000원</td>
					<td class="align-middle">결제완료</td>
				</tr>
				<tr>
					<td class="align-middle">2022.09.13<br>[20220913-0023355]</td>
					<td><img src="<%= ctxPath%>/images/그린티라떼더블샷.png" width=100 height=100></td>
					<td class="align-middle">그린티 라떼 더블샷</td>
					<td class="align-middle">1</td>
					<td class="align-middle">12,000원</td>
					<td class="align-middle">결제완료</td>
				</tr>
			</tbody>
		</table>
	</div>
    
    
      
      
     <div> 
      <div class="fakeimg">Fake Image</div>
      <p>Some text..</p>
      <p>Sunt in culpa qui officia deserunt mollit anim id est laborum consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco.</p>
      <br>
      <h2>TITLE HEADING</h2>
      <h5>Title description, Sep 2, 2017</h5>
      <div class="fakeimg">Fake Image</div>
      <p>Some text..</p>
      <p>Sunt in culpa qui officia deserunt mollit anim id est laborum consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco.</p>
    </div>
    
  </div>
</div>

<%@ include file="footer.jsp"%>
