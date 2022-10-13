<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<style type="text/css">


</style>

<script type="text/javascript">

	let isOrderOK = false;  // 초기값
	// 로그인한 사용자가 해당 제품을 구매한 상태인지 구매하지 않은 상태인지 알아오는 용도.
	// isOrderOK 값이 true 이면   로그인한 사용자가 해당 제품을 구매한 상태이고,
	// isOrderOK 값이 false 이면  로그인한 사용자가 해당 제품을 구매하지 않은 상태로 할 것임.	

	$(document).ready(function(){
		
		// 상품리뷰 내용 200 글자로 제한하기
		$('textarea#content').on('keyup', function() {
	        $('#content_cnt').html("("+$(this).val().length+" / 200)");
	 
	        if($(this).val().length > 200) {
	            $(this).val($(this).val().substring(0, 200));
	            $('#content_cnt').html("(200 / 200)");
	        }
	    });	

		
		
		// **** 제품후기 쓰기(로그인하여 실제 해당 제품을 구매했을 때만 딱 1번만 작성할 수 있는 것. 제품후기를 삭제했을 경우에는 다시 작성할 수 있는 것임.) ****// 
		$("button#btnCommentOK").click(function(){
			/*
				if( ${empty sessionScope.loginuser}) {  // 로그인 하지 않은 경우
				    alert("로그인 후 상품리뷰 작성이 가능합니다.");
				    return; // 종료  => return; 을 하면 아래로 더이상 내려오지 않고 이 메소드가 종료한다.
			    }
			*/
			// if( !isOrderOK ) {}  ==> isOrderOK 자체가 true
			// 또는
			//if( isOrderOK == false ) {  // 상품을 구매하지 않은 경우
			//    alert("구매한 상품만 리뷰 작성이 가능합니다.");
			//}
			//else {  // 상품을 구매한 경우
				const review_subject = $("input[name='subject']").val().trim();      // 제목
				const review_content = $("textarea[name='content']").val().trim(); // 내용
				const review_score = $("input[name='review_score']").val();          // 평점
				
				if(review_subject == "") {  // 제품사용 내용이 없는 경우
					alert("제목을 입력해주세요.");
					return;  // 종료
				}
				
				if(review_content == "") {  // 제품사용 내용이 없는 경우
					alert("내용을 입력해주세요.");
					return;  // 종료
				}
				
				// === 보내야할 데이터를 선정하는 첫번째 방법 ===
				<%--
				const queryString = {"fk_userid":"${sessionScope.loginuser.userid}",   // ${sessionScope.loginuser.userid} 은 문자열타입이므로 꼭 "" 안에 적어줘야 한다.
					 				 "fk_pnum":"${requestScope.pvo.pnum}",             // ${requestScope.pvo.pnum} 은 int 타입이므로 "" 을 안해줘도 되고, 해줘도 된다.
					 				 "contents":$("textarea[name='contents']").val()};
				--%>
				
				// === 보내야할 데이터를 선정하는 두번째 방법 ===
				// jQuery에서 사용하는 것으로써,
            	// form태그의 선택자.serialize(); 을 해주면 form 태그내의 모든 값들을 name값을 키값으로 만들어서 보내준다. 
				const queryString = $("form[name='reviewFrm']").serialize();  // form 태그의 내용이 많을 경우 선호하는 방법이다!!
				/*
					queryString 은 아래와 같이 되어진다.
					
					{"content":$("textarea[name='content']").val(),
					 "fk_userid":$("input[name='fk_userid']").val(),
					 "fk_pnum":$("input[name='fk_pnum']").val()}
				*/
				
				$.ajax({
					url:"<%= request.getContextPath()%>/shop/reviewRegister.tea",
				    type:"POST",
				    data:queryString,
				    dataType:"JSON",
				    
				    success:function(json) {  // {"n":1} 또는 {"n":0}
				    	if(json.n == 1) {  // insert 성공시
				    		// 제품후기 등록(insert)이 성공했으므로 제품후기글을 새로이 보여줘야(select) 한다.
				    		//goReviewListView(); // 제품후기글을 보여주는 함수 호출하기
				    		alert("상품 리뷰가 등록되었습니다.");
				    	}
				    	else {  // insert 실패시(후기 중복 작성시))
				    		// 동일한 상품에 대하여 동일한 회원이 제품후기를 2번 쓰려고 경우 unique 제약에 위배됨.
				    		alert("이미 후기를 작성하셨습니다."); 
				    	}
				    	
				    	$("input[name='subject']").val("").focus();  // 상품리뷰 제목을 비우고, 마우스 커서 놓아준다. 다음 상품리뷰 작성시를 위해서 비워준다.
				    	$("textarea[name='content']").val(""); 
				    	$("input[name='review_score']").val("");
				    	
					},
				    error: function(request, status, error){
						 alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
				    }
				    
				});
				
			//}
			
		});// end of $("button#btnCommentOK").click(function(){});----------------
		
		
	});// end of $(document).ready(function(){}------------------------
			
	
	


</script>

<form name="reviewFrm"
      action="<%= request.getContextPath()%>/shop/reviewRegister.tea"   <%-- action 은 본인페이지로 보낸다. --%>
      method="post"
      enctype="multipart/form-data">
      
	<ul style="list-style-type: none">
	
    	<li style="margin: 25px 0">
    		<input type="text" name="userid" value="${sessionScope.loginuser.userid}" />  <%-- 사용후기를 적은 사용자 userid --%>
    		<input type="hidden" name="pnum" value="${requestScope.pvo.pnum}" />      <%-- 사용후기를 적은 상품번호 --%>
        	<label for="name" style="display: inline-block; width: 90px">제목<span class="text-danger">*</span></label>
            <input type="text" class="reviewData" name="subject" id="subject" size="50" placeholder="제목을 입력하세요." autocomplete="off" required />
     	</li>
     	<li style="margin: 25px 0">
        	<label for="content" style="display: inline-block; width: 90px">내용<span class="text-danger">*</span></label>
        	<textarea class="reviewData" name="content" id="content" size="50" rows="10" cols="30" placeholder="내용을 입력하세요." autocomplete="off" style="height: 200px; width: 404.8px;" required ></textarea>
     		<div id="content_cnt">(0 / 200)</div>
     	</li>
        <li style="margin: 25px 0">
        	<label for="review_radio" style="display: inline-block; width: 90px">평점<span class="text-danger">*</span></label>
        	<div class="reviewData" >
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
     	<%-- <li style="margin: 25px 0">
        	<label for="image" style="display: inline-block; width: 100px">사진 첨부</label>
        	<br>
            <input type="file" class="image" name="image" id="image" size="50"/>
     	</li>
     	--%>
	</ul>
	
	<div class="my-3">
	    <p class="text-center">
	       <button type="button" class="btn" id="btnCommentOK" style="background-color: #1E7F15; color: white;">상품 후기 등록하기</button> <%-- 후기등록 버튼을 클릭시 ajax 로 들어간다. --%>
	    </p>
  	</div>
  	
</form>    
