<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2010 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!-- BEGIN SubscriptionChildOrdersTableDetailsDisplay.jsp -->

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ include file="../../Common/EnvironmentSetup.jspf"%>
<%@ include file="../../Common/nocache.jspf"%>

<c:set var="beginIndex" value="${WCParam.beginIndex}" />
<c:if test="${empty beginIndex}">
	<c:set var="beginIndex" value="0" />
</c:if>

<c:set var="pageSize" value="${WCParam.pageSize}" />
<c:if test="${empty pageSize}">
	<c:set var="pageSize" value="${maxOrderItemsPerPage}"/>
</c:if>

<c:set var="orderItemId" value="${WCParam.orderItemId}"/>
<c:set var="subscriptionName" value="${WCParam.subscriptionName}"/>

<c:set var="contextId" value="SubscriptionChildOrdersDisplay_Context"/>

<jsp:useBean id="now" class="java.util.Date" scope="page"/>

<c:set var="formattedTimeZone" value="${fn:replace(cookie.WC_timeoffset.value, '%2B', '+')}"/>
<c:set var="formattedTimeZone" value="${fn:replace(formattedTimeZone, '.75', ':45')}"/>	
<c:set var="formattedTimeZone" value="${fn:replace(formattedTimeZone, '.5', ':30')}"/>

<wcf:getData type="com.ibm.commerce.order.facade.datatypes.OrderType[]" var="childOrders" varShowVerb="ShowVerbAllChildOrders" expressionBuilder="findChildOrdersByOrderItemUniqueID" maxItems="${pageSize}" recordSetStartNumber="${beginIndex}" >
	<wcf:param name="orderItemId" value="${orderItemId}" />
	<wcf:param name="accessProfile" value="IBM_Summary" />
</wcf:getData>

<c:if test="${empty childOrders && beginIndex >= pageSize}">
	<c:set var="beginIndex" value="${beginIndex - pageSize}"/>
	<wcf:getData type="com.ibm.commerce.order.facade.datatypes.OrderType[]" var="childOrders" varShowVerb="ShowVerbAllChildOrders" expressionBuilder="findChildOrdersByOrderItemUniqueID" maxItems="${pageSize}" recordSetStartNumber="${beginIndex}" >
		<wcf:param name="orderItemId" value="${orderItemId}" />
		<wcf:param name="accessProfile" value="IBM_Summary" />
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
	<div id="SubscriptionChildOrdersPagination_1">
		<span id="SubscriptionChildOrdersDetailPagination_span_1a" class="text">
			<fmt:message key="MO_Page_Results" > 
				<fmt:param><fmt:formatNumber value="${beginIndex + 1}"/></fmt:param>
				<fmt:param><fmt:formatNumber value="${endIndex}"/></fmt:param>
				<fmt:param><fmt:formatNumber value="${numEntries}"/></fmt:param>
			</fmt:message>
			<span id="SubscriptionChildOrdersDetailPagination_span_2a" class="paging">
				<c:if test="${beginIndex != 0}">	
					<a id="SubscriptionChildOrdersDetailPagination_previous_link_1" href="javaScript:setCurrentId('SubscriptionChildOrdersDetailPagination_previous_link_1'); if(submitRequest()){cursor_wait();
					wc.render.updateContext('${contextId}',{'beginIndex':'<c:out value='${beginIndex - pageSize}'/>',orderItemId:'<c:out value='${orderItemId}'/>',subscriptionName:'<c:out value='${subscriptionName}'/>'});}">
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
					<a id="SubscriptionChildOrdersDetailPagination_next_link_1" href="javaScript:setCurrentId('SubscriptionChildOrdersDetailPagination_next_link_1'); if(submitRequest()){cursor_wait();
					wc.render.updateContext('${contextId}',{'beginIndex':'<c:out value='${beginIndex + pageSize}'/>',orderItemId:'<c:out value='${orderItemId}'/>',subscriptionName:'<c:out value='${subscriptionName}'/>'});}">
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
	<fmt:message key="MO_NOORDERSFOUND" />
</c:when>
<c:otherwise>

