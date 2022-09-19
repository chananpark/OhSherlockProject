<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>    
    
<style>

	.listView {
		width: 90px; 
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
   
    <div class="col text-left">
      <div style="font-weight: bold; font-size: 20px;">4월 다다일상 베이직/홈카페 배송 지연 안내</div><br>
      <div style="font-weight: normal; font-size: 15.5px; margin-bottom: 10px;">2022.04.12</div>
    </div>
    
    <hr style="border-top: solid 1.2px black">
    
    <div class="col text-left">
      <div style="font-size: 20px;">
	      <br>안녕하세요. 오설록입니다.<br>
		  항상 오설록을 사랑해 주시는 고객님들께 먼저 죄송한 말씀드립니다.<br><br>
		  현재 코로나로 인한 생산 지연과 인원 부족, 그리고 다다일상 주문 건수 증가로 인하여<br>
		  금월 다다일상 베이직/홈카페의 가장 주요한 구성품인 '벚꽃향 가득한 올레 10입'의 재고 부족으로 다다일상 배송이 지연되고 있습니다.<br>
		  재고는 4/20 이후 입고 예정이며 입고되는 대로 빠르게 고객님들께 배송될 수 있도록 하겠습니다.<br><br>
		  고객님들께 불편을 드리게 된 점 책임을 깊게 통감 중에 있습니다.<br>
		  동일한 문제 발생하지 않도록 더욱 노력하겠으며, 더 좋은 서비스로 보답드릴 수 있도록 최선을 다 하겠습니다.<br><br>
		  앞으로도 오설록에 대한 많은 관심과 사랑 부탁드립니다.<br>
		  감사합니다.<br>
		  오설록 드림<br>
	  </div>
    </div>
	
  	<div class="text-right" style="display: block; margin-top: 30px;"> <%-- 글쓰기 버튼은 관리자 계정에서만 보임 --%>
	  <input type="button" class="btn-secondary listView" value="목록보기" />
    </div>
	
	
</div>

<%@ include file="../footer.jsp"%>