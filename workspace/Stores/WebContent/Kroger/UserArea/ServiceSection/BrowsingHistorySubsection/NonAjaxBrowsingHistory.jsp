
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ include file="../../../Common/EnvironmentSetup.jspf"%>
<%@ include file="../../../Common/nocache.jspf" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>    
<%@ taglib uri="http://commerce.ibm.com/coremetrics"  prefix="cm" %>
<%-- ErrorMessageSetup.jspf is used to retrieve an appropriate error message when there is an error --%>
<%@ include file="../../../include/ErrorMessageSetup.jspf" %>

<c:set var="myAccountPage" value="true" scope="request"/>
<c:set var="hasBreadCrumbTrail" value="false" scope="request"/>

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
<html xmlns="http://www.w3.org/1999/xhtml" lang="${shortLocale}" xml:lang="${shortLocale}">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title><fmt:message key="BROWSING_HISTORY"/></title>
	<link rel="stylesheet" href="<c:out value="${jspStoreImgDir}${env_vfileStylesheet}"/>" type="text/css"/>
	<%@ include file="../../../Common/CommonJSToInclude.jspf"%>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Widgets/Search.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Widgets/MiniShopCartDisplay/MiniShopCartDisplay.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Widgets/Department/Department.js"/>"></script>
	
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/CommonContextsDeclarations.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/CommonControllersDeclaration.js"/>"></script>
	
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Widgets/QuickInfo/QuickInfo.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Widgets/ESpot/ProductRecommendation.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Widgets/ShoppingList/ShoppingList.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Widgets/ShoppingList/ShoppingListServicesDeclaration.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Common/ShoppingActionsServicesDeclaration.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Common/ShoppingActions.js"/>"></script>
	
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/UserArea/AddressHelper.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/CatalogArea/CategoryDisplay.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/UserArea/MyAccountDisplay.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/UserArea/MyAccountServicesDeclaration.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/ServicesDeclaration.js"/>"></script>
	
	<%@ include file="../../../Common/CommonJSPFToInclude.jspf"%>
	
	<script type="text/javascript">
		categoryDisplayJS.setCommonParameters('<c:out value='${WCParam.langId}'/>','<c:out value='${WCParam.storeId}'/>','<c:out value='${WCParam.catalogId}'/>','<c:out value='${userType}'/>');
		MyAccountServicesDeclarationJS.setCommonParameters('<c:out value='${WCParam.langId}'/>','<c:out value='${WCParam.storeId}'/>','<c:out value='${WCParam.catalogId}'/>');
	
	
		<fmt:message key="REQUIRED_FIELD_ENTER" var="REQUIRED_FIELD_ENTER"/>
		<fmt:message key="SHOPCART_ADDED" var="SHOPCART_ADDED"/>
		<fmt:message key="SHOPCART_REMOVEITEM" var="SHOPCART_REMOVEITEM" />
		<fmt:message key="ERROR_MESSAGE_TYPE" var="ERROR_MESSAGE_TYPE"/>
		<fmt:message key="QUANTITY_INPUT_ERROR" var="QUANTITY_INPUT_ERROR"/>
		<%-- Missing Message --%>
		<fmt:message key="ERROR_CONTRACT_EXPIRED_GOTO_ORDER" var="ERROR_CONTRACT_EXPIRED_GOTO_ORDER"/>
		<fmt:message key="ERR_RESOLVING_SKU" var="ERR_RESOLVING_SKU"/>
		
	
		MessageHelper.setMessage("REQUIRED_FIELD_ENTER", <wcf:json object="${REQUIRED_FIELD_ENTER}"/>);
		MessageHelper.setMessage("SHOPCART_ADDED", <wcf:json object="${SHOPCART_ADDED}"/>);
		MessageHelper.setMessage("SHOPCART_REMOVEITEM", <wcf:json object="${SHOPCART_REMOVEITEM}"/>);
		MessageHelper.setMessage("ERROR_MESSAGE_TYPE", <wcf:json object="${ERROR_MESSAGE_TYPE}"/>);
		MessageHelper.setMessage("QUANTITY_INPUT_ERROR", <wcf:json object="${QUANTITY_INPUT_ERROR}"/>);
		MessageHelper.setMessage("ERROR_CONTRACT_EXPIRED_GOTO_ORDER", <wcf:json object="${ERROR_CONTRACT_EXPIRED_GOTO_ORDER}"/>);
		MessageHelper.setMessage("ERR_RESOLVING_SKU", <wcf:json object="${ERR_RESOLVING_SKU}"/>);	
	</script>
	<script type="text/javascript" src="<c:out value='${jsAssetsDir}javascript/CheckoutArea/CheckoutHelper.js'/>"></script>
