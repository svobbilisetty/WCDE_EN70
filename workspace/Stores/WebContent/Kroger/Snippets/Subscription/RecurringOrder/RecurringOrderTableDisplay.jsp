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
<%--
  *****
  *
  * This JSP page displays the Recurring Order page 
  * For each order, the following is displayed
  * 	- Order Number, Next Order Date, Status, Total price
  * In each list, 'Details' is a link to the Order Details page for that order
  *
  *
  * How to use this snippet?
  *	<c:import url="../../../Snippets/Subscription/RecurringOrder/RecurringOrderTableDisplay.jsp" >
  *		<c:param name="isMyAccountMainPage" value="true"/>
  *	</c:import>
  *
  *****
--%>
<!-- BEGIN RecurringOrderTableDisplay.jsp -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ include file="../../../Common/EnvironmentSetup.jspf" %>


<c:set var="pageSize" value="${WCParam.pageSize}" />
<c:if test="${empty pageSize}">
	<c:set var="pageSize" value="${maxOrderItemsPerPage}"/>
</c:if>

<c:set var="beginIndex" value="${WCParam.beginIndex}" />
<c:if test="${empty beginIndex}">
	<c:set var="beginIndex" value="0" />
</c:if>

<div role="grid" id="WC_RecurringOrderTableDisplay_div_1" class="order_status_table scheduled_orders" aria-describedby="RecurringOrderPage" aria-readonly="true">
	<div id="RecurringOrderPage" class="hidden_summary">
		<fmt:message key="MO_SCHEDULED_ORDERS_TABLE_DESCRIPTION" />
	</div>
	<c:choose>         
		<c:when test="${!param.isMyAccountMainPage}">
			<div dojoType="wc.widget.RefreshArea" widgetId="RecurringOrderDisplay" id="RecurringOrderDisplay" controllerId="RecurringOrderDisplayController">
		</c:when>
		<c:otherwise>
			<div dojoType="wc.widget.RefreshArea" widgetId="RecentRecurringOrderDisplay" id="RecentRecurringOrderDisplay" controllerId="RecentRecurringOrderDisplayController">
		</c:otherwise>
	</c:choose>
	<%out.flush();%>
		<c:import url="${env_jspStoreDir}/Snippets/Subscription/RecurringOrder/RecurringOrderTableDetailsDisplay.jsp"> 
			<c:param name="catalogId" value="${WCParam.catalogId}" />
			<c:param name="langId" value="${WCParam.langId}" />
			<c:param name="storeId" value="${WCParam.storeId}" />
			<c:param name="isMyAccountMainPage" value="${param.isMyAccountMainPage}"/>
		</c:import>
	<%out.flush();%>
	</div>
</div>

<!-- END RecurringOrderTableDisplay.jsp -->
