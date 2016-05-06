<%-- 
  *****
  * This JSP file is used to render the single shipment order summary page of the checkout flow.
  * It displays a read only version of the shipping and billing page to allow shoppers to review
  * the shopping cart information before submitting the order for processing.
  *****
--%>

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

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="http://commerce.ibm.com/coremetrics"  prefix="cm" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ include file="../../../Common/EnvironmentSetup.jspf"%>
<%@ include file="../../../Common/nocache.jspf"%>
<!-- BEGIN SingleShipmentSummary.jsp -->
<html xmlns="http://www.w3.org/1999/xhtml" lang="${shortLocale}" xml:lang="${shortLocale}">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<%@ include file="../../../Common/CommonJSToInclude.jspf" %>		
			
		<link rel="stylesheet" href="<c:out value="${jspStoreImgDir}${env_vfileStylesheet}"/>" type="text/css"/>
		
		<%-- CommonContexts must come before CommonControllers --%>
		<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/CommonContextsDeclarations.js"/>"></script>
		<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/CommonControllersDeclaration.js"/>"></script>
		
		<script type="text/javascript" src="<c:out value="${jsAssetsDir}/javascript/Widgets/Search.js"/>"></script>
		<script type="text/javascript" src="<c:out value="${jsAssetsDir}/javascript/Widgets/MiniShopCartDisplay/MiniShopCartDisplay.js"/>"></script>
		<script type="text/javascript" src="<c:out value="${jsAssetsDir}/javascript/Widgets/Department/Department.js"/>"></script>
			
		<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/ServicesEventMapping.js"/>"></script>
		<script type="text/javascript" src="<c:out value='${jsAssetsDir}javascript/CheckoutArea/CheckoutHelper.js'/>"></script>
		<script type="text/javascript" src="<c:out value='${jsAssetsDir}javascript/MessageHelper.js'/>"></script>
		<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/ServicesDeclaration.js"/>"></script>
		<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Common/ShoppingActions.js"/>"></script>
		
		<script type="text/javascript" src="${jsAssetsDir}javascript/Tealeaf/tealeafWC.js"></script>
		<c:if test="${env_Tealeaf eq 'true' && env_inPreview != 'true'}">
			<script type="text/javascript" src="${jsAssetsDir}javascript/Tealeaf/tealeaf.js"></script>
		</c:if>

		<title><c:out value="${storeName}"/> - <fmt:message key="TITLE_ORDER_SUMMARY" /></title>
		
		<script type="text/javascript">
			dojo.addOnLoad(function() { 
				<fmt:message key="ERROR_EmailEmpty" var="ERROR_EmailEmpty"/>
				<fmt:message key="ERROR_INVALIDEMAILFORMAT" var="ERROR_INVALIDEMAILFORMAT"/>
				<fmt:message key="ERROR_EmailTooLong" var="ERROR_EmailTooLong"/>
				<fmt:message key="ERROR_MESSAGE_TYPE" var="ERROR_MESSAGE_TYPE"/>
				<%-- Missing --%>
				<fmt:message key="PO_Number" var="PO_Number"/>
				<%-- Missing --%>
				<fmt:message key="ERROR_PONumberEmpty" var="ERROR_PONumberEmpty"/>
				<%-- Missing --%>
				<fmt:message key="ERROR_PONumberTooLong" var="ERROR_PONumberTooLong"/>
				<fmt:message key="ERROR_GUEST_USER_SUBMIT_RECURRING_ORDER" var="ERROR_GUEST_USER_SUBMIT_RECURRING_ORDER"/>
				<fmt:message key="EDPPaymentMethods_CANNOT_RECONCILE_PAYMENT_AMT" var="EDPPaymentMethods_CANNOT_RECONCILE_PAYMENT_AMT"/>
				<fmt:message key="EDPPaymentMethods_PAYMENT_AMOUNT_LARGER_THAN_ORDER_AMOUNT" var="EDPPaymentMethods_PAYMENT_AMOUNT_LARGER_THAN_ORDER_AMOUNT"/>
				<fmt:message key="EDPPaymentMethods_PAYMENT_AMOUNT_PROBLEM" var="EDPPaymentMethods_PAYMENT_AMOUNT_PROBLEM"/>
			
                MessageHelper.setMessage("ERROR_EmailEmpty", <wcf:json object="${ERROR_EmailEmpty}"/>);
                MessageHelper.setMessage("ERROR_INVALIDEMAILFORMAT", <wcf:json object="${ERROR_INVALIDEMAILFORMAT}"/>);
                MessageHelper.setMessage("ERROR_EmailTooLong", <wcf:json object="${ERROR_EmailTooLong}"/>);
				MessageHelper.setMessage("ERROR_MESSAGE_TYPE", <wcf:json object="${ERROR_MESSAGE_TYPE}"/>);
				MessageHelper.setMessage("PO_NUMBER", <wcf:json object="${PO_Number}"/>);
				MessageHelper.setMessage("ERROR_PONumberEmpty", <wcf:json object="${ERROR_PONumberEmpty}"/>);
				MessageHelper.setMessage("ERROR_PONumberTooLong", <wcf:json object="${ERROR_PONumberTooLong}"/>);
				MessageHelper.setMessage("ERROR_GUEST_USER_SUBMIT_RECURRING_ORDER", <wcf:json object="${ERROR_GUEST_USER_SUBMIT_RECURRING_ORDER}"/>);
				MessageHelper.setMessage("EDPPaymentMethods_CANNOT_RECONCILE_PAYMENT_AMT", <wcf:json object="${EDPPaymentMethods_CANNOT_RECONCILE_PAYMENT_AMT}"/>);
				MessageHelper.setMessage("EDPPaymentMethods_PAYMENT_AMOUNT_LARGER_THAN_ORDER_AMOUNT", <wcf:json object="${EDPPaymentMethods_PAYMENT_AMOUNT_LARGER_THAN_ORDER_AMOUNT}"/>);
				MessageHelper.setMessage("EDPPaymentMethods_PAYMENT_AMOUNT_PROBLEM", <wcf:json object="${EDPPaymentMethods_PAYMENT_AMOUNT_PROBLEM}"/>);
				
				ServicesDeclarationJS.setCommonParameters('<c:out value='${WCParam.langId}'/>','<c:out value='${WCParam.storeId}'/>','<c:out value='${WCParam.catalogId}'/>');
				CheckoutHelperJS.setCommonParameters('<c:out value='${WCParam.langId}'/>','<c:out value='${WCParam.storeId}'/>','<c:out value='${WCParam.catalogId}'/>');
				CheckoutHelperJS.initializeShipmentPage('1');
			});
		</script>
		
		<c:set var="pageSize" value="${WCParam.pageSize}" />
		<c:if test="${empty pageSize}">
			<c:set var="pageSize" value="${maxOrderItemsPerPage}"/>
		</c:if>	
		
		<%-- Index to begin the order item paging with --%>			
		<c:set var="beginIndex" value="${WCParam.beginIndex}" />
		<c:if test="${empty beginIndex}">
			<c:set var="beginIndex" value="0" />
		</c:if> 
		
		<wcf:getData type="com.ibm.commerce.order.facade.datatypes.OrderType"
		var="order" expressionBuilder="findCurrentShoppingCartWithPagingOnItem" varShowVerb = "ShowVerbSummary" maxItems="${pageSize}" recordSetStartNumber="${beginIndex}" recordSetReferenceId="summarystatus" scope="request">
			<wcf:param name="accessProfile" value="IBM_Details" />
			<wcf:param name="sortOrderItemBy" value="orderItemID" />
			<wcf:param name="isSummary" value="false" />
		</wcf:getData>
		
		<script type="text/javascript">
			dojo.addOnLoad(function() { 
				CheckoutHelperJS.setOrderPrepared('<c:out value='${order.orderStatus.prepareIndicator}'/>');
				CheckoutHelperJS.setOrderPayments('<c:out value='${order.orderAmount.grandTotal.value}'/>', <wcf:json object='${order.orderPaymentInfo.paymentInstruction}'/>);
			});
		</script>
		
		<wcf:getData type="com.ibm.commerce.member.facade.datatypes.PersonType" var="person" expressionBuilder="findCurrentPerson">
			<wcf:param name="accessProfile" value="IBM_All" />
		</wcf:getData>
		
		<c:set var="personAddresses" value="${person.addressBook}"/>	
		<c:set var="numberOfPaymentMethods" value="${fn:length(order.orderPaymentInfo.paymentInstruction)}"/>
		
		<wcf:url var="shopViewURL" value="AjaxCheckoutDisplayView"></wcf:url>
		<wcf:url var="ShoppingCartURL" value="OrderCalculate" type="Ajax">
			<wcf:param name="langId" value="${langId}" />
			<wcf:param name="storeId" value="${WCParam.storeId}" />
			<wcf:param name="catalogId" value="${WCParam.catalogId}" />
			<wcf:param name="URL" value="${shopViewURL}" />
			<wcf:param name="errorViewName" value="AjaxCheckoutDisplayView" />
			<wcf:param name="updatePrices" value="1" />
			<wcf:param name="calculationUsageId" value="-1" />
			<wcf:param name="orderId" value="." />
		</wcf:url>
		
		<wcf:url var="AddressURL" value="AjaxUnregisteredCheckoutAddressForm" type="Ajax">
			<wcf:param name="langId" value="${langId}" />						
			<wcf:param name="storeId" value="${WCParam.storeId}" />
			<wcf:param name="catalogId" value="${WCParam.catalogId}" />
		</wcf:url>
		
		<c:set var="isOrderScheduled" value="false" scope="request"/>
		<c:set var="scheduledOrderEnabled" value="false"/>
		<c:set var="recurringOrderEnabled" value="false"/>
		<flow:ifEnabled feature="ScheduleOrder">
			<c:set var="scheduledOrderEnabled" value="true"/>
		</flow:ifEnabled>
		<flow:ifEnabled feature="RecurringOrders">
			<c:set var="recurringOrderEnabled" value="true"/>
			<c:set var="cookieKey1" value="WC_recurringOrder_${order.orderIdentifier.uniqueID}"/>
			<c:set var="currentOrderIsRecurringOrder" value="${cookie[cookieKey1].value}"/>
		</flow:ifEnabled>
		<c:if test="${scheduledOrderEnabled == 'true' || recurringOrderEnabled == 'true'}">
			<c:set var="orderId" value="${order.orderIdentifier.uniqueID}"/>							
			<c:set var="key" value="WC_ScheduleOrder_${orderId}_interval"/>
			<c:set var="interval" value="${cookie[key].value}"/>							
			<c:set var="key" value="WC_ScheduleOrder_${orderId}_strStartDate"/>
			<c:set var="strStartDate" value="${cookie[key].value}"/>
			
			<c:if test="${interval != null && strStartDate != null}">
				<c:set var="isOrderScheduled" value="true" scope="request"/>
			</c:if>
		</c:if>
	</head>
	<body>
		<%-- Page Start --%>
		<div id="page">

			<%@ include file="../../../Common/CommonJSPFToInclude.jspf"%>

			<!-- Import Header Widget -->
			<div class="header_wrapper_position" id="headerWidget">
				<%out.flush();%>
				<c:import url = "${env_jspStoreDir}/Widgets/Header/Header.jsp" />
				<%out.flush();%>
			</div>
			<!-- Header Nav End -->

			<!-- Main Content Start -->
			<div class="content_wrapper_position" role="main">
				<div class="content_wrapper" role="main">
					<div class="content_left_shadow">
						<div class="content_right_shadow">
							<div class="main_content">
								<div class="container_full_width">
									<!-- Breadcrumb Start -->
									<div id="checkout_crumb">
										<div class="crumb" id="WC_SingleShipmentSummary_div_4">
											<a href="<c:out value="${ShoppingCartURL}"/>" id="WC_SingleShipmentSummary_links_2">
												<span class="step_off"><fmt:message key="BCT_SHOPPING_CART" /></span>
											</a>
											<span class="step_arrow"></span> 
											<%@ include file="SingleShipmentSummaryBreadCrumbExt.jspf"%>
											<span class="step_on"><fmt:message key="BCT_ORDER_SUMMARY" /></span>
										</div>
									</div>
									<!-- Breadcrumb End -->
				
									<!-- Content Start -->
									<div id="box">
										<div class="main_header" id="WC_SingleShipmentSummary_div_5">
											<div class="left_corner" id="WC_SingleShipmentSummary_div_6"></div>
											<div class="left" id="WC_SingleShipmentSummary_div_7"><span aria-level="1" class="main_header_text" role="heading"><fmt:message key="BCT_SHIPPING_INFO"/></span></div>
											<div class="right_corner" id="WC_SingleShipmentSummary_div_8"></div>
											<%@ include file="../../../Snippets/ReusableObjects/CheckoutTopESpotDisplay.jspf"%>		
										</div>
										<div class="contentline" id="WC_SingleShipmentSummary_div_9"></div>
										<div class="body shipping_billing_height" id="WC_SingleShipmentSummary_div_13">
											<div id="shipping">
												<div class="shipping_address_summary" id="WC_SingleShipmentSummary_div_14">
													<p class="title"><fmt:message key="SHIP_SHIPPING_ADDRESS_COLON"/></p>
													<div id = "SingleShipmentShippingAddress" class="shipping_address_content">
														<%-- since this is just single shipment page, all the order items will have same address --%>
														<c:set var="contact" value="${order.orderItem[0].orderItemShippingInfo.shippingAddress}"/>
						
														<c:if test="${!empty contact.contactInfoIdentifier.externalIdentifier.contactInfoNickName}">
															<p class="profile"><c:choose><c:when test="${contact.contactInfoIdentifier.externalIdentifier.contactInfoNickName eq  profileShippingNickname}"><fmt:message key="QC_DEFAULT_SHIPPING" /></c:when>
															<c:when test="${contact.contactInfoIdentifier.externalIdentifier.contactInfoNickName eq  profileBillingNickname}"><fmt:message key="QC_DEFAULT_BILLING" /></c:when>
															<c:otherwise>${contact.contactInfoIdentifier.externalIdentifier.contactInfoNickName}</c:otherwise></c:choose></p>
														</c:if>
														<!-- Display shiping address of the order -->
														<%@ include file="../../../Snippets/ReusableObjects/AddressDisplay.jspf"%>
														</div>
													</div>
		
													<div class="shipping_method_summary" id="WC_SingleShipmentSummary_div_15">
														<p>
															<span class="title"><fmt:message key="SHIP_SHIPPING_METHOD_COLON" /></span>
															<span class="text shipping_method_content">
															<c:choose>
																<c:when test="${!empty order.orderItem[0].orderItemShippingInfo.shippingMode.description.value}">
																	<c:out value="${order.orderItem[0].orderItemShippingInfo.shippingMode.description.value}"/>
																</c:when>
																<c:otherwise>
																	<c:set var="shippingModeIdentifier" value="${order.orderItem[0].orderItemShippingInfo.shippingMode.shippingModeIdentifier}"/>
																	<c:out value="${shippingModeIdentifier.externalIdentifier.shipModeCode}"/>
																</c:otherwise>
															</c:choose>
															</span>
														</p>
														<br />
														
														<flow:ifEnabled feature="ShippingChargeType">
															<wcbase:useBean id="shipCharges" classname="com.ibm.commerce.order.beans.UsableShipChargesAndAccountByShipModeDataBean" scope="page">
																<c:set property="orderId" value="${order.orderIdentifier.uniqueID}" target="${shipCharges}"/>
															</wcbase:useBean>

															<c:if test="${not empty shipCharges.shipChargesByShipMode}">
																<c:forEach items="${shipCharges.shipChargesByShipMode}" var="shipCharges_shipModeData"  varStatus="counter1">
																	<c:if test="${shipCharges_shipModeData.shipModeDesc == order.orderItem[0].orderItemShippingInfo.shippingMode.description.value}">
																		<c:forEach items="${shipCharges_shipModeData.shippingChargeTypes}" var="shipCharges_data"  varStatus="counter2">
																			<c:if test="${shipCharges_data.selected}">
																				<p>
																					<%-- Missing message --%>
																					<span class="title"><fmt:message key="ShippingChargeType" />:</span>
																					<span class="text"><fmt:message key="${shipCharges_data.policyName}" /></span>
																				</p>
																				<c:if test="${shipCharges_data.carrAccntNumber != null && shipCharges_data.carrAccntNumber != ''}">
																					<p>
																						<%-- Missing message --%>
																						<span class="title"><fmt:message key="ShippingChargeAcctNum"/>:</span>
																						<span class="text"><c:out value="${shipCharges_data.carrAccntNumber}"/></span>
																					</p>
																				</c:if>
																			</c:if>
																		</c:forEach>
																	</c:if>
																</c:forEach>
															</c:if>
															<br />
														</flow:ifEnabled>

														<flow:ifEnabled feature="ShipAsComplete">
															<p class="ship_as_complete_summary">
																<span class="title"><fmt:message key="SHIP_SHIP_AS_COMPLETE_COLON" /> </span>
																<c:if test='${order.shipAsComplete}'>
																	<span class="text"><fmt:message key="YES"/></span>
																</c:if>
																<c:if test='${!order.shipAsComplete}'>
																	<span class="text"><fmt:message key="NO"/></span>
																</c:if>
															</p>
															<br />
														</flow:ifEnabled>

														<flow:ifEnabled feature="ShippingInstructions">
															<c:set var="shipInstructions" value="${order.orderItem[0].orderItemShippingInfo.shippingInstruction}"/>
															<c:if test="${!empty shipInstructions}">
																<p class="title"><fmt:message key="SHIP_SHIPPING_INSTRUCTIONS_COLON"/></p>
																<p class="text"><c:out value = "${shipInstructions}"/></p>
																<br />
															</c:if>
														</flow:ifEnabled>								

														<flow:ifEnabled feature="FutureOrders">
															<c:if test="${!isOrderScheduled}">
																<c:set var="requestedShipDate" value="${order.orderItem[0].orderItemShippingInfo.requestedShipDate}"/>
														
																<c:if test='${!empty requestedShipDate}'>
																	<c:catch>
																		<fmt:parseDate parseLocale="${dateLocale}" var="expectedShipDate" value="${requestedShipDate}" pattern="yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" timeZone="GMT"/>
																	</c:catch>
																	<c:if test="${empty expectedShipDate}">
																		<c:catch>
																			<fmt:parseDate parseLocale="${dateLocale}" var="expectedShipDate" value="${requestedShipDate}" pattern="yyyy-MM-dd'T'HH:mm:ss'Z'" timeZone="GMT"/>
																		</c:catch>
																	</c:if>
																	
																	<%-- Format the timezone retrieved from cookie since it is in decimal representation --%>
																	<%-- Convert the decimals back to the correct timezone format such as :30 and :45 --%>
																	<%-- Only .75 and .5 are converted as currently these are the only timezones with decimals --%>				
																	<c:set var="formattedTimeZone" value="${fn:replace(cookie.WC_timeoffset.value, '%2B', '+')}"/>
																	<c:set var="formattedTimeZone" value="${fn:replace(formattedTimeZone, '.75', ':45')}"/>	
																	<c:set var="formattedTimeZone" value="${fn:replace(formattedTimeZone, '.5', ':30')}"/>
																	<fmt:formatDate value="${expectedShipDate}" type="date" dateStyle="long" var="formattedDate" timeZone="${formattedTimeZone}"/>
																</c:if>
																<c:if test="${!empty formattedDate}">
																	<p>
																		<span class="title"><fmt:message key="SHIP_REQUESTED_DATE_COLON"/></span>
																		<span class="text"><c:out value="${formattedDate}"/></span>
																	</p>
																	<br />
																</c:if>
															</c:if>
														</flow:ifEnabled>
														<%@ include file="SingleShipmentSummaryExt.jspf"%>
														<%@ include file="GiftRegistrySingleShipmentSummaryExt.jspf"%>
													</div>

													<span id="OrderItemPagingDisplay_ACCE_Label" class="spanacce"><fmt:message key="ACCE_Region_Order_Item_List"/></span>
													<div dojoType="wc.widget.RefreshArea" widgetId="OrderItemPagingDisplay" id="OrderItemPagingDisplay" controllerId="OrderItemPaginationDisplayController" ariaMessage="<fmt:message key="ACCE_Status_Order_Item_List_Updated"/>" ariaLiveId="${ariaMessageNode}" role="region" aria-labelledby="OrderItemPagingDisplay_ACCE_Label">
														<%out.flush();%>
														<c:import url="/${sdb.jspStoreDir}/ShoppingArea/CheckoutSection/SingleShipment/OrderItemDetailSummary.jsp"> 
															<c:param name="catalogId" value="${WCParam.catalogId}" />
															<c:param name="langId" value="${WCParam.langId}" />
															<c:param name="storeId" value="${WCParam.storeId}" />
															<c:param name="orderPage" value="summary" />
														</c:import>
														<%out.flush();%>
													</div>
													<script type="text/javascript">
														dojo.addOnLoad(function() { 
															parseWidget("OrderItemPagingDisplay");
														});
													</script>
													<%out.flush();%>
													<c:import url="/${sdb.jspStoreDir}/ShoppingArea/CheckoutSection/SingleShipment/SingleShipmentOrderTotalsSummary.jsp"> 
														<c:param name="fromPage" value="orderSummaryPage"/>
													</c:import>
													<%out.flush();%>
												</div>
												<br clear="all" />
											</div>

											<c:choose>
												<c:when test="${scheduledOrderEnabled == 'true'}">
													<%out.flush();%>
													<c:import url="/${sdb.jspStoreDir}/ShoppingArea/CheckoutSection/ScheduleOrderDisplayExt.jsp">
														<c:param value="false" name="isShippingBillingPage"/>
														<c:param value="${order.orderIdentifier.uniqueID}" name="orderId"/>
													</c:import>
													<%out.flush();%>
												</c:when>
												<c:when test="${recurringOrderEnabled == 'true' && currentOrderIsRecurringOrder == 'true'}">
													<%out.flush();%>
													<c:import url="/${sdb.jspStoreDir}/ShoppingArea/CheckoutSection/RecurringOrderCheckoutDisplay.jsp">
														<c:param value="false" name="isShippingBillingPage"/>
														<c:param value="${order.orderIdentifier.uniqueID}" name="orderId"/>
													</c:import>
													<%out.flush();%>
												</c:when>
									 		</c:choose>

											<div class="main_header" id="WC_SingleShipmentSummary_div_21">
												<div class="left_corner_straight" id="WC_SingleShipmentSummary_div_22"></div>
												<div class="left" id="WC_SingleShipmentSummary_div_23"><span aria-level="1" class="main_header_text" role="heading"><fmt:message key="BILL_BILLING_INFO" /></span></div>
												<div class="right_corner_straight" id="WC_SingleShipmentSummary_div_24"></div>
											</div>

											<div class="contentline" id="WC_SingleShipmentSummary_div_25"></div>

											<c:set var="PurchaseOrderEntryField" value="true"/>
											<c:if test="${!empty order}">
												<%@ include file="../CheckoutPaymentAndBillingAddressSummary.jspf" %>
												<%@ include file="../OrderAdditionalDetailSummaryExt.jspf" %>
											</c:if>

											<div class="button_footer_line" id="WC_SingleShipmentSummary_div_31_1">
												<flow:ifEnabled feature="SharedShippingBillingPage">
													<a role="button" class="button_secondary tlignore" id="WC_SingleShipmentSummary_links_4" tabindex="0" href="javascript:setPageLocation('<c:out value="${ShippingAndBillingURL}"/>')">
														<div class="left_border"></div>
														<div class="button_text"><fmt:message key="BACK"/><span class="spanacce"><fmt:message key="Checkout_ACCE_back_ship_bill"/></span></div>
														<div class="right_border"></div>
													</a>
												</flow:ifEnabled>
												<flow:ifDisabled feature="SharedShippingBillingPage">
													<a role="button" class="button_secondary tlignore" id="WC_SingleShipmentSummary_links_4a" tabindex="0" href="javascript:setPageLocation('<c:out value="${TraditionalBillingURL}"/>')">
														<div class="left_border"></div>
														<div class="button_text"><fmt:message key="BACK"/><span class="spanacce"><fmt:message key="Checkout_ACCE_back_ship_bill"/></span></div>
														<div class="right_border"></div>
													</a>
												</flow:ifDisabled>
	
												<c:choose>
													<c:when test="${isOrderScheduled}">
														<a role="button" class="button_primary button_left_padding tlignore" id="singleOrderSummary" tabindex="0" href="javascript:setCurrentId('singleOrderSummary'); CheckoutHelperJS.scheduleOrder(<c:out value='${order.orderIdentifier.uniqueID}'/>,<c:out value='${recurringOrderEnabled}'/>,'<c:out value='${userType}'/>')">
															<div class="left_border"></div>
															<c:choose>
																<c:when test="${scheduledOrderEnabled == 'true'}">
																	<div class="button_text"><fmt:message key="SCHEDULE_ORDER_HEADER"/></div>												
																</c:when>
																<c:otherwise>
																	<div class="button_text"><fmt:message key="ORDER"/></div>												
																</c:otherwise>
													 		</c:choose>
															<div class="right_border"></div>
														</a>
													</c:when>
													<c:otherwise>
														<a role="button" class="button_primary button_left_padding tlignore" id="singleOrderSummary" tabindex="0" href="javascript:setCurrentId('singleOrderSummary'); CheckoutHelperJS.checkoutOrder(<c:out value="${order.orderIdentifier.uniqueID}"/>,'<c:out value='${userType}'/>','<c:out value='${addressListForMailNotification}'/>')">
															<div class="left_border"></div>
															<div class="button_text"><fmt:message key="ORDER"/></div>												
															<div class="right_border"></div>
														</a>
	
														<flow:ifEnabled feature="EnableQuotes">
															<div id="WC_SingleShipmentSummary_div_31_4">
															<a role="button" class="button_primary button_left_padding" id="singleQuoteSummary" tabindex="0" href="javascript:setCurrentId('singleQuoteSummary'); CheckoutHelperJS.checkoutOrder(<c:out value="${order.orderIdentifier.uniqueID}"/>,'<c:out value='${userType}'/>','<c:out value='${addressListForMailNotification}'/>', true)">
																	<div class="left_border"></div>
																	<div class="button_text"><fmt:message key="CREATE_QUOTE"/></div>												
																	<div class="right_border"></div>
																</a>
															</div>
														</flow:ifEnabled>
													</c:otherwise>
												</c:choose>
	
												<%@ include file="SingleShipmentSummaryEIExt.jspf" %>
											</div>
											<div class="right_corner" id="WC_SingleShipmentSummary_div_36"></div>
											<div class="espot_checkout_bottom" id="WC_SingleShipmentSummary_div_37">
													<%@ include file="../../../Snippets/ReusableObjects/CheckoutBottomESpotDisplay.jspf"%>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
				<!-- Content End -->
			</div>
			<!-- Main Content End -->
		
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
<!-- END SingleShipmentSummary.jsp -->
