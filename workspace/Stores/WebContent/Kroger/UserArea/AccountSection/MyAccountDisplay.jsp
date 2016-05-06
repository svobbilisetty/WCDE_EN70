
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ include file="../../Common/EnvironmentSetup.jspf"%>
<%@ include file="../../Common/nocache.jspf"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="http://commerce.ibm.com/coremetrics"  prefix="cm" %>

<c:set var="myAccountPage" value="true" scope="request"/>
<c:set var="hasBreadCrumbTrail" value="false" scope="request"/>

<wcf:url var="OrderStatusTableDetailsDisplayURL" value="OrderStatusTableDetailsDisplay" type="Ajax">
	<wcf:param name="storeId"   value="${WCParam.storeId}"  />
	<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
	<wcf:param name="langId" value="${langId}" />
	<c:if test="${WCParam.isQuote eq true}">
		<wcf:param name="isQuote" value="true" />
	</c:if>
</wcf:url>

<wcf:url var="RecurringOrderTableDetailsDisplayURL" value="RecurringOrderTableDetailsDisplay" type="Ajax">
	<wcf:param name="storeId"   value="${WCParam.storeId}"  />
	<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
	<wcf:param name="langId" value="${langId}" />
</wcf:url>

<wcf:url var="SubscriptionTableDetailsDisplayURL" value="SubscriptionTableDetailsDisplay" type="Ajax">
	<wcf:param name="storeId"   value="${WCParam.storeId}"  />
	<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
	<wcf:param name="langId" value="${langId}" />
</wcf:url>

<!DOCTYPE HTML>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2008, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<!-- BEGIN MyAccountDisplay.jsp -->
<html xmlns="http://www.w3.org/1999/xhtml"
xmlns:wairole="http://www.w3.org/2005/01/wai-rdf/GUIRoleTaxonomy#"
xmlns:waistate="http://www.w3.org/2005/07/aaa" lang="${shortLocale}" xml:lang="${shortLocale}">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<!-- Mimic Internet Explorer 7 -->
	<%@ include file="../../Common/CommonJSToInclude.jspf"%>

	<link href="<c:out value="${jspStoreImgDir}${env_vfileStylesheet}"/>" rel="stylesheet" type="text/css" />
	<link rel="stylesheet" href="<c:out value="${jspStoreImgDir}${vfileStylesheetprint}"/>" type="text/css" media="print"/>
	
	
	<%@ include file="../../include/ErrorMessageSetupBrazilExt.jspf" %>
	<%@ include file="MyAccountDisplayExt.jspf" %>
	<%@ include file="GiftRegistryMyAccountDisplayExt.jspf" %>
	
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Widgets/Search.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Widgets/MiniShopCartDisplay/MiniShopCartDisplay.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Widgets/Department/Department.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Widgets/ShoppingList/ShoppingList.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Widgets/ShoppingList/ShoppingListServicesDeclaration.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Common/ShoppingActionsServicesDeclaration.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Common/ShoppingActions.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Widgets/QuickInfo/QuickInfo.js"/>"></script>
	
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/CommonContextsDeclarations.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/CommonControllersDeclaration.js"/>"></script>
	
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/UserArea/AddressHelper.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/CheckoutArea/CheckoutPayments.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/UserArea/MyAccountDisplay.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/UserArea/LogonForm.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/CatalogArea/CategoryDisplay.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/UserArea/MyAccountServicesDeclaration.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/UserArea/MyAccountControllersDeclaration.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/CheckoutArea/Punchout.js"/>"></script>
	<c:if test="${isBrazilStore}"> 
		<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/UserArea/MyBrazilAccountDisplay.js"/>"></script>
	</c:if>
	
	<%@ include file="../../Widgets/QuickInfo/QuickInfoPopup.jspf" %>
	<%@ include file="../../Widgets/ShoppingList/ItemAddedPopup.jspf" %>
	<%@ include file="../../Common/CommonJSPFToInclude.jspf"%>
		
	<title><fmt:message key="MA_MYACCOUNT"/></title>

