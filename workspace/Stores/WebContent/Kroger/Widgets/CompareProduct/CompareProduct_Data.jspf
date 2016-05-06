<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2011, 2012 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<c:set var="catEntryIds" value="${fn:split(param.catentryId, ';')}"/>
<c:if test="${empty param.catentryId}">
	<c:set var="catEntryIds" value="${fn:split(WCParam.catentryId, ';')}"/>
</c:if>

<wcf:useBean var="catEntryNames" classname="java.util.ArrayList"/>
<wcf:useBean var="brands" classname="java.util.ArrayList"/>
<wcf:useBean var="catEntryDetails" classname="java.util.ArrayList"/>

<jsp:useBean id="catEntryImagesMap" class="java.util.LinkedHashMap" type="java.util.Map"/>
<jsp:useBean id="catEntryShortDescMap" class="java.util.LinkedHashMap" type="java.util.Map"/>
<jsp:useBean id="catEntryUrlMap" class="java.util.LinkedHashMap" type="java.util.Map"/>
<jsp:useBean id="catEntryTypeMap" class="java.util.LinkedHashMap" type="java.util.Map"/>
<jsp:useBean id="catEntryAttributes" class="java.util.HashMap" type="java.util.Map"/>
<jsp:useBean id="catEntryBuyable" class="java.util.HashMap" type="java.util.Map"/>
	
<%-- Check first in the param and then in WCParam --%>
<c:if test="${!empty param.top_category}">
	<c:set var="top_category" value="${param.top_category}"/>
</c:if>
<c:if test="${!empty WCParam.top_category}">
	<c:set var="top_category" value="${WCParam.top_category}"/>
</c:if>
<c:if test="${!empty param.parent_category_rn}">
	<c:set var="parent_category_rn" value="${param.parent_category_rn}"/>
</c:if>
<c:if test="${!empty WCParam.parent_category_rn}">
	<c:set var="parent_category_rn" value="${WCParam.parent_category_rn}"/>
</c:if>
<c:if test="${!empty param.categoryId}">
	<c:set var="categoryId" value="${param.categoryId}"/>
</c:if>
<c:if test="${!empty WCParam.categoryId}">
	<c:set var="categoryId" value="${WCParam.categoryId}"/>
</c:if>

<c:choose>
	<%-- If categoryId is empty --%>
	<c:when test="${empty categoryId}">
		<c:set var="patternName" value="ProductURL"/>
	</c:when>
	<%-- If only categoryId is present and top_category, parent_category_rn either empty or same as categoryId --%>
	<c:when test="${(empty top_category or (categoryId eq top_category)) and (empty parent_category_rn or (categoryId eq parent_category_rn))}">
		<c:set var="patternName" value="ProductURLWithCategory"/>
	</c:when>
	<%-- If categoryId, top_category and parent_category_rn are present and different --%>
	<c:when test="${(not empty top_category) and (not empty parent_category_rn) and (categoryId ne parent_category_rn) and (categoryId ne top_category) and (parent_category_rn ne top_category)}">
		<c:set var="patternName" value="ProductURLWithParentAndTopCategory"/>
	</c:when>
	<%-- here, categoryId will be present and either top_category or parent_category_rn will be different from categoryId --%>
	<c:otherwise>
		<c:set var="patternName" value="ProductURLWithParentCategory"/>
	</c:otherwise>
