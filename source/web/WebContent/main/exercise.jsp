<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR" import="java.sql.*"%>
<%@ page import="capstone.DBUtil" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="EUC-KR">
    <title>운동화면</title>
    <link rel="stylesheet" type="text/css" href="exercise.css"/>
    
    <%		
		String loginID = request.getParameter("id");
    	String dDay=request.getParameter("dDay");
    	String value=request.getParameter("value");
		String penalty="";
		String copyright="";
	   
		Statement stmt;
		ResultSet rs;

		Connection conn=DBUtil.getMySQLConnection(); //DB connect
	    stmt = conn.createStatement();
		
	    if(stmt.execute("select * from info where _id='"+loginID+"'")) {
	    	rs = stmt.getResultSet();
	    	
	        while(rs.next()) {
	        	penalty=rs.getString("penalty");
			}
	     		    	
	    }

		if(value.contains("stretch.mp4")) {copyright="https://www.youtube.com/watch?v=yyjOhsNEqtE";}
		else if(value.contains("upper.mp4")){ copyright="https://www.youtube.com/watch?v=87uwSVdvPY8";}
		else if(value.contains("leg.mp4")) {copyright="https://www.youtube.com/watch?v=UaX5G9pHvUM";}
		else if(value.contains("waist.mp4")){ copyright="https://www.youtube.com/watch?v=7eN_xK97SHs";}
		else if(value.contains("stomach.mp4")){ copyright="https://www.youtube.com/watch?v=RWcCaSzueB4";}
		else if(value.contains("whole.mp4")) {copyright="https://www.youtube.com/watch?v=a-zbMpN3yww";}
		
		DBUtil.close(conn);

		
	%>

</head>


<body>
	<div id=header> 
            <div id="header_logo">Pcat </div>
            <div id="header_left"> D-<%=dDay%> <%=penalty %></div>
            <div id="header_right"> <a href="login.jsp">로그아웃</a> &nbsp; | &nbsp; <a href="main.jsp?id=<%=loginID%>"> 내정보 </a> &nbsp; | &nbsp; <a href="exerciseList.jsp?id=<%=loginID%>">운동목록</a> </div>
            <hr>
        </div>
	<video id="video" width="960" height="720" src="video/<%=value%>" muted controls autoplay></video>
	<video id="webcam" width="320" height="240" autoplay></video>
	<span id=accuracy> 정확도 : <a id="resulta"> 0.0 </a> % </span>
		
	<canvas id="webcam_canvas" width="320" height="240" style="display: none"></canvas>
	<canvas id="video_canvas" width="320" height="240" style="display: none"></canvas> 
	<br>영상 출처: <%=copyright%>

	<script
  src="https://code.jquery.com/jquery-3.4.1.min.js"
  integrity="sha256-CSXorXvZcTkaix6Yvo6HppcZGetbYMGWSFlBw8HfCJo="
  crossorigin="anonymous"></script>
	<script>
	if(navigator.mediaDevices && navigator.mediaDevices.getUserMedia) {
		navigator.mediaDevices.getUserMedia({ video: true }).then(function(stream) {
			var w_video = document.getElementById('webcam');
			w_video.srcObject = stream;
			w_video.play();
		
			/*w_video.style.cssText = "-moz-transform: scale(-1, 1); \
			-webkit-transform: scale(-1, 1); -o-transform: scale(-1, 1); \
			transform: scale(-1, 1); filter: FlipH;";
			*/
		});
}
	
	var w_canvas = document.getElementById('webcam_canvas');
	var w_context = w_canvas.getContext('2d');
	var w_video = document.getElementById('webcam');
	
	var v_canvas = document.getElementById('video_canvas');
	var v_context = v_canvas.getContext('2d');
	var v_video = document.getElementById('video');
	
	Alert = setInterval(function() {
		w_context.drawImage(w_video,0,0,320,240);
		var dataURL = w_canvas.toDataURL();
		var imgtype = "webcam";
		
		 $.ajax({
		url : 'Upload.jsp',
		type : 'POST',
		data:{"imgBase64":dataURL, "imgtype":imgtype},
	    contentType: "application/x-www-form-urlencoded; charset=utf-8"
	 });
		
		 v_context.drawImage(v_video,0,0,320,240);
		var dataURL = v_canvas.toDataURL();
		var imgtype = "video";
		

		 $.ajax({
		url : 'Upload.jsp',
		type : 'POST',
		data:{"imgBase64":dataURL, "imgtype":imgtype},
	    contentType: "application/x-www-form-urlencoded; charset=utf-8"
	    
	 });
		 
		 $.ajax({
			 type:"POST",                //전송방식
	         url:"accuracy.jsp",    //주소
	         success:function(args){
	        	 $("#resulta").html(args); 
	         }
	   });
		 
	}, 5000);
	

	//http://localhost:8081/Capston/WebCam/WebCamTest2.jsp
</script>
</body>
</html>