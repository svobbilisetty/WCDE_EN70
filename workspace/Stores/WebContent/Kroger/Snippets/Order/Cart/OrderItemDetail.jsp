<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2008, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!-- BEGIN OrderItemDetail.jsp -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ include file="../../../Common/EnvironmentSetup.jspf"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<flow:ifEnabled feature="AjaxCheckout"> 
	<c:set var="isAjaxCheckout" value="true" />
</flow:ifEnabled>
<flow:ifDisabled feature="AjaxCheckout"> 
<form name="ShopCartForm" method="post" action="OrderChangeServiceItemUpdate" id="ShopCartForm">
	<c:set var="isAjaxCheckout" value="false" />
</flow:ifDisabled>

<flow:ifEnabled feature="AjaxAddToCart"> 
	<c:set var="isAjaxAddToCart" value="true" />
</flow:ifEnabled>
<flow:ifDisabled feature="AjaxAddToCart"> 
	<c:set var="isAjaxAddToCart" value="false" />
</flow:ifDisabled>

<flow:ifEnabled feature="AjaxMyAccountPage">
	<wcf:url var="WishListDisplayURL" value="AjaxLogonForm">
		<wcf:param name="storeId"   value="${WCParam.storeId}"  />
		<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
		<wcf:param name="langId" value="${langId}" />
		<wcf:param name="listId" value="." />    
		<wcf:param name="page" value="customerlinkwishlist"/>
	</wcf:url>
	<wcf:url var="SOAWishListDisplayURL" value="AjaxLogonForm">
		<wcf:param name="storeId"   value="${WCParam.storeId}"  />
		<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
		<wcf:param name="langId" value="${langId}" />
		<wcf:param name="listId" value="." />    
		<wcf:param name="page" value="customerlinkwishlist"/>
	</wcf:url>
</flow:ifEnabled>
<flow:ifDisabled feature="AjaxMyAccountPage">
	<wcf:url var="WishListDisplayURL" value="NonAjaxAccountWishListDisplayView">
		<wcf:param name="storeId"   value="${WCParam.storeId}"  />
		<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
		<wcf:param name="langId" value="${langId}" />
		<wcf:param name="listId" value="." />           
	</wcf:url>
	<wcf:url var="SOAWishListDisplayURL" value="NonAjaxAccountWishListDisplayView">
		<wcf:param name="storeId"   value="${WCParam.storeId}"  />
		<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
		<wcf:param name="langId" value="${langId}" />
		<wcf:param name="listId" value="." />           
	</wcf:url>
</flow:ifDisabled>

<wcf:url var="GuestWishListDisplayURL" value="InterestItemDisplay">
		<wcf:param name="storeId"   value="${WCParam.storeId}"  />
		<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
		<wcf:param name="langId" value="${langId}" />
		<wcf:param name="listId" value="." />           
	</wcf:url>

<c:choose>
	<c:when test="${userType eq 'G'}">
		<c:set var="interestItemDisplayURL" value="${GuestWishListDisplayURL}"/>
	</c:when>
	<c:otherwise>
		<c:set var="interestItemDisplayURL" value="${WishListDisplayURL}"/>
	</c:otherwise>
</c:choose>

<c:set var="search" value='"'/>
<c:set var="replaceStr" value="'"/>
<c:set var="search01" value="'"/>
<c:set var="replaceStr01" value="\\'"/>
<c:set var="replaceStr02" value="inches"/>

<c:set var="pageSize" value="${WCParam.pageSize}" />
<c:if test="${empty pageSize}">
	<c:set var="pageSize" value="${maxOrderItemsPerPage}"/>
</c:if>

<c:set var="beginIndex" value="${WCParam.beginIndex}" />
<c:if test="${empty beginIndex}">
	<c:set var="beginIndex" value="0" />
</c:if>
	
<c:set var="pagorder" value="${requestScope.order}"/>
<c:set var="orderId" value="${WCParam.orderId}"/>

<c:choose>
	<c:when test="${(empty pagorder || pagorder == null) && (!empty orderId && orderId != null) && (!empty WCParam.fromPage && WCParam.fromPage == 'pendingOrderDisplay')}">
	
			<wcf:getData type="com.ibm.commerce.order.facade.datatypes.OrderType" scope="request" 
				var="pagorder" expressionBuilder="findByOrderIdWithPagingOnItem" varShowVerb="ShowVerbCart" maxItems="${pageSize}" recordSetStartNumber="${beginIndex}" recordSetReferenceId="ostatus">
				<wcf:param name="orderId" value="${orderId}" />	 
				<wcf:param name="sortOrderItemBy" value="orderItemID" />
				<wcf:param name="isSummary" value="false" />
			</wcf:getData>
			<c:if test="${beginIndex > ShowVerbCart.recordSetTotal}">
				<fmt:formatNumber var="totalPages" value="${(ShowVerbCart.recordSetTotal/pageSize)}" maxFractionDigits="0"/>		
				<c:if test="${ShowVerbCart.recordSetTotal%pageSize < (pageSize/2)}">
					<fmt:formatNumber var="totalPages" value="${(ShowVerbCart.recordSetTotal+(pageSize/2)-1)/pageSize}" maxFractionDigits="0"/>
				</c:if>
				<fmt:parseNumber var="totalPages" value="${totalPages}" integerOnly="true" parseLocale="en_US"/>
				<c:set var="beginIndex" value="${(totalPages-1)*pageSize}" />
				<wcf:getData type="com.ibm.commerce.order.facade.datatypes.OrderType" scope="request" 
					var="pagorder" expressionBuilder="findByOrderIdWithPagingOnItem" varShowVerb="ShowVerbCart" maxItems="${pageSize}" recordSetStartNumber="${beginIndex}" recordSetReferenceId="ostatus">
					<wcf:param name="orderId" value="${orderId}" />	 
					<wcf:param name="sortOrderItemBy" value="orderItemID" />
					<wcf:param name="isSummary" value="false" />
				</wcf:getData>
			</c:if>
	</c:when>
	<c:otherwise>
		<c:if test="${empty pagorder || pagorder == null}">
			<wcf:getData type="com.ibm.commerce.order.facade.datatypes.OrderType"
				var="pagorder" expressionBuilder="findCurrentShoppingCartWithPagingOnItem" varShowVerb = "ShowVerbCart" maxItems="${pageSize}" recordSetStartNumber="${beginIndex}" recordSetReferenceId="ostatus">
				<wcf:param name="accessProfile" value="IBM_Details" />	 
				<wcf:param name="sortOrderItemBy" value="orderItemID" />
				<wcf:param name="isSummary" value="false" />
			</wcf:getData>
			<c:if test="${beginIndex > ShowVerbCart.recordSetTotal}">
				<fmt:formatNumber var="totalPages" value="${(ShowVerbCart.recordSetTotal/pageSize)}"/>		
				<c:if test="${ShowVerbCart.recordSetTotal%pageSize < (pageSize/2)}">
					<fmt:parseNumber var="totalPages" value="${(ShowVerbCart.recordSetTotal+(pageSize/2)-1)/pageSize}" parseLocale="en_US"/>
				</c:if>
				<fmt:parseNumber var="totalPages" value="${totalPages}" integerOnly="true" parseLocale="en_US"/>
				<c:set var="beginIndex" value="${(totalPages-1)*pageSize}" />
				<wcf:getData type="com.ibm.commerce.order.facade.datatypes.OrderType"
					var="pagorder" expressionBuilder="findCurrentShoppingCartWithPagingOnItem" varShowVerb = "ShowVerbCart" maxItems="${pageSize}" recordSetStartNumber="${beginIndex}" recordSetReferenceId="ostatus">
					<wcf:param name="accessProfile" value="IBM_Details" />	 
					<wcf:param name="sortOrderItemBy" value="orderItemID" />
					<wcf:param name="isSummary" value="false" />
				</wcf:getData>
			</c:if>
		</c:if>		
	</c:otherwise>
