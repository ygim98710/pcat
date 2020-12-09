<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR" import="java.sql.*,java.text.SimpleDateFormat, java.util.Date"%>
<%@ page import="capstone.DBUtil" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%		
		String loginID = request.getParameter("id");
		String penalty="";
		String joinedDate="";
	   
		Statement stmt;
		ResultSet rs;

		Connection conn=DBUtil.getMySQLConnection(); //DB connect
	    stmt = conn.createStatement();
		
	    if(stmt.execute("select * from info where _id='"+loginID+"'")) {
	    	rs = stmt.getResultSet();
	    	
	        while(rs.next()) {
	        	penalty=rs.getString("penalty");
	        	joinedDate=rs.getString("joined");
			}
	     		    	
	    }

		DBUtil.close(conn);
		
		//d-day 계산
		SimpleDateFormat format1=new SimpleDateFormat("yyyy-MM-dd");
		
		Date today=new Date();
		Date joined=format1.parse(joinedDate);
		
		long sub= today.getTime()-joined.getTime();
		double dDay=7-(Math.floor(sub/(1000*60*60*24)))%7;
		
%>

<meta http-ｅquiv="Content-Type" content="text/html;charset=UTF-8">
<title> 운동화면 </title>
<link rel="stylesheet" type="text/css" href="exerciseList.css"/>
<script>
	function searchbox(){
		var data=document.getElementById("searchtext");
		var list=document.getElementsByName("list");
		var list_child=document.getElementsByName("list_child");
		if(data.value != ""){
			for(i=0; i<list_child.length; i++){
				if(data.value==list_child[i].innerHTML.replace(/(\s*)/g,"")){
					list[i].style.display="";
				}else{
					list[i].style.display="none";
				}
			}
		}
	}
	
	function search(){
		var data= document.getElementById("mySelect").value;
		var list=document.getElementsByName("list");
		var list_child=document.getElementsByName("list_child");
		if(data.value != ""){
			for(i=0; i<list_child.length; i++){
				if(data==list_child[i].innerHTML.replace(/(\s*)/g,"")){
					list[i].style.display="";
				}else{
					list[i].style.display="none";
				}
			}
		}
	}

</script>

</head>
<body>
	<div id=header> 
    	<div id="header_logo">Pcat </div>
        <div id="header_left"> D-<%=(int)dDay%> <%=penalty%></div>
        <div id="header_right"> <a href="login.jsp">로그아웃</a> &nbsp; | &nbsp; <a href="main.jsp?id=<%=loginID%>"> 내정보 </a> &nbsp; | &nbsp; <a href="">운동목록</a> </div>
	</div>
    <hr>
	<div id=main>
    	<form  id="searchbox">
        	<input type="search" id="searchtext">
            <button type="button" id="searchbutton" onclick="searchbox()"> <img src='image/search.png' id="searchimage"> </button> 
		</form>
    <div id="table">
		<table>
			<tr>
            	<th>
                	<select id="mySelect" onchange="search()">
                    	<option>스트레칭</option>
                        <option>상체</option>
						<option>하체</option>
                        <option>복부</option>
                        <option>허리</option>
                        <option>유산소</option>
					</select>
				</th>
                
                <th>제목 </th>
				<th> 운동시간 </th>
                <th> 최고정확도 </th>
                <th> 도전횟수 </th>
			</tr>
                        
            <tr name="list">    
            	<td name="list_child">스트레칭</td>
                <td> <a href="exercise.jsp?id=<%=loginID%> &value=stretch.mp4 &dDay=<%=(int)dDay%>"> 운동 전 최고의 스트레칭! 10분만 따라해도 운동효과 대박! </a></td>
                <td> 10:59 </td>
                <td> <div id=a_box> 미흡 </div> </td>
                <td> 0회 </td>
			</tr>
            <tr name="list">    
            	<td name="list_child">상체</td>
                <td> <a href="exercise.jsp?id=<%=loginID%> &value=upper.mp4 &dDay=<%=(int)dDay%>"> 상하체불균형, 상체비만 운동법 </a></td>
                <td> 20:03 </td>
                <td> <div id=a_box> 미흡 </div> </td>
                <td> 0회 </td>
			</tr>
            <tr name="list">    
            	<td name="list_child">하체</td>
				<td> <a href="exercise.jsp?id=<%=loginID%> &value=leg.mp4 &dDay=<%=(int)dDay%>"> 상하체불균형, 하체비만 운동법 </a></td>
                <td> 17:53 </td>
                <td> <div id=a_box> 미흡 </div> </td>
                <td> 3회 </td>
			</tr>
            <tr name="list">    
            	<td name="list_child">복부</td>
                <td> <a href="exercise.jsp?id=<%=loginID%> &value=stomach.mp4 &dDay=<%=(int)dDay%>"> 무조건 빠지는 아랫배 운동법(feat.내장지방, 똥배 없애기) </a></td>
                <td> 12:09 </td>
                <td> <div id=a_box> 미흡 </div> </td>
                 <td> 0회 </td>
			</tr>
            <tr name="list">    
            	<td name="list_child">허리</td>
                <td> <a href="exercise.jsp?id=<%=loginID%> &value=waist.mp4 &dDay=<%=(int)dDay%>"> 허리 얇아지는 복근+코어운동 6분 프로그램  </a></td>
                <td> 7:09 </td>
                <td> <div id=a_box> 미흡 </div> </td>
                <td> 0회 </td>
			</tr>
            <tr name="list">    
            	<td name="list_child">유산소</td>
                <td> <a href="exercise.jsp?id=<%=loginID%> &value=whole.mp4 &dDay=<%=(int)dDay%>"> 무조건 감량보장! 5분 전신 유산소운동  </a></td>
                <td> 6:25 </td>
                <td> <div id=a_box> 미흡 </div> </td>
                <td> 0회 </td>
			</tr>
		</table>
	</div>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script> 
</body>
</html>