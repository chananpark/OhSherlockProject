<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../../header.jsp"%>   
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<div class="container">

		<h2 class="col text-left" style="font-weight: bold">자주묻는질문</h2>
		<br>
		<hr style="background-color: black; height: 1.2px;">

		<div>
			<table class="table">
				<tbody>
					<tr>
						<td><input type="text" class="form-control"
							placeholder="글 제목" name="contentTitle" maxlength="40"></td>
					</tr>
					<tr>
						<td><textarea type="text" class="form-control"
								placeholder="글 내용을 작성하세요" name="contentDetail" maxlength="1024"
								style="height: 400px;"></textarea></td>
					</tr>
				</tbody>
			</table>
		</div>

		<div class="text-right" id="detail"
			style="display: block; margin-top: 15px;">
			<input type="button" class="btn-secondary" value="글쓰기" />
		</div>
	</div>
<%@ include file="../../footer.jsp"%>