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
Displays the order details for Single Shipment on the Order Summary page
as well as Order Confirmation page 
--%>

<!-- BEGIN OrderItemDetailSummary.jsp -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ include file="../../../Common/EnvironmentSetup.jspf"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%-- Substring to search for --%>
 <c:set var="search" value='"'/>
<%-- Substring to replace the search string with --%>
 <c:set var="replaceStr" value="'"/>

<c:set var="pageSize" value="${WCParam.pageSize}" />
<c:if test="${empty pageSize}">
	<c:set var="pageSize" value="${maxOrderItemsPerPage}"/>
</c:if>
<fmt:parseNumber var="pageSize" value="${pageSize}"/>
<%-- Index to begin the order item paging with --%>
<c:set var="beginIndex" value="${WCParam.beginIndex}" />
<c:if test="${empty beginIndex}">
	<c:set var="beginIndex" value="0" />
</c:if> 

<%-- To identify which order page we're currently in --%>
<c:set var="orderPage" value="${param.orderPage}" />
<c:if test="${empty orderPage}">
	<c:set var="orderPage" value="${WCParam.orderPage}" />
</c:if> 

<%-- To identify if this JSP is imported from the Order Details page --%>
<c:set var="isFromOrderDetailsPage" value="false"/>
<c:if test="${(!empty param.isFromOrderDetailsPage) && (param.isFromOrderDetailsPage == 'true')}">
	<c:set var="isFromOrderDetailsPage" value="true"/>
</c:if>

<c:set var="subscriptionOrderItemId" value="${param.subscriptionOrderItemId}" />

<%@ include file="../../../Snippets/ReusableObjects/GiftItemInfoDetailsDisplayExt.jspf" %>
<%@ include file="../../../Snippets/ReusableObjects/GiftRegistryGiftItemInfoDetailsDisplayExt.jspf" %>

<%-- Retrieve the current page of order & order item information from this request --%>
<c:set var="pagorder" value="${requestScope.order}"/>
<c:if test="${empty pagorder || pagorder == null}">
<c:choose>
<c:when test="${WCParam.externalOrderId != null && WCParam.externalOrderId != ''}">
<wcf:getData type="com.ibm.commerce.order.facade.datatypes.OrderType" var="pagorder" expressionBuilder="findOrderByExternalOrderID" maxItems="${pageSize}" recordSetStartNumber="${beginIndex}" varShowVerb="ShowVerbSummary" recordSetReferenceId="summarystatus" scope="request">
			<wcf:param name="orderId" value="${WCParam.externalOrderId}"/>
			<wcf:param name="accessProfile" value="IBM_External_Details" />
			<wcf:param name="sortOrderItemBy" value="orderItemID" />
			<wcf:param name="isSummary" value="false" />
</wcf:getData>
</c:when>
<c:when test="${WCParam.externalQuoteId != null && WCParam.externalQuoteId != ''}">
<wcf:getData type="com.ibm.commerce.order.facade.datatypes.QuoteType" var="quote" expressionBuilder="findQuoteByExternalQuoteID" maxItems="${pageSize}" recordSetStartNumber="${beginIndex}" varShowVerb="ShowVerbSummary" recordSetReferenceId="summarystatus" scope="request">
			<wcf:param name="quoteId" value="${WCParam.externalQuoteId}"/>
			<wcf:param name="accessProfile" value="IBM_External_Details" />
			<wcf:param name="sortOrderItemBy" value="orderItemID" />
			<wcf:param name="isSummary" value="false" />
