<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2009, 2012 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%--
  *****
  * This JSP page displays order status details in the My Account section. It is imported in OrderStatusTableDisplay.jsp.
  *****
--%>

<!-- BEGIN OrderStatusTableDetailsDisplay.jsp -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>    
<%@ include file="../../../Common/EnvironmentSetup.jspf" %>

<c:set var="beginIndex" value="${WCParam.beginIndex}" />
<c:if test="${empty beginIndex}">
	<c:set var="beginIndex" value="0" />
</c:if>
<c:set var="pageSize" value="${WCParam.pageSize}" />
<c:if test="${empty pageSize}">
<c:set var="pageSize" value="${maxOrderItemsPerPage}"/>
</c:if>

<flow:ifEnabled feature="SideBySideIntegration">
	<c:set var="lastExternalOrderIds" value="${WCParam.lastExternalOrderIds}" />
	 <c:if test="${empty lastExternalOrderIds}">
	  <c:set var="lastExternalOrderIds" value="" />
	</c:if>
	<!-- used to check the order total change in external system -->
	<c:set var="recordSetTotal" value="${WCParam.recordSetTotal}" />
	 <c:if test="${empty recordSetTotal}">
	  <c:set var="recordSetTotal" value="0" />
	</c:if>
</flow:ifEnabled>

<c:set var="isProcessedOrdersTab" value="${param.selectedTab == 'PreviouslyProcessed' || WCParam.selectedTab == 'PreviouslyProcessed'}"/>
<c:set var="isWaitingForApprovalOrdersTab" value="${param.selectedTab == 'WaitingForApproval' || WCParam.selectedTab == 'WaitingForApproval'}"/>
<c:set var="isScheduledOrdersTab" value="${param.selectedTab == 'Scheduled' || WCParam.selectedTab == 'Scheduled'}"/>
<c:set var="contextId" value=""/>

<jsp:useBean id="now" class="java.util.Date" scope="page"/>

<c:set var="formattedTimeZone" value="${fn:replace(cookie.WC_timeoffset.value, '%2B', '+')}"/>
<c:set var="formattedTimeZone" value="${fn:replace(formattedTimeZone, '.75', ':45')}"/>	
<c:set var="formattedTimeZone" value="${fn:replace(formattedTimeZone, '.5', ':30')}"/>

