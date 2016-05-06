
<%-- 
  *****
  * This JSP displays store locator content and allows shopper to select a store to add to the WC_physicalStores
  * cookie. This JSP will then update the shipping mode and address id associated with the order itmes of the 
  * current order once the shopper clicks the next button in the shopping flow.
  *****
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="http://commerce.ibm.com/coremetrics"  prefix="cm" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ include file="../../Common/EnvironmentSetup.jspf" %>
<%@ include file="../../Common/nocache.jspf" %>
<%@ include file="../../include/ErrorMessageSetup.jspf" %>

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
<!-- BEGIN CheckoutStoreSelection.jsp -->
<html xmlns="http://www.w3.org/1999/xhtml" lang="${shortLocale}" xml:lang="${shortLocale}">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<%@ include file="../../Common/CommonJSToInclude.jspf" %>	
	
	<link rel="stylesheet" href="<c:out value="${jspStoreImgDir}${env_vfileStylesheet}"/>" type="text/css"/>

	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Widgets/Search.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Widgets/MiniShopCartDisplay/MiniShopCartDisplay.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Widgets/Department/Department.js"/>"></script>	
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Common/ShoppingActions.js"/>"></script>
	
	<title><fmt:message key="CO_STORE_SELECTION_TITLE" /></title>
</head>

<c:set var="isAjaxCheckOut" value="true"/>
<%-- Check if its a non-ajax checkout..--%>
<flow:ifDisabled feature="AjaxCheckout"> 
	<c:set var="isAjaxCheckOut" value="false"/>
</flow:ifDisabled>

<wcf:url var="shopViewURL" value="AjaxOrderItemDisplayView"></wcf:url>
<wcf:url var="ShoppingCartURL" value="OrderCalculate" type="Ajax">
	<wcf:param name="langId" value="${langId}" />
	<wcf:param name="storeId" value="${WCParam.storeId}" />
	<wcf:param name="catalogId" value="${WCParam.catalogId}" />
	<wcf:param name="URL" value="${shopViewURL}" />
	<wcf:param name="updatePrices" value="1" />
	<wcf:param name="calculationUsageId" value="-1" />
	<wcf:param name="orderId" value="." />
</wcf:url>

<%-- constructs form used by ShipmodeSelectionExtJS --%>
<wcf:getData type="com.ibm.commerce.order.facade.datatypes.OrderType" var="order" expressionBuilder="findCurrentShoppingCart">
	<wcf:param name="accessProfile" value="IBM_Details" />
</wcf:getData>

<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/MessageHelper.js"/>"></script>
<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/StoreLocatorArea/PhysicalStoreCookie.js"/>"></script>
<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/CheckoutArea/ShipmodeSelectionExt.js"/>"></script>

<script type="text/javascript" src="${jsAssetsDir}javascript/Tealeaf/tealeafWC.js"></script>
<c:if test="${env_Tealeaf eq 'true' && env_inPreview != 'true'}">
	<script type="text/javascript" src="${jsAssetsDir}javascript/Tealeaf/tealeaf.js"></script>
</c:if>
<script type="text/javascript">
	dojo.addOnLoad(function() {
		ShipmodeSelectionExtJS.setCommonParameters('<c:out value="${WCParam.langId}"/>','<c:out value="${WCParam.storeId}"/>','<c:out value="${WCParam.catalogId}"/>');
		ShipmodeSelectionExtJS.setOrderItemId('${order.orderItem[0].orderItemIdentifier.uniqueID}');
		<fmt:message key="ERR_NO_PHY_STORE" var="ERR_NO_PHY_STORE"/>
		MessageHelper.setMessage("message_NO_STORE", <wcf:json object="${ERR_NO_PHY_STORE}"/>);
	});
</script>

<flow:ifEnabled feature="Analytics">
	<c:if test="${userType == 'R' && WCParam.showRegTag == 'T'}">
		<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Analytics.js"/>"></script>
		<script type="text/JavaScript">
			dojo.addOnLoad(function() { analyticsJS.publishShopCartLoginTags(); });
		</script>
	</c:if>
</flow:ifEnabled>

<body>
 
