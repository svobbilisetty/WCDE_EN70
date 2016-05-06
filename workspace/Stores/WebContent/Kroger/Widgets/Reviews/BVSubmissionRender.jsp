<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2012 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!doctype HTML>

<!-- BEGIN BVSubmissionRender.jsp -->

<!-- Include script files -->

<%@include file="../../Common/EnvironmentSetup.jspf"%>
<%@include file="../../Common/nocache.jspf" %>
<%@include file="../../Common/ReviewsSetup.jspf" %>

<c:if test="${empty productId}">
	<c:set var="bvProductId" value="${requestScope.bvproductid[0]}">
	</c:set>
	<c:if test="${!empty bvProductId}">
		<c:set var="bvIds" value="${fn:split(requestScope.bvproductid[0], '_')}">
		</c:set>
		<c:if test="${fn:length(bvIds) > 2}" >
			<c:set var="productId" value="${bvIds[2]}">
			</c:set>
		</c:if>
	</c:if>
</c:if>

<wcf:url var="ProductDisplayURL" patternName="ProductURL" value="Product1">
	<wcf:param name="langId" value="${langId}" />
	<wcf:param name="storeId" value="${WCParam.storeId}" />
	<wcf:param name="catalogId" value="${WCParam.catalogId}" />
	<wcf:param name="productId" value="${productId}" />
	<wcf:param name="urlLangId" value="${urlLangId}" />
</wcf:url>

<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogNavigationViewType" var="catalogNavigationView_summary" expressionBuilder="getCatalogEntryViewSummaryByID">
	<wcf:param name="UniqueID" value="${productId}"/>
	<wcf:contextData name="storeId" data="${storeId}" />
</wcf:getData>

<c:if test="${empty catalogEntryDetails}" >
	<c:if test="${empty productId}">
	</c:if>
	<c:if test="${!empty productId}">	
		<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogNavigationViewType" var="catalogNavigationView" 
			expressionBuilder="getCatalogEntryViewAllByID" varShowVerb="showCatalogNavigationView" maxItems="1" recordSetStartNumber="0">
			<wcf:param name="UniqueID" value="${productId}"/>
			<wcf:contextData name="storeId" data="${storeId}" />
			<wcf:contextData name="catalogId" data="${catalogId}" />
		</wcf:getData>
	</c:if>
	<c:if test="${empty productId && !empty WCParam.partNumber}">
		<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogNavigationViewType" var="catalogNavigationView" 
			expressionBuilder="getCatalogEntryViewAllByPartnumber" varShowVerb="showCatalogNavigationView" maxItems="1" recordSetStartNumber="0">
			<wcf:param name="PartNumber" value="${WCParam.partNumber}" />
			<wcf:contextData name="storeId" data="${storeId}" />
			<wcf:contextData name="catalogId" data="${catalogId}" />
		</wcf:getData>
	</c:if>
	<c:if test="${!empty catalogNavigationView && !empty catalogNavigationView.catalogEntryView[0]}">
		<c:set var="catalogEntryDetails" value="${catalogNavigationView.catalogEntryView[0]}"/>
	</c:if>
</c:if>
<c:set var="shortDescription" value="${catalogEntryDetails.shortDescription}" />
<c:set var="pageTitle" value="${catalogNavigationView_summary.catalogEntryView[0].title}" />
<c:set var="metaDescription" value="${shortDescription}"/>
<c:set var="fullImageAltDescription" value="${catalogNavigationView_summary.catalogEntryView[0].fullImageAltDescription}" scope="request" />

<html xmlns:wairole="http://www.w3.org/2005/01/wai-rdf/GUIRoleTaxonomy#"
	xmlns:waistate="http://www.w3.org/2005/07/aaa" lang="${shortLocale}" xml:lang="${shortLocale}">

