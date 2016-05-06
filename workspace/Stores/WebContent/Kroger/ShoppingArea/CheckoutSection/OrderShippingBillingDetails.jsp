
<%-- 
  *****
  * This JSP file is used to render the shipping and billing page of the online checkout flow.
  * It allows shoppers to enter their shipping address and shipping method as well as other
  * advanced shipping options such as shipping instructions, requested shipping date, etc.
  * It also allows the shoppers to enter the billing and payment information for their order.
  *****
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://commerce.ibm.com/coremetrics"  prefix="cm" %>
<%@ include file="../../Common/EnvironmentSetup.jspf"%>
<%@ include file="../../Common/nocache.jspf"%>

<c:set var="isAjaxCheckOut" value="true"/>
<%-- Check if its a non-ajax checkout..--%>
<flow:ifDisabled feature="AjaxCheckout"> 
       <c:set var="isAjaxCheckOut" value="false"/>
</flow:ifDisabled>

<c:set var="isSinglePageCheckout" value="true"/>
<%-- Check if its a traditional checkout..--%>
<flow:ifDisabled feature="SharedShippingBillingPage"> 
       <c:set var="isSinglePageCheckout" value="false"/>
</flow:ifDisabled>

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
<!-- BEGIN OrderShippingBillingDetails.jsp -->
<html xmlns="http://www.w3.org/1999/xhtml"
xmlns:wairole="http://www.w3.org/2005/01/wai-rdf/GUIRoleTaxonomy#"
xmlns:waistate="http://www.w3.org/2005/07/aaa" lang="${shortLocale}" xml:lang="${shortLocale}">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>
	<flow:ifEnabled feature="SharedShippingBillingPage">
		<c:out value="${storeName}"/> - <fmt:message key="TITLE_SHIPMENT_DISPLAY"/>
	</flow:ifEnabled>
	<flow:ifDisabled feature="SharedShippingBillingPage">
		<c:out value="${storeName}"/> - <fmt:message key="TITLE_SHIPMENT_DISPLAY_SHIPPING_ONLY"/>
	</flow:ifDisabled>
</title>

<link rel="stylesheet" href="<c:out value="${jspStoreImgDir}${env_vfileStylesheet}"/>" type="text/css"/>

<%-- This following section is only loaded and executed if the current page flow is non-AJAX --%>
<c:if test="${!isAjaxCheckOut}">
       <script type="text/javascript">
              // summary              : Sets a dirty flag
              // description       : Sets a dirty flag in CheckoutPayments.js when the user modifies the shipping information in a non-AJAX checkout flow
              //
              // event              : DOM/Dojo/Dijit event, e.g. onclick, onchange, etc.
              // assumptions       : Should be used in non-AJAX
              // dojo API              : 
              // returns              : void
              function setDirtyFlag(){
                     CheckoutHelperJS.setFieldDirtyFlag(true);
                     console.debug("Shipping information on the Shipping and Billing Method page was modified.");
              }
              
              ///////////////////////////////////////////////////////////////////////
              // On page load, we add the editable fields in the shipping information
              // section to dojo event listener so that when they are changed by the
              // user, we ask the user to update the shipping information before
              // proceeding to checkout.
              ///////////////////////////////////////////////////////////////////////
       </script>
</c:if>

<%@ include file="../../Common/CommonJSToInclude.jspf"%>
<script type="text/javascript" src="<c:out value='${jsAssetsDir}javascript/UserArea/AddressHelper.js'/>"></script>
<script type="text/javascript" src="<c:out value='${jsAssetsDir}javascript/CatalogArea/CategoryDisplay.js'/>"></script>
<script type="text/javascript" src="<c:out value='${jsAssetsDir}javascript/CheckoutArea/CheckoutHelper.js'/>"></script>
<script type="text/javascript" src="<c:out value='${jsAssetsDir}javascript/MessageHelper.js'/>"></script>
<flow:ifDisabled feature="SharedShippingBillingPage"> 
	<script type="text/javascript" src="<c:out value='${jsAssetsDir}javascript/CheckoutArea/CheckoutPayments.js'/>"></script>
</flow:ifDisabled>
<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/ServicesDeclaration.js"/>"></script>
<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/CheckoutArea/ShippingAndBillingServicesDeclaration.js"/>"></script>

<%-- CommonContexts must come before CommonControllers --%>
<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/CommonContextsDeclarations.js"/>"></script>
<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/CommonControllersDeclaration.js"/>"></script>

<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/ServicesEventMapping.js"/>"></script>
<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/CheckoutArea/ShippingAndBillingControllersDeclaration.js"/>"></script>

<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Widgets/Search.js"/>"></script>
<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Widgets/MiniShopCartDisplay/MiniShopCartDisplay.js"/>"></script>
<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Widgets/Department/Department.js"/>"></script>
<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Common/ShoppingActions.js"/>"></script>
<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Widgets/QuickInfo/QuickInfo.js"/>"></script>
<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Widgets/ShoppingList/ShoppingList.js"/>"></script>
<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Widgets/ShoppingList/ShoppingListServicesDeclaration.js"/>"></script>

<script type="text/javascript" src="${jsAssetsDir}javascript/Tealeaf/tealeafWC.js"></script>
<c:if test="${env_Tealeaf eq 'true' && env_inPreview != 'true'}">
	<script type="text/javascript" src="${jsAssetsDir}javascript/Tealeaf/tealeaf.js"></script>
</c:if>


<c:set var="validAddressId" value=""/>

<c:set var="pageSize" value="${WCParam.pageSize}" />
<c:if test="${empty pageSize}">
	<c:set var="pageSize" value="${maxOrderItemsPerPage}"/>
</c:if>

<c:set var="beginIndex" value="${WCParam.beginIndex}" />
<c:if test="${empty beginIndex}">
	<c:set var="beginIndex" value="0" />
</c:if>

<c:set var="order" value="${requestScope.orderInCart}" />

<flow:ifEnabled feature="Analytics">
	<c:if test="${userType == 'R' && WCParam.showRegTag == 'T'}">
		<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Analytics.js"/>"></script>
		<script type="text/JavaScript">
			dojo.addOnLoad(function() { analyticsJS.publishShopCartLoginTags(); });
		</script>
	</c:if>
</flow:ifEnabled>

