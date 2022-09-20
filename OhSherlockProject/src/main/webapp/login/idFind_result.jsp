<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

    
 <style type="text/css">
      
      
      div#idFind_box {
        width: 380px;
      }

      
      div#input_idFind > input,
      div#btn_idFind > input {
        width: 100%;
        padding: 12px;
        border: 1px solid gray;
        margin: 5px 0;
        opacity: 0.85;
        font-size: 17px;
        line-height: 20px;
      }

      div#input_idFind > input:hover,
      div#btn_idFind > input:hover {
        opacity: 1;
      }

     
      div#input_idFind > input {
        border-radius: 4px;
      }

      
      #btn_login {
        height: 45px;
        border-radius: 90px;
        background-color: #1E7F15;
        color: white;
        cursor: pointer;
      }
      
      #btn_pwdFind {
     	 height: 45px;
        border-radius: 90px;
        background-color: #1a1a1a;
        color: white;
        border-style: none;
        cursor: pointer;
      
      }
      
      #idFind_result {
      	border: 1px solid gray;
      	border-radius: 2%;
      	font-size: 15px;
      	font-weight: bold;
      	padding: 20px;
      	margin-bottom: 10px;
      }
      
    </style>

    <div class="container">
      <form>
        <div id="idFind_box" class="d-flex flex-column m-auto">
          <div id="idFind_title">
            <h2 style=" line-height: 40px; font-weight: bold;">
              고객님 아이디 찾기가 완료 되었습니다.
            </h2>
          </div>

          <div id="idFind_result">
            아이디: ooo 입니다.
          </div>

          <div id="btn_idFind" class="d-flex flex-column">
            <input type="button" class="btn btn-dark" id="btn_login" value="로그인" />
            <input type="button" class="btn btn-light" id="btn_pwdFind" value="비밀번호찾기" />
          </div>
        </div>
      </form>
    </div>

 