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

<c:if test="${empty catalogEntryDetails}" >
	<c:if test="${!empty productId}">
		<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogNavigationViewType" var="catalogNavigationView" 
			expressionBuilder="getCatalogEntryViewAllByID" varShowVerb="showCatalogNavigationView" maxItems="1" recordSetStartNumber="0">
			<wcf:param name="UniqueID" value="${productId}"/>
			<wcf:contextData name="storeId" data="${WCParam.storeId}" />
			<wcf:contextData name="catalogId" data="${WCParam.catalogId}" />
		</wcf:getData>
	</c:if>
	<c:if test="${empty productId && !empty WCParam.partNumber}">
		<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogNavigationViewType" var="catalogNavigationView" 
			expressionBuilder="getCatalogEntryViewAllByPartnumber" varShowVerb="showCatalogNavigationView" maxItems="1" recordSetStartNumber="0">
			<wcf:param name="PartNumber" value="${WCParam.partNumber}" />
			<wcf:contextData name="storeId" data="${WCParam.storeId}" />
			<wcf:contextData name="catalogId" data="${WCParam.catalogId}" />
		</wcf:getData>
	</c:if>
	<c:if test="${!empty catalogNavigationView && !empty catalogNavigationView.catalogEntryView[0]}">
		<c:set var="catalogEntryDetails" value="${catalogNavigationView.catalogEntryView[0]}"/>
		<c:set property="productId" value="${catalogEntryDetails.uniqueID}" target="${WCParam}"/>
		<c:set var="productId" value="${WCParam.productId}" />
	</c:if>
</c:if>

<c:set var="minimumPrice" value=""/>
<c:set var="maximumPrice" value=""/>
<c:set var="emptyPriceString" value=""/>
<c:set var="priceString" value=""/>
<c:remove var="indexedPrice"/>
<c:remove var="listPrice"/>
<c:remove var="calculatedPrice"/>
<c:remove var="minimumPriceString"/>
<c:remove var="maximumPriceString"/>
<c:set var="dataBean" value="true"/>

<c:set var="catalogEntryId" value="${catalogEntryDetails.uniqueID}"/>
<c:set var="listPriced" value="false"/>
<c:forEach var="price" items="${catalogEntryDetails.price}" >
	<c:choose>
		<c:when test="${price.priceUsage == 'Display'}">
			<c:set var="displayPrice" value="${price.value.value}" />
			<c:set var="listPriced" value="true"/>
		</c:when>
		<c:when test="${price.priceUsage == 'Offer'}">
			<c:set var="calculatedPrice" value="${price}" />
		</c:when>
	</c:choose>
</c:forEach>

<c:set var="minimumPrice" value="${calculatedPrice.minimumValue}"  />
<c:set var="maximumPrice" value="${calculatedPrice.maximumValue}"  />
<c:set var="minimumPriceString" value="${calculatedPrice.minimumValue.value}"  />
<c:set var="maximumPriceString" value="${calculatedPrice.maximumValue.value}"  />
	
<c:set var="offerPrice" value="${minimumPriceString}"/>
	<%-- If minimum price is empty, means all SKUs has the same offer price. Get the offer price from first SKU--%>
<c:if test="${empty offerPrice}">
	<c:if test="${!empty catalogEntryDetails.SKUs[0].price}">
		<c:forEach var="price" items="${catalogEntryDetails.SKUs[0].price}" >
			<c:if test="${price.priceUsage == 'Offer'}">
				<c:set var="offerPrice" value="${price.value.value}" />
			</c:if>
		</c:forEach>
	</c:if>
	<%-- If offer price is still empty, use product's offer price--%>
	<c:if test="${empty offerPrice}">
		<c:set var="offerPrice" value="${calculatedPrice.value.value}"/>
	</c:if>
</c:if>

<c:if test="${catalogEntryDetails.catalogEntryTypeCode eq 'DynamicKitBean'}">
	<c:set var="dataBean" value="false"/>
	<c:set var="dynamicKitprice" value="${catalogEntryDetails.price[0]}"/>