<script type="text/javascript">
	dojo.addOnLoad(function() {
		categoryDisplayJS.setCommonParameters('<c:out value="${WCParam.langId}"/>','<c:out value="${WCParam.storeId}"/>','<c:out value="${WCParam.catalogId}"/>','${userType}');
		MyAccountServicesDeclarationJS.setCommonParameters('<c:out value="${WCParam.langId}"/>','<c:out value="${WCParam.storeId}"/>','<c:out value="${WCParam.catalogId}"/>');

		<fmt:message key="MO_ORDER_CANCELED_MSG" var="MO_ORDER_CANCELED_MSG"/>
		<fmt:message key="SCHEDULE_ORDER_CANCEL_MSG" var="SCHEDULE_ORDER_CANCEL_MSG"/>
		<fmt:message key="SCHEDULE_ORDER_PENDING_CANCEL_MSG" var="SCHEDULE_ORDER_PENDING_CANCEL_MSG"/>
		<fmt:message key="SUBSCRIPTION_CANCEL_MSG" var="SUBSCRIPTION_CANCEL_MSG"/>
		<fmt:message key="SUBSCRIPTION_PENDING_CANCEL_MSG" var="SUBSCRIPTION_PENDING_CANCEL_MSG"/>
		<fmt:message key="CANNOT_RENEW_NOW_MSG" var="CANNOT_RENEW_NOW_MSG"/>
		MessageHelper.setMessage("MO_ORDER_CANCELED_MSG", <wcf:json object="${MO_ORDER_CANCELED_MSG}"/>);	
		MessageHelper.setMessage("SCHEDULE_ORDER_CANCEL_MSG", <wcf:json object="${SCHEDULE_ORDER_CANCEL_MSG}"/>);
		MessageHelper.setMessage("SCHEDULE_ORDER_PENDING_CANCEL_MSG", <wcf:json object="${SCHEDULE_ORDER_PENDING_CANCEL_MSG}"/>);
		MessageHelper.setMessage("SUBSCRIPTION_CANCEL_MSG", <wcf:json object="${SUBSCRIPTION_CANCEL_MSG}"/>);
		MessageHelper.setMessage("SUBSCRIPTION_PENDING_CANCEL_MSG", <wcf:json object="${SUBSCRIPTION_PENDING_CANCEL_MSG}"/>);
		MessageHelper.setMessage("CANNOT_RENEW_NOW_MSG", <wcf:json object="${CANNOT_RENEW_NOW_MSG}"/>);
		MyAccountControllersDeclarationJS.setControllerURL("ScheduledOrdersStatusDisplayController", "<c:out value='${OrderStatusTableDetailsDisplayURL}'/>");
		MyAccountControllersDeclarationJS.setControllerURL("ProcessedOrdersStatusDisplayController", "<c:out value='${OrderStatusTableDetailsDisplayURL}'/>");
		MyAccountControllersDeclarationJS.setControllerURL("WaitingForApprovalOrdersStatusDisplayController", "<c:out value='${OrderStatusTableDetailsDisplayURL}'/>");
		if(document.getElementById("RecentRecurringOrderDisplay")){
			parseWidget("RecentRecurringOrderDisplay");
		}
		if(document.getElementById("RecentSubscriptionDisplay")){
			parseWidget("RecentSubscriptionDisplay");
		}
		MyAccountControllersDeclarationJS.setControllerURL("RecurringOrderDisplayController", "<c:out value='${RecurringOrderTableDetailsDisplayURL}'/>");
		MyAccountControllersDeclarationJS.setControllerURL("SubscriptionDisplayController", "<c:out value='${SubscriptionTableDetailsDisplayURL}'/>");
		if (dojo.cookie("WC_SHOW_USER_ACTIVATION_" + WCParamJS.storeId) == "true") {dojo.cookie("WC_SHOW_USER_ACTIVATION_" + WCParamJS.storeId, null, {path: '/', expire: -1});}
	});
</script>
 <script type="text/javascript">
         function popupWindow(URL) {
            window.open(URL, "mywindow", "status=1,scrollbars=1,resizable=1");
         }
 </script>

</head>
<body>
 
<!-- Page Start -->
<div id="page">
	<!-- Header Widget -->
	<div class="header_wrapper_position" id="headerWidget">
		<%out.flush();%>
		<c:import url = "${env_jspStoreDir}/Widgets/Header/Header.jsp" />
		<%out.flush();%>
	</div>
	
	<script type="text/javascript">
		if('<wcf:out value="${WCParam.page}" escapeFormat="js"/>'=='quickcheckout'){
			dojo.addOnLoad(function() { 
				MessageHelper.displayStatusMessage(storeNLS["QC_UPDATE_SUCCESS"]);
			});
		}
	</script>

	<c:set var="action" value="recurring_order"/>
	<%@ include file="../../Snippets/Subscription/CancelPopup.jspf" %>
	<c:set var="action" value="subscription"/>
	<%@ include file="../../Snippets/Subscription/CancelPopup.jspf" %>
	
	<div class="content_wrapper_position" role="main">	
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
						  		<%@ include file="../../include/LeftSidebarDisplay.jspf"%>
						  	</div>

							<div class="right_column"> 
							    <!-- Main Content Start -->
								<c:choose>         
									<c:when test="${WCParam.myAcctMain == 1}">
										<div id="WC_MyAccountDisplay_div_3_9">
											<div id="WC_MyAccountDisplay_div_4">
												<div id= "box">
													<div class="my_account" id="WC_MyAccountDisplay_div_4_1">
														<div class="main_header" id="WC_MyAccountDisplay_div_5">
															<h2 class="myaccount_header bottom_line"><fmt:message key='MA_SUMMARY'/></h2>
														</div>
														<div class="contentline" id="WC_MyAccountDisplay_div_9"></div>
														<div class="body" id="WC_MyAccountDisplay_div_13">
															<%out.flush();%>
															<c:import url="/${sdb.jspStoreDir}/UserArea/AccountSection/MyAccountCenterLinkDisplay.jsp">  
																<c:param name="storeId" value="${WCParam.storeId}"/>
																<c:param name="catalogId" value="${WCParam.catalogId}"/>  
																<c:param name="langId" value="${langId}"/>
															</c:import>
															<%out.flush();%>  
														</div>
														<div class="footer" id="WC_MyAccountDisplay_div_14">
															<div class="left_corner" id="WC_MyAccountDisplay_div_15"></div>
															<div class="tile" id="WC_MyAccountDisplay_div_16"></div>
															<div class="right_corner" id="WC_MyAccountDisplay_div_17"></div>
														</div>
													</div>
												</div>
											</div>
										</div>
									</c:when>
									<c:otherwise>
										<div id="box_1">
											<div class="my_account" id="WC_MyAccountDisplay_div_18"/>
										</div>
									</c:otherwise>
								</c:choose>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- Main Content End -->
	<!-- Footer Start Start -->
	<div class="footer_wrapper_position">
		<%out.flush();%>
		<c:import url = "${env_jspStoreDir}/Widgets/Footer/Footer.jsp" />
		<%out.flush();%>
	</div> 
     <!-- Footer Start End -->
</div>

<flow:ifEnabled feature="Analytics"><cm:pageview/></flow:ifEnabled>
</body>
</html>
<!-- END MyAccountDisplay.jsp -->