<c:if test="${empty order || order==null}">
	<wcf:getData type="com.ibm.commerce.order.facade.datatypes.OrderType"
		var="order" expressionBuilder="findCurrentShoppingCartWithPagingOnItem" varShowVerb="ShowVerbShipment" maxItems="${pageSize}" recordSetStartNumber="${beginIndex}" recordSetReferenceId="ostatus" scope="request">
		<wcf:param name="accessProfile" value="IBM_Details" />	 
		<wcf:param name="sortOrderItemBy" value="orderItemID" />
		<wcf:param name="isSummary" value="false" />
	</wcf:getData>
</c:if>


<c:if test="${empty order.orderItem && beginIndex >= pageSize}">
	<c:set var="beginIndex" value="${beginIndex - pageSize}" />
	<wcf:getData type="com.ibm.commerce.order.facade.datatypes.OrderType"
		var="order" expressionBuilder="findCurrentShoppingCartWithPagingOnItem" varShowVerb="ShowVerbShipment" maxItems="${pageSize}" recordSetStartNumber="${beginIndex}" recordSetReferenceId="ostatus" scope="request">
		<wcf:param name="accessProfile" value="IBM_Details" />	 
		<wcf:param name="sortOrderItemBy" value="orderItemID" />
		<wcf:param name="isSummary" value="true" />
	</wcf:getData>
</c:if>

<c:if test="${beginIndex == 0}">
	<c:if test="${ShowVerbShipment.recordSetTotal > ShowVerbShipment.recordSetCount}">		
		<c:set var="pageSize" value="${ShowVerbShipment.recordSetCount}" />
	</c:if>
</c:if>	

<c:set var="orderInCart" value="${requestScope.orderInCart}" />
<c:if test="${empty orderInCart || orderInCart==null}">
	<c:set var="orderInCart" value="${order}" scope="request"/>
	<c:if test="${empty orderInCart || orderInCart==null}">
   
		<wcf:getData type="com.ibm.commerce.order.facade.datatypes.OrderType"
					var="orderInCart" expressionBuilder="findCurrentShoppingCartWithPagingOnItem" varShowVerb="ShowVerbCart" maxItems="${maxOrderItemsToInspect}" recordSetStartNumber="0" recordSetReferenceId="headerorder" scope="request">
			<wcf:param name="accessProfile" value="IBM_Details" />	 
			<wcf:param name="sortOrderItemBy" value="orderItemID" />
			<wcf:param name="isSummary" value="true" />
		</wcf:getData>
	</c:if>
</c:if>

<c:if test="${!empty order.orderItem}">

	<c:set var="forceShipmentType" value=""/>
	<c:if test="${!empty param.forceShipmentType}">
		<c:set var="forceShipmentType" value="${param.forceShipmentType}"/>
	</c:if>
	<c:if test="${!empty WCParam.forceShipmentType}">
		<c:set var="forceShipmentType" value="${WCParam.forceShipmentType}"/>
	</c:if>

	<flow:ifDisabled  feature="MultipleShipments">
		<c:set var="forceShipmentType" value="1"/>
	</flow:ifDisabled>

	<c:choose>
		<c:when test="${forceShipmentType == 1}">
			<c:set var="shipmentTypeId" value="1"/>
		</c:when>
		<c:when test="${forceShipmentType == 2}">
			<c:set var="shipmentTypeId" value="2"/>
		</c:when>
		<c:otherwise>
			<c:choose>
				<c:when test="${ShowVerbShipment.recordSetTotal > maxOrderItemsToInspect}">
					<c:set var="shipmentTypeId" value="2"/>
				</c:when>
				<c:otherwise>
					<jsp:useBean id="blockMap" class="java.util.HashMap" scope="request"/>
					<c:forEach var="orderItem" items="${orderInCart.orderItem}" varStatus="status">
						<c:set var = "itemId" value="${orderItem.orderItemIdentifier.uniqueID}"/>
						<c:set var ="addressId" value = "${orderItem.orderItemShippingInfo.shippingAddress.contactInfoIdentifier.uniqueID}"/>
						<c:set var ="shipModeId" value= "${orderItem.orderItemShippingInfo.shippingMode.shippingModeIdentifier.uniqueID}"/>
						<c:set var = "keyVar" value="${addressId}_${shipModeId}"/>
						<c:set var = "itemIds" value="${blockMap[keyVar]}"/>
						<c:choose>
							<c:when test="${empty itemIds}">
								<c:set target="${blockMap}" property="${keyVar}" value="${itemId}"/>
							</c:when>       
							<c:otherwise>
								<c:set target="${blockMap}" property="${keyVar}" value="${itemIds},${itemId}"/>
							</c:otherwise>       
						</c:choose>       
					</c:forEach>
					<c:choose>
						<c:when test = "${fn:length(blockMap) == 1}">
							<c:set var="shipmentTypeId" value="1"/>
						</c:when>
						<c:otherwise>
							<c:set var="shipmentTypeId" value="2"/>
						</c:otherwise>
					</c:choose>
				</c:otherwise>
			</c:choose>
		</c:otherwise>
	</c:choose>
</c:if>
			
<c:choose>
	<c:when test="${b2bStore || shipmentTypeId == 2}">
		<c:set var="maxItems" value="${pageSize}"/>
	</c:when>
	<c:otherwise>
		<c:set var="maxItems" value="1"/>
	</c:otherwise>
</c:choose>

<%-- The below getdata statment for UsableShippingInf can be removed if the order services can return order details and shipping details in same service call --%>
<wcf:getData type="com.ibm.commerce.order.facade.datatypes.OrderType"
	var="orderUsableShipping" expressionBuilder="findUsableShippingInfoWithPagingOnItem" varShowVerb="ShowVerbUsableShippingInfo" maxItems="${maxItems}" recordSetStartNumber="${beginIndex}" recordSetReferenceId="usistatus" scope="request">
	<wcf:param name="orderId" value="${order.orderIdentifier.uniqueID}" />	
	<wcf:param name="accessProfile" value="IBM_UsableShippingInfo" />
</wcf:getData>

<%-- Since this is the online shopping checkout path, we must make sure that none of the order items are using the 'PickUpInStore' shipping mode. --%>
<c:if test="${!empty orderInCart.orderItem}" >
	<c:set var="invalidShipModeIdForOnline" value="false"/>
	<c:forEach var="orderItem" items="${orderInCart.orderItem}" varStatus="status">
		<c:if test="${!invalidShipModeIdForOnline}">
			<c:if test="${orderItem.orderItemShippingInfo.shippingMode.shippingModeIdentifier.externalIdentifier.shipModeCode == 'PickupInStore'}">
				<c:set var="invalidShipModeIdForOnline" value="true"/>
			</c:if>
		</c:if>
	</c:forEach>
