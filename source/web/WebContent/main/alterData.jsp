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
	String penalty=request.getParameter("penalty");
	String origin_wgt=request.getParameter("origin_wgt");
	String goal_wgt=request.getParameter("goal_wgt");
	String cur_wgt=request.getParameter("cur_wgt");
	
	
	Connection conn=DBUtil.getMySQLConnection();  //db 연결
	
	PreparedStatement pstmt=null;
	String sql="update info set penalty = ?, origin_wgt = ?, goal_wgt = ?, cur_wgt = ? where _id= ? ";

	pstmt=conn.prepareStatement(sql);
	pstmt.setString(1,penalty);
	pstmt.setString(2,origin_wgt);
	pstmt.setString(3,goal_wgt);
	pstmt.setString(4,cur_wgt);
	pstmt.setString(5,id);
	
	pstmt.executeUpdate();
	
	DBUtil.close(conn);
%>
<script>
	alert('정보가 변경되었습니다.');
</script>

<%
	response.sendRedirect("main.jsp?id="+id); 
%>
</head>
<body>
</body>
</html>