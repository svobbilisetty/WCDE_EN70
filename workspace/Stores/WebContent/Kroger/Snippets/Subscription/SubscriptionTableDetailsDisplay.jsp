<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2010, 2012 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!-- BEGIN SubscriptionTableDetailsDisplay.jsp -->

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ include file="../../Common/EnvironmentSetup.jspf" %>
<%@ include file="../../Common/nocache.jspf" %>

<c:set var="beginIndex" value="${WCParam.beginIndex}" />
<c:if test="${empty beginIndex}">
	<c:set var="beginIndex" value="0" />
</c:if>

<c:set var="pageSize" value="${WCParam.pageSize}" />
<c:if test="${empty pageSize}">
	<c:set var="pageSize" value="${maxOrderItemsPerPage}"/>
</c:if>
<c:if test="${param.isMyAccountMainPage}">
	<c:set var="pageSize" value="3"/>
</c:if>

<c:set var="contextId" value="SubscriptionDisplay_Context"/>

<fmt:message var="openingBrace" key="OPENING_BRACE" />

<jsp:useBean id="now" class="java.util.Date" scope="page"/>

<c:set var="formattedTimeZone" value="${fn:replace(cookie.WC_timeoffset.value, '%2B', '+')}"/>
<c:set var="formattedTimeZone" value="${fn:replace(formattedTimeZone, '.75', ':45')}"/>	
<c:set var="formattedTimeZone" value="${fn:replace(formattedTimeZone, '.5', ':30')}"/>

<wcf:getData type="com.ibm.commerce.subscription.facade.datatypes.SubscriptionType[]" var="subscriptions" varShowVerb="ShowVerbAllSubscriptions" expressionBuilder="findAllSubscriptionsForUser" maxItems="${pageSize}" recordSetStartNumber="${beginIndex}">
		<wcf:param name="storeId" value="${WCParam.storeId}" />
		<wcf:param name="memberId" value="${CommandContext.userId}" />
</wcf:getData>

<c:if test="${empty subscriptions && beginIndex >= pageSize}">
	<c:set var="beginIndex" value="${beginIndex - pageSize}"/>
	<wcf:getData type="com.ibm.commerce.subscription.facade.datatypes.SubscriptionType[]" var="subscriptions" varShowVerb="ShowVerbAllSubscriptions" expressionBuilder="findAllSubscriptionsForUser" maxItems="${pageSize}" recordSetStartNumber="${beginIndex}">
		<wcf:param name="storeId" value="${WCParam.storeId}" />
		<wcf:param name="memberId" value="${CommandContext.userId}" />
	</wcf:getData>
</c:if>