<c:choose>
	<c:when test="${isProcessedOrdersTab}">
		<c:set var="max" value="3"/>
		<c:set var="start" value="0"/>
		
		<c:if test="${param.isMyAccountMainPage == null || param.isMyAccountMainPage == false}">
			<c:set var="max" value="${pageSize}"/>
			<c:set var="start" value="${beginIndex}"/>
			<c:set var="contextId" value="ProcessedOrdersStatusDisplay_Context"/>
		</c:if>
		
		<c:choose>
			<c:when test="${param.isQuote eq true}">
				<wcf:getData type="com.ibm.commerce.order.facade.datatypes.QuoteType[]" var="allOrdersInThisCategory" varShowVerb="ShowVerbAllOrdersInThisCategory" expressionBuilder="findQuotesByStatus" maxItems="${max}" recordSetStartNumber="${start}" recordSetReferenceId="orderstatus">
					<wcf:param name="status" value="N,M,A,B,C,R,S,D,F,G" />
				</wcf:getData>
			</c:when>
			<c:otherwise>
				<flow:ifEnabled feature="SideBySideIntegration">			
				    <c:forTokens var="splitStr" items="${lastExternalOrderIds}" delims=";" varStatus="status">
				      <c:if test="${status.last}">
				        <c:set var="extOrderId" value="${splitStr}" />				        
				      </c:if>				      
				    </c:forTokens>
				    
							   
					<wcf:getData type="com.ibm.commerce.order.facade.datatypes.OrderType[]" var="allOrdersInThisCategory" varShowVerb="ShowVerbAllOrdersInThisCategory" expressionBuilder="findByOrderStatusExt" maxItems="${max}" recordSetStartNumber="${start}" recordSetReferenceId="orderstatus">
						<wcf:param name="status" value="N,M,A,B,C,R,S,D,F,H" />
						<wcf:param name="extOrderId" value="${extOrderId}"  />	
						<wcf:param name="recordSetTotal" value="${recordSetTotal}"  />						
						<wcf:param name="accessProfile" value="IBM_Summary" />
					</wcf:getData>
				</flow:ifEnabled>
				<flow:ifDisabled feature="SideBySideIntegration">
					<wcf:getData type="com.ibm.commerce.order.facade.datatypes.OrderType[]" var="allOrdersInThisCategory" varShowVerb="ShowVerbAllOrdersInThisCategory" expressionBuilder="findByOrderStatus" maxItems="${max}" recordSetStartNumber="${start}" recordSetReferenceId="orderstatus">
						<wcf:param name="status" value="N,M,A,B,C,R,S,D,F,G" />
						<wcf:param name="accessProfile" value="IBM_Summary" />
					</wcf:getData>
				</flow:ifDisabled>
			</c:otherwise>
		</c:choose>
	</c:when>
	<c:when test="${isWaitingForApprovalOrdersTab}">
		<c:choose>
			<c:when test="${param.isQuote eq true}">
				<wcf:getData type="com.ibm.commerce.order.facade.datatypes.QuoteType[]" var="allOrdersInThisCategory" varShowVerb="ShowVerbAllOrdersInThisCategory" expressionBuilder="findQuotesByStatus" maxItems="${pageSize}" recordSetStartNumber="${beginIndex}" recordSetReferenceId="orderstatus">
					<wcf:param name="status" value="W" />
				</wcf:getData>
			</c:when>
			<c:otherwise>
				<wcf:getData type="com.ibm.commerce.order.facade.datatypes.OrderType[]" var="allOrdersInThisCategory" varShowVerb="ShowVerbAllOrdersInThisCategory" expressionBuilder="findByOrderStatus" maxItems="${pageSize}" recordSetStartNumber="${beginIndex}" recordSetReferenceId="orderstatus">
					<wcf:param name="status" value="W" />
					<wcf:param name="accessProfile" value="IBM_Summary" />
				</wcf:getData>
			</c:otherwise>
		</c:choose>
		<c:set var="contextId" value="WaitingForApprovalOrdersStatusDisplay_Context"/>
	</c:when>
	<c:when test="${isScheduledOrdersTab}">
		<flow:ifEnabled feature="ScheduleOrder">
			<wcf:getData type="com.ibm.commerce.order.facade.datatypes.OrderType[]" var="allOrdersInThisCategory" varShowVerb="ShowVerbAllOrdersInThisCategory" expressionBuilder="findScheduledOrder" maxItems="${pageSize}" recordSetStartNumber="${beginIndex}" recordSetReferenceId="orderstatus">
					<wcf:param name="storeId" value="${WCParam.storeId}" />
					<wcf:param name="memberId" value="${CommandContext.userId}" />
					<wcf:param name="startTime" value="" />
				</wcf:getData>
			<c:if test="${empty allOrdersInThisCategory && beginIndex >= pageSize}">
				<c:set var="beginIndex" value="${beginIndex - pageSize}"/>
				<wcf:getData type="com.ibm.commerce.order.facade.datatypes.OrderType[]" var="allOrdersInThisCategory" varShowVerb="ShowVerbAllOrdersInThisCategory" expressionBuilder="findScheduledOrder" maxItems="${pageSize}" recordSetStartNumber="${beginIndex}" recordSetReferenceId="orderstatus">
					<wcf:param name="storeId" value="${WCParam.storeId}" />
					<wcf:param name="memberId" value="${CommandContext.userId}" />
					<wcf:param name="startTime" value="" />
				</wcf:getData>
			</c:if>
			<c:set var="contextId" value="ScheduledOrdersStatusDisplay_Context"/>
		</flow:ifEnabled>
	</c:when>
</c:choose>

