<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2012 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%--
  *****
  * This JSP file displays the shopping cart details. It shows an empty shopping cart page accordingly.
  *****
--%>                    
<!-- BEGIN ShopCartDisplay.jsp -->

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ include file="../../Common/EnvironmentSetup.jspf"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!-- Get order Details using the ORDER SOI -->
<c:set var="pageSize" value="${WCParam.pageSize}" />
<c:if test="${empty pageSize}">
	<c:set var="pageSize" value="${maxOrderItemsPerPage}"/>
</c:if>

<c:set var="beginIndex" value="${WCParam.beginIndex}" />
<c:if test="${empty beginIndex}">
	<c:set var="beginIndex" value="0" />
</c:if>  
<wcf:getData type="com.ibm.commerce.order.facade.datatypes.OrderType" scope="request" 
	var="order" expressionBuilder="findCurrentShoppingCartWithPagingOnItem" varShowVerb="ShowVerbCart" maxItems="${pageSize}" recordSetStartNumber="${beginIndex}" recordSetReferenceId="ostatus">
	<wcf:param name="accessProfile" value="IBM_Details" />	 
	<wcf:param name="sortOrderItemBy" value="orderItemID" />
	<wcf:param name="isSummary" value="false" />
</wcf:getData>

<c:if test="${empty order.orderItem && beginIndex >= pageSize}">
	<fmt:formatNumber var="totalPages" value="${(ShowVerbCart.recordSetTotal/pageSize)}" maxFractionDigits="0"/>		
	<c:if test="${ShowVerbCart.recordSetTotal%pageSize < (pageSize/2)}">
		<fmt:formatNumber var="totalPages" value="${(ShowVerbCart.recordSetTotal+(pageSize/2)-1)/pageSize}" maxFractionDigits="0"/>
	</c:if>
	<fmt:parseNumber var="totalPages" value="${totalPages}" integerOnly="true"/>
	<c:set var="beginIndex" value="${(totalPages-1)*pageSize}" />
	<wcf:getData type="com.ibm.commerce.order.facade.datatypes.OrderType" scope="request" 
		var="order" expressionBuilder="findCurrentShoppingCartWithPagingOnItem" varShowVerb="ShowVerbCart" maxItems="${pageSize}" recordSetStartNumber="${beginIndex}" recordSetReferenceId="ostatus">
		<wcf:param name="accessProfile" value="IBM_Details" />	 
		<wcf:param name="sortOrderItemBy" value="orderItemID" />
		<wcf:param name="isSummary" value="false" />
	</wcf:getData>
</c:if>

<wcf:url var="currentShoppingCartLink" value="ShopCartPageView" type="Ajax">
	<wcf:param name="storeId"   value="${WCParam.storeId}"  />
	<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
	<wcf:param name="langId" value="${WCParam.langId}" />
</wcf:url>
<script type="text/javascript">
dojo.addOnLoad(
	function(){
		CommonControllersDeclarationJS.setControllerURL('ShopCartPaginationDisplayController','<c:out value="${currentShoppingCartLink}"/>');
		ShipmodeSelectionExtJS.setOrderItemId('${order.orderItem[0].orderItemIdentifier.uniqueID}');
	}
);
</script>
<c:set var="showTax" value="false"/>
<c:set var="showShipping" value="false"/>
<c:choose>
	<c:when test="${empty param.orderId}">        
		<c:choose>
			<c:when test="${!empty WCParam.orderId}">
				<c:set var="orderId" value="${WCParam.noElementToDisplay}" />
			</c:when>
		</c:choose>
	</c:when>
	<c:otherwise>
		<c:set var="orderId" value="${param.orderId}" />
	</c:otherwise>
</c:choose>
<wcf:useBean var="cachedStoreCatalogEntryAttributesByIDsMap" classname="java.util.HashMap" scope="request"/>
    
