<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

    
 <style type="text/css">
      
      /* 아이디찾기 내용 전체 */
      div#idFind_box {
        width: 380px;
      }

      /* 이름, 이메일 박스랑 확인 버튼 */
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

      /* 이름, 이메일 박스 */
      div#input_idFind > input {
        border-radius: 4px;
      }

      /* 확인 버튼 */
      div#btn_idFind > input[type='button'] {
        height: 45px;
        border-radius: 90px;
        background-color: #003300;
        color: white;
        cursor: pointer;
      }
    </style>

     <div class="container">
      <form>
        <div id="idFind_box" class="d-flex flex-column m-auto">
          <div id="idFind_title">
            <h2
              style="
                text-align: center;
                font-size: 30px;
                line-height: 40px;
                font-weight: bold;
              "
            >
              FIND P/W
            </h2>
          </div>

          <div id="input_idFind" class="d-flex flex-column">
            <input type="text" name="userId" placeholder="아이디" required />
            <input type="text" name="username" placeholder="이름" required />
            <input type="text" name="email" placeholder="이메일" required />
          </div>

          <div id="btn_idFind" class="d-flex flex-column">
            <input type="button" class="btn btn-dark" value="확인" />
          </div>
        </div>
      </form>
    </div>

 