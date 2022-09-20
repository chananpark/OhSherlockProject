<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

    
 <style type="text/css">
      
      /* 아이디찾기 내용 전체 */
      div#pwd_box {
        width: 380px;
      }

      /* 이름, 이메일 박스랑 확인 버튼 */
      div#input_pwd > input,
      div#btn_update > input {
        width: 100%;
        padding: 12px;
        border: 1px solid gray;
        margin: 5px 0;
        opacity: 0.85;
        font-size: 17px;
        line-height: 20px;
      }

      div#input_pwd > input:hover,
      div#btn_update > input:hover {
        opacity: 1;
      }

      /* 이름, 이메일 박스 */
      div#input_pwd > input {
        border-radius: 4px;
      }

      /* 확인 버튼 */
      div#btn_update > input[type='button'] {
        height: 45px;
        border-radius: 90px;
        background-color: #1E7F15;
        color: white;
        cursor: pointer;
      }
    </style>

     <div class="container">
      <form>
        <div id="pwd_box" class="d-flex flex-column m-auto">
          <div id="idFind_title">
            <h2
              style="
                text-align: center;
                font-size: 30px;
                line-height: 40px;
                font-weight: bold;
              "
            >
              비밀번호 변경
            </h2>
          </div>

          <div id="input_pwd" class="d-flex flex-column">
            <input type="password" name="password" placeholder="새비밀번호" required />
            <input type="password" name="password2" placeholder="비밀번호 확인" required />
          </div>

          <div id="btn_update" class="d-flex flex-column">
            <input type="button" class="btn btn-dark" value="확인" />
          </div>
        </div>
      </form>
    </div>

 