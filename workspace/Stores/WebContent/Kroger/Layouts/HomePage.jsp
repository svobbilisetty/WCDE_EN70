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

<!-- BEGIN HomePage.jsp -->

<%-- 
  *****
  * This JSP diplay the product details given a productId or partNumber. This page imports the following components
  * Header Component - Display header links, department widget, mini shop-cart widget and Search widget
  * Product Image Component - Display the product image
  * Product Description Component - Displays product short description, attributes, inventory component, price component etc.,
  * Merchandising Association Component
  * E-spots for Recently Viewed and Recommendations
  * Product TAB component
  * Footer Component - Display footer links
  *****
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
		<wcf:param name="pageName" value="HOME_PAGE"/>
		<wcf:param name="accessProfile" value="IBM_Store_SEOPageDefinition_Details"/>
</wcf:getData>

<c:set var="pageTitle" value="${onlineStoreSEO.SEOPageDefinitions[0].title}" />
<c:set var="metaDescription" value="${onlineStoreSEO.SEOPageDefinitions[0].metaDescription}" />
<c:set var="metaKeyword" value="${onlineStoreSEO.SEOPageDefinitions[0].metaKeyword}" />
<c:set var="fullImageAltDescription" value="${onlineStoreSEO.SEOPageDefinitions[0].fullImageAltDescription}" scope="request" />

<html xmlns:wairole="http://www.w3.org/2005/01/wai-rdf/GUIRoleTaxonomy#"
<flow:ifEnabled feature="FacebookIntegration">
	<%-- Facebook requires this to work in IE browsers --%>
	xmlns:fb="http://www.facebook.com/2008/fbml" 
	xmlns:og="http://opengraphprotocol.org/schema/"
