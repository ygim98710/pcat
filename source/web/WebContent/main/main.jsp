<%@page import="capstone.DBUtil" %>
<%@page import="java.sql.*,java.text.SimpleDateFormat, java.util.Date" %>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR" %>

<%		
		String loginID = request.getParameter("id");
		String penalty="";
		String imgSrc="";
		String joinedDate="";
		String profile="";
		float origin_wgt=0;
		float goal_wgt=0;
		float cur_wgt=0;
		float kcal=0;
	   
		Statement stmt;
		ResultSet rs;

		Connection conn=DBUtil.getMySQLConnection(); //DB connect
	    stmt = conn.createStatement();
		
	    if(stmt.execute("select * from info where _id='"+loginID+"'")) {
	    	rs = stmt.getResultSet();
	    	
	        while(rs.next()) {
	        	penalty=rs.getString("penalty");
	        	origin_wgt=rs.getFloat("origin_wgt");
	        	goal_wgt=rs.getFloat("goal_wgt");
	        	cur_wgt=rs.getFloat("cur_wgt");
	        	imgSrc=rs.getString("profile");
	        	kcal=rs.getFloat("kcal");
	        	joinedDate=rs.getString("joined");
	        	profile=rs.getString("profile");
			}
	     		    	
	    }

		DBUtil.close(conn);
		
		//d-day 계산
		SimpleDateFormat format1=new SimpleDateFormat("yyyy-MM-dd");
		
		Date today=new Date();
		Date joined=format1.parse(joinedDate);
		
		long sub= today.getTime()-joined.getTime();
		double dDay=7-(Math.floor(sub/(1000*60*60*24)))%7;
		
		String[] arr=profile.split("/");
		int n=arr.length;
		profile=arr[n-1];
		
		
%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">

<script src="file/jquery-3.5.1.min.js"></script>
<script src="file/Chart.js/Chart.min.js"></script>
<script src="file/Chart.js/samples/utils.js"></script>
<script src="file/main.js"></script>
<link href="https://cdnjs.cloudflare.com/ajax/libs/fullPage.js/2.6.6/jquery.fullPage.css" rel="stylesheet"> 

