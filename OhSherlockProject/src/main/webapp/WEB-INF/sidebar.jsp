<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
    
<%-- 사이드바시작 --%>   
	<div class="mysidebar">        
		  <p class="title" id="shopping" style="font-weight: bold;">나의 쇼핑</p>  
		  <div class="nav flex-column" id="nav01">
		      <div><a class="nav-link" href="#">주문조회</a></div>
		      <div><a class="nav-link" href="#">취소/반품/교환 내역</a></div>
		      <div><a class="nav-link" href="<%= request.getContextPath() %>/cart/cart.tea">장바구니</a></div>
		      <div><a class="nav-link" href="<%= request.getContextPath() %>/shop/likeList.tea?userid=${(sessionScope.loginuser).userid}">찜목록</a></div>
		  </div>
		  
		  <div class="nav flex-column" id="nav02">
		      <div><a class="nav-link" href="<%= request.getContextPath() %>/mypage/point_history.tea?userid=${(sessionScope.loginuser).userid}">적립금내역</a></div>
              <div><a class="nav-link" href="<%= request.getContextPath() %>/mypage/coin_history.tea?userid=${(sessionScope.loginuser).userid}">예치금내역</a></div>
		  </div>
		  
		  <p class="title" id="activity" style="font-weight: bold; padding-top: 20px;">나의 활동</p>    
		  <div class="nav flex-column" id="nav03">
		      <div><a class="nav-link" href="<%=request.getContextPath()%>/mypage/inquiryList.tea">1:1 문의 내역</a></div>
		      <div><a class="nav-link" href="<%=request.getContextPath()%>/mypage/reviewList.tea?userid=${(sessionScope.loginuser).userid}">상품 리뷰</a></div>
		  </div>
		  
		  <p class="title" id="information" style="font-weight: bold; padding-top: 20px;">나의 정보</p>
		  <div class="nav flex-column" id="nav04">
		      <div><a class="nav-link" href="<%= request.getContextPath() %>/member/memberEdit.tea?userid=${(sessionScope.loginuser).userid}">회원정보수정</a></div>
		      <div><a class="nav-link" href="<%= request.getContextPath() %>/member/memberWithdrawal.tea?userid=${(sessionScope.loginuser).userid}">회원탈퇴</a></div>
		  </div>
   </div>
<%-- 사이드바끝 --%> 