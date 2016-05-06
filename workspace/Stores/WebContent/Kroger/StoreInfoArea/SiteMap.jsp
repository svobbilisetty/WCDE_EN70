<!DOCTYPE HTML>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2008, 2012 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@include file="../Common/EnvironmentSetup.jspf" %>
<%@include file="../Common/nocache.jspf" %>
<%@ taglib uri="http://commerce.ibm.com/coremetrics"  prefix="cm" %>

<wcf:getData type="com.ibm.commerce.infrastructure.facade.datatypes.OnlineStoreType"
			var="onlineStoreSEO" 
			expressionBuilder="findSEOPageDefintionByPageNameAndStoreID">
		<wcf:contextData name="storeId" data="${storeId}"/>
		<wcf:param name="storeId" value="${storeId}"/>
		<wcf:param name="dataLanguageIds" value="${langId}"/>
		<wcf:param name="pageName" value="SITEMAP_PAGE"/>
		<wcf:param name="accessProfile" value="IBM_Store_SEOPageDefinition_Details"/>
</wcf:getData>

<!-- BEGIN SiteMap.jsp -->
<html lang="${shortLocale}" xml:lang="${shortLocale}">
<head>
	<%@ include file="../Common/CommonJSToInclude.jspf" %>
	
	<link rel="stylesheet" href="<c:out value="${jspStoreImgDir}${env_vfileStylesheet}"/>" type="text/css"/>
	<script type="text/javascript" src="${jsAssetsDir}javascript/Widgets/Search.js"></script>
	<script type="text/javascript" src="${jsAssetsDir}javascript/Widgets/MiniShopCartDisplay/MiniShopCartDisplay.js"></script>
	<script type="text/javascript" src="${jsAssetsDir}javascript/Widgets/Department/Department.js"></script>		
	<script type="text/javascript" src="${jsAssetsDir}javascript/Common/ShoppingActions.js"></script>	
			
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title><c:out value="${onlineStoreSEO.SEOPageDefinitions[0].title}"/></title>
	<meta name="description" content="<c:out value="${onlineStoreSEO.SEOPageDefinitions[0].metaDescription}"/>"/>
	<meta name="keyword" content="<c:out value="${onlineStoreSEO.SEOPageDefinitions[0].metaKeyword}"/>"/>
	<meta name="pageName" content="SiteMapPage"/>
</head>
<body>

<%@ include file="../Common/CommonJSPFToInclude.jspf"%>

<!-- Page Start -->
<div id="page">
	<!-- Header Nav Start -->
	<!-- Import Header Widget -->
	<div class="header_wrapper_position" id="headerWidget">
		<%out.flush();%>
		<c:import url = "${env_jspStoreDir}/Widgets/Header/Header.jsp" />
		<%out.flush();%>
	</div>
	<!-- Header Nav End -->
	
		<%out.flush();%>
		<c:import url = "${env_jspStoreDir}/Widgets/Department/Department_SiteMap.jsp" />
		<%out.flush();%>

			
		<!-- Footer Start -->
	<div class="footer_wrapper_position">
		<%out.flush();%>
			<c:import url = "${env_jspStoreDir}/Widgets/Footer/Footer.jsp" />
		<%out.flush();%>
	</div>
	<!-- Footer End -->
	
</div>
<flow:ifEnabled feature="Analytics"><cm:pageview/></flow:ifEnabled>
</body>
</html>
<!-- END SiteMap.jsp -->