<c:if test="${(param.isMyAccountMainPage == null) || (empty param.isMyAccountMainPage) || (param.isMyAccountMainPage == false)}">

	<c:set var="pageSize" value="${ShowVerbAllSubscriptions.recordSetCount + pageSize - ShowVerbAllSubscriptions.recordSetCount}" />

	<c:set var="numEntries" value="${ShowVerbAllSubscriptions.recordSetTotal}"/>
	<c:if test="${numEntries > pageSize}">
		<fmt:formatNumber var="totalPages" value="${(numEntries/pageSize)}" maxFractionDigits="0"/>		
		<c:if test="${numEntries%pageSize < (pageSize/2)}">
			<fmt:formatNumber var="totalPages" value="${(numEntries+(pageSize/2)-1)/pageSize}" maxFractionDigits="0"/>
		</c:if>
		<fmt:parseNumber var="totalPages" value="${totalPages}" integerOnly="true"/> 
			
		<c:choose>
			<c:when test="${beginIndex + pageSize >= numEntries}">
				<c:set var="endIndex" value="${numEntries}" />
			</c:when>
			<c:otherwise>
				<c:set var="endIndex" value="${beginIndex + pageSize}" />
			</c:otherwise>
		</c:choose>
	
		<fmt:formatNumber var="currentPage" value="${(beginIndex/pageSize)+1}"/>
		<fmt:parseNumber var="currentPage" value="${currentPage}" integerOnly="true"/>
	
		<div id="SubscriptionPagination_1">
			<span id="SubscriptionDetailPagination_span_1a" class="text">
				<fmt:message key="MO_Page_Results" > 
					<fmt:param><fmt:formatNumber value="${beginIndex + 1}"/></fmt:param>
					<fmt:param><fmt:formatNumber value="${endIndex}"/></fmt:param>
					<fmt:param><fmt:formatNumber value="${numEntries}"/></fmt:param>
				</fmt:message>
				<span id="SubscriptionDetailPagination_span_2a" class="paging">
					<c:if test="${beginIndex != 0}">	
						<a id="SubscriptionDetailPagination_previous_link_1" href="javaScript:setCurrentId('SubscriptionDetailPagination_previous_link_1'); if(submitRequest()){cursor_wait();
						wc.render.updateContext('${contextId}',{'beginIndex':'<c:out value='${beginIndex - pageSize}'/>'});}">
					</c:if>
					<img src="<c:out value="${jspStoreImgDir}${env_vfileColor}${vfileColorBIDI}" />paging_back.png" alt="<fmt:message key="CATEGORY_PAGING_LEFT_IMAGE" />" />
					<c:if test="${beginIndex != 0}">
						</a>
					</c:if>
					<fmt:message key="CATEGORY_RESULTS_PAGES_DISPLAYING" > 
						<fmt:param><fmt:formatNumber value="${currentPage}"/></fmt:param>
						<fmt:param><fmt:formatNumber value="${totalPages}"/></fmt:param>
					</fmt:message>
					<c:if test="${numEntries > endIndex }">
						<a id="SubscriptionDetailPagination_next_link_1" href="javaScript:setCurrentId('SubscriptionDetailPagination_next_link_1'); if(submitRequest()){cursor_wait();
						wc.render.updateContext('${contextId}',{'beginIndex':'<c:out value='${beginIndex + pageSize}'/>'});}">
					</c:if>
					<img src="<c:out value="${jspStoreImgDir}${env_vfileColor}${vfileColorBIDI}" />paging_next.png" alt="<fmt:message key="CATEGORY_PAGING_RIGHT_IMAGE" />" />
					<c:if test="${numEntries > endIndex }">
						</a>
					</c:if>
				</span>
			</span>
		</div>
	</c:if>
</c:if>

<c:choose>
<c:when test="${ShowVerbAllSubscriptions.recordSetTotal <= 0}">
	<div role="row"><div role="gridcell"><fmt:message key="NO_SUBSCRIPTIONS_FOUND" /></div></div>
</c:when>
<c:otherwise>

<div role="row" id="SubscriptionDetailsDisplayExt_ul_1" class="ul column_heading">
<div role="columnheader" id="SubscriptionDetailsDisplayExt_li_header_1" class="li order_number_column_1"><fmt:message key="MA_SUBSCRIPTION" /></div>
<div role="columnheader" id="SubscriptionDetailsDisplayExt_li_header_2" class="li next_order_column_1"><fmt:message key="MO_NEXT_ORDER" /></div>
<div role="columnheader" id="SubscriptionDetailsDisplayExt_li_header_3" class="li next_order_column_1"><fmt:message key="MA_EXPIRY_DATE" /></div>
<div role="columnheader" id="SubscriptionDetailsDisplayExt_li_header_4" class="li order_status_column_1"><fmt:message key="MO_SUBSCRIPTION_STATUS" /></div>
<div role="columnheader" id="SubscriptionDetailsDisplayExt_li_header_5" class="li total_price_column_1"><fmt:message key="TABLE_PRICE" /></div>
<div role="columnheader" id="SubscriptionDetailsDisplayExt_li_header_6" class="li options_column"><span class="spanacce"><fmt:message key="MO_ACCE_BUTTON_COLUMN" /></span></div>
<div id="SubscriptionDetailsDisplayExt_li_header_7" class="li clear_float"></div>
</div>
<c:forEach var="order" items="${subscriptions}" varStatus="status">
<c:choose>
	<c:when test="${order.purchaseDetails.parentOrderIdentifier.externalOrderID != null}">
		<c:set var="objectId" value="${order.purchaseDetails.parentOrderIdentifier.externalOrderID}"/>
		<c:set var="objectIdParam" value="externalOrderId"/>
	</c:when>
	<c:otherwise>
		<c:set var="objectId" value="${order.purchaseDetails.parentOrderIdentifier.uniqueID}"/>
		<c:set var="objectIdParam" value="orderId"/>
	</c:otherwise>