</c:choose>

<c:if test="${beginIndex == 0}">
	<c:if test="${ShowVerbCart.recordSetTotal > ShowVerbCart.recordSetCount}">		
		<c:set var="pageSize" value="${ShowVerbCart.recordSetCount}" />
	</c:if>
</c:if>	

<c:set var="numEntries" value="${ShowVerbCart.recordSetTotal}"/>	

<c:if test="${numEntries > pageSize}">
	<fmt:formatNumber var="totalPages" type="number" groupingUsed="false" value="${numEntries / pageSize}" maxFractionDigits="0" />
	<c:if test="${numEntries - (totalPages * pageSize) > 0}" >
		<c:set var="totalPages" value="${totalPages + 1}" />
	</c:if>
		
	<c:choose>
		<c:when test="${beginIndex + pageSize >= numEntries}">
			<c:set var="endIndex" value="${numEntries}" />
		</c:when>
		<c:otherwise>
			<c:set var="endIndex" value="${beginIndex + pageSize}" />
		</c:otherwise>
	</c:choose>

	<fmt:formatNumber var="currentPage" value="${(beginIndex/pageSize)+1}"/>
	<fmt:parseNumber var="currentPage" value="${currentPage}" integerOnly="true" parseLocale="en_US"/>

	<div id="ShopcartPaginationText1">
		<div class="textfloat">
		<fmt:message key="CATEGORY_RESULTS_DISPLAYING" > 
				<fmt:param><fmt:formatNumber value="${beginIndex + 1}"/></fmt:param>
				<fmt:param><fmt:formatNumber value="${endIndex}"/></fmt:param>
				<fmt:param><fmt:formatNumber value="${numEntries}"/></fmt:param>
		</fmt:message>
		</div>
		<div class="text textfloat divpadding">
		
			<c:if test="${beginIndex != 0}">	
					
				<c:choose>
					<c:when test="${param.fromPage == 'pendingOrderDisplay'}">
							<a id="ShopcartPaginationText1_1" class="tlignore" href="javaScript:if(!CheckoutHelperJS.checkForDirtyFlag()){setCurrentId('ShopcartPaginationText1_1'); if(submitRequest()){ cursor_wait();
						wc.render.updateContext('PendingOrderPaginationDisplay_Context',{'beginIndex':'<c:out value='${beginIndex - pageSize}'/>','pageSize':'<c:out value='${pageSize}'/>'});}}">
				
					</c:when>
					<c:otherwise>
						<a id="ShopcartPaginationText1_1" class="tlignore" href="javaScript:if(!CheckoutHelperJS.checkForDirtyFlag()){setCurrentId('ShopcartPaginationText1_1'); if(submitRequest()){ cursor_wait();
					wc.render.updateContext('ShopCartPaginationDisplay_Context',{'beginIndex':'<c:out value='${beginIndex - pageSize}'/>','pageSize':'<c:out value='${pageSize}'/>'});}}">
				
					</c:otherwise>
				</c:choose>
				
				</c:if>
				
					<img src="<c:out value="${jspStoreImgDir}${env_vfileColor}${vfileColorBIDI}" />paging_back.png" alt="<fmt:message key="CATEGORY_PAGING_LEFT_IMAGE" />" />
				
				<c:if test="${beginIndex != 0}">
					</a>
				</c:if>
			<span>
			
			<fmt:message key="CATEGORY_RESULTS_PAGES_DISPLAYING" > 
					<fmt:param><fmt:formatNumber value="${currentPage}"/></fmt:param>
					<fmt:param><fmt:formatNumber value="${totalPages}"/></fmt:param>
				</fmt:message>
			
			</span>
				
				<c:if test="${numEntries > endIndex }">
				<c:choose>
					<c:when test="${param.fromPage == 'pendingOrderDisplay'}">
							<a id="ShopcartPaginationText1_2" class="tlignore" href="javaScript:if(!CheckoutHelperJS.checkForDirtyFlag()){setCurrentId('ShopcartPaginationText1_2'); if(submitRequest()){ cursor_wait();
						wc.render.updateContext('PendingOrderPaginationDisplay_Context',{'beginIndex':'<c:out value='${beginIndex + pageSize}'/>','pageSize':'<c:out value='${pageSize}'/>'});}}">
				
					</c:when>
					<c:otherwise>
						<a id="ShopcartPaginationText1_2" class="tlignore" href="javaScript:if(!CheckoutHelperJS.checkForDirtyFlag()){setCurrentId('ShopcartPaginationText1_2'); if(submitRequest()){ cursor_wait();
						wc.render.updateContext('ShopCartPaginationDisplay_Context',{'beginIndex':'<c:out value='${beginIndex + pageSize}'/>','pageSize':'<c:out value='${pageSize}'/>'});}}">
					
					</c:otherwise>
				</c:choose>
					</c:if>
				<img src="<c:out value="${jspStoreImgDir}${env_vfileColor}${vfileColorBIDI}" />paging_next.png" alt="<fmt:message key="CATEGORY_PAGING_RIGHT_IMAGE" />" />
				<c:if test="${numEntries > endIndex }">
					</a>
				</c:if>
		
		</div>
	</div>
	<div class="clear_float"></div>