<head>

	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title><c:out value="${shortDescription}" escapeXml="false"/></title>
	<meta name="description" content="<c:out value="${metaDescription}"/>"/>
	
	<!--Main Stylesheet for browser -->
	<link rel="stylesheet" href="${jspStoreImgDir}${env_vfileStylesheet}" type="text/css" media="screen"/>
	<!-- Style sheet for print -->
	<link rel="stylesheet" href="${jspStoreImgDir}${env_vfileStylesheetprint}" type="text/css" media="print"/>
	<!--Stylesheet for Social Bazaarvoice Integration -->
	<link rel="stylesheet" href="${jspStoreImgDir}/css/social1_1.css" type="text/css" media="screen"/>
	

		<!-- Include script files -->
		<%@include file="../../Common/CommonJSToInclude.jspf" %>
		<script type="text/javascript" src="${jsAssetsDir}javascript/StoreCommonUtilities.js"></script>
		<script type="text/javascript" src="${jsAssetsDir}javascript/Widgets/Search.js"></script>
		<script type="text/javascript" src="${jsAssetsDir}javascript/CommonContextsDeclarations.js"></script>
		<script type="text/javascript" src="${jsAssetsDir}javascript/CommonControllersDeclaration.js"></script>
		<script type="text/javascript" src="${jsAssetsDir}javascript/Widgets/ShoppingList/ShoppingList.js"></script>
		<script type="text/javascript" src="${jsAssetsDir}javascript/Widgets/ShoppingList/ShoppingListServicesDeclaration.js"></script>
		<script type="text/javascript" src="${jsAssetsDir}javascript/Common/ShoppingActionsServicesDeclaration.js"></script>
		<script type="text/javascript" src="${jsAssetsDir}javascript/Common/ShoppingActions.js"></script>
		<script type="text/javascript" src="${jsAssetsDir}javascript/Widgets/MiniShopCartDisplay/MiniShopCartDisplay.js"></script>
		<script type="text/javascript" src="${jsAssetsDir}javascript/Widgets/Department/Department.js"></script>
		<script type="text/javascript" src="${jsAssetsDir}javascript/Widgets/QuickInfo/QuickInfo.js"></script>
		<script type="text/javascript" src="${jsAssetsDir}javascript/Layouts/SearchBasedNavigationDisplay.js"></script>
		<script type="text/javascript">
			dojo.addOnLoad(function() { 
				shoppingActionsServicesDeclarationJS.setCommonParameters('${langId}','${storeId}','${catalogId}');
				});
		</script>

		<script type="text/javascript" src="${reviewParameters.bvApiUrl}" >
		</script>

		<script type="text/javascript">
			var tokenBV =  "<c:out value="${bvUserToken}"/>";
			$BV.ui("submission_container", {
				 userToken: tokenBV
				}); 
		</script>
</head>

<!--   <body onload="javascript:startWork()">  -->

<body>      

		<%-- This file includes the progressBar mark-up and success/error message display markup --%>
		<%@ include file="../../Common/CommonJSPFToInclude.jspf"%>

		<!-- Begin Page -->
		<div id="page">
		
			<!-- Import Header Widget -->
			<div class="header_wrapper_position" id="headerWidget">
				<%out.flush();%>
					<c:import url = "${env_jspStoreDir}Widgets/Header/Header.jsp" />
				<%out.flush();%>
			</div>
			
			<!--Start Page Content-->
			<div class="content_wrapper_position" role="main">
				<div class="content_wrapper">
					<!--For border customization -->
					<div class="content_top">
						<div class="left_border"></div>
						<div class="middle"></div>
						<div class="right_border"></div>
					</div>
					<!-- Main Content Area -->
					<div class="content_left_shadow">
						<div class="content_right_shadow">				
							<div class="main_content">
								<!-- Start Main Content -->
								<div id="BVSubmissionContainer"></div>
								<!-- End Main Content -->
							</div>
						</div>				
					</div>

					<!--For border customization -->
					<div class="content_bottom">
						<div class="left_border"></div>
						<div class="middle"></div>
						<div class="right_border"></div>
					</div>

				</div>
			</div>
			<!--End Page Content-->
					
			<!--Start Footer Content-->
			<div class="footer_wrapper_position">
				<%out.flush();%>
					<c:import url = "${env_jspStoreDir}Widgets/Footer/Footer.jsp" />
				<%out.flush();%>
			</div>
			<!--End Footer Content-->
			
		</div>
</body>
</html>

<!-- END BVSubmissionRender.jsp -->