<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 

<style>

</style>


<c:if test="${empty imgDetailList}">
	상품 상세이미지 준비중입니다.
</c:if>
<c:if test="${not empty imgDetailList}">
	<c:forEach items="${requestScope.imgDetailList}" var="img">
	
		<img src="../images/${img.imgfilename}" width="100%"/>
	</c:forEach>
</c:if>
