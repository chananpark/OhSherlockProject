<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>    

<style>
	button {
		border-style: none;
	}
	
	td:nth-child(odd) {
	  background-color: #f2f2f2;
	  font-weight: bold;
	}
		
</style>

<script type="text/javascript">

	$(document).ready(function(){
		
		
	}); // end of $(document).ready
		
</script>

<div class="container">

	<h2 class="col text-left" style="font-weight:bold">회원정보 상세조회</h2><br>
   	<hr style="background-color: black; height: 1.2px;"><br>
  
  	<h5 style="font-weight:bold">회원정보</h5>
  	<div style="overflow-x:auto;">
	  	<table class="table mt-4 prodList text-left" >
				<tbody>
					<tr>
						<td class="col-4">아이디</td>
						<td class="col-8">leess</td>
					</tr>
					<tr>
						<td class="col-4">이름</td>
						<td class="col-8">이순신</td>
					</tr>
					<tr>
						<td class="col-4">연락처</td>
						<td class="col-8">01012341234</td>
					</tr>
					<tr>
						<td class="col-4">이메일</td>
						<td class="col-8">leess@naver.com</td>
					</tr>
					<tr>
						<td class="col-4">생년월일</td>
						<td class="col-8">1997.02.01</td>
					</tr>
					
					1. 아이디
2. 이름
3. 연락처
4. 이메일
5. 생년월일
6. 예치금
7. 적립금
8. 가입일자
9. 휴면계정 여부
10. 휴면 해제
				</tbody>
			</table>
		</div>
  	
  	
  	<h5 style="font-weight:bold">구매정보</h5>

</div>

<%@ include file="../footer.jsp"%>