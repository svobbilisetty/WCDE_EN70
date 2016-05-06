
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ include file="../../../Common/EnvironmentSetup.jspf"%>
<%@ include file="../../../include/ErrorMessageSetup.jspf"%>
<%@ include file="../../../Common/nocache.jspf" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>    
<%@ taglib uri="http://commerce.ibm.com/coremetrics"  prefix="cm" %>

<c:set var="myAccountPage" value="true" scope="request"/>
<c:set var="hasBreadCrumbTrail" value="false" scope="request"/>

<wcf:url var="AjaxCheckoutDisplayViewURL" value="AjaxCheckoutDisplayView">
	<wcf:param name="storeId"   value="${WCParam.storeId}"  />
	<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
	<wcf:param name="langId" value="${langId}" />
</wcf:url>
<wcf:url var="PrepareOrderURL" value="OrderProcessServiceOrderPrepare">
	<wcf:param name="storeId"   value="${WCParam.storeId}"  />
	<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
	<wcf:param name="langId" value="${langId}" />
	<wcf:param name="URL" value="${AjaxCheckoutDisplayViewURL}" />
</wcf:url>

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

  (C) Copyright IBM Corp. 2008, 2012 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<!-- BEGIN OrderStatusDisplay.jsp -->
<html xmlns="http://www.w3.org/1999/xhtml" lang="${shortLocale}" xml:lang="${shortLocale}">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title><fmt:message key="MO_MYORDERS"/></title>
	<link rel="stylesheet" href="<c:out value="${jspStoreImgDir}${env_vfileStylesheet}"/>" type="text/css"/>

	<%@ include file="../../../Common/CommonJSToInclude.jspf"%>
	
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}/javascript/Widgets/Search.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}/javascript/Widgets/MiniShopCartDisplay/MiniShopCartDisplay.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}/javascript/Widgets/Department/Department.js"/>"></script>
	
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Common/ShoppingActions.js"/>"></script>
	
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/CommonContextsDeclarations.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/CommonControllersDeclaration.js"/>"></script>
			
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/UserArea/AddressHelper.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/UserArea/MyAccountDisplay.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/UserArea/MyAccountServicesDeclaration.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/UserArea/MyAccountControllersDeclaration.js"/>"></script>
	
	<%@ include file="../../../Common/CommonJSPFToInclude.jspf"%>
	
	<script type="text/javascript">
		dojo.addOnLoad(function() {
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
			if(document.getElementById("RecurringOrderDisplay")){
				parseWidget("RecurringOrderDisplay");
			}
			if(document.getElementById("SubscriptionDisplay")){
				parseWidget("SubscriptionDisplay");
			}
			MyAccountControllersDeclarationJS.setControllerURL("RecurringOrderDisplayController", "<c:out value='${RecurringOrderTableDetailsDisplayURL}'/>");
			MyAccountControllersDeclarationJS.setControllerURL("SubscriptionDisplayController", "<c:out value='${SubscriptionTableDetailsDisplayURL}'/>");
		});
	</script>
	<flow:ifEnabled feature="RecurringOrders">
		<c:if test="${WCParam.isRecurringOrder eq true}">
			<script type="text/javascript">
				dojo.addOnLoad(function() {
					if(document.getElementById("RecurringOrderBreadcrumb")){
						document.getElementById("MyAccountBreadcrumbLink").style.display = "none";
						document.getElementById("RecurringOrderBreadcrumb1").style.display = "inline";
					}
				});
			</script>
		</c:if>
	</flow:ifEnabled>
	<flow:ifEnabled feature="Subscription">
		<c:if test="${WCParam.isSubscription eq true}">
			<script type="text/javascript">
				dojo.addOnLoad(function() {
					if(document.getElementById("SubscriptionBreadcrumb")){
						document.getElementById("MyAccountBreadcrumbLink").style.display = "none";
						document.getElementById("SubscriptionBreadcrumb1").style.display = "inline";
					}
				});
			</script>
		</c:if>
	</flow:ifEnabled>
	<c:if test="${WCParam.isSubscription ne true && WCParam.isRecurringOrder ne true}">
		<script type="text/javascript">
			dojo.addOnLoad(function() {
				if(document.getElementById("OrderHistoryBreadcrumb")){
					document.getElementById("MyAccountBreadcrumbLink").style.display = "none";
					document.getElementById("OrderHistoryBreadcrumb1").style.display = "inline";
				}
			});
		</script>
	</c:if>