</c:if> 

<c:set var="allContractsValid" value="true" scope="request"/>
<table id="order_details" cellpadding="0" cellspacing="0" border="0" width="100%" summary="<fmt:message key="SHOPCART_TABLE_SUMMARY" />">
	  <tr class="nested">
		   <th class="align_left" id="shoppingCart_tableCell_productName"><fmt:message key="SHOPCART_PRODUCT" /></th>
		   <th class="align_left" id="shoppingCart_tableCell_availability"><fmt:message key="SHOPCART_AVAILABILITY" /></th>
		   <th class="align_center" id="shoppingCart_tableCell_quantity" abbr="<fmt:message key="QUANTITY1" />"><fmt:message key="SHOPCART_QTY" /></th>
		   <th class="align_right" id="shoppingCart_tableCell_each" abbr="<fmt:message key="UNIT_PRICE" />"><fmt:message key="SHOPCART_EACH" /></th>
		   <th class="align_right" id="shoppingCart_tableCell_total" abbr="<fmt:message key="TOTAL_PRICE" />"><fmt:message key="SHOPCART_TOTAL" /></th>
	  </tr>

<flow:ifDisabled feature="AjaxCheckout">                                 
	
	<input type="hidden" name="storeId" value='<c:out value="${storeId}"/>' id="WC_OrderItemDetailsf_inputs_5"/>
	<input type="hidden" name="langId" value='<c:out value="${langId}" />' id="WC_OrderItemDetailsf_inputs_6"/>
	<input type="hidden" name="orderId" value='<c:out value="${pagorder.orderIdentifier.uniqueID}"/>' id="WC_OrderItemDetailsf_inputs_7"/>
	<input type="hidden" name="catalogId" value='<c:out value="${catalogId}"/>' id="WC_OrderItemDetailsf_inputs_8"/>
	<c:choose>
		<c:when test="${param.fromPage == 'pendingOrderDisplay'}">
			<input type="hidden" name="URL" id="WC_OrderItemDetailsf_inputs_4" value='PendingOrderDisplayView?orderId=<c:out value="${pagorder.orderIdentifier.uniqueID}"/>&catalogId=<c:out value="${catalogId}"/>&storeId=<c:out value="${storeId}"/>&langId=<c:out value="${langId}"/>'/>
			<input type="hidden" name="errorViewName" value="PendingOrderDisplayView" id="WC_OrderItemDetailsf_inputs_9"/>
		</c:when>
		<c:otherwise>
			<input type="hidden" name="URL" id="WC_OrderItemDetailsf_inputs_4" value='AjaxOrderItemDisplayView?&orderItem*=&quantity*=&selectedAttr*=&catalogId_*=&beginIndex*=&orderId*='/>
			<input type="hidden" name="errorViewName" value="AjaxOrderItemDisplayView" id="WC_OrderItemDetailsf_inputs_9"/>
		</c:otherwise>
	</c:choose>
				
		
	<input type="hidden" name="calculationUsage" value="-1,-2,-3,-4,-5,-6,-7" id="WC_OrderItemDetailsf_inputs_10"/>
							