</wcf:getData>
<c:set var="pagorder" value="${quote.orderTemplate}" scope="request"/>
</c:when>
<c:otherwise>

	<c:choose>
		<c:when test="${orderPage == 'confirmation'}">		
			<wcf:getData type="com.ibm.commerce.order.facade.datatypes.OrderType"
			var="pagorder" expressionBuilder="findByOrderIdWithPagingOnItem" varShowVerb = "ShowVerbSummary" maxItems="${pageSize}" recordSetStartNumber="${beginIndex}" recordSetReferenceId="confirmstatus">
				<wcf:param name="orderId" value="${WCParam.orderId}"/>
				<wcf:param name="accessProfile" value="IBM_Details" />
				<wcf:param name="sortOrderItemBy" value="orderItemID" />
				<wcf:param name="isSummary" value="false" />
			</wcf:getData>
		</c:when>
		<c:otherwise>				
			<wcf:getData type="com.ibm.commerce.order.facade.datatypes.OrderType"
			var="pagorder" expressionBuilder="findCurrentShoppingCartWithPagingOnItem" varShowVerb = "ShowVerbSummary" maxItems="${pageSize}" recordSetStartNumber="${beginIndex}" recordSetReferenceId="summarystatus">
				<wcf:param name="accessProfile" value="IBM_Details" />
				<wcf:param name="sortOrderItemBy" value="orderItemID" />
				<wcf:param name="isSummary" value="false" />
			</wcf:getData>
		</c:otherwise>
	</c:choose>

</c:otherwise>
</c:choose>
</c:if>

<c:if test="${beginIndex == 0}">
	<c:if test="${ShowVerbSummary.recordSetTotal > ShowVerbSummary.recordSetCount}">		
		<c:set var="pageSize" value="${ShowVerbSummary.recordSetCount}" />
	</c:if>
</c:if>	

<c:set var="numEntries" value="${ShowVerbSummary.recordSetTotal}"/>	

<wcf:url var="currentOrderItemDetailPaging" value="OrderItemPageView" type="Ajax">
	<wcf:param name="storeId"   value="${storeId}"  />
	<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
	<wcf:param name="langId" value="${WCParam.langId}" />
	<wcf:param name="orderPage" value="${orderPage}" />
	<c:if test="${orderPage == 'confirmation'}">  
		<wcf:param name="orderId" value="${WCParam.orderId}" />
	</c:if> 
</wcf:url>

<c:set var="orderStatus" value="${pagorder.orderStatus.status}"/>
<c:set var="isOrderScheduled" value="false"/>
<c:if test="${!empty requestScope.isOrderScheduled}">
	<c:set var="isOrderScheduled" value="${requestScope.isOrderScheduled}"/>
</c:if>

<script type="text/javascript">
<%-- Declare the controller to refresh the order item area on page index change for single shipment --%>
dojo.addOnLoad(function(){CommonControllersDeclarationJS.setControllerURL('OrderItemPaginationDisplayController','<c:out value='${currentOrderItemDetailPaging}'/>');});
</script>

