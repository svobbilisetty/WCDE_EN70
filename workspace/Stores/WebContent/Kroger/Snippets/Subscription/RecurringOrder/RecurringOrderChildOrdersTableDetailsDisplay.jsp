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

<!-- BEGIN RecurringOrderChildOrdersTableDetailsDisplay.jsp -->

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ include file="../../../Common/EnvironmentSetup.jspf" %>
<%@ include file="../../../Common/nocache.jspf" %>

<c:set var="beginIndex" value="${WCParam.beginIndex}" />
<c:if test="${empty beginIndex}">
	<c:set var="beginIndex" value="0" />
</c:if>

<c:set var="pageSize" value="${WCParam.pageSize}" />
<c:if test="${empty pageSize}">
	<c:set var="pageSize" value="${maxOrderItemsPerPage}"/>
</c:if>

<c:set var="orderId" value="${WCParam.orderId}"/>

<c:set var="contextId" value="RecurringOrderChildOrdersDisplay_Context"/>

<jsp:useBean id="now" class="java.util.Date" scope="page"/>

<c:set var="formattedTimeZone" value="${fn:replace(cookie.WC_timeoffset.value, '%2B', '+')}"/>
<c:set var="formattedTimeZone" value="${fn:replace(formattedTimeZone, '.75', ':45')}"/>	
<c:set var="formattedTimeZone" value="${fn:replace(formattedTimeZone, '.5', ':30')}"/>

<wcf:getData type="com.ibm.commerce.order.facade.datatypes.OrderType[]" var="childOrders" varShowVerb="ShowVerbAllChildOrders" expressionBuilder="findChildOrdersByParentOrderUniqueID" maxItems="${pageSize}" recordSetStartNumber="${beginIndex}">
		<wcf:param name="orderId" value="${orderId}"/>
		<wcf:param name="storeId" value="${WCParam.storeId}" />
</wcf:getData>

<c:if test="${empty childOrders && beginIndex >= pageSize}">
	<c:set var="beginIndex" value="${beginIndex - pageSize}"/>
	<wcf:getData type="com.ibm.commerce.order.facade.datatypes.OrderType[]" var="childOrders" varShowVerb="ShowVerbAllChildOrders" expressionBuilder="findChildOrdersByParentOrderUniqueID" maxItems="${pageSize}" recordSetStartNumber="${beginIndex}">
		<wcf:param name="orderId" value="${orderId}"/>
		<wcf:param name="storeId" value="${WCParam.storeId}" />
	</wcf:getData>
</c:if>

<c:set var="pageSize" value="${ShowVerbAllChildOrders.recordSetCount + pageSize - ShowVerbAllChildOrders.recordSetCount}" />
	
<c:set var="numEntries" value="${ShowVerbAllChildOrders.recordSetTotal}"/>
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
	<div id="RecurringOrderChildOrdersPagination_1">
		<span id="RecurringOrderChildOrdersDetailPagination_span_1a" class="text">
			<fmt:message key="MO_Page_Results" > 
				<fmt:param><fmt:formatNumber value="${beginIndex + 1}"/></fmt:param>
				<fmt:param><fmt:formatNumber value="${endIndex}"/></fmt:param>
				<fmt:param><fmt:formatNumber value="${numEntries}"/></fmt:param>
			</fmt:message>
			<span id="RecurringOrderChildOrdersDetailPagination_span_2a" class="paging">
				<c:if test="${beginIndex != 0}">	
					<a id="RecurringOrderChildOrdersDetailPagination_previous_link_1" href="javaScript:setCurrentId('RecurringOrderChildOrdersDetailPagination_previous_link_1'); if(submitRequest()){cursor_wait();
					wc.render.updateContext('${contextId}',{'beginIndex':'<c:out value='${beginIndex - pageSize}'/>',orderId:'<c:out value='${orderId}'/>'});}">
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
					<a id="RecurringOrderChildOrdersDetailPagination_next_link_1" href="javaScript:setCurrentId('RecurringOrderChildOrdersDetailPagination_next_link_1'); if(submitRequest()){cursor_wait();
					wc.render.updateContext('${contextId}',{'beginIndex':'<c:out value='${beginIndex + pageSize}'/>',orderId:'<c:out value='${orderId}'/>'});}">
				</c:if>
				<img src="<c:out value="${jspStoreImgDir}${env_vfileColor}${vfileColorBIDI}" />paging_next.png" alt="<fmt:message key="CATEGORY_PAGING_RIGHT_IMAGE" />" />
				<c:if test="${numEntries > endIndex }">
					</a>
				</c:if>
			</span>
		</span>
	</div>
