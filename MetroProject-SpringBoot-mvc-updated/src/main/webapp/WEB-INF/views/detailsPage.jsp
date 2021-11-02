<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
       <%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Card Details</title>
<link rel="stylesheet" href="/css/styles.css">
</head>
<body>
<div class="bg-image"></div>
<div class="bg-text">
<div class="center">
<h1>Metro System Welcomes You..</h1>
<h3 float: left;><a href="./back">GoBack</a></h3>
</div><br><br>
<div class ="center1">
<c:if test="${not empty transactions }">
<h3>Your travel details : </h3>
<table border="1">
		<tr>
			<th>From</th>
			<th>To</th>
			<th>Fare</th>
			<th>Penality</th>
		</tr>
<c:forEach items="${transactions}" var="transaction">
<tr>
				
				<td> L${transaction.station.stationId } : ${transaction.swipeInTime }</td>
				<td>L${transaction.destinationStationId } : ${transaction.swipeOutTime }</td>
				<td>${ transaction.fare}</td>
				<td>${transaction.penality}</td>
				
			</tr>

</c:forEach>
</c:if>
</div>
</div>
</body>
</html>