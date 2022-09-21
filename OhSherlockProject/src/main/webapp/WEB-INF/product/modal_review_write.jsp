<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>


<script type="text/javascript">

	$(document).ready(function(){
		
			
			
		
	}); // end of $(document).ready(function()
			
	
	


</script>

<form name="reviewFrm">

	<ul style="list-style-type: none">
	
    	<li style="margin: 25px 0">
        	<label for="name" style="display: inline-block; width: 90px">제목<span class="text-danger">*</span></label>
            <input type="text" name="title" id="title" size="50" placeholder="제목을 입력하세요." autocomplete="off" required />
     	</li>
     	<li style="margin: 25px 0">
        	<label for="content" style="display: inline-block; width: 90px">내용<span class="text-danger">*</span></label>
            <input type="text" name="content" id="content" size="50" placeholder="내용을 입력하세요." autocomplete="off" style="height: 200px;"required />
     	</li>
        <li style="margin: 25px 0">
        	<label for="review_radio" style="display: inline-block; width: 90px">평점<span class="text-danger">*</span></label>
        	<div>
        		<%-- 별점 선택하면 리뷰 화면에는 별로 출력 : switch문 사용..? --%>
	        	<span style="width:50px;" class="mr-4">
					<input type="radio" name="review_score" id="review_radio1" value="1">
					<label for="review_radio1">1점</label>
				</span>
				<span style="width:50px;" class="mr-4">
					<input type="radio" name="review_score" id="review_radio2" value="2">
					<label for="review_radio2">2점</label>
				</span>
				<span style="width:50px;" class="mr-4">
					<input type="radio" name="review_score" id="review_radio3" value="3">
					<label for="review_radio3">3점</label>
				</span>
				<span style="width:50px;" class="mr-4">
					<input type="radio" name="review_score" id="review_radio4" value="4">
					<label for="review_radio4">4점</label>
				</span>
				<span style="width:50px;">
					<input type="radio" name="review_score" id="review_radio5" value="5" checked>
					<label for="review_radio5">5점</label>
				</span>
			</div>
     	</li>
     	<li style="margin: 25px 0">
        	<label for="photo" style="display: inline-block; width: 100px">사진 첨부</label>
        	<br>
            <input type="file" name="photo" id="photo" size="50"/>
     	</li>
	</ul>
	
	<div class="my-3">
	    <p class="text-center">
	       <button type="button" class="btn" id="btnWriteFin" style="background-color: #1E7F15; color: white;">상품 후기 등록하기</button>
	    </p>
  	</div>
	
  	
</form>    