<style>
	body{ text-align:center; font-size:20px;}
    

	a{ color:black; text-decoration:none; }
	canvas {
		-moz-user-select: none;
		-webkit-user-select: none;
		-ms-user-select: none;
	}

	#top{ width:100%; height:10%; position: fixed; z-index: 50; top: 0px; left:0px;}
	#fullpage{height:90%;}
	#title{ font-size:30px; float:left;}
	#menu{   display: inline-table; float: right;}
	#menu td{ padding: 5px 10px 5px 10px; font-size:16px;}
	#profile{border-radius: 70%; width:100px; height:100px; }
	#trainList td{background-color:#bed09f; border-radius:70%; width:80px; height:80px;}

	#profileTable img:hover{-webkit-transform:scale(1.2,1.2);}
	#closeImg{width:30px; height:30px; float:right;}
	.section table{margin: 50px auto 0px auto;  border-spacing:30px;}
	.modal {
		background: white;
		padding: 24px 16px;
		border-radius: 10px;
		width: 600px;
	}
	.modal table{margin-left: auto; margin-right: auto; border-spacing:30px;}
	.modal-wrapper, .modal-wrappers {
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
	
	Chart.pluginService.register({
	      beforeDraw: function (chart) {
	        if (chart.config.options.elements.center) {
	//Get ctx from string
	        var ctx = chart.chart.ctx;
	
	//Get options from the center object in options
	        var centerConfig = chart.config.options.elements.center;
	        var fontStyle = centerConfig.fontStyle || 'Arial';
	        var txt = centerConfig.text;
	        var color = centerConfig.color || '#000';
	        var sidePadding = centerConfig.sidePadding || 20;
	        var sidePaddingCalculated = (sidePadding/100) * (chart.innerRadius * 2)
	        //Start with a base font of 30px
	        ctx.font = "30px " + fontStyle;
	
	//Get the width of the string and also the width of the element minus 10 to give it 5px side padding
	        var stringWidth = ctx.measureText(txt).width;
	        var elementWidth = (chart.innerRadius * 2) - sidePaddingCalculated;
	
	// Find out how much the font can grow in width.
	        var widthRatio = elementWidth / stringWidth;
	        var newFontSize = Math.floor(30 * widthRatio);
	        var elementHeight = (chart.innerRadius * 2);
	
	// Pick a new font size so it will not be larger than the height of label.
	        var fontSizeToUse = Math.min(newFontSize, elementHeight);
	
	//Set font settings to draw it correctly.
	        ctx.textAlign = 'center';
	        ctx.textBaseline = 'middle';
	        var centerX = ((chart.chartArea.left + chart.chartArea.right) / 2);
	        var centerY = ((chart.chartArea.top + chart.chartArea.bottom) / 2);
	        ctx.font = fontSizeToUse+"px " + fontStyle;
	        ctx.fillStyle = color;
	
	        //Draw text in center
	        ctx.fillText(txt, centerX, centerY);
				}
			}
	});


	var weekData = {
		labels: ['월', '화', '수', '목', '금', '토', '일'],
		datasets: [{backgroundColor: 'rgba(197,84,40,1)',
			data: [2,1,2.5,4,0,1.2,0]
		}]
	};
 
	var kcalData = {
		datasets: [{
			data: [<%=kcal%>,100-<%=kcal%>],
			backgroundColor: ['rgba(124,47,26,1)', 'rgba(243,195,84,0.8)',]
		}]
	};
	
	var monthData = {
		labels: ['1월', '2월', '3월', '4월', '5월', '6월', '7월','8월','9월','10월','11월','12월'],
		datasets: [{borderColor: 'rgba(124,47,26,1)', backgroundColor: 'rgba(243,195,84,1)',
			data: [30,35,20,10,15,5,25,30,50,55],
			fill: true,
		}]			
	};
	
	var trainingData = {
		type:'pie',
		labels: ['스트레칭','상체','하체','복부','허리','유산소'],
		datasets: [{
			data: [
				randomScalingFactor(),
				randomScalingFactor(),
				randomScalingFactor(),
				randomScalingFactor(),
				randomScalingFactor(),
				randomScalingFactor()
			],
			backgroundColor: [
				'rgba(197,84,40,1)',
				'rgba(124,47,26,1)',
				'rgba(195,135,83,1)',
				'rgba(236,146,28,1)',
				'rgba(117,147,97,1)',
				'rgba(243,195,84,1)'
			]
		}]
			
	};


	window.onload = function() {
		
		var ctx = document.getElementById('week-chart').getContext('2d');
		window.myMixedChart = new Chart(ctx,{
			type: 'bar',
			data: weekData,
			options: {
				responsive: false,
				title: {display: true,	text: '운동시간'},
				tooltips: {	mode: 'index', intersect: true },
				legend:{ display:false}
			}
		});

		var ctx2 = document.getElementById("kcal-chart").getContext('2d');
		window.myDoughnut = new Chart(ctx2,{
			type: 'doughnut',
			data: kcalData,
			options: {
				responsive: false,
				title: { display: true, text: '소모한 칼로리'	},
				animation: { animateScale: true, animateRotate: true},
				elements: { center: { text: <%=kcal%>+'%', sidePadding: 30 },arc: { borderWidth: 0 }}
			}
		});

		var ctx3=document.getElementById("month-chart").getContext('2d');
		window.myLine = new Chart(ctx3, {
			type:'line',
			data:monthData,
			options: { responsive: false, title: { display: true,text: '월별 운동시간'},
				legend:{ display:false }
			}
		});

		var ctx4 = document.getElementById('training-chart').getContext('2d');
		window.myPie = new Chart(ctx4, {
			type:'pie',
			data:trainingData,
			options: { responsive:false, 
				title: { display:true, text:'진행한 운동부위' },
				elements:{arc: { borderWidth: 0 }}
			}
		});
	};
	
	function editOpen(name){
		
		var modal=document.querySelector(name);
		modal.style.display="flex";
	}
	
	function editClose(name){

		var modal=document.querySelector(name);
		modal.style.display="none";
	}
	
	function imgClick(obj){
		editClose(".modal-wrappers");
		console.log(obj.src);
		var url="changeProfile.jsp?id=<%= loginID %> &src=" + obj.src;
		var rtnVal = window.open(url, "_self");
		
	}
	
	 
	function checkValid(){
		var origin=document.getElementsByName("origin_wgt")[0];
		var goal=document.getElementsByName("goal_wgt")[0];
		var cur=document.getElementsByName("cur_wgt")[0];
		var pen=document.getElementsByName("penalty")[0];
		
		console.log(origin.length);
		console.log(goal.value);
		console.log(cur.value);
		console.log(pen.value);
		
		if(origin.value==""|| goal.value==""|| cur.value=="" || pen.value==""){
			alert("모든 정보를 입력해주세요");
			return false;
		}else{
			return true;
		}
	}
		
</script>
</head>

<body>

	<div id="top">
		<div id="title" >Pcat</div>
		<div id="menu">
			<table >
				<tr><td ><a href="login.jsp">로그아웃</a></td>
				<td><a href="">내 정보</a></td>	
				<td><a href="exerciseList.jsp?id=<%=loginID%>">운동 하기</a></td></tr>
			</table>
		</div>
		
	</div>
	
	<div class="modal-wrapper" style="display:none">
		<div class="modal"><form onsubmit="return checkValid()" action="alterData.jsp?id=<%= loginID %>" method="post">
			<img id="closeImg" src="image/close.png" onclick="editClose('.modal-wrapper')">
			프로필 편집<br>
			<table>
				<tr><td>초기 몸무게: </td><td> <input type="text" name="origin_wgt" style="width:30px;" value="<%= origin_wgt %>"> kg </td></tr>
				
				<tr><td>목표 몸무게: </td><td> <input type="text" name="goal_wgt" style="width:30px;" value="<%= goal_wgt %>"> kg </td></tr>
				
				<tr><td>현재 몸무게: </td><td> <input type="text" name="cur_wgt" style="width:30px;" value="<%= cur_wgt %>"> kg </td></tr>
			
				<tr><td>벌칙: <input type="text" name="penalty" value="<%= penalty %>"></td></tr>
					
			</table>
				<input type="submit" value="수정하기" >
			</form>
		</div>
	</div>
	
	<div class="modal-wrappers" style="display:none">
		<div class="modal">
			<img id="closeImg" src="image/close.png" onclick="editClose('.modal-wrappers')">
			프로필 선택<br>
			<table id="profileTable"> 
				<tr><td><img id="profile" src="image/tomato.png" value="1" onclick="imgClick(this)"></td><td><img id="profile" src="image/watermelon.png" value="2" onclick="imgClick(this)"></td><td><img id="profile" src="image/apple.png" value="3" onclick="imgClick(this)"></td></tr>
				<tr><td><img id="profile" src="image/orange.png" value="4" onclick="imgClick(this)"></td><td><img id="profile" src="image/lemon.png" value="5" onclick="imgClick(this)"></td><td><img id="profile" src="image/kiwi.png" value="6" onclick="imgClick(this)"></td></tr>
				<tr><td><img id="profile" src="image/abo.png" value="7" onclick="imgClick(this)"></td><td><img id="profile" src="image/yaja.png" value="8" onclick="imgClick(this)"></td><td><img id="profile" src="image/user.png" value="9" onclick="imgClick(this)"></td></tr>
			</table>
		</div>
	</div>

<div id="fullpage">

	<div  class="section">
		<table style="border-spacing:70px;">
			<tr><td><img id="profile" src="image/<%=profile%>"><br><span  style="font-size:17px;"><%= loginID %>님 환영합니다!</span></td></tr>
			<tr><td> <%= penalty %> 하기까지 <span style="font-size:24px; font-weight:bold;">D-<span style="color:red;"><%= (int)dDay %></span>!!</span></td></tr>
			<tr><td><input type="button" value="프로필 변경" onclick='editOpen(".modal-wrappers")'></td></tr>
		</table>
	</div>
	
	<div class="section" style="background:rgba(243,195,84,0.5);">
		<table>
			<tr><td><hr style="width:100px;"></td><td style="font-size:25px; font-weight:bold;">출석체크</td>
			<td><hr style="width:100px;"></td></tr>
		</table>
		<table>
			<tr><td>남은 시간 :</td><td> <span style="font-size:17px; font-weight:bold;">D-<span style="color:red;"><%= (int)dDay %></span></span></td></tr>
			<tr><td>남은 칼로리: </td><td style="font-size:17px;"><%= kcal %> kcal</td></tr>
		</table>
		<table>
			<tr><td></td><td style="font-size:16px; font-weight:bold;">추천운동</td><td></td></tr>
			<tr id="trainList" style="font-size:12px;"><td>허리 </td><td>상체</td><td>허벅지</td></tr>
		</table>
	</div>

	<div class="section" style="background:#bed09f;">
		<table>
			<tr><td><hr style="width:100px;"></td><td style="font-size:25px; font-weight:bold;">내 정보</td>
			<td><hr style="width:100px;"></td></tr>
		</table>
		<table>
			<tr><td>초기 몸무게</td><td>목표 몸무게</td><td>현재 몸무게</td></tr>
			<tr style="font-size:17px;"><td><%= origin_wgt %> kg</td><td><%= goal_wgt %> kg</td><td><%= cur_wgt %> kg</td></tr>
		
		</table>
		<table>
			<tr><td>운동 실패시 나는 <span><%= penalty %></span>를 할 것이다!</td></tr>
			<tr><td><input type="button" value="수정" onclick="editOpen('.modal-wrapper')"></td></tr>
		</table>
	</div>

	<div class="section" style="background:#bed09f;">
		<table>
			<tr><td><hr style="width:100px;"></td><td style="font-size:25px; font-weight:bold;">운동 분석</td>
			<td><hr style="width:100px;"></td></tr>
		</table>
		
		<table>
			<tr><td><canvas id="week-chart" style="height:300px; width:300px;"></canvas></td>
			<td><canvas id="kcal-chart" style="height:200px; width:200px;"></canvas></td>
			<td><canvas id="month-chart" style="height:300px; width:300px;"></canvas></td>
			<td><canvas id="training-chart" style="height:250px; width:250px;"></canvas></td>
			</tr>
		</table>
	</div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/fullPage.js/2.6.6/jquery.fullPage.min.js"></script>
    
</body>
</html>