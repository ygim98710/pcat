<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
    
<%@page import="javax.imageio.ImageIO"%>
<%@page import="java.awt.image.BufferedImage"%>
<%@page import="java.io.*"%>
<%@page import="org.apache.commons.codec.binary.Base64" %>  

<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Upload</title>
</head>
<body>
<script
  src="https://code.jquery.com/jquery-3.4.1.min.js"
  integrity="sha256-CSXorXvZcTkaix6Yvo6HppcZGetbYMGWSFlBw8HfCJo="
  crossorigin="anonymous"></script>
 <script>
 
 </script>
</body>
</html>

<%
request.setCharacterEncoding("utf-8");
String base64Str = request.getParameter("imgBase64");
String imgtype = request.getParameter("imgtype");

//출처: https://micropilot.tistory.com/2516 []
//찐 출처 : https://okky.kr/article/343154
System.out.println(base64Str);
try {
			// create a buffered image
	BufferedImage image = null;
	String saveFilePath = "C:/Users/20175/Desktop/IMAGE/";
	//String saveFilePath = "../";
	
	String savename = "webcam_img";
	if (!imgtype.equals("webcam"))
		savename = "video_img";
	
	String imgbase64 = base64Str;
	
			
	String[] base64Arr = imgbase64.split(","); // image/png;base64, 이 부분 버리기 위한 작업
	byte[] imageByte = Base64.decodeBase64(base64Arr[1]); // base64 to byte array로 변경
	System.out.println("imgbase64 : "+imgbase64);
			
	ByteArrayInputStream bis = new ByteArrayInputStream(imageByte);
	image = ImageIO.read(bis);
	bis.close();

	// write the image to a file
	//savename = savename;
	
	File outputfile = new File(saveFilePath + savename + ".png");
	System.out.println("save : "+saveFilePath+savename+".png");
	ImageIO.write(image, "png", outputfile); // 파일생성
	
	
	

	} catch (IOException e) {
	
	e.printStackTrace();
	}	
		
%>