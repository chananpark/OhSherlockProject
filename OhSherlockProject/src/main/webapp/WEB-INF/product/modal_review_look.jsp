<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 


	<style>
	* {
			font-family: 'Gowun Dodum', sans-serif;
		  }
	
	/* .listView {
		width: 90px;
		margin: 15px;
		border-style: none;
		height: 30px;
		font-size: 14px;
	}
	 */
	.btn-secondary:hover {
		border: 2px none #1E7F15;
		background-color: #1E7F15;
		color: white;
	}
	
	.inquiryContent {
		border: 1px solid gray;
		border-radius: 1%;
		min-height: 150px;
		max-height: 250;
		overflow: auto;
		background-color: white;
	}
	
	#replyTbl{
		width: 100%;
	}
	
	#replyTbl thead {
		background-color: #1E7F15;
		color: white
	}
	
	td#rsubject{
		font-weight: bold;
		font-size: 20px;
	
	}
	
	</style>


	<script type="text/javascript">
	
		$(document).ready(function(){
			
				
				
			
		}); // end of $(document).ready(function()
			

	</script>
	
	

	<div class="container-fluid">

	<%-- 리뷰를 자세히보는 페이지--%>


	<div class=" text-left">
	
		<div style="font-weight: bold; font-size: 20px; padding-bottom: 10px;">${pvo.pname}</div> <br>
		

	<table id="replyTbl">
		<thead>
			<tr>
				<td class="p-2 pl-3">${rvo.rcontent}</td>
				<td class="text-right p-2 pr-3">
					<c:if test="${not empty review_look}">
						${requestScope.pvo.point} 
					</c:if>
					<c:if test="${empty ivo.irevo}">
					🍵
					</c:if>
				</td>
			</tr>
		</thead>
		<tbody class="bg-light">
			<tr>
				<td colspan='2' class="p-3">
					<c:if test="${not empty ivo.irevo}">
					 ${ivo.irevo.inquiry_reply_content}
					 </c:if>
					 <c:if test="${empty ivo.irevo}">
					 리뷰상세내용들어오기....
					 </c:if>
				</td>
			</tr>
		</tbody>
	</table>


</div> 
</div> 

