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
		
		//d-day ���
		SimpleDateFormat format1=new SimpleDateFormat("yyyy-MM-dd");
		
		Date today=new Date();
		Date joined=format1.parse(joinedDate);
		
		long sub= today.getTime()-joined.getTime();
		double dDay=7-(Math.floor(sub/(1000*60*60*24)))%7;
		
%>

<meta http-��quiv="Content-Type" content="text/html;charset=UTF-8">
<title> �ȭ�� </title>
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
        <div id="header_right"> <a href="login.jsp">�α׾ƿ�</a> &nbsp; | &nbsp; <a href="main.jsp?id=<%=loginID%>"> ������ </a> &nbsp; | &nbsp; <a href="">����</a> </div>
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
                    	<option>��Ʈ��Ī</option>
                        <option>��ü</option>
						<option>��ü</option>
                        <option>����</option>
                        <option>�㸮</option>
                        <option>�����</option>
					</select>
				</th>
                
                <th>���� </th>
				<th> ��ð� </th>
                <th> �ְ���Ȯ�� </th>
                <th> ����Ƚ�� </th>
			</tr>
                        
            <tr name="list">    
            	<td name="list_child">��Ʈ��Ī</td>
                <td> <a href="exercise.jsp?id=<%=loginID%> &value=stretch.mp4 &dDay=<%=(int)dDay%>"> � �� �ְ��� ��Ʈ��Ī! 10�и� �����ص� �ȿ�� ���! </a></td>
                <td> 10:59 </td>
                <td> <div id=a_box> ���� </div> </td>
                <td> 0ȸ </td>
			</tr>
            <tr name="list">    
            	<td name="list_child">��ü</td>
                <td> <a href="exercise.jsp?id=<%=loginID%> &value=upper.mp4 &dDay=<%=(int)dDay%>"> ����ü�ұ���, ��ü�� ��� </a></td>
                <td> 20:03 </td>
                <td> <div id=a_box> ���� </div> </td>
                <td> 0ȸ </td>
			</tr>
            <tr name="list">    
            	<td name="list_child">��ü</td>
				<td> <a href="exercise.jsp?id=<%=loginID%> &value=leg.mp4 &dDay=<%=(int)dDay%>"> ����ü�ұ���, ��ü�� ��� </a></td>
                <td> 17:53 </td>
                <td> <div id=a_box> ���� </div> </td>
                <td> 3ȸ </td>
			</tr>
            <tr name="list">    
            	<td name="list_child">����</td>
                <td> <a href="exercise.jsp?id=<%=loginID%> &value=stomach.mp4 &dDay=<%=(int)dDay%>"> ������ ������ �Ʒ��� ���(feat.��������, �˹� ���ֱ�) </a></td>
                <td> 12:09 </td>
                <td> <div id=a_box> ���� </div> </td>
                 <td> 0ȸ </td>
			</tr>
            <tr name="list">    
            	<td name="list_child">�㸮</td>
                <td> <a href="exercise.jsp?id=<%=loginID%> &value=waist.mp4 &dDay=<%=(int)dDay%>"> �㸮 ������� ����+�ھ� 6�� ���α׷�  </a></td>
                <td> 7:09 </td>
                <td> <div id=a_box> ���� </div> </td>
                <td> 0ȸ </td>
			</tr>
            <tr name="list">    
            	<td name="list_child">�����</td>
                <td> <a href="exercise.jsp?id=<%=loginID%> &value=whole.mp4 &dDay=<%=(int)dDay%>"> ������ ��������! 5�� ���� ����ҿ  </a></td>
                <td> 6:25 </td>
                <td> <div id=a_box> ���� </div> </td>
                <td> 0ȸ </td>
			</tr>
		</table>
	</div>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script> 
</body>
</html>