</c:if>

<%-- Determine a valid online shipping mode identifier if required --%>
<c:set var="doneLoop" value="false"/>
<c:forEach items="${orderUsableShipping.orderItem}" var="curOrderItem">
	<c:if test="${not doneLoop}">
		<c:forEach items="${curOrderItem.usableShippingMode}" var="curShipmode">
			<c:if test="${not doneLoop}">
				<c:if test="${curShipmode.shippingModeIdentifier.externalIdentifier.shipModeCode != 'PickupInStore'}">
					<c:set var="doneLoop" value="true"/>
					<c:set var="validOnlineShipmodeId" value="${curShipmode.shippingModeIdentifier.uniqueID}"/>
				</c:if>
			</c:if>
		</c:forEach>
	</c:if>
</c:forEach>


<wcf:getData type="com.ibm.commerce.order.facade.datatypes.OrderType"
	var="usablePayments" expressionBuilder="findCurrentShoppingCart" scope="request">
	<wcf:param name="accessProfile" value="IBM_UsablePaymentInfo" />
</wcf:getData>

<c:forEach var="usableAddress" items="${orderUsableShipping.usableShippingAddress}">
	<c:if test="${usableAddress.externalIdentifier.contactInfoNickName != profileShippingNickname && usableAddress.externalIdentifier.contactInfoNickName != profileBillingNickname}" > 
		<c:set var="validAddressId" value="true"/>
	</c:if>
</c:forEach>

<%-- Check to see if all the order items have valid addressId or not. If the addressId of order items is empty, then we
need to first assign a valid address id to these order items before proceeding with the checkout flow. --%>
<c:if test="${!empty order.orderItem}" >
	<c:set var="orderItemsHaveInvalidAddressId" value="false"/>
	<%-- Get the list of order items which have an empty addressId.--%>
	<c:forEach var="orderItem" items="${order.orderItem}" varStatus="status">
		<c:if test="${!orderItemsHaveInvalidAddressId}">
			<c:set var ="addressId" value = "${orderItem.orderItemShippingInfo.shippingAddress.contactInfoIdentifier.uniqueID}"/>
			<c:if test="${empty addressId}">
				<c:set var="orderItemsHaveInvalidAddressId" value="true"/>
			</c:if>
		</c:if>
	</c:forEach>
</c:if>

<c:set var="totalExistingPaymentMethods" value="1"/>
<c:forEach var="paymentInstance" items="${order.orderPaymentInfo.paymentInstruction}" varStatus="paymentCount">
	<c:set var="totalExistingPaymentMethods" value="${paymentCount.count}"/>
</c:forEach>

<c:set var="quickCheckoutProfileForPayment" value="${param.quickCheckoutProfileForPayment}"/>
<c:if test="${empty quickCheckoutProfileForPayment}">
	<c:set var="quickCheckoutProfileForPayment" value="${WCParam.quickCheckoutProfileForPayment}"/>
</c:if>

<c:if test="${quickCheckoutProfileForPayment}">
	<%-- we should use quick checkout profile for payment options..with quick checkout there will be only one payment method --%>
	<c:set var="totalExistingPaymentMethods" value="1"/>
</c:if>

<wcf:url var="ShippingAddressDisplayURL" value="ShippingAddressDisplayView" type="Ajax">
	<wcf:param name="langId" value="${langId}" />                                          
	<wcf:param name="storeId" value="${WCParam.storeId}" />
	<wcf:param name="catalogId" value="${WCParam.catalogId}" />
	<wcf:param name="forceShipmentType" value="1" />
</wcf:url>

<wcf:url var="ShoppingCartURL" value="OrderCalculate" type="Ajax">
	<wcf:param name="langId" value="${langId}" />
	<wcf:param name="storeId" value="${WCParam.storeId}" />
	<wcf:param name="catalogId" value="${WCParam.catalogId}" />
	<wcf:param name="URL" value="AjaxCheckoutDisplayView" />
	<wcf:param name="errorViewName" value="AjaxCheckoutDisplayView" />
	<wcf:param name="updatePrices" value="1" />
	<wcf:param name="calculationUsageId" value="-1" />
	<wcf:param name="orderId" value="." />
</wcf:url>

<wcf:url var="TraditionalShippingURL" value="OrderShippingBillingView" type="Ajax">
	<wcf:param name="langId" value="${langId}" />
	<wcf:param name="storeId" value="${WCParam.storeId}" />
	<wcf:param name="catalogId" value="${WCParam.catalogId}" />
	<wcf:param name="forceShipmentType" value="${WCParam.forceShipmentType}" />
</wcf:url>

<wcf:url var="AjaxSingleShipmentShipChargeViewURL" value="AjaxSingleShipmentShipChargeView" type="Ajax">
	<wcf:param name="storeId" value="${WCParam.storeId}"/>
	<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
	<wcf:param name="langId" value="${WCParam.langId}"/>
	<wcf:param name="orderId" value="${order.orderIdentifier.uniqueID}"/>
</wcf:url>

<wcf:url var="AjaxMultipleShipmentShipChargeViewURL" value="AjaxMultipleShipmentShipChargeView" type="Ajax">
	<wcf:param name="storeId" value="${WCParam.storeId}"/>
	<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
	<wcf:param name="langId" value="${WCParam.langId}"/>
	<wcf:param name="orderId" value="${order.orderIdentifier.uniqueID}"/>
</wcf:url>

<%-- This declares the common error messages and <c:url tags --%>
<%@ include file="CommonUtilities.jspf"%>

<%-- get the addressId --%>
<c:set var="selectedAddressId" value="${order.orderItem[0].orderItemShippingInfo.shippingAddress.contactInfoIdentifier.uniqueID}"/>
<%-- do we need to ship all items at once.. is it shipAsComplete...--%>
<c:set var="shipAsCompleteCheckBoxStatus" value="false"/>
<c:if test="${order.shipAsComplete}">
	<c:set var="shipAsCompleteCheckBoxStatus" value="true"/>
</c:if>
<c:set var="currentOrderId" value="${order.orderIdentifier.uniqueID}" />

