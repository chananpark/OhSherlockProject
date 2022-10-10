<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<script type="text/javascript">

   if (confirm("${requestScope.message}") == true){    //확인
		location.href="${requestScope.loc}"; // 페이지 이동
   } else{   //취소
		location.href = "<%= request.getContextPath()%>/shop/likeList.tea";
   }
   
   opener.location.reload(true); // 부모창(opener) 을 새로고침
   self.close();  // 나의정보수정하기 페이지 닫기
</script>    