<%@page import="capstone.DBUtil" %>
<%@page import="java.sql.*,java.text.SimpleDateFormat, java.util.Date" %>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Insert title here</title>

</head>
<body>

<%
   request.setCharacterEncoding("utf-8");

   SimpleDateFormat format1=new SimpleDateFormat("yyyy-MM-dd");
   Date today=new Date();
   
   String id=request.getParameter("id");
   String password=request.getParameter("password");
   String phone=request.getParameter("phone");
   String email=request.getParameter("email");
   String penalty=request.getParameter("penalty");
   String profile="user.png";
   String date=format1.format(today);
   String sns="1";
   String origin_wgt="12";
   String goal_wgt="12";
   String cur_wgt="14";
   String kcal="14.2";
   
   Connection conn=DBUtil.getMySQLConnection();  //db 연결

   ResultSet rs;
   Statement stmt;
   stmt = conn.createStatement();
   
    if(stmt.execute("select _id from info where _id='"+id+"'")) {
       rs = stmt.getResultSet();
       
       if(rs.next()){ 
          %>alert('중복된 아이디입니다.');<% 
          response.sendRedirect("login.jsp");
          
        }else{
           String sql="insert into info(_id,password,phone,email,penalty,sns,joined,origin_wgt,goal_wgt,cur_wgt,profile,kcal) values(?,?,?,?,?,?,?,?,?,?,?,?)";
           PreparedStatement pstmt=conn.prepareStatement(sql);
             
           pstmt.setString(1,id);
           pstmt.setString(2,password);
           pstmt.setString(3,phone);
           pstmt.setString(4,email);
           pstmt.setString(5,penalty);
           pstmt.setString(6,sns);
           pstmt.setString(7,date);
           pstmt.setString(8,origin_wgt);
           pstmt.setString(9,goal_wgt);
           pstmt.setString(10,cur_wgt);
           pstmt.setString(11,profile);
           pstmt.setString(12,kcal);
           pstmt.executeUpdate();
             
           DBUtil.close(pstmt);
           DBUtil.close(conn);
           
           response.sendRedirect("login.jsp"); 

       }
       
       
    }
%>


</body>
</html>