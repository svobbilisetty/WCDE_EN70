<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2011 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%--
  *****
  * This JSP displays the store's static URLs for use by the crawler.
  *****
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ include file="../Common/EnvironmentSetup.jspf" %>
<%@ include file="../Common/nocache.jspf" %>

<?xml version="1.0" encoding="UTF-8"?>
<urlset>
	<%--
  	***
  	* begin of HelpContactUsView 
    ***
    --%>
		<wcf:url var="HelpContactUsContentOnlyURL" patternName="HelpContactUsContentOnlyURL" value="Help">
			<wcf:param name="langId" value="${langId}" />
			<wcf:param name="storeId" value="${storeId}" />
			<wcf:param name="catalogId" value="${catalogId}" />
			<wcf:param name="omitHeader" value="1" />
			<wcf:param name="urlLangId" value="${urlLangId}" />
		</wcf:url>
		<wcf:url var="HelpContactUsViewURL" patternName="HelpContactUsURL" value="Help">
			<wcf:param name="langId" value="${langId}" />
			<wcf:param name="storeId" value="${storeId}" />
			<wcf:param name="catalogId" value="${catalogId}" />
			<wcf:param name="urlLangId" value="${urlLangId}" />
		</wcf:url>
		<url crawlurl="${HelpContactUsContentOnlyURL}" indexurl="${HelpContactUsViewURL}"> 
		</url>
	<%--
  	***
 	* End of HelpContactUsView
  	***
 	--%>	

	<%--
  	***
  	* begin of PrivacyView 
  	***
    --%>
    <wcf:url var="PrivacyContentOnlyURL" patternName="PrivacyContentOnlyURL" value="PrivacyPolicy">
		   	<wcf:param name="langId" value="${langId}" />
		    <wcf:param name="storeId" value="${storeId}" />
	      <wcf:param name="catalogId" value="${catalogId}" />
	      <wcf:param name="omitHeader" value="1" />
	      <wcf:param name="urlLangId" value="${urlLangId}" />
		</wcf:url>
		<wcf:url var="PrivacyViewURL" patternName="PrivacyURL" value="PrivacyPolicy">
		   	<wcf:param name="langId" value="${langId}" />
		    <wcf:param name="storeId" value="${storeId}" />
	      <wcf:param name="catalogId" value="${catalogId}" />
	      <wcf:param name="urlLangId" value="${urlLangId}" />
		</wcf:url>
		<url crawlurl="${PrivacyContentOnlyURL}" indexurl="${PrivacyViewURL}">
		</url>
	<%--
  	***
 	* End of PrivacyView
  	***
 	--%>

	<%--
  	***
  	* begin of video URL 
  	***
    --%>
    <wcf:url var="VideoContentOnlyURL" patternName="StaticContentOnlyURL" value="StaticContent">
		   	<wcf:param name="langId" value="${langId}" />
		    <wcf:param name="storeId" value="${storeId}" />
	      <wcf:param name="catalogId" value="${catalogId}" />
	      <wcf:param name="omitHeader" value="1" />
	      <wcf:param name="url" value="Video.html" />
	      <wcf:param name="urlLangId" value="${urlLangId}" />
		</wcf:url>
		<url crawlurl="${VideoContentOnlyURL}" indexurl="StaticContent/Video.html">
		</url>
	<%--
  	***
 	* End of  video URL
  	***
 	--%>

	<%--
  	***
  	* begin of manual URL 
  	***
    --%>
    <wcf:url var="ManualContentOnlyURL" patternName="StaticContentOnlyURL" value="StaticContent">
		   	<wcf:param name="langId" value="${langId}" />
		    <wcf:param name="storeId" value="${storeId}" />
	      <wcf:param name="catalogId" value="${catalogId}" />
	      <wcf:param name="omitHeader" value="1" />
	      <wcf:param name="url" value="Manual.html" />
	      <wcf:param name="urlLangId" value="${urlLangId}" />
		</wcf:url>
		<url crawlurl="${ManualContentOnlyURL}" indexurl="StaticContent/Manual.html">
		</url>
	<%--
  	***
 	* End of  manual URL
  	***
 	--%>
 	
	<%--
  	***
  	* begin of recipe URL 
  	***
    --%>
    <wcf:url var="RecipeContentOnlyURL" patternName="StaticContentOnlyURL" value="StaticContent">
		   	<wcf:param name="langId" value="${langId}" />
		    <wcf:param name="storeId" value="${storeId}" />
	      <wcf:param name="catalogId" value="${catalogId}" />
	      <wcf:param name="omitHeader" value="1" />
	      <wcf:param name="url" value="Recipe.html" />
	      <wcf:param name="urlLangId" value="${urlLangId}" />
		</wcf:url>
		<url crawlurl="${RecipeContentOnlyURL}" indexurl="StaticContent/Recipe.html">
		</url>
	<%--
  	***
 	* End of  video URL
  	***
 	--%>
 	
</urlset>
