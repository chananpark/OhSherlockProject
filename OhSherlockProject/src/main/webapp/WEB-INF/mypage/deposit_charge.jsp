<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%
	String ctxPath = request.getContextPath();
	//    /MyMVC
%>  
    

<!-- Required meta tags -->
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

<!-- Bootstrap CSS -->
<link rel="stylesheet" type="text/css" href="<%= ctxPath%>/bootstrap-4.6.0-dist/css/bootstrap.min.css" > 

<!-- 직접 만든 CSS -->
<link rel="stylesheet" type="text/css" href="<%= ctxPath%>/css/style.css" />

<!-- Optional JavaScript -->
<script type="text/javascript" src="<%= ctxPath%>/js/jquery-3.6.0.min.js"></script>
<script type="text/javascript" src="<%= ctxPath%>/bootstrap-4.6.0-dist/js/bootstrap.bundle.min.js" ></script> 


<style type="text/css">

    span {
    	margin-right: 10px;
    }
                   
	.stylePoint {
		background-color: red; 
		color: white;
	}
                
	.purchase {
		cursor: pointer;
		color: red;
	}         
	      
   .depositbtn {
		width: 20%;
		margin-top: 50px;
		border: 2px solid #666666;
		background-color: #666666;
		color: white;
	}
	
   .depositbtn:hover {
		border: 2px solid #1E7F15;
		background-color: #1E7F15;
	    color: white;
	}
   
   
</style>

<script type="text/javascript">

	$(document).ready(function(){
		
		
		
		
		
	});// end of $(document).ready(function(){})------------------------------

</script>

<div class="container">
	<h2 style="font-weight: bold; margin-bottom: 5px;">예치금 충전</h2>
    
    <br><br>
    
	<div>
		<table class="table mt-4 text-center"> 
		    <colgroup>
	          <col />
	          <col width="400px"/>
	          <col/>
	      	</colgroup>
			<thead class="thead-light"> 
				<tr>
					<th></th>
					<th>충전금액</th>
					<th>적립예정금액</th>
				</tr>
			</thead> 
			<tbody>
				<tr>
				   <td style="text-align: right;">
				   	 <input type="radio" name="coinmoney" value="50000" />
				   </td>
				   <td>
	                 <label class="radio-inline">&nbsp;50,000원</label>
                   </td>
                   <td>
	                 <span>500</span>
	               </td>
				</tr>
				<tr>
				   <td style="text-align: right;">
				   	 <input type="radio" name="coinmoney" value="100000" />
				   </td>
				   <td>
	                 <label class="radio-inline">&nbsp;100,000원</label>
                   </td>
                   <td>
	                 <span>1,000</span>
	               </td>
				</tr>
				<tr>
				   <td style="text-align: right;">
				   	 <input type="radio" name="coinmoney" value="200000" />
				   </td>
				   <td>
	                 <label class="radio-inline">&nbsp;200,000원</label>
                   </td>
                   <td>
	                 <span>2,000</span>
	               </td>
				</tr>
				<tr>
				   <td style="text-align: right;">
				   	 <input type="radio" name="coinmoney" value="300000" />
				   </td>
				   <td>
	                 <label class="radio-inline">&nbsp;300,000원</label>
                   </td>
                   <td>
	                 <span>3,000</span>
	               </td>
				</tr>
			</tbody>
		</table>
	</div>
	
	<div>
      <table class="table table-active table-borderless" style="height: 100px;">
          <tbody class="text-center" style="font-weight: bold;">
             <tr>
			   <td style="margin-bottom: 70px; text-align: center;">
                 <span>충전금액&nbsp;&nbsp;&nbsp;</span>
                 <span>50,000원</span>
               </td>
             </tr>
             <tr>  
               <td style="margin-bottom: 70px; text-align: center;">
                 <span>적립예정금액</span>
                 <span>&nbsp;&nbsp;500p</span>
               </td>
			</tr>
          </tbody>
        </table>
    </div>
	
	
	
    <div class="text-center">
       <input type="button" class="btn depositbtn" id="purchase" colspan="3" value="예치금충전하기" />
    </div>
	
</div>