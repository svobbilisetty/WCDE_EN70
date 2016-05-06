<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
	xsi:schemaLocation="http://www.sitemaps.org/schemas/sitemap/0.9 
	http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd" 
	xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
<%--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c) Copyright IBM Corp.  2006
All Rights Reserved

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================--%>

<%-- 
  *****
  * Sitemap.jsp is used to generate all the URLs a store admin want to be indexed by Google search engine.
  * This JSP can be called by site admin directly from a URL such as
  * http://<hostname>/<webpath>/<storedir>/Sitemap.jsp?storeId=10101&catalogIds=10101,10151
  * parameters:
  * 	storeId: the storeId of the store to which the sitemap file is generated.
  *	catalogIds: list of catalog Ids that belong to this store.
  *     hostName: hostName of the production server which will host the sitemap xml file to be generated.
  *		  This parameter is required when the jsp is invoked on a staging server
  *****
--%>
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ page import="com.ibm.commerce.seo.beans.CatalogNodeListDataBean" %>
<%@ page import="com.ibm.commerce.seo.beans.CatalogNodeDataBean" %>
<%@ page import="com.ibm.commerce.datatype.TypedProperty" %>
<%@ page import="java.util.*" %>
<%@ page contentType="text/xml" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="flow.tld" prefix="flow" %>


<%--
***
* If the sitemapGenerate command is executed on a staging server, then the command need pass hostName to the jsp, where
* hostName is the serverName which will be hosting the sitemap xml file to be generated.
***
--%>
<c:choose>
	<c:when test="${not empty param.hostName}">
		<c:set var="hostName" value="${param.hostName}"/>
	</c:when>
	<c:otherwise>
		<c:set var="hostName" value="${pageContext.request.serverName}"/>
	</c:otherwise>
</c:choose>

<c:set var="path" value="http://${hostName}${pageContext.request.contextPath}/servlet/" />


<%--
***
* Retrieve parameters for deciding how many URLs to create and the beginning index for the current iteration.
***
--%>
<c:set var="numberUrlsToGenerate" value="${param.numberUrlsToGenerate}" />
<c:if test="${empty numberUrlsToGenerate}">
	<c:set var="numberUrlsToGenerate" value="50000"/>
</c:if>

<c:set var="beginIndex" value="${param.beginIndex}" />
<c:if test="${empty beginIndex}">
	<c:set var="beginIndex" value="0"/>
</c:if>

<c:set var="maxUrlsToGenerate" value="${beginIndex+numberUrlsToGenerate}" />
<c:set var="urlCounter" value="0" />
<c:set var="constructedUrlCounter" value="0" />

<%--
***
* Get storeId and create storeDB
***
--%>
<c:set var="storeId" value="${param.storeId}" /> 
<wcbase:useBean	id="storeDB" classname="com.ibm.commerce.common.beans.StoreDataBean">
	<c:set value="${storeId}" target="${storeDB}" property="storeId" />
</wcbase:useBean>

<%--
***
* The master catalog will be used if no catalogId is provided in the request
***
--%>
<c:choose>
	<c:when test="${empty param.catalogIds}">
	    	<c:set var="catalogIdsStr" value="${storeDB.masterCatalogDataBean.catalogId}" />
   	</c:when>
   	<c:otherwise>
		<c:set var="catalogIdsStr" value="${param.catalogIds}" />
    </c:otherwise>
</c:choose>

<%--
***
* Begin  generate URLs for views TopCategoriesDisplay, categoryDisplay and productDisplay for each catalogId.
***
--%>
<c:set var="delim" value="," />
<c:set var="catalogIdsArray" value="${fn:split(catalogIdsStr, delim)}" />

<c:forEach var="token" items="${catalogIdsArray}" varStatus="count">
	<c:set var="catalogId" value="${token}" />

	<%--
	***
	* For Each language supported by the store, generate URLs for view:
	* TopCategoriesDisplay
	***
	--%>
	<c:forEach var="dbLanguage" items="${storeDB.languageDataBeans}">
		<c:set var="langId" value="${dbLanguage.languageId}" />
		<c:set var="urlLangId" value="${langId}" />
	<c:if test="${urlCounter >= beginIndex && urlCounter < maxUrlsToGenerate}">

		<wcf:url var="TopCategoriesDisplayURL" patternName="HomePageURLWithLang" value="TopCategories1">
			<wcf:param name="langId" value="${langId}" />
			<wcf:param name="storeId" value="${storeId}" />
			<wcf:param name="catalogId" value="${catalogId}" />
			<wcf:param name="urlLangId" value="${urlLangId}" />
		</wcf:url>
			<url>
				<loc> <c:out value="${path}${TopCategoriesDisplayURL}" /> </loc>
			</url>

		 <c:set var="constructedUrlCounter" value="${constructedUrlCounter + 1}" />
	</c:if>
		<c:set var="urlCounter" value="${urlCounter + 1}" />
 	</c:forEach>
 	<%--
  	***
 	* End of topCategoriesDisplay
  	***
 	--%>	
	
