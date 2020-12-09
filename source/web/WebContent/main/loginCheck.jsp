<%@page import="capstone.DBUtil" %>
<%@page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Insert title here</title>

<%
	String id=request.getParameter("loginID");
	String pass=request.getParameter("loginPW");

	Statement stmt;
	ResultSet rs;
	
	Connection conn=DBUtil.getMySQLConnection(); //DB connect
	stmt = conn.createStatement();
	
	
	
    if(stmt.execute("select password from info where _id='"+id+"'")) {
    	rs = stmt.getResultSet();
    	
    	if(!rs.next()){ 
    		%> alert('아이디가 존재하지 않습니다.'); <%
    		response.sendRedirect("login.jsp");
    		
    	 }else{
    		if(pass.equals(rs.getString("password"))){
    			%>alert('로그인 되었습니다.');<%
    		 	
    			response.sendRedirect("main.jsp?id="+id);
    		}else{
	    		%>alert('비밀번호가 일치하지 않습니다.');<%
	    		response.sendRedirect("login.jsp");
    		}
    	}
    	
    	
    }

	DBUtil.close(conn);
	
	
	
%>
</head>
<body>

</body>
</html>