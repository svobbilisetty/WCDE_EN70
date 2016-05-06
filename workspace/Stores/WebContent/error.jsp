<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2006, 2010 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%> 

<%@ page language="java" %>
<%@ page import="com.ibm.commerce.ras.ECTrace"%>
<%@ page import="com.ibm.commerce.ras.ECTraceIdentifiers"%>
<%@ page import="com.ibm.commerce.ras.ECMessageLog"%>
<%@ page import="com.ibm.commerce.ras.ECMessage"%>
<%@ page import="com.ibm.commerce.exception.ExceptionHandler"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML lang="en">

<%
try {
%>





<jsp:useBean id="ErrorReport" scope="request" class="com.ibm.websphere.servlet.error.ServletErrorReport"/>

<%
int errorCode			= ErrorReport.getErrorCode();
String message			= ErrorReport.getMessage();
Throwable rootCause		= ErrorReport.getRootCause();
String targetServletName	= ErrorReport.getTargetServletName();
%>





<HEAD><TITLE>Error <c:out value="<%= errorCode %>" /></TITLE></HEAD>
<BODY>

<FONT size="+1">An error has occurred:</FONT>
<TABLE border="2" bordercolor="#98d3ec">
	<TR bgcolor="#98d3ec">
		<TH><FONT size="+1">Error Code</FONT></TH>
		<TH><FONT size="+1">Message</FONT></TH>
		<TH><FONT size="+1">Target Servlet Name</FONT></TH>
	</TR>
	<TR>
		<TD><CENTER><c:out value="<%= errorCode %>" /></CENTER></TD>
		<TD><CENTER><c:out value="<%= message %>" /></CENTER></TD>
		<TD><CENTER><c:out value="<%= targetServletName %>" /></CENTER></TD>
	</TR>
</TABLE>


<B>Root Cause: </B><c:out value="<%= (rootCause == null ? \"N/A\" : rootCause.toString()) %>" />

</BODY>

<%
} catch (Exception e) {
	ECMessageLog.out(
		ECMessage._ERR_GENERIC, 
		"error.jsp", 
		"body", 
		ExceptionHandler.convertStackTraceToString(e));
}

%>
</HTML>