<%--
***
* For Each language supported by the store, generate URLs for views:
* HelpContactUsView, PrivacyView. 
* Only need generate URLs with one catalogId.
***
--%>

<c:forEach var="dbLanguage" items="${storeDB.languageDataBeans}">
	<c:set var="langId" value="${dbLanguage.languageId}" />
	<c:set var="urlLangId" value="${langId}" />

	<%--
  	***
  	* begin of HelpContactUsView 
    ***
    --%>
  <c:if test="${urlCounter >= beginIndex && urlCounter < maxUrlsToGenerate}">
		<wcf:url var="HelpContactUsViewURL" patternName="HelpContactUsURL" value="Help">
			<wcf:param name="langId" value="${langId}" />
			<wcf:param name="storeId" value="${storeId}" />
			<wcf:param name="catalogId" value="${catalogId}" />
			<wcf:param name="urlLangId" value="${urlLangId}" />
		</wcf:url>
		<url> 
			<loc> <c:out value="${path}${HelpContactUsViewURL}" /> </loc> 
		</url>
		<c:set var="constructedUrlCounter" value="${constructedUrlCounter + 1}" />
	</c:if>
	<c:set var="urlCounter" value="${urlCounter + 1}" />
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
  <c:if test="${urlCounter >= beginIndex && urlCounter < maxUrlsToGenerate}">
		<wcf:url var="PrivacyViewURL" patternName="PrivacyURL" value="PrivacyPolicy">
		   	<wcf:param name="langId" value="${langId}" />
		    <wcf:param name="storeId" value="${storeId}" />
	      <wcf:param name="catalogId" value="${catalogId}" />
	      <wcf:param name="urlLangId" value="${urlLangId}" />
		</wcf:url>
		<url> 
		    <loc><c:out value="${path}${PrivacyViewURL}" /> </loc> 
		</url>
		<c:set var="constructedUrlCounter" value="${constructedUrlCounter + 1}" />
	</c:if>
	<c:set var="urlCounter" value="${urlCounter + 1}" />
	<%--
  	***
 	* End of PrivacyView
  	***
 	--%>
</c:forEach>
<%--
***
* End of for Each language supported by the store, generate URLs for views:
* HelpContactUsView, PrivacyView. 
***
--%>

<%-- search landing pages --%>

<flow:ifEnabled feature="SearchBasedNavigation">
<c:forEach var="dbLanguage" items="${storeDB.languageDataBeans}">
	<c:set var="langId" value="${dbLanguage.languageId}" />
	<c:set var="urlLangId" value="${langId}" />

	<wcf:getData type="com.ibm.commerce.search.facade.datatypes.SearchTermAssociationType[]"
		var="landingPages"	
		varShowVerb="showVerb"
		expressionBuilder="findLandingPagesByLanguageAndStorePath"
		recordSetStartNumber="0"
		recordSetReferenceId="1"
		maxItems="100">
			<wcf:contextData name="storeId" data="${storeId}" />
			<wcf:param name="dataLanguageIds" value="${langId}"/>
	</wcf:getData>
	
	<c:if test="${landingPages != null || landingPages != 'null'}">
		<c:forEach items="${landingPages}" var="curLandingPage">
		  <c:if test="${urlCounter >= beginIndex && urlCounter < maxUrlsToGenerate}">
				<wcf:url var="landingPageURL" patternName="SearchURL" value="SearchDisplay">
				  <wcf:param name="langId" value="${langId}" />                                          
				  <wcf:param name="storeId" value="${WCParam.storeId}" />
				  <wcf:param name="catalogId" value="${WCParam.catalogId}" />
				  <wcf:param name="searchTerm" value="${curLandingPage.searchTerms}" />
				  <wcf:param name="urlLangId" value="${urlLangId}" />
				</wcf:url>
				<url> 
					<loc><c:out value="${path}${landingPageURL}" /> </loc> 
				</url>
				<c:set var="constructedUrlCounter" value="${constructedUrlCounter + 1}" />
		  </c:if>
				<c:set var="urlCounter" value="${urlCounter + 1}" />
		</c:forEach>
	</c:if>
</c:forEach>

</flow:ifEnabled>

