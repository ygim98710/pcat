<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@page import="java.io.*"%>
<%
try{
	String filePath = "C:/Users/20175/Desktop/IMAGE/ac.txt";

	FileReader fr = new FileReader(filePath); //�����бⰴü����
	BufferedReader br = new BufferedReader(fr); //���۸�����ü����

	String line = null;
	line = br.readLine();
	//System.out.println("��Ȯ�� " + line);
	out.print(line);
}
catch(Exception e){
	e.printStackTrace();
}
%>