<%-- Include controllers declarations after common contexts declarations. controllers will make a local copy of the render contexts.. so render contexts should be declared before controllers. Never declare two contexts with same id.. Even if two contexts with same id is defined, they should be defined before defining controller..Because if you declare context and controller in this order..
{context - controller - context} the controller will make a local copy of the first context declared and always refers to it.. But updateContext and other functions will refer to second context declared and so there wont be any sync between context used in code and context referred by controller..Controllers use context by value and not by reference.. --%>
<c:set var="orderPrepare" value="${param.orderPrepare}"/>
<script type="text/javascript">
	dojo.addOnLoad(function() { 
		<flow:ifEnabled feature="ShippingChargeType">
			SBControllersDeclarationJS.setShipChargeEnabled('true');
			SBControllersDeclarationJS.setControllerURL('multipleShipmentShipChargeController','<c:out value="${AjaxMultipleShipmentShipChargeViewURL}"/>');
			SBControllersDeclarationJS.setControllerURL('singleShipmentShipChargeController','<c:out value="${AjaxSingleShipmentShipChargeViewURL}"/>');
		</flow:ifEnabled>
		CheckoutHelperJS.setCommonParameters('<c:out value='${WCParam.langId}'/>','<c:out value='${WCParam.storeId}'/>','<c:out value='${WCParam.catalogId}'/>');
		CheckoutHelperJS.setSinglePageCheckout(<c:out value='${isSinglePageCheckout}'/>);
		ServicesDeclarationJS.setCommonParameters('<c:out value='${WCParam.langId}'/>','<c:out value='${WCParam.storeId}'/>','<c:out value='${WCParam.catalogId}'/>');
		SBServicesDeclarationJS.setCommonParameters('<c:out value='${WCParam.langId}'/>','<c:out value='${WCParam.storeId}'/>','<c:out value='${WCParam.catalogId}'/>');
		SBServicesDeclarationJS.orderPrepare='<c:out value='${orderPrepare}'/>';
		SBServicesDeclarationJS.setAjaxCheckOut(<c:out value='${isAjaxCheckOut}'/>);
		SBServicesDeclarationJS.setSinglePageCheckout(<c:out value='${isSinglePageCheckout}'/>);
		CommonContextsJS.setCommonParameters('<c:out value='${WCParam.langId}'/>','<c:out value='${WCParam.storeId}'/>','<c:out value='${WCParam.catalogId}'/>');
		SBControllersDeclarationJS.setAjaxCheckOut('<c:out value='${isAjaxCheckOut}'/>');
		SBControllersDeclarationJS.setSinglePageCheckout(<c:out value='${isSinglePageCheckout}'/>);
		SBControllersDeclarationJS.setControllerURL('traditionalShipmentDetailsController','<c:out value="${TraditionalAjaxShippingDetailsViewURL}"/>');
		SBControllersDeclarationJS.setControllerURL('shippingAddressSelectBoxAreaController','<c:out value="${ShippingAddressDisplayURL}"/>');
		SBControllersDeclarationJS.setControllerURL('multipleShipmentDetailsController','<c:out value="${AjaxMultipleShipmentOrderItemDetailsViewURL}"/>');
		SBControllersDeclarationJS.setControllerURL('currentOrderTotalsAreaController','<c:out value="${AjaxCurrentOrderInformationViewURL}"/>');
		SBControllersDeclarationJS.setControllerURL('billingAddressSelectBoxAreaController','<c:out value="${billingAddressDisplayURL}"/>');
		CommonContextsJS.setContextProperty('billingAddressDropDownBoxContext','billingURL1','${billingAddressDisplayURL_1}');
		CommonContextsJS.setContextProperty('billingAddressDropDownBoxContext','billingURL2','${billingAddressDisplayURL_2}');
		CommonContextsJS.setContextProperty('billingAddressDropDownBoxContext','billingURL3','${billingAddressDisplayURL_3}');
		
		<fmt:message key="ERROR_UPDATE_FIRST" var="ERROR_UPDATE_FIRST"/>
		<fmt:message key="SHOPCART_ADDED" var="SHOPCART_ADDED"/>
		<fmt:message key="SHOPCART_REMOVEITEM" var="SHOPCART_REMOVEITEM"/>
		<fmt:message key="SHIPPING_INVALID_ADDRESS" var="SHIPPING_INVALID_ADDRESS"/>
		<fmt:message key="ERROR_QUICKCHECKOUT_ADDRESS_CHANGE" var="ERROR_QUICKCHECKOUT_ADDRESS_CHANGE"/>
		<fmt:message key="REQUESTED_SHIPPING_DATE_OUT_OF_RANGE_ERROR" var="REQUESTED_SHIPPING_DATE_OUT_OF_RANGE_ERROR"/>
		<fmt:message key="ERROR_ShippingInstructions_TooLong" var="ERROR_ShippingInstructions_TooLong"/>
		<fmt:message key="PAST_DATE_ERROR" var="PAST_DATE_ERROR"/>
		<fmt:message key="SCHEDULE_ORDER_MISSING_START_DATE" var="SCHEDULE_ORDER_MISSING_START_DATE"/>
		<fmt:message key="SCHEDULE_ORDER_MISSING_FREQUENCY" var="SCHEDULE_ORDER_MISSING_FREQUENCY"/>
		<%-- Missing --%> 
		<fmt:message key="ERROR_CONTRACT_EXPIRED_GOTO_ORDER" var="ERROR_CONTRACT_EXPIRED_GOTO_ORDER"/>
		<fmt:message key="GENERICERR_MAINTEXT" var="ERROR_RETRIEVE_PRICE">                                     
			<fmt:param><fmt:message key="GENERICERR_CONTACT_US"/></fmt:param>
		</fmt:message>
		<fmt:message key="SHIP_REQUESTED_ERROR" var="SHIP_REQUESTED_ERROR"/>
		
		<%-- Missing --%>
		<fmt:message key="ERROR_SWITCH_SINGLE_SHIPMENT" var="ERROR_SWITCH_SINGLE_SHIPMENT"/>
		
		MessageHelper.setMessage("ERROR_RETRIEVE_PRICE", <wcf:json object="${ERROR_RETRIEVE_PRICE}"/>);
		MessageHelper.setMessage("ERROR_UPDATE_FIRST", <wcf:json object="${ERROR_UPDATE_FIRST}"/>);
		MessageHelper.setMessage("SHOPCART_ADDED", <wcf:json object="${SHOPCART_ADDED}"/>);
		MessageHelper.setMessage("SHOPCART_REMOVEITEM",  <wcf:json object="${SHOPCART_REMOVEITEM}"/>);
		MessageHelper.setMessage("SHIPPING_INVALID_ADDRESS", <wcf:json object="${SHIPPING_INVALID_ADDRESS}"/>);
		MessageHelper.setMessage("ERROR_QUICKCHECKOUT_ADDRESS_CHANGE", <wcf:json object="${ERROR_QUICKCHECKOUT_ADDRESS_CHANGE}"/>);
		MessageHelper.setMessage("REQUESTED_SHIPPING_DATE_OUT_OF_RANGE_ERROR", <wcf:json object="${REQUESTED_SHIPPING_DATE_OUT_OF_RANGE_ERROR}"/>);
		MessageHelper.setMessage("ERROR_ShippingInstructions_TooLong", <wcf:json object="${ERROR_ShippingInstructions_TooLong}"/>);		
		MessageHelper.setMessage("PAST_DATE_ERROR", <wcf:json object="${PAST_DATE_ERROR}"/>);
		MessageHelper.setMessage("SCHEDULE_ORDER_MISSING_START_DATE", <wcf:json object="${SCHEDULE_ORDER_MISSING_START_DATE}"/>);
		MessageHelper.setMessage("SCHEDULE_ORDER_MISSING_FREQUENCY", <wcf:json object="${SCHEDULE_ORDER_MISSING_FREQUENCY}"/>);
		MessageHelper.setMessage("ERROR_CONTRACT_EXPIRED_GOTO_ORDER", <wcf:json object="${ERROR_CONTRACT_EXPIRED_GOTO_ORDER}"/>);
		MessageHelper.setMessage("ERROR_SWITCH_SINGLE_SHIPMENT", <wcf:json object="${ERROR_SWITCH_SINGLE_SHIPMENT}"/>);
		MessageHelper.setMessage("SHIP_REQUESTED_ERROR", <wcf:json object="${SHIP_REQUESTED_ERROR}"/>);
	}); 
        
