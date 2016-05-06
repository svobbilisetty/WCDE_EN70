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

<!-- BEGIN GetCatalogEntryDetailsByID.jsp -->

<%@ include file="../../Common/EnvironmentSetup.jspf"%>

<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogNavigationViewType" var="catalogNavigationView" 
	expressionBuilder="getCatalogEntryViewDetailsByID" varShowVerb="showCatalogNavigationView" maxItems="1" recordSetStartNumber="0">
	<wcf:param name="UniqueID" value="${WCParam.catalogEntryId}"/>
	<wcf:contextData name="storeId" data="${storeId}" />
	<wcf:contextData name="catalogId" data="${catalogId}" />
</wcf:getData>

<c:set var="catalogEntry" value="${catalogNavigationView.catalogEntryView[0]}"/>

<%-- catalogIdEntry is used in CatalogEntrySetPriceDisplay.jspf, hence using this variable --%>
<c:set var="catalogIdEntry" value="${catalogEntry}"/>

<%@ include file="../../Snippets/Search/CatalogEntrySetPriceDisplay.jspf" %>
<fmt:formatNumber var="offerPrice" value="${priceString}" type="currency" currencySymbol="${env_CurrencySymbolToFormat}" maxFractionDigits="${env_currencyDecimal}"/>
<c:if test="${not empty listPrice}">
	<fmt:formatNumber var="listPrice" value="${listPrice.value.value}" type="currency" currencySymbol="${env_CurrencySymbolToFormat}" maxFractionDigits="${env_currencyDecimal}"/>
</c:if>
<c:if test="${not empty calculatedPrice and not empty calculatedPrice.contractIdentifier and not empty calculatedPrice.contractIdentifier.externalIdentifier}">
	<c:set var="ownerID" value="${calculatedPrice.contractIdentifier.externalIdentifier.ownerID}"/>
</c:if>
<c:set var="search" value='"'/>
<c:set var="replaceStr" value='&quot;'/>

<%-- Fetch fullimage and thumbnail from metadata --%>
<c:forEach var="metadata" items="${catalogEntry.metaData}">
	<c:if test="${metadata.key == 'ThumbnailPath'}">
		<c:set var="thumbNail" value="${env_imageContextPath}/${metadata.value}" />
	</c:if>			
	<c:if test="${metadata.key == 'FullImagePath'}">
		<c:set var="fullImage" value="${env_imageContextPath}/${metadata.value}" />
	</c:if>
</c:forEach>

/*
{"catalogEntry": {
		"catalogEntryIdentifier": {
			"uniqueID": "${catalogEntry.uniqueID}",
			"externalIdentifier": {
				"partNumber": "${catalogEntry.partNumber}",
				"ownerID": "${ownerID}"
			}
		},
		"description": [{
			"name": "${fn:replace(catalogEntry.name, search, replaceStr)}",
			"thumbnail": "${thumbNail}",
			"fullImage": "${fullImage}",
			"shortDescription": "${fn:replace(catalogEntry.shortDescription, search, replaceStr)}",
			"longDescription": "${fn:replace(catalogEntry.longDescription, search, replaceStr)}",
			"keyword": "${fn:replace(catalogEntry.keyword, search, replaceStr)}",
			"language": "${langId}"
		}],
		"offerPrice": "${offerPrice}",
		"listPrice": "${listPrice}",
		"listPriced": "${not empty listPrice}"
		<c:if test="${not empty calculatedPrice}">
		, "priceRange": [
			<c:forEach var="priceRange" items="${calculatedPrice.priceRange}" varStatus="status">
				<fmt:formatNumber var="localizedPrice" value="${priceRange.value.value}" type="currency" currencySymbol="${env_CurrencySymbolToFormat}" maxFractionDigits="${env_currencyDecimal}"/>
				
				<%-- if maximum quantity is empty need to pass it as null --%>
				<c:choose>
					<c:when test="${empty priceRange.maximumQuantity}">
						<c:set var="maximumQuantity" value="null"/>
					</c:when>
					<c:otherwise>
						<c:set var="maximumQuantity" value="${priceRange.maximumQuantity}"/>
					</c:otherwise>
				</c:choose>
				{
					"startingNumberOfUnits" : "${priceRange.minimumQuantity}",
					"endingNumberOfUnits" : "${maximumQuantity}",
					"localizedPrice" : "${localizedPrice}"
				}<c:if test="${not status.last}">,</c:if>
			</c:forEach>
		]
		</c:if>
	}
}
*/

<!-- END GetCatalogEntryDetailsByID.jsp -->