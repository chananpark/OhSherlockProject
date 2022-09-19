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

.btn-withdrawal {
		width: 85px; 
		margin: 15px; 
		border-style: none; 
		height: 33px;
	}
	
.btn-withdrawal:hover {
	border: 2px none #1E7F15;
	background-color: #1E7F15;
    color: white;
}

.tbl_drop td {
	padding: 0.75rem; 
	vertical-align: top;
}
	

</style>

<div class="container mypage">
	<h2 style="font-weight: bold">회원탈퇴</h2><br>
      <hr style="background-color: black; height: 1.2px;">
	
	<div>
		회원 탈퇴(이용약관 동의 철회)시 아래 내용을 확인해주세요.
	</div>
	
	<br><br>
	
	<div >
		<table class="tbl_drop" style="border: 1px solid #444444;"> 
			<tbody>
				<tr>
					<td>• 이용약관 동의 철회 시 고객님께서 보유하셨던 쿠폰은 모두 삭제되며, 재가입 시 복원이 불가능합니다.</td>
				</tr>
				
				<tr>
					<td>• 이용약관 동의 철회 시 거래 정보 관리를 위해서 회원ID, 상품정보, 거래내역 등의 기본정보는 5년간 보관됩니다.</td>
				</tr>
				
				<tr>
					<td>• 이용약관 동의를 철회한 후에라도 해당 약관에 다시 동의하시면 서비스를 이용할 수 있습니다.</td>
				</tr>
				
				<tr>
					<td>• 진행 중인 전자상거래 이용내역(결제/배송/교환/반품 중인 상태)이 있거나 고객상담 및 이용하신 서비스가 완료되지    않은 경우 서비스 철회 하실 수 없습니다. </td>
				</tr>
				
			</tbody>
		</table>
	</div>
	
    <br><br>
    
    <div class="text-center" id="withdrawal" style="display: block;"> 
		    OOOO 회원 탈퇴(이용약관 동의 철회)를 하시겠습니까?<br>
			  <input type="button" class="btn-withdrawal" value="탈퇴하기" />
    </div>
	
 </div>
 <%@ include file="../footer.jsp"%>