</script>
</head>
<body>
<%-- TODO to show quick info for products in the shopping cart
<%@ include file="../../Snippets/ReusableObjects/CatalogEntryQuickInfoDetails.jspf" %>--%>
<%@ include file="../../Snippets/Order/Cart/B2BOrderPricingPopup.jspf" %>

<%@ include file="../../Snippets/ReusableObjects/GiftItemInfoDetailsDisplayExt.jspf" %>
<%@ include file="../../Snippets/ReusableObjects/GiftRegistryGiftItemInfoDetailsDisplayExt.jspf" %>

<!-- Page Start -->
	<div id="page">
		<%-- This file includes the progressBar mark-up and success/error message display markup --%>
		<%@ include file="../../Common/CommonJSPFToInclude.jspf"%>
		<%@ include file="../../Widgets/QuickInfo/QuickInfoPopup.jspf" %>
		<%@ include file="../../Widgets/ShoppingList/ItemAddedPopup.jspf" %>

		<!-- Import Header Widget -->
		<div class="header_wrapper_position" id="headerWidget">
			<%out.flush();%>
			<c:import url = "${env_jspStoreDir}/Widgets/Header/Header.jsp" />
			<%out.flush();%>
		</div>
		
		<div id="OrderShippingBillingErrorArea" class="nodisplay" role="alert" aria-describedby="WC_OrderShippingBillingDetails_div_3">
			<div id="WC_OrderShippingBillingDetails_div_1">
				<div class="body" id="WC_OrderShippingBillingDetails_div_2">
					<div class="left" id="WC_OrderShippingBillingDetails_div_3">
						<fmt:message key="SHIP_PROBLEM_DESC"/>
					</div>
					<br clear="all" />
					<div class="button_align" id="WC_OrderShippingBillingDetails_div_4">
						<a role="button" class="button_primary tlignore" id="WC_OrderShippingBillingDetails_links_1" tabindex="0" href="javascript:setPageLocation('<c:out value='${ShoppingCartURL}'/>')">
							<div class="left_border"></div>
							<div class="button_text"><fmt:message key="SHIP_GO_BACK"/><span class="spanacce"><fmt:message key="Checkout_ACCE_back_shopping_cart"/></span></div>
							<div class="right_border"></div>
						</a>
					</div>
				</div>
			</div>
		</div>
 
		<c:choose>     
			<c:when test = "${empty order.orderItem}">
				<div class="content_wrapper_position" role="main">
					<div class="content_wrapper">
						<div class="content_left_shadow">
							<div class="content_right_shadow">
								<div class="main_content">
									<div class="container_full_width">
										<flow:ifEnabled feature="SharedShippingBillingPage">
											<!-- Breadcrumb Start -->
											<div id="checkout_crumb">
												<div class="crumb" id="WC_ShipmentDisplay_div_4">
													<a href="<c:out value="${ShoppingCartURL}"/>" id="WC_ShipmentDisplay_links_2">
														<span class="step_off"><fmt:message key="BCT_SHOPPING_CART"/></span>
													</a> 
													<span class="step_arrow"></span>
	
													<%--
														If validAddressId is empty, this means there are no common addresses. In Madison, users will be asked to entered addresses. 
														In Elite, since address can be set in the contracts already, we'll skip the address page and go directly to the multiple 
														shipment page if there are no common addresses. If there is a common address, the single shipment page willbe displayed.
													--%>
													<c:choose>
														<c:when test="${empty validAddressId}">
															<c:if test="${(!b2bStore && orderItemsHaveInvalidAddressId) || (b2bStore && WCParam.guestChkout == '1' )}">
															 	<span class="step_on"><fmt:message key="BCT_ADDRESS"/></span>
															 	<span class="step_arrow"></span>
														 	</c:if>
															<c:set var="highlightShippingBilling" value="step_off"/>
															<c:if test="${b2bStore && !(WCParam.guestChkout == '1')}"><c:set var="highlightShippingBilling" value="step_on"/></c:if>
														 	<span class="${highlightShippingBilling}" ><fmt:message key="BCT_SHIPPING_AND_BILLING"/></span>
														 	<span class="step_arrow"></span>
														</c:when>
														<c:otherwise>
															<span class="step_on"><fmt:message key="BCT_SHIPPING_AND_BILLING"/></span>
															<span class="step_arrow"></span>
														</c:otherwise>					
													</c:choose>
													<span class="step_off"><fmt:message key="BCT_ORDER_SUMMARY"/></span>
												</div>
											</div>
							        		<!-- Breadcrumb End -->
										</flow:ifEnabled>
	
										<flow:ifDisabled feature="SharedShippingBillingPage">
											<div id="checkout_crumb">
												<div class="crumb" id="WC_ShipmentDisplay_div_4">
													<a href="<c:out value="${ShoppingCartURL}"/>" id="WC_ShipmentDisplay_links_2">
														<span class="step_off"><fmt:message key="BCT_SHOPPING_CART"/></span>
													</a>
													<span class="step_arrow"></span>
													<c:if test="${empty validAddressId}">
														<span class="step_on"><fmt:message key="BCT_ADDRESS"/></span>
														<span class="step_arrow"></span>
														<span class="step_off"><fmt:message key="TRA_SHIPPING"/></span>
														<span class="step_arrow"></span>
														<span class="step_off"><fmt:message key="TRA_BILLING"/></span>
														<span class="step_arrow"></span>
													</c:if>
													<c:if test="${!empty validAddressId}">
														<span class="step_on"><fmt:message key="BCT_SHIPPING"/></span></a>
														<span class="step_arrow"></span>
														<span class="step_off"><fmt:message key="BCT_BILLING"/></span>
														<span class="step_arrow"></span>
													</c:if> 
													<span class="step_off"><fmt:message key="BCT_ORDER_SUMMARY"/></span>
												</div>
											</div>
										</flow:ifDisabled>

										<%-- Display Empty Shopping Cart --%>				
										<div id="box">
											<div class="myaccount_header" id="WC_UnregisteredCheckout_div_5">
												<%@ include file="../../Snippets/ReusableObjects/CheckoutTopESpotDisplay.jspf"%>
											</div>
					                                   
											<div class="body" id="WC_UnregisteredCheckout_div_9">
												<%@ include file="../../Snippets/ReusableObjects/EmptyShopCartDisplay.jspf"%> 
											</div>
											<div class="footer" id="WC_EmptyShopCartDisplay_div_10">
												<div class="left_corner" id="WC_EmptyShopCartDisplay_div_11"></div>
												<div class="left" id="WC_EmptyShopCartDisplay_div_12"></div>
												<div class="right_corner" id="WC_EmptyShopCartDisplay_div_13"></div>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</c:when>
			<c:when test="${empty validAddressId && ((!b2bStore && orderItemsHaveInvalidAddressId) || (b2bStore && WCParam.guestChkout == '1'))}" >

				<%-- Get the OrderDataBean to check whether the personal shipping address is allowed for each of the order item --%>
				<wcbase:useBean id="orderBean" classname="com.ibm.commerce.order.beans.OrderDataBean" scope="request">
					<c:set value="${order.orderIdentifier.uniqueID}" target="${orderBean}" property="orderId"/>
				</wcbase:useBean>

				<c:if test="${orderBean.personalAddressesAllowedForShipping}">                  
					<%-- User has items in shopping cart but doesnt have any valid address Id.. Redirect user to unregistered address create page first --%>
					<c:import url="/${sdb.jspStoreDir}/ShoppingArea/CheckoutSection/UnregisteredCheckout.jsp"/>                     
				</c:if>
			</c:when>
			<c:when test="${invalidShipModeIdForOnline}" >

				<%-- User has order items with 'PickUpInStore' shipping mode in the online checkout path, those need to be changed to use valid online shipping method --%>
				<%out.flush();%>
				<c:import url="/${sdb.jspStoreDir}/ShoppingArea/CheckoutSection/ShoppingCartItemsUpdateHelper.jsp">
					<c:param value="${validOnlineShipmodeId}" name="shipModeId"/>
				</c:import>
				<%out.flush();%>
			</c:when>
			<c:when test="${orderItemsHaveInvalidAddressId}" >

				<%-- User has some valid shipping addresses, but the order has some order items which do not have an addressId associated with them.
					We need to make one server call to update the addressId of those items which have empty addressId. --%>
				<c:import url="/${sdb.jspStoreDir}/ShoppingArea/CheckoutSection/ShoppingCartItemsUpdateHelper.jsp"/>
			</c:when>
			<c:otherwise>

				<%-- The controllers declaration JavaScript file will declare all the controllers without setting URL. URLs are created using <c:url tag and hence cannot be used in JS file. So we have to explicitly set the URL after including controllers...--%>
				<script type="text/javascript">
					wc.render.declareRefreshController({
						id: "editShippingAdddressAreaController",
						renderContext: wc.render.getContextById("editShippingAddressContext"),
						url: "${editAddressDisplayURL}",
						formId: ""
						,modelChangedHandler: function(message, widget) {
							if('${shipmentTypeId}' == 2){
								var controller = this;
								var renderContext = this.renderContext;
								if (message.actionId in address_updated){
									//This means, invokeService for Address Add/Edit has been called..so update our select box area
									wc.render.updateContext('contextForMainAndAddressDiv', {'showArea':'mainContents','hideArea':'editAddressContents'});
									selectedAddressId = message.addressId;
									CheckoutHelperJS.updateAddressIdOFItemsOnCreateEditAddress(selectedAddressId);
									cursor_clear();  
								} 
							}
						}
						,renderContextChangedHandler: function(message, widget) {
							var controller = this;
							var renderContext = this.renderContext;
							if (controller.testForChangedRC(["shippingAddress"])) {
								var addressId = renderContext.properties["shippingAddress"];
								//reset the addressID..so that when user selects create address next time it works properly..
								renderContext.properties["shippingAddress"] = 0;
								var addressType = renderContext.properties["addressType"];
								widget.refresh({"addressId": addressId,"addressType":addressType});
							}
						}
						,postRefreshHandler: function(widget) {
							var controller = this;
							var renderContext = this.renderContext;
							cursor_clear();
							AddressHelper.loadStatesUI('shopcartAddressForm','','stateDiv','state', true);
							TealeafWCJS.rebind("centered_single_column_form");
						}
					});
				</script>

				<div id="content_wrapper" class="content_wrapper_position" dojoType="wc.widget.RefreshArea" widgetId="content_wrapper" controllerId="controllerForMainAndAddressDiv" role="main">
					<div class="content_wrapper">
						<div class="content_left_shadow">
							<div class="content_right_shadow">
							<!-- Content Start -->
							<!-- There are two parts in the content (editAddressContents and mainContents Div)..One Div contains the entire checkoutContents (shopping cart, shipping address, billing info and other things.. The second DIV contains only edit Address page .. On click of Edit Address button, the first div will be hidden and edit address page div will be displayed...
								Instead of having both the div's in same page, we can make a call to server on click of edit button and get the edit Address page..But the problem in that case is, if user clicks on Cancel/Submit button after changing the address details, we update the server with the changes and again redirect the user to Shipping and Billing address page which results in resetting any changes made in shipping / billing details. User will loose all the changes made in shipping/billing page before clicking on edit address button..To avoid this situation we have both the DIV's defined in this page and use hide/show logic here..-->
								<div class="main_content" style="display:block">
									<div class="container_full_width">
									<flow:ifEnabled feature="SharedShippingBillingPage">
										<!-- Breadcrumb Start -->
										<div id="checkout_crumb">
											<div class="crumb" id="WC_ShipmentDisplay_div_4">
												<c:if test = "${!empty order.orderItem}">
													<a href="<c:out value="${ShoppingCartURL}"/>" id="WC_ShipmentDisplay_links_2">
														<span class="step_off"><fmt:message key="BCT_SHOPPING_CART"/></span>
													</a> 
													<span class="step_arrow"></span>
	
													<%--
														If validAddressId is empty, this means there are no common addresses. In Madison, users will be asked to entered addresses. 
														In Elite, since address can be set in the contracts already, we'll skip the address page and go directly to the multiple 
														shipment page if there are no common addresses. If there is a common address, the single shipment page willbe displayed.
													--%>
													<c:choose>
														<c:when test="${empty validAddressId}">
															<c:if test="${(!b2bStore && orderItemsHaveInvalidAddressId) || (b2bStore && WCParam.guestChkout == '1' )}">
															 	<span class="step_on"><fmt:message key="BCT_ADDRESS"/></span>
															 	<span class="step_arrow"></span>
														 	</c:if>
															<c:set var="highlightShippingBilling" value="step_off"/>
															<c:if test="${b2bStore && !(WCParam.guestChkout == '1')}"><c:set var="highlightShippingBilling" value="step_on"/></c:if>
														 	<span class="${highlightShippingBilling}" ><fmt:message key="BCT_SHIPPING_AND_BILLING"/></span>
														 	<span class="step_arrow"></span>
														</c:when>
														<c:otherwise>
															<span class="step_on"><fmt:message key="BCT_SHIPPING_AND_BILLING"/></span>
															<span class="step_arrow"></span>
														</c:otherwise>					
													</c:choose>
													<span class="step_off"><fmt:message key="BCT_ORDER_SUMMARY"/></span>
												</c:if>
											</div>
										</div>
						        		<!-- Breadcrumb End -->
									</flow:ifEnabled>

									<flow:ifDisabled feature="SharedShippingBillingPage">
										<div id="checkout_crumb">
											<div class="crumb" id="WC_ShipmentDisplay_div_4">
												<c:if test = "${!empty order.orderItem}">
													<a href="<c:out value="${ShoppingCartURL}"/>" id="WC_ShipmentDisplay_links_2">
														<span class="step_off"><fmt:message key="BCT_SHOPPING_CART"/></span>
													</a>
													<span class="step_arrow"></span>
													<c:if test="${empty validAddressId}">
														<span class="step_on"><fmt:message key="BCT_ADDRESS"/></span>
														<span class="step_arrow"></span>
														<span class="step_off"><fmt:message key="TRA_SHIPPING"/></span>
														<span class="step_arrow"></span>
														<span class="step_off"><fmt:message key="TRA_BILLING"/></span>
														<span class="step_arrow"></span>
													</c:if>
													<c:if test="${!empty validAddressId}">
														<span class="step_on"><fmt:message key="BCT_SHIPPING"/></span></a>
														<span class="step_arrow"></span>
														<span class="step_off"><fmt:message key="BCT_BILLING"/></span>
														<span class="step_arrow"></span>
													</c:if> 
													<span class="step_off"><fmt:message key="BCT_ORDER_SUMMARY"/></span>
												</c:if>
											</div>
										</div>
									</flow:ifDisabled>
									<div id="mainContents" style="display:block">
										<div id="box">                                          
											<%out.flush();%>
											<c:import url="/${sdb.jspStoreDir}/ShoppingArea/CheckoutSection/ShippingDetailsDisplay.jsp">
												<c:param value="${shipmentTypeId}" name="shipmentTypeId"/>
												<c:param value="${ShowVerbShipment.recordSetTotal}" name="recordSetTotal"/>
												<c:param value="${currentOrderId}" name="orderId"/>
											</c:import>
											<%out.flush();%>
					
											<flow:ifEnabled feature="SharedShippingBillingPage">
												<c:set var="scheduledOrderEnabled" value="false"/>
												<c:set var="recurringOrderEnabled" value="false"/>
												<flow:ifEnabled feature="ScheduleOrder">
													<c:set var="scheduledOrderEnabled" value="true"/>
												</flow:ifEnabled>
												<flow:ifEnabled feature="RecurringOrders">
													<c:set var="recurringOrderEnabled" value="true"/>
													<c:set var="cookieKey1" value="WC_recurringOrder_${currentOrderId}"/>
													<c:set var="currentOrderIsRecurringOrder" value="${cookie[cookieKey1].value}"/>
												</flow:ifEnabled>
												<c:choose>
													<c:when test="${scheduledOrderEnabled == 'true'}">
														<%out.flush();%>
														<c:import url="/${sdb.jspStoreDir}/ShoppingArea/CheckoutSection/ScheduleOrderDisplayExt.jsp">
															<c:param value="true" name="isShippingBillingPage"/>
															<c:param value="${currentOrderId}" name="orderId"/>
														</c:import>
														<%out.flush();%>
													</c:when>
													<c:when test="${recurringOrderEnabled == 'true' && currentOrderIsRecurringOrder == 'true'}">
														<%out.flush();%>
														<c:import url="/${sdb.jspStoreDir}/ShoppingArea/CheckoutSection/RecurringOrderCheckoutDisplay.jsp">
															<c:param value="true" name="isShippingBillingPage"/>
															<c:param value="${currentOrderId}" name="orderId"/>
														</c:import>
														<%out.flush();%>
													</c:when>
												</c:choose>
												<br/>&nbsp;		
			 
												<div class="main_header" id="WC_ShipmentDisplay_div_22">
													<div class="left_corner_straight" id="WC_ShipmentDisplay_div_23"></div>
													<div class="headingtext" id="WC_ShipmentDisplay_div_24"><span aria-level="1" class="main_header_text" role="heading"><fmt:message key="BILL_BILLING_INFO"/></span></div>
													<div class="right_corner_straight" id="WC_ShipmentDisplay_div_25"></div>
												</div>
		
												<!-- Display drop down box to select number of payment options.. -->
												<c:choose>
						                       		<c:when test="${isBrazilStore}">
						                       		    <!-- Allow only one payment method for the Brazil Solution -->
											   			<div class="checkout_subheader nodisplay" id="WC_ShipmentDisplay_div_26">
											   		</c:when>
											   		<c:otherwise>
											   			<div class="checkout_subheader" id="WC_ShipmentDisplay_div_26">
											   		</c:otherwise>
												</c:choose>
												<div class="left_corner" id="WC_ShipmentDisplay_div_27"></div>
												<div class="left_drop_down_shipment" id="WC_ShipmentDisplay_div_28">
													<span class="content_text"><label for="numberOfPaymentMethods"><fmt:message key="BILL_MULTIPLE_BILLING_MESSAGE"/></label>
														<select class="drop_down_billing" name="numberOfPaymentMethods" id="numberOfPaymentMethods" onchange="JavaScript:CheckoutPayments.setNumberOfPaymentMethods(<c:out value="${numberOfPaymentMethods}"/>,this,'paymentSection');CheckoutPayments.reinitializePaymentObjects(this);">
															<c:set var="selectStr" value="" />
															<c:forEach var="i" begin="1" end="${numberOfPaymentMethods}">
																<c:if test="${i == totalExistingPaymentMethods}">
																	<c:set var="selectStr" value='selected="selected"'/>
																</c:if>
																<option value="<c:out value="${i}"/>" <c:out value="${selectStr}" escapeXml="false"/>>
																	<fmt:message key="BILL_PAYMENT_OPTIONS">
																		<fmt:param value="${i}"/>
																	</fmt:message>
																</option>
																<c:set var="selectStr" value="" />
															</c:forEach>
														</select>
													</span>
												</div> <%-- Corresponds to content_header div --%>
												<div class="right_corner" id="WC_ShipmentDisplay_div_29"></div>
												</div>

												<c:set var="showPayInStore" value="false"/>
												<div class="body shipping_billing_height" id="WC_ShipmentDisplay_div_30">
													<%@ include file="CheckoutPaymentsAndBillingAddress.jspf"%>
													<%@ include file="OrderAdditionalDetailExt.jspf"%>
												</div>
											</flow:ifEnabled>

											
											<div class="button_footer_line" id="WC_ShipmentDisplay_div_32_1"> 
												<a role="button" class="button_secondary tlignore" id="WC_ShipmentDisplay_links_5" tabindex="0" href="javascript:setPageLocation('<c:out value='${ShoppingCartURL}'/>')">
													<div class="left_border"></div>
													<div class="button_text"><fmt:message key="BACK"/><span class="spanacce"><fmt:message key="Checkout_ACCE_back_shopping_cart"/></span></div>
													<div class="right_border"></div>
												</a>
												<a role="button" class="button_primary button_left_padding tlignore" id="shippingBillingPageNext" tabindex="0" href="JavaScript:setCurrentId('shippingBillingPageNext'); CheckoutPayments.processCheckout('PaymentForm');">
													<div class="left_border"></div>
													<flow:ifEnabled feature="SharedShippingBillingPage">
														<div class="button_text"><fmt:message key="NEXT"/><span class="spanacce"><fmt:message key="Checkout_ACCE_next_summary"/></span></div>
													</flow:ifEnabled>
													<flow:ifDisabled feature="SharedShippingBillingPage">
														<div class="button_text"><fmt:message key="NEXT"/><fmt:message key="Checkout_ACCE_next_bill"/></span></div>
													</flow:ifDisabled>
													<div class="right_border"></div>
												</a>
												<span class="button_right_side_message" id="WC_ShipmentDisplay_div_32_3">
													<flow:ifEnabled feature="SharedShippingBillingPage">
														<fmt:message key="ORD_MESSAGE"/>
													</flow:ifEnabled>
													<flow:ifDisabled feature="SharedShippingBillingPage">
														<fmt:message key="ORD_MESSAGE_BILLING"/>
													</flow:ifDisabled>
												</span>
											</div>
											<div class="espot_checkout_bottom" id="WC_ShipmentDisplay_div_38">
												<%@ include file="../../Snippets/ReusableObjects/CheckoutBottomESpotDisplay.jspf"%>
											</div>
										</div>
									</div>
									<!-- Edit address div -->
									<div id="editAddressContents" style="display:none">
										<!-- Start of second div in this page -->
										<span class="spanacce" id="editShippingAddressArea1_ACCE_Label"><fmt:message key="Checkout_ACCE_edit_create_address"/></span>
										<div dojoType="wc.widget.RefreshArea" id="editShippingAddressArea1" aria-labelledby="editShippingAddressArea1_ACCE_Label" widgetId="editShippingAddressArea1" controllerId="editShippingAdddressAreaController">
										</div>
										<script type="text/javascript">
											dojo.addOnLoad(function() { 
												parseWidget("editShippingAddressArea1");
											});
										</script>
									</div>
									<!-- Main Content End -->									
								</div>
							</div>
						</div>
					</div>
					<!-- Main Content End -->                           
				</div>
				<script type="text/javascript">
					dojo.addOnLoad(function() { 
						parseWidget("content_wrapper");
					});
				</script>
			</c:otherwise>
		</c:choose>
	</div>
	<!-- Footer Start -->
	<div class="footer_wrapper_position">
		<%out.flush();%>
			<c:import url = "${env_jspStoreDir}/Widgets/Footer/Footer.jsp" />
		<%out.flush();%>
	</div>
	<!-- Footer End -->
	<flow:ifEnabled feature="Analytics"><cm:pageview/></flow:ifEnabled>
</body>
</html>
<!-- END OrderShippingBillingDetails.jsp -->
