
<%-- 
  *****
  * This JSP displays the store locator main page.
  *****
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/coremetrics"  prefix="cm" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ include file="../Common/EnvironmentSetup.jspf" %>

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
<!-- BEGIN StoreLocatorDisplay.jsp -->
<html xmlns="http://www.w3.org/1999/xhtml" lang="${shortLocale}" xml:lang="${shortLocale}">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title><fmt:message key="STORELOCATOR_TITLE" /></title>
	<link rel="stylesheet" href="<c:out value="${jspStoreImgDir}${env_vfileStylesheet}"/>" type="text/css"/>
	<%@ include file="../Common/CommonJSToInclude.jspf"%>
	
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Widgets/Search.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Widgets/MiniShopCartDisplay/MiniShopCartDisplay.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Widgets/Department/Department.js"/>"></script>
	<script type="text/javascript" src="${jsAssetsDir}javascript/Tealeaf/tealeafWC.js"></script>
	<c:if test="${env_Tealeaf eq 'true' && env_inPreview != 'true'}">
		<script type="text/javascript" src="${jsAssetsDir}javascript/Tealeaf/tealeaf.js"></script>
	</c:if>
</head>

<body>

<%@ include file="../Common/CommonJSPFToInclude.jspf"%>

<!-- Page Start -->
<div id="page" class="checkout">

	<c:set var="fromPage" value="StoreLocator" />
	<c:if test="${!empty WCParam.fromPage}">
		<c:set var="fromPage" value="${WCParam.fromPage}" />
	</c:if>
	<c:if test="${!empty param.fromPage}">
		<c:set var="fromPage" value="${param.fromPage}" />
	</c:if>

	<c:if test="${fromPage == 'StoreLocator'}">
		<c:set var="hasBreadCrumbTrail" value="true" scope="request"/>
		<c:set var="extensionPageWithBCF" value="true" scope="request"/>
		<fmt:message var="finalBreadcrumb" key="BREADCRUMB_STORE_LOCATOR" scope="request"/>
	</c:if>  
	<c:if test="${fromPage == 'ProductDetails'}">
		<c:set var="hasBreadCrumbTrail" value="true" scope="request"/>
		<c:set var="extensionPageWithBCF" value="true" scope="request"/>
		<fmt:message var="finalBreadcrumb" key="BREADCRUMB_CHECK_AVAILABILITY" scope="request"/>
	</c:if>

	<!-- Import Header Widget -->
	<div class="header_wrapper_position" id="headerWidget">
		<%out.flush();%>
		<c:import url = "${env_jspStoreDir}/Widgets/Header/Header.jsp" />
		<%out.flush();%>
	</div>
	<!-- Header Nav End -->  
	<div class="content_wrapper_position">
		<div class="content_wrapper">
			<div class="content_left_shadow">
				<div class="content_right_shadow">
					<div class="main_content">
						<div class="container_full_width">
							<!-- Content Start -->
							<div id="box" role="main">
								<%out.flush();%>
								<c:import url="/${sdb.jspStoreDir}/Snippets/StoreLocator/StoreLocator.jsp">
									<c:param name="storeId" value="${WCParam.storeId}"/>
									<c:param name="catalogId" value="${WCParam.catalogId}"/>
									<c:param name="langId" value="${langId}"/>
								</c:import>
								<%out.flush();%>
							</div>
							<!-- Content End -->
						</div>
					</div>
				</div>
	   		</div>
	   	</div>
	</div>

	<!-- Footer Start -->
	<div class="footer_wrapper_position">
		<%out.flush();%>
			<c:import url = "${env_jspStoreDir}/Widgets/Footer/Footer.jsp" />
		<%out.flush();%>
	</div>
	<!-- Footer End -->    
</div>

<flow:ifEnabled feature="Analytics">
	<cm:pageview/>
</flow:ifEnabled>
</body>
</html>

<!-- END StoreLocatorDisplay.jsp -->
