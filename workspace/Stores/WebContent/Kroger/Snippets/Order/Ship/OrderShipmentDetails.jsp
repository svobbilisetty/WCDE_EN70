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
<!-- BEGIN OrderShipmentDetails.jsp -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ include file="../../../Common/EnvironmentSetup.jspf"%>
<flow:fileRef id="vfileLogo" fileId="vfile.logo"/>
<c:if test='${param.email eq "true"}'>
	<c:set value="${pageContext.request.scheme}://${pageContext.request.serverName}" var="eHostPath" />
	<c:set value="${eHostPath}${jspStoreImgDir}" var="jspStoreImgDir" />
</c:if>

<c:if test='${param.email != "true"}'>
	<script type="text/javascript" src="<c:out value='${jsAssetsDir}javascript/CheckoutArea/CheckoutHelper.js'/>"></script>
	
<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/ServicesDeclaration.js"/>"></script>
	<script type="text/javascript">
		dojo.addOnLoad(function() {
			ServicesDeclarationJS.setCommonParameters('<c:out value="${WCParam.langId}"/>','<c:out value="${WCParam.storeId}"/>','<c:out value="${WCParam.catalogId}"/>');
			// On IE7, the specified div requires float:left in order for the CSS containers to show properly.  However, this change messes up the styling on all other
			// browsers.
			if (dojo.isIE == 7) {
				document.getElementById('WC_OrderShipmentDetails_div_16').style.styleFloat='left';
			}
		});
	</script>
</c:if>
<c:set var="subscriptionId" value="${WCParam.subscriptionId}" />
<c:set var="pageSize" value="${WCParam.pageSize}" />
<c:if test="${empty pageSize}">
	<c:set var="pageSize" value="${maxOrderItemsPerPage}"/>
</c:if>
<fmt:parseNumber var="pageSize" value="${pageSize}"/>

<c:set var="formattedTimeZone" value="${fn:replace(cookie.WC_timeoffset.value, '%2B', '+')}"/>
<c:set var="formattedTimeZone" value="${fn:replace(formattedTimeZone, '.75', ':45')}"/>	
<c:set var="formattedTimeZone" value="${fn:replace(formattedTimeZone, '.5', ':30')}"/>

<c:choose>
	<c:when test="${WCParam.orderId != null}">
		<wcf:getData type="com.ibm.commerce.order.facade.datatypes.OrderType" var="order" expressionBuilder="findByOrderIdWithPagingOnItem" maxItems="${pageSize}" recordSetStartNumber="0" varShowVerb="ShowVerbSummary" recordSetReferenceId="confirmstatus" scope="request">
			<wcf:param name="orderId" value="${WCParam.orderId}"/>
			<wcf:param name="accessProfile" value="IBM_Details" />
			<wcf:param name="sortOrderItemBy" value="orderItemID" />
			<wcf:param name="isSummary" value="false" />
		</wcf:getData>
		<c:set var="objectId" value="${order.orderIdentifier.uniqueID}"/>
	</c:when>
	
	<c:when test="${WCParam.externalOrderId != null}">
		<wcf:getData type="com.ibm.commerce.order.facade.datatypes.OrderType" var="order" expressionBuilder="findOrderByExternalOrderID" maxItems="${pageSize}" recordSetStartNumber="0" varShowVerb="ShowVerbSummary" recordSetReferenceId="confirmstatus" scope="request">
			<wcf:param name="orderId" value="${WCParam.externalOrderId}"/>
			<wcf:param name="accessProfile" value="IBM_External_Details" />
			<wcf:param name="sortOrderItemBy" value="orderItemID" />
			<wcf:param name="isSummary" value="false" />
		</wcf:getData>
		<c:set var="objectId" value="${order.orderIdentifier.externalOrderID}"/>
	</c:when>
	
	<c:when test="${WCParam.quoteId != null}">
		<%/* Currently no local implementation available*/%>
	</c:when>
	
	<c:when test="${WCParam.externalQuoteId != null}">
		<wcf:getData type="com.ibm.commerce.order.facade.datatypes.QuoteType" var="quote" expressionBuilder="findQuoteByExternalQuoteID" maxItems="${pageSize}" recordSetStartNumber="0" varShowVerb="ShowVerbSummary" recordSetReferenceId="confirmstatus" scope="request">
			<wcf:param name="quoteId" value="${WCParam.externalQuoteId}"/>
			<wcf:param name="accessProfile" value="IBM_External_Details" />
			<wcf:param name="sortOrderItemBy" value="orderItemID" />
			<wcf:param name="isSummary" value="false" />
		</wcf:getData>
		<c:set var="objectId" value="${quote.quoteIdentifier.externalQuoteID}"/>
		<c:set var="order" value="${quote.orderTemplate}" scope="request"/>
	</c:when>
	<c:otherwise>
	</c:otherwise>
</c:choose>

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

<c:set var="shipmentTypeId" value="1"/>

<c:choose>
	<c:when test="${ShowVerbSummary.recordSetTotal > maxOrderItemsToInspect}">
		<c:set var="shipmentTypeId" value="2"/>
	</c:when>
	<c:otherwise>
		<jsp:useBean id="blockMap" class="java.util.HashMap" scope="request"/>
		<c:forEach var="orderItem" items="${order.orderItem}" varStatus="status">
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

				