<c:if test="${empty subscriptionOrderItemId}">
	<c:if test="${numEntries > pageSize}">
		<fmt:formatNumber var="totalPages" value="${(numEntries/pageSize)}" maxFractionDigits="0"/>		
		<c:if test="${numEntries%pageSize < (pageSize/2)}">
			<fmt:formatNumber var="totalPages" value="${(numEntries+(pageSize/2)-1)/pageSize}" maxFractionDigits="0"/>
		</c:if>
		<fmt:parseNumber var="totalPages" value="${totalPages}" integerOnly="true"/> 
			
		<c:choose>
			<c:when test="${beginIndex + pageSize >= numEntries}">
				<c:set var="endIndex" value="${numEntries}" />
			</c:when>
			<c:otherwise>
				<c:set var="endIndex" value="${beginIndex + pageSize}" />
			</c:otherwise>
		</c:choose>

		<fmt:formatNumber var="currentPage" value="${(beginIndex/pageSize)+1}"/>
		<fmt:parseNumber var="currentPage" value="${currentPage}" integerOnly="true"/>

						
		<div class="shopcart_pagination" id="OrderItemDetailSummaryPagination1">
			<br/><br/>
			<span class="text">
				<fmt:message key="CATEGORY_RESULTS_DISPLAYING"> 
					<fmt:param><fmt:formatNumber value="${beginIndex + 1}"/></fmt:param>
					<fmt:param><fmt:formatNumber value="${endIndex}"/></fmt:param>
					<fmt:param><fmt:formatNumber value="${numEntries}"/></fmt:param>
				</fmt:message>
				<span class="paging">
					<c:if test="${beginIndex != 0}">
						<a id="OrderItemDetailSummaryPg1_1" class="tlignore" href="javaScript:setCurrentId('OrderItemDetailSummaryPg1_1'); if(submitRequest()){ cursor_wait();
						CommonControllersDeclarationJS.setControllerURL('OrderItemPaginationDisplayController','<c:out value='${currentOrderItemDetailPaging}'/>');
						wc.render.updateContext('OrderItemPaginationDisplay_Context',{'beginIndex':'<c:out value='${beginIndex - pageSize}'/>','pageSize':'<c:out value='${pageSize}'/>','externalOrderId':'${WCParam.externalOrderId}','externalQuoteId':'${WCParam.externalQuoteId}','isFromOrderDetailsPage':'<c:out value='${isFromOrderDetailsPage}'/>'});}">
					</c:if>
					<img src="<c:out value="${jspStoreImgDir}${env_vfileColor}${vfileColorBIDI}" />paging_back.png" alt="<fmt:message key="CATEGORY_PAGING_LEFT_IMAGE"/>" />
					<c:if test="${beginIndex != 0}">
						</a>
					</c:if>
					<fmt:message key="CATEGORY_RESULTS_PAGES_DISPLAYING"> 
						<fmt:param><fmt:formatNumber value="${currentPage}"/></fmt:param>
						<fmt:param><fmt:formatNumber value="${totalPages}"/></fmt:param>
					</fmt:message>
					<c:if test="${numEntries > endIndex }">
						<a id="OrderItemDetailSummaryPg1_2" class="tlignore" href="javaScript:setCurrentId('OrderItemDetailSummaryPg1_2'); if(submitRequest()){ cursor_wait();
						CommonControllersDeclarationJS.setControllerURL('OrderItemPaginationDisplayController','<c:out value='${currentOrderItemDetailPaging}'/>');
						wc.render.updateContext('OrderItemPaginationDisplay_Context',{'beginIndex':'<c:out value='${beginIndex + pageSize}'/>','pageSize':'<c:out value='${pageSize}'/>','externalOrderId':'${WCParam.externalOrderId}','externalQuoteId':'${WCParam.externalQuoteId}','isFromOrderDetailsPage':'<c:out value='${isFromOrderDetailsPage}'/>'});}">
					</c:if>
					<img src="<c:out value="${jspStoreImgDir}${env_vfileColor}${vfileColorBIDI}" />paging_next.png" alt="<fmt:message key="CATEGORY_PAGING_RIGHT_IMAGE"/>" />
					<c:if test="${numEntries > endIndex }">
						</a>
					</c:if>
				</span>
			</span>
		</div>
	</c:if> 