</flow:ifDisabled>

	<c:if test="${pagorder.orderItem != null && !empty pagorder.orderItem}">
		<%-- Try to get it from our internal hashMap --%>
		<c:if test="${cachedStoreCatalogEntryAttributesByIDsMap == null}">
			<wcf:useBean var="cachedStoreCatalogEntryAttributesByIDsMap" classname="java.util.HashMap" scope="request"/>
		</c:if>
		<c:set var="key1" value="getStoreCatalogEntryAttributesByIDs"/>
		<c:set var="catalogEntriesForAttributes" value="${cachedStoreCatalogEntryAttributesByIDsMap[key1]}"/>
		<c:if test="${empty catalogEntriesForAttributes}">
			<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogEntryType[]" var="catalogEntriesForAttributes" expressionBuilder="getStoreCatalogEntryAttributesByIDs">
				<wcf:contextData name="storeId" data="${WCParam.storeId}"/>
				<c:forEach var="orderItem" items="${pagorder.orderItem}">
					<wcf:param name="UniqueID" value="${orderItem.catalogEntryIdentifier.uniqueID}"/>
				</c:forEach>
				<wcf:param name="dataLanguageIds" value="${WCParam.langId}"/>
			</wcf:getData>
			<wcf:set target = "${cachedStoreCatalogEntryAttributesByIDsMap}" key="${key1}" value="${catalogEntriesForAttributes}"/>
		</c:if>

		<c:if test="${showDynamicKit eq 'true'}">
			<c:set var="orderHasDKComponents" value="false" />
			<c:forEach var="orderItem" items="${pagorder.orderItem}">
				<c:if test="${!empty orderItem.configurationID && !empty orderItem.orderItemComponent}">
					<c:set var="orderHasDKComponents" value="true" />
				</c:if>
			</c:forEach>
			<c:if test="${orderHasDKComponents eq 'true'}">
				<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogNavigationViewType" var="dkComponents" 
						expressionBuilder="getCatalogEntryViewAllByID" scope="request" varShowVerb="showCatalogNavigationView" 
						maxItems="100" recordSetStartNumber="0" scope="request">
								<c:forEach var="orderItem" items="${pagorder.orderItem}">
								<wcf:param name="UniqueID" value="${orderItem.catalogEntryIdentifier.uniqueID}"/>
									<c:forEach var="orderItemComponents" items="${orderItem.orderItemComponent}">
										<wcf:param name="UniqueID" value="${orderItemComponents.catalogEntryIdentifier.uniqueID}"/>
									</c:forEach>
								</c:forEach>
								<wcf:contextData name="storeId" data="${WCParam.storeId}" />
								<wcf:contextData name="catalogId" data="${WCParam.catalogId}" />
				</wcf:getData>
			</c:if>
		</c:if>
	</c:if>
	
	<%--
		The following snippet retrieves all the catalog entries associated with each item in the current order.
		It was taken out of the larger c:forEach loop below for performance reasons.
	--%>
	<jsp:useBean id="catalogEntryDataBeansInThisOrder" class="java.util.HashMap" scope="page"/>
	<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogNavigationViewType" var="allCatEntryInOrder" expressionBuilder="getCatalogEntryViewParentInfoByIDNoEntitlementCheck">
		<c:forEach var="orderItem0" items="${pagorder.orderItem}">
			<wcf:param name="UniqueID" value="${orderItem0.catalogEntryIdentifier.uniqueID}"/>
		</c:forEach>
		<wcf:contextData name="storeId" data="${WCParam.storeId}" />
		<wcf:contextData name="catalogId" data="${WCParam.catalogId}" />
	</wcf:getData>
	<c:set var="orderHasCatentryWithParent" value="false" />
	<c:forEach var="aCatEntry" items="${allCatEntryInOrder.catalogEntryView}">
		<c:set property="${aCatEntry.uniqueID}" value="${aCatEntry}" target="${catalogEntryDataBeansInThisOrder}"/>
		<c:if test="${!empty aCatEntry.parentCatalogEntryID}">
			<c:set var="orderHasCatentryWithParent" value="true" />
		</c:if>
	</c:forEach>
	
	<jsp:useBean id="parentCatalogEntrysMap" class="java.util.HashMap" scope="page"/>
	<c:if test="${orderHasCatentryWithParent}">
		<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogNavigationViewType" var="parentCatalogEntrys" expressionBuilder="getCatalogEntryViewForShoppingCart">
			<c:forEach var="oneCatEntry" items="${allCatEntryInOrder.catalogEntryView}">
				<c:if test="${!empty oneCatEntry.parentCatalogEntryID}">
					<wcf:param name="UniqueID" value="${oneCatEntry.parentCatalogEntryID}"/>
				</c:if>
			</c:forEach>
			<wcf:param name="searchProfile" value="IBM_findCatalogEntrySKUs"/>
			<wcf:contextData name="storeId" data="${WCParam.storeId}" />
			<wcf:contextData name="catalogId" data="${WCParam.catalogId}" />
		</wcf:getData>
		<c:forEach var="oneCatEntry" items="${parentCatalogEntrys.catalogEntryView}">
			<c:set property="${oneCatEntry.uniqueID}" value="${oneCatEntry}" target="${parentCatalogEntrysMap}"/>
		</c:forEach>
	</c:if>
	<c:set var="nonRecurringOrderItems" value=""/>
	<c:set var="nonRecurringOrderItemsCount" value="0"/>
	<c:forEach var="orderItem" items="${pagorder.orderItem}" varStatus="status">
		<c:set var="catEntry" value="${catalogEntryDataBeansInThisOrder[orderItem.catalogEntryIdentifier.uniqueID]}"/>
		<c:set var="patternName" value="ProductURL"/>
		
		<%-- The URL that links to the display page --%>
		<wcf:url var="catEntryDisplayUrl" patternName="${patternName}" value="Product2">
			<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
			<wcf:param name="storeId" value="${WCParam.storeId}"/>
			<wcf:param name="productId" value="${orderItem.catalogEntryIdentifier.uniqueID}"/>
			<wcf:param name="langId" value="${langId}"/>
			<wcf:param name="urlLangId" value="${urlLangId}" />
		</wcf:url>
				
		<%-- If this is a product and has defining attributes, then allow user to change --%>
		<c:set var="parentCatEntryId" value="${catEntry.parentCatalogEntryID}"/>
		<c:set var="childrenSKUCount" value="0"/>
		<c:if test="${!empty parentCatEntryId}">
			<c:set var="parentCatalogEntry" value="${parentCatalogEntrysMap[parentCatEntryId]}"/>
			<c:set var="childrenSKUCount" value="${parentCatalogEntry.numberOfSKUs}"/>
		</c:if>
		
		<c:forEach var="metadata" items="${catEntry.metaData}" varStatus="status2">
			<c:if test="${metadata.key == 'ThumbnailPath'}">
				<c:set var="thumbNail" value="${env_imageContextPath}/${metadata.value}" />
			</c:if>			
		</c:forEach>
		
		<c:choose>
			<c:when test="${empty  catEntry.name}">			
				<c:set var="cartItemName" value="${orderItem.catalogEntryIdentifier.externalIdentifier.partNumber}" />
				<c:set var="cartItemPartNumber" value="${orderItem.catalogEntryIdentifier.externalIdentifier.partNumber}" />
			</c:when>
			<c:otherwise>
				<c:set var="cartItemName" value="${catEntry.name}" />
				<c:set var="cartItemPartNumber" value="${catEntry.partNumber}" />
			</c:otherwise>
		</c:choose>
		
		<%-- get the formatted qty for this item --%>
		<fmt:formatNumber var="quickCartOrderItemQuantity" value="${orderItem.quantity.value}"  pattern='#####'/>
		<%-- keep setting total number of items variable..in the last loop, it will contain correct value :-)better to get this value using length function.. --%>
		<c:set var="totalNumberOfItems" value="${status.count}"/>
		<input type="hidden" value='<c:out value="${orderItem.orderItemIdentifier.uniqueID}"/>' name='orderItem_<c:out value="${status.count}"/>' id='orderItem_<c:out value="${status.count}"/>'/>
		<input type="hidden" value='<c:out value="${orderItem.catalogEntryIdentifier.uniqueID}"/>' name='catalogId_<c:out value="${status.count}"/>' id='catalogId_<c:out value="${status.count}"/>'/>
		<tr>
		
			<c:forEach var="discounts" items="${orderItem.orderItemAmount.adjustment}">			
					<%-- only show the adjustment detail if display level is OrderItem, if display level is order, display it at the order summary section --%>
					<c:if test="${discounts.displayLevel == 'OrderItem'}">
						<c:set var="nobottom" value="th_align_left_no_bottom"/>
					</c:if>
			</c:forEach>
			<th class="th_align_left_normal <c:out value="${nobottom}"/>" id="shoppingCart_rowHeader_product<c:out value='${status.count}'/>" abbr="<fmt:message key="Checkout_ACCE_for" /> <c:out value="${fn:replace(cartItemName, search, replaceStr)}" escapeXml="false"/>">
				<div class="img" id="WC_OrderItemDetailsf_div_1_<c:out value='${status.count}'/>">
					<c:set var="catEntryIdentifier" value="${orderItem.catalogEntryIdentifier.uniqueID}"/>
					<c:choose>
						<c:when test="${!empty thumbNail}">
							<c:set var="imgSource" value="${fn:replace(thumbNail, itemThumbnailImage, miniImage)}" />
						</c:when>
						<c:otherwise>
							<c:set var="imgSource" value="${jspStoreImgDir}images/NoImageIcon_sm.jpg" />
						</c:otherwise>
					</c:choose>	
					<a href="${catEntryDisplayUrl}" id="catalogEntry_img_${orderItem.orderItemIdentifier.uniqueID}" title="${cartItemName}">
						<img alt="" src="${imgSource}"/>
					</a>
					<c:remove var="thumbNail"/>
				</div>			
				<div id="WC_OrderItemDetailsf_div_2_<c:out value='${status.count}'/>" class="img">
					<c:if test="${!empty  catEntry.name}">
						<p><a class="hover_underline" id="catalogEntry_name_${orderItem.orderItemIdentifier.uniqueID}" href="<c:out value="${catEntryDisplayUrl}"/>"><c:out value="${cartItemName}" escapeXml="false"/></a></p>
					</c:if>
					<span><fmt:message key="CurrentOrder_SKU" /> <c:out value="${cartItemPartNumber}" escapeXml="false"/></span><br/>	
					<c:if test="${orderItem.orderItemAmount.freeGift}">
						<p class="italic"><fmt:message key="SHOPCART_FREEGIFT" /></p>
					</c:if>
					<%@ include file="../../ReusableObjects/OrderGiftItemDisplayExt.jspf" %>
					<%@ include file="../../ReusableObjects/GiftRegistryOrderGiftItemDisplayExt.jspf" %>
					<%--
					 ***
					 * Start: Display Defining attributes
					 * Loop through the attribute values and display the defining attributes
					 ***
					--%>
					
						<c:forEach var="catalogEntry1" items="${catalogEntriesForAttributes}">
							<c:if test="${catalogEntry1.catalogEntryIdentifier.uniqueID == orderItem.catalogEntryIdentifier.uniqueID}">
								<c:remove var="selectedAttr"/>
								<c:remove var="disallowRecurringOrder"/>
								<c:forEach var="attribute" items="${catalogEntry1.catalogEntryAttributes.attributes}" varStatus="status2">
									<c:if test="${ attribute.usage=='Defining' }" >	
										<c:choose>
											<c:when test="${empty selectedAttr}">
												<c:set var="selectedAttr" value="${attribute.name}|${attribute.value.value}"/>
											</c:when>
											<c:otherwise>
												<c:set var="selectedAttr" value="${selectedAttr}|${attribute.name}|${attribute.value.value}"/>
											</c:otherwise>
										</c:choose>
									</c:if>
									<c:if test="${ attribute.name=='disallowRecurringOrder' }" >
										<c:set var="disallowRecurringOrder" value="${attribute.stringValue.value}"/>
									</c:if>
								</c:forEach>
								
								<c:if test="${!orderItem.orderItemAmount.freeGift && !empty selectedAttr && childrenSKUCount > 1}">
									<a class="order_link hover_underline tlignore" id="WC_OrderItemDetailsf_links_1_<c:out value='${status.count}'/>_<c:out value='${status2.count}'/>" href="javaScript: if (!this.disabled) {setCurrentId('WC_OrderItemDetailsf_links_1_<c:out value="${status.count}"/>_<c:out value="${status2.count}"/>');
										QuickInfoJS.changeAttributes('${orderItem.orderItemIdentifier.uniqueID}','<c:out value='${parentCatEntryId}'/>', '${orderItem.catalogEntryIdentifier.uniqueID}',${quickCartOrderItemQuantity});}"> 
										<fmt:message key="CHANGE_ATTRIBUTES" />
									</a>
									<br/>
								</c:if>
								<input type="hidden" name="selectedAttr" id="selectedAttr_${orderItem.orderItemIdentifier.uniqueID}" value="${selectedAttr}"/>
								
								<%-- Build non recurring item message for order item --%>
								<c:if test="${disallowRecurringOrder == '1'}">
									<c:set var="nonRecurringOrderItemsCount" value="${nonRecurringOrderItemsCount+1}"/>
									<c:if test="${!empty nonRecurringOrderItems}">
										<c:set var="nonRecurringOrderItems" value="${nonRecurringOrderItems},"/>
									</c:if>
									<c:set var="nonRecurringOrderItems" value="${nonRecurringOrderItems}${orderItem.orderItemIdentifier.uniqueID}"/>
									<div class="no_checkout" id="nonRecurringItem_<c:out value='${orderItem.orderItemIdentifier.uniqueID}'/>" style="display: none;"><div class="no_checkout_icon"></div> &nbsp;<fmt:message key="NON_RECURRING_PRODUCT" /></div>
								</c:if>
								
							</c:if>
						</c:forEach>
					<%--
					 ***
					 * End: Display Defining attributes
					 ***
					--%>
					
					<c:if test="${showDynamicKit eq 'true' && !empty orderItem.configurationID}">
						<div class="top_margin5px"><fmt:message key="CONFIGURATION" /></div>
						<p>
							<ul class="product_specs" id="configuredComponents_${orderItem.orderItemIdentifier.uniqueID}">
								<c:forEach var="oiComponent" items="${orderItem.orderItemComponent}">
									<c:forEach var="savedDKComponent" items="${dkComponents.catalogEntryView}">
										<c:if test="${savedDKComponent.uniqueID == oiComponent.catalogEntryIdentifier.uniqueID}">
											<fmt:formatNumber var="itemComponentQuantity" value="${oiComponent.quantity.value}" type="number" maxFractionDigits="0"/>
											
											<c:choose>
												<c:when test="${itemComponentQuantity>1}">
													<%-- output order item component quantity in the form of "5 x ComponentName" --%>
													<fmt:message var="txtOrderItemQuantityAndName" key="ITEM_COMPONENT_QUANTITY_NAME" > 
														<fmt:param><c:out value="${itemComponentQuantity}" escapeXml="false"/></fmt:param>
														<fmt:param><c:out value="${savedDKComponent.shortDescription}" escapeXml="false"/></fmt:param>
													</fmt:message>
													<li><c:out value="${txtOrderItemQuantityAndName}"/></li>
												</c:when>
												<c:otherwise>
													<li><c:out value="${savedDKComponent.shortDescription}"/></li>
												</c:otherwise>
											</c:choose>
										</c:if>
									</c:forEach>
								</c:forEach>
							</ul>
						</p>
						<wcf:url var="dkConfigureURL" value="ConfigureView">
							<wcf:param name="storeId"   value="${WCParam.storeId}"  />
							<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
							<wcf:param name="langId" value="${langId}" />
							<wcf:param name="catEntryId" value="${orderItem.catalogEntryIdentifier.uniqueID}" />
							<wcf:param name="orderItemId" value="${orderItem.orderItemIdentifier.uniqueID}"/>
							<wcf:param name="contractId" value="${orderItem.contractIdentifier.uniqueID}"/>
							<wcf:param name="fromURL" value="AjaxOrderItemDisplayView" />
						</wcf:url>
						<p>
							<a href="<c:out value='${dkConfigureURL}'/>"><fmt:message key="CHANGE_CONFIGURATION" /></a>	
						</p>
					</c:if>
					
					<c:set var="fromPage" value="${param.fromPage}" scope="request"/>
					<c:set var="orderId" value="${pagorder.orderIdentifier.uniqueID}" scope="request"/>
					
					<c:if test="${!orderItem.orderItemAmount.freeGift}">
						<c:set var="isShoppingCartPage" value="true"/>
						<%@ include file="B2BContractSelectExt.jspf" %>		
						<br/>
						
							<%-- displays move to wish list link if user is a registered shopper --%>
							<flow:ifEnabled feature="SOAWishlist">
								<%out.flush();%>
								<c:import url = "${env_jspStoreDir}Widgets/ShoppingList/ShoppingList.jsp">
									<c:param name="parentPage" value="OI${orderItem.orderItemIdentifier.uniqueID}"/>
									<c:param name="catalogId" value="${WCParam.catalogId}"/>
									<c:param name="productId" value="${orderItem.catalogEntryIdentifier.uniqueID}"/>
									<c:param name="deleteCartCookie" value="true" />
									<c:param name="orderItemId" value="${orderItem.orderItemIdentifier.uniqueID}"/>
								</c:import>
								<%out.flush();%>
							</flow:ifEnabled>
						

						<flow:ifEnabled feature="AjaxCheckout">
							<a class="remove_address_link hover_underline tlignore" id="WC_OrderItemDetailsf_links_2_<c:out value='${status.count}'/>" href="JavaScript:setCurrentId('WC_OrderItemDetailsf_links_2_<c:out value='${status.count}'/>'); CheckoutHelperJS.deleteFromCart('<c:out value='${orderItem.orderItemIdentifier.uniqueID}'/>');">
								<img src="<c:out value='${jspStoreImgDir}${vfileColor}'/>table_x_delete.png" alt=""/>
								<fmt:message key="SHOPCART_REMOVE" />
							</a>
						</flow:ifEnabled>
						<flow:ifDisabled feature="AjaxCheckout">
							<wcf:url var="OrderItemDelete" value="OrderChangeServiceItemDelete">
								<wcf:param name="orderItemId" value="${orderItem.orderItemIdentifier.uniqueID}"/>
								<wcf:param name="orderId" value="${pagorder.orderIdentifier.uniqueID}"/>
								<wcf:param name="langId" value="${WCParam.langId}" />
								<wcf:param name="storeId" value="${WCParam.storeId}" />
								<wcf:param name="catalogId" value="${WCParam.catalogId}" />
								<wcf:param name="calculationUsage" value="-1,-2,-3,-4,-5,-6,-7" />
								<c:choose>
									<c:when test="${param.fromPage != null && param.fromPage == 'pendingOrderDisplay'}">
										<wcf:param name="URL" value="PendingOrderDisplayView" />
										<wcf:param name="errorViewName" value="PendingOrderDisplayView" />
									</c:when>
									<c:otherwise>
										<wcf:param name="URL" value="AjaxOrderItemDisplayView" />
										<wcf:param name="errorViewName" value="AjaxOrderItemDisplayView" />
									</c:otherwise>
								</c:choose>
								
								<wcf:param name="beginIndex" value="${beginIndex}" />
							</wcf:url>
							<a class="hover_underline" href="#" onclick="Javascript:setPageLocation('<c:out value='${OrderItemDelete}'/>');return false;" id="WC_OrderItemDetailsf_links_3_<c:out value='${status.count}'/>">
								<img src="<c:out value='${jspStoreImgDir}${vfileColor}'/>table_x_delete.png" alt=""/>
								<fmt:message key="SHOPCART_REMOVE"  />
							</a>
						</flow:ifDisabled>

					</c:if>
				</div>
			</th>
			<td id="WC_OrderItemDetailsf_td_1_<c:out value='${status.count}'/>" class="<c:out value="${nobottom}"/> avail" headers="shoppingCart_tableCell_availability shoppingCart_rowHeader_product<c:out value='${status.count}'/>">
				<%@ include file="../../ReusableObjects/CatalogEntryAvailabilityDisplay.jspf" %>				
			</td>
			<td id="WC_OrderItemDetailsf_td_2_<c:out value='${status.count}'/>" class="<c:out value="${nobottom}"/> QTY" headers="shoppingCart_tableCell_quantity shoppingCart_rowHeader_product<c:out value='${status.count}'/>">
				<p class="item-quantity">
					<c:choose>
						<c:when test="${orderItem.orderItemAmount.freeGift}">
							<%-- This is a free item..can't change the qty --%>
							<input type="hidden" value="-1" id='freeGift_qty_<c:out value="${status.count}"/>' name='qty_<c:out value="${status.count}"/>'/><span><c:out value="${quickCartOrderItemQuantity}"/></span>
						</c:when>
						<c:otherwise>
							<flow:ifEnabled feature="AjaxCheckout">
								<label for='qty_<c:out value="${status.count}"/>' style='display:none'><fmt:message key="QUANTITY1" /></label>
								<input id='qty_<c:out value="${status.count}"/>' name='qty_<c:out value="${status.count}"/>' type="tel" size="1" style="width:25px;" value='<c:out value="${quickCartOrderItemQuantity}"/>' onkeydown="JavaScript:setCurrentId('qty_<c:out value='${status.count}'/>'); CheckoutHelperJS.updateCartWait(this, '<c:out value='${orderItem.orderItemIdentifier.uniqueID}'/>',event)" />
							</flow:ifEnabled>
							<flow:ifDisabled feature="AjaxCheckout">
								<label for='quantity_<c:out value="${status.count}"/>' style='display:none'><fmt:message key="QUANTITY1" /></label>
								<input type="hidden" value='<c:out value="${orderItem.orderItemIdentifier.uniqueID}"/>' name='orderItemId_<c:out value="${status.count}"/>' id='orderItemId_<c:out value="${status.count}"/>'/>
								<fmt:formatNumber	var="quickCartOrderItemQuantity" value="${orderItem.quantity.value}" type="number" maxFractionDigits="0"/>
								<input type="tel" size="2" class="input" value='<c:out value="${quickCartOrderItemQuantity}"/>' id='quantity_<c:out value="${status.count}"/>' name='quantity_<c:out value="${status.count}"/>'/>
							</flow:ifDisabled>
						</c:otherwise>
					</c:choose>
				</p>
			</td>
			<td id="WC_OrderItemDetailsf_td_3_<c:out value='${status.count}'/>" class="<c:out value="${nobottom}"/> each" headers="shoppingCart_tableCell_each shoppingCart_rowHeader_product<c:out value='${status.count}'/>">

				<%-- unit price column of order item details table --%>
				<%-- shows unit price of the order item --%>
				<span class="price">
					<fmt:formatNumber var="formattedUnitPrice" value="${orderItem.orderItemAmount.unitPrice.price.value}" type="currency" maxFractionDigits="${env_currencyDecimal}" currencySymbol="${env_CurrencySymbolToFormat}"/>
					<c:out value="${formattedUnitPrice}" escapeXml="false" />
					<c:out value="${CurrencySymbol}"/>
				</span>

			</td>
			<td id="WC_OrderItemDetailsf_td_4_<c:out value='${status.count}'/>" class="<c:out value="${nobottom}"/> total" headers="shoppingCart_tableCell_total shoppingCart_rowHeader_product<c:out value='${status.count}'/>">
				<c:choose>
					<c:when test="${orderItem.orderItemAmount.freeGift}">
						<%-- the OrderItem is a freebie --%>
						<span class="details">
							<fmt:message key="OrderSummary_SHOPCART_FREE" />
						</span>
					</c:when>
					<c:otherwise>
						<span class="price">
							<fmt:formatNumber var="totalFormattedProductPrice" value="${orderItem.orderItemAmount.orderItemPrice.value}" type="currency" maxFractionDigits="${env_currencyDecimal}" currencySymbol="${env_CurrencySymbolToFormat}"/>
							<c:out value="${totalFormattedProductPrice}" escapeXml="false" />
							<c:out value="${CurrencySymbol}"/>
						</span>
					</c:otherwise>
				</c:choose>
			</td>
		</tr>
		<c:remove var="nobottom"/>
		<%-- row to display product level discount --%>
		<c:if test="${!empty orderItem.orderItemAmount.adjustment}">
			<jsp:useBean id="aggregatedDiscounts" class="java.util.HashMap" scope="page" />
			<jsp:useBean id="discountReferences" class="java.util.HashMap" scope="page" />
			
			<%-- Loop through the discounts, summing discounts with the same code --%>
			<c:forEach var="discounts" items="${orderItem.orderItemAmount.adjustment}">			
				<%-- only show the adjustment detail if display level is OrderItem, if display level is order, display it at the order summary section --%>
				<c:if test="${discounts.displayLevel == 'OrderItem'}">
					<c:set property="${discounts.code}" value="${discounts}" target="${discountReferences}"/> 
					<c:if test="${empty aggregatedDiscounts[discounts.code]}">
  						<c:set property="${discounts.code}" value="0" target="${aggregatedDiscounts}"/>	
  					</c:if>				
  					<c:set property="${discounts.code}" value="${aggregatedDiscounts[discounts.code]+discounts.amount.value}" target="${aggregatedDiscounts}"/>
				</c:if>
			</c:forEach>	
											
			<c:forEach var="discountsIterator" items="${discountReferences}" varStatus="status2">									
			    <c:set var="discounts" value="${discountsIterator.value}" />
   				<%-- only show the adjustment detail if display level is OrderItem, if display level is order, display it at the order summary section --%>
				<c:if test="${discounts.displayLevel == 'OrderItem'}">
					<tr>
						<th colspan="4" class="th_align_left_dotted_top_solid_bottom" abbr="<fmt:message key="Checkout_ACCE_prod_discount" /> <c:out value="${fn:replace(cartItemName, search, replaceStr)}" escapeXml="false"/>" id="shopcart_rowHeader_discount<c:out value='${status.count}'/>_<c:out value='${status2.count}'/>">
							<div class="itemspecs" id="WC_OrderItemDetailsf_div_3_<c:out value='${status.count}'/>_<c:out value='${status2.count}'/>">
								<c:url var="DiscountDetailsDisplayViewURL" value="DiscountDetailsDisplayView">
									<c:param name="code" value="${discounts.code}" />
									<c:param name="langId" value="${langId}" />
									<c:param name="storeId" value="${WCParam.storeId}" />
									<c:param name="catalogId" value="${WCParam.catalogId}" />
								</c:url>	
								<a class="discount hover_underline" href='<c:out value="${DiscountDetailsDisplayViewURL}" />' id="WC_OrderItemDetails_Link_ItemDiscount_1_<c:out value='${status2.count}'/>">
									<img src="<c:out value="${jspStoreImgDir}" />images/empty.gif" alt="<fmt:message key="Checkout_ACCE_prod_discount" /> <c:out value="${fn:replace(catalogEntry.description.name, search, replaceStr)}" escapeXml="false"/>"/>
									<c:out 	value="${discounts.description.value}" escapeXml="false"/>
								</a>
								<br />
							</div>
						</th>
						<td id="WC_OrderItemDetailsf_td_5_<c:out value='${status.count}'/>_<c:out value='${status2.count}'/>" class="th_align_left_dotted_top_solid_bottom total" headers="shopcart_rowHeader_discount<c:out value='${status.count}'/>_<c:out value='${status2.count}'/>">
							<fmt:formatNumber	var="formattedDiscountValue" value="${aggregatedDiscounts[discounts.code]}" type="currency" maxFractionDigits="${env_currencyDecimal}" currencySymbol="${env_CurrencySymbolToFormat}"/>
							<c:out value="${formattedDiscountValue}" escapeXml="false" />
							<c:out value="${CurrencySymbol}"/>
							<br />
						</td>
					</tr>	
				</c:if>			
			</c:forEach>
			<c:remove var="aggregatedDiscounts"/>
			<c:remove var="discountReferences"/>
		</c:if>
		<c:remove var="catEntry"/>
	</c:forEach>
