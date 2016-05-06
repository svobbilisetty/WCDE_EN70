<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2011 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%-- Pick catalogEntryId from the param, if empty look in WCParam --%>
<c:set var ="catalogEntryId" value="${param.productId}" />
<c:if test="${empty catalogEntryId}">
	<c:set var ="catalogEntryId" value="${WCParam.productId}" />
</c:if>

<jsp:useBean id="discountsMap" class="java.util.HashMap" type="java.util.Map"/>
<%-- Using useBean since the service to fetch the promotions is not available --%>
<wcbase:useBean id="discounts" classname="com.ibm.commerce.fulfillment.beans.CalculationCodeListDataBean" scope="page">
	<c:set property="catalogEntryId" value="${catalogEntryId}" target="${discounts}" />
	<c:set property="includeParentProduct" value="true" target="${discounts}" />
	<c:set property="includeChildItems" value="true" target="${discounts}"/>
	<%-- UsageId for discount is -1 --%>
	<c:set property="calculationUsageId" value="-1" target="${discounts}" />
</wcbase:useBean>

<c:if test="${!empty discounts.calculationCodeDataBeans}" >
	<c:forEach var="discountEntry" items="${discounts.calculationCodeDataBeans}" varStatus="discountCounter">
		<c:url var="DiscountDetailsDisplayViewURL" value="DiscountDetailsDisplayView">
	          <c:param name="code" value="${discountEntry.code}" />
	          <c:param name="langId" value="${langId}" />
	          <c:param name="storeId" value="${storeId}" />
	          <c:param name="catalogId" value="${catalogId}" />
	          <c:param name="productId" value="${catalogEntryId}"/> 
	   	</c:url>
	   	<c:set target="${discountsMap}" property="${discountEntry.descriptionString}" value="${DiscountDetailsDisplayViewURL}"/>
	</c:forEach>
</c:if>