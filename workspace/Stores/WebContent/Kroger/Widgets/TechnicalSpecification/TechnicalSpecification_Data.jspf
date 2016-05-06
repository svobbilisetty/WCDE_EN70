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
<%-- 
  ***
  * params: productId, storeId, catalogId, usage, excludeUsageStr 
  ***
--%>
<%-- Pick the productId from WCParam. If empty, pick from param --%>
<c:set var="uniqueID" value="${WCParam.productId}"/>
<c:if test="${empty uniqueID}">
	<c:set var="uniqueID" value="${param.productId}"/>
</c:if>
<c:set var="excludeUsageStr" value="${WCParam.excludeUsageStr}"/>
<c:if test="${empty excludeUsageStr}">
	<c:set var="excludeUsageStr" value="${param.excludeUsageStr}"/>
</c:if>
<%-- Try to get it from our internal hashMap --%>
<c:set var="key1" value="${uniqueID}+getCatalogEntryViewAllByID"/>
<c:set var="catEntry" value="${cachedCatalogEntryDetailsMap[key1]}"/>
<c:if test="${empty catEntry}">
	<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogNavigationViewType" var="catalogNavigationView" 
			expressionBuilder="getCatalogEntryViewAllWithoutAttachmentsByID" varShowVerb="showCatalogNavigationView" maxItems="1" recordSetStartNumber="0" scope="request">
		<wcf:param name="UniqueID" value="${uniqueID}" />
		<wcf:contextData name="storeId" data="${storeId}" />
		<wcf:contextData name="catalogId" data="${catalogId}" />
	</wcf:getData>
	
	<c:set var="catEntry" value="${catalogNavigationView.catalogEntryView[0]}" />
	<wcf:set target="${cachedCatalogEntryDetailsMap}" key="${key1}" value="${catEntry}"/>
</c:if>


<%-- Picking the descriptive attributes --%>
<wcf:useBean var="descAttrMap" classname="java.util.LinkedHashMap"/>
<wcf:useBean var="descAttrNames" classname="java.util.HashMap"/>
<c:forEach items="${catEntry.attributes}" var="attribute" varStatus="status">
	<c:if test="${attribute.usage eq 'Descriptive' and attribute.displayable and !fn:startsWith(attribute.identifier,'ribbonad')}">
		<c:if test="${empty descAttrMap[attribute.uniqueID]}">
			<c:set var="varName" value="attrValueContainer_${status.count}"/>
			<wcf:useBean var="${varName}" classname="java.util.ArrayList" scope="request"/>
			<wcf:set target="${descAttrMap}" key="${attribute.uniqueID}" value="${requestScope[varName]}"/>
			<wcf:set target="${descAttrNames}" key="${attribute.uniqueID}" value="${attribute.name}"/>
		</c:if>
		<c:set var="attrValueContainer" value="${descAttrMap[attribute.uniqueID]}"/>
		<c:forEach items="${attribute.values}" var="value">
			<wcf:set target="${attrValueContainer}" value="${value.value}"/>
		</c:forEach>
	</c:if>
</c:forEach>

<%-- If item descriptive attributes are empty, fetch the parent descriptive attributes--%>
<c:if test="${empty descAttrMap and not empty catEntry.parentCatalogEntryID}">
	<%-- Try to get it from our internal hashMap --%>
	<c:set var="key2" value="${catEntry.parentCatalogEntryID}+getCatalogEntryViewAllByID"/>
	<c:set var="parentCatEntry" value="${cachedCatalogEntryDetailsMap[key2]}"/>
	<c:if test="${empty parentCatEntry}">
		<%-- Since this is an item, get the details about the parent product --%>
		<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogNavigationViewType" var="parentCatalogNavigationView" 
			expressionBuilder="getCatalogEntryViewDetailsByID" varShowVerb="showCatalogNavigationView" maxItems="1" recordSetStartNumber="0">
			<wcf:param name="UniqueID" value="${catEntry.parentCatalogEntryID}"/>
			<wcf:contextData name="storeId" data="${storeId}" />
			<wcf:contextData name="catalogId" data="${catalogId}" />
		</wcf:getData>
		
		<c:set var="parentCatEntry" value="${parentCatalogNavigationView.catalogEntryView[0]}" />
		<wcf:set target="${cachedCatalogEntryDetailsMap}" key="${key1}" value="${parentCatEntry}"/>
	</c:if>
	
		
	<%-- Check if the parent is a product and not package or bundle --%>
	<c:if test="${parentCatEntry.catalogEntryTypeCode eq 'ProductBean'}">
		<%-- Pick all the descriptive attributes of the parent --%>
		<c:forEach items="${parentCatEntry.attributes}" var="attribute"  varStatus="status">
			<c:if test="${attribute.usage eq 'Descriptive' and attribute.displayable and !fn:startsWith(attribute.identifier,'ribbonad')}">
			<c:if test="${empty descAttrMap[attribute.uniqueID]}">
				<c:set var="varName" value="attrValueContainer_${status.count}"/>
				<wcf:useBean var="${varName}" classname="java.util.TreeSet" scope="request"/>
				<wcf:set target="${descAttrMap}" key="${attribute.uniqueID}" value="${requestScope[varName]}"/>
				<wcf:set target="${descAttrNames}" key="${attribute.uniqueID}" value="${attribute.name}"/>
			</c:if>
			<c:set var="attrValueContainer" value="${descAttrMap[attribute.uniqueID]}"/>
			<c:forEach items="${attribute.values}" var="value">
				<wcf:set target="${attrValueContainer}" key="${value.value}" value="${value.value}"/>
			</c:forEach>
			</c:if>
		</c:forEach>
	</c:if>
</c:if>

<c:if test="${catEntry.catalogEntryTypeCode eq 'DynamicKitBean'}">
	<wcf:useBean var="dynamicKitComponentList" classname="java.util.ArrayList"/>
	
	<c:forEach items="${catEntry.components}" var="component">
		<c:choose>
			<c:when test="${not empty component.catalogEntryView.shortDescription}">
				<c:set var="componentDescription" value="${component.catalogEntryView.shortDescription}"/>
			</c:when>
			<c:when test="${not empty component.catalogEntryView.name}">
				<c:set var="componentDescription" value="${component.catalogEntryView.name}"/>
			</c:when>
		</c:choose>
		<fmt:formatNumber var="componentQty" value="${component.quantity}" type="number" maxFractionDigits="0"/>
		<c:if test="${componentQty > 1}">
			<%-- output order item component quantity in the form of "5 x ComponentName" --%>
			<fmt:message var="componentDescription" key="ITEM_COMPONENT_QUANTITY_NAME" > 
				<fmt:param><c:out value="${componentQty}" escapeXml="false"/></fmt:param>
				<fmt:param><c:out value="${componentDescription}" escapeXml="false"/></fmt:param>
			</fmt:message>
		</c:if>
		<wcf:set target="${dynamicKitComponentList}" value="${componentDescription}" />
	</c:forEach>
	
</c:if>



