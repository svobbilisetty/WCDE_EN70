<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2008, 2009 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Locale"%>
<%@page import="com.ibm.icu.util.TimeZone"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%
	String timeZoneId = request.getParameter("timeZoneId");
	String localeStr = request.getParameter("locale");
	Locale locale = null;
	if (localeStr == null) {
		locale = Locale.getDefault();
	}
	else {
		String[] localeInfo = localeStr.split("_");
		if (localeInfo.length == 1) {
			locale = new Locale(localeInfo[0]);
		}
		else{
			locale = new Locale(localeInfo[0], localeInfo[1]);
		}
	}

	if (timeZoneId == null || "".equals(timeZoneId)) {
		timeZoneId = TimeZone.getDefault().getID();
	}
	TimeZone preferredTz = TimeZone.getTimeZone(timeZoneId);
	TimeZone serverTz = TimeZone.getTimeZone(TimeZone.getDefault().getID());
	String preferredTzDisplayName = preferredTz.getDisplayName(locale);
	String serverTzDisplayName = serverTz.getDisplayName(locale);
	long dateNow = new Date().getTime();

	pageContext.setAttribute("timeZoneId", timeZoneId);
	pageContext.setAttribute("displayName", preferredTzDisplayName);

	pageContext.setAttribute("serverTimeZoneId", TimeZone.getDefault().getID());
	pageContext.setAttribute("serverDisplayName", serverTzDisplayName);


%>
<values>
  <timeZoneId><wcf:cdata data="${timeZoneId}"/></timeZoneId>
  <timeZoneDisplayName><wcf:cdata data="${displayName}"/></timeZoneDisplayName>
  <serverTimeZoneId><wcf:cdata data="${serverTimeZoneId}"/></serverTimeZoneId>
  <serverTimeZoneDisplayName><wcf:cdata data="${serverDisplayName}"/></serverTimeZoneDisplayName>
</values>
