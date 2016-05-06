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
<%-- 
  *****
  * This JSP file renders the order totals section used throughout the entire checkout flow.
  *****
--%>
<!-- BEGIN SingleShipmentOrderTotalsSummary.jsp -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ include file="../../../Common/EnvironmentSetup.jspf"%>

<script type="text/javascript">
	dojo.addOnLoad(initDiscountDetails);
	
	function initDiscountDetails(){	
		<%-- Initially discountDetailsSection div will be hidden (Otherwise all the tooltip pop-ups will be visible and disappear only after dojo parses it. So hide them initially). Display it on page load. --%>
		if(document.getElementById("discountDetailsSection")!=null )  {
			document.getElementById("discountDetailsSection").style.display = "block";
		}
	}
</script>

<c:set var="order" value="${requestScope.order}" />
<%-- the following check is to handle the AJAX case in the Shopping Cart page and Shipment Display page 
	when user modifies his/her order. In both pages, the "order" data is of the same type and has the same parameters --%>
<c:if test="${empty order || order==null}">
	<wcf:getData type="com.ibm.commerce.order.facade.datatypes.OrderType"
		var="order" expressionBuilder="findCurrentShoppingCart">
		<wcf:param name="accessProfile" value="IBM_Summary" />
	</wcf:getData>
</c:if>

<c:set var="totalProductDiscount" value="0"/>
<c:set var="hasProductDiscount" value="false"/>
<c:set var="showTotals" value="true"/>

<flow:ifDisabled feature="SharedShippingBillingPage">
	<c:if test="${param.fromPage eq 'shoppingCartDisplay' || param.fromPage eq 'shippingPage'}">
		<c:set var="showTotals" value="false"/>
	</c:if>
</flow:ifDisabled>


