<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2012 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<table style="border-collapse:collapse; border-spacing:0; width:100%; margin:20px 0;">  
	<tr>
		<th style="margin:0; padding:0; border-bottom:1px dotted #aaaaaa; padding:9px 0 7px 0; text-align:left; border-bottom:1px solid #e5e5e5;"><fmt:message key="EMAIL_PRODUCT"/></th>
		<th style="margin:0; padding:0; border-bottom:1px dotted #aaaaaa; padding:9px 0 7px 0; width:15%; text-align:center; border-bottom:1px solid #e5e5e5;"><fmt:message key="EMAIL_QUANTITY"/></th>
		<th style="margin:0; padding:0; border-bottom:1px dotted #aaaaaa; padding:9px 0 7px 0; width:15%; text-align:right; border-bottom:1px solid #e5e5e5;"><fmt:message key="EMAIL_EACH"/></th>
		<th style="margin:0; padding:0; border-bottom:1px dotted #aaaaaa; padding:9px 0 7px 0; width:15%; text-align:right; border-bottom:1px solid #e5e5e5;"><fmt:message key="EMAIL_TOTAL"/></th>
	</tr>	

	<c:forEach var="orderItem" items="${order.orderItem}" varStatus="status">
			<wcbase:useBean id="catEntry" classname="com.ibm.commerce.catalog.beans.CatalogEntryDataBean" scope="request">
					<c:set property="catalogEntryID" value="${orderItem.catalogEntryIdentifier.uniqueID}" target="${catEntry}" />
			</wcbase:useBean>
			<fmt:formatNumber	var="quickCartOrderItemQuantity" value="${orderItem.quantity.value}" type="number" maxFractionDigits="0"/>
			<tr>
		<td style="margin:0; padding:0; border-bottom:1px dotted #aaaaaa; padding:9px 0 7px 0; text-align:left;">${catEntry.description.name}
			
		<c:if test="${showDynamicKit eq 'true'}">
			<c:set var="orderHasDKComponents" value="false" />
			<c:forEach var="orderItem2" items="${order.orderItem}">
				<c:if test="${!empty orderItem2.orderItemComponent}">
					<c:set var="orderHasDKComponents" value="true" /> 
				</c:if>
			</c:forEach>
			<c:if test="${orderHasDKComponents eq 'true'}">
				<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogNavigationViewType" var="dkComponents" 
						expressionBuilder="getCatalogEntryViewAllByID" scope="request" varShowVerb="showCatalogNavigationView" 
						maxItems="100" recordSetStartNumber="0" scope="request">
								<c:forEach var="orderItem1" items="${order.orderItem}">
								<wcf:param name="UniqueID" value="${orderItem1.catalogEntryIdentifier.uniqueID}"/>  
									<c:forEach var="orderItemComponents" items="${orderItem1.orderItemComponent}">   
										<wcf:param name="UniqueID" value="${orderItemComponents.catalogEntryIdentifier.uniqueID}"/> 
									</c:forEach>
								</c:forEach>
								<wcf:contextData name="storeId" data="${WCParam.storeId}" />
								<wcf:contextData name="catalogId" data="${WCParam.catalogId}" />
				</wcf:getData>
			</c:if>
		</c:if>
		
		<c:if test="${showDynamicKit eq 'true' && !empty orderItem.orderItemComponent}">
						<c:forEach var="savedDKComponent" items="${dkComponents.catalogEntryView}">
							<c:if test="${!empty savedDKComponent.dynamicKitDefaultConfiguration && savedDKComponent.uniqueID==orderItem.catalogEntryIdentifier.uniqueID}">
								<input type="hidden" id="configXml_${orderItem.orderItemIdentifier.uniqueID}" class="configurationXML" value="${savedDKComponent.dynamicKitDefaultConfiguration}"/>
							</c:if>
						</c:forEach>	
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
		</td>
				<td style="margin:0; padding:0; border-bottom:1px dotted #aaaaaa; padding:9px 0 7px 0; width:15%; text-align:center;">
					<c:out value="${quickCartOrderItemQuantity}"/></td>
				<td style="margin:0; padding:0; border-bottom:1px dotted #aaaaaa; padding:9px 0 7px 0; width:15%; text-align:right;">
					<fmt:formatNumber value="${orderItem.orderItemAmount.unitPrice.price.value}" type="currency" maxFractionDigits="${env_currencyDecimal}" currencySymbol="${env_CurrencySymbolToFormat}"/>
					<c:out value="${CurrencySymbol}"/></td>
				<td style="margin:0; padding:0; border-bottom:1px dotted #aaaaaa; padding:9px 0 7px 0; width:15%; text-align:right;">
				<c:choose>
				<c:when test="${orderItem.orderItemAmount.freeGift}">
					<%-- the OrderItem is a freebie --%>
					<fmt:message key="Free"/>
				</c:when>
				<c:otherwise>
					<fmt:formatNumber var="totalFormattedProductPrice" value="${orderItem.orderItemAmount.orderItemPrice.value}" type="currency" maxFractionDigits="${env_currencyDecimal}" currencySymbol="${env_CurrencySymbolToFormat}"/>
					<c:out value="${totalFormattedProductPrice}" escapeXml="false" />
					<c:out value="${CurrencySymbol}"/>
				</c:otherwise>
				</c:choose></td>
			</tr>
		<c:remove var="catEntry"/>
	</c:forEach>
															