<%
	boolean urlCountExceeded = false;
	
	TypedProperty prop = (TypedProperty)request.getAttribute("RequestProperties");
	CatalogNodeListDataBean catalogTreeDB = (CatalogNodeListDataBean)prop.get("catalogTreeDB");
	String beanCatalogId = catalogTreeDB.getCatalogId();
	String pageCatalogId = (String)pageContext.getAttribute("catalogId");

	if(beanCatalogId == null || !pageCatalogId.equals(beanCatalogId)){
		catalogTreeDB.setCatalogId(pageCatalogId);
		catalogTreeDB.setIncludeProducts(true);
		DataBeanManager.activate(catalogTreeDB, request);
	}
	
	Iterator catalogIterator = catalogTreeDB.getIterator();
	while (catalogIterator.hasNext()) {
		if(urlCountExceeded){
			break;
		}
		CatalogNodeDataBean catalogTreeNode = (CatalogNodeDataBean)catalogIterator.next();
		pageContext.setAttribute("catalogTreeNode", catalogTreeNode);
	%>

		<c:set var="topCategoryId" value="${catalogTreeNode.topCategoryId}" />

		<%--
		***
		* Begin of generating URLs for all the languages for this catalog tree node
		***
   		--%>
		<c:forEach var="dbLanguage" items="${storeDB.languageDataBeans}">
			<c:set var="langId" value="${dbLanguage.languageId}" />
			<c:set var="urlLangId" value="${langId}" />
		<c:choose>
		<c:when test="${constructedUrlCounter < numberUrlsToGenerate}">
			<c:choose>
				<c:when test="${catalogTreeNode.type eq 'CategoryBean'}">
					<c:set var="categoryId"	value="${catalogTreeNode.category.categoryId}" />
					<c:set var="lastMod" value="${catalogTreeNode.category.lastUpdate}" />
					<c:choose>
						<c:when
							test="${catalogTreeNode.topCategoryId eq catalogTreeNode.category.categoryId}">
							<wcf:url var="loc" patternName="CanonicalCategoryURL" value="Category3">
								<wcf:param name="langId" value="${langId}" />
								<wcf:param name="storeId" value="${storeId}" />
								<wcf:param name="catalogId" value="${catalogId}" />
								<wcf:param name="top" value="Y" />
								<wcf:param name="categoryId" value="${categoryId}" />
								<wcf:param name="urlLangId" value="${urlLangId}" />
							</wcf:url>
						</c:when>
						<c:otherwise>
							<flow:ifDisabled feature="SearchBasedNavigation">
								<wcf:url var="loc" patternName="CategoryURL" value="Category4">
									<wcf:param name="langId" value="${langId}" />
									<wcf:param name="storeId" value="${storeId}" />
									<wcf:param name="catalogId" value="${catalogId}" />
									<wcf:param name="categoryId" value="${categoryId}" />
									<wcf:param name="top_category" value="${topCategoryId}" />
									<wcf:param name="parent_category_rn" value="${catalogTreeNode.parentId}" />
									<wcf:param name="urlLangId" value="${urlLangId}" />
								</wcf:url>
							</flow:ifDisabled>
							<flow:ifEnabled feature="SearchBasedNavigation">
								<wcf:url var="loc" patternName="SearchCategoryURL" value="SearchDisplay">
									<wcf:param name="langId" value="${langId}" />
									<wcf:param name="storeId" value="${storeId}" />
									<wcf:param name="catalogId" value="${catalogId}" />
									<wcf:param name="categoryId" value="${categoryId}" />
									<wcf:param name="sType" value="SimpleSearch" />
									<wcf:param name="urlLangId" value="${urlLangId}" />
								</wcf:url>	
							</flow:ifEnabled>
						</c:otherwise>
					</c:choose>
				</c:when>
				<c:otherwise>
					<c:set var="lastMod" value="${catalogTreeNode.lastModifiedDate}" />
					<wcf:url var="loc" patternName="ProductURLWithCategory" value="Product3">
						<wcf:param name="langId" value="${langId}" />
						<wcf:param name="storeId" value="${storeId}" />
						<wcf:param name="catalogId" value="${catalogId}" />
						<wcf:param name="productId" value="${catalogTreeNode.catalogEntryId}" />
						<wcf:param name="categoryId" value="${catalogTreeNode.parentId}" />
						<wcf:param name="urlLangId" value="${urlLangId}" />
					</wcf:url>
				</c:otherwise>
			</c:choose>
			  <url>
				<loc> <c:out value="${path}${loc}" /> </loc>
				<c:if test="${not empty lastMod}">
					<c:set var="dateLength" value="10" />
					<lastmod> <c:out value="${fn:substring(lastMod, 0, dateLength)}" /> </lastmod>
				</c:if>
			</url>
			<c:set var="constructedUrlCounter" value="${constructedUrlCounter + 1}" />
		</c:when>
		<c:otherwise>
					<%
						urlCountExceeded = true;
					%>
		</c:otherwise>
		</c:choose>
		</c:forEach>
		<%--
		***
		* End of generating views categoryDisplay and productDisplay for all the languages for this catalog tree node
		***
   		--%>

	<%
	} //end while
	%>	
	<%--
	***
	* End of generating views categoryDisplay and productDisplay for this catalogID
	***
   	--%>
    <c:remove var="catalogTreeDB" scope="page" />
<%--
***
* End of generating views categoryDisplay and productDisplay for all catalogIDs
***
--%>

</c:forEach> 

</urlset>

<%-- End - JSP File Name:  Sitemap.jsp --%>