</c:if>

 <table id="order_details" cellpadding="0" cellspacing="0" border="0" width="100%" summary="<fmt:message key="SHOPCART_TABLE_CONFIRM_SUMMARY"/>">

	<tr class="nested">
		<th class="align_left" id="SingleShipment_tableCell_productName"><fmt:message key="PRODUCT"/></th>
		<c:set var="th_count" value="1"/>
		<c:if test="${isFromOrderDetailsPage && !(orderStatus eq 'I')}">
			<flow:ifEnabled feature="FutureOrders">
				<th class="align_left" id="SingleShipment_tableCell_requestedShippingDate"><fmt:message key="SHIP_REQUESTED_DATE"/></th>
				<c:set var="th_count" value="${th_count + 1}"/>
			</flow:ifEnabled>
		</c:if>
		<flow:ifEnabled feature="ExpeditedOrders">
			<c:if test="${orderStatus != 'I' && !isOrderScheduled}">
				<%-- Missing message --%>
				<th class="align_left" id="SingleShipment_tableCell_expedite"><fmt:message key="SHIP_EXPEDITE_SHIPPING"/></th>
				<c:set var="th_count" value="${th_count + 1}"/>
			</c:if>
		</flow:ifEnabled>
		
		<c:remove var="isSBSEnabled"/>
		<flow:ifEnabled feature="SideBySideIntegration">
			<c:set var="isSBSEnabled">Y</c:set>
			<c:choose>
		        <c:when test="${orderPage == 'confirmation' && isFromOrderDetailsPage=='true'}">
		            <th class="avail" id="SingleShipment_tableCell_availability"><fmt:message key="MO_SUBSCRIPTION_STATUS"/></th>
		        </c:when>
		        <c:otherwise>
		            <th class="avail" id="SingleShipment_tableCell_availability"><fmt:message key="AVAILABILITY"/></th>
		        </c:otherwise>
		    </c:choose>
		    <c:set var="th_count" value="${th_count + 1}"/>
		</flow:ifEnabled>
		<flow:ifDisabled feature="SideBySideIntegration">
		    <c:set var="isSBSEnabled">N</c:set>
			<th class="avail" id="SingleShipment_tableCell_availability"><fmt:message key="AVAILABILITY"/></th>
			<c:set var="th_count" value="${th_count + 1}"/>
		</flow:ifDisabled>
		<th class="QTY" id="SingleShipment_tableCell_quantity" abbr="<fmt:message key="QUANTITY1"/>"><fmt:message key="QTY"/></th>
		<c:set var="th_count" value="${th_count + 1}"/>
		<th class="each short" id="SingleShipment_tableCell_unitPrice" abbr="<fmt:message key="UNIT_PRICE"/>"><fmt:message key="EACH"/></th>
		<c:set var="th_count" value="${th_count + 1}"/>
		<th class="total short" id="SingleShipment_tableCell_totalPrice" abbr="<fmt:message key="TOTAL_PRICE"/>"><fmt:message key="TOTAL"/></th>
	</tr>
	  
	<c:if test="${!empty pagorder.orderItem}"> 
		<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogEntryType[]" var="catalogEntriesForAttributes" expressionBuilder="getStoreCatalogEntryAttributesByIDs">
			<wcf:contextData name="storeId" data="${WCParam.storeId}"/>
			<c:forEach var="orderItem" items="${pagorder.orderItem}">
				<%@ include file="../../../Snippets/Catalog/CatalogEntryDisplay/ResolveCatalogEntryIDExt.jspf" %>
				<wcf:param name="UniqueID" value="${orderItem.catalogEntryIdentifier.uniqueID}"/>
			</c:forEach>
			<wcf:param name="dataLanguageIds" value="${WCParam.langId}"/>
		</wcf:getData>
		
		<c:if test="${showDynamicKit eq 'true'}">
			<c:set var="orderHasDKComponents" value="false" />
			<c:forEach var="orderItem" items="${pagorder.orderItem}">
				<c:if test="${!empty orderItem.orderItemComponent}">
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
	<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogNavigationViewType" var="allCatEntryInOrder" expressionBuilder="getCatalogEntryViewForShoppingCart">
		<c:forEach var="orderItem0" items="${pagorder.orderItem}">
			<wcf:param name="UniqueID" value="${orderItem0.catalogEntryIdentifier.uniqueID}"/>
		</c:forEach>
		<wcf:contextData name="storeId" data="${WCParam.storeId}" />
		<wcf:contextData name="catalogId" data="${WCParam.catalogId}" />
	</wcf:getData>
	<c:forEach var="aCatEntry" items="${allCatEntryInOrder.catalogEntryView}">
		<c:set property="${aCatEntry.uniqueID}" value="${aCatEntry}" target="${catalogEntryDataBeansInThisOrder}"/>
	</c:forEach>
	
	<c:forEach var="orderItem" items="${pagorder.orderItem}" varStatus="status">
		<c:if test="${empty subscriptionOrderItemId || (!empty subscriptionOrderItemId && subscriptionOrderItemId == orderItem.orderItemIdentifier.uniqueID)}">
			<c:set var="catEntry" value="${catalogEntryDataBeansInThisOrder[orderItem.catalogEntryIdentifier.uniqueID]}"/>
		
		<c:forEach var="metadata" items="${catEntry.metaData}" varStatus="status2">
				<c:if test="${metadata.key == 'ThumbnailPath'}">
					<c:set var="thumbNail" value="${env_imageContextPath}/${metadata.value}" />
				</c:if>			
		</c:forEach>
			
		<!-- use this catalog services to get catalog entry attributes -->
		<!-- get the formatted qty for this item -->
		<fmt:formatNumber	var="quickCartOrderItemQuantity" value="${orderItem.quantity.value}" type="number" maxFractionDigits="0"/>
		<c:forEach var="discounts" items="${orderItem.orderItemAmount.adjustment}">			
			<c:if test="${discounts.displayLevel == 'OrderItem'}">
				<c:set var="nobottom" value="th_align_left_no_bottom"/>
			</c:if>
		</c:forEach>
			
		<tr>
			<th class="th_align_left_normal <c:out value="${nobottom}"/>" id="SingleShipment_rowHeader_product<c:out value='${status.count}'/>" abbr="<fmt:message key="Checkout_ACCE_for"/> ${catEntry.name}">
				<div class="img" id="WC_OrderItemDetailsSummaryf_div_1_<c:out value='${status.count}'/>">
					<c:choose>
						<c:when test="${!empty thumbNail}">
							<c:set var="imgSource" value="${fn:replace(thumbNail, itemThumbnailImage, miniImage)}" />
							<img src="<c:out value='${imgSource}'/>" 
							alt="<c:out value='${catEntry.name}' escapeXml='false'/>" 
							border="0" width="70" height="70"/>							
						</c:when>
						<c:otherwise>
							<img src="<c:out value='${jspStoreImgDir}' />images/NoImageIcon_sm.jpg" 
							alt="<c:out value='${catEntry.name}' escapeXml='false'/>" 
							border="0" width="70" height="70"/>							
						</c:otherwise>
					</c:choose>	
					<c:remove var="thumbNail"/>
				</div>
				<div class="itemspecs" id="WC_OrderItemDetailsSummaryf_div_2_<c:out value='${status.count}'/>">
					<p class="strong_content"><c:out value="${catEntry.name}" escapeXml="false"/></p>
					<span><fmt:message key="CurrentOrder_SKU" /> <c:out value="${catEntry.partNumber}" escapeXml="false"/></span><br />
					<c:if test="${empty subscriptionOrderItemId}">
						<%--
						 ***
						 * Start: Display Defining attributes
						 * Loop through the attribute values and display the defining attributes
						 ***
						--%>
						<c:forEach var="catalogEntry1" items="${catalogEntriesForAttributes}" >
							<c:if test="${catalogEntry1.catalogEntryIdentifier.uniqueID == orderItem.catalogEntryIdentifier.uniqueID}">
								<c:forEach var="attribute" items="${catalogEntry1.catalogEntryAttributes.attributes}">
									<c:set var="displayValue" value="${attribute.value.value}" />
									<c:if test="${ attribute.usage=='Defining' }" >
										<c:if test="${attribute.attributeIdentifier.externalIdentifier.identifier != subsFulfillmentFrequencyAttrName 
													&& attribute.attributeIdentifier.externalIdentifier.identifier != subsPaymentFrequencyAttrName
													&& attribute.attributeIdentifier.externalIdentifier.identifier != subsTimePeriodAttrName}">
											<span class="strongtext"><c:out value="${attribute.name}"  escapeXml="false" /> : </span>
											<c:choose>
												<c:when test="${!empty displayValue}">
													<c:out value="${displayValue}"  escapeXml="false" />		
												</c:when>
												<c:otherwise>
													<fmt:message key="MO_NOT_AVAILABLE"/>
												</c:otherwise>
											</c:choose>
											<br />
										</c:if>
									</c:if>
								</c:forEach>
							</c:if>
						</c:forEach>
						<%--
						 ***
						 * End: Display Defining attributes
						 ***
						--%>
					</c:if>
					
					<c:if test="${showDynamicKit eq 'true' && !empty orderItem.orderItemComponent}">
						<div class="top_margin5px"><fmt:message key="CONFIGURATION"/></div>
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
					</c:if>
					
					<c:if test="${b2bStore}">
						<c:set var="isShoppingCartPage" value="false"/>
						<%@ include file="../../../Snippets/Order/Cart/B2BContractSelectExt.jspf" %>
					</c:if>					
					<br />
					<%@ include file="../../../Snippets/ReusableObjects/OrderGiftItemDisplayExt.jspf" %>
					<%@ include file="../../../Snippets/ReusableObjects/GiftRegistryOrderGiftItemDisplayExt.jspf" %>
				</div>
			</th>
			<c:if test="${isFromOrderDetailsPage && !(orderStatus eq 'I')}">
				<flow:ifEnabled feature="FutureOrders">
					<c:set var="currentItemRequestedShipDate" value="${orderItem.orderItemShippingInfo.requestedShipDate}"/>
					<c:if test='${!empty currentItemRequestedShipDate}'>
						<c:catch>
							<fmt:parseDate parseLocale="${dateLocale}" var="expectedShipDate" value="${currentItemRequestedShipDate}" pattern="yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" timeZone="GMT"/>
						</c:catch>
						<c:if test="${empty expectedShipDate}">
							<c:catch>
								<fmt:parseDate parseLocale="${dateLocale}" var="expectedShipDate" value="${currentItemRequestedShipDate}" pattern="yyyy-MM-dd'T'HH:mm:ss'Z'" timeZone="GMT"/>
							</c:catch>
						</c:if>
						<fmt:formatDate value="${expectedShipDate}" type="date" dateStyle="long" var="formattedDate" timeZone="${fn:replace(cookie.WC_timeoffset.value, '%2B', '+')}"/>
					</c:if>
					<td class="requestedShippingDate <c:out value="${nobottom}"/>" id="WC_OrderItemDetailsSummaryf_td_requestedShippingDate_<c:out value='${status.count}'/>" headers="SingleShipment_tableCell_requestedShippingDate SingleShipment_rowHeader_product<c:out value='${status.count}'/>">
						<c:choose>
							<c:when test="${!empty formattedDate}">
								<span class="text"><c:out value="${formattedDate}"/></span>
							</c:when>
							<c:otherwise>
								<%-- Displays a blank space, because otherwise IE would not display the table border for an empty table cell. --%>
								&nbsp;
							</c:otherwise>
						</c:choose>
					</td>
				</flow:ifEnabled>
			</c:if>
			<flow:ifEnabled feature="ExpeditedOrders">
				<c:if test="${orderStatus != 'I' && !isOrderScheduled}">
					<td class="expedite <c:out value="${nobottom}"/>" id="WC_OrderItemDetailsSummaryf_td_expedite_<c:out value='${status.count}'/>" headers="SingleShipment_tableCell_expedite SingleShipment_rowHeader_product<c:out value='${status.count}'/>">
						<c:choose>
							<c:when test="${orderItem.orderItemShippingInfo.expedite}">
								<fmt:message key="YES"/>
							</c:when>
							<c:otherwise>
								<fmt:message key="NO"/>
							</c:otherwise>
						</c:choose>
					</td>
				</c:if>
			</flow:ifEnabled>
			
			<c:choose>
				<c:when test="${isSBSEnabled == 'Y' && orderPage == 'confirmation' && isFromOrderDetailsPage=='true'}">
					<td class="avail <c:out value="${nobottom}"/>" id="WC_OrderItemDetailsSummaryf_td_1_<c:out value='${status.count}'/>" headers="SingleShipment_tableCell_availability SingleShipment_rowHeader_product<c:out value='${status.count}'/>">
						<c:choose>
							<c:when test="${!empty orderItem.orderItemStatus.status}">
								<c:choose>
									<c:when test="${orderItem.orderItemStatus.status == 'H'}">
										<span><fmt:message key="MO_OrderStatus_M"/></span>
									</c:when>
									<c:otherwise>
										<span><fmt:message key="MO_OrderStatus_${orderItem.orderItemStatus.status}"/></span>
									</c:otherwise>
								</c:choose>
							</c:when>
						 	<c:otherwise>
								<fmt:message key="MO_NOT_AVAILABLE"/>								
							</c:otherwise>
					 	</c:choose>
					</td>
				</c:when>
				<c:otherwise>
					<td class="avail <c:out value="${nobottom}"/>" id="WC_OrderItemDetailsSummaryf_td_1_<c:out value='${status.count}'/>" headers="SingleShipment_tableCell_availability SingleShipment_rowHeader_product<c:out value='${status.count}'/>">
						<%@ include file="../../../Snippets/ReusableObjects/CatalogEntryAvailabilityDisplay.jspf" %>	
					</td>
				</c:otherwise>
			</c:choose>
			<td class="QTY <c:out value="${nobottom}"/>" id="WC_OrderItemDetailsSummaryf_td_2_<c:out value='${status.count}'/>" headers="SingleShipment_tableCell_quantity SingleShipment_rowHeader_product<c:out value='${status.count}'/>">
				<p class="item-quantity">
				<c:choose>
							<c:when test="${!empty quickCartOrderItemQuantity}">
								<c:out value="${quickCartOrderItemQuantity}"/>
							</c:when>
							<c:otherwise>
								<fmt:message key="MO_NOT_AVAILABLE"/>
							</c:otherwise>
					</c:choose>			
					
				</p>
			</td>
			<td class="each <c:out value="${nobottom}"/>" id="WC_OrderItemDetailsSummaryf_td_3_<c:out value='${status.count}'/>" headers="SingleShipment_tableCell_unitPrice SingleShipment_rowHeader_product<c:out value='${status.count}'/>">
				<%-- unit price column of order item details table --%>
				<%-- shows unit price of the order item --%>
				<span class="price">
					
					<c:choose>
							<c:when test="${!empty orderItem.orderItemAmount.unitPrice.price.value}">
								<fmt:formatNumber value="${orderItem.orderItemAmount.unitPrice.price.value}" type="currency" maxFractionDigits="${env_currencyDecimal}" currencySymbol="${env_CurrencySymbolToFormat}"/>
								<c:out value="${CurrencySymbol}"/>
							</c:when>
							<c:otherwise>
								<fmt:message key="MO_NOT_AVAILABLE"/>
							</c:otherwise>
					</c:choose>		

					
				</span>	
			</td>
			<td class="total <c:out value="${nobottom}"/>" id="WC_OrderItemDetailsSummaryf_td_4_<c:out value='${status.count}'/>" headers="SingleShipment_tableCell_totalPrice SingleShipment_rowHeader_product<c:out value='${status.count}'/>">
				<c:choose>
					<c:when test="${orderItem.orderItemAmount.freeGift}">
						<%-- the OrderItem is a freebie --%>
						<span class="details">
							<fmt:message key="Free"/>
						</span>
					</c:when>
					<c:otherwise>
						<span class="price">
							<c:choose>
							<c:when test="${!empty orderItem.orderItemAmount.orderItemPrice.value}">
								<fmt:formatNumber var="totalFormattedProductPrice" value="${orderItem.orderItemAmount.orderItemPrice.value}" type="currency" maxFractionDigits="${env_currencyDecimal}" currencySymbol="${env_CurrencySymbolToFormat}"/>
							<c:out value="${totalFormattedProductPrice}" escapeXml="false" />
							<c:out value="${CurrencySymbol}"/>
							</c:when>
							<c:otherwise>
								<fmt:message key="MO_NOT_AVAILABLE"/>
							</c:otherwise>
					</c:choose>		
							
							
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
						<th colspan="<c:out value='${th_count}'/>" class="th_align_left_dotted_top_solid_bottom" abbr="<fmt:message key="Checkout_ACCE_prod_discount" /> <c:out value='${catEntry.name}'/>" id="SingleShipment_rowHeader_discount<c:out value='${status.count}'/>_<c:out value='${status2.count}'/>">
							<div class="itemspecs" id="WC_OrderItemDetailsSummaryf_div_3_<c:out value='${status.count}'/>_<c:out value='${status2.count}'/>">
								<c:url var="DiscountDetailsDisplayViewURL" value="DiscountDetailsDisplayView">
									<c:param name="code" value="${discounts.code}" />
									<c:param name="langId" value="${langId}" />
									<c:param name="storeId" value="${WCParam.storeId}" />
									<c:param name="catalogId" value="${WCParam.catalogId}" />
								</c:url>	
								<a class="discount hover_underline" href='<c:out value="${DiscountDetailsDisplayViewURL}" />' id="WC_OrderItemDetails_Link_ItemDiscount_1_<c:out value='${status.count}'/>_<c:out value='${status2.count}'/>"
									<img src="<c:out value="${jspStoreImgDir}" />images/empty.gif" alt="<fmt:message key="Checkout_ACCE_prod_discount" /> <c:out value="${fn:replace(catalogEntry.description.name, search, replaceStr)}" escapeXml="false"/>"/>
									<c:out 	value="${discounts.description.value}" escapeXml="false"/>
								</a>
								<br />
							</div>
						</th>
						<td class="th_align_left_dotted_top_solid_bottom total" id="WC_OrderItemDetailsSummaryf_td_5_<c:out value='${status.count}'/>_<c:out value='${status2.count}'/>" headers="SingleShipment_rowHeader_discount<c:out value='${status.count}'/>_<c:out value='${status2.count}'/>">
							<fmt:formatNumber	var="formattedDiscountValue"	value="${aggregatedDiscounts[discounts.code]}" type="currency" maxFractionDigits="${env_currencyDecimal}" currencySymbol="${env_CurrencySymbolToFormat}"/>
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
		</c:if>
	</c:forEach>
	<%-- dont change the name of this hidden input element. This variable is used in CheckoutHelper.js --%>
	<input type="hidden" id = "totalNumberOfItems" name="totalNumberOfItems" value='<c:out value="${totalNumberOfItems}"/>'/>
 </table>