<flow:ifDisabled feature="AjaxCheckout">
</form>
</flow:ifDisabled>
	<%-- dont change the name of this hidden input element. This variable is used in CheckoutHelper.js --%>
	<input type="hidden" id = "totalNumberOfItems" name="totalNumberOfItems" value='<c:out value="${totalNumberOfItems}"/>'/>
	
	<c:forEach var="paymentInstruction" items="${pagorder.orderPaymentInfo.paymentInstruction}">
		<c:if test="${!empty existingPaymentInstructionIds}">
			<c:set var="existingPaymentInstructionIds" value="${existingPaymentInstructionIds},"/>
		</c:if>
		<c:set var="existingPaymentInstructionIds" value="${existingPaymentInstructionIds}${paymentInstruction.uniqueID}"/>
	</c:forEach>
	<input type="hidden" name="existingPaymentInstructionId" value="<c:out value="${existingPaymentInstructionIds}"/>" id="existingPaymentInstructionId"/>

	<%-- If there are more than pageSize items in the order, we need to call another service to find out the non recurring order items in the order --%>
	<c:if test="${numEntries > pageSize}">
		<wcf:getData type="com.ibm.commerce.order.facade.datatypes.OrderType" var="nonRecOrder" expressionBuilder="findCurrentShoppingCart" varShowVerb="ShowVerbNonRec" maxItems="${pageSize}" recordSetStartNumber="0" recordSetReferenceId="nonrec_status">
			<wcf:param name="accessProfile" value="IBM_NonRecurring" />
		</wcf:getData>
		<c:set var="totalNonRecItemsInOrder" value="0"/>
		<c:set var="allNonRecOrderItemIds" value=""/>
		<c:forEach var="nonRecOrderItem" items="${nonRecOrder.orderItem}" varStatus="nonRec_status">
			<c:if test="${!empty allNonRecOrderItemIds}">
				<c:set var="allNonRecOrderItemIds" value="${allNonRecOrderItemIds},"/>
			</c:if>
			<c:set var="allNonRecOrderItemIds" value="${allNonRecOrderItemIds}${nonRecOrderItem.orderItemIdentifier.uniqueID}"/>
			<c:set var="totalNonRecItemsInOrder" value="${totalNonRecItemsInOrder+1}"/>
		</c:forEach>
		<c:set var="nonRecurringOrderItems" value="${allNonRecOrderItemIds}"/>
		<c:set var="nonRecurringOrderItemsCount" value="${totalNonRecItemsInOrder}"/>
	</c:if>

	<input type="hidden" name="currentOrderId" value="<c:out value="${pagorder.orderIdentifier.uniqueID}"/>" id="currentOrderId"/>
	<input type="hidden" name="numOrderItemsInOrder" value="<c:out value="${numEntries}"/>" id="numOrderItemsInOrder"/>
	<input type="hidden" name="nonRecurringOrderItems" value="<c:out value="${nonRecurringOrderItems}"/>" id="nonRecurringOrderItems"/>
	<input type="hidden" name="nonRecurringOrderItemsCount" value="<c:out value="${nonRecurringOrderItemsCount}"/>" id="nonRecurringOrderItemsCount"/>
 </table>