</c:if>


<c:choose>
<c:when test="${ShowVerbAllChildOrders.recordSetTotal <= 0}">
	<div role="row"><div role="gridcell"><fmt:message key="MO_NOORDERSFOUND" /></div></div>
</c:when>
<c:otherwise>

<div role="row" id="RecurringOrderChildOrdersDetailsDisplayExt_ul_1" class="ul column_heading">
<div role="columnheader" id="RecurringOrderChildOrdersDetailsDisplayExt_li_header_1" class="li order_number_column">
<c:set var="messageKey" value="ORD_ORDER_NUMBER"/>	
<fmt:message key="${messageKey}" />
</div>
<div role="columnheader" id="RecurringOrderChildOrdersDetailsDisplayExt_li_header_2" class="li order_scheduled_column"><fmt:message key="ORD_ORDER_DATE" /></div>
<div role="columnheader" id="RecurringOrderChildOrdersDetailsDisplayExt_li_header_4" class="li order_status_column_history"><fmt:message key="MO_SUBSCRIPTION_STATUS" /></div>
<div role="columnheader" id="RecurringOrderChildOrdersDetailsDisplayExt_li_header_5" class="li total_price_column"><fmt:message key="TOTAL_PRICE" /></div>
<div id="RecurringOrderChildOrdersDetailsDisplayExt_li_header_7" class="li clear_float"></div>
</div>
<c:forEach var="order" items="${childOrders}" varStatus="status">
<c:choose>
<c:when test="${param.isQuote eq true}">
	<c:set var="quote" value="${order}"/>
	<c:set var="order" value="${quote.orderTemplate}"/>
	<c:choose>
		<c:when test="${quote.quoteIdentifier.externalQuoteID != null}">
			<c:set var="objectId" value="${quote.quoteIdentifier.externalQuoteID}"/>
			<c:set var="objectIdParam" value="externalQuoteId"/>
		</c:when>
		<c:otherwise>
			<c:set var="objectId" value="${quote.quoteIdentifier.uniqueID}"/>
			<c:set var="objectIdParam" value="quoteId"/>
		</c:otherwise>
	</c:choose>
</c:when>
<c:otherwise>
	<c:choose>
		<c:when test="${order.orderIdentifier.externalOrderID != null}">
			<c:set var="objectId" value="${order.orderIdentifier.externalOrderID}"/>
			<c:set var="objectIdParam" value="externalOrderId"/>
		</c:when>
		<c:otherwise>
			<c:set var="objectId" value="${order.orderIdentifier.uniqueID}"/>
			<c:set var="objectIdParam" value="orderId"/>
		</c:otherwise>
	</c:choose>
</c:otherwise>
</c:choose>
	