<c:if test="${(param.isMyAccountMainPage == null) || (empty param.isMyAccountMainPage) || (param.isMyAccountMainPage == false)}">
	<c:if test="${beginIndex == 0}">
		<c:if test="${ShowVerbAllOrdersInThisCategory.recordSetTotal > ShowVerbAllOrdersInThisCategory.recordSetCount}">		
			<c:set var="pageSize" value="${ShowVerbAllOrdersInThisCategory.recordSetCount}" />
		</c:if>
	</c:if>	
	<c:set var="numEntries" value="${ShowVerbAllOrdersInThisCategory.recordSetTotal}"/>
	<c:if test="${numEntries > pageSize}">
		<fmt:formatNumber var="totalPages" value="${(numEntries/pageSize)}" maxFractionDigits="0"/>		
		<fmt:formatNumber var="halfPageSize" value="${(pageSize/2)}" maxFractionDigits="0"/>
		<c:if test="${numEntries%pageSize < halfPageSize}">
			<fmt:formatNumber var="totalPages" value="${(numEntries+halfPageSize-1)/pageSize}" maxFractionDigits="0"/>
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
	
		<div id="OrderStatusDetailPagination">
			<span id="OrderStatusDetailPagination_span_1" class="text">
				<fmt:message key="MO_Page_Results" > 
					<fmt:param><fmt:formatNumber value="${beginIndex + 1}"/></fmt:param>
					<fmt:param><fmt:formatNumber value="${endIndex}"/></fmt:param>
					<fmt:param><fmt:formatNumber value="${numEntries}"/></fmt:param>
				</fmt:message>
				<span id="OrderStatusDetailPagination_span_2" class="paging">
					<flow:ifEnabled feature="SideBySideIntegration">
			    		<c:set var="actualPageSize" value="${ShowVerbAllOrdersInThisCategory.recordSetCount}"/>
						<c:forEach var="orderIter" items="${allOrdersInThisCategory}" varStatus="status" begin="${actualPageSize-1}">
							<c:set var="lastOrder" value="${orderIter}"/>				  		
						</c:forEach>
					</flow:ifEnabled>
					<c:if test="${beginIndex != 0}">	
						<flow:ifEnabled feature="SideBySideIntegration">
							<a id="OrderStatusDetailPagination_link_1" href="javaScript:setCurrentId('OrderStatusDetailPagination_link_1'); if(submitRequest()){cursor_wait();
							MyAccountDisplay.updateRenderContextForPagination('${contextId}', '${beginIndex}', '${pageSize}', '${param.isQuote}', '${currentPage}', '', '${lastExternalOrderIds}', '', '${numEntries}');}">
					    </flow:ifEnabled>
					    <flow:ifDisabled feature="SideBySideIntegration">
							<a id="OrderStatusDetailPagination_link_1" href="javaScript:setCurrentId('OrderStatusDetailPagination_link_1'); if(submitRequest()){cursor_wait();
							wc.render.updateContext('${contextId}',{'beginIndex':'<c:out value='${beginIndex - pageSize}'/>','pageSize':'<c:out value='${pageSize}'/>','isQuote':'${param.isQuote}'});}">
						</flow:ifDisabled>
					</c:if>
					<img src="<c:out value="${jspStoreImgDir}${env_vfileColor}${vfileColorBIDI}" />paging_back.png" alt="<fmt:message key="CATEGORY_PAGING_LEFT_IMAGE" />" />
					<c:if test="${beginIndex != 0}">
						</a>
					</c:if>
					<fmt:message key="CATEGORY_RESULTS_PAGES_DISPLAYING" > 
						<fmt:param><fmt:formatNumber value="${currentPage}"/></fmt:param>
						<fmt:param><fmt:formatNumber value="${totalPages}"/></fmt:param>
					</fmt:message>
					<c:if test="${numEntries > endIndex }">
						<flow:ifEnabled feature="SideBySideIntegration">
							<a id="OrderStatusDetailPagination_link_2" href="javaScript:setCurrentId('OrderStatusDetailPagination_link_2'); if(submitRequest()){cursor_wait();
							MyAccountDisplay.updateRenderContextForPagination('${contextId}', '${beginIndex}', '${pageSize}', '${param.isQuote}', '${currentPage}', '${lastOrder.orderIdentifier.externalOrderID}', '${lastExternalOrderIds}', '1', '${numEntries}');}">
						</flow:ifEnabled>
						<flow:ifDisabled feature="SideBySideIntegration">
							<a id="OrderStatusDetailPagination_link_2" href="javaScript:setCurrentId('OrderStatusDetailPagination_link_2'); if(submitRequest()){cursor_wait();
							wc.render.updateContext('${contextId}',{'beginIndex':'<c:out value='${beginIndex + pageSize}'/>','pageSize':'<c:out value='${pageSize}'/>','isQuote':'${param.isQuote}'});}">
						</flow:ifDisabled>
					</c:if>
					<img src="<c:out value="${jspStoreImgDir}${env_vfileColor}${vfileColorBIDI}" />paging_next.png" alt="<fmt:message key="CATEGORY_PAGING_RIGHT_IMAGE" />" />
					<c:if test="${numEntries > endIndex }">
						</a>
					</c:if>
				</span>
			</span>
		</div>
	</c:if>
</c:if>