<div role="row" id="SubscriptionChildOrdersDetailsDisplayExt_ul_1" class="ul column_heading">
<div role="columnheader" id="SubscriptionChildOrdersDetailsDisplayExt_li_header_1" class="li order_number_column"><fmt:message key="MA_SUBSCRIPTION" />
</div>
<div role="columnheader" id="SubscriptionChildOrdersDetailsDisplayExt_li_header_2" class="li next_order_column"><fmt:message key="ORD_ORDER_DATE" /></div>
<div role="columnheader" id="SubscriptionChildOrdersDetailsDisplayExt_li_header_3" class="li order_status_column_history"><fmt:message key="MO_SUBSCRIPTION_STATUS" /></div>
<div id="SubscriptionChildOrdersDetailsDisplayExt_li_header_4" class="li clear_float"></div>
</div>
<c:forEach var="order" items="${childOrders}" varStatus="status">
	
	<div role="row" id="SubscriptionChildOrdersDisplay_ul_2_${status.count}" class="ul row">
			
			<div role="gridcell" id="SubscriptionChildOrdersDetailsDisplayExt_subscription_name_<c:out value='${status.count}'/>" class="li order_number_column">
				<span>
					<c:choose>
							<c:when test="${!empty subscriptionName}">
								<c:out value="${subscriptionName}"/>	
							</c:when>
							<c:otherwise>
								<fmt:message key="MO_NOT_AVAILABLE" />	
							</c:otherwise>
					</c:choose>	
				</span>
			</div>

			<div role="gridcell" id="SubscriptionChildOrdersDetailsDisplayExt_order_date_<c:out value='${status.count}'/>" class="li next_order_column">
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
			
			<div role="gridcell" id="SubscriptionChildOrdersDetailsDisplayExt_order_status_<c:out value='${status.count}'/>" class="li order_status_column_history">
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

		<div role="gridcell" id="SubscriptionChildOrdersDetailsDisplayExt_clear_float_<c:out value='${status.count}'/>" class="li clear_float"></div>
	</div>
</c:forEach>
</c:otherwise>
</c:choose>

<c:if test="${numEntries > pageSize}">
	<div id="SubscriptionChildOrdersPagination_2">
		<span id="SubscriptionChildOrdersDetailPagination_span_1b" class="text">
			<fmt:message key="MO_Page_Results" > 
				<fmt:param><fmt:formatNumber value="${beginIndex + 1}"/></fmt:param>
				<fmt:param><fmt:formatNumber value="${endIndex}"/></fmt:param>
				<fmt:param><fmt:formatNumber value="${numEntries}"/></fmt:param>
			</fmt:message>
			<span id="SubscriptionChildOrdersDetailPagination_span_2b" class="paging">
				<c:if test="${beginIndex != 0}">	
					<a id="SubscriptionChildOrdersDetailPagination_previous_link_2" href="javaScript:setCurrentId('SubscriptionChildOrdersDetailPagination_previous_link_2'); if(submitRequest()){cursor_wait();
					wc.render.updateContext('${contextId}',{'beginIndex':'<c:out value='${beginIndex - pageSize}'/>',orderItemId:'<c:out value='${orderItemId}'/>',subscriptionName:'<c:out value='${subscriptionName}'/>'});}">
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
					<a id="SubscriptionChildOrdersDetailPagination_next_link_2" href="javaScript:setCurrentId('SubscriptionChildOrdersDetailPagination_next_link_2'); if(submitRequest()){cursor_wait();
					wc.render.updateContext('${contextId}',{'beginIndex':'<c:out value='${beginIndex + pageSize}'/>',orderItemId:'<c:out value='${orderItemId}'/>',subscriptionName:'<c:out value='${subscriptionName}'/>'});}">
				</c:if>
				<img src="<c:out value="${jspStoreImgDir}${env_vfileColor}${vfileColorBIDI}" />paging_next.png" alt="<fmt:message key="CATEGORY_PAGING_RIGHT_IMAGE" />" />
				<c:if test="${numEntries > endIndex }">
					</a>
				</c:if>
			</span>
		</span>
	</div>
</c:if>

<!-- END SubscriptionChildOrdersTableDetailsDisplay.jsp -->