</head>
<body>

	<%@ include file="../../../Widgets/QuickInfo/QuickInfoPopup.jspf" %>
	<%@ include file="../../../Widgets/ShoppingList/ItemAddedPopup.jspf" %>
	<!-- Page Start -->
	<div id="page">	

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
							<%out.flush();%>
							<c:import url="/${sdb.jspStoreDir}/include/BreadCrumbTrailDisplay.jsp">
								<c:param name="topCategoryPage" value="${requestScope.topCategoryPage}" />
								<c:param name="categoryPage" value="${requestScope.categoryPage}" />
								<c:param name="productPage" value="${requestScope.productPage}" />
								<c:param name="shoppingCartPage" value="${requestScope.shoppingCartPage}" />
								<c:param name="compareProductPage" value="${requestScope.compareProductPage}" />
								<c:param name="finalBreadcrumb" value="${requestScope.finalBreadcrumb}" />
								<c:param name="extensionPageWithBCF" value="${requestScope.extensionPageWithBCF}" />
								<c:param name="hasBreadCrumbTrail" value="${requestScope.hasBreadCrumbTrail}" />
								<c:param name="requestURIPath" value="${requestScope.requestURIPath}" />
								<c:param name="SavedOrderListPage" value="${requestScope.SavedOrderListPage}" />
								<c:param name="pendingOrderDetailsPage" value="${requestScope.pendingOrderDetailsPage}" />
								<c:param name="sharedWishList" value="${requestScope.sharedWishList}" />
								<c:param name="searchPage" value="${requestScope.searchPage}"/>
							</c:import>
							<%out.flush();%>
						
							<div class="container_content_leftsidebar">													
							  	<div class="left_column">
							  		<%@ include file="../../../include/LeftSidebarDisplay.jspf"%>
							  	</div>
							  	<div class="right_column"> 

								<!-- Main Content Start -->
								<div id="box">
									<div class="my_account" id="WC_NonAjaxBrowseHistory_div_1">														
										<div class="widget_recentlyviewed_position" id="WC_NonAjaxBrowseHistory_div_6">
											<fmt:message var="titleString" key="BROWSING_HISTORY"/>												
												<%out.flush();%>
												<c:import url="${env_jspStoreDir}Widgets/ESpot/ProductRecommendation/ProductRecommendation.jsp">
													<c:param name="pageSize" value="12"/>
													<c:param name="emsName" value="RecViewed_CatEntries" />
													<c:param name="errorViewName" value="AjaxOrderItemDisplayView"/>
													<c:param name="pageView" value="miniGrid"/>
													<c:param name="espotTitle" value="${titleString}"/>
												</c:import>
												<%out.flush();%>	
											
											<script type="text/javascript">
												dojo.addOnLoad(function() { 
													parseWidget("BrowsingHistoryDisplay_Widget"); 
												});
											</script>								
									  	</div>
									  		  	
										<div class="footer" id="WC_NonAjaxBrowseHistory_div_7">
											<div class="left_corner" id="WC_NonAjaxBrowseHistory_div_8"></div>
											<div class="tile" id="WC_NonAjaxBrowseHistory_div_9"></div>
											<div class="right_corner" id="WC_NonAjaxBrowseHistory_div_10"></div>
										</div>
									</div>
								</div>
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
</body>
</html>