</c:choose>
<c:set var="hasBrand" value="false"/>
<c:forEach var="catEntryId" items="${catEntryIds}" varStatus="status">

	<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogNavigationViewType" var="catalogNavigationView" 
		expressionBuilder="getCatalogEntryViewDetailsByID" varShowVerb="showCatalogNavigationView" maxItems="1" recordSetStartNumber="0">
		<wcf:param name="UniqueID" value="${catEntryId}"/>
		<wcf:contextData name="storeId" data="${storeId}" />
		<wcf:contextData name="catalogId" data="${catalogId}" />
	</wcf:getData>
	
	<c:set var="catalogEntryView" value="${catalogNavigationView.catalogEntryView[0]}"/>
	
	<%-- The URL that links to the display page --%>
	<wcf:url var="catEntryDisplayUrl" patternName="${patternName}" value="Product2">
		<wcf:param name="langId" value="${langId}" />
	    <wcf:param name="storeId" value="${storeId}"/>
	    <wcf:param name="catalogId" value="${catalogId}"/>
	    <wcf:param name="productId" value="${catEntryId}"/>
		<wcf:param name="categoryId" value="${categoryId}"/>		  
		<wcf:param name="parent_category_rn" value="${parent_category_rn}"/>
		<wcf:param name="top_category" value="${top_category}" />
	    <wcf:param name="errorViewName" value="ProductDisplayErrorView"/>
		<wcf:param name="urlLangId" value="${urlLangId}" />
	</wcf:url>
	
	<c:set target="${catEntryImagesMap}" property="${catEntryId}" value="${env_imageContextPath}/${catalogEntryView.metaData['ThumbnailPath']}"/>	
	<c:set target="${catEntryShortDescMap}" property="${catEntryId}" value="${catalogEntryView.shortDescription}"/>
	<c:set target="${catEntryUrlMap}" property="${catEntryId}" value="${catEntryDisplayUrl}"/>
	<wcf:set target="${catEntryNames}" value="${catalogEntryView.name}"/>
	
	<wcf:set target="${brands}" value="${catalogEntryView.manufacturer}"/>
	<c:if test="${not empty catalogEntryView.manufacturer}">
		<c:set var="hasBrand" value="true"/>
	</c:if>
	
	<wcf:set target="${catEntryDetails}" value="${catalogEntryView}"/>

	<c:forEach var="attribute" items="${catalogEntryView.attributes}">
		<c:if test="${attribute.comparable && attribute.displayable && !fn:startsWith(attribute.identifier,'ribbonad')}">
			<c:choose>
				<c:when test="${empty catEntryAttributes[attribute.name]}">
					<jsp:useBean id="attributeValues" class="java.util.HashMap" type="java.util.Map"/>
					<c:set target="${catEntryAttributes}" property="${attribute.name}" value="${attributeValues}"/>
				</c:when>
				<c:otherwise>
					<c:set var="attributeValues" value="${catEntryAttributes[attribute.name]}"/>
				</c:otherwise>
			</c:choose>
			<c:set var="attrValue" value=""/>
			<c:forEach items="${attribute.values}" var="value">
				<c:if test="${not empty attrValue}">
					<c:set var="attrValue" value="${attrValue}, "/>
				</c:if>
					<c:set var="attrValue" value="${attrValue}${value.value}"/>
			</c:forEach>
			<c:set target="${attributeValues}" property="${status.count}" value="${attrValue}"/>
			<c:remove var="attributeValues"/>
		</c:if>
	</c:forEach>
	
	<c:forEach var="prices" items="${catalogEntryView.price}">
		<c:if test="${prices.priceUsage == 'Offer'}">
			<c:set var="maximumItemPrice" value="${prices.maximumValue.value}"/>
			<c:if test="${empty maximumItemPrice}">						
				<c:set var="maximumItemPrice" value="${prices.value.value}"/>
			</c:if>
		</c:if>
	</c:forEach>
	
	<c:forEach var='sku' items='${catalogEntryView.SKUs}' varStatus='outerStatus'>
		<c:forEach var="definingAttrValue" items="${sku.attributes}" varStatus="innerStatus">
			<c:choose>
				<c:when test="${definingAttrValue.identifier == env_subsFulfillmentFrequencyAttrName}">
					<c:set var="fulfillmentFrequency" value="${definingAttrValue2.values[0].value}"/>
				</c:when>
				<c:when test="${definingAttrValue2.identifier == env_subsPaymentFrequencyAttrName}">
					<c:set var="paymentFrequency" value="${definingAttrValue2.values[0].value}"/>
				</c:when>
				<c:when test="${definingAttrValue2.identifier == env_subsTimePeriodAttrName}">
					<c:set var="aValidTimePeriod" value="${definingAttrValue2.values[0].value}"/>
				</c:when>
			</c:choose>
		</c:forEach>
	</c:forEach>
	
	<c:set var="showAdd2CartButton" value="false"/>
	<%-- Subscription products without the well know 3 attributes will not be allowed to add to cart --%>
	<c:if test="${(!empty maximumItemPrice && catalogEntryView.buyable) || (isSubscription && !empty fulfillmentFrequency && !empty paymentFrequency && !empty aValidTimePeriod)}" >
		<c:set var="showAdd2CartButton" value="true"/>
	</c:if>
	
	<c:set target="${catEntryBuyable}" property="${status.count}" value="${showAdd2CartButton}"/>
	
	<c:choose>
		<c:when test="${catalogEntryView.catalogEntryTypeCode eq 'ProductBean' and catalogEntryView.hasSingleSKU}">
			<c:set target="${catEntryTypeMap}" property="${catalogEntryView.singleSKUCatalogEntryID}" value="ItemBean"/>
		</c:when>
		<c:otherwise>
			<c:set target="${catEntryTypeMap}" property="${catEntryId}" value="${catalogEntryView.catalogEntryTypeCode}"/>
		</c:otherwise>
	</c:choose>
	
	<c:choose>
		<c:when test="${empty catEntryId}">
			<c:set var="productCount" value="0"/>
		</c:when>
		<c:otherwise>
			<c:set var="productCount" value="${status.count}"/>
		</c:otherwise>
	</c:choose>
	
</c:forEach>