<div id="box" class="shopping_cart_box">
	<div class="myaccount_header bottom_line" id="shopping_cart_product_table_tall">
		<flow:ifEnabled feature="RequisitionList">
			<c:set var="hideSavedOrderCreateButton" value="true"/>
			<c:set var="hideSavedOrderCancelButton" value="true"/>
			<c:set var="hideSavedOrderCopyButton" value="true"/>
			<c:set var="hideSavedOrderSaveButton" value="true"/>
			<c:if test="${empty order.orderItem }" >
				<c:set var="hideSavedOrderAddToReqListButton" value="true"/>
			</c:if>	
			 			  
			<%@ include file="../../Snippets/ReusableObjects/SavedOrdersToolbar.jspf" %>
		</flow:ifEnabled>		
		<%@ include file="../../Snippets/ReusableObjects/CheckoutTopESpotDisplay.jspf"%>
		<%-- Split the shopping_cart_product_table_tall div in order to move the online and pick up in store choice and maintain function --%>
	<c:choose>
		<c:when test="${!empty order.orderItem }" >
			<%out.flush();%>
			<c:import url="/${sdb.jspStoreDir}/Snippets/Order/Cart/ShipmodeSelectionExt.jsp"/> 
			<%out.flush();%>
			</div>
			
			<div class="body" id="WC_ShopCartDisplay_div_5">
				<input type="hidden" id="OrderFirstItemId" value="${order.orderItem[0].orderItemIdentifier.uniqueID}"/>
				<flow:ifEnabled feature="RecurringOrders">
					<%-- Moved to here from ShipmodeSelectionExt.jsp in order to move shipping selection into the header --%>
					<c:set var="cookieKey1" value="WC_recurringOrder_${order.orderIdentifier.uniqueID}"/>
					<c:set var="currentOrderIsRecurringOrder" value="${cookie[cookieKey1].value}"/>
					<div id="scheduling_options" style="display: block;">
						<span id="recurringOrderAcceText" style="display:none">
							<fmt:message key="WHAT_IS_REC_ORDER"/>
							<fmt:message key="REC_ORDER_POPUP_DESCRIPTION"/>
						</span>
						<form name="RecurringOrderForm">
							<input name="recurringOrder" id="recurringOrder" class="radio" type="checkbox" 
											<c:if test="${currentOrderIsRecurringOrder == 'true'}">checked="checked"</c:if>
											onclick="javascript:ShipmodeSelectionExtJS.hideShowNonRecurringOrderMsg(<c:out value="${order.orderIdentifier.uniqueID}" />)" >
							<label for="recurringOrder"><fmt:message key="RECURRING_ORDER_SELECT"/></label>
							<span
								id="recurringOrderInfo"
								tabindex="0"
								onmouseover="javascript: this.title = '';"
								onmouseout="javascript: this.title = document.getElementById('recurringOrderAcceText').innerHTML;"
								title="<fmt:message key='WHAT_IS_REC_ORDER'/><fmt:message key='REC_ORDER_POPUP_DESCRIPTION'/>"
							>&nbsp;
								<img
									src="<c:out value='${jspStoreImgDir}${vfileColor}info.png'/>"
									alt="<fmt:message key='RECURRING_ORDER_INFO'/>"
									border="0"/>
							</span>
						
							<div id="recurringOrderInfoPopUp" dojoType="wc.widget.Tooltip" connectId="recurringOrderInfo" class="recurring_orderdesc_popup_main_div">
								<div id="recurringOrderInfoPopUp_div1" class="widget_site_popup">
									<div class="top">
										<div class="left_border"></div>
										<div class="middle"></div>
										<div class="right_border"></div>
									</div>
									<div class="clear_float"></div>
									<div class="middle">
										<div class="content_left_border">
											<div class="content_right_border">
												<div class="content">
													<div class="header" id="recurringOrderInfoPopUp_div4">
														<span id="recurringOrderInfoPopUp_title">
															<fmt:message key="WHAT_IS_REC_ORDER"/>
														</span>
														<div class="clear_float"></div>
													</div>
													<div class="body" id="recurringOrderInfoPopUp_div7">
														<fmt:message key="REC_ORDER_POPUP_DESCRIPTION"/>														
													</div>
													<div class="clear_float" id="recurringOrderInfoPopUp_div8"></div>										
												</div>
											</div>
										</div>
									</div>
									<div class="clear_float"></div>
									<div class="bottom">
										<div class="left_border"></div>
										<div class="middle"></div>
										<div class="right_border"></div>
									</div>
									<div class="clear_float"></div>								
								</div>
							</div>
						</form>
					</div>
				</flow:ifEnabled>
				<span id="ShopCartPagingDisplay_ACCE_Label" class="spanacce"><fmt:message key="ACCE_Region_Order_Item_List"/></span>
				<div dojoType="wc.widget.RefreshArea" widgetId="ShopCartPagingDisplay" id="ShopCartPagingDisplay" controllerId="ShopCartPaginationDisplayController" ariaMessage="<fmt:message key="ACCE_Status_Order_Item_List_Updated"/>" ariaLiveId="${ariaMessageNode}" role="region" aria-labelledby="ShopCartPagingDisplay_ACCE_Label">
					<%out.flush();%>
					<c:import url="/${sdb.jspStoreDir}/Snippets/Order/Cart/OrderItemDetail.jsp"> 
						<c:param name="catalogId" value="${WCParam.catalogId}" />
						<c:param name="langId" value="${WCParam.langId}" />
						<c:param name="storeId" value="${WCParam.storeId}" />
					</c:import>
					<%out.flush();%>
				</div>
				<c:if test="${b2bStore}">
					<script type="text/javascript">
						dojo.addOnLoad(function() { 
							if (savedOrdersJS != null && savedOrdersJS != 'undefined')
							{
								savedOrdersJS.isCurrentOrderPage(true);
						  		savedOrdersJS.setOrderId('<c:out value="${order.orderIdentifier.uniqueID}"/>');
							}
						});            
					</script>
				</c:if>
				<div class="free_gifts_block">
					<%out.flush();%>		
					<c:import url="/${sdb.jspStoreDir}/Snippets/Marketing/Promotions/PromotionPickYourFreeGift.jsp"/>
					<%out.flush();%>
				</div>
				<div id="WC_ShopCartDisplay_div_5a" class="espot_payment left">
					<%out.flush();%>
						<c:import url = "${env_jspStoreDir}Widgets/ESpot/ContentRecommendation/ContentRecommendation.jsp">
							<c:param name="storeId" value="${storeId}" />
							<c:param name="catalogId" value="${catalogId}" />
							<c:param name="emsName" value="ShoppingCartCenter_Content" />
						</c:import>
					<%out.flush();%>						
				</div>
				
				<%out.flush();%>
				<c:import url="/${sdb.jspStoreDir}/ShoppingArea/CheckoutSection/SingleShipment/SingleShipmentOrderTotalsSummary.jsp"> 
					<c:param name="returnView" value="AjaxOrderItemDisplayView"/>
					<c:param name="fromPage" value="shoppingCartDisplay"/>
				</c:import>
				<%out.flush();%>
				<br clear="all" />
				<%out.flush();%>
				<c:import url="/${sdb.jspStoreDir}/Snippets/Order/Cart/CheckoutLogon.jsp"/>
				<%out.flush();%>
				<%@ include file="../../Snippets/ReusableObjects/CheckoutBottomESpotDisplay.jspf"%>
			</div>			
		</c:when>
		<c:otherwise>
			</div>
			<div class="body" id="WC_ShopCartDisplay_div_6">
				<%@ include file="../../Snippets/ReusableObjects/EmptyShopCartDisplay.jspf"%>
			</div>
		</c:otherwise>
	</c:choose>
	  		
	<div class="footer" id="WC_ShopCartDisplay_div_7">
		<div class="left_corner" id="WC_ShopCartDisplay_div_8"></div>
		<div class="left" id="WC_ShopCartDisplay_div_9"></div>
		<div class="right_corner" id="WC_ShopCartDisplay_div_10"></div>
	</div>
</div>
<!-- END ShopCartDisplay.jsp -->
