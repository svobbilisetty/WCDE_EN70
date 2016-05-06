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
<c:choose>
	<c:when test="${!empty WCParam.productId}">
		<c:set var="productId" value="${WCParam.productId}" />
	</c:when>
	<c:otherwise>
		<c:set var="productId" value="${param.productId}" />
	</c:otherwise>
</c:choose>

<c:choose>
	<c:when test="${!empty productId}">
		<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogNavigationViewType" var="catalogNavigationView" 
			expressionBuilder="getCatalogEntryViewDetailsWithComponentsAndAttachmentsByID" varShowVerb="showCatalogNavigationView" maxItems="1" recordSetStartNumber="0">
			<wcf:param name="UniqueID" value="${productId}"/>
			<wcf:contextData name="storeId" data="${storeId}" />
			<wcf:contextData name="catalogId" data="${catalogId}" />
		</wcf:getData>
	</c:when>
	<c:when test="${empty productId && !empty WCParam.partNumber}">
		<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogNavigationViewType" var="catalogNavigationView" 
			expressionBuilder="getCatalogEntryViewDetailsWithComponentsAndAttachmentsByPartnumber" varShowVerb="showCatalogNavigationView" maxItems="1" recordSetStartNumber="0">
			<wcf:param name="PartNumber" value="${WCParam.partNumber}" />
			<wcf:contextData name="storeId" data="${WCParam.storeId}" />
			<wcf:contextData name="catalogId" data="${WCParam.catalogId}" />
		</wcf:getData>
	</c:when>
</c:choose>
<c:if test="${!empty catalogNavigationView && !empty catalogNavigationView.catalogEntryView[0]}">
	<c:set var="catalogEntryDetails" value="${catalogNavigationView.catalogEntryView[0]}"/>
</c:if>

<wcf:useBean var="components" classname="java.util.ArrayList"/>

<c:forEach var="componentCatalogEntry" items="${catalogEntryDetails.components}">
	<c:set var="catalogEntryView" value="${componentCatalogEntry.catalogEntryView}"/>
	
	<jsp:useBean id="componentDetails" class="java.util.HashMap" type="java.util.Map"/>
	<c:set target="${componentDetails}" property="uniqueID" value="${catalogEntryView.uniqueID}"/>
	<c:set target="${componentDetails}" property="quantity" value="${fn:substringBefore(componentCatalogEntry.quantity,'.')}"/>
	
	<wcf:set target="${components}" value="${componentDetails}"/>
	<c:remove var="componentDetails"/>
	
</c:forEach>