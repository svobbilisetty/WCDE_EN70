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
<c:set var="search01" value="'"/>
<c:set var="search02" value='"'/>
<c:set var="replaceStr01" value="\\'"/>
<c:set var="replaceStr02" value="inches"/>
<c:set var="escapedSingleQuote" value="\\\\'"/>

<%-- Fetches the existing shopping list --%>
<c:if test="${userType ne 'G'}">
	<wcf:getData
		type="com.ibm.commerce.giftcenter.facade.datatypes.GiftListType[]"
		var="shoppingLists" expressionBuilder="findWishListsForUser">
		<wcf:contextData name="storeId" data="${storeId}" />
	</wcf:getData>
</c:if>

<%-- Prepares the map with shopping list id and names --%>
<jsp:useBean id="shoppingListMap" class="java.util.HashMap" type="java.util.Map"/>
<c:set var="defaultShoppingListId" value="-1"/>
<c:set var="shoppingListNames" value=""/>
<fmt:message key="SL_DEFAULT_WISH_LIST_NAME" var="defaultName"/>
<c:forEach var="shoppingList" items="${shoppingLists}">
	<c:set target="${shoppingListMap}" property="${shoppingList.giftListIdentifier.uniqueID}" value="${shoppingList.description.name}"/>
	<c:if test="${shoppingList.description.name eq defaultName}">
		<c:set var="defaultShoppingListId" value="${shoppingList.giftListIdentifier.uniqueID}"/>
	</c:if>
	<c:if test="${!empty shoppingListNames}">
		<c:set var="shoppingListNames" value="${shoppingListNames},"/>
	</c:if>
	<%-- Replacing backslash with double-backslash since it gets omitted as it is the escape character --%>
	<c:set var="shoppingListName" value="${fn:replace(shoppingList.description.name,'\\\\','\\\\\\\\')}"/>
	<c:set var="shoppingListName" value="${fn:replace(shoppingListName,'\\'','&#39;')}"/>
	<c:set var="shoppingListNames" value="${shoppingListNames}'${fn:escapeXml(shoppingListName)}': 1"/>
</c:forEach>
<c:set target="${shoppingListMap}" property="${defaultShoppingListId}" value="${null}"/>
<c:set var="shoppingListNames" value="${fn:toUpperCase(shoppingListNames)}"/>
<%-- Pick the productId from WCParam, if empty pick from param --%>
<c:set var="uniqueID" value="${param.productId}"/>
<c:if test="${empty uniqueID}">
	<c:set var="uniqueID" value="${WCParam.productId}"/>
</c:if>

<c:if test="${empty catalogId}">
	<c:set var="catalogId" value="${param.catalogId}"/>
</c:if>

<%-- Fetches the details of the currently displayed catalogEntry --%>
<%-- Look in our internal cached map. ALL will give us required data --%>
<c:set var="key1" value="${uniqueID}+getCatalogEntryViewAllByID"/>
<c:set var="catalogEntryView" value="${cachedCatalogEntryDetailsMap[key1]}"/>
<c:if test="${empty catalogEntryView}">
	<%-- Look in our internal cached map for a particular expression builder --%>
	<c:set var="key1" value="${uniqueID}+getCatalogEntryViewDetailsWithComponentsAndAttachmentsByID"/>
	<c:set var="catalogEntryView" value="${cachedCatalogEntryDetailsMap[key1]}"/>
	<c:if test="${empty catalogEntryView}">
		<wcf:getData
			type="com.ibm.commerce.catalog.facade.datatypes.CatalogNavigationViewType"
			var="catalogEntry"
			expressionBuilder="getCatalogEntryViewDetailsWithComponentsAndAttachmentsByID"
			maxItems="1" recordSetStartNumber="0">
			<wcf:contextData name="storeId" data="${storeId}" />
			<wcf:contextData name="catalogId" data="${catalogId}" />
			<wcf:param name="UniqueID" value="${uniqueID}" />
		</wcf:getData>
		<c:set var="catalogEntryView" value="${catalogEntry.catalogEntryView[0]}"/>
		<wcf:set target = "${cachedCatalogEntryDetailsMap}" key="${key1}" value="${catalogEntryView}"/>
	</c:if>
</c:if>

