<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"  import="java.sql.*"%>
<%@page import="capstone.DBUtil" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">


<style>
   a{ color:black; text-decoration:none; }
   #top{ width:100%; height:40px;}
   #title{float:left; font-size:30px;}
   #closeImg{width:30px; height:30px; float:right;}
   #menu{ float:right;}
   #menu td{  padding: 5px 10px 5px 10px;}
   #mid{
      position:absolute;
      z-index:1;
      width:100%; 
      height:100%;
      text-align:center;  
      margin-top:100px;
   }
   #mid hr {width:500px;}
   #mid table {margin: 60px auto 20px auto; border-spacing:20px;}
   .modal {
      background: rgba(153, 171, 159, 1);
      padding: 24px 16px;
      border-radius: 10px;
      width: 600px;
      text-align: center;
   }
   .modal table{margin-left: auto; margin-right: auto; border-spacing:30px;}
   .modal-wrapper {
      position: fixed;
      z-index: 100;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background: rgba(0, 0, 0, 0.3);
      display: flex;
      align-items: center;
      text-align: center;
      justify-content: center;
   }
</style>

<script>

   
   function signIn(){
      var modal=document.querySelector(".modal-wrapper");
      modal.style.display="flex";
   }
   
   function signInDone(){
      var modal=document.querySelector(".modal-wrapper");
      modal.style.display="none";
   }

   function validate(){
      var idCheck= /^[a-zA-Z0-9]{7,16}$/;
      var passCheck=/^[a-zA-Z0-9]{10,20}$/;
      var phoneCheck=/^[0-9]+$/;
      var emailCheck=/^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i;

      var id=document.getElementsByName("id")[0];
      var pw=document.getElementsByName("password")[0];
      var phone=document.getElementsByName("phone")[0];
      var email=document.getElementsByName("email")[0];
      var penalty=document.getElementsByName("penalty")[0];
      
      if(!check(idCheck,id,"아이디는 7~16자의 영문 대소문자,숫자로 입력")) return false;
      if(!check(passCheck,pw,"비밀번호는 10~20자의 영문 대소문자,숫자로 입력")) return false;
      if(join.password.value != join.passwordCheck.value){
         alert('비밀번호가 다릅니다. 다시 입력해 주세요');
         join.passwordCheck.value="";
         join.passwordCheck.focus();
         return false;
      }
      if(!check(phoneCheck,phone,"전화번호 입력 형식이 다릅니다")) return false;
   
      if(email.value==""){
         alert('이메일을 입력해주세요');
         email.focus();
         return false;
      }
      if(!check(emailCheck,email,"이메일 형식이 올바르지 않습니다")) return false;
      if(penalty.value.length<5){
         alert('벌칙은 최소 5자 이상 써주세요');
         return false;
      }
      
      alert('회원가입이 완료되었습니다.');
   }

   function check(re,obj,msg){
      if(re.test(obj.value)){
         return true;
      }
      alert(msg);
      obj.value="";
      obj.focus();
   }
   
   
   
</script>

</head>
<body>

   <div id="top">
      <div id="title">Pcat</div>
      <div id="menu">
         <table>
            <tr><td><a href="">로그인</a></td>
            <td><a href="#" onclick="alert('로그인 후 사용 가능합니다.');">내 정보</a></td>
            <td><a href="#" onclick="alert('로그인 후 사용 가능합니다.');">운동 하기</a></td></tr>
         </table>
      </div>
   </div>

   <div id="mid">
      <span style="font-size:30px;">로그인</span><hr>
      <form action="loginCheck.jsp" method="post">
         <table>
            <tr><td>아이디: </td>
            <td><input type="text" name="loginID"></td></tr>
            <tr><td>비밀번호: </td>
            <td><input type="password" name="loginPW"></td></tr>
         </table>
         <input type="submit" value="로그인">
         <input type="button" value="회원가입" onclick="signIn()">
      </form>
   </div>

   <div class="modal-wrapper" style="display:none">
      <div class="modal">
      <img id="closeImg" src="image/close.png" onclick="signInDone()">
      <span style="font-weight:bold; font-size:20px;">회원가입</span><hr>
      <form name="join" onsubmit="return validate()" action="addData.jsp" method="post"><table>
         <tr><td>아이디: </td>
         <td><input type="text" name="id" placeholder="최소 7자, 최대 16자" ></td></tr>
         <tr><td>비밀번호: </td>
         <td><input type="password" name="password" placeholder="최소 10자, 최대 20자"></td></tr>
         <tr><td>비밀번호 확인: </td>
         <td><input type="password" name="passwordCheck" ></td></tr>
         <tr><td>전화번호: </td>
         <td><input type="tel" name="phone" placeholder="ex) 01012341234"></td></tr>
         <tr><td>이메일: </td>
         <td><input type="email" name="email" placeholder="ex) mail@naver.com"></td></tr>
         <tr><td>운동 실패시: </td>
         <td><textarea rows="3" cols="23" name="penalty"  placeholder="수행할 벌칙을 적어주세요!(최소 5자 이상 )" style="resize:none;"></textarea></td></tr>
         </table>
         
         <input type="checkbox" name="checkSend">카톡 및 이메일 수신을 허용합니다.<br><br>
         <input type="submit" value="확인" >
      </form>
      </div>
   </div>


</body>
</html>