<c:choose>
	<c:when test="${ShowVerbAllOrdersInThisCategory.recordSetTotal <= 0}">
		<c:choose>
			<c:when test="${param.isQuote eq true}">
				<div role="row"><div role="gridcell"><fmt:message key="MO_NOQUOTESFOUND"/></div></div>
			</c:when>
			<c:otherwise>
				<div role="row"><div role="gridcell"><fmt:message key="MO_NOORDERSFOUND" /></div></div>
			</c:otherwise>
		</c:choose>
	</c:when>
	<c:otherwise>
		
		<%-- 
			The variable columnStyle is used to set the CSS class for a table column depending on the type of the order. 
			Its default value is 1, which corresponds to orders that have already been processed. 
		--%>
		<c:set var="columnStyle" value="1"/>
		<c:if test="${isWaitingForApprovalOrdersTab}">
			<c:set var="columnStyle" value="2"/>
		</c:if>
		<c:if test="${isScheduledOrdersTab}">
			<c:set var="columnStyle" value="3"/>
		</c:if>
		
		<div role="row" id="OrderStatusDetailsDisplayExt_ul_1" class="ul column_heading">
			<div role="columnheader" id="OrderStatusDetailsDisplayExt_li_header_1" class="li order_number_column_<c:out value="${columnStyle}"/>">
			<c:choose>
				<c:when test="${param.isQuote eq true}">
					<fmt:message key="MO_QUOTENUMBER" />
				</c:when>
				<c:otherwise>
						<c:set var="messageKey" value="MA_ORDERNUM"/>
						<c:if test="${isScheduledOrdersTab}">
							<c:set var="messageKey" value="MO_SCHEDULED_ORDER_NUMBER"/>
						</c:if>
						<fmt:message key="${messageKey}" />
				</c:otherwise>
			</c:choose>
			</div>
			<c:if test="${isProcessedOrdersTab}">
				<div role="columnheader" id="OrderStatusDetailsDisplayExt_li_header_2" class="li order_date_column_<c:out value="${columnStyle}"/>">
				<c:choose>
					<c:when test="${param.isQuote eq true}">
						<fmt:message key="MO_QUOTEDATE" />
					</c:when>
					<c:otherwise>
						<fmt:message key="MA_ORDER_DATE" />
					</c:otherwise>
				</c:choose>
				</div>
			</c:if>
			<c:if test="${isWaitingForApprovalOrdersTab}"><div role="columnheader" id="OrdersStatusDetailsDisplayExt_li_header_3" class="li last_updated_column_<c:out value="${columnStyle}"/>"><fmt:message key="MO_LAST_UPDATED" /></div></c:if>
			<c:if test="${showPONumber && !isScheduledOrdersTab}"><div role="columnheader" id="OrderStatusDetailsDisplayExt_li_header_4" class="li purchase_order_column_<c:out value="${columnStyle}"/>"><fmt:message key="MO_PURCHASEORDER" /></div></c:if>
			<c:if test="${isProcessedOrdersTab}"><div role="columnheader" id="OrderStatusDetailsDisplayExt_li_header_5" class="li status_column_<c:out value="${columnStyle}"/>"><fmt:message key="MO_SUBSCRIPTION_STATUS" /></div></c:if>
			<c:if test="${isScheduledOrdersTab}"><flow:ifEnabled feature="ScheduleOrder"><div role="columnheader" id="OrderStatusDetailsDisplayExt_li_header_6" class="li next_order_date_column_<c:out value="${columnStyle}"/>"><fmt:message key="MO_NEXT_ORDER" /></div></flow:ifEnabled></c:if>
			<div role="columnheader" id="OrderStatusDetailsDisplayExt_li_header_7" class="li total_price_column_<c:out value="${columnStyle}"/>"><fmt:message key="TOTAL_PRICE" /></div>
			<c:if test="${!isWaitingForApprovalOrdersTab}"><div role="columnheader" id="OrderStatusDetailsDisplayExt_li_header_8" class="li option_<c:out value="${columnStyle}"/>"><span class="spanacce"><fmt:message key="MO_ACCE_BUTTON_COLUMN" /></span></div></c:if>
			<div id="OrderStatusDetailsDisplayExt_li_header_9" class="li clear_float"></div>
		</div>
		
		<c:forEach var="order" items="${allOrdersInThisCategory}" varStatus="status">
			<c:choose>
				<c:when test="${param.isQuote eq true}">
					<c:set var="quote" value="${order}"/>
					<c:set var="order" value="${quote.orderTemplate}"/>
					<c:choose>
						<c:when test="${quote.quoteIdentifier.externalQuoteID != null}">
							<c:set var="objectId" value="${quote.quoteIdentifier.externalQuoteID}"/>
							<c:set var="objectIdParam" value="externalQuoteId"/>
						</c:when>
						<c:otherwise>
							<c:set var="objectId" value="${quote.quoteIdentifier.uniqueID}"/>
							<c:set var="objectIdParam" value="quoteId"/>
						</c:otherwise>
					</c:choose>
				</c:when>
				<c:otherwise>
					<c:choose>
						<c:when test="${!empty order.orderIdentifier.externalOrderID}">
							<c:set var="objectId" value="${order.orderIdentifier.externalOrderID}"/>
							<c:set var="objectIdParam" value="externalOrderId"/>
						</c:when>
						<c:otherwise>
							<c:set var="objectId" value="${order.orderIdentifier.uniqueID}"/>
							<c:set var="objectIdParam" value="orderId"/>
						</c:otherwise>
					</c:choose>
				</c:otherwise>
			</c:choose>
			
			<%-- Need to reset currencyFormatterDB as initialized in JSTLEnvironmentSetup.jspf, as the currency code used there is from commandContext. For order history we want to display with currency used when the order was placed. --%>
			<c:choose>
				<c:when test ="${order.orderAmount.grandTotal != null}">
					<c:remove var="currencyFormatterDB"/>
					<wcbase:useBean id="currencyFormatterDB" classname="com.ibm.commerce.common.beans.StoreCurrencyFormatDescriptionDataBean" scope="request" >
						<c:set property="storeId" value="${storeId}" target="${currencyFormatterDB}" />
						<c:set property="langId" value="${langId}" target="${currencyFormatterDB}" />
						<c:set property="currencyCode" value="${order.orderAmount.grandTotal.currency}" target="${currencyFormatterDB}" />
						<c:set property="numberUsage" value="-1" target="${currencyFormatterDB}" />
					</wcbase:useBean>
					<c:set var="currencyDecimal" value="${currencyFormatterDB.decimalPlaces}"/>
					
					<c:if test="${order.orderAmount.grandTotal.currency == 'KRW'}">
						<c:set property="currencySymbol" value="&#8361;" target="${currencyFormatterDB}"/>
					</c:if>
					<c:if test="${order.orderAmount.grandTotal.currency == 'PLN'}">
						<c:set property="currencySymbol" value="z&#322;" target="${currencyFormatterDB}"/>
					</c:if>
					
					<%-- These variables are used to hold the currency symbol --%>
					<c:choose>
						<c:when test="${order.orderAmount.grandTotal.currency == 'ar_EG' && order.orderAmount.grandTotal.currency == 'EGP'}">
							<c:set var="CurrencySymbolToFormat" value=""/>
							<c:set var="CurrencySymbol" value="${currencyFormatterDB.currencySymbol}"/>
						</c:when>
						<c:otherwise>
							<c:set var="CurrencySymbolToFormat" value="${currencyFormatterDB.currencySymbol}"/>
							<c:set var="CurrencySymbol" value=""/>
						</c:otherwise>
					</c:choose>
				</c:when>
			</c:choose>

			<fmt:message key="X_DETAILS"  var="OrderDetailBreadcrumbLinkLabel"> 
				<fmt:param>
				    <flow:ifEnabled feature="SideBySideIntegration">
					   <c:out value="${order.orderIdentifier.uniqueID}"/>			
				    </flow:ifEnabled>
				    <flow:ifDisabled feature="SideBySideIntegration">
					    <c:out value="${objectId}"/>	
				    </flow:ifDisabled>
				</fmt:param>
			</fmt:message>
			
			<div role="row" id="OrderStatusDetailsDisplayExt_ul_2_${status.count}" class="ul row">
					<wcf:url value="OrderDetail" var="OrderDetailUrl1">
						<wcf:param name="${objectIdParam}" value="${objectId}"/>
						<wcf:param name="orderStatusCode" value="${order.orderStatus.status}"/>
						<wcf:param name="storeId" value="${WCParam.storeId}"/>
						<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
						<wcf:param name="langId" value="${WCParam.langId}"/>
						<c:if test="${param.isQuote eq true}">
							<wcf:param name="isQuote" value="true"/>
						</c:if>
					</wcf:url>
				
				<div role="gridcell" id="OrderStatusDetailsDisplayExt_order_number_<c:out value='${status.count}'/>" class="hover_underline li order_number_column_<c:out value="${columnStyle}"/>">
					<span>
					<c:choose>
							<c:when test="${!empty objectId}">
							    <flow:ifEnabled feature="SideBySideIntegration">
							        <c:out value="${order.orderIdentifier.uniqueID}"/>			
							    </flow:ifEnabled>
							    <flow:ifDisabled feature="SideBySideIntegration">
							        <c:out value="${objectId}"/>	
							    </flow:ifDisabled>
							</c:when>
							<c:otherwise>
								<fmt:message key="MO_NOT_AVAILABLE" />	
							</c:otherwise>
					</c:choose>					
					</span>
					<br/>
					<a href="<c:out value='${OrderDetailUrl1}'/>" class="myaccount_link" id="WC_OrderStatusDisplay_Link_2b_<c:out value='${status.count}'/>"><fmt:message key="DETAILS" /></a>
				</div>
				<c:if test="${isProcessedOrdersTab}">					
					<div role="gridcell" id="OrderStatusDetailsDisplayExt_order_date_<c:out value='${status.count}'/>" class="li order_date_column_<c:out value="${columnStyle}"/>">
						<c:remove var="orderDate"/>
						<c:catch>
							<fmt:parseDate parseLocale="${dateLocale}" var="orderDate" value="${order.placedDate}" pattern="yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" timeZone="GMT"/>
						</c:catch>
						<c:if test="${empty orderDate}">
							<c:catch>
								<fmt:parseDate parseLocale="${dateLocale}" var="orderDate" value="${order.placedDate}" pattern="yyyy-MM-dd'T'HH:mm:ss'Z'" timeZone="GMT"/>
							</c:catch>
						</c:if>
						<span>
						<c:choose>
							<c:when test="${!empty orderDate}">
								<fmt:formatDate value="${orderDate}" dateStyle="long" timeZone="${formattedTimeZone}"/>				
							</c:when>
							<c:otherwise>
								<fmt:message key="MO_NOT_AVAILABLE" />
							</c:otherwise>
						</c:choose>
										
						</span>
					</div>
				</c:if>
				<c:if test="${isWaitingForApprovalOrdersTab}">
					<div role="gridcell" id="OrderStatusDetailsDisplayExt_last_updated_<c:out value='${status.count}'/>" class="li last_updated_column_<c:out value="${columnStyle}"/>">
						<c:catch>
							<fmt:parseDate parseLocale="${dateLocale}" var="lastUpdateDate" value="${order.lastUpdateDate}" pattern="yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" timeZone="GMT"/>
						</c:catch>
						<c:if test="${empty lastUpdateDate}">
							<c:catch>
								<fmt:parseDate parseLocale="${dateLocale}" var="lastUpdateDate" value="${order.lastUpdateDate}" pattern="yyyy-MM-dd'T'HH:mm:ss'Z'" timeZone="GMT"/>
							</c:catch>
						</c:if>
						<span><fmt:formatDate value="${lastUpdateDate}" dateStyle="long" timeZone="${formattedTimeZone}"/></span>
					</div>
				</c:if>
				<c:if test="${showPONumber && !isScheduledOrdersTab}">
					<div role="gridcell" id="OrderStatusDetailsDisplayExt_purchase_order_<c:out value='${status.count}'/>" class="li purchase_order_column_<c:out value="${columnStyle}"/>">
						<c:set var="purchaseOrderNumber" value="${order.buyerPONumber}"/>
						<span id="WC_OrderStatusDisplay_TableCell_34a_<c:out value='${status.count}'/>">
							<c:choose>
								<c:when test="${empty purchaseOrderNumber}">
									<fmt:message key="MO_NONE" />
								</c:when>
								<c:otherwise>
									<c:remove var="purchaseOrderBean"/>
									<wcbase:useBean id="purchaseOrderBean" classname="com.ibm.commerce.payment.beans.BuyerPurchaseOrderDataBean">
										<c:set target="${purchaseOrderBean}" property="dataBeanKeyBuyerPurchaseOrderId" value="${purchaseOrderNumber}"/>
									</wcbase:useBean>
									<c:choose>
										<c:when test="${empty purchaseOrderBean.purchaseOrderNumber}">
											<fmt:message key="MO_NONE" />
										</c:when>
										<c:otherwise>
											<c:out value='${purchaseOrderBean.purchaseOrderNumber}'/>
										</c:otherwise>
									</c:choose>
								</c:otherwise>
							</c:choose>
						</span>
					</div>
				</c:if>
				<c:if test="${isProcessedOrdersTab}">
					<div role="gridcell" id="OrderStatusDetailsDisplayExt_status_<c:out value='${status.count}'/>" class="li status_column_<c:out value="${columnStyle}"/>">
						<flow:ifEnabled feature="SideBySideIntegration">
					    	<c:choose>
					    		<c:when test="${!empty order.orderStatus.status}">
					    			<c:set var="ordStatus" value="${order.orderStatus.status }"/>
					    			<c:if test="${order.orderStatus.status eq 'H' }">
					    				<c:set var="ordStatus" value="M"/>
					    			</c:if>
									<span><fmt:message key="MO_OrderStatus_${ordStatus}"/></span>
								</c:when>
								<c:otherwise>
									<fmt:message key="MO_NOT_AVAILABLE" />								
								</c:otherwise>
					    	</c:choose>
						</flow:ifEnabled>
						<flow:ifDisabled feature="SideBySideIntegration">
							<c:choose>
								<c:when test="${!empty order.orderStatus.status}">
										<span><fmt:message key="MO_OrderStatus_${order.orderStatus.status}" /></span>
								</c:when>
								<c:otherwise>
									<fmt:message key="MO_NOT_AVAILABLE" />								
								</c:otherwise>
							</c:choose>
						</flow:ifDisabled>
					</div>
				</c:if>
				<c:if test="${isScheduledOrdersTab}">
					<flow:ifEnabled feature="ScheduleOrder">
						<div role="gridcell" id="OrderStatusDetailsDisplayExt_next_order_date_<c:out value='${status.count}'/>" class="li next_order_date_column_<c:out value="${columnStyle}"/>">
							<fmt:parseNumber var="interval" value="${order.orderScheduleInfo.interval}" integerOnly="true"/>
							<c:catch>
								<fmt:parseDate parseLocale="${dateLocale}" var="startTime" value="${order.orderScheduleInfo.startTime}" pattern="yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" timeZone="GMT"/>
							</c:catch>
							<c:if test="${empty startTime}">
								<c:catch>
									<fmt:parseDate parseLocale="${dateLocale}" var="startTime" value="${order.orderScheduleInfo.startTime}" pattern="yyyy-MM-dd'T'HH:mm:ss'Z'" timeZone="GMT"/>
								</c:catch>
							</c:if>
							<c:choose>
								<c:when test="${startTime >= now}">
									<fmt:formatDate var="formattedNextOrderDate" value="${startTime}" dateStyle="long" timeZone="${formattedTimeZone}"/>
									<span><c:out value="${formattedNextOrderDate}"/></span>
								</c:when>
								<c:otherwise>
									<c:choose>
										<c:when test="${interval == null || empty (fn:trim(interval)) || interval == 0}">
											<span><fmt:message key="MO_NOT_APPLICABLE" /></span>
										</c:when>
										<c:otherwise>
											<c:set var="nextOrderDate" value="${now}"/>
											
											<%-- The variable stores the difference in seconds between now and the scheduled order start time. The original unit is in milliseconds. --%>
											<fmt:parseNumber var="timeDifference" value="${(now.time - startTime.time)/1000}" integerOnly="true"/>
											
											<fmt:parseNumber var="secondsUntilNextOrder" value="${interval - (timeDifference % interval)}" integerOnly="true"/>
											<fmt:parseNumber var="daysUntilNextOrder" value="${secondsUntilNextOrder / 86400}" integerOnly="true" parseLocale="en_US"/>
											
											<%-- If daysUntilNextOrder == 0, then it means that the next order is tomorrow. --%>
											<c:if test="${daysUntilNextOrder == 0}">
												<c:set var="daysUntilNextOrder" value="${daysUntilNextOrder + 1}"/>
											</c:if>
											
											<fmt:parseNumber var="now_year" value="${now.year + 1900}" integerOnly="true"/>
											<fmt:parseNumber var="now_month" value="${now.month + 1}" integerOnly="true"/>
											<fmt:parseNumber var="now_date" value="${now.date}" integerOnly="true"/>
											
											<c:set var="incrementMonth" value="false"/>
											<c:set var="daysInThisMonth" value="31"/>
											<c:set var="newDate" value="${now_date + daysUntilNextOrder}"/>
											
											<c:if test="${now_month == 4 || now_month == 6 || now_month == 9 || now_month == 11}">
												<c:set var="daysInThisMonth" value="30"/>
											</c:if>
											<c:if test="${now_month == 2}">
												<c:set var="daysInThisMonth" value="28"/>
												<c:if test="${((now_year % 4) == 0 && (now_year % 100) != 0) || (now_year % 400) == 0}">
													<c:set var="daysInThisMonth" value="29"/>
												</c:if>
											</c:if>
											
											<c:if test="${newDate > daysInThisMonth}">
												<c:set var="newDate" value="${newDate - daysInThisMonth}"/>
												<c:set var="incrementMonth" value="true"/>
											</c:if>
											
											<c:set var="nextOrderDate_year" value="${now_year}"/>
											<c:set var="nextOrderDate_month" value="${now_month}"/>
											<c:set var="nextOrderDate_date" value="${newDate}"/>
											<c:if test="${incrementMonth}">
												<c:set var="nextOrderDate_month" value="${now_month + 1}"/>
												<c:if test="${nextOrderDate_month > 12}">
													<c:set var="nextOrderDate_month" value="${nextOrderDate_month - 12}"/>
													<c:set var="nextOrderDate_year" value="${now_year + 1}"/>
												</c:if>
											</c:if>
											<fmt:parseDate parseLocale="${dateLocale}" var="nextOrderDate" value="${nextOrderDate_year}-${nextOrderDate_month}-${nextOrderDate_date}" pattern="yyyy-MM-dd" timeZone="${formattedTimeZone}"/>
											<fmt:formatDate var="formattedNextOrderDate" value="${nextOrderDate}" dateStyle="long" timeZone="${formattedTimeZone}"/>
											<span><c:out value="${formattedNextOrderDate}"/></span>
										</c:otherwise>
									</c:choose>
								</c:otherwise>
							</c:choose>
						</div>
					</flow:ifEnabled>
				</c:if>
				<div role="gridcell" id="OrderStatusDetailsDisplayExt_grand_total_<c:out value='${status.count}'/>" class="li total_price_column_<c:out value="${columnStyle}"/>">
					
					<span class="price">
					<c:choose>
					    <c:when test="${order.orderAmount.grandTotal != null}">
							<c:choose>
								<c:when test="${!empty order.orderAmount.grandTotal.value}">
									<fmt:formatNumber value="${order.orderAmount.grandTotal.value}" type="currency" maxFractionDigits="${currencyDecimal}" currencySymbol="${CurrencySymbolToFormat}"/>
									<c:out value="${CurrencySymbol}"/>
								</c:when>
								<c:otherwise>
									<fmt:message key="MO_NOT_AVAILABLE" />					
								</c:otherwise>
							</c:choose>
						</c:when>
						<c:otherwise>
							<fmt:message key="MO_NOT_AVAILABLE" />					
						</c:otherwise>
					</c:choose>
					</span>
				</div>
				<div role="gridcell" id="OrderStatusDetailsDisplayExt_option_<c:out value='${status.count}'/>" class="li option_<c:out value="${columnStyle}"/>">
					<c:choose>
						<c:when test="${isProcessedOrdersTab}">
							
								<flow:ifEnabled feature="AllowReOrder">
									<c:if test="${param.isQuote != true}">
										<wcf:url value="AjaxOrderCopy" var="OrderCopyUrl" type="Ajax">
											<wcf:param name="fromOrderId_1" value="${objectId}"/>
											<wcf:param name="toOrderId" value=".**."/>
											<wcf:param name="copyOrderItemId_1" value="*"/>
											<wcf:param name="URL" value="AjaxOrderItemDisplayView"/>
											<wcf:param name="storeId" value="${WCParam.storeId}"/>
											<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
											<wcf:param name="langId" value="${WCParam.langId}"/>
											<wcf:param name="inventoryValidation" value="true"/>
										</wcf:url>
										<div id="OrderStatusDetailsDisplayExt_option_button_1_<c:out value='${status.count}'/>" class="option_button">
											<div class="option_button">
												<flow:ifEnabled feature="SideBySideIntegration">
													<c:if test="${ordStatus != 'X'}">
														<c:choose>
															<c:when test="${objectIdParam=='externalOrderId'}">
																<wcf:url value="AjaxSSFSOrderCopy" var="SSFSOrderCopyUrl" type="Ajax">
																	<wcf:param name="OrderHeaderKey" value="${objectId}"/>
																	<wcf:param name="OrderNo" value="${order.orderIdentifier.uniqueID}"/>
																	<wcf:param name="toOrderId" value=".**."/>
																	<wcf:param name="calculate" value="1"/>
																	<wcf:param name="URL" value="AjaxOrderItemDisplayView"/>
																	<wcf:param name="storeId" value="${WCParam.storeId}"/>
																	<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
																	<wcf:param name="langId" value="${WCParam.langId}"/>
																	<wcf:param name="inventoryValidation" value="true"/>
																</wcf:url>
																<a href="#" role="button" class="button_primary" id="OrderStatusDetailsDisplayExt_option_button_link_1_<c:out value='${status.count}'/>" width="100%" onclick="javaScript:setCurrentId('OrderStatusDetailsDisplayExt_option_button_link_1_<c:out value='${status.count}'/>'); MyAccountDisplay.prepareSSFSOrderCopy('<c:out value='${SSFSOrderCopyUrl}'/>');">
																	<div class="left_border"></div>
																	<div class="button_text"><fmt:message key="MO_REORDER" /></div>												
																	<div class="right_border"></div>
																</a>
															</c:when>
															<c:otherwise>
																<a href="#" role="button" class="button_primary" id="OrderStatusDetailsDisplayExt_option_button_link_1_<c:out value='${status.count}'/>" width="100%" onclick="javaScript:setCurrentId('OrderStatusDetailsDisplayExt_option_button_link_1_<c:out value='${status.count}'/>'); MyAccountDisplay.prepareOrderCopy('<c:out value='${OrderCopyUrl}'/>');">
																	<div class="left_border"></div>
																	<div class="button_text"><fmt:message key="MO_REORDER" /></div>												
																	<div class="right_border"></div>
																</a>
															</c:otherwise>
														</c:choose>
													</c:if>
												</flow:ifEnabled>
												<flow:ifDisabled feature="SideBySideIntegration">
													<a href="#" role="button" class="button_primary" id="OrderStatusDetailsDisplayExt_option_button_link_1_<c:out value='${status.count}'/>" width="100%" onclick="javaScript:setCurrentId('OrderStatusDetailsDisplayExt_option_button_link_1_<c:out value='${status.count}'/>'); MyAccountDisplay.prepareOrderCopy('<c:out value='${OrderCopyUrl}'/>');">
														<div class="left_border"></div>
														<div class="button_text"><fmt:message key="MO_REORDER" /></div>												
														<div class="right_border"></div>
													</a>
												</flow:ifDisabled>
											</div>
										</div>
									</c:if>
								</flow:ifEnabled>
							
						</c:when>
						<c:when test="${isScheduledOrdersTab}">
							<flow:ifEnabled feature="ScheduleOrder">
								
									<div id="OrderStatusDetailsDisplayExt_option_button_3_<c:out value='${status.count}'/>" class="option_button"> 
										<a href="#" role="button" class="button_primary" id="OrderStatusDetailsDisplayExt_option_button_link_3_<c:out value='${status.count}'/>" width="100%" onclick="javaScript:setCurrentId('OrderStatusDetailsDisplayExt_option_button_link_3_<c:out value='${status.count}'/>'); MyAccountDisplay.cancelScheduledOrder('<c:out value='${objectId}'/>');">
											<div class="left_border"></div>
											<div class="button_text"><fmt:message key="MO_CancelButton" /></div>												
											<div class="right_border"></div>
										</a>
									</div>
								
							</flow:ifEnabled>
						</c:when>
					</c:choose>
				</div>
				<div role="gridcell" id="OrderStatusDetailsDisplayExt_clear_float_<c:out value='${status.count}'/>" class="li clear_float"></div>
			</div>
		</c:forEach>
	</c:otherwise>
</c:choose>
<!-- END OrderStatusTableDetailsDisplay.jsp -->