<c:set var="componentItems" value=""/>
<c:set var="skus" value=""/>
<c:choose>
	<%-- If the catalog entry is a ProductBean --%>
	<c:when test="${catalogEntryView.catalogEntryTypeCode eq 'ProductBean'}">
		<c:choose>
			<%-- If the catalog entry is a ProductBean and it has only one SKU, then it is as good as ItemBean.
			So identify the uniqueID of the single SKU and mark it as ItemBean --%>
			<c:when test="${catalogEntryView.hasSingleSKU}">
				<c:set var="uniqueID" value="${catalogEntryView.singleSKUCatalogEntryID}"/>
				<c:set var="type" value="ItemBean"/>
			</c:when>
			<c:otherwise>
				<c:set var="uniqueID" value="${catalogEntryView.uniqueID}"/>
				<c:set var="type" value="${catalogEntryView.catalogEntryTypeCode}"/>
				<%-- Pick the SKUs and the corresponding attributes --%>
				<c:forEach var="sku" items="${catalogEntryView.SKUs}">
					<c:if test="${!empty skus}">
						<c:set var="skus" value="${skus},"/>
					</c:if>
					<c:set var="attributes" value=""/>
					<c:forEach var="skuAttribute" items="${sku.attributes}">
						<c:if test="${skuAttribute.usage eq 'Defining'}">
							<c:if test="${!empty attributes}">
								<c:set var="attributes" value="${attributes},"/>
							</c:if>
							<c:set var="attributes" value="${attributes}'${skuAttribute.name}': '${fn:replace(fn:replace(skuAttribute.values[0].value, search01, replaceStr01), search02, replaceStr02)}'"/>
						</c:if>
					</c:forEach>
					<c:set var="skus" value="${skus}{id: '${sku.uniqueID}', attributes: {${attributes}}}"/>
				</c:forEach>
			</c:otherwise>
		</c:choose>
	</c:when>
	<%-- If the catalog entry is a BundleBean, get the components forming this bundle --%>
	<c:when test="${catalogEntryView.catalogEntryTypeCode eq 'BundleBean'}">
		<c:set var="uniqueID" value="${catalogEntryView.uniqueID}"/>
		<c:set var="type" value="${catalogEntryView.catalogEntryTypeCode}"/>
		<c:forEach var="component" items="${catalogEntryView.components}">
			<c:if test="${!empty componentItems}">
				<c:set var="componentItems" value="${componentItems},"/>
			</c:if>
			<c:choose>
				<%-- If the bundle has a component which is a ProductBean, pick all the SKUs and default the id to the first SKU --%>
				<c:when test="${component.catalogEntryView.catalogEntryTypeCode eq 'ProductBean'}">
					<c:set var="componentSkuIds" value""/>
					<c:forEach var="componentSku" items="${component.catalogEntryView.SKUs}">
						<c:if test="${!empty componentSkuIds}">
							<c:set var="componentSkuIds" value="${componentSkuIds},"/>
						</c:if>
						<c:set var="componentSkuIds" value="${componentSkuIds}{id: '${componentSku.uniqueID}'}"/>
					</c:forEach>
					<c:set var="componentItems" value="${componentItems}'${component.catalogEntryView.uniqueID}': 
							{id: '${component.catalogEntryView.SKUs[0].uniqueID}', skus: [${componentSkuIds}], quantity: ${component.quantity}}"/>
				</c:when>
				<c:otherwise>
					<c:set var="componentItems" value="${componentItems}'${component.catalogEntryView.uniqueID}': 
						{id: '${component.catalogEntryView.uniqueID}', quantity: ${component.quantity}}"/>
				</c:otherwise>
			</c:choose>
		</c:forEach>
	</c:when>
	<c:otherwise>
		<c:set var="uniqueID" value="${catalogEntryView.uniqueID}"/>
		<c:set var="type" value="${catalogEntryView.catalogEntryTypeCode}"/>
	</c:otherwise>
</c:choose>
<c:set var="shoppingListImage" value="${env_imageContextPath}/${fn:replace(catalogEntryView.metaData['FullImagePath'], productMasterImage, miniShopCartImage)}"/>
<c:set var="catEntryParams" value="{id: '${uniqueID}', name: '${fn:replace(catalogEntryView.name, search01, escapedSingleQuote)}', image: '${fn:replace(shoppingListImage, search01, escapedSingleQuote)}', type: '${type}', components: {${componentItems}}, skus: [${skus}]}"/>
<%-- Keep the store specific parameters like storeId, catalogId and langId in json object format --%>
<c:set var="storeParams" value="{storeId: '${fn:escapeXml(storeId)}',catalogId: '${fn:escapeXml(catalogId)}',langId: '${fn:escapeXml(langId)}'}"/>
