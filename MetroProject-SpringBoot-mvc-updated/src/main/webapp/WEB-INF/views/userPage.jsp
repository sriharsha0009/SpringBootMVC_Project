<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="/css/styles.css">
<meta charset="ISO-8859-1">
<title>UserPage</title>
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
<form action="./login" method="post">
<div class="row">
    <div class="col-25">
   
</div>
 <div class="col-75">
<input type="text" name="cId" placeholder="Your Card Number.."><br><br>
</div>
</div>
<input type="submit" value="Login" class="button1">

</form>
</c:if>
<c:if test="${not empty msg}">
<c:if test="${msg==-1}">
<h3 id="ongoing">Card Not Found!</h3>
</c:if>
</c:if>
</div>
</div>
</body>
</html>