<div id="total_breakdown">
	
	<%-- promotion code area --%>
	<flow:ifEnabled feature="promotionCode">
		<c:if test="${param.fromPage != 'orderSummaryPage' && param.fromPage != 'orderConfirmationPage' && param.fromPage != 'pendingOrderDisplay'}">
			<div id="promotions">
				<%-- Flush the buffer so this fragment JSP is not cached twice --%>
				<%out.flush();%>
				<c:import url="/${sdb.jspStoreDir}/Snippets/Marketing/Promotions/PromotionCodeDisplay.jsp">
					<c:param name="orderId" value="${order.orderIdentifier.uniqueID}" />
					<c:param name="returnView" value="${param.returnView}" />
				</c:import>
				<%out.flush();%>
			</div>
		</c:if>
	</flow:ifEnabled>
	
	<table id="order_total" cellpadding="0" cellspacing="0" border="0" role="presentation">
		
		<%-- ORDER SUMMARY LINE - order subtotal --%>
		<tr> 
			<td class="total_details" id="WC_SingleShipmentOrderTotalsSummary_td_1"><fmt:message key="MO_ORDERSUBTOTAL" /></td>
			<td class="total_figures" id="WC_SingleShipmentOrderTotalsSummary_td_2"><fmt:formatNumber value="${order.orderAmount.totalProductPrice.value}" type="currency" maxFractionDigits="${env_currencyDecimal}" minFractionDigits="${env_currencyDecimal}" currencySymbol="${env_CurrencySymbolToFormat}"/><c:out value="${CurrencySymbol}"/></td>
		</tr>
		
	<c:if test="${showTotals eq true}">
		<%-- TOTAL PRODUCT DISCOUNTS --%>
		<%-- Check and see if there is any product (i.e. order item) level adjustment to display --%>
		<tr>
			<c:forEach var="orderItemAdjustment" items="${order.orderAmount.adjustment}">
				<c:if test="${!hasProductDiscount}">
					<c:if test="${orderItemAdjustment.displayLevel.name == 'OrderItem'}">
						<c:set var="hasProductDiscount" value="true"/>
						<td class="total_details" id="WC_SingleShipmentOrderTotalsSummary_td_11"><fmt:message key="ORD_ORDER_DISCOUNTS_PRODUCTS" /></td>
					</c:if>
				</c:if>
			</c:forEach>
			<c:forEach var="orderItemAdjustment" items="${order.orderAmount.adjustment}">
				<c:if test="${hasProductDiscount}">
					<c:if test="${orderItemAdjustment.displayLevel.name == 'OrderItem'}">
						<c:set var="totalProductDiscount" value="${totalProductDiscount + orderItemAdjustment.amount.value}"/>
					</c:if>
				</c:if>
			</c:forEach>
			<c:if test="${hasProductDiscount}">
				<td class="total_figures" id="WC_SingleShipmentOrderTotalsSummary_td_12"><fmt:formatNumber value="${totalProductDiscount}" type="currency" maxFractionDigits="${env_currencyDecimal}" minFractionDigits="${env_currencyDecimal}" currencySymbol="${env_CurrencySymbolToFormat}"/><c:out value="${CurrencySymbol}"/></td>
			</c:if>
			<c:if test="${!hasProductDiscount}">
				<td></td>
			</c:if>
		</tr>
		
		<%-- ORDER SUMMARY LINE - total order discount --%>
		<tr>
			<td class="total_details" id="WC_SingleShipmentOrderTotalsSummary_td_3">
				<%-- Check and see if there is any order level adjustment to display --%>
				<c:set var="displayDiscountTooltip" value="false"/>
				<c:choose>
					<c:when test="${param.fromPage == 'shoppingCartDisplay'}">
						<c:forEach var="adjustment" items="${order.orderAmount.adjustment}">
							<c:if test="${!displayDiscountTooltip}">
								<c:if test="${adjustment.displayLevel.name == 'Order' && adjustment.usage == 'Discount'}">
									<c:set var="displayDiscountTooltip" value="true"/>
								</c:if>
							</c:if>
						</c:forEach>
					</c:when>
					<c:otherwise>
						<c:forEach var="adjustment" items="${order.orderAmount.adjustment}">
							<c:if test="${!displayDiscountTooltip}">
								<c:if test="${adjustment.displayLevel.name == 'Order'}">
									<c:set var="displayDiscountTooltip" value="true"/>
								</c:if>
							</c:if>
						</c:forEach>
					</c:otherwise>
				</c:choose>
				<c:choose>
					<%-- displays a link and upon focus it will show a tooltip displaying order discount details --%>
					<c:when test="${displayDiscountTooltip}">
						<div id="discountDetailsSection" style="display:none">		
							<span id="discountAcceText" style="display:none">
								<fmt:message key='ORD_DISCOUNT_DETAILS_TITLE' bundle='${storeText}'/>
								<c:forEach var="adjustment" items="${order.orderAmount.adjustment}">
									<c:if test="${adjustment.displayLevel.name == 'Order'}">
										<c:out value="${adjustment.description.value}" escapeXml="false"/>&nbsp;
										<fmt:formatNumber value="${adjustment.amount.value}" type="currency" maxFractionDigits="${env_currencyDecimal}" minFractionDigits="${env_currencyDecimal}" currencySymbol="${env_CurrencySymbolToFormat}"/><c:out value="${CurrencySymbol}"/>
									</c:if>
								</c:forEach>
							</span>
							<span class="info_icon" id="discountDetails" tabindex="0" onmouseover="javascript: this.title = '';" onmouseout="javascript: this.title = document.getElementById('discountAcceText').innerHTML;"
							title="<fmt:message key='ORD_DISCOUNT_DETAILS_TITLE' bundle='${storeText}'/>
							<c:forEach var="adjustment" items="${order.orderAmount.adjustment}">
								<c:if test="${adjustment.displayLevel.name == 'Order'}">
									<c:out value="${adjustment.description.value}" escapeXml="false"/>&nbsp;
									<fmt:formatNumber value="${adjustment.amount.value}" type="currency" maxFractionDigits="${env_currencyDecimal}" minFractionDigits="${env_currencyDecimal}" currencySymbol="${env_CurrencySymbolToFormat}"/><c:out value="${CurrencySymbol}"/>
								</c:if>
							</c:forEach>">
							<img src="<c:out value='${jspStoreImgDir}${vfileColor}/info.png'/>"  alt="<fmt:message key="ORD_DISCOUNT_ADJUSTMENTS" />"/><fmt:message key="DISCOUNT1" /></span>
							<div id="WC_SingleShipmentOrderTotalsSummary_span_1" dojoType="wc.widget.Tooltip" connectId="discountDetails" style="display: none;">
								<div class="widget_site_popup">
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
													<div class="header" id="WC_SingleShipmentOrderTotalsSummary_div_1"> 
														<span id="WC_SingleShipmentOrderTotalsSummary_div_2"><fmt:message key="ORD_DISCOUNT_DETAILS_TITLE" /></span>
														<div class="clear_float"></div>
													</div>
													<div class="body" id="WC_SingleShipmentOrderTotalsSummary_div_3">
													    <c:choose>
															<c:when test="${param.fromPage == 'shoppingCartDisplay'}">
																<c:forEach var="adjustment" items="${order.orderAmount.adjustment}">
																	<c:if test="${adjustment.displayLevel.name == 'Order' && adjustment.usage == 'Discount'}">
																		<c:out value="${adjustment.description.value}" escapeXml="false"/>&nbsp;
																		<span class="tooltip_popup_price"><fmt:formatNumber value="${adjustment.amount.value}" type="currency" maxFractionDigits="${env_currencyDecimal}" minFractionDigits="${env_currencyDecimal}" currencySymbol="${env_CurrencySymbolToFormat}"/><c:out value="${CurrencySymbol}"/></span><br />
																	</c:if>
																</c:forEach>
															</c:when>
															<c:otherwise>
																<c:forEach var="adjustment" items="${order.orderAmount.adjustment}">
																	<c:if test="${adjustment.displayLevel.name == 'Order'}">
																		<c:out value="${adjustment.description.value}" escapeXml="false"/>&nbsp;
																		<span class="tooltip_popup_price"><fmt:formatNumber value="${adjustment.amount.value}" type="currency" maxFractionDigits="${env_currencyDecimal}" minFractionDigits="${env_currencyDecimal}" currencySymbol="${env_CurrencySymbolToFormat}"/><c:out value="${CurrencySymbol}"/></span><br />
																	</c:if>
																</c:forEach>
															</c:otherwise>
														</c:choose>
													</div>
													<div class="clear_float"></div>
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
						</div>
					</c:when>
					<%-- if no discount is applied to the order - do not show details text and no tooltip --%>
					<c:otherwise>
						<fmt:message key="DISCOUNT1" /> 
					</c:otherwise>
				</c:choose>
			</td>
			<c:choose>
				<c:when test="${param.fromPage == 'shoppingCartDisplay'}">
					<c:set var="totalOrderLevelDiscount" value="0"/>
					<c:forEach var="adjustment" items="${order.orderAmount.adjustment}">
						<c:if test="${adjustment.displayLevel.name == 'Order' && adjustment.usage == 'Discount'}">
							<c:set var="totalOrderLevelDiscount" value="${totalOrderLevelDiscount + adjustment.amount.value}"/>
						</c:if>
					</c:forEach>
					
					<td class="total_figures" id="WC_SingleShipmentOrderTotalsSummary_td_4">
						<c:choose>
							<c:when test="${isBiDiLocale}">
								<fmt:formatNumber pattern="#,##0.00 �;#,##0.00- �" value="${totalOrderLevelDiscount}" type="currency" maxFractionDigits="${env_currencyDecimal}" minFractionDigits="${env_currencyDecimal}" currencySymbol="${env_CurrencySymbolToFormat}"/>
							</c:when>
							<c:otherwise>
								<fmt:formatNumber value="${totalOrderLevelDiscount}" type="currency" maxFractionDigits="${env_currencyDecimal}" minFractionDigits="${env_currencyDecimal}" currencySymbol="${env_CurrencySymbolToFormat}"/>
							</c:otherwise>
						</c:choose>
						<c:out value="${CurrencySymbol}"/>
					</td>
				</c:when>
				<c:otherwise>
					<td class="total_figures" id="WC_SingleShipmentOrderTotalsSummary_td_4">
						<c:choose>
							<c:when test="${isBiDiLocale}">
								<fmt:formatNumber pattern="#,##0.00 �;#,##0.00- �" value="${order.orderAmount.totalAdjustment.value - totalProductDiscount}" type="currency" maxFractionDigits="${env_currencyDecimal}" minFractionDigits="${env_currencyDecimal}" currencySymbol="${env_CurrencySymbolToFormat}"/>
							</c:when>
							<c:otherwise>
								<fmt:formatNumber value="${order.orderAmount.totalAdjustment.value - totalProductDiscount}" type="currency" maxFractionDigits="${env_currencyDecimal}" minFractionDigits="${env_currencyDecimal}" currencySymbol="${env_CurrencySymbolToFormat}"/>
							</c:otherwise>
						</c:choose>
						<c:out value="${CurrencySymbol}"/>
					</td>
				</c:otherwise>
			</c:choose>
		</tr>
		
		<%-- for the shopping cart page only - do not show tax and shipping charge --%>
		<c:if test="${param.fromPage != 'shoppingCartDisplay' && param.fromPage != 'pendingOrderDisplay'}">
			<%-- ORDER SUMMARY LINE - tax --%>
		  	<c:choose>
		  		<c:when test="${isBrazilStore}">
					<%-- For the Brazil store, normally taxes are zero in the country so they don't want to see 
					     the tax line. But in the case, where a registered user isn't from brazil( not mormally for case for Brazil store),
					     show the tax line if amount is greater then zero. For example, registered as a USA shopper, show the 
					     the tax line. In most case, for the Brazil store, they will be registered from Brazil --%>
					<c:if test="${order.orderAmount.totalSalesTax.value > 0}">
						<tr> <%-- Unusual case so show tax line --%>
							<td class="total_details" id="WC_SingleShipmentOrderTotalsSummary_td_5"><fmt:message key="MO_TAX" /></td>
							<td class="total_figures" id="WC_SingleShipmentOrderTotalsSummary_td_6"><fmt:formatNumber value="${order.orderAmount.totalSalesTax.value}" type="currency" maxFractionDigits="${env_currencyDecimal}" minFractionDigits="${env_currencyDecimal}" currencySymbol="${env_CurrencySymbolToFormat}"/><c:out value="${CurrencySymbol}"/></td>
						</tr>	
					</c:if>		  		    
		  		</c:when>
		  		<c:otherwise> <%-- Output Madisons tax line  --%>
					<tr>
						<td class="total_details" id="WC_SingleShipmentOrderTotalsSummary_td_5"><fmt:message key="MO_TAX" /></td>
						<td class="total_figures" id="WC_SingleShipmentOrderTotalsSummary_td_6"><fmt:formatNumber value="${order.orderAmount.totalSalesTax.value}" type="currency" maxFractionDigits="${env_currencyDecimal}" minFractionDigits="${env_currencyDecimal}" currencySymbol="${env_CurrencySymbolToFormat}"/><c:out value="${CurrencySymbol}"/></td>
					</tr>	
		  		</c:otherwise>
			</c:choose>
			
			<%-- ORDER SUMMARY LINE - shipping charge --%>
			<tr>
				<td class="total_details" id="WC_SingleShipmentOrderTotalsSummary_td_7"><fmt:message key="MO_SHIPPING" /></td>
				<td class="total_figures" id="WC_SingleShipmentOrderTotalsSummary_td_8"><fmt:formatNumber value="${order.orderAmount.totalShippingCharge.value}" type="currency" maxFractionDigits="${env_currencyDecimal}" minFractionDigits="${env_currencyDecimal}" currencySymbol="${env_CurrencySymbolToFormat}"/><c:out value="${CurrencySymbol}"/></td>
			</tr>				
			<%-- ORDER SUMMARY LINE - shipping tax --%>
			<tr>
				<td class="total_details" id="WC_SingleShipmentOrderTotalsSummary_td_14"><fmt:message key="MO_SHIPPING_TAX" /></td>
				<td class="total_figures" id="WC_SingleShipmentOrderTotalsSummary_td_15"><fmt:formatNumber value="${order.orderAmount.totalShippingTax.value}" type="currency" maxFractionDigits="${env_currencyDecimal}" minFractionDigits="${env_currencyDecimal}" currencySymbol="${env_CurrencySymbolToFormat}"/><c:out value="${CurrencySymbol}"/></td>
			</tr>
		</c:if>
		
		<%-- ORDER SUMMARY LINE - order total --%>
		<tr>
			<td class="total_details order_total" id="WC_SingleShipmentOrderTotalsSummary_td_9"><fmt:message key="MO_ORDERTOTAL" /></td>
			<c:choose>
				<c:when test="${param.fromPage == 'shoppingCartDisplay'}">
					<td class="total_figures breadcrumb_current" id="WC_SingleShipmentOrderTotalsSummary_td_13"><fmt:formatNumber value="${order.orderAmount.totalProductPrice.value + totalProductDiscount + totalOrderLevelDiscount}" type="currency" maxFractionDigits="${env_currencyDecimal}" minFractionDigits="${env_currencyDecimal}" currencySymbol="${env_CurrencySymbolToFormat}"/><c:out value="${CurrencySymbol}"/></td>
				</c:when>
				<c:otherwise>
					<td class="total_figures breadcrumb_current" id="WC_SingleShipmentOrderTotalsSummary_td_10"><fmt:formatNumber value="${order.orderAmount.grandTotal.value}" type="currency" maxFractionDigits="${env_currencyDecimal}" minFractionDigits="${env_currencyDecimal}" currencySymbol="${env_CurrencySymbolToFormat}"/><c:out value="${CurrencySymbol}"/></td>
				</c:otherwise>
			</c:choose>
		</tr>
	</c:if>
	</table>

</div>

<flow:ifEnabled feature="CouponWallet">
	<c:if test="${param.fromPage != 'orderConfirmationPage' && param.fromPage != 'orderSummaryPage' && param.fromPage != 'pendingOrderDisplay'}">
	<%out.flush();%>
	<c:import url="/${sdb.jspStoreDir}/Snippets/Marketing/Promotions/CouponWalletTable.jsp">
			<c:param name="orderId" value="${order.orderIdentifier.uniqueID}" />
			<c:param name="returnView" value="${param.returnView}" />
	</c:import>
	<%out.flush();%>
	</c:if>
</flow:ifEnabled>
<!-- END SingleShipmentOrderTotalsSummary.jsp -->
