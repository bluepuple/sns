<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>
</head>
<body>
<%
   String id, pw;
    id = request.getParameter("id");
    pw = request.getParameter("pw");

    if (id.equals("123@123") && pw.equals("123")) {
%>
        <h2>로그인 성공</h2>
<%
    } else {
%>
        <h2>로그인 실패</h2>
        <p>아이디 또는 비밀번호가 일치하지 않습니다. 다시 시도해 주세요.</p>
        <a href="http://localhost:8080/project1/login.html">로그인 페이지로 돌아가기</a>
<%
    }
%>
</body>
</html>