<c:if test="${numEntries > pageSize}">
	<div id="ShopcartPaginationText2">
		<div class="textfloat">
		<fmt:message key="CATEGORY_RESULTS_DISPLAYING" > 
				<fmt:param><fmt:formatNumber value="${beginIndex + 1}"/></fmt:param>
				<fmt:param><fmt:formatNumber value="${endIndex}"/></fmt:param>
				<fmt:param><fmt:formatNumber value="${numEntries}"/></fmt:param>
		</fmt:message>
		</div>
		<div class="text textfloat divpadding">
		
			<c:if test="${beginIndex != 0}">	
					
				<c:choose>
					<c:when test="${param.fromPage == 'pendingOrderDisplay'}">
							<a id="ShopcartPaginationText2_1" href="javaScript:if(!CheckoutHelperJS.checkForDirtyFlag()){setCurrentId('ShopcartPaginationText2_1'); if(submitRequest()){ cursor_wait();
						wc.render.updateContext('PendingOrderPaginationDisplay_Context',{'beginIndex':'<c:out value='${beginIndex - pageSize}'/>','pageSize':'<c:out value='${pageSize}'/>'});}}">
				
					</c:when>
					<c:otherwise>
						<a id="ShopcartPaginationText2_1" href="javaScript:if(!CheckoutHelperJS.checkForDirtyFlag()){setCurrentId('ShopcartPaginationText2_1'); if(submitRequest()){ cursor_wait();
					wc.render.updateContext('ShopCartPaginationDisplay_Context',{'beginIndex':'<c:out value='${beginIndex - pageSize}'/>','pageSize':'<c:out value='${pageSize}'/>'});}}">
				
					</c:otherwise>
				</c:choose>
				
				</c:if>
				
					<img src="<c:out value="${jspStoreImgDir}${env_vfileColor}${vfileColorBIDI}" />paging_back.png" alt="<fmt:message key="CATEGORY_PAGING_LEFT_IMAGE" />" />
				
				<c:if test="${beginIndex != 0}">
					</a>
				</c:if>
			<span>
			
			<fmt:message key="CATEGORY_RESULTS_PAGES_DISPLAYING" > 
					<fmt:param><fmt:formatNumber value="${currentPage}"/></fmt:param>
					<fmt:param><fmt:formatNumber value="${totalPages}"/></fmt:param>
				</fmt:message>
			
			</span>
				
				<c:if test="${numEntries > endIndex }">
				<c:choose>
					<c:when test="${param.fromPage == 'pendingOrderDisplay'}">
							<a id="ShopcartPaginationText2_2" href="javaScript:if(!CheckoutHelperJS.checkForDirtyFlag()){setCurrentId('ShopcartPaginationText2_2'); if(submitRequest()){ cursor_wait();
						wc.render.updateContext('PendingOrderPaginationDisplay_Context',{'beginIndex':'<c:out value='${beginIndex + pageSize}'/>','pageSize':'<c:out value='${pageSize}'/>'});}}">
				
					</c:when>
					<c:otherwise>
						<a id="ShopcartPaginationText2_2" href="javaScript:if(!CheckoutHelperJS.checkForDirtyFlag()){setCurrentId('ShopcartPaginationText2_2'); if(submitRequest()){ cursor_wait();
						wc.render.updateContext('ShopCartPaginationDisplay_Context',{'beginIndex':'<c:out value='${beginIndex + pageSize}'/>','pageSize':'<c:out value='${pageSize}'/>'});}}">
					
					</c:otherwise>
				</c:choose>
					</c:if>
				<img src="<c:out value="${jspStoreImgDir}${env_vfileColor}${vfileColorBIDI}" />paging_next.png" alt="<fmt:message key="CATEGORY_PAGING_RIGHT_IMAGE" />" />
				<c:if test="${numEntries > endIndex }">
					</a>
				</c:if>
		
		</div>
	</div>
</c:if> 

<flow:ifEnabled feature="Analytics">
	<flow:ifEnabled feature="AjaxCheckout"> 
		<script type="text/javascript">
			dojo.addOnLoad(function() {
				analyticsJS.storeId=<c:out value="${WCParam.storeId}" />;
				analyticsJS.catalogId=<c:out value="${WCParam.catalogId}" />;
				analyticsJS.publishCartView();
			});
		</script>
	</flow:ifEnabled>	
</flow:ifEnabled>	
<!-- END OrderItemDetail.jsp -->