<!-- Page Start -->
<div id="page">
	<!-- Include top message display widget -->
	<%@ include file="../../Common/CommonJSPFToInclude.jspf"%>

	<!-- Header Nav Start -->
	<div class="header_wrapper_position" id="headerWidget">
		<%out.flush();%>
		<c:import url = "${env_jspStoreDir}/Widgets/Header/Header.jsp" />
		<%out.flush();%>
	</div>
	<!-- Header Nav End -->
	
	<!-- Main Content Start -->
	<div class="content_wrapper_position" role="main">
		<div class="content_wrapper">
			<div class="content_left_shadow">
				<div class="content_right_shadow">
					<div class="main_content">
						<div class="container_full_width">
							<!-- Breadcrumb Start -->
							<div id="checkout_crumb">
								<div class="crumb" id="WC_CheckoutStoreSelection_div_1">
									<a href="<c:out value="${ShoppingCartURL}"/>" id="WC_CheckoutStoreSelection_links_1">
										<span class="step_off"><fmt:message key="BCT_SHOPPING_CART"/></span>
									</a>
									<span class="step_arrow"></span>
									<span class="step_on"><fmt:message key="BCT_STORE_SELECTION"/></span>
									<span class="step_arrow"></span>
									<span class="step_off"><fmt:message key="BCT_ADDRESS"/></span>
									<span class="step_arrow"></span>
									<span class="step_off"><fmt:message key="BCT_SHIPPING_AND_BILLING"/></span>
									<span class="step_arrow"></span>
									<span class="step_off"><fmt:message key="BCT_ORDER_SUMMARY"/></span>
								</div>							</div>
							<!-- Breadcrumb End -->   
						
							<div id="box">
								<wcf:getData type="com.ibm.commerce.order.facade.datatypes.OrderType"
										var="usableShippingInfo" expressionBuilder="findUsableShippingInfoWithPagingOnItem" varShowVerb="ShowVerbUsableShippingInfo" maxItems="1" recordSetStartNumber="0" recordSetReferenceId="ostatus">
									<wcf:param name="accessProfile" value="IBM_UsableShippingInfo" /> 
									<wcf:param name="orderId" value="${order.orderIdentifier.uniqueID}" />
									<wcf:param name="sortOrderItemBy" value="orderItemID" />
								</wcf:getData>

					 			<%out.flush();%>
								<c:import url="/${sdb.jspStoreDir}/Snippets/StoreLocator/StoreLocator.jsp">
									<c:param name="fromPage" value="ShoppingCart" />
									<c:param name="orderId" value="${order.orderIdentifier.uniqueID}" />
								</c:import>
								<%out.flush();%>
							</div>
							<c:set var="orderItemArray" value="${order.orderItem}"/>
							<form id="orderItemStoreSelectionForm" name="orderItemStoreSelectionForm" method="post" action="OrderChangeServiceShipInfoUpdate">
								<input type="hidden" id="storeId" name="storeId" value="${WCParam.storeId}"/>
								<input type="hidden" id="catalogId" name="catalogId" value="${WCParam.catalogId}"/>
								<input type="hidden" id="langId" name="langId" value="${WCParam.langId}"/>
								<input type="hidden" id="fromPage" name="fromPage" value="ShoppingCart"/>
								<input type="hidden" id="orderId" name="orderId" value="${order.orderIdentifier.uniqueID}"/>
								<input type="hidden" id="errorViewName" name="errorViewName" value="CheckoutStoreSelectionView"/>
								<input type="hidden" id="URL" name="URL" value="CheckoutPayInStoreView?orderItemId*=&shipModeId*=&physicalStoreId*="/>
								<input type="hidden" name="calculationUsage" value="-1,-2,-3,-4,-5,-6,-7" id="calcUsage"/>
								
								<c:set var="doneLoop" value="false"/>
								<c:forEach items="${usableShippingInfo.orderItem}" var="curOrderItem">
									<c:if test="${not doneLoop}">
										<c:forEach items="${curOrderItem.usableShippingMode}" var="curShipmode">
											<c:if test="${not doneLoop}">
												<c:if test="${curShipmode.shippingModeIdentifier.externalIdentifier.shipModeCode == 'PickupInStore'}">
													<c:set var="doneLoop" value="true"/>
													<c:set var="bopisShipmodeId" value="${curShipmode.shippingModeIdentifier.uniqueID}"/>
												</c:if>
											</c:if>
										</c:forEach>
									</c:if>
								</c:forEach>
																	
								<input type="hidden" id="shipModeId" name="shipModeId" value="${bopisShipmodeId}"/>
								<input type="hidden" id="physicalStoreId" name="physicalStoreId" value=""/>
			
								<!-- Store selection footer -->
								<div class="button_footer_line" id="WC_CheckoutStoreSelection_div_4">
									<div class="left" id="WC_CheckoutStoreSelection_div_5">
										<a role="button" class="button_secondary" id="WC_CheckoutStoreSelection_links_2" href="javascript:setPageLocation('<c:out value="${ShoppingCartURL}"/>')">
											<div class="left_border"></div>
											<div class="button_text"><fmt:message key="CO_STORE_SELECTION_BACK"/><span class="spanacce"><fmt:message key="Checkout_ACCE_back_shopping_cart"/></span></div>
											<div class="right_border"></div>
										</a>
									</div>
									<div class="left" id="WC_CheckoutStoreSelection_div_8">
										<a href="#" role="button" class="button_primary button_left_padding" id="storeSelection_NextButton" onclick="javascript:TealeafWCJS.processDOMEvent(event);ShipmodeSelectionExtJS.submitStoreSelectionForm(document.orderItemStoreSelectionForm); return false;">
											<div class="left_border"></div>
											<div class="button_text"><fmt:message key="CO_STORE_SELECTION_NEXT"/><span class="spanacce"><fmt:message key="Checkout_ACCE_next_summary"/></span></div>
											<div class="right_border"></div>
										</a>
									</div>
									<div class="button_side_message" id="WC_CheckoutStoreSelection_div_11">
										<fmt:message key="CO_STORE_SELECTION_NEXTSTEP"/>
									</div>
								</div>
								<div class="espot_checkout_bottom" id="WC_CheckoutStoreSelection_div_13">
									<%@ include file="../../Snippets/ReusableObjects/CheckoutBottomESpotDisplay.jspf"%>
								</div>
							</form>
						</div>
						<!-- Main Content End --> 
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

<flow:ifEnabled feature="Analytics">
	<cm:pageview/>
</flow:ifEnabled>

</body>
</html>

<!-- END CheckoutStoreSelection.jsp -->
