<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2009 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<?xml version="1.0" encoding="UTF-8"?>
<%@page import="java.util.Enumeration" %>
<%@page import="java.util.Locale" %>
<%@page import="java.util.ResourceBundle" %>
<%@page import="com.ibm.commerce.foundation.client.lobtools.actions.ResourceBundleHelper" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>

<%
String developmentMode = request.getParameter("developmentMode");

// 169480 - ktsang:
// to make output stream encode in UTF-8
response.setContentType("text/xml;charset=UTF-8");

if (developmentMode.equals("true")) {
	String curLocale = request.getParameter("locale");
	Locale currentLocale = new Locale(curLocale);
	String resourceBundleName = request.getParameter("baseName");
	String extResourceBundleName = request.getParameter("extensionBaseName");

	ResourceBundle resourceBundle = ResourceBundleHelper.getBundle(resourceBundleName, currentLocale);
	ResourceBundle extResourceBundle = ResourceBundleHelper.getBundle(extResourceBundleName, currentLocale);
	%>

	<values>
	<%
	String key = null;
	String value = null;
	if (resourceBundle != null) {
		Enumeration keysEnum = resourceBundle.getKeys();
		while (keysEnum.hasMoreElements()) {
			key = (String)keysEnum.nextElement();
			value = resourceBundle.getString(key);
	%>
	<<%= key %>><wcf:cdata data="<%= value %>"/></<%= key %>>
	<% }
	}
	%>
	<%
	if (extResourceBundle != null) {
		Enumeration extKeysEnum = extResourceBundle.getKeys();
		while (extKeysEnum.hasMoreElements()) {
			key = (String)extKeysEnum.nextElement();
			value = extResourceBundle.getString(key);
	%>
	<<%= key %>><wcf:cdata data="<%= value %>"/></<%= key %>>
	<% }
	}
	%>
	</values>
<%} else {
%>
	<fmt:setLocale value="${param.locale}"/>
	<fmt:setBundle basename="${param.baseName}" var="resources" />
	<%
		javax.servlet.jsp.jstl.fmt.LocalizationContext bundle = (javax.servlet.jsp.jstl.fmt.LocalizationContext) pageContext.findAttribute("resources");
		if (bundle != null && bundle.getResourceBundle() != null) {
			pageContext.setAttribute("resources_keys", bundle.getResourceBundle().getKeys());
		}
	%>
	<fmt:setBundle basename="${param.extensionBaseName}" var="extendedResources" />
	<%
		bundle = (javax.servlet.jsp.jstl.fmt.LocalizationContext) pageContext.findAttribute("extendedResources");
		if (bundle != null && bundle.getResourceBundle() != null) {
			pageContext.setAttribute("extendedResources_keys", bundle.getResourceBundle().getKeys());
		}
	%>

	<values>
	<c:forEach var="rbKey" items="${resources_keys}">
	<${rbKey}><![CDATA[<fmt:message key="${rbKey}" bundle="${resources}"/>]]></${rbKey}>
	</c:forEach>
	<c:forEach var="rbKey" items="${extendedResources_keys}">
	<${rbKey}><![CDATA[<fmt:message key="${rbKey}" bundle="${extendedResources}"/>]]></${rbKey}>
	</c:forEach>
	</values>
<% } %>