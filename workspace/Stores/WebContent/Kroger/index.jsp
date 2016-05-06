<!DOCTYPE HTML>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2002, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%-- 
  *****
  * This JSP can be called directly from a URL such as http://<hostname>/<webpath>/<storedir>/index.jsp.
  *  index.jsp acquires the storeId from parameters.jspf and finds the stores default catalogId if the
  * catalogId is not provided in the URL.
  * This JSP redirects to the TopCategoriesDisplay view to display the store's home page.
  *****
--%>
<%@ page import="com.ibm.commerce.server.*" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ taglib uri="http://commerce.ibm.com/coremetrics"  prefix="cm" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<%@ include file="include/parameters.jspf" %>
<%@ include file="Common/nocache.jspf" %>

<c:if test="${empty requestScope.requestServletPath}">
	<c:redirect url="${requestScope.contextPath}/servlet${pageContext.request.servletPath}"/>
</c:if>

<%
JSPHelper jhelper = new JSPHelper(request);
String storeentID = jhelper.getParameter("storeId");
if (storeentID!= null && !storeentID.equals("")) {
	storeId = storeentID;
}
request.setAttribute("storeId", storeId);

String catalogId = jhelper.getParameter("catalogId");
request.setAttribute("catalogId", catalogId);

String deleteCartCookie = jhelper.getParameter("deleteCartCookie");
request.setAttribute("deleteCartCookie", deleteCartCookie);
%>

<wcbase:useBean id="storeDB" classname="com.ibm.commerce.common.beans.StoreDataBean">
	<% storeDB.setStoreId(storeId); %>
</wcbase:useBean>

<wcf:getData type="com.ibm.commerce.infrastructure.facade.datatypes.ConfigurationType"
	var="currentStoreDefaultLanguage"
	expressionBuilder="findByUniqueID">
	<wcf:param name="uniqueId" value="com.ibm.commerce.foundation.defaultLanguage" />
	<wcf:contextData name="storeId" data="${storeId}"/>
</wcf:getData>

<c:forEach var="additionalValue" items="${currentStoreDefaultLanguage.configurationAttribute[0].additionalValue}">
	<c:if test="${additionalValue.name == 'languageId'}">
		<c:set var="langId" value="${additionalValue.value}"/>
	</c:if>
</c:forEach>

<c:set var="langId" value="${WCParam.langId}" scope="page" />
<c:if test="${empty langId}">
	<c:set var="langId" value="${CommandContext.languageId}" scope="page" />
</c:if>

<wcf:url var="homePageUrl" patternName="HomePageURLWithLang" value="TopCategories">
    <wcf:param name="langId" value="${langId}" />
	<wcf:param name="catalogId" value="${requestScope.catalogId}"/>
	<wcf:param name="storeId" value="${requestScope.storeId}"/>
	<wcf:param name="urlLangId" value="${langId}" />
</wcf:url>

<%-- Check if deleteCartCookie param is present from store preview.  If it is, add to home page URL to clear minicart contents --%>
<c:if test="${!empty requestScope.deleteCartCookie && requestScope.deleteCartCookie}">
	<script type="text/javascript">
		document.cookie = "WC_DeleteCartCookie_${requestScope.storeId}=true;path=/";
	</script>	
</c:if>
	
<html lang="en" xml:lang="en">
	<head>
		<meta http-equiv="Refresh" content="0;URL=${homePageUrl}"/>
	</head>
	<body>
<flow:ifEnabled feature="Analytics"><cm:pageview/></flow:ifEnabled>
	</body>
</html>
