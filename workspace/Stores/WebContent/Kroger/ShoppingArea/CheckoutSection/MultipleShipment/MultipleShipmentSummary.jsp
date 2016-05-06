
<%--
  *****
  * This JSP file renders the multiple shipment order summary page of the checkout flow. It is a read only page.
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
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ taglib uri="http://commerce.ibm.com/coremetrics"  prefix="cm" %>
<%@ include file="../../../Common/EnvironmentSetup.jspf"%>
<%@ include file="../../../Common/nocache.jspf"%>
<!-- BEGIN MultipleShipmentSummary.jsp -->
<html xmlns="http://www.w3.org/1999/xhtml" lang="${shortLocale}" xml:lang="${shortLocale}">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		
		<%@ include file="../../../Common/CommonJSToInclude.jspf" %>
		
		<link rel="stylesheet" href="<c:out value="${jspStoreImgDir}${env_vfileStylesheet}"/>" type="text/css"/>
		
		<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/ServicesEventMapping.js"/>"></script>
		<script type="text/javascript" src="<c:out value='${jsAssetsDir}javascript/CheckoutArea/CheckoutHelper.js'/>"></script>
		<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/MessageHelper.js"/>"></script>
		<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/ServicesDeclaration.js"/>"></script>
		<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Common/ShoppingActions.js"/>"></script>
		
		<%-- CommonContexts must come before CommonControllers --%>
		<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/CommonContextsDeclarations.js"/>"></script>
		<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/CommonControllersDeclaration.js"/>"></script>
		
		<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Widgets/Search.js"/>"></script>
		<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Widgets/MiniShopCartDisplay/MiniShopCartDisplay.js"/>"></script>
		<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Widgets/Department/Department.js"/>"></script>
		
		<script type="text/javascript" src="${jsAssetsDir}javascript/Tealeaf/tealeafWC.js"></script>
		<c:if test="${env_Tealeaf eq 'true' && env_inPreview != 'true'}">
			<script type="text/javascript" src="${jsAssetsDir}javascript/Tealeaf/tealeaf.js"></script>
		</c:if>
		
		<title><c:out value="${storeName}"/> - <fmt:message key="TITLE_ORDER_SUMMARY"/></title>
		
		<script type="text/javascript">
			dojo.addOnLoad(function() { 
				ServicesDeclarationJS.setCommonParameters('<c:out value='${WCParam.langId}'/>','<c:out value='${WCParam.storeId}'/>','<c:out value='${WCParam.catalogId}'/>');
				CheckoutHelperJS.setCommonParameters('<c:out value='${WCParam.langId}'/>','<c:out value='${WCParam.storeId}'/>','<c:out value='${WCParam.catalogId}'/>');
				CheckoutHelperJS.initializeShipmentPage('2');
				
				<fmt:message key="PO_Number" var="PO_Number"/>
				<fmt:message key="ERROR_PONumberEmpty" var="ERROR_PONumberEmpty"/>
				<fmt:message key="ERROR_PONumberTooLong" var="ERROR_PONumberTooLong"/>
				<fmt:message key="ERROR_GUEST_USER_SUBMIT_RECURRING_ORDER" var="ERROR_GUEST_USER_SUBMIT_RECURRING_ORDER"/>
				<fmt:message key="EDPPaymentMethods_CANNOT_RECONCILE_PAYMENT_AMT" var="EDPPaymentMethods_CANNOT_RECONCILE_PAYMENT_AMT"/>
				<fmt:message key="EDPPaymentMethods_PAYMENT_AMOUNT_LARGER_THAN_ORDER_AMOUNT" var="EDPPaymentMethods_PAYMENT_AMOUNT_LARGER_THAN_ORDER_AMOUNT"/>
				<fmt:message key="EDPPaymentMethods_PAYMENT_AMOUNT_PROBLEM" var="EDPPaymentMethods_PAYMENT_AMOUNT_PROBLEM"/>
				
				MessageHelper.setMessage("PO_NUMBER", <wcf:json object="${PO_Number}"/>);
				MessageHelper.setMessage("ERROR_PONumberEmpty", <wcf:json object="${ERROR_PONumberEmpty}"/>);
				MessageHelper.setMessage("ERROR_PONumberTooLong", <wcf:json object="${ERROR_PONumberTooLong}"/>);
				MessageHelper.setMessage("ERROR_GUEST_USER_SUBMIT_RECURRING_ORDER", <wcf:json object="${ERROR_GUEST_USER_SUBMIT_RECURRING_ORDER}"/>);
				MessageHelper.setMessage("EDPPaymentMethods_CANNOT_RECONCILE_PAYMENT_AMT", <wcf:json object="${EDPPaymentMethods_CANNOT_RECONCILE_PAYMENT_AMT}"/>);
				MessageHelper.setMessage("EDPPaymentMethods_PAYMENT_AMOUNT_LARGER_THAN_ORDER_AMOUNT", <wcf:json object="${EDPPaymentMethods_PAYMENT_AMOUNT_LARGER_THAN_ORDER_AMOUNT}"/>);
				MessageHelper.setMessage("EDPPaymentMethods_PAYMENT_AMOUNT_PROBLEM", <wcf:json object="${EDPPaymentMethods_PAYMENT_AMOUNT_PROBLEM}"/>);
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
		
		<c:if test="${beginIndex == 0}">
			<c:if test="${ShowVerbSummary.recordSetTotal > ShowVerbSummary.recordSetCount}">		
				<c:set var="pageSize" value="${ShowVerbSummary.recordSetCount}" />
			</c:if>
		</c:if>
		
		<wcf:getData type="com.ibm.commerce.member.facade.datatypes.PersonType" var="person" expressionBuilder="findCurrentPerson">
			<wcf:param name="accessProfile" value="IBM_All" />
		</wcf:getData>
		
		<c:set var="personAddresses" value="${person.addressBook}"/>
		
		<c:set var="numberOfPaymentMethods" value="${fn:length(order.orderPaymentInfo.paymentInstruction)}"/>
		
		<wcf:url var="ShoppingCartURL" value="AjaxCheckoutDisplayView" type="Ajax">
			<wcf:param name="langId" value="${langId}" />						
			<wcf:param name="storeId" value="${WCParam.storeId}" />
			<wcf:param name="catalogId" value="${WCParam.catalogId}" />
		</wcf:url>
		
		<wcf:url var="AddressURL" value="AjaxUnregisteredCheckoutAddressForm" type="Ajax">
			<wcf:param name="langId" value="${langId}" />						
			<wcf:param name="storeId" value="${WCParam.storeId}" />
			<wcf:param name="catalogId" value="${WCParam.catalogId}" />
		</wcf:url>
		
		<wcf:url var="ShippingAndBillingURL" value="OrderShippingBillingView" type="Ajax">
			<wcf:param name="langId" value="${langId}" />						
			<wcf:param name="storeId" value="${WCParam.storeId}" />
			<wcf:param name="catalogId" value="${WCParam.catalogId}" />
			<wcf:param name="forceShipmentType" value="2" />
			<wcf:param name="purchaseorder_id" value="${WCParam.purchaseorder_id}"/>
		</wcf:url>
		
		<wcf:url var="TraditionalShippingURL" value="OrderShippingBillingView" type="Ajax">
			<wcf:param name="langId" value="${langId}" />						
			<wcf:param name="storeId" value="${WCParam.storeId}" />
			<wcf:param name="catalogId" value="${WCParam.catalogId}" />
			<wcf:param name="forceShipmentType" value="2" />
		</wcf:url>

		<wcf:url var="TraditionalBillingURL" value="OrderBillingView" type="Ajax">
			<wcf:param name="langId" value="${langId}" />						
			<wcf:param name="storeId" value="${WCParam.storeId}" />
			<wcf:param name="catalogId" value="${WCParam.catalogId}" />
			<wcf:param name="forceShipmentType" value="2" />
			<c:if test="${WCParam.purchaseorder_id != null}">
				<wcf:param name="purchaseorder_id" value="${WCParam.purchaseorder_id}"/>
			</c:if>
		</wcf:url>

		<c:set var="shipInstructions" value="${order.orderItem[0].orderItemShippingInfo.shippingInstruction}"/>
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
				<div class="content_wrapper">
					<div class="content_left_shadow">
						<div class="content_right_shadow">
							<div class="main_content">
								<div class="container_full_width">
									<!-- Breadcrumb Start -->
									<div id="checkout_crumb">				
										<div class="crumb" id="WC_MultipleShipmentSummary_div_4">
											<a href="<c:out value="${ShoppingCartURL}"/>" id="WC_MultipleShipmentSummary_link_2">
												<span class="step_off"><fmt:message key="BCT_SHOPPING_CART"/></span>
											</a>
											<span class="step_arrow"></span>
											<flow:ifEnabled feature="SharedShippingBillingPage">
												<a href="<c:out value="${ShippingAndBillingURL}"/>" id="WC_MultipleShipmentSummary_link_3">
													<span class="step_off"><fmt:message key="BCT_SHIPPING_AND_BILLING"/></span>
												</a>
												<span class="step_arrow"></span>
											</flow:ifEnabled>
						
											<flow:ifDisabled feature="SharedShippingBillingPage">
												<a href="<c:out value="${TraditionalShippingURL}"/>" id="WC_SingleShipmentSummary_links_3a">
													<span class="step_off"><fmt:message key="BCT_SHIPPING"/></span>
												</a>
												<span class="step_arrow"></span>
												<a href="<c:out value="${TraditionalBillingURL}"/>" id="WC_SingleShipmentSummary_links_3b">
													<span class="step_off"><fmt:message key="BCT_BILLING"/></span>
												</a>
												<span class="step_arrow"></span>
											</flow:ifDisabled>
											<span class="step_on"><fmt:message key="BCT_ORDER_SUMMARY"/></span>
										</div>
									</div>
									<!-- Breadcrumb End -->
				
									<!-- Content Start -->
									<div id="box">
										<div class="main_header" id="WC_MultipleShipmentSummary_div_5">
											<div class="left_corner" id="WC_MultipleShipmentSummary_div_6"></div>
											<div class="left" id="WC_MultipleShipmentSummary_div_7"><span aria-level="1" class="main_header_text" role="heading"><fmt:message key="BCT_SHIPPING_INFO"/></span></div>
											<div class="right_corner" id="WC_MultipleShipmentSummary_div_8"></div>
											<%@ include file="../../../Snippets/ReusableObjects/CheckoutTopESpotDisplay.jspf"%>											
										</div>
										<div class="contentline" id="WC_MultipleShipmentSummary_div_9"></div>
										<div class="body left" id="WC_MultipleShipmentSummary_div_13">
											<div id="shipping">
												<div class="shipping_method" id="WC_MultipleShipmentSummary_div_14">
													<p>
														<flow:ifEnabled feature="ShipAsComplete">
															<span class="title"><fmt:message key="SHIP_SHIP_AS_COMPLETE"/>:</span>
															<c:if test='${order.shipAsComplete}'>
																<span class="text"><fmt:message key="YES"/></span>
															</c:if>
															<c:if test='${!order.shipAsComplete}'>
																<span class="text"><fmt:message key="NO"/></span>
															</c:if>
														</flow:ifEnabled>
													</p>
												</div>

												<%-- Declare the refresh area for the order items table and bind it to the paging controller --%>
												<span id="MSOrderItemPagingDisplay_ACCE_Label" class="spanacce"><fmt:message key="ACCE_Region_Order_Item_List"/></span>
												<div dojoType="wc.widget.RefreshArea" class="shipping_billing_img_padding" widgetId="MSOrderItemPagingDisplay" id="MSOrderItemPagingDisplay" controllerId="MSOrderItemPaginationDisplayController" ariaMessage="<fmt:message key="ACCE_Status_Order_Item_List_Updated"/>" ariaLiveId="${ariaMessageNode}" role="region" aria-labelledby="MSOrderItemPagingDisplay_ACCE_Label">
													<%out.flush();%>
													<c:import url="/${sdb.jspStoreDir}/ShoppingArea/CheckoutSection/MultipleShipment/MSOrderItemDetailSummary.jsp"> 
														<c:param name="catalogId" value="${WCParam.catalogId}" />
														<c:param name="langId" value="${WCParam.langId}" />
														<c:param name="storeId" value="${WCParam.storeId}" />
														<c:param name="orderPage" value="summary" />
													</c:import>
													<%out.flush();%>
												</div>
												<script type="text/javascript">dojo.addOnLoad(function() { 
													parseWidget("MSOrderItemPagingDisplay"); 
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
										<br/>&nbsp;
										<div class="main_header" id="WC_MultipleShipmentSummary_div_20">
											<div class="left_corner_straight" id="WC_MultipleShipmentSummary_div_21"></div>
											<div class="left" id="WC_MultipleShipmentSummary_div_22"><span aria-level="1" class="main_header_text" role="heading"><fmt:message key="BILL_BILLING_INFO"/></span></div>
											<div class="right_corner_straight" id="WC_MultipleShipmentSummary_div_23"></div>
										</div>
								
										<div class="contentline" id="WC_MultipleShipmentSummary_div_24"></div>
			
										<c:set var="PurchaseOrderEntryField" value="true"/>
										<c:if test="${!empty order}">
											<%@ include file="../CheckoutPaymentAndBillingAddressSummary.jspf" %>
											<%@ include file="../OrderAdditionalDetailSummaryExt.jspf" %>
										</c:if>
										
										<div class="button_footer_line" id="WC_MultipleShipmentSummary_div_30_1">
											<flow:ifEnabled feature="SharedShippingBillingPage">
												<a role="button" class="button_secondary tlignore" id="WC_MultipleShipmentSummary_link_4" tabindex="0" href="javascript:setPageLocation('<c:out value="${ShippingAndBillingURL}"/>')">
													<div class="left_border"></div>
													<div class="button_text"><fmt:message key="BACK"/><span class="spanacce"><fmt:message key="Checkout_ACCE_back_ship_bill"/></span></div>												
													<div class="right_border"></div>
												</a>
											</flow:ifEnabled>
											<flow:ifDisabled feature="SharedShippingBillingPage">
												<a role="button" class="button_secondary tlignore" id="WC_MultipleShipmentSummary_link_4a" tabindex="0" href="javascript:setPageLocation('<c:out value="${TraditionalBillingURL}"/>')">
													<div class="left_border"></div>
													<div class="button_text"><fmt:message key="BACK"/><span class="spanacce"><fmt:message key="Checkout_ACCE_back_ship_bill"/></span></div>												
													<div class="right_border"></div>
												</a>		
											</flow:ifDisabled>

											<c:choose>
												<c:when test="${isOrderScheduled}">
													<a role="button" class="button_primary button_left_padding tlignore" id="singleOrderSummary" tabindex="0" href="javascript:setCurrentId('singleOrderSummary'); CheckoutHelperJS.scheduleOrder(<c:out value='${order.orderIdentifier.uniqueID}'/>,<c:out value='${recurringOrderEnabled}'/>,'<c:out value='${userType}'/>')">
														<div class="left_border"></div>
														<div class="button_text">
															<c:choose>
																<c:when test="${scheduledOrderEnabled == 'true'}">
																	<fmt:message key="SCHEDULE_ORDER_HEADER"/>
																</c:when>
																<c:otherwise>
																	<fmt:message key="ORDER"/>
																</c:otherwise>
														 	</c:choose>
														 </div>
														<div class="right_border"></div>
													</a>														
												</c:when>
												<c:otherwise>
													<a role="button" class="button_primary button_left_padding tlignore" id="WC_MultipleShipmentSummary_link_5" tabindex="0" href="javascript:setCurrentId('WC_MultipleShipmentSummary_link_5'); CheckoutHelperJS.checkoutOrder(<c:out value="${order.orderIdentifier.uniqueID}"/>,'<c:out value='${userType}'/>','<c:out value='${addressListForMailNotification}'/>')">
														<div class="left_border"></div>
														<div class="button_text"><fmt:message key="ORDER"/></div>												
														<div class="right_border"></div>
													</a>
													<flow:ifEnabled feature="EnableQuotes">
														<a role="button" class="button_primary button_left_padding tlignore" id="WC_MultipleShipmentSummary_link_6" tabindex="0" href="javascript:setCurrentId('WC_MultipleShipmentSummary_link_6'); CheckoutHelperJS.checkoutOrder(<c:out value="${order.orderIdentifier.uniqueID}"/>,'<c:out value='${userType}'/>','<c:out value='${addressListForMailNotification}'/>', true)">
															<div class="left_border"></div>
															<div class="button_text"><fmt:message key="CREATE_QUOTE"/></div>												
															<div class="right_border"></div>
														</a>
													</flow:ifEnabled>
												</c:otherwise>
											</c:choose>
											<%@ include file="MultipleShipmentSummaryEIExt.jspf" %>
										</div>
										<div class="right_corner" id="WC_MultipleShipmentSummary_div_35"></div>
										<div class="espot_checkout_bottom" id="WC_MultipleShipmentSummary_div_36">
											<%@ include file="../../../Snippets/ReusableObjects/CheckoutBottomESpotDisplay.jspf"%>
										</div>
									</div>
								</div>
							</div>
							<!-- Content End -->
						</div>
						<!-- Main Content End -->
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
<!-- END MultipleShipmentSummary.jsp -->
