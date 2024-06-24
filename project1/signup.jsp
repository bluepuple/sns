<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입 결과</title>
</head>
<body>
<%
    String username = request.getParameter("username");
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    String confirmPassword = request.getParameter("confirmPassword");

    if (password.equals(confirmPassword)) {
        // 회원 정보를 세션에 저장
        session.setAttribute("username", username);
        session.setAttribute("email", email);
        session.setAttribute("password", password);
%>
        <h2>회원가입 성공</h2>
        <p>회원 정보가 저장되었습니다.</p>
        <a href="http://localhost:8080/project1/login.jsp">로그인 페이지로 이동</a>
<%
    } else {
%>
        <h2>회원가입 실패</h2>
        <p>비밀번호가 일치하지 않습니다. 다시 시도해 주세요.</p>
        <a href="http://localhost:8080/project1/signup.html">회원가입 페이지로 돌아가기</a>
<%
    }
%>
</body>
</html>
