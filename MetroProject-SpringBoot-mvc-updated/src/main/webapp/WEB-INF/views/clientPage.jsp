<%@page import="com.project.bean.Station"%>
<%@page import="com.project.bean.Transaction"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
     <%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Actions</title>
<link rel="stylesheet" href="/css/styles.css">
</head>
<body>

<div class="bg-image"></div>
<div class="bg-text">
<div class="center">
<h1>Metro System Welcomes You..</h1>
<c:if test="${not empty card}">
<h3 class="h">Logged Card Number is ${card.cardId}&emsp;&emsp;&emsp;&emsp; <a href="./logout" id="logout">Logout</a></h3>
</c:if>
</div><br><br>
<div class ="center1">
<c:if test="${not empty card}">
  <ul>
  <li>
  <form action="./details" method="post">
<input type="hidden" name="cId" value="${card.cardId }">
<input type="submit" value="Card Details" class="button">
</form></li>
&emsp;&emsp;
  <li><form action="./swipe" method="post">
<input type="hidden" name="cId" value="${card.cardId }">
<input type="submit" value="SwipeIn/Out" class="button">
</form></li>
&emsp;&emsp;
<li>
<form action="./recharge" method="post">
<input type="hidden" name="cId" value="${card.cardId }">
<input type="submit" value="Recharge" class="button">
</form>

</li>
&emsp;&emsp;
  <li><form action="./history" method="post">
<input type="hidden" name="cId" value="${card.cardId }">
<input type="submit" value="History" class="button">
</form></li>
  
</ul>


<div id="ongoing">
<c:if test="${msg==0}">
<h3>Your card number is ${card.cardId }</h3>
<h3>Card Holder's name is ${card.holderName }</h3>
<h3>Available Balance is ${card.balance }</h3>
<h3>Created on ${card.creationDate }</h3>
</c:if>
<c:if test="${msg==-1}">
<form action="./rechargeAmount" method="post">
<div class="row">
    <div class="col-25">
    <label>
Enter Your Amount</label>
</div>
 <div class="col-75">
<input type="text" name="amount" placeholder="Your Amount.."><br><br>
</div>
</div>
<input type="hidden" name="cardId" value="${card.cardId }">
<input type="submit" value="Recharge" class="button1">

</form>
</c:if>
<c:if test="${msg==-2}">
<h3>Balance should be greater than 0</h3>
</c:if>
<c:if test="${msg>1}">
<h3>Final Amount after adding is ${msg }</h3>
</c:if>
<c:if test="${not empty swipeIn}">
<c:if test="${card.balance>20 }">
<h3>Select Stations to SwipeIn</h3>
<form action="/swipeIn" method="post">
<input type="hidden" name ="cId" value="${card.cardId }">
<select name="stations" id="stations">
<c:forEach items="${swipeIn}" var="station">
      <option value="${station.stationName }">${station.stationName }</option>
   </c:forEach>
  </select>
  <input type="submit" value="SwipeIn" class ="button1">
</form>
</c:if>
<c:if test="${card.balance<=20 }">
<h3>No sufficient funds found, please recharge to continue.</h3>
</c:if>
</c:if>
<c:if test="${not empty swipeOut}">
<c:if test="${card.balance>20 }">
<h3>Select Stations to SwipeOut</h3>
<form action="/swipeOut" method="post">
<input type="hidden" name ="cId" value="${card.cardId }">
<select name="stations" id="station">
<c:forEach items="${swipeOut}" var="station">
      <option value="${station.stationName }">${station.stationName }</option>
   </c:forEach>
  </select>
  <input type="submit" value="SwipeOut" class="button1">
</form>
</c:if>
<c:if test="${card.balance<=20 }">
<h3>No sufficient funds found, please recharge to continue.</h3>
</c:if>
</c:if>
<c:if test="${not empty status }">
<h3>${status }</h3>
</c:if>
<c:if test="${not empty transaction }">
<h3>Your travel details : </h3>
<h3> From L${transaction.station.stationId } : ${transaction.swipeInTime }</h3>
<h3>To L${transaction.destinationStationId } : ${transaction.swipeOutTime }</h3>
<h3>Your Total fare is ${ transaction.fare} with penality of ${transaction.penality}</h3>
<h3>You have successfully Swiped Out with card balance as ${card.balance }</h3>
</c:if>
<c:if test="${not empty negative }">
<h3>No sufficient funds found, add ${negative } more to continue.</h3>
</c:if>
</div>
<c:if test="${not empty transactions }">
<h3 id ="ongoing">Your travel details </h3>
<table border="1" id ="table1">
		<tr>
			<th>From</th>
			<th>To</th>
			<th>Fare</th>
			<th>Penality</th>
		</tr>
<c:forEach items="${transactions}" var="transaction">
<tr>
				
				<td> L${transaction.station.stationId } : ${transaction.swipeInTime }</td>
				<c:if test="${transaction.destinationStationId!=0 }">
				<td>L${transaction.destinationStationId } : ${transaction.swipeOutTime }</td>
				<td>${ transaction.fare}</td>
				<td>${transaction.penality}</td>
				</c:if>
				<c:if test="${transaction.destinationStationId==0 }">
				<td id="ongoing">Journey Ongoing</td>
				<td id="ongoing">Pending</td>
				<td id="ongoing">Pending</td>
				</c:if>
			</tr>

</c:forEach>
</table>
</c:if>
</c:if>
<c:if test="${empty card}">
<h1 id ="ongoing">404 Not Found</h1>
</c:if>
</div>
</body>
</html>