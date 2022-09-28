<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>    
    
<style>
	
	a, a:hover, a:link, a:visited {
		color: black;
		text-decoration: none;
	}

	.page-link {
	  color: #666666; 
	  background-color: #fff;
	  border: 1px solid #ccc; 
	}
	
	.page-item.active .page-link {
	 z-index: 1;
	 color: white;
	 border-color: #1E7F15;
	 background-color: #1E7F15; 
	 
	}
	
	.page-link:focus, .page-link:hover {
	  color: #1E7F15;
	  background-color: #fafafa; 
	  border-color: #1E7F15;
	}

	.badge {
		background-color: #1E7F15; 
		color: white; 
		font-weight: bold;
	}
	
	.btn-secondary {
		width: 80px; 
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

	button {
		border-style: none;
	}
	
</style>       
    
<script>

	$(document).ready(()=>{
		const goBackURL = "${goBackURL}";
		sessionStorage.setItem("goBackURL", goBackURL);
		// 세션스토리지에 goBackURL 저장
		
		$("#btnWriteNotice").click(()=>{
			location.href="<%=ctxPath%>/cs/noticeWrite.tea";
		});
		
		$("input#searchWord").bind("keyup",(e)=>{
		   // 검색어에서 엔터를 치면 검색함수 실행
		   if(e.keyCode == "13")
			   goSearch();
	   });
		
	   // 검색어가 있을때 입력창에 넣어주기
	   if('${requestScope.searchWord}' != "") {
		   $("select#searchType").val('${requestScope.searchType}');
		   $("input#searchWord").val('${requestScope.searchWord}');		   
	   }
	   
	});
	
	// 검색 함수
	function goSearch() {
		   const frm = document.searchFrm;
		   frm.action = "notice.tea";
		   frm.method = "GET";
		   frm.submit();
	   }
</script>
    
<div class="container">

	<div class="titleZone row">
      <h2 class="col text-left" style="font-weight:bold">공지사항</h2><br>
      <div class="col text-right">
         <span style="font-weight: bold; font-size: 20px;">02-336-8546</span><br>
         <span style="font-weight: normal; font-size: 15.5px;">평일 09:30 ~ 18:00 (점심시간 12:30 ~ 13:30)<br>주말 및 공휴일 휴무</span>
       </div>
   </div>
   <hr style="background-color: black; height: 1.2px;"><br>
   
   <form name="searchFrm">
	    <div class="text-right">
	    	<%-- 검색 구분 --%>
	    	<select id="searchType" name="searchType" class="mr-1">
				<option value="noticeSubject">제목</option>
				<option value="noticeNo">글번호</option>
			</select>
			<%-- 검색어 입력창 --%>
	    	<input type="text" style="display: none;"/>
		  	<input type="text" id="searchWord" name="searchWord" placeholder="검색어를 입력하세요"/>&nbsp;
		  	<button class="rounded" type="button" onclick="goSearch()"><i class="fas fa-search"></i></button>
	  	</div>
  	</form>
  	
		<table class="table mt-4 text-center mb-5">
		<thead class="thead-light">
			<tr>
				<th>글번호</th>
				<th>제목</th>
				<th>등록일</th>
				<th>조회수</th>
			</tr>
		</thead>
		<tbody>
			<c:if test="${not empty noticeList}">
				<c:forEach items="${noticeList}" var="notice">
					<tr>
						<td>${notice.noticeNo}</td>
						<td>
							<c:if test="${notice.fresh == true}">
								<span class="badge badge-pill">new</span>&nbsp;&nbsp;
							</c:if> 
							<a href="<%=ctxPath%>/cs/noticeDetail.tea?noticeNo=${notice.noticeNo}">${notice.noticeSubject}</a>
							</td>
						<td><fmt:formatDate pattern="yyyy.MM.dd" value="${notice.noticeDate}"/>
						</td>
						<td>${notice.noticeHit}</td>
					</tr>
				</c:forEach>
			</c:if>
			<c:if test="${empty noticeList}">
				<tr>
					<td class="pt-5" colspan="4">
					해당하는 게시글이 없습니다.
					</td>
				</tr>
				
			</c:if>

		</tbody>
	</table>
	<%-- 글쓰기 버튼은 관리자 계정에서만 보임 --%>
	<c:if test="${sessionScope.loginuser ne null and loginuser.userid eq 'admin' }">
		<div class="text-right" id="detail" style="display: block; margin-top: 50px;"> 
		  <input type="button" class="btn-secondary rounded" id="btnWriteNotice" value="글쓰기"/>
	    </div>
	</c:if>		

	<nav aria-label="Page navigation example">
		<ul class="pagination justify-content-center">${pageBar}</ul>
	</nav>
	
	
</div>

<%@ include file="../footer.jsp"%>