<%-- Need to reset currencyFormatterDB as initialized in JSTLEnvironmentSetup.jspf, as the currency code used there is from commandContext. For order history we want to display with currency used when the order was placed. --%>
<c:choose>
	<c:when test ="${order.orderAmount.grandTotal != null}">
		<c:remove var="currencyFormatterDB"/>
		<wcbase:useBean id="currencyFormatterDB" classname="com.ibm.commerce.common.beans.StoreCurrencyFormatDescriptionDataBean" scope="request" >
			<c:set property="storeId" value="${storeId}" target="${currencyFormatterDB}" />
			<c:set property="langId" value="${langId}" target="${currencyFormatterDB}" />
			<c:set property="currencyCode" value="${order.orderAmount.grandTotal.currency}" target="${currencyFormatterDB}" />
			<c:set property="numberUsage" value="-1" target="${currencyFormatterDB}" />
		</wcbase:useBean>
	
		<c:set var="currencyDecimal" value="${currencyFormatterDB.decimalPlaces}"/>
		<c:if test="${order.orderAmount.grandTotal.currency == 'KRW'}">
			<c:set property="currencySymbol" value="&#8361;" target="${currencyFormatterDB}"/>
		</c:if>
		<c:if test="${order.orderAmount.grandTotal.currency == 'PLN'}">
			<c:set property="currencySymbol" value="z&#322;" target="${currencyFormatterDB}"/>
		</c:if>		
		
		<%-- These variables are used to hold the currency symbol --%>
		<c:choose>
			<c:when test="${order.orderAmount.grandTotal.currency == 'ar_EG' && order.orderAmount.grandTotal.currency == 'EGP'}">
				<c:set var="CurrencySymbolToFormat" value=""/>
				<c:set var="CurrencySymbol" value="${currencyFormatterDB.currencySymbol}"/>
			</c:when>
			<c:otherwise>
				<c:set var="CurrencySymbolToFormat" value="${currencyFormatterDB.currencySymbol}"/>
				<c:set var="CurrencySymbol" value=""/>
			</c:otherwise>
		</c:choose>
		
	</c:when>
</c:choose>


<wcf:getData type="com.ibm.commerce.member.facade.datatypes.PersonType" 
		var="person" expressionBuilder="findCurrentPerson">
	<wcf:param name="accessProfile" value="IBM_All" />
</wcf:getData>

<c:set var="personAddresses" value="${person.addressBook}"/>

<c:set var="numberOfPaymentMethods" value="${fn:length(order.orderPaymentInfo.paymentInstruction)}"/>
<div id="orderConfirmationHeader">
	<div id="orderConfirmImage">
		<img src="<c:out value="${storeImgDir}${vfileLogo}" />" alt="<c:out value="${storeName}" />" border="0"/>
	</div>
	<div id="orderConfirmText">
		<fmt:message key="HEADER_ORDER_CONFIRM"  />
	</div>