</c:choose>
	
<%-- Need to reset currencyFormatterDB as initialized in JSTLEnvironmentSetup.jspf, as the currency code used there is from commandContext. For order history we want to display with currency used when the order was placed. --%>
<c:remove var="currencyFormatterDB"/>
<c:choose>
	<c:when test ="${order.subscriptionInfo.paymentInfo.totalCost.value != null}">
		<wcbase:useBean id="currencyFormatterDB" classname="com.ibm.commerce.common.beans.StoreCurrencyFormatDescriptionDataBean" scope="request" >
			<c:set property="storeId" value="${storeId}" target="${currencyFormatterDB}" />
			<c:set property="langId" value="${langId}" target="${currencyFormatterDB}" />
			<c:set property="currencyCode" value="${order.subscriptionInfo.paymentInfo.totalCost.currency}" target="${currencyFormatterDB}" />
			<c:set property="numberUsage" value="-1" target="${currencyFormatterDB}" />
		</wcbase:useBean>
		<c:set var="currencyDecimal" value="${currencyFormatterDB.decimalPlaces}"/>
		
		<c:if test="${order.subscriptionInfo.paymentInfo.totalCost.currency == 'KRW'}">
			<c:set property="currencySymbol" value="&#8361;" target="${currencyFormatterDB}"/>
		</c:if>

		<c:if test="${order.subscriptionInfo.paymentInfo.totalCost.currency == 'PLN'}">
			<c:set property="currencySymbol" value="z&#322;" target="${currencyFormatterDB}"/>
		</c:if>		
		
		<%-- These variables are used to hold the currency symbol --%>
		<c:choose>
			<c:when test="${order.subscriptionInfo.paymentInfo.totalCost.currency == 'ar_EG' && order.subscriptionInfo.paymentInfo.totalCost.currency == 'EGP'}">
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

	<wcbase:useBean id="catEntry" classname="com.ibm.commerce.catalog.beans.CatalogEntryDataBean">
				<c:set property="catalogEntryID" value="${order.purchaseDetails.subscribedItem.uniqueID}" target="${catEntry}" />
	</wcbase:useBean>

	<c:choose>
		<c:when test="${fn:contains(catEntry.description.name,openingBrace)}">
			<c:set var="subscriptionName" value="${fn:substringBefore(catEntry.description.name,openingBrace)}"/>
		</c:when>
		<c:otherwise>
			<c:set var="subscriptionName" value="${catEntry.description.name}"/>
		</c:otherwise>
	</c:choose>

	<div role="row" id="SubscriptionDisplay_ul_2_${status.count}" class="ul row">
				<wcf:url value="OrderDetail" var="SubscriptionDetailUrl1">
					<wcf:param name="${objectIdParam}" value="${objectId}"/>
					<wcf:param name="storeId" value="${WCParam.storeId}"/>
					<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
					<wcf:param name="langId" value="${WCParam.langId}"/>
					<wcf:param name="currentSelection" value="SubscriptionDetailSlct"/>
					<wcf:param name="subscriptionId" value="${order.subscriptionIdentifier.uniqueID}"/>
					<wcf:param name="orderItemId" value="${order.purchaseDetails.parentOrderItemIdentifier.uniqueID}"/>
					<wcf:param name="subscriptionName" value="${subscriptionName}"/>
					<wcf:param name="subscriptionCatalogEntryId" value="${order.purchaseDetails.subscribedItem.uniqueID}"/>
				</wcf:url>

			<div role="gridcell" id="SubscriptionDetailsDisplayExt_subscription_name_<c:out value='${status.count}'/>" class="li order_number_column_1">
				<span>
					<c:choose>
							<c:when test="${!empty objectId}">
								<c:out value="${subscriptionName}"/>	
							</c:when>
							<c:otherwise>
								<fmt:message key="MO_NOT_AVAILABLE" />	
							</c:otherwise>
					</c:choose>					
				</span>
				<br/>

				<c:if test="${fn:contains(catEntry.description.name,openingBrace)}">
					<c:out value="${openingBrace}"/><c:out value="${fn:substringAfter(catEntry.description.name,openingBrace)}"/>
					<br/>
				</c:if>
				
				<a href="<c:out value='${SubscriptionDetailUrl1}'/>" class="myaccount_link hover_underline" id="SubscriptionLink_NonAjax_<c:out value='${status.count}'/>"><fmt:message key="DETAILS" /></a>
				
			</div>

			<div role="gridcell" id="SubscriptionDetailsDisplayExt_subscription_duration_<c:out value='${status.count}'/>" class="li next_order_column_1">
				<c:choose>
					<c:when test="${order.state eq 'Active' || order.state eq 'PendingCancel' || order.state eq 'InActive'}">
						<c:catch>
							<fmt:parseDate parseLocale="${dateLocale}" var="nextShipment" value="${order.subscriptionInfo.fulfillmentSchedule.frequencyInfo.nextOccurence}" pattern="yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" timeZone="GMT"/>
						</c:catch>

						<c:if test="${empty nextShipment}">
							<c:catch>
								<fmt:parseDate parseLocale="${dateLocale}" var="nextShipment" value="${order.subscriptionInfo.fulfillmentSchedule.frequencyInfo.nextOccurence}" pattern="yyyy-MM-dd'T'HH:mm:ss'Z'" timeZone="GMT"/>
							</c:catch>
						</c:if>

						<fmt:formatDate var="formattedNextShipmentDate" value="${nextShipment}" dateStyle="long" timeZone="${formattedTimeZone}"/>
						<span><c:out value="${formattedNextShipmentDate}"/></span>
					</c:when>
					<c:otherwise>
						<span><c:out value="-"/></span>
					</c:otherwise>
				</c:choose>
			</div>

			<div role="gridcell" id="SubscriptionDetailsDisplayExt_expiry_date_<c:out value='${status.count}'/>" class="li next_order_column_1">
				<c:catch>
					<fmt:parseDate parseLocale="${dateLocale}" var="expiryTime" value="${order.subscriptionInfo.fulfillmentSchedule.endInfo.endDate}" pattern="yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" timeZone="GMT"/>
				</c:catch>

				<c:if test="${empty nextTime}">
					<c:catch>
						<fmt:parseDate parseLocale="${dateLocale}" var="expiryTime" value="${order.subscriptionInfo.fulfillmentSchedule.endInfo.endDate}" pattern="yyyy-MM-dd'T'HH:mm:ss'Z'" timeZone="GMT"/>
					</c:catch>
				</c:if>

				<fmt:parseNumber var="timeDifference1" value="${(expiryTime.time - now.time)/1000}" integerOnly="true"/>

				<c:choose>
					<c:when test="${timeDifference1 > 0 && order.state ne 'Cancelled'}">
						<c:set var="renewTime" value="${order.subscriptionInfo.fulfillmentSchedule.endInfo.endDate}" />
					</c:when>
					<c:otherwise>
						<fmt:parseNumber var="now_year" value="${now.year + 1900}" integerOnly="true"/>
						<fmt:parseNumber var="now_month" value="${now.month + 1}" integerOnly="true"/>
						<fmt:parseNumber var="now_date" value="${now.date}" integerOnly="true"/>
						<fmt:parseNumber var="now_hours" value="${now.hours}" integerOnly="true"/>
						<fmt:parseNumber var="now_minutes" value="${now.minutes}" integerOnly="true"/>
						<fmt:parseNumber var="now_seconds" value="${now.seconds}" integerOnly="true"/>

						<c:if test="${now_month < 10}">
							<c:set var="now_month" value="0${now_month}"/>
						</c:if>
						<c:if test="${now_date < 10}">
							<c:set var="now_date" value="0${now_date}"/>
						</c:if>
						<c:if test="${now_hours < 10}">
							<c:set var="now_hours" value="0${now_hours}"/>
						</c:if>
						<c:if test="${now_minutes < 10}">
							<c:set var="now_minutes" value="0${now_minutes}"/>
						</c:if>
						<c:if test="${now_seconds < 10}">
							<c:set var="now_seconds" value="0${now_seconds}"/>
						</c:if>

						<c:set var="renewTime" value="${now_year}-${now_month}-${now_date}T${now_hours}:${now_minutes}:${now_seconds}.000Z"/>
					</c:otherwise>
				</c:choose>

				<fmt:formatDate var="formattedExpiryDate" value="${expiryTime}" dateStyle="long" timeZone="${formattedTimeZone}"/>
				<span><c:out value="${formattedExpiryDate}"/></span>
			</div>

			<c:catch>
				<fmt:parseDate parseLocale="${dateLocale}" var="nextTime" value="${order.subscriptionInfo.fulfillmentSchedule.frequencyInfo.nextOccurence}" pattern="yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" timeZone="GMT"/>
			</c:catch>

			<c:if test="${empty nextTime}">
				<c:catch>
					<fmt:parseDate parseLocale="${dateLocale}" var="nextTime" value="${order.subscriptionInfo.fulfillmentSchedule.frequencyInfo.nextOccurence}" pattern="yyyy-MM-dd'T'HH:mm:ss'Z'" timeZone="GMT"/>
				</c:catch>
			</c:if>
			<c:set var="indexTime" value="${nextTime}" />
			<fmt:formatDate var="formattedNextOrderDate" value="${nextTime}" dateStyle="long" timeZone="${formattedTimeZone}"/>
			<fmt:parseNumber var="timeDifference" value="${(indexTime.time - now.time)/1000}" parseLocale="${dateLocale}" integerOnly="true"/>
			<fmt:parseNumber var="cancelSubscriptionNoticePeriod1" value="${cancelSubscriptionNoticePeriod}" integerOnly="true"/>
			<c:choose>
				<c:when test="${timeDifference >= cancelSubscriptionNoticePeriod1}">
					<fmt:message key="SUBSCRIPTION_CANCEL_PER"  var="cancelMessage"/>
				</c:when>
				<c:otherwise>
					<fmt:message key="SUBSCRIPTION_CANCEL_NOTICE_PERIOD_MSG"  var="cancelMessage"> 
						<fmt:param><c:out value="${formattedNextOrderDate}" escapeXml="false"/></fmt:param>
					</fmt:message>
				</c:otherwise>
			</c:choose>
			<div role="gridcell" id="SubscriptionDetailsDisplayExt_order_status_<c:out value='${status.count}'/>" class="li order_status_column_1">
				<span>
					<c:choose>
						<c:when test="${!empty order.state}">
							<c:choose>
								<c:when test="${order.state eq 'InActive'}" >
									<fmt:message key="INACTIVE_STATE" />
								</c:when>
								<c:when test="${order.state eq 'Active'}" >
									<fmt:message key="ACTIVE_STATE" />
								</c:when>
								<c:when test="${order.state eq 'Expired'}" >
									<fmt:message key="EXPIRED_STATE" />
								</c:when>
								<c:when test="${order.state eq 'Cancelled'}" >
									<fmt:message key="CANCELLED_STATE" />
								</c:when>
								<c:when test="${order.state eq 'Completed'}" >
									<fmt:message key="COMPLETED_STATE" />
								</c:when>
								<c:when test="${order.state eq 'Suspended'}" >
									<fmt:message key="SUSPENDED_STATE" />
								</c:when>
								<c:when test="${order.state eq 'PendingCancel'}" >
									<fmt:message key="PENDING_CANCEL_STATE" />
								</c:when>
							</c:choose>
						</c:when>
						<c:otherwise>
							<fmt:message key="MO_NOT_AVAILABLE" />
						</c:otherwise>
					</c:choose>
				</span>
			</div>

			<div role="gridcell" id="SubscriptionDetailsDisplayExt_total_price_<c:out value='${status.count}'/>" class="li total_price_column_1">					
				<span class="price">
					<c:choose>
						<c:when test="${order.subscriptionInfo.paymentInfo.totalCost.value != null}">
							<c:choose>
								<c:when test="${!empty order.subscriptionInfo.paymentInfo.totalCost.value}">
									<fmt:formatNumber value="${order.subscriptionInfo.paymentInfo.totalCost.value}" type="currency" maxFractionDigits="${currencyDecimal}" currencySymbol="${CurrencySymbolToFormat}"/>
									<c:out value="${CurrencySymbol}"/>
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
				</span>
			</div>

			<c:if test="${order.state eq 'Active'}" >
			<div role="gridcell" id="SubscriptionDetailsDisplayExt_option_<c:out value='${status.count}'/>" class="li options_column">
				<div class="option_button"> 
					<div id="subscription_showOptions_<c:out value='${status.count}'/>" class="option_button">
						<a href="javascript:void(0);" class="button_primary" id="SubscriptionDetailsDisplayExt_option_button_3b_<c:out value='${status.count}'/>" tabindex="0" width="100%" onkeypress="javaScript:MyAccountDisplay.showActionsPopup(event,'subscription_showOptions_<c:out value='${status.count}'/>','subscription_actions_popup_<c:out value='${status.count}'/>', 'actions_popup_widget_subscription');" onclick="javaScript:MyAccountDisplay.showActionsPopup(null,'subscription_showOptions_<c:out value='${status.count}'/>','subscription_actions_popup_<c:out value='${status.count}'/>', 'actions_popup_widget_subscription');">
							<div class="left_border"></div>
							<div class="button_text"><fmt:message key="MO_ACTIONS" /><img class="actions_down_arrow" src="<c:out value="${jspStoreImgDir}${vfileColor}transparent.gif"/>" alt="<fmt:message key='DOWN_ARROW_IMAGE' bundle='${storeText}'/>"/></div>
							<div class="right_border"></div>
						</a>
					</div>
				</div>
			</div>
			</c:if>

			<c:if test="${order.state ne 'Active'}" >
				<div role="gridcell" id="SubscriptionDetailsDisplayExt_option_<c:out value='${status.count}'/>" class="li options_column">
							<c:if test="${param.isQuote != true}">
								<wcf:url value="AjaxOrderCopy" var="SubscriptionCopyUrl" type="Ajax">
									<wcf:param name="fromOrderId_1" value="${objectId}"/>
									<wcf:param name="toOrderId" value=".**."/>
									<wcf:param name="copyOrderItemId_1" value="${order.purchaseDetails.parentOrderItemIdentifier.uniqueID}"/>
									<wcf:param name="URL" value="AjaxOrderItemDisplayView"/>
									<wcf:param name="storeId" value="${WCParam.storeId}"/>
									<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
									<wcf:param name="langId" value="${WCParam.langId}"/>
								</wcf:url>
								<div id="SubscriptionDetailsDisplayExt_option_1_<c:out value='${status.count}'/>" class="option_button">
									<div class="option_button">
										<a href="#" class="button_primary" id="SubscriptionDetailsDisplayExt_option_button_link_1_<c:out value='${status.count}'/>" tabindex="0" width="100%" onclick="javaScript:setCurrentId('SubscriptionDetailsDisplayExt_option_button_link_1_<c:out value='${status.count}'/>'); MyAccountDisplay.setSubscriptionDate('<c:out value='${renewTime}'/>'); MyAccountDisplay.prepareSubscriptionRenew('<c:out value='${SubscriptionCopyUrl}'/>');">
											<div class="left_border"></div>
											<div class="button_text"><fmt:message key="MA_RENEW" /></div>
											<div class="right_border"></div>
										</a>
									</div>
								</div>
							</c:if>
				</div>
			</c:if>

		
				

		<div id="subscription_actions_popup_<c:out value='${status.count}'/>" style="display:none" >
			<div id="subscription_actions_popup_div1_<c:out value='${status.count}'/>" class="actions_popup hover_underline">
				<div id="subscription_actions_popup_renew_<c:out value='${status.count}'/>" class="reorder">
							<c:if test="${param.isQuote != true}">
								<wcf:url value="AjaxOrderCopy" var="SubscriptionCopyUrl" type="Ajax">
									<wcf:param name="fromOrderId_1" value="${objectId}"/>
									<wcf:param name="toOrderId" value=".**."/>
									<wcf:param name="copyOrderItemId_1" value="${order.purchaseDetails.parentOrderItemIdentifier.uniqueID}"/>
									<wcf:param name="URL" value="AjaxOrderItemDisplayView"/>
									<wcf:param name="storeId" value="${WCParam.storeId}"/>
									<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
									<wcf:param name="langId" value="${WCParam.langId}"/>
								</wcf:url>
								<a href="javaScript:setCurrentId('SubscriptionDetailsDisplayExt_option_button_3b_<c:out value='${status.count}'/>'); MyAccountDisplay.setSubscriptionDate('<c:out value='${renewTime}'/>'); MyAccountDisplay.prepareSubscriptionRenew('<c:out value='${SubscriptionCopyUrl}'/>');" width="100%" id="SubscriptionDetailsDisplayExt_option_button_link_2_<c:out value='${status.count}'/>" class="link"><fmt:message key="MA_RENEW" /></a>
							</c:if>
				</div>
				<input type="hidden" id="cancelMessage_<c:out value='${status.count}'/>" name="cancelMessage_<c:out value='${status.count}'/>" value="${cancelMessage}">
				<div id="subscription_actions_popup_cancel_<c:out value='${status.count}'/>" class="cancel">
					<a href="javaScript:setCurrentId('Subscription_CancelButton_Ajax_<c:out value='${status.count}'/>'); dijit.byId('actions_popup_widget_subscription').hide(); MyAccountDisplay.showPopup('subscription',${order.subscriptionIdentifier.uniqueID},'cancelMessage_<c:out value='${status.count}'/>');" width="100%" id="Subscription_CancelButton_Ajax_<c:out value='${status.count}'/>" class="link"><fmt:message key="SUBSCRIPTION_CANCEL" /></a>
				</div>
			</div>
		</div>
					

		<div role="gridcell" id="SubscriptionDetailsDisplayExt_clear_float_<c:out value='${status.count}'/>" class="li clear_float"></div>
	</div>
	<c:remove var="catEntry"/>
