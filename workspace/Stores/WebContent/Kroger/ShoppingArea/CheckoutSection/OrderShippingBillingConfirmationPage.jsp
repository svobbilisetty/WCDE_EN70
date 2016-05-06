
<%-- 
  *****
  * This JSP file is used to render the order confirmation page to the shopper right after successfully processing
  * an order. It renders a page that can be printed off by the shopper as a reference.
  *****
--%>
<!DOCTYPE HTML>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2012 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://commerce.ibm.com/coremetrics"  prefix="cm" %>
<%@ include file="../../Common/EnvironmentSetup.jspf"%>

<!-- BEGIN OrderShippingBillingConfirmationPage.jsp -->
<html xmlns="http://www.w3.org/1999/xhtml" lang="${shortLocale}" xml:lang="${shortLocale}">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<%@ include file="../../Common/CommonJSToInclude.jspf"%>
		
		
		<link rel="stylesheet" href="<c:out value="${jspStoreImgDir}${env_vfileStylesheet}"/>" type="text/css"/>
		<link rel="stylesheet" href="<c:out value="${jspStoreImgDir}${env_vfileStylesheetprint}"/>" type="text/css" media="print"/>

		<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/CheckoutArea/CheckoutHelper.js"/>"></script>
		<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/CheckoutArea/Punchout.js"/>"></script>

		<%-- CommonContexts must come before CommonControllers --%>
		<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/CommonContextsDeclarations.js"/>"></script>
		<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/CommonControllersDeclaration.js"/>"></script>
		
		<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Widgets/Search.js"/>"></script>
		<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Widgets/MiniShopCartDisplay/MiniShopCartDisplay.js"/>"></script>
		<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Widgets/Department/Department.js"/>"></script>
		<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Common/ShoppingActionsServicesDeclaration.js"/>"></script>
		<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Common/ShoppingActions.js"/>"></script>

		<flow:ifEnabled feature="IntelligentOffer">
			<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Widgets/QuickInfo/QuickInfo.js"/>"></script>
			<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Widgets/ShoppingList/ShoppingList.js"/>"></script>
			<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Widgets/ShoppingList/ShoppingListServicesDeclaration.js"/>"></script>
			<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Widgets/ShoppingList/ShoppingListControllers.js"/>"></script>
		</flow:ifEnabled> 
		
		<script type="text/javascript" src="${jsAssetsDir}javascript/Tealeaf/tealeafWC.js"></script>
		<c:if test="${env_Tealeaf eq 'true' && env_inPreview != 'true'}">
			<script type="text/javascript" src="${jsAssetsDir}javascript/Tealeaf/tealeaf.js"></script>
		</c:if>
		
		<c:choose>
			<c:when test="${WCParam.isQuote eq true}">
				<title><c:out value="${storeName}"/> - <fmt:message key="TITLE_QUOTE_CONFIRMATION"/></title>
			</c:when>
			<c:otherwise>
				<title><c:out value="${storeName}"/> - <fmt:message key="TITLE_ORDER_CONFIRMATION"/></title>
			</c:otherwise>
		</c:choose>
				
	</head>
	<body>
		<%@ include file="../../Snippets/ReusableObjects/GiftItemInfoDetailsDisplayExt.jspf" %>
		<%@ include file="../../Snippets/ReusableObjects/GiftRegistryGiftItemInfoDetailsDisplayExt.jspf" %>
		<!-- Page Start -->
		<div id="page">
			<%@ include file="../../Common/CommonJSPFToInclude.jspf"%>

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
											var="order" expressionBuilder="findByOrderIdWithPagingOnItem" varShowVerb = "ShowVerbSummary" maxItems="${pageSize}" recordSetStartNumber="${beginIndex}" recordSetReferenceId="confirmstatus" scope="request">
											<wcf:param name="orderId" value="${WCParam.orderId}"/>
											<wcf:param name="accessProfile" value="IBM_Details" />
											<wcf:param name="sortOrderItemBy" value="orderItemID" />
											<wcf:param name="isSummary" value="false" />
										</wcf:getData>

										<c:if test="${beginIndex == 0}">
											<c:if test="${ShowVerbSummary.recordSetTotal > ShowVerbSummary.recordSetCount}">		
												<c:set var="pageSize" value="${ShowVerbSummary.recordSetCount}" />
											</c:if>
										</c:if>

										<c:if test="${order.orderStatus.status eq 'M'}">
											<%-- The following code snippet is used for handling the case where punchout payment was used as the payment method. --%>
											<c:set var="wasPunchoutPaymentUsed" value="false"/>
											<c:set var="breakLoop" value="false"/>
											<c:forEach var="paymentInstructionInstance" items="${order.orderPaymentInfo.paymentInstruction}" varStatus="paymentInstCount">
												<c:if test="${not breakLoop}">
													<c:if test="${paymentInstructionInstance.paymentMethod.paymentMethodName eq 'SimplePunchout'}">
														<c:set var="wasPunchoutPaymentUsed" value="true"/>
														<c:set var="breakLoop" value="true"/>
													</c:if>
												</c:if>
											</c:forEach>
											<c:if test="${wasPunchoutPaymentUsed}">
												<jsp:useBean id="payInstMap" class="java.util.HashMap"/>
												<c:set var="isPunchoutPaymentPending" value="false"/>
												<wcbase:useBean id="edpPayInstBean" classname="com.ibm.commerce.edp.beans.EDPPaymentInstructionsDataBean">
													<c:set value="${order.orderIdentifier.uniqueID}" target="${edpPayInstBean}" property="orderId"/>
												</wcbase:useBean>
												<c:forEach var="payInst" items="${edpPayInstBean.paymentInstructions}">
													<c:set target="${payInstMap}" property="${payInst.id}" value="${payInst.overallPaymentInstructionStatus}"/>
													<c:if test="${payInst.paymentMethod eq 'SimplePunchout' && payInst.overallPaymentInstructionStatus eq 'Pending'}">
														<c:set var="isPunchoutPaymentPending" value="true"/>
													</c:if>
												</c:forEach>
											</c:if>
										</c:if>

										<c:set var="shipmentTypeId" value="${WCParam.shipmentTypeId}"/>

										<wcf:getData type="com.ibm.commerce.member.facade.datatypes.PersonType" var="person" expressionBuilder="findCurrentPerson">
											<wcf:param name="accessProfile" value="IBM_All" />
										</wcf:getData>
						
										<c:set var="personAddresses" value="${person.addressBook}"/>
										<c:set var="numberOfPaymentMethods" value="${fn:length(order.orderPaymentInfo.paymentInstruction)}"/>
										
										<div class="continue_shopping" id="WC_OrderShippingBillingConfirmationPage_div_1">
											<a href="#" role="button" class="button_secondary" id="WC_OrderShippingBillingConfirmationPage_links_1" tabindex="0" onclick="javascript:TealeafWCJS.processDOMEvent(event);setPageLocation('<c:out value="${env_TopCategoriesDisplayURL}"/>')">
												<div class="left_border"></div>
												<div class="button_text"><fmt:message key="CONTINUE_SHOPPING"/></div>
												<div class="right_border"></div>
											</a>
										</div>

										<div class="crumb" id="WC_OrderShippingBillingConfirmationPage_div_4">
											<c:set var="ordStatus" value="${order.orderStatus.status}"/>                            
											<c:choose>
												<c:when test="${ordStatus eq 'L'}">
													<h1 class="breadcrumb_current"><fmt:message key="ORD_THANKS_MESSAGE_LESS_INV"/></h1>				
												</c:when>                                   
												<c:when test="${ordStatus eq 'W'}">
													<%-- Missing message --%>
													<h1 class="breadcrumb_current"><fmt:message key="ORD_ORDER_PENDING_APPROVAL_MESSAGE"/></h1>				
												</c:when>
												<c:when test="${ordStatus eq 'I'}">
													<h1 class="breadcrumb_current"><fmt:message key="ORD_ORDER_SCHEDULED_MESSAGE"/></h1>
												</c:when>
												<c:when test="${ordStatus eq 'M' && isPunchoutPaymentPending eq true}">
													<h1 class="breadcrumb_current"><fmt:message key="PUNCHOUT_PAYMENT_ORDER_PENDING_MSG"/></h1>
												</c:when>
												<c:otherwise>
													<c:choose>
														<c:when test="${WCParam.isQuote eq true}">
															<h1 class="breadcrumb_current"><fmt:message key="ORD_THANKS_MESSAGE_QUOTE"/></h1>
															<p><fmt:message key="ORD_CONFIRMATION_MESSAGE_QUOTE"/></p>
														</c:when>
														<c:otherwise>
															<h1 class="breadcrumb_current"><fmt:message key="ORD_THANKS_MESSAGE"/></h1>
															<p><fmt:message key="ORD_CONFIRMATION_MESSAGE"/></p>
														</c:otherwise>
													</c:choose>
												</c:otherwise>                     
											</c:choose>
											<c:choose>
												<c:when test="${WCParam.isQuote eq true}">
													<c:choose>
										              	<c:when test="${WCParam.externalQuoteId != null}">
										              		<c:choose>
										              			<c:when test="${WCParam.externalQuoteId eq \"\" }"><fmt:message var="objectId" key="ORD_MESSAGE_QUOTENUMBER_UNAVAILABLE"/></c:when>
										              			<c:otherwise><c:set var="objectId" value="${WCParam.externalQuoteId}"/></c:otherwise>
										              		</c:choose>
										              	</c:when>
										              	<c:otherwise>
										              		<c:set var="objectId" value="${WCParam.quoteId}"/>
										              	</c:otherwise>
								              		</c:choose>
													<p><span class="strong"><fmt:message key="ORD_QUOTE_NUMBER"/></span> <span id="WC_OrderShippingBillingConfirmationPage_span_1"><c:out value="${objectId}"/></span></p>
												</c:when>
								              	<c:otherwise>
								              		<c:choose>
														<c:when test="${order.orderIdentifier.externalOrderID != null}">
															<c:choose>
																<c:when test="${order.orderIdentifier.externalOrderID eq \"\" }"><fmt:message var="objectId" key="ORD_MESSAGE_ORDERNUMBER_UNAVAILABLE"/></c:when>
																<c:otherwise><c:set var="objectId" value="${order.orderIdentifier.externalOrderID}"/></c:otherwise>
															</c:choose>
														</c:when>
														<c:otherwise>
															<c:set var="objectId" value="${order.orderIdentifier.uniqueID}"/>
														</c:otherwise>
													</c:choose>
													<c:choose>
														<c:when test="${ordStatus eq 'I'}">
															<p><span class="strong"><fmt:message key="ORD_SCHEDULED_ORDER_NUMBER"/></span> <span id="WC_OrderShippingBillingConfirmationPage_ScheduledOrderNumber"><c:out value="${objectId}"/></span></p>
														</c:when>
														<c:when test="${ordStatus eq 'M' && isPunchoutPaymentPending eq true}">
															<p><span class="strong"><fmt:message key="PUNCHOUT_PAYMENT_PAY_INSTRUCTION_MSG"/></span></p>
														</c:when>
														<c:otherwise>
															<p><span class="strong"><fmt:message key="ORD_ORDER_NUMBER_COLON"/></span><span id="WC_OrderShippingBillingConfirmationPage_span_1"><c:out value="${objectId}"/></span></p>
														</c:otherwise>
													</c:choose>
												</c:otherwise>
											</c:choose>
											<c:if test="${!(ordStatus eq 'I' || ordStatus eq 'W')}">
												<c:choose>
													<c:when test="${WCParam.isQuote eq true}">
														<jsp:useBean id="nowDateForQuotes" class="java.util.Date" />
														<fmt:formatDate value="${nowDateForQuotes}" type="date" dateStyle="long" var="formattedOrderDate" timeZone="${fn:replace(cookie.WC_timeoffset.value, '%2B', '+')}"/>
														<p id="orderDateParagraph"><span class="strong"><fmt:message key="ORD_QUOTE_DATE"/></span> <c:out value="${formattedOrderDate}"/></p>
													</c:when>
													<c:otherwise>
														<c:catch>
															<fmt:parseDate parseLocale="${dateLocale}" var="orderDate" value="${order.placedDate}" pattern="yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" timeZone="GMT"/>
														</c:catch>
														<c:if test="${empty orderDate}">
															<c:catch>
																<fmt:parseDate parseLocale="${dateLocale}" var="orderDate" value="${order.placedDate}" pattern="yyyy-MM-dd'T'HH:mm:ss'Z'" timeZone="GMT"/>
															</c:catch>
														</c:if>
														<fmt:formatDate value="${orderDate}" type="date" dateStyle="long" var="formattedOrderDate" timeZone="${fn:replace(cookie.WC_timeoffset.value, '%2B', '+')}"/>
														<p id="orderDateParagraph"><span class="strong"><fmt:message key="ORD_ORDER_DATE_COLON"/></span> <c:out value="${formattedOrderDate}"/></p>
													</c:otherwise>
												</c:choose>
											</c:if>
											<c:if test="${ordStatus eq 'I'}">
												<p><fmt:message key="ORD_SCHEDULED_ORDER_DESC"/></p>
											</c:if>
											<%@ include file="OrderShippingBillingConfirmationEIExt.jspf"%> 
										</div>
									</div>
									<!-- Breadcrumb End -->
	                     
									<!-- Main Content Start -->
									<div id="box">
										<div class="main_header" id="WC_OrderShippingBillingConfirmationPage_div_5">
											<div class="left_corner" id="WC_OrderShippingBillingConfirmationPage_div_6"></div>
											<div class="left" id="WC_OrderShippingBillingConfirmationPage_div_7"><span class="main_header_text" role="heading" aria-level="1"><fmt:message key="BCT_SHIPPING_INFO"/></span></div>
											<div class="right_corner" id="WC_OrderShippingBillingConfirmationPage_div_8"></div>
											<%@ include file="../../Snippets/ReusableObjects/CheckoutTopESpotDisplay.jspf"%>			
										</div>
										<div class="contentline" id="WC_OrderShippingBillingConfirmationPage_div_9"></div>
										<div class="body shipping_billing_height" id="WC_OrderShippingBillingConfirmationPage_div_13">
											<div id="shipping">
												<c:choose>
													<c:when test = "${shipmentTypeId == 1}">
														<div class="shipping_address" id="WC_OrderShippingBillingConfirmationPage_div_14">
															<p class="title"><fmt:message key="SHIP_SHIPPING_ADDRESS_COLON"/></p>
															<!-- since this is just single shipment page, all the orderItems will have same address -->
															<c:set var="contact" value="${order.orderItem[0].orderItemShippingInfo.shippingAddress}"/>
	
															<p class="profile">
																<c:choose>
																	<c:when test="${contact.contactInfoIdentifier.externalIdentifier.contactInfoNickName eq  profileShippingNickname}"><fmt:message key="QC_DEFAULT_SHIPPING"/></c:when>
																	<c:when test="${contact.contactInfoIdentifier.externalIdentifier.contactInfoNickName eq  profileBillingNickname}"><fmt:message key="QC_DEFAULT_BILLING"/></c:when>
																	<c:otherwise>${contact.contactInfoIdentifier.externalIdentifier.contactInfoNickName}</c:otherwise>
																</c:choose>
															</p>
	
															<!-- Display shiping address of the order -->
															<%@ include file="../../Snippets/ReusableObjects/AddressDisplay.jspf"%>
														</div>
	
														<div class="shipping_method" id="WC_OrderShippingBillingConfirmationPage_div_15">
															<p>
																<flow:ifEnabled feature="ShipAsComplete">
																	<span class="title"><fmt:message key="SHIP_SHIP_AS_COMPLETE_COLON"/></span>
																	<c:choose>
																		<c:when test='${order.shipAsComplete}'>
																			<span class="text"><fmt:message key="YES"/></span>
																		</c:when>
																		<c:otherwise>
																			<span class="text"><fmt:message key="NO"/></span>
																		</c:otherwise>
																	</c:choose>
																</flow:ifEnabled>
															</p>
															<br />
															<p>
																<span class="title"><fmt:message key="SHIP_SHIPPING_METHOD_COLON"/></span>
																<span class="text">
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
																						<span class="title"><fmt:message key="ShippingChargeType"/>:</span>
																						<span class="text"><fmt:message key="${shipCharges_data.policyName}"/></span>
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
															</flow:ifEnabled>
	                                                                    
															<flow:ifEnabled feature="ShippingInstructions">
																<c:set var="shipInstructions" value="${order.orderItem[0].orderItemShippingInfo.shippingInstruction}"/>
																<c:if test="${!empty shipInstructions}">
																	<p>
																		<span class="title"><fmt:message key="SHIP_SHIPPING_INSTRUCTIONS_COLON" /></span>
																		<span class="text"><c:out value = "${shipInstructions}"/></span>
																	</p>
																	<br />
																</c:if>
															</flow:ifEnabled>                                                        
	
															<flow:ifEnabled feature="FutureOrders">
																<%-- get requested shipping date --%>
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
																		<span class="title"><fmt:message key="SHIP_REQUESTED_DATE_COLON" /></span>
																		<span class="text"><c:out value="${formattedDate}"/></span>
																	</p>
																	<br />
																</c:if>
															</flow:ifEnabled>
	                                                 	</div>
														<%-- Display Single shipment confirmation page --%>
														<span id="OrderConfirmPagingDisplay_ACCE_Label" class="spanacce"><fmt:message key="ACCE_Region_Order_Item_List"/></span>
														<%-- Declare the refresh area for the order items table and bind it to the paging controller --%>                                                               
														<div dojoType="wc.widget.RefreshArea" widgetId="OrderConfirmPagingDisplay" id="OrderConfirmPagingDisplay" 
															controllerId="OrderItemPaginationDisplayController" ariaMessage="<fmt:message key="ACCE_Status_Order_Item_List_Updated"/>" ariaLiveId="${ariaMessageNode}" role="region" aria-labelledby="OrderConfirmPagingDisplay_ACCE_Label">
															<%out.flush();%>
															<c:import url="/${sdb.jspStoreDir}/ShoppingArea/CheckoutSection/SingleShipment/OrderItemDetailSummary.jsp">  
																<c:param name="catalogId" value="${WCParam.catalogId}" />
																<c:param name="langId" value="${WCParam.langId}" />
																<c:param name="storeId" value="${WCParam.storeId}" />
																<c:param name="orderPage" value="confirmation" />
															</c:import>
															<%out.flush();%>
														</div>
														<script type="text/javascript">
															dojo.addOnLoad(function() { 
																parseWidget("OrderConfirmPagingDisplay");
															});
														</script>
													</c:when>
													<c:otherwise>
														<div class="shipping_method" id="WC_OrderShippingBillingConfirmationPage_div_15a">
															<p>
																<flow:ifEnabled feature="ShipAsComplete">
																	<span class="title"><fmt:message key="SHIP_SHIP_AS_COMPLETE_COLON"/></span>
																	<c:if test='${order.shipAsComplete}'>
																		<span class="text"><fmt:message key="YES"/></span>
																	</c:if>
																	<c:if test='${!order.shipAsComplete}'>
																		<span class="text"><fmt:message key="NO"/></span>
																	</c:if>
																</flow:ifEnabled>
															</p>
														</div>
														<%-- Display Multiple shipment confirmation page --%>
														<span id="MSOrderConfirmPagingDisplay_ACCE_Label" class="spanacce"><fmt:message key="ACCE_Region_Order_Item_List"/></span>
														<%-- Declare the refresh area for the order items table and bind it to the paging controller --%>                                                               
														<div dojoType="wc.widget.RefreshArea" widgetId="MSOrderConfirmPagingDisplay" id="MSOrderConfirmPagingDisplay" 
															controllerId="MSOrderItemPaginationDisplayController" ariaMessage="<fmt:message key="ACCE_Status_Order_Item_List_Updated"/>" ariaLiveId="${ariaMessageNode}" role="region" aria-labelledby="MSOrderConfirmPagingDisplay_ACCE_Label">
															<%out.flush();%>
															<c:import url="/${sdb.jspStoreDir}/ShoppingArea/CheckoutSection/MultipleShipment/MSOrderItemDetailSummary.jsp">  
																<c:param name="catalogId" value="${WCParam.catalogId}" />
																<c:param name="langId" value="${WCParam.langId}" />
																<c:param name="storeId" value="${WCParam.storeId}" />
																<c:param name="orderPage" value="confirmation" />
															</c:import>
															<%out.flush();%>
														</div>
														<script type="text/javascript">
															dojo.addOnLoad(function() { 
																parseWidget("MSOrderConfirmPagingDisplay");
															});
														</script>
													</c:otherwise>
												</c:choose>
	                                                                                   
												<%@ include file="OrderShippingBillingConfirmationPageExt.jspf" %>
												<%@ include file="GiftRegistryOrderShippingBillingConfirmationPageExt.jspf" %>
												<%out.flush();%>
												<c:import url="/${sdb.jspStoreDir}/ShoppingArea/CheckoutSection/SingleShipment/SingleShipmentOrderTotalsSummary.jsp"> 
													<c:param name="fromPage" value="orderConfirmationPage"/>
												</c:import>
												<%out.flush();%>
											</div>
											<br clear="all" />
										</div>
	
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
										<div class="main_header" id="WC_OrderShippingBillingConfirmationPage_div_21">
											<div class="left_corner_straight" id="WC_OrderShippingBillingConfirmationPage_div_22"></div>
											<div class="left" id="WC_OrderShippingBillingConfirmationPage_div_23"><span class="main_header_text"><fmt:message key="BILL_BILLING_INFO"/></span></div>
											<div class="right_corner_straight" id="WC_OrderShippingBillingConfirmationPage_div_24"></div>
										</div>
	
										<div class="contentline" id="WC_OrderShippingBillingConfirmationPage_div_25"></div>
	                            
										<%-- Hide the PayInStoreEmailAddress field --%>
										<c:set var="hidePayInStoreEmailAddress" value="true"/>
										<%@ include file="CheckoutPaymentAndBillingAddressSummary.jspf"%>
										<%@ include file="OrderAdditionalDetailSummaryExt.jspf" %>

										<wcf:url var="RegisterURL" value="UserRegistrationForm">
											<wcf:param name="langId" value="${langId}" />
											<wcf:param name="storeId" value="${WCParam.storeId}" />
											<wcf:param name="catalogId" value="${WCParam.catalogId}" />
											<wcf:param name="new" value="Y" />
											<wcf:param name="myAcctMain" value="1"/>
										</wcf:url>
										<c:choose>
											<c:when test="${userType eq 'G'}">
												<div class="left order_print_signup" id="WC_OrderShippingBillingConfirmationPage_div_31">
											</c:when>
											<c:otherwise>
												<div class="button_footer_line button_footer_line_confirmation_page" id="WC_OrderShipmentDetails_div_31">
											</c:otherwise>
										</c:choose>
										<div class="left left_confirmation_page" id="WC_OrderShippingBillingConfirmationPage_div_32">
											<a href="#" role="button" class="button_primary" id="WC_OrderShippingBillingConfirmationPage_Print_Link" tabindex="0" onclick="JavaScript: print();">
												<div class="left_border"></div>
												<div class="button_text"><fmt:message key="PRINT"/></div>
												<div class="right_border"></div>
											</a>
										</div>
										<div class="button_right_side_message" id="WC_OrderShippingBillingConfirmationPage_div_35">
											<fmt:message key="PRINT_RECOMMEND"/>
										</div>
	
										<c:if test="${userType eq 'G'}">
											<br/>
											<div class="left hover_underline" id="WC_OrderShippingBillingConfirmationPage_div_36">
												<c:set var="signUpLink">
													<a href="<c:out value='${RegisterURL}'/>" class="order_link" id="WC_OrderShippingBillingConfirmationPage_links_2"><fmt:message key="ORD_SIGN_UP_2" /></a>
												</c:set>
												<fmt:message key="ORD_SIGN_UP_1">
													<fmt:param value = "${signUpLink}"/>
												</fmt:message>
											</div>

										</c:if>
																				
										<flow:ifEnabled feature="IntelligentOffer">
											<%-- Begin - Added for Coremetrics Intelligent Offer to Display dynamic recommendations for the most recently viewed product --%>											
											<%@ include file="../../Widgets/QuickInfo/QuickInfoPopup.jspf" %>
											<%@ include file="../../Widgets/ShoppingList/ItemAddedPopup.jspf" %>
											<%@ include file="../../Common/MultipleWishListSetup.jspf" %>
											<br/>										
											<div class="widget_product_listing_position container_margin_5px">
												<%out.flush();%>
												<c:import url="${env_jspStoreDir}Widgets/ESpot/IntelligentOffer/IntelligentOffer.jsp">
													<c:param name="emsName" value="OrderConf_IntellOffer" />
													<c:param name="catalogId" value="${WCParam.catalogId}" />
													<c:param name="pageSize" value="4" />
													<c:param name="pageView" value="miniGrid" />
												</c:import>
												<%out.flush();%>													
											</div>	
	
											<%-- End - Added for Coremetrics Intelligent Offer --%>	
										</flow:ifEnabled> 
	
									</div>
									<div class="espot_checkout_bottom" id="WC_OrderShippingBillingConfirmationPage_div_38">
										<%@ include file="../../Snippets/ReusableObjects/CheckoutBottomESpotDisplay.jspf"%>
									</div>
								</div>									
							</div>              
						</div>	
						<!-- Content End -->
					</div>
				</div>
			</div>

			<!-- Main Content End -->
			<div class="footer_wrapper_position">
				<%out.flush();%>
					<c:import url = "${env_jspStoreDir}/Widgets/Footer/Footer.jsp" />
				<%out.flush();%>
			</div>
			<!-- Footer End --> 

		</div>
		<flow:ifEnabled feature="Analytics">
			<wcf:getData type="com.ibm.commerce.order.facade.datatypes.OrderType" var="orderForAn" expressionBuilder="findByOrderId">
				<wcf:param name="accessProfile" value="IBM_Details" />
				<wcf:param name="orderId" value="${WCParam.orderId}" />
			</wcf:getData>
			<cm:order includeTaxInUnitPrice="false" includeTaxInTotalPrice="false" orderType="${orderForAn}" extraparms="null, ${cookie.analyticsFacetAttributes.value}"/>
			<cm:registration/>						
			<cm:pageview/>
		</flow:ifEnabled>
	</body>
</html>
<!-- END OrderShippingBillingConfirmationPage.jsp -->