<c:if test="${empty subscriptionOrderItemId}">
	<c:if test="${numEntries > pageSize}">
		<div class="shopcart_pagination" id="OrderItemDetailSummaryPagination2">
			<span class="text">
				<fmt:message key="CATEGORY_RESULTS_DISPLAYING"> 
					<fmt:param><fmt:formatNumber value="${beginIndex + 1}"/></fmt:param>
					<fmt:param><fmt:formatNumber value="${endIndex}"/></fmt:param>
					<fmt:param><fmt:formatNumber value="${numEntries}"/></fmt:param>
				</fmt:message>
				<span class="paging">
					<c:if test="${beginIndex != 0}">
						<a id="OrderItemDetailSummaryPagination2_1" class="tlignore" href="javaScript:setCurrentId('OrderItemDetailSummaryPagination2_1'); if(submitRequest()){ cursor_wait();	
						CommonControllersDeclarationJS.setControllerURL('OrderItemPaginationDisplayController','<c:out value='${currentOrderItemDetailPaging}'/>');
						wc.render.updateContext('OrderItemPaginationDisplay_Context',{'beginIndex':'<c:out value='${beginIndex - pageSize}'/>','pageSize':'<c:out value='${pageSize}'/>','externalOrderId':'${WCParam.externalOrderId}','externalQuoteId':'${WCParam.externalQuoteId}','isFromOrderDetailsPage':'<c:out value='${isFromOrderDetailsPage}'/>'});}">
					</c:if>
					<img src="<c:out value="${jspStoreImgDir}${env_vfileColor}${vfileColorBIDI}" />paging_back.png" alt="<fmt:message key="CATEGORY_PAGING_LEFT_IMAGE"/>"/>
					<c:if test="${beginIndex != 0}">
						</a>
					</c:if>
					<fmt:message key="CATEGORY_RESULTS_PAGES_DISPLAYING"> 
						<fmt:param><fmt:formatNumber value="${currentPage}"/></fmt:param>
						<fmt:param><fmt:formatNumber value="${totalPages}"/></fmt:param>
					</fmt:message>
					<c:if test="${numEntries > endIndex }">
						<a id="OrderItemDetailSummaryPagination2_2" class="tlignore" href="javaScript:setCurrentId('OrderItemDetailSummaryPagination2_2'); if(submitRequest()){ cursor_wait();	
						CommonControllersDeclarationJS.setControllerURL('OrderItemPaginationDisplayController','<c:out value='${currentOrderItemDetailPaging}'/>');
						wc.render.updateContext('OrderItemPaginationDisplay_Context',{'beginIndex':'<c:out value='${beginIndex + pageSize}'/>','pageSize':'<c:out value='${pageSize}'/>','externalOrderId':'${WCParam.externalOrderId}','externalQuoteId':'${WCParam.externalQuoteId}','isFromOrderDetailsPage':'<c:out value='${isFromOrderDetailsPage}'/>'});}">
					</c:if>
					<img src="<c:out value="${jspStoreImgDir}${env_vfileColor}${vfileColorBIDI}" />paging_next.png" alt="<fmt:message key="CATEGORY_PAGING_RIGHT_IMAGE"/>"/>
					<c:if test="${numEntries > endIndex }">
						</a>
					</c:if>
				</span>
			</span>
		</div>
	</c:if> 
</c:if>
<!-- END OrderItemDetailSummary.jsp -->