</flow:ifEnabled>
xmlns:waistate="http://www.w3.org/2005/07/aaa" lang="${shortLocale}" xml:lang="${shortLocale}">
	<head>
	
		<title><c:out value="${pageTitle}"/></title>
		<meta name="description" content="<c:out value="${metaDescription}"/>"/>
		<meta name="keyword" content="<c:out value="${metaKeyword}"/>"/>
	    <link rel="canonical" href="<c:out value="${env_TopCategoriesDisplayURL}"/>" />
		
		<!--Main Stylesheet for browser -->
		<link rel="stylesheet" href="${jspStoreImgDir}${env_vfileStylesheet}" type="text/css" media="screen"/>
		<!-- Style sheet for print -->
		<link rel="stylesheet" href="${jspStoreImgDir}${env_vfileStylesheetprint}" type="text/css" media="print"/>
		
		<!-- Include script files -->
		<%@include file="../Common/CommonJSToInclude.jspf" %>
		<%@include file="HomePageEx.jspf" %>
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
		<script type="text/javascript">
			dojo.addOnLoad(function() { 
				shoppingActionsServicesDeclarationJS.setCommonParameters('${langId}','${storeId}','${catalogId}');
				});
		</script>
		
		<flow:ifEnabled feature="FacebookIntegration">
			<%@include file="../Common/JSTLEnvironmentSetupExtForFacebook.jspf" %>
			
			<%--Facebook Open Graph tags that are required  --%>
			<meta property="og:title" content="<c:out value="${pageTitle}"/>" /> 			
			<meta property="og:image" content="<c:out value="${schemeToUse}://${request.serverName}${portUsed}${jspStoreImgDir}images/logo.png"/>" />
			<meta property="og:url" content="<c:out value="${env_TopCategoriesDisplayURL}"/>"/>
			<meta property="og:type" content="website"/>
			<meta property="fb:app_id" name="fb_app_id" content="<c:out value="${facebookAppId}"/>"/>
			<meta property="og:description" content="${onlineStoreSEO.SEOPageDefinitions[0].metaDescription}" />
		</flow:ifEnabled>

	</head>
		
	<body>

		<%-- This file includes the progressBar mark-up and success/error message display markup --%>
		<%@ include file="../Common/CommonJSPFToInclude.jspf"%>
		<%@ include file="../Widgets/QuickInfo/QuickInfoPopup.jspf" %>
		<%@ include file="../Widgets/ShoppingList/ItemAddedPopup.jspf" %>
		
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
								
								<!-- Content - Full Width Container -->
								<div class="container_full_width container_margin_5px">
									
									<div class="widget_home_hero_image_position">
										<div class="widget_home_hero_image" role="region" aria-labelledby="mainAdRibbonRegion" aria-describedby="mainAdRibbonRegionDescription">
											<span class="spanacce" id="mainAdRibbonRegion"><fmt:message key='ACCE_ES_RIBBON_REGION'/></span>
											<span class="spanacce" id="mainAdRibbonRegionDescription"><fmt:message key='ACCE_ES_RIBBON_DESCRIPTION'/></span>
										
											<c:choose>
												<c:when test="${env_fetchMarketingDetailsOnLoad}">
													<div dojoType="wc.widget.RefreshArea" id="HomeHeroESpot_Widget" controllerId="HomeHeroESpot_Controller">
													</div>
												</c:when>
												<c:otherwise>
													<%out.flush();%>
													<c:import url="${env_jspStoreDir}Widgets/ESpot/ContentRecommendation/ContentRecommendation.jsp">
														<c:param name="emsName" value="HomeRow1_Content" />
														<c:param name="numberContentPerRow" value="1" />
														<c:param name="catalogId" value="${catalogId}" />
														<c:param name="ribbonAdWidth" value="935" />
														<c:param name="ribbonAdHeight" value="394" />
														<c:param name="useRibbon" value="true" />														
													</c:import>
													<%out.flush();%>
												</c:otherwise>
											</c:choose>
										</div>
									</div>
									
									<div class="widget_carousel_position container_margin_5px">
										<c:choose>
											<c:when test="${env_fetchMarketingDetailsOnLoad}">
												<div dojoType="wc.widget.RefreshArea" id="ScrollableESpot_Widget" controllerId="ScrollableESpot_Controller">
												</div>
											</c:when>
											<c:otherwise>
												<%out.flush();%>
												<c:import url="${env_jspStoreDir}Widgets/ESpot/ProductRecommendation/ProductRecommendation.jsp">
													<c:param name="emsName" value="HomeRow2_CatEntries"/>
													<c:param name="pageView" value="miniGrid"/>
													<c:param name="align" value="scroll"/>
												</c:import>
												<%out.flush();%>
											</c:otherwise>
										</c:choose>
									</div>
									
									<div class="clear_float"></div>
									
									<div class="widget_home_espots_left_position">
										<div class="widget_home_espots_left">
											<c:choose>
												<c:when test="${env_fetchMarketingDetailsOnLoad}">
													<div dojoType="wc.widget.RefreshArea" id="HomeLeftESpot_Widget" controllerId="HomeLeftESpot_Controller">
													</div>
												</c:when>
												<c:otherwise>
													<%out.flush();%>
														<c:import url="${env_jspStoreDir}Widgets/ESpot/ContentRecommendation/ContentRecommendation.jsp">
															<c:param name="emsName" value="HomeLeft_Content" />
															<c:param name="numberContentPerRow" value="2" />
															<c:param name="catalogId" value="${catalogId}" />
														</c:import>
													<%out.flush();%>
												</c:otherwise>
											</c:choose>
										</div>
									</div>
																		
									<div class="widget_home_espots_right_position">
										<div class="widget_home_espots_right">
											<c:choose>
												<c:when test="${env_fetchMarketingDetailsOnLoad}">
													<div dojoType="wc.widget.RefreshArea" id="HomeRightTopESpot_Widget" controllerId="HomeRightTopESpot_Controller">
													</div>
												</c:when>
												<c:otherwise>
													<%out.flush();%>
													<c:import url="${env_jspStoreDir}Widgets/ESpot/ContentRecommendation/ContentRecommendation.jsp">
														<c:param name="emsName" value="HomeRightRow1_Content" />
														<c:param name="numberContentPerRow" value="1" />
														<c:param name="catalogId" value="${catalogId}" />
														<c:param name="errorViewName" value="AjaxOrderItemDisplayView" />
													</c:import>
													<%out.flush();%>
												</c:otherwise>
											</c:choose>
							
										<div class="clear_float"></div>
										<div class="item_spacer_5px"></div>
										
										    <c:set var="isFacebookEnabled" value="false" scope="page" />
											<flow:ifEnabled feature="FacebookIntegration">
											   <c:set var="isFacebookEnabled" value="true" scope="page" />
											</flow:ifEnabled>

											<c:choose>
											    <c:when test="${isFacebookEnabled}">
													<%out.flush();%>
											    	<c:import url="${env_jspStoreDir}Widgets/FacebookActivity/FacebookActivity.jsp" />													
													<%out.flush();%>
												</c:when>
												<c:when test="${env_fetchMarketingDetailsOnLoad}">
													<div dojoType="wc.widget.RefreshArea" id="HomeRightBottomESpot_Widget" controllerId="HomeRightBottomESpot_Controller">
													</div>
												</c:when>
												<c:otherwise>
													<%out.flush();%>
													<c:import url="${env_jspStoreDir}Widgets/ESpot/ContentRecommendation/ContentRecommendation.jsp">
														<c:param name="emsName" value="HomeRightRow2_Content" />
														<c:param name="numberContentPerRow" value="1" />
														<c:param name="catalogId" value="${catalogId}" />
														<c:param name="errorViewName" value="AjaxOrderItemDisplayView" />
													</c:import>
													<%out.flush();%>
												</c:otherwise>
											</c:choose>

										</div>
									</div>
									
									
									<div class="clear_float"></div>
									
									<flow:ifEnabled feature="IntelligentOffer">											
										<div class="widget_product_listing_position">											
											<%out.flush();%>
											<c:import url="${env_jspStoreDir}Widgets/ESpot/IntelligentOffer/IntelligentOffer.jsp">	
												<c:param name="emsName" value="Home_IntellOffer" />
												<c:param name="catalogId" value="${catalogId}" />
												<c:param name="pageSize" value="4" />
												<c:param name="pageView" value="miniGrid" />
												<c:param name="parentCategoryId" value="_TS_" />												
											</c:import>
											<%out.flush();%>												
										</div>
									</flow:ifEnabled> 
								</div>
								
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
					<c:param name="homeHeroESpot" value="true"/>
					<c:param name="scrollableESpot" value="true"/>
					<c:param name="homeLeftESpot" value="true"/>
					<c:param name="homeRightTopESpot" value="true"/>
					<c:param name="homeRightBottomESpot" value="true"/>
				</c:import>
			<%out.flush();%>
			</c:if>
			<!--End: Contents after page load-->
		</div>
	<flow:ifEnabled feature="Analytics"><cm:pageview/></flow:ifEnabled>
	</body>

<!-- END HomePage.jsp -->		
</html>