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
<%-- 
  ***
  * This jsp populates the data required by the physical store inventory section of the product display page.
  * It creates a JSON object which is returned to the client from the AJAX call.
  ***
--%>
<%@ include file="../../Common/EnvironmentSetup.jspf" %>

<c:set var="cookieVal" value="${cookie.WC_physicalStores.value}" />
<c:set var="cookieVal" value="${fn:replace(cookieVal, '%2C', ',')}"/>

<%-- Fetches the inventory list for a particular item in online store and physical store using store ids--%>
<wcf:getData type="com.ibm.commerce.infrastructure.facade.datatypes.ConfigurationType"
		var="storeInventoryConfig" expressionBuilder="findByUniqueID">
	<wcf:contextData name="storeId" data="${storeId}" />
	<wcf:param name="uniqueId" value="com.ibm.commerce.foundation.inventorySystem" />
</wcf:getData>
<c:set var="storeInventorySystem" value="${storeInventoryConfig.configurationAttribute[0].primaryValue.value}"/>
	
<c:if test="${storeInventorySystem != 'No inventory'}">
	<c:catch>
		<wcf:getData
			type="com.ibm.commerce.inventory.facade.datatypes.InventoryAvailabilityType[]"
			var="itemInventoryList"
			expressionBuilder="findInventoryAvailabilityByCatalogEntryIdsAndOnlineStoreIdsAndPhysicalStoreIds">
			<wcf:param name="accessProfile" value="IBM_Store_Details" />
			<wcf:param name="onlineStoreId" value="${storeId}" />
			<wcf:param name="catalogEntryId" value="${param.itemId}" />
			<c:forTokens items="${cookieVal}" delims="," var="phyStoreId">
				<wcf:param name="physicalStoreId" value="${phyStoreId}" />
			</c:forTokens>
		</wcf:getData>
	</c:catch>
</c:if>

<c:set var="physicalStores" value=""/>
<c:set var="storeCounter" value="0"/>
<c:set var="onlineInventoryStatus" value="NA"/>
<%-- Iterates through the inventory list to get the online inventory status and physical store inventory status --%>
<c:forEach var="itemInventory" items="${itemInventoryList}" varStatus="counter">
	<c:choose>
		<%-- Selects the online inventory status when online store identifier is not empty --%>
		<c:when test="${!empty itemInventory.inventoryAvailabilityIdentifier.externalIdentifier.onlineStoreIdentifier}">
			<c:if test="${!empty  itemInventory.inventoryStatus}">
			    <c:set var="onlineInventoryStatus" value="${itemInventory.inventoryStatus}"/>
			</c:if>
		</c:when>
		<c:when test="${!empty itemInventory.inventoryAvailabilityIdentifier.externalIdentifier.physicalStoreIdentifier}">
			<c:set var="storeCounter" value="${storeCounter+1}"/>
			
			<c:choose>
				<c:when test="${! empty(itemInventory.availabilityDateTime)}">
					<c:catch>
						<fmt:parseDate parseLocale="${dateLocale}" var="date" value="${itemInventory.availabilityDateTime}" pattern="yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" timeZone="GMT" dateStyle="long"/>
					</c:catch>
					<c:if test="${empty date}">
						<c:catch>
							<fmt:parseDate parseLocale="${dateLocale}" var="date" value="${itemInventory.availabilityDateTime}" pattern="yyyy-MM-dd'T'HH:mm:ss'Z'" timeZone="GMT" dateStyle="long"/>
						</c:catch>
					</c:if>
					<fmt:formatDate var="availableDate" value="${date}"/>
				</c:when>
				<c:otherwise>
					<c:set var="availableDate" value=""/>
				</c:otherwise>
			</c:choose>
			
			<c:choose>
				<c:when test="${empty itemInventory.inventoryStatus}">
					<c:set var="inventoryStatus" value="NA"/>
					<fmt:message key="INV_STATUS_NA" var="inventoryStatusText"/>
					<fmt:message key="IMG_NAME_NA" var="imageName"/>
					<fmt:message key="IMG_INV_STATUS_NA" var="altText"/>
					
				</c:when>
				<c:otherwise>
					<c:set var="inventoryStatus" value="${itemInventory.inventoryStatus.name}"/>
					<fmt:message key="INV_STATUS_${itemInventory.inventoryStatus.name}" var="inventoryStatusText"/>
					<fmt:message key="IMG_NAME_${itemInventory.inventoryStatus.name}" var="imageName"/>
					<fmt:message key="IMG_INV_STATUS_${itemInventory.inventoryStatus.name}" var="altText"/>
				</c:otherwise>
			</c:choose>
			<c:if test="${!empty physicalStores}">
				<c:set var="physicalStores" value="${physicalStores},"/>
			</c:if>
			<c:set var="physicalStores" value="${physicalStores}{
				id: '${itemInventory.inventoryAvailabilityIdentifier.externalIdentifier.physicalStoreIdentifier.uniqueID}',
				name: '${fn:escapeXml(itemInventory.inventoryAvailabilityIdentifier.externalIdentifier.physicalStoreIdentifier.externalIdentifier)}',
				status: '${inventoryStatus}',
				statusText: '${fn:escapeXml(inventoryStatusText)}',
				image: '${jspStoreImgDir}${env_vfileColor}widget_product_info/${imageName}',
				altText: '${fn:escapeXml(altText)}',
				availableDate: '${availableDate}',
				availableQuantity: '${itemInventory.availableQuantity.value}'}"/>
		</c:when>
	</c:choose>
</c:forEach>

<%-- Pick 'Select Store' message if no physical store currently picked. Pick 'Change Store' if some physical store is picked already.  --%>
<c:choose>
	<c:when test="${storeCounter eq 0}">
		<fmt:message key="INV_STATUS_CHECK_IN_STORES" var="invStatusCheckStores"/>
	</c:when>
	<c:otherwise>
		<fmt:message key="INV_STATUS_CHECK_OTHER_STORES" var="invStatusCheckStores"/>
	</c:otherwise>
</c:choose>

<%-- Prepares the json object to be returned --%>
/*
{
"onlineInventory": {
	status: "<fmt:message key="INV_STATUS_${onlineInventoryStatus}"/>",
	image: "${jspStoreImgDir}${env_vfileColor}widget_product_info/<fmt:message key="IMG_NAME_${onlineInventoryStatus}"/>",
	altText: "<fmt:message key="IMG_INV_STATUS_${onlineInventoryStatus}"/>"},
"inStoreInventory": {
	stores: [${physicalStores}],
	checkStoreText: "${invStatusCheckStores}"
	}
}
*/
