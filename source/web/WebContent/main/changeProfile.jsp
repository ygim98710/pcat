<%@page import="capstone.DBUtil" %>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">

<%
	
	String id=request.getParameter("id");
	String profile=request.getParameter("src");
	
	
	Connection conn=DBUtil.getMySQLConnection();  //db 연결
	
	PreparedStatement pstmt=null;
	String sql="update info set  profile = ? where _id= ? ";

	pstmt=conn.prepareStatement(sql);
	pstmt.setString(1,profile);
	pstmt.setString(2,id);
	
	pstmt.executeUpdate();
	
	DBUtil.close(conn);
%>


<%
	response.sendRedirect("main.jsp?id="+id); 
%>
</head>
<body>
</body>
</html>