<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="/css/styles.css">
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<div class="bg-image"></div>
<div class="bg-text">
<div class="center">
<h1>Metro System Welcomes You..</h1>
</div><br><br>
<div class ="center1">
<div id="ongoing">
<c:if test="${not empty card }">
<h2>A card is already logged in </h2>
<form action="./login" method="post">
	<input type="hidden" name="cId" value="${card.cardId}">
	<h2><input type="submit" value="Click here" class="button"> to go to Card.</h2>
	</form>
</c:if>
</div>
<c:if test="${empty card }">
<h2 id="ongoing">Create New Card</h2>
<form action="./create" method="post">

<input type="text" name="name" placeholder="Enter Card Holder Name"><br><br>
<input type="text" name="balance" placeholder="Enter Balance"><br><br>

<input type="submit" value="Create" class="button1">
</form>
<div id ="ongoing">
<c:if test="${not empty msg}">
	<c:if test="${msg>=1}">
	<h4>Added Successfully and your card number is ${msg}</h4>
	<form action="./login" method="post">
	<input type="hidden" name="cId" value="${msg}">
	<p><input type="submit" value="Click here" class="button"> to go to Card.</p>
	</form>
</c:if>
<c:if test="${msg==0}">
	<h4>Balance should be greater than 0</h4>
</c:if>
<c:if test="${msg==-1}">
	<h4>Not Added</h4>
</c:if>
<c:if test="${msg==-2}">
	<h4>Empty Fields Detected.</h4>
</c:if>
</c:if>
</div>
</c:if>
</div>
</body>
</html>