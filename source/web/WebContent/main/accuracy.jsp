<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@page import="java.io.*"%>
<%
try{
	String filePath = "C:/Users/20175/Desktop/IMAGE/ac.txt";

	FileReader fr = new FileReader(filePath); //파일읽기객체생성
	BufferedReader br = new BufferedReader(fr); //버퍼리더객체생성

	String line = null;
	line = br.readLine();
	//System.out.println("정확도 " + line);
	out.print(line);
}
catch(Exception e){
	e.printStackTrace();
}
%>