</table>

 <table role="presentation" style="border-collapse:collapse; border-spacing:0; width:100%; text-align:right; line-height:14px; margin-bottom:35px;"> 
	<tr>
		<td style="margin:0; padding:0; width:85%; line-height:14px;"><fmt:message key="EMAIL_ORDER_SUBTOTAL" />&#58;</td>
		<td style="margin:0; padding:0;">
		<fmt:formatNumber value="${order.orderAmount.totalProductPrice.value}" type="currency" maxFractionDigits="${env_currencyDecimal}" currencySymbol="${env_CurrencySymbolToFormat}"/><c:out value="${CurrencySymbol}"/>
		</td>
	</tr>
	<c:set var="totalProductDiscount" value="0"/>
	<c:set var="hasProductDiscount" value="false"/>
	<c:forEach var="orderItemAdjustment" items="${order.orderAmount.adjustment}">
		<c:if test="${!hasProductDiscount}">
			<c:if test="${orderItemAdjustment.displayLevel.name == 'OrderItem'}">
				<c:set var="hasProductDiscount" value="true"/>
	<tr>
		<td style="margin:0; padding:0; width:85%; line-height:14px;"><fmt:message key="PRODUCT_DISCOUNT_TOTAL"/>&#58;
		</td>
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
		<td style="margin:0; padding:0;">
		<fmt:formatNumber value="${totalProductDiscount}" type="currency" maxFractionDigits="${env_currencyDecimal}" currencySymbol="${env_CurrencySymbolToFormat}"/><c:out value="${CurrencySymbol}"/>
		</td>
		</tr>
	</c:if>

	<tr>
		<td style="margin:0; padding:0; width:85%; line-height:14px;"><fmt:message key="EMAIL_TOTAL_ORDER_DISCOUNT" />&#58;</td>
		<td style="margin:0; padding:0;">
			<fmt:formatNumber value="${order.orderAmount.totalAdjustment.value - totalProductDiscount}" type="currency" maxFractionDigits="${env_currencyDecimal}" currencySymbol="${env_CurrencySymbolToFormat}"/><c:out value="${CurrencySymbol}"/>
		</td>
	</tr>
	<tr>
		<td style="margin:0; padding:0; width:85%; line-height:14px;"><fmt:message key="EMAIL_TAX" />&#58;</td>
		<td style="margin:0; padding:0;">
			<fmt:formatNumber value="${order.orderAmount.totalSalesTax.value}" type="currency" maxFractionDigits="${env_currencyDecimal}" currencySymbol="${env_CurrencySymbolToFormat}"/><c:out value="${CurrencySymbol}"/>
		</td>
	</tr>
	<tr>
		<td style="margin:0; padding:0; width:85%; line-height:14px;"><fmt:message key="EMAIL_SHIPPING" />&#58;</td>
		<td style="margin:0; padding:0;">
			<fmt:formatNumber value="${order.orderAmount.totalShippingCharge.value}" type="currency" maxFractionDigits="${env_currencyDecimal}" currencySymbol="${env_CurrencySymbolToFormat}"/><c:out value="${CurrencySymbol}"/>
		</td>
	</tr>
	<tr>
		<td style="margin:0; padding:0; width:85%; line-height:14px;"><fmt:message key="EMAIL_SHIPPING_TAX" />&#58;</td>
		<td style="margin:0; padding:0;">
			<fmt:formatNumber value="${order.orderAmount.totalSalesTax.value}" type="currency" maxFractionDigits="${env_currencyDecimal}" currencySymbol="${env_CurrencySymbolToFormat}"/><c:out value="${CurrencySymbol}"/>
		</td>
	</tr>
	<tr>
		<td style="margin:0; padding:0; width:85%; line-height:14px;"><strong><fmt:message key="EMAIL_ORDER_TOTAL" />&#58;</strong></td>
		<td style="margin:0; padding:0;">
			<strong><fmt:formatNumber value="${order.orderAmount.grandTotal.value}" type="currency" maxFractionDigits="${env_currencyDecimal}" currencySymbol="${env_CurrencySymbolToFormat}"/><c:out value="${CurrencySymbol}"/></strong>
		</td>
	</tr>
</table>