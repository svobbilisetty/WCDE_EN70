<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2011, 2012 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!doctype HTML>

<!-- BEGIN CompareProductsDisplay.jsp -->

<%@include file="../Common/EnvironmentSetup.jspf" %>
<%@include file="../Common/nocache.jspf" %>
<%@ taglib uri="http://commerce.ibm.com/coremetrics"  prefix="cm" %>

<html xmlns:wairole="http://www.w3.org/2005/01/wai-rdf/GUIRoleTaxonomy#"
xmlns:waistate="http://www.w3.org/2005/07/aaa" lang="${shortLocale}" xml:lang="${shortLocale}">
	<head>
	
		<title><c:out value="${storeName}"/> - <fmt:message key="CPG_PAGE_TITLE" /></title>
		
		<!--Main Stylesheet for browser -->
		<link rel="stylesheet" href="${jspStoreImgDir}${env_vfileStylesheet}" type="text/css" media="screen"/>
		<!-- Style sheet for print -->
		<link rel="stylesheet" href="${jspStoreImgDir}${env_vfileStylesheetprint}" type="text/css" media="print"/>

		<!-- Include script files -->
		<%@include file="../Common/CommonJSToInclude.jspf" %>
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
		<script type="text/javascript" src="${jsAssetsDir}javascript/Widgets/CompareProduct/CompareProduct.js"></script>

	</head>
		
	<body>

		<%-- This file includes the progressBar mark-up and success/error message display markup --%>
		<%@ include file="../Common/CommonJSPFToInclude.jspf"%>

		<!-- Begin Page -->
		<div id="page">
		
			<!-- Start Content -->
			<%@ include file="../Widgets/QuickInfo/QuickInfoPopup.jspf" %>
			<%@ include file="../Widgets/ShoppingList/ItemAddedPopup.jspf" %>

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
								
								<div class="container_full_width container_margin_8px">
									<!-- Widget Breadcrumb-->
									<div class="widget_breadcrumb_position">
										<%out.flush();%>
											<c:import url = "${env_jspStoreDir}Widgets/BreadCrumb/BreadCrumb.jsp">
												<c:param name="pageName" value="ProductComparePage"/>
											</c:import>
										<%out.flush();%>
									</div>
									<!-- Widget Breadcrumb -->
								</div>
								
								<!-- Content - Full Width Container -->
								<div class="container_full_width container_margin_5px">
									<div class="widget_product_compare_position">
										<%out.flush();%>
											<c:import url = "${env_jspStoreDir}Widgets/CompareProduct/CompareProduct.jsp" />
										<%out.flush();%>
									</div>
								</div>
								<!-- End Content - Full Width Container -->

								<!-- Start Double E-Spot Container -->
								<div class="widget_double_espot_container_position">
									<div class="widget_double_espot_container">
										<c:choose>
											<c:when test="${env_fetchMarketingDetailsOnLoad}">
												<div dojoType="wc.widget.RefreshArea" id="DoubleContentAreaESpot_Widget" controllerId="DoubleContentAreaESpot_Controller">
												</div>
											</c:when>
											<c:otherwise>
												<%out.flush();%>
												<c:import url="${env_jspStoreDir}Widgets/ESpot/ContentRecommendation/ContentRecommendation.jsp">
													<c:param name="emsName" value="CatalogBanner_Content" />
													<c:param name="numberContentPerRow" value="2" />
													<c:param name="catalogId" value="${catalogId}" />
												</c:import>
												<%out.flush();%>
											</c:otherwise>
										</c:choose>
									</div>
								</div>
								<!-- End Double E-Spot Container --->
								
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
			
			<!--Start: Contents after page load-->
			<c:if test="${env_fetchMarketingDetailsOnLoad}">
			<%out.flush();%>
				<c:import url = "${env_jspStoreDir}Widgets/PageLoadContent/PageLoadContent.jsp">
					<c:param name="doubleContentAreaESpot" value="true"/>
				</c:import>
			<%out.flush();%>
			</c:if>
			<!--End: Contents after page load-->
		</div>
	
	<flow:ifEnabled feature="Analytics"><cm:pageview/></flow:ifEnabled>
	</body>

<!-- END CompareProductsDisplay.jsp -->	
	
</html>