</head>
<body>

<!-- Page Start -->
<div id="page">
	<!-- Import Header Widget -->
	<div class="header_wrapper_position" id="headerWidget">
		<%out.flush();%>
		<c:import url = "${env_jspStoreDir}/Widgets/Header/Header.jsp" />
		<%out.flush();%>
	</div>
	<!-- Header Nav End -->
	
	<c:if test="${WCParam.isRecurringOrder eq true}">
		<c:set var="action" value="recurring_order"/>
	</c:if>
	<c:if test="${WCParam.isSubscription eq true}">
		<c:set var="action" value="subscription"/>
	</c:if>
	<%@ include file="../../../Snippets/Subscription/CancelPopup.jspf" %>

    <!-- Main Content Start -->
		
	<c:if test="${!empty errorMessage}">
		<fmt:message var ="msgType" key="ERROR_MESSAGE_TYPE"/>
		<c:set var = "errorMessage" value ="${msgType}${errorMessage}"/>
		<script type="text/javascript">
			dojo.addOnLoad(function() { 
				dojo.byId('MessageArea').style.display = "block";
				dojo.byId('ErrorMessageText').innerHTML =<wcf:json object="${errorMessage}"/>;
				dojo.byId('MessageArea').focus();
				setTimeout("dojo.byId('ErrorMessageText').focus()",2000);
			});
		</script>
	</c:if>
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
						  		<%@ include file="../../../include/LeftSidebarDisplay.jspf"%>
						  	</div>

							<div class="right_column">
								<div id="box">
									<div class="my_account" id="WC_OrderStatusDisplay_div_1">		

										<div class="myaccount_header bottom_line" id="WC_OrderStatusCommonPage_div_2">
											<div class="left_corner" id="WC_OrderStatusCommonPage_div_3"></div>
											<div class="headingtext" id="WC_OrderStatusCommonPage_div_4">
												<span class="main_header_text">
													<c:choose>
														<c:when test="${WCParam.isQuote eq true}">
															<fmt:message key='MO_MYQUOTES'/>
														</c:when>
														<c:when test="${WCParam.isRecurringOrder eq true}">
															<fmt:message key='MA_SCHEDULEDORDERS'/>
														</c:when>
														<c:when test="${WCParam.isSubscription eq true}">
															<fmt:message key='MA_SUBSCRIPTIONS'/>
														</c:when>
														<c:otherwise>
															<fmt:message key='MA_ORDER_HISTORY'/>
														</c:otherwise>
													</c:choose>
												</span>
											</div>
											<div class="right_corner" id="WC_OrderStatusCommonPage_div_5"></div>
										</div>
					
										<div class="body" id="WC_OrderStatusCommonPage_div_6">						
											<% out.flush(); %>
											<c:choose>
												<c:when test="${WCParam.isQuote eq true}">
													<c:import url="/${sdb.jspStoreDir}/Snippets/Order/Cart/OrderStatusTableDisplay.jsp" >
														<c:param name="isQuote" value="true"/>
													</c:import>
												</c:when>
												<c:when test="${WCParam.isRecurringOrder eq true}">
													<c:import url="/${sdb.jspStoreDir}/Snippets/Subscription/RecurringOrder/RecurringOrderTableDisplay.jsp"></c:import>
												</c:when>
												<c:when test="${WCParam.isSubscription eq true}">
													<c:import url="/${sdb.jspStoreDir}/Snippets/Subscription/SubscriptionTableDisplay.jsp"></c:import>
												</c:when>
												<c:otherwise>
													<c:import url="/${sdb.jspStoreDir}/Snippets/Order/Cart/OrderStatusTableDisplay.jsp"></c:import>
												</c:otherwise>
											</c:choose>
											<% out.flush();%>				
											<br/>								
											<br clear="all" />					
										</div>
									</div>
									<div class="footer" id="WC_OrderStatusCommonPage_div_7">
										<div class="left_corner" id="WC_OrderStatusCommonPage_div_8"></div>
										<div class="tile" id="WC_OrderStatusCommonPage_div_9"></div>
										<div class="right_corner" id="WC_OrderStatusCommonPage_div_10"></div>
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

<flow:ifEnabled feature="Analytics"><cm:pageview/></flow:ifEnabled>
</body>
</html>
<!-- END OrderStatusDisplay.jsp -->