</c:forEach>
</c:otherwise>
</c:choose>

<c:if test="${(param.isMyAccountMainPage == null) || (empty param.isMyAccountMainPage) || (param.isMyAccountMainPage == false)}">
	<c:if test="${numEntries > pageSize}">
		<div id="SubscriptionPagination_2">
			<span id="SubscriptionDetailPagination_span_1b" class="text">
				<fmt:message key="MO_Page_Results" > 
					<fmt:param><fmt:formatNumber value="${beginIndex + 1}"/></fmt:param>
					<fmt:param><fmt:formatNumber value="${endIndex}"/></fmt:param>
					<fmt:param><fmt:formatNumber value="${numEntries}"/></fmt:param>
				</fmt:message>
				<span id="SubscriptionDetailPagination_span_2b" class="paging">
					<c:if test="${beginIndex != 0}">	
						<a id="SubscriptionDetailPagination_previous_link_2" href="javaScript:setCurrentId('SubscriptionDetailPagination_previous_link_2'); if(submitRequest()){cursor_wait();
						wc.render.updateContext('${contextId}',{'beginIndex':'<c:out value='${beginIndex - pageSize}'/>'});}">
					</c:if>
					<img src="<c:out value="${jspStoreImgDir}${env_vfileColor}${vfileColorBIDI}" />paging_back.png" alt="<fmt:message key="CATEGORY_PAGING_LEFT_IMAGE" />" />
					<c:if test="${beginIndex != 0}">
						</a>
					</c:if>
					<fmt:message key="CATEGORY_RESULTS_PAGES_DISPLAYING" > 
						<fmt:param><fmt:formatNumber value="${currentPage}"/></fmt:param>
						<fmt:param><fmt:formatNumber value="${totalPages}"/></fmt:param>
					</fmt:message>
					<c:if test="${numEntries > endIndex }">
						<a id="SubscriptionDetailPagination_next_link_2" href="javaScript:setCurrentId('SubscriptionDetailPagination_next_link_2'); if(submitRequest()){cursor_wait();
						wc.render.updateContext('${contextId}',{'beginIndex':'<c:out value='${beginIndex + pageSize}'/>'});}">
					</c:if>
					<img src="<c:out value="${jspStoreImgDir}${env_vfileColor}${vfileColorBIDI}" />paging_next.png" alt="<fmt:message key="CATEGORY_PAGING_RIGHT_IMAGE" />" />
					<c:if test="${numEntries > endIndex }">
						</a>
					</c:if>
				</span>
			</span>
		</div>
	</c:if>
</c:if>
<div id='actions_popup_widget_subscription' style='display:none'></div>

<!-- END SubscriptionTableDetailsDisplay.jsp -->