</div>
<div id="box">
	<script type="text/javascript">dojo.addOnLoad(function() { parseWidget("WC_OrderShipmentDetails_div_1"); });</script>
	<div class="my_account" id="WC_OrderShipmentDetails_div_1">
		<c:choose>
			<c:when test = "${WCParam.currentSelection eq 'RecurringOrderDetailSlct' || WCParam.currentSelection eq 'SubscriptionDetailSlct'}" >
				<c:if test = "${WCParam.currentSelection eq 'SubscriptionDetailSlct'}" >
					<flow:ifEnabled feature="Subscription">						
						<wcbase:useBean id="subscriptionCatEntry" classname="com.ibm.commerce.catalog.beans.CatalogEntryDataBean">
							<c:set property="catalogEntryID" value="${WCParam.subscriptionCatalogEntryId}" target="${subscriptionCatEntry}" />
						</wcbase:useBean>
						<fmt:message var="openingBrace" key="OPENING_BRACE" />
						<c:choose>
							<c:when test="${fn:contains(subscriptionCatEntry.description.name,openingBrace)}">
								<c:set var="subscriptionName" value="${fn:substringBefore(subscriptionCatEntry.description.name,openingBrace)}"/>
							</c:when>
							<c:otherwise>
								<c:set var="subscriptionName" value="${subscriptionCatEntry.description.name}"/>
							</c:otherwise>
						</c:choose>
					</flow:ifEnabled>
				</c:if>

				<c:if test = "${WCParam.currentSelection eq 'RecurringOrderDetailSlct'}" >
					<flow:ifEnabled feature="RecurringOrders">
						<fmt:message key="X_DETAILS"  var="RecurringOrderDetailBreadcrumbLinkLabel"> 
							<fmt:param><c:out value="${objectId}"/></fmt:param>
						</fmt:message>
						<script type="text/javascript">
							dojo.addOnLoad(function() { 
								if(document.getElementById("RecurringOrderBreadcrumb")){
									document.getElementById("MyAccountBreadcrumbLink").style.display = "none";
									document.getElementById("RecurringOrderDetailBreadcrumbLink").innerHTML = "<c:out value='${RecurringOrderDetailBreadcrumbLinkLabel}' />";
									document.getElementById("RecurringOrderBreadcrumb").style.display = "inline";
								}
							});
						</script>
					</flow:ifEnabled>
				</c:if>
				<c:if test = "${WCParam.currentSelection eq 'SubscriptionDetailSlct'}" >
					<flow:ifEnabled feature="Subscription">
						<script type="text/javascript">
							dojo.addOnLoad(function() { 
								if(document.getElementById("SubscriptionBreadcrumb")){
									document.getElementById("MyAccountBreadcrumbLink").style.display = "none";
									document.getElementById("SubscriptionDetailBreadcrumbLink").innerHTML = "<c:out value='${subscriptionName}' />";
									document.getElementById("SubscriptionBreadcrumb").style.display = "inline";
								}
							});
						</script>
					</flow:ifEnabled>
				</c:if>

				<!--- Tabs --->
				<div class="tab_container_top" >
					<div id="recurring_order_details_On">
						<div class="tab_clear"></div>
						<div class="tab_active_left"></div>
						<div class="tab_active_middle" id="tab_order_details1">
							<c:choose>
								<c:when test="${WCParam.isQuote eq true}">
									<fmt:message key="MO_QUOTEDETAILS" />
								</c:when>
								<c:when test="${WCParam.currentSelection eq 'SubscriptionDetailSlct'}">
									<c:out value="${subscriptionName}"/>
								</c:when>
								<c:otherwise>
									<fmt:message key="X_ORDER_DETAILS" > 
										<fmt:param><c:out value="${objectId}"/></fmt:param>
									</fmt:message>
								</c:otherwise>
							</c:choose>
						</div>
						<div class="tab_active_inactive"></div>
					</div>
					<div id="recurring_order_details_Off" style="display:none">
						<div class="tab_clear"></div>
						<div class="tab_inactive_left"></div>
						<div class="tab_inactive_middle" id="tab_order_details">
							<a href="javascript:MyAccountDisplay.selectRecurringOrderTab('recurring_order_details');" class="tab_link">
								<c:choose>
									<c:when test="${WCParam.currentSelection eq 'SubscriptionDetailSlct'}">
										<c:out value="${subscriptionName}"/>
									</c:when>
									<c:when test="${WCParam.isQuote eq true}">
										<fmt:message key="MO_QUOTEDETAILS" />
									</c:when>
									<c:otherwise>
										<fmt:message key="X_ORDER_DETAILS" > 
											<fmt:param><c:out value="${objectId}"/></fmt:param>
										</fmt:message>
									</c:otherwise>
								</c:choose>
							</a>
						</div>
						<div class="tab_inactive_active"></div>
					</div>

					<div id="recurring_order_history_Off">
						<div class="tab_inactive_middle" id="tab_order_history1">  
							<a href="javascript:MyAccountDisplay.selectRecurringOrderTab('recurring_order_history');" class="tab_link">
								<c:choose>
									<c:when test="${WCParam.currentSelection eq 'SubscriptionDetailSlct'}">
										<fmt:message key="MO_SUBSCRIPTION_HISTORY" />
									</c:when>
									<c:otherwise>
										<fmt:message key="MO_SCHEDULED_ORDER_HISTORY" >
											<fmt:param value="${objectId}" /> 
										</fmt:message>
									</c:otherwise>
								</c:choose>									
							</a>
						</div>
						<div class="tab_inactive_right"></div>
					</div>					
					<div id="recurring_order_history_On" style="display:none">
						<div class="tab_active_middle" id="tab_order_history">
							<a href="#" class="tab_link">
								<c:choose>
									<c:when test="${WCParam.currentSelection eq 'SubscriptionDetailSlct'}">
										<fmt:message key="MO_SUBSCRIPTION_HISTORY" />
									</c:when>
									<c:otherwise>
										<fmt:message key="MO_SCHEDULED_ORDER_HISTORY" >
											<fmt:param value="${objectId}" />
										</fmt:message>
									</c:otherwise>
								</c:choose>
							</a>
						</div>
						<div class="tab_active_right"></div>
					</div>
				</div>

				<div class="tab_container_base">
					<div class="tab_container_left"></div>
					<div class="tab_container_middle"></div>
					<div class="tab_container_right"></div>
				</div>
				<!--- End Tabs --->
			</c:when>
			<c:otherwise>
				<fmt:message key="X_DETAILS"  var="OrderHistoryDetailBreadcrumbLinkLabel"> 
					<fmt:param><c:out value="${objectId}"/></fmt:param>
				</fmt:message>
				<script type="text/javascript">
					dojo.addOnLoad(function() { 
						if(document.getElementById("OrderHistoryBreadcrumb")){
							document.getElementById("MyAccountBreadcrumbLink").style.display = "none";
							document.getElementById("OrderHistoryDetailBreadcrumbLink").innerHTML = "<c:out value='${OrderHistoryDetailBreadcrumbLinkLabel}' />";
							document.getElementById("OrderHistoryBreadcrumb").style.display = "inline";
						}
					});
				</script>
				<h2 class="myaccount_header">
					<c:choose>
						<c:when test="${WCParam.isQuote eq true}">
							<fmt:message key="MO_QUOTEDETAILS" />
						</c:when>
						<c:otherwise>
							<fmt:message key="MO_ORDERDETAILS" />
						</c:otherwise>
					</c:choose>
				</h2>
			</c:otherwise>
		</c:choose>

		<c:if test="${WCParam.currentSelection eq 'RecurringOrderDetailSlct' || WCParam.currentSelection eq 'SubscriptionDetailSlct'}">
			<div id="mainTabContainer" class="mainTabContainer_body" dojoType="dijit.layout.TabContainer" doLayout="false">
				<div id="recurring_order_details" dojoType="dijit.layout.ContentPane" selected="true">
		</c:if>

		<div class="body" id="WC_OrderShipmentDetails_div_6">
			<div class="order_details_my_account" id="WC_OrderShipmentDetails_div_7">
				<c:if test="${order.orderStatus.status eq 'W'}">
					<c:choose>
						<c:when test="${WCParam.isQuote eq true}">
							<p><span class="my_account_content_bold"><fmt:message key="MO_QUOTE_PENDING_APPROVAL_MESSAGE" /></span></p>
						</c:when>
						<c:otherwise>
							<p><span class="my_account_content_bold"><fmt:message key="MO_ORDER_PENDING_APPROVAL_MESSAGE" /></span></p>
						</c:otherwise>
					</c:choose>
				</c:if>
				
				<p>
					<c:choose>
						<c:when test="${WCParam.isQuote eq true}">
							<span class="my_account_content_bold"><fmt:message key="MO_QUOTE_NUMBER" /></span>
						</c:when>
						<c:otherwise>
							<c:choose>
								<c:when test="${order.orderStatus.status eq 'I' && order.orderTypeCode ne 'REC'}">									
									<span class="my_account_content_bold"><fmt:message key="MO_ORDER_NUMBER" /></span>
								</c:when>
								<c:when test="${WCParam.currentSelection eq 'RecurringOrderDetailSlct'}">
									<span class="my_account_content_bold"><fmt:message key="ORD_SCHEDULED_ORDER_NUMBER" /></span>
								</c:when>
								<c:when test="${order.orderStatus.status eq 'M' && isPunchoutPaymentPending eq true}">
									<span class="my_account_content_bold"><fmt:message key="PUNCHOUT_PAYMENT_PAY_INSTRUCTION_MSG" /></span>
								</c:when>
								<c:otherwise>
									<span class="my_account_content_bold"><fmt:message key="MO_ORDER_NUMBER" /></span>
								</c:otherwise>
							</c:choose>
						</c:otherwise>
					</c:choose>
					<c:if test="${isPunchoutPaymentPending ne true}">
						<c:choose>
							<c:when test="${!empty objectId}">
								<c:out value="${objectId}"/>	
							</c:when>
							<c:otherwise>
								<fmt:message key="MO_NOT_AVAILABLE" />
							</c:otherwise>
						</c:choose>
					</c:if>							
				</p>
				<c:if test="${!(order.orderStatus.status eq 'I' || order.orderStatus.status eq 'W') && (WCParam.currentSelection ne 'RecurringOrderDetailSlct') && (WCParam.currentSelection ne 'SubscriptionDetailSlct')}">
					<c:choose>
						<c:when test="${WCParam.isQuote eq true}">
							<p><span class="my_account_content_bold"><fmt:message key="MO_QUOTE_DATE" /></span>
						</c:when>
						<c:otherwise>
							<p><span class="my_account_content_bold"><fmt:message key="MO_ORDER_DATE" /></span>
						</c:otherwise>
					</c:choose>
					<c:catch>
						<fmt:parseDate parseLocale="${dateLocale}" var="expectedDate" value="${order.placedDate}" pattern="yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" timeZone="GMT"/>
					</c:catch>
					<c:if test="${empty expectedDate}">
						<c:catch>
							<fmt:parseDate parseLocale="${dateLocale}" var="expectedDate" value="${order.placedDate}" pattern="yyyy-MM-dd'T'HH:mm:ss'Z'" timeZone="GMT"/>
						</c:catch>
					</c:if>
					<c:choose>
							<c:when test="${!empty expectedDate}">
								<fmt:formatDate value="${expectedDate}" dateStyle="long" timeZone="${formattedTimeZone}"/></p>
							</c:when>
							<c:otherwise>
								<fmt:message key="MO_NOT_AVAILABLE" /></p>
							</c:otherwise>
					</c:choose>			
					
				</c:if>
				<c:if test="${WCParam.currentSelection eq 'RecurringOrderDetailSlct'}" >
					<c:choose>
						<c:when test="${WCParam.isQuote eq true}">
							<p><span class="my_account_content_bold"><fmt:message key="MO_QUOTE_DATE" /></span>
						</c:when>
						<c:otherwise>
							<p><span class="my_account_content_bold"><fmt:message key="MO_ORDER_DATE" /></span>
						</c:otherwise>
					</c:choose>
					<c:catch>
						<fmt:parseDate parseLocale="${dateLocale}" var="expectedDate" value="${order.placedDate}" pattern="yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" timeZone="GMT"/>
					</c:catch>
					<c:if test="${empty expectedDate}">
						<c:catch>
							<fmt:parseDate parseLocale="${dateLocale}" var="expectedDate" value="${order.placedDate}" pattern="yyyy-MM-dd'T'HH:mm:ss'Z'" timeZone="GMT"/>
						</c:catch>
					</c:if>
					<c:choose>
						<c:when test="${!empty expectedDate}">
							<fmt:formatDate value="${expectedDate}" dateStyle="long" timeZone="${formattedTimeZone}"/></p>
						</c:when>
						<c:otherwise>
							<fmt:message key="MO_NOT_AVAILABLE" /></p>
						</c:otherwise>
					</c:choose>
				</c:if>
				<c:if test="${WCParam.currentSelection eq 'SubscriptionDetailSlct'}" >
					<p><span class="my_account_content_bold"><fmt:message key="MO_ORDER_DATE" /></span>
					<c:catch>
						<fmt:parseDate parseLocale="${dateLocale}" var="expectedDate" value="${order.placedDate}" pattern="yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" timeZone="GMT"/>
					</c:catch>
					<c:if test="${empty expectedDate}">
						<c:catch>
							<fmt:parseDate parseLocale="${dateLocale}" var="expectedDate" value="${order.placedDate}" pattern="yyyy-MM-dd'T'HH:mm:ss'Z'" timeZone="GMT"/>
						</c:catch>
					</c:if>
					<c:choose>
						<c:when test="${!empty expectedDate}">
							<fmt:formatDate value="${expectedDate}" dateStyle="long" timeZone="${formattedTimeZone}"/></p>
						</c:when>
						<c:otherwise>
							<fmt:message key="MO_NOT_AVAILABLE" /></p>
						</c:otherwise>
					</c:choose>
					<wcf:getData type="com.ibm.commerce.subscription.facade.datatypes.SubscriptionType" var="subscription" varShowVerb="ShowVerbSubscriptions" expressionBuilder="getSubscriptionDetailsByUniqueID"  >
							<wcf:param name="UniqueID" value="${subscriptionId}" />
							<wcf:param name="storeId" value="${WCParam.storeId}" />
					</wcf:getData>

					<p><span class="my_account_content_bold"><fmt:message key="MO_EXPIRY_DATE" /></span>
					<c:catch>
						<fmt:parseDate parseLocale="${dateLocale}" var="expiryDate" value="${subscription.subscriptionInfo.fulfillmentSchedule.endInfo.endDate}" pattern="yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" timeZone="GMT"/>
					</c:catch>
					<c:if test="${empty expiryDate}">
						<c:catch>
							<fmt:parseDate parseLocale="${dateLocale}" var="expiryDate" value="${subscription.subscriptionInfo.fulfillmentSchedule.endInfo.endDate}" pattern="yyyy-MM-dd'T'HH:mm:ss'Z'" timeZone="GMT"/>
						</c:catch>
					</c:if>
					<c:choose>
						<c:when test="${!empty expiryDate}">
							<fmt:formatDate value="${expiryDate}" dateStyle="long" timeZone="${formattedTimeZone}"/></p>
						</c:when>
						<c:otherwise>
							<fmt:message key="MO_NOT_AVAILABLE" /></p>
						</c:otherwise>
					</c:choose>

				</c:if>
				<br/>
			</div>
		
		
			<div class="myaccount_header" id="WC_OrderShipmentDetails_div_8">
				<div class="left_corner_straight" id="WC_OrderShipmentDetails_div_9"></div>
				<div class="headingtext" id="WC_OrderShipmentDetails_div_10"><span class="header"><fmt:message key="MO_SHIPPINGINFO" /></span></div>
				<div class="right_corner_straight" id="WC_OrderShipmentDetails_div_11"></div>
			</div>
			<div class="myaccount_content margin_below" id="WC_OrderShipmentDetails_div_16">
				<div id="shipping">
					<c:choose>
						<c:when test = "${shipmentTypeId == 1}">
							<div class="shipping_address" id="WC_OrderShipmentDetails_div_17">
								<p class="my_account_content_bold"><fmt:message key="MO_SHIPPINGADDRESS" /></p>
						
								<c:set var="contact" value="${order.orderItem[0].orderItemShippingInfo.shippingAddress}" />
	
								<c:if test="${!empty contact.contactInfoIdentifier.externalIdentifier.contactInfoNickName}">
									<p>
										<c:choose>
											<c:when test="${contact.contactInfoIdentifier.externalIdentifier.contactInfoNickName eq  profileShippingNickname}">
												<fmt:message key="QC_DEFAULT_SHIPPING" />
											</c:when>
											<c:when test="${contact.contactInfoIdentifier.externalIdentifier.contactInfoNickName eq  profileBillingNickname}">
												<fmt:message key="QC_DEFAULT_BILLING" />
											</c:when>
											<c:otherwise>
												${contact.contactInfoIdentifier.externalIdentifier.contactInfoNickName}
											</c:otherwise>
										</c:choose>
									</p>
								</c:if>

								<!-- Display shipping address of the order -->
								<%@ include file="../../ReusableObjects/AddressDisplay.jspf"%>
							</div>

							<div class="shipping_method" id="WC_OrderShipmentDetails_div_18">
								<p>
									<flow:ifEnabled feature="ShipAsComplete">
										<span class="my_account_content_bold"><fmt:message key="SHIP_SHIP_AS_COMPLETE" />: </span>
										<c:choose>
											<c:when test='${order.shipAsComplete}'>
												<span class="text"><fmt:message key="YES" /></span>
											</c:when>
											<c:otherwise>
												<span class="text"><fmt:message key="NO" /></span>
											</c:otherwise>
										</c:choose>
									</flow:ifEnabled>
								</p>
								<br />
								
								<p class="my_account_content_bold"><fmt:message key="MO_SHIPPINGMETHOD" /></p>
								<p>
								<c:choose>
									<c:when test="${!empty order.orderItem[0].orderItemShippingInfo.shippingMode.description.value}">
										<c:out value="${order.orderItem[0].orderItemShippingInfo.shippingMode.description.value}"/>
									</c:when>
									<c:otherwise>
										<c:set var="shippingModeIdentifier" value="${order.orderItem[0].orderItemShippingInfo.shippingMode.shippingModeIdentifier}"/>
										<c:out value="${shippingModeIdentifier.externalIdentifier.shipModeCode}"/>
									</c:otherwise>
								</c:choose>
								</p>
								<br clear="all"/>

								<flow:ifEnabled feature="ShippingChargeType">
									<wcbase:useBean id="shipCharges" classname="com.ibm.commerce.order.beans.UsableShipChargesAndAccountByShipModeDataBean" scope="page">
										<c:set property="orderId" value="${order.orderIdentifier.uniqueID}" 	target="${shipCharges}"  />
									</wcbase:useBean>
									
									<c:if test="${not empty shipCharges.shipChargesByShipMode}">
										<c:forEach items="${shipCharges.shipChargesByShipMode}" var="shipCharges_shipModeData"  varStatus="counter1">
											<c:if test="${shipCharges_shipModeData.shipModeDesc == order.orderItem[0].orderItemShippingInfo.shippingMode.description.value}">
												<c:forEach items="${shipCharges_shipModeData.shippingChargeTypes}" var="shipCharges_data"  varStatus="counter2">
													<c:if test="${shipCharges_data.selected}">
														<p>
															<span class="my_account_content_bold"><fmt:message key="ShippingChargeType" />:</span>
															<span class="text"><fmt:message key="${shipCharges_data.policyName}" /></span>
														</p>
														<c:if test="${shipCharges_data.carrAccntNumber != null && shipCharges_data.carrAccntNumber != ''}">
															<p>
																<span class="my_account_content_bold"><fmt:message key="ShippingChargeAcctNum" />:</span>
																<span class="text"><c:out value="${shipCharges_data.carrAccntNumber}"/></span>
															</p>
														</c:if>
													</c:if>
												</c:forEach>
											</c:if>
										</c:forEach>
									</c:if>
								</flow:ifEnabled>
							
								<c:set var="shipInstructions" value="${order.orderItem[0].orderItemShippingInfo.shippingInstruction}"/>	
								<flow:ifEnabled feature="ShippingInstructions">
									<c:if test="${!empty shipInstructions}">
										<p>
											<span class="my_account_content_bold"><fmt:message key="SHIP_SHIPPING_INSTRUCTIONS"  />: </span>
											<span class="text"><c:out value = "${shipInstructions}"/></span>
										</p>
										<br />
									</c:if>
								</flow:ifEnabled>								
							</div>
					
							<%-- Display Single shipment confirmation page --%>
							<c:if test='${param.email != "true"}'>
								
								<span id="OrderConfirmPagingDisplay_ACCE_Label" class="spanacce"><fmt:message key="ACCE_Region_Order_Item_List"/></span>  
								<div dojoType="wc.widget.RefreshArea" widgetId="OrderConfirmPagingDisplay" id="OrderConfirmPagingDisplay" 
								controllerId="OrderItemPaginationDisplayController" ariaMessage="<fmt:message key="ACCE_Status_Order_Item_List_Updated"/>" ariaLiveId="${ariaMessageNode}" role="region" aria-labelledby="OrderConfirmPagingDisplay_ACCE_Label">
							</c:if>  
							<c:choose>
								<c:when test="${WCParam.currentSelection ne 'SubscriptionDetailSlct'}">
									<%out.flush();%>
										<c:import url="/${sdb.jspStoreDir}/ShoppingArea/CheckoutSection/SingleShipment/OrderItemDetailSummary.jsp">  
											<c:param name="catalogId" value="${WCParam.catalogId}" />
											<c:param name="langId" value="${WCParam.langId}" />
											<c:param name="storeId" value="${storeId}"/>
											<c:param name="orderPage" value="confirmation" />
											<c:param name="isFromOrderDetailsPage" value="true" />
										</c:import>
									<%out.flush();%>
								</c:when>
								<c:otherwise>
									<%out.flush();%>
										<c:import url="/${sdb.jspStoreDir}/ShoppingArea/CheckoutSection/SingleShipment/OrderItemDetailSummary.jsp">  
											<c:param name="catalogId" value="${WCParam.catalogId}" />
											<c:param name="langId" value="${WCParam.langId}" />
											<c:param name="storeId" value="${storeId}"/>
											<c:param name="orderPage" value="confirmation" />
											<c:param name="isFromOrderDetailsPage" value="true" />
											<c:param name="subscriptionOrderItemId" value="${WCParam.orderItemId}" />
										</c:import>
									<%out.flush();%>
								</c:otherwise>
							</c:choose>
							<c:if test='${param.email != "true"}'>
								</div>
								<script type="text/javascript">dojo.addOnLoad(function() { 
									parseWidget("OrderConfirmPagingDisplay");
									});
								</script>
							</c:if>		
						</c:when>
						<c:otherwise>
							<div class="shipping_method" id="WC_OrderShipmentDetails_div_35">
								<p>
									<flow:ifEnabled feature="ShipAsComplete">
										<span class="my_account_content_bold"><fmt:message key="SHIP_SHIP_AS_COMPLETE" />: </span>
										<c:if test='${order.shipAsComplete}'>
											<span class="text"><fmt:message key="YES" /></span>
										</c:if>
										<c:if test='${!order.shipAsComplete}'>
											<span class="text"><fmt:message key="NO" /></span>
										</c:if>
									</flow:ifEnabled>
								</p>
							</div>
						
							<%-- Display Multiple shipment confirmation page --%>
							<c:if test='${param.email != "true"}'>
							<span id="MSOrderConfirmPagingDisplay_ACCE_Label" class="spanacce"><fmt:message key="ACCE_Region_Order_Item_List"/></span>  
							<div dojoType="wc.widget.RefreshArea" widgetId="MSOrderConfirmPagingDisplay" id="MSOrderDetailPagingDisplay" 
								controllerId="MSOrderItemPaginationDisplayController" ariaMessage="<fmt:message key="ACCE_Status_Order_Item_List_Updated"/>" ariaLiveId="${ariaMessageNode}" role="region" aria-labelledby="MSOrderConfirmPagingDisplay_ACCE_Label">
							</c:if>
							<c:choose>
								<c:when test="${WCParam.currentSelection ne 'SubscriptionDetailSlct'}">
									<%out.flush();%>
									<c:import url="/${sdb.jspStoreDir}/ShoppingArea/CheckoutSection/MultipleShipment/MSOrderItemDetailSummary.jsp">  
										<c:param name="catalogId" value="${WCParam.catalogId}" />
										<c:param name="langId" value="${WCParam.langId}" />
										<c:param name="storeId" value="${storeId}"/>
										<c:param name="orderPage" value="confirmation" />
										<c:param name="isFromOrderDetailsPage" value="true" />
									</c:import>
									<%out.flush();%>
								</c:when>
								<c:otherwise>
									<%out.flush();%>
									<c:import url="/${sdb.jspStoreDir}/ShoppingArea/CheckoutSection/MultipleShipment/MSOrderItemDetailSummary.jsp">  
										<c:param name="catalogId" value="${WCParam.catalogId}" />
										<c:param name="langId" value="${WCParam.langId}" />
										<c:param name="storeId" value="${storeId}"/>
										<c:param name="orderPage" value="confirmation" />
										<c:param name="isFromOrderDetailsPage" value="true" />
										<c:param name="subscriptionOrderItemId" value="${WCParam.orderItemId}" />
									</c:import>
									<%out.flush();%>
								</c:otherwise>
							</c:choose>
							<c:if test='${param.email != "true"}'>
							</div>	
								<script type="text/javascript">dojo.addOnLoad(function() { 
									parseWidget("MSOrderDetailPagingDisplay");
									});
								</script>	
							</c:if>
						</c:otherwise>
					</c:choose>
					<c:if test="${WCParam.currentSelection ne 'SubscriptionDetailSlct'}">
						<div id="total_breakdown">
							<table id="order_total" cellpadding="0" cellspacing="0" border="0" role="presentation">
							
								<%-- ORDER SUBTOTAL--%>
								<tr> 
									<td class="total_details" id="WC_SingleShipmentOrderTotalsSummary_td_1"><fmt:message key="MO_ORDERSUBTOTAL" /></td>
									<td class="total_figures" id="WC_SingleShipmentOrderTotalsSummary_td_2">
										<c:choose>
											<c:when test="${!empty order.orderAmount.totalProductPrice.value}">
												<fmt:formatNumber value="${order.orderAmount.totalProductPrice.value}" type="currency" maxFractionDigits="${env_currencyDecimal}" currencySymbol="${env_CurrencySymbolToFormat}"/><c:out value="${CurrencySymbol}"/>
											</c:when>
											<c:otherwise>
												<fmt:message key="MO_NOT_AVAILABLE" />
											</c:otherwise>
										</c:choose>	
									</td>
								</tr>
	
								<%-- DISCOUNT ADJUSTMENTS --%>
								<tr>
									<td class="total_details" id="WC_SingleShipmentOrderTotalsSummary_td_11"><fmt:message key="MO_DISCOUNTADJ" /></td>
									<td class="total_figures" id="WC_SingleShipmentOrderTotalsSummary_td_12">
										<c:choose>
											<c:when test="${!empty order.orderAmount.totalAdjustment.value}">
												<fmt:formatNumber value="${order.orderAmount.totalAdjustment.value}" type="currency" maxFractionDigits="${env_currencyDecimal}" currencySymbol="${env_CurrencySymbolToFormat}"/><c:out value="${CurrencySymbol}"/>
											</c:when>
											<c:otherwise>
												<fmt:message key="MO_NOT_AVAILABLE" />
											</c:otherwise>
										</c:choose>
									</td>
								</tr>
					
								<%-- TAX --%>
								<tr> 
									<td class="total_details" id="WC_SingleShipmentOrderTotalsSummary_td_5"><fmt:message key="MO_TAX" /></td>
									<td class="total_figures" id="WC_SingleShipmentOrderTotalsSummary_td_6">
										<c:choose>
											<c:when test="${!empty order.orderAmount.totalSalesTax.value}">
												<fmt:formatNumber value="${order.orderAmount.totalSalesTax.value}" type="currency" maxFractionDigits="${env_currencyDecimal}" currencySymbol="${env_CurrencySymbolToFormat}"/><c:out value="${CurrencySymbol}"/>
											</c:when>
											<c:otherwise>
												<fmt:message key="MO_NOT_AVAILABLE" />
											</c:otherwise>
										</c:choose>
									</td>
								</tr>	
										
								<%-- SHIPPING CHARGE --%>
								<tr>
									<td class="total_details" id="WC_SingleShipmentOrderTotalsSummary_td_7"><fmt:message key="MO_SHIPPING" /></td>
									<td class="total_figures" id="WC_SingleShipmentOrderTotalsSummary_td_8">
										<c:choose>
											<c:when test="${!empty order.orderAmount.totalShippingCharge.value}">
												<fmt:formatNumber value="${order.orderAmount.totalShippingCharge.value}" type="currency" maxFractionDigits="${env_currencyDecimal}" currencySymbol="${env_CurrencySymbolToFormat}"/><c:out value="${CurrencySymbol}"/>
											</c:when>
											<c:otherwise>
												<fmt:message key="MO_NOT_AVAILABLE" />
											</c:otherwise>
										</c:choose>
									</td>
								</tr>				
					
								<%-- SHIPPING TAX --%>
								<tr>
									<td class="total_details" id="WC_SingleShipmentOrderTotalsSummary_td_14"><fmt:message key="MO_SHIPPING_TAX" /></td>
									<td class="total_figures" id="WC_SingleShipmentOrderTotalsSummary_td_15">
										<c:choose>
											<c:when test="${!empty order.orderAmount.totalShippingTax.value}">
												<fmt:formatNumber value="${order.orderAmount.totalShippingTax.value}" type="currency" maxFractionDigits="${env_currencyDecimal}" currencySymbol="${env_CurrencySymbolToFormat}"/><c:out value="${CurrencySymbol}"/>
											</c:when>
											<c:otherwise>
												<fmt:message key="MO_NOT_AVAILABLE" />
											</c:otherwise>
										</c:choose>	
									</td>
								</tr>
								
								<%-- ORDER TOTAL --%>
								<tr>
									<td class="total_details order_total" id="WC_SingleShipmentOrderTotalsSummary_td_9"><fmt:message key="MO_ORDERTOTAL" /></td>
									<td class="total_figures breadcrumb_current" id="WC_SingleShipmentOrderTotalsSummary_td_10">
										<c:choose>
											<c:when test="${order.orderAmount.grandTotal != null}">
													<c:choose>
													<c:when test="${!empty order.orderAmount.grandTotal.value}">
														<fmt:formatNumber value="${order.orderAmount.grandTotal.value}" type="currency" maxFractionDigits="${env_currencyDecimal}" currencySymbol="${env_CurrencySymbolToFormat}"/><c:out value="${CurrencySymbol}"/>
													</c:when>
													<c:otherwise>
														<fmt:message key="MO_NOT_AVAILABLE" />
													</c:otherwise>
												</c:choose>									
											</c:when>
											<c:otherwise>
												<fmt:message key="MO_NOT_AVAILABLE" />					
											</c:otherwise>
										</c:choose>
									</td>
								</tr>
							</table>
						</div>
					</c:if>
					<br clear="all" />
				</div>
			</div>

			<c:if test="${WCParam.currentSelection ne 'SubscriptionDetailSlct'}">
				<c:set var="scheduledOrderEnabled" value="false"/>
				<c:set var="recurringOrderEnabled" value="false"/>
				<flow:ifEnabled feature="ScheduleOrder">
					<c:set var="scheduledOrderEnabled" value="true"/>
				</flow:ifEnabled>
				<flow:ifEnabled feature="RecurringOrders">
					<c:set var="recurringOrderEnabled" value="true"/>
				</flow:ifEnabled>
				<c:choose>
					<c:when test="${scheduledOrderEnabled == 'true'}">
						<c:if test="${WCParam.isQuote != true}">
							<%out.flush();%>
								<c:import url="/${sdb.jspStoreDir}/ShoppingArea/CheckoutSection/ScheduleOrderDisplayExt.jsp">
									<c:param value="false" name="isShippingBillingPage"/>
									<c:param value="${order.orderIdentifier.uniqueID}" name="orderId"/>
								</c:import>
							<%out.flush();%>
						</c:if>
					</c:when>
					<c:when test="${recurringOrderEnabled == 'true'}">
						<c:if test="${WCParam.isQuote != true}">
							<%out.flush();%>
								<c:import url="/${sdb.jspStoreDir}/ShoppingArea/CheckoutSection/RecurringOrderCheckoutDisplay.jsp">
									<c:param value="false" name="isShippingBillingPage"/>
									<c:param value="${order.orderIdentifier.uniqueID}" name="orderId"/>
									<c:param name="subscriptionId" value="${subscriptionId}"/>
								</c:import>
							<%out.flush();%>
						</c:if>
					</c:when>
					<c:otherwise>
						
					</c:otherwise>
				 </c:choose>
			</c:if>		
			<br/>
			<c:if test="${order.orderTypeCode ne 'SUB'}">
				<div class="myaccount_header" id="WC_OrderShipmentDetails_div_21">
					<div class="left_corner_straight" id="WC_OrderShipmentDetails_div_22"></div>
					<div class="headingtext" id="WC_OrderShipmentDetails_div_23"><span class="header"><fmt:message key="MO_BILLINGINFO" /></span></div>
					<div class="right_corner_straight" id="WC_OrderShipmentDetails_div_24"></div>
				</div>

				<%@ include file="../../../ShoppingArea/CheckoutSection/CheckoutPaymentAndBillingAddressSummary.jspf" %>
				<%@ include file="../../../ShoppingArea/CheckoutSection/OrderAdditionalDetailSummaryExt.jspf" %>
			</c:if>
			<br/>
			<div class="button_footer_line" id="WC_OrderShipmentDetails_div_29">
	
				<div id="WC_OrderShipmentDetails_div_31_1" class="button_primary">
					<a href="#" role="button" class="button_primary" id="WC_OrderDetailDisplay_Print_Link" onclick="JavaScript: print();">
						<div class="left_border"></div>
						<div class="button_text"><fmt:message key="PRINT" /></div>
						<div class="right_border"></div>
					</a>
				</div>
						
				<div class="button_right_side_message" id="WC_OrderShipmentDetails_div_32_1">
					<fmt:message key="PRINT_RECOMMEND" />
				</div>
			</div>	
			<c:if test="${WCParam.currentSelection eq 'RecurringOrderDetailSlct' || WCParam.currentSelection eq 'SubscriptionDetailSlct'}">
				</div>
				</div>
			</c:if>

	<c:if test="${WCParam.currentSelection eq 'RecurringOrderDetailSlct'}">		
		<div id="recurring_order_history" dojoType="dijit.layout.ContentPane" style="display:none">
			<div class="body" id="WC_OrderShipmentDetails_div_26">
				<div role="grid" id="WC_OrderShipmentDetails_div_27" class="order_status_table scheduled_orders" aria-describedby="WC_OrderShipmentDetails_div_28" aria-readonly="true">
					<div id="WC_OrderShipmentDetails_div_28" class="hidden_summary">
						<fmt:message key="MO_SCHEDULED_ORDER_CHILD_ORDERS_TABLE_DESCRIPTION" />
					</div>
					<div dojoType="wc.widget.RefreshArea" widgetId="RecurringOrderChildOrdersDisplay" id="RecurringOrderChildOrdersDisplay" controllerId="RecurringOrderChildOrdersDisplayController">
						<%out.flush();%>
							<c:import url="/${sdb.jspStoreDir}/Snippets/Subscription/RecurringOrder/RecurringOrderChildOrdersTableDetailsDisplay.jsp">
								<c:param name="${objectIdParam}" value="${objectId}"/>
								<c:param name="catalogId" value="${WCParam.catalogId}" />
								<c:param name="langId" value="${WCParam.langId}" />
								<c:param name="storeId" value="${WCParam.storeId}" />
							</c:import>
						<%out.flush();%>
					</div>
				</div>
			</div>
			<div class="footer">
				<div class="left_corner"></div>
				<div class="tile"></div>
				<div class="right_corner"></div>
			</div>
		</div>
	</c:if>
	<c:if test="${WCParam.currentSelection eq 'SubscriptionDetailSlct'}">
		<div id="recurring_order_history" dojoType="dijit.layout.ContentPane" style="display:none">
			<div class="body" id="WC_OrderShipmentDetails_div_26a">
				<div role="grid" id="WC_OrderShipmentDetails_div_27a" class="order_status_table scheduled_orders" aria-describedby="WC_OrderShipmentDetails_div_28a">
					<div id="WC_OrderShipmentDetails_div_28a" class="hidden_summary">
						<fmt:message key="MO_SUBSCRIPTION_CHILD_ORDERS_TABLE_DESCRIPTION" />
					</div>
					<div dojoType="wc.widget.RefreshArea" widgetId="SubscriptionChildOrdersDisplay" id="SubscriptionChildOrdersDisplay" controllerId="SubscriptionChildOrdersDisplayController">
						<%out.flush();%>
							<c:import url="/${sdb.jspStoreDir}/Snippets/Subscription/SubscriptionChildOrdersTableDetailsDisplay.jsp">
								<c:param name="orderItemId" value="${WCParam.orderItemId}"/>
								<c:param name="catalogId" value="${WCParam.catalogId}" />
								<c:param name="langId" value="${WCParam.langId}" />
								<c:param name="storeId" value="${WCParam.storeId}" />
							</c:import>
						<%out.flush();%>
					</div>
				</div>
			</div>
			<div class="footer">
				<div class="left_corner"></div>
				<div class="tile"></div>
				<div class="right_corner"></div>
			</div>
		</div>
	</c:if>

<!-- Content End -->
</div>
</div>
</div>
<!-- END OrderShipmentDetails.jsp -->