</c:if>

<c:choose>
	<%--
	***
	*	If there is no price, then get a message indicating there 
	*	is no available price. This rule applies only to Dynamic Kits.
	***
	--%>
	<c:when test="${catalogEntryDetails.catalogEntryTypeCode eq 'DynamicKitBean' && empty catalogEntryDetails.price}">
		<fmt:message var="emptyPriceString" key="NO_PRICE_AVAILABLE" />
	</c:when>
	
	<%-- 
	***
	*	This rule applies only to Dynamic Kits.
	*	Dynamic Kits do not have a price range. Only the best price is displayed.
	***
	--%>
	<c:when test="${catalogEntryDetails.catalogEntryTypeCode eq 'DynamicKitBean' && !empty dynamicKitprice}">
		<c:choose>
			<c:when test="${dynamicKitprice.description == 'I'}">
				<c:set var="indexedPrice" value="${dynamicKitprice}" />
			</c:when>
			<c:when test="${dynamicKitprice.description == 'L'}">
				<c:set var="listPrice" value="${dynamicKitprice}" />
			</c:when>
			<c:when test="${dynamicKitprice.description == 'O'}">
				<c:set var="calculatedPrice" value="${dynamicKitprice}" />
			</c:when>
		</c:choose>
		

		<c:if test="${not empty indexedPrice}" >
			<c:if test="${not empty listPrice && listPrice.value.value gt indexedPrice.value.value}" >
				<c:set var="strikedPriceString" value="${listPrice.value.value}"/>
			</c:if>
			<c:set var="priceString" value="${indexedPrice.value.value}"/>
		</c:if>
		<c:if test="${not empty calculatedPrice}" >
			<c:remove var="strikedPriceString"/>
			<c:set var="minimumPriceString">
				<fmt:formatNumber value="${calculatedPrice.minimumValue.value}" type="currency" currencySymbol="${env_CurrencySymbolToFormat}" maxFractionDigits="${env_currencyDecimal}"/>
			</c:set>
			<c:set var="maximumPriceString">
				<fmt:formatNumber value="${calculatedPrice.maximumValue.value}" type="currency" currencySymbol="${env_CurrencySymbolToFormat}" maxFractionDigits="${env_currencyDecimal}"/>
			</c:set>
			<c:choose>
				<c:when test="${not empty minimumPriceString && not empty maximumPriceString}">
					<c:set var="priceString" value="${minimumPriceString} - ${maximumPriceString}"/>
				</c:when>
				<c:otherwise>
					<c:if test="${not empty listPrice && listPrice.value.value gt calculatedPrice.value.value}" >
						<c:set var="strikedPriceString">
							<fmt:formatNumber value="${listPrice.value.value}" type="currency" currencySymbol="${env_CurrencySymbolToFormat}" maxFractionDigits="${env_currencyDecimal}"/>
						</c:set>
					</c:if>
					<c:set var="priceString">
						<fmt:formatNumber value="${calculatedPrice.value.value}" type="currency" currencySymbol="${env_CurrencySymbolToFormat}" maxFractionDigits="${env_currencyDecimal}"/>
					</c:set>
				</c:otherwise>
			</c:choose>
		</c:if>
	</c:when>

	<c:when test="${type eq 'individualContractPrice' && empty catalogEntryDetails.price}">
		<fmt:message var="emptyPriceString" key="NO_PRICE_AVAILABLE" />
	</c:when>

	<c:when test="${type eq 'individualContractPrice' && !empty catalogEntryPrice}">
		<c:choose>
			<c:when test="${catalogEntryPrice.description == 'I'}">
				<c:set var="indexedPrice" value="${catalogEntryPrice}" />
			</c:when>
			<c:when test="${catalogEntryPrice.description == 'L'}">
				<c:set var="listPrice" value="${catalogEntryPrice}" />
			</c:when>
			<c:when test="${catalogEntryPrice.description == 'O'}">
				<c:set var="calculatedPrice" value="${catalogEntryPrice}" />
			</c:when>
		</c:choose>
		<c:if test="${not empty indexedPrice}" >
			<c:if test="${not empty listPrice && listPrice.value.value gt indexedPrice.value.value}" >
				<c:set var="strikedPriceString" value="${listPrice.value.value}"/>
			</c:if>
			<c:set var="priceString" value="${indexedPrice.value.value}"/>
		</c:if>
		<c:if test="${not empty calculatedPrice}" >
			<c:remove var="strikedPriceString"/>
			<c:set var="minimumPriceString">
				<fmt:formatNumber value="${calculatedPrice.minimumValue.value}" type="currency" currencySymbol="${env_CurrencySymbolToFormat}" maxFractionDigits="${env_currencyDecimal}"/>
			</c:set>
			<c:set var="maximumPriceString">
				<fmt:formatNumber value="${calculatedPrice.maximumValue.value}" type="currency" currencySymbol="${env_CurrencySymbolToFormat}" maxFractionDigits="${env_currencyDecimal}"/>
			</c:set>
			<c:choose>
				<c:when test="${not empty minimumPriceString && not empty maximumPriceString}">
					<c:set var="priceString" value="${minimumPriceString} - ${maximumPriceString}"/>
				</c:when>
				<c:otherwise>
					<c:if test="${not empty listPrice && listPrice.value.value gt calculatedPrice.value.value}" >
						<c:set var="strikedPriceString">
							<fmt:formatNumber value="${listPrice.value.value}" type="currency" currencySymbol="${env_CurrencySymbolToFormat}" maxFractionDigits="${env_currencyDecimal}"/>
						</c:set>
					</c:if>
					<c:set var="priceString">
						<fmt:formatNumber value="${calculatedPrice.value.value}" type="currency" currencySymbol="${env_CurrencySymbolToFormat}" maxFractionDigits="${env_currencyDecimal}"/>
					</c:set>
				</c:otherwise>
			</c:choose>
		</c:if>
	</c:when>
	<%--
	***
	*	If there is no calculated contract price or range, then get a message 
	*   indicating there is no available price. This rule applies to
	*	any type of a catalog entry.
	*
	--%>
	<c:when test="${ empty offerPrice && empty minimumPriceString}">
		<fmt:message var="emptyPriceString" key="NO_PRICE_AVAILABLE" />
	</c:when>
	
	<%-- 
	***
	*	If there is a price range, then make the range the price to 
	*	be displayed.
	***
	--%>
	<c:when test="${!empty minimumPrice && !empty maximumPrice && (minimumPrice.value != maximumPrice.value) && fn:indexOf(maximumPrice.value, minimumPrice.value)==-1 && fn:indexOf(minimumPrice.value, maximumPrice.value)==-1}">
		 <fmt:message var="priceString" key="PRICE_RANGE" >
			<fmt:param><fmt:formatNumber value="${minimumPriceString}" type="currency" currencySymbol="${env_CurrencySymbolToFormat}" maxFractionDigits="${env_currencyDecimal}"/></fmt:param>
			<fmt:param><fmt:formatNumber value="${maximumPriceString}"  type="currency" currencySymbol="${env_CurrencySymbolToFormat}" maxFractionDigits="${env_currencyDecimal}"/></fmt:param>
		 </fmt:message>
	</c:when>
</c:choose>

<c:if test="${!empty offerPrice}">
	<c:set var="offerPriceString">
		<fmt:formatNumber value="${offerPrice}" type="currency" currencySymbol="${env_CurrencySymbolToFormat}" maxFractionDigits="${env_currencyDecimal}"/>
	</c:set>
</c:if>

<c:if test="${!empty displayPrice}">
	<c:set var="displayPriceString">
		<fmt:formatNumber value="${displayPrice}" type="currency" currencySymbol="${env_CurrencySymbolToFormat}" maxFractionDigits="${env_currencyDecimal}"/>
	</c:set>
</c:if>