<%-- Need to reset currencyFormatterDB as initialized in JSTLEnvironmentSetup.jspf, as the currency code used there is from commandContext. For order history we want to display with currency used when the order was placed. --%>
<c:remove var="currencyFormatterDB"/>
<c:choose>
	<c:when test ="${order.orderAmount.grandTotal.value != null}">
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

	<div role="row" id="RecurringOrderChildOrdersDisplay_ul_2_${status.count}" class="ul row">
			
				<wcf:url value="OrderDetail" var="OrderDetailUrl1">
					<wcf:param name="${objectIdParam}" value="${objectId}"/>
					<wcf:param name="orderStatusCode" value="${order.orderStatus.status}"/>
					<wcf:param name="storeId" value="${WCParam.storeId}"/>
					<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
					<wcf:param name="langId" value="${WCParam.langId}"/>
					<c:if test="${param.isQuote eq true}">
						<wcf:param name="isQuote" value="true"/>
					</c:if>
				</wcf:url>

			<div role="gridcell" id="RecurringOrderChildOrdersDetailsDisplayExt_order_number_<c:out value='${status.count}'/>" class="li order_number_column">
				<span>
					<c:choose>
							<c:when test="${!empty objectId}">
								<c:out value="${objectId}"/>
							</c:when>
							<c:otherwise>
								<fmt:message key="MO_NOT_AVAILABLE" />	
							</c:otherwise>
					</c:choose>					
				</span>
				<a href="<c:out value='${OrderDetailUrl1}'/>" class="myaccount_link hover_underline" id="RecurringOrderChildOrdersDetailLink_NonAjax_<c:out value='${status.count}'/>"><fmt:message key="DETAILS" /></a>
			</div>

			<div role="gridcell" id="RecurringOrderChildOrdersDetailsDisplayExt_order_scheduled_<c:out value='${status.count}'/>" class="li order_scheduled_column">
				<c:catch>
					<fmt:parseDate parseLocale="${dateLocale}" var="orderDate" value="${order.placedDate}" pattern="yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" timeZone="GMT"/>
				</c:catch>
				<c:if test="${empty orderDate}">
					<c:catch>
						<fmt:parseDate parseLocale="${dateLocale}" var="orderDate" value="${order.placedDate}" pattern="yyyy-MM-dd'T'HH:mm:ss'Z'" timeZone="GMT"/>
					</c:catch>
				</c:if>
				<span>
				<c:choose>
					<c:when test="${!empty orderDate}">
						<fmt:formatDate value="${orderDate}" dateStyle="long" timeZone="${formattedTimeZone}"/>				
					</c:when>
					<c:otherwise>
						<fmt:message key="MO_NOT_AVAILABLE" />
					</c:otherwise>
				</c:choose>
								
				</span>
			</div>
			
			<div role="gridcell" id="RecurringOrderChildOrdersDetailsDisplayExt_order_status_<c:out value='${status.count}'/>" class="li order_status_column_history">
				<span>
					<c:choose>
						<c:when test="${!empty order.orderStatus.status}">
								<span><fmt:message key="MO_OrderStatus_${order.orderStatus.status}" /></span>
						</c:when>
						<c:otherwise>
							<fmt:message key="MO_NOT_AVAILABLE" />								
						</c:otherwise>
					</c:choose>
				</span>
			</div>

			<div role="gridcell" id="RecurringOrderChildOrdersDetailsDisplayExt_total_price_<c:out value='${status.count}'/>" class="li total_price_column">					
				<span class="price">
					<c:choose>
					    <c:when test="${order.orderAmount.grandTotal != null}">
							<c:choose>
								<c:when test="${!empty order.orderAmount.grandTotal.value}">
									<fmt:formatNumber value="${order.orderAmount.grandTotal.value}" type="currency" maxFractionDigits="${currencyDecimal}" currencySymbol="${CurrencySymbolToFormat}"/>
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

		<div role="gridcell" id="RecurringOrderChildOrdersDetailsDisplayExt_clear_float_<c:out value='${status.count}'/>" class="li clear_float"></div>
	</div>
</c:forEach>
</c:otherwise>
</c:choose>

<c:if test="${numEntries > pageSize}">
	<div id="RecurringOrderChildOrdersPagination_2">
		<span id="RecurringOrderChildOrdersDetailPagination_span_1b" class="text">
			<fmt:message key="MO_Page_Results" > 
				<fmt:param><fmt:formatNumber value="${beginIndex + 1}"/></fmt:param>
				<fmt:param><fmt:formatNumber value="${endIndex}"/></fmt:param>
				<fmt:param><fmt:formatNumber value="${numEntries}"/></fmt:param>
			</fmt:message>
			<span id="RecurringOrderChildOrdersDetailPagination_span_2b" class="paging">
				<c:if test="${beginIndex != 0}">	
					<a id="RecurringOrderChildOrdersDetailPagination_previous_link_2" href="javaScript:setCurrentId('RecurringOrderChildOrdersDetailPagination_previous_link_2'); if(submitRequest()){cursor_wait();
					wc.render.updateContext('${contextId}',{'beginIndex':'<c:out value='${beginIndex - pageSize}'/>',orderId:'<c:out value='${orderId}'/>'});}">
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
					<a id="RecurringOrderChildOrdersDetailPagination_next_link_2" href="javaScript:setCurrentId('RecurringOrderChildOrdersDetailPagination_next_link_2'); if(submitRequest()){cursor_wait();
					wc.render.updateContext('${contextId}',{'beginIndex':'<c:out value='${beginIndex + pageSize}'/>',orderId:'<c:out value='${orderId}'/>'});}">
				</c:if>
				<img src="<c:out value="${jspStoreImgDir}${env_vfileColor}${vfileColorBIDI}" />paging_next.png" alt="<fmt:message key="CATEGORY_PAGING_RIGHT_IMAGE" />" />
				<c:if test="${numEntries > endIndex }">
					</a>
				</c:if>
			</span>
		</span>
	</div>
</c:if>

<!-- END RecurringOrderChildOrdersTableDetailsDisplay.jsp -->
