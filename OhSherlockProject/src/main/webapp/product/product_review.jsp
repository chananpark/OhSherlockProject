<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<script type="text/javascript">

	$(document).ready(function (e) {

		// 제목 클릭 시 상품 상세 열어주는 함수(수정필요)
		$(".viewhidden").click(function () {
            status = $(".hidden").css("display"); 
            if (status == "none") {
                $(".hidden").css("display", "");
            } else {
                $(".hidden").css("display", "none");
            }
        });
	
	});
	

</script>

<style>

	#review_page a {
		text-decoration: none;
		color: black;
	}
	
	#review_page a:link, .footer a:visited {
		color: black;
	}
	
	#review_page .btnEditDel {
		border:none;
	}
	
	#review_page .vertical_bottom {
		vertical-align: bottom;
	}

</style>


<div id="review_page">
	<table class="table mt-4" style="text-align: center;"> 
		<thead class="thead-light"> 
			<tr>
				<th>번호</th>
				<th>제목</th>
				<th>작성자</th>
				<th>작성일</th>
				<th>평점</th>
			</tr>
		</thead> 
		<tbody>
			<tr>
				<td>3</td>
				<td><a href="#" onclick="return false;" class="viewhidden">프리미엄 티 컬렉션 최고입니다.</a></td><%-- return false 지우면 작동 안함. 삭제 금지 --%>
				<td>손*진</td> 
				<td>2022.09.25</td> 
				<td>★★★</td> 
			</tr>
			<tr class="hidden" style="display:none;" >
		        <td colspan="3" style="text-align: left; padding:20px 50px;" >
		        	유명한 제품이라고 해서 어머니한테 선물로 드렸더니 맛있다고 너무 좋아하셨어요. 다음에 재구매 하겠습니다 ^^
		        	유명한 제품이라고 해서 어머니한테 선물로 드렸더니 맛있다고 너무 좋아하셨어요. 다음에 재구매 하겠습니다 ^^
		        	유명한 제품이라고 해서 어머니한테 선물로 드렸더니 맛있다고 너무 좋아하셨어요. 다음에 재구매 하겠습니다 ^^
		        	유명한 제품이라고 해서 어머니한테 선물로 드렸더니 맛있다고 너무 좋아하셨어요. 다음에 재구매 하겠습니다 ^^
		        	<br><br>
		        	<img src="../images/tea_review.jpg" width=50%/>
		        </td> 
		        <td colspan="1" class="vertical_bottom"><span style="width:20%;"><input class="btnEditDel" type="button" value="수정하기" /></span></td>
			   	<td colspan="1" class="vertical_bottom"><span style="width:20%;"><input class="btnEditDel" type="button" value="삭제하기" /></span></td>
		    </tr>
			<tr>
				<td>2</td>
				<td><a href="#" onclick="return false;" class="viewhidden">맛있네용</a></td>
				<td>손*진</td> 
				<td>2021.03.25</td> 
				<td>★★★★★</td> 
			</tr>
			<tr class="hidden" style="display:none;" >
		        <td colspan="3" style="text-align: left; padding:20px 50px;" >
		        	유명한 제품이라고 해서 어머니한테 선물로 드렸더니 맛있다고 너무 좋아하셨어요. 다음에 재구매 하겠습니다 ^^
	        		<br><br>
	        		<img src="../images/tea_review.jpg" width=50% />
        		</td> 
        		<td colspan="1" class="vertical_bottom"><span style="width:20%;"><input class="btnEditDel" type="button" value="수정하기" /></span></td>
			   	<td colspan="1" class="vertical_bottom"><span style="width:20%;"><input class="btnEditDel" type="button" value="삭제하기" /></span></td>
		    </tr>
			<tr>
				<td>1</td>
				<td><a href="#" onclick="return false;" class="viewhidden">추가구매했어용</a></td>
				<td>손*진</td> 
				<td>2021.01.25</td> 
				<td>★★★★</td> 
			</tr>
			<tr class="hidden" style="display:none;" >
		        <td colspan="3" style="text-align: left; padding:20px 50px;" >
		        	유명한 제품이라고 해서 어머니한테 선물로 드렸더니 맛있다고 너무 좋아하셨어요. 다음에 재구매 하겠습니다 ^^
	        		<br><br>
	        		<img src="../images/tea_review.jpg" width=50% />
        		</td> 
        		<td colspan="1" class="vertical_bottom"><span style="width:20%;"><input class="btnEditDel" type="button" value="수정하기" /></span></td>
			   	<td colspan="1" class="vertical_bottom"><span style="width:20%;"><input class="btnEditDel" type="button" value="삭제하기" /></span></td>
		    </tr>
		</tbody>
	</table>
	
	<div class="row justify-content-end" style="margin-top:50px;">
		<span><input class="btnEditDel mr-4" type="button" value="상품후기작성" data-toggle="modal" data-target="#btnReview" data-dismiss="modal" data-backdrop="static"/></span>
		<span><input class="btnEditDel mr-4" type="button" value="전체상품 후기조회" id="btnAllReview"/></span>
	</div>

	<%-- 하단 페이징처리 --%>
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




<%-- *** 리뷰작성 모달창 *** --%>
<div class="modal fade" id="btnReview">
	<div class="modal-dialog ">
    	<div class="modal-content">
    
	      	<!-- Modal header -->
	      	<div class="modal-header">
	        	<h4 class="modal-title">상품 후기 작성</h4>
	        	<button type="button" class="close idFindClose" data-dismiss="modal">&times;</button>
	      	</div>
	      
	      	<!-- Modal body -->
	      	<div class="modal-body">
	        	<div id="reviewWrite">
	        	<%-- jsp 파일 연결을 위해서 iframe 을 사용하지 않고, 우선 include로 연결해 두었다. --%>
	        	<%--	<iframe id="iframe_reviewWrite" style="border: none; width: 100%; height: 350px;" src="<%= request.getContextPath()%>/login/idFind.up"> </iframe>---%>
             		<%@ include file="modal_review_write.jsp"%>
	        	</div>
	      	</div>
	      
	      	<!-- Modal footer -->
	      	<div class="modal-footer">
	        	<button type="button" class="btn btn-light idFindClose" data-dismiss="modal">Close</button>
	        	<%-- close나 엑스 버튼을 누르면 아이디 찾기에 입력해 놓은 값을 날려주기 
	        		 close와 엑스버튼을 한번에 잡으려고 클래스를 idFindClose 로 동일하게 부여--%>
	      	</div>
	      	
		</div>
	</div>
</div>
