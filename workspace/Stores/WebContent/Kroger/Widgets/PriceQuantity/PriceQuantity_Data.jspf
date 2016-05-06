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

<c:set var="productId" value="${WCParam.productId}" />
<c:if test="${empty productId}">
	<c:set var="productId" value="${param.productId}"/>
</c:if>

<c:if test="${empty catalogEntryDetails}">
	<c:if test="${!empty productId}">
		<%-- Try to get it from our internal hashMap --%>
		<c:set var="key1" value="${productId}+getCatalogEntryViewAllByID"/>
		<c:set var="catalogEntryDetails" value="${cachedCatalogEntryDetailsMap[key1]}"/>
		<c:if test="${empty catalogEntryDetails}">
			<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogNavigationViewType" var="catalogNavigationView" 
				expressionBuilder="getCatalogEntryViewAllByID" varShowVerb="showCatalogNavigationView" maxItems="1" recordSetStartNumber="0">
				<wcf:param name="UniqueID" value="${productId}"/>
				<wcf:contextData name="storeId" data="${storeId}" />
				<wcf:contextData name="catalogId" data="${catalogId}" />
			</wcf:getData>
		</c:if>
	</c:if>
	<c:if test="${empty productId && !empty WCParam.partNumber}">
		<c:set var="key1" value="${WCParam.partNumber}+getCatalogEntryViewAllByPartnumber"/>
		<c:set var="catalogEntryDetails" value="${cachedCatalogEntryDetailsMap[key1]}"/>
		<c:if test="${empty catalogEntryDetails}">
			<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogNavigationViewType" var="catalogNavigationView" 
				expressionBuilder="getCatalogEntryViewAllByPartnumber" varShowVerb="showCatalogNavigationView" maxItems="1" recordSetStartNumber="0">
				<wcf:param name="PartNumber" value="${WCParam.partNumber}" />
				<wcf:contextData name="storeId" data="${storeId}" />
				<wcf:contextData name="catalogId" data="${catalogId}" />
			</wcf:getData>
		</c:if>
	</c:if>
	<c:if test="${!empty catalogNavigationView && !empty catalogNavigationView.catalogEntryView[0]}">
		<c:set var="catalogEntryDetails" value="${catalogNavigationView.catalogEntryView[0]}"/>
		<c:set property="productId" value="${catalogEntryDetails.uniqueID}" target="${WCParam}"/>
		<c:set var="productId" value="${WCParam.productId}" />
	</c:if>
</c:if>

<%-- LinkedHashMap to retain order --%>
<wcf:useBean var="localizedQuantityPriceMap" classname="java.util.LinkedHashMap"/>

<%-- using a different variable so that productId is not overwritten in bundle page --%>
<c:set var="priceProductId" value="${catalogEntryDetails.uniqueID}"/>

<c:if test="${!empty env_b2bStore && env_b2bStore != 'true'}">
	<c:if test="${type != 'bundle'}">
		<c:forEach var="price" items="${catalogEntryDetails.price}" varStatus="aStatus">
			<c:if test="${price.priceUsage == 'Offer'}">
				<!-- For each contract -->
				<c:forEach var="priceRange" items="${price.priceRange}" varStatus="priceRangeCounter">
					<c:if test="${not empty priceRange.maximumQuantity or priceRangeCounter.index ne '0'}">
						<!-- For each contract price range -->
						<c:choose>
							<c:when test="${!empty priceRange.maximumQuantity and (priceRange.minimumQuantity eq priceRange.maximumQuantity)}">
								<fmt:message var="localizedPriceString" key="PQ_PRICE_{0}" >
									<fmt:param value="${priceRange.minimumQuantity}" />
								</fmt:message>
							</c:when>
							<c:when test="${!empty priceRange.maximumQuantity}">
								<fmt:message var="localizedPriceString" key="PQ_PRICE_{0}_TO_{1}" >
									<fmt:param value="${priceRange.minimumQuantity}" />
									<fmt:param value="${priceRange.maximumQuantity}" />
								</fmt:message>
							</c:when>
							<c:otherwise>										
								<fmt:message var="localizedPriceString" key="PQ_PRICE_{0}_OR_MORE" >
									<fmt:param value="${priceRange.minimumQuantity}" />
								</fmt:message>
							</c:otherwise>
						</c:choose>
						<fmt:formatNumber var="localizedPrice" value="${priceRange.value.value}" type="currency" currencySymbol="${env_CurrencySymbolToFormat}" maxFractionDigits="${env_currencyDecimal}"/>
						<wcf:set target="${localizedQuantityPriceMap}" key="${localizedPriceString}" value="${localizedPrice}"/>
					</c:if>
				</c:forEach>
			</c:if>
		</c:forEach>	
	</c:if>
</c:if>
