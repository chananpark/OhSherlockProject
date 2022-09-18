<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>    
    
<style>

	.page-link {
	  color: #666666; 
	  background-color: #fff;
	  border: 1px solid #ccc; 
	}
	
	.page-item.active .page-link {
	 z-index: 1;
	 color: #1E7F15;
	 border-color: #1E7F15;
	 
	}
	
	.page-link:focus, .page-link:hover {
	  color: #1E7F15;
	  background-color: #fafafa; 
	  border-color: #1E7F15;
	}

</style>       
    
<div class="container">

	<h2 style="font-weight:bold">자주묻는질문</h2><br>
		<hr style="background-color: black; height: 1.2px;"><br>

	<nav aria-label="Page navigation example" style="margin-top: 60px;">
		<ul class="pagination justify-content-center">
			<li class="page-item"><a class="page-link" href="#"
				aria-label="Previous"> <span aria-hidden="true">&laquo;</span>
			</a></li>
			<li class="page-item"><a class="page-link" href="#">1</a></li>
			<li class="page-item"><a class="page-link" href="#">2</a></li>
			<li class="page-item"><a class="page-link" href="#">3</a></li>
			<li class="page-item"><a class="page-link" href="#"
				aria-label="Next"> <span aria-hidden="true">&raquo;</span>
			</a></li>
		</ul>
	</nav>
</div>

<%@ include file="../footer.jsp"%>