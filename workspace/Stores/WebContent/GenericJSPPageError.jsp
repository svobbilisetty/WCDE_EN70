<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2009, 2012 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!--  
//********************************************************************
//*-------------------------------------------------------------------
//* The sample contained herein is provided to you "AS IS".
//*
//* It is furnished by IBM as a simple example and has not been thoroughly tested
//* under all conditions.  IBM, therefore, cannot guarantee its reliability, 
//* serviceability or functionality.  
//*
//* This sample may include the names of individuals, companies, brands and products 
//* in order to illustrate concepts as completely as possible.  All of these names
//* are fictitious and any similarity to the names and addresses used by actual persons 
//* or business enterprises is entirely coincidental.
//*--------------------------------------------------------------------------------------
//*
-->

<%@ page language="java" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.datatype.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.server.ECConstants" %>
<%@ page import="com.ibm.commerce.foundation.common.util.logging.LoggingHelper"%>
<%@ page import="java.util.logging.Logger"%>
<%@ page import="java.util.logging.Level"%>
<%@ page isErrorPage="true" %>

<%
CommandContext cmdcontext = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
Locale locale = cmdcontext.getLocale();
JSPResourceBundle myResourceBundle = null;
try {
	myResourceBundle = new JSPResourceBundle(java.util.ResourceBundle.getBundle("GenericApplicationError",locale));
} catch (java.util.MissingResourceException mre) {
	myResourceBundle = new JSPResourceBundle();
}

JSPHelper jhelper = new JSPHelper(request);
jhelper.rollbackTransaction(false);

String displayMessage = null;
if (exception != null && exception.getCause() != null) {
	if (exception.getCause().toString().indexOf("categories")!=-1) {
		displayMessage = myResourceBundle.getString("genericErrSOLRNotSetupText");
	}
}
%>

<% response.setContentType("text/html;charset=UTF-8"); %>
<% response.setHeader("Pragma", "No-cache");           %>
<% response.setDateHeader("Expires", 0);               %>
<% response.setHeader("Cache-Control", "no-cache");    %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html lang="en">
<head>
	<title>
		<%= myResourceBundle.getString("title") %>
	</title>
</head>
<body>

<br/>
<h1 role="main"><%= myResourceBundle.getString("genericErrMainText") %></h1>
<br/>
<br/>

</body>
</html>

<%
final Logger LOGGER = LoggingHelper.getLogger(LoggingHelper.class);
LOGGER.logp(Level.SEVERE, this.getServletName(), "-", exception.getLocalizedMessage(), exception);

if (displayMessage != null) {
	LOGGER.logp(Level.SEVERE, this.getServletName(), "-", displayMessage);
}
%>
