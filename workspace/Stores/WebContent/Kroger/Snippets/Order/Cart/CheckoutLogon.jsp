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
<!-- BEGIN CheckoutLogon.jsp -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ include file="../../../Common/EnvironmentSetup.jspf"%>
 
<!-- Start - JSP File Name:  CheckoutLogon.jsp -->
<wcf:url var="OrderCalculateURL" value="OrderShippingBillingView" type="Ajax">
	<wcf:param name="langId" value="${langId}" />						
	<wcf:param name="storeId" value="${WCParam.storeId}" />
	<wcf:param name="catalogId" value="${WCParam.catalogId}" />
	<wcf:param name="shipmentType" value="single" />
</wcf:url>

<wcf:url var="PhysicalStoreSelectionURL" value="CheckoutStoreSelectionView">
	<wcf:param name="langId" value="${langId}" />
	<wcf:param name="storeId" value="${WCParam.storeId}" />
	<wcf:param name="catalogId" value="${WCParam.catalogId}" />
	<wcf:param name="fromPage" value="ShoppingCart" />
</wcf:url>

<c:if test="${userType != 'G'}">
	<%-- See if this user has quick checkout profile created or not, if quick checkout enabled --%>
	<flow:ifEnabled feature="quickCheckout"> 
		<wcf:getData type="com.ibm.commerce.order.facade.datatypes.OrderType" var="quickOrder" expressionBuilder="findByOrderStatus">
			<wcf:param name="status" value="Q"/>
			<wcf:param name="accessProfile" value="IBM_Summary" />
		</wcf:getData>
		<c:if test="${!empty quickOrder.orderIdentifier.uniqueID}">
			<c:choose>
				<c:when test="${isBrazilStore}">
					<%-- See if this user has more info in the quick checkout profile than just the CPF number --%>
					<wcf:getData type="com.ibm.commerce.member.facade.datatypes.PersonType" var="person" expressionBuilder="findCurrentPerson">
			   		<wcf:param name="accessProfile" value="IBM_CheckoutProfile" />
					</wcf:getData>
					<c:if test="${!empty person.checkoutProfile[0].paymentInfo.protocolData[1].value}">
						<c:set var="quickCheckoutProfile" value="true"/>
					</c:if>		
				</c:when>
				<c:otherwise>
					<c:set var="quickCheckoutProfile" value="true"/>
				</c:otherwise>
			</c:choose>
		</c:if>
	</flow:ifEnabled>
</c:if>

<c:if test="${userType == 'G'}">	
	<wcf:url var="orderMove" value="OrderItemMove" type="Ajax">		
		<wcf:param name="toOrderId" value="."/>
		<c:choose>
			<c:when test="${b2bStore}">
				<wcf:param name="deleteIfEmpty" value="."/>
				<flow:ifEnabled feature="MultipleActiveOrders">	
					<wcf:param name="fromOrderId" value="."/>						
				</flow:ifEnabled>
				<flow:ifDisabled feature="MultipleActiveOrders">
					<%-- MultipleActiveOrders is disabled. Order merging behavior should be the same as B2B --%>
					<wcf:param name="fromOrderId" value="*"/>						
				</flow:ifDisabled>
			</c:when>
			<c:otherwise>
				<wcf:param name="deleteIfEmpty" value="*"/>
				<wcf:param name="fromOrderId" value="*"/>
			</c:otherwise>
		</c:choose>
		<wcf:param name="continue" value="1"/>
		<wcf:param name="createIfEmpty" value="1"/>
		<wcf:param name="calculationUsageId" value="-1"/>
		<wcf:param name="updatePrices" value="0"/>
	</wcf:url>
		
	<wcf:url var="ForgetPasswordURL" value="ResetPasswordGuestErrorView">
		<wcf:param name="langId" value="${langId}" />
		<wcf:param name="storeId" value="${WCParam.storeId}" />
		<wcf:param name="catalogId" value="${WCParam.catalogId}" />
		<wcf:param name="state" value="forgetpassword" />
	</wcf:url>	

	<form method="post" name="AjaxLogon" id="AjaxLogon" action="Logon">
		<input type="hidden" name="storeId" value="<c:out value="${WCParam.storeId}"/>" id="WC_RememberMeLogonForm_FormInput_storeId_In_AjaxLogon_1"/>
		<input type="hidden" name="catalogId" value="<c:out value="${WCParam.catalogId}"/>" id="WC_RememberMeLogonForm_FormInput_catalogId_In_AjaxLogon_1"/>
		<input type="hidden" name="URL" value="" id="WC_AccountDisplay_FormInput_URL_In_Logon_1" />
		<input type="hidden" name="reLogonURL" value="AjaxOrderItemDisplayView" id="WC_RememberMeLogonForm_FormInput_reLogonURL_In_AjaxLogon_1"/>
		<input type="hidden" name="errorViewName" value="AjaxOrderItemDisplayView" id="WC_RememberMeLogonForm_FormInput_errorViewName_In_AjaxLogon_1"/>	

		<div class="top_border" id="WC_CheckoutLogonf_div_0">
			<div id="customers_new_or_returning">
				<div class="new" id="WC_CheckoutLogonf_div_1">
					<h2><fmt:message key="SHOPCART_NEW_CUSTOMER"/></h2>
					<p><fmt:message key="SHOPCART_CHECKOUT_WITHOUT_SIGNING"/></p>
					<br />
					<p><fmt:message key="SHOPCART_TEXT1"/></p>
					<br />
					<p><fmt:message key="SHOPCART_TEXT2"/></p>
					<div class="new_button" id="WC_CheckoutLogonf_div_2">
						<div class="button_align" id="WC_CheckoutLogonf_div_3">
							<a href="#" role="button" class="button_primary" id="guestShopperContinue" onclick="javascript:if(CheckoutHelperJS.canCheckoutContinue('<c:out value="${userType}"/>') && CheckoutHelperJS.updateShoppingCart(document.ShopCartForm,true)){TealeafWCJS.processDOMEvent(event);ShipmodeSelectionExtJS.guestShopperContinue('<c:out value='${OrderCalculateURL}'/>', '<c:out value='${PhysicalStoreSelectionURL}'/>');}return false;">
								<div class="left_border"></div>
								<div class="button_text"><fmt:message key="SHOPCART_CONTINUE" /></div>
								<div class="right_border"></div>
							</a>
						</div>
					</div>
				</div>			

				<div class="returning" id="WC_CheckoutLogonf_div_4">
					<h2><fmt:message key="SHOPCART_TEXT3"/></h2>
					<p><fmt:message key="SHOPCART_TEXT4"/></p>
					<br />
					<p><label for="WC_CheckoutLogon_FormInput_logonId"><fmt:message key="SHOPCART_USERNAME"/></label></p>
					<p>
						<input id="WC_CheckoutLogon_FormInput_logonId" name="logonId" type="text" size="25" onchange="javaScript:TealeafWCJS.processDOMEvent(event);" onkeypress="if(event.keyCode==13){javascript:if(CheckoutHelperJS.canCheckoutContinue() && CheckoutHelperJS.updateShoppingCart(document.ShopCartForm,true)){ShipmodeSelectionExtJS.guestShopperLogon('javascript:LogonForm.SubmitAjaxLogin(document.AjaxLogon)', '<c:out value='${orderMove}'/>', '<c:out value='${OrderCalculateURL}'/>', '<c:out value='${PhysicalStoreSelectionURL}'/>');}}" />
					</p>
					<br />
					<p><label for="WC_CheckoutLogon_FormInput_logonPassword"><fmt:message key="SHOPCART_PASSWORD"/></label></p>
					<p>
						<input id="WC_CheckoutLogon_FormInput_logonPassword" name="logonPassword" type="password" autocomplete="off" size="25" onchange="javaScript:TealeafWCJS.processDOMEvent(event);" onkeypress="if(event.keyCode==13){javascript:if(CheckoutHelperJS.canCheckoutContinue() && CheckoutHelperJS.updateShoppingCart(document.ShopCartForm,true)){ShipmodeSelectionExtJS.guestShopperLogon('javascript:LogonForm.SubmitAjaxLogin(document.AjaxLogon)', '<c:out value='${orderMove}'/>', '<c:out value='${OrderCalculateURL}'/>', '<c:out value='${PhysicalStoreSelectionURL}'/>');}}" />
					</p>
					<p><a href="<c:out value="${ForgetPasswordURL}"/>" class="myaccount_link hover_underline" id="WC_CheckoutLogonf_links_1"><fmt:message key="SHOPCART_FORGOT"/></a></p>
					<div class="returning_button" id="WC_CheckoutLogonf_div_5">
						<div class="button_align" id="WC_CheckoutLogonf_div_6">
							<a href="#" role="button" class="button_primary" id="guestShopperLogon" onclick="javascript:TealeafWCJS.processDOMEvent(event);if(CheckoutHelperJS.canCheckoutContinue() && CheckoutHelperJS.updateShoppingCart(document.ShopCartForm,true)){ShipmodeSelectionExtJS.guestShopperLogon('javascript:LogonForm.SubmitAjaxLogin(document.AjaxLogon)', '<c:out value='${orderMove}'/>', '<c:out value='${OrderCalculateURL}'/>', '<c:out value='${PhysicalStoreSelectionURL}'/>');}return false;">
								<div class="left_border"></div>
								<div class="button_text"><fmt:message key="SHOPCART_SIGNIN" /></div>
								<div class="right_border"></div>
							</a>
						</div>
					</div>
				</div>
			</div>
		</div>
	 	<br clear="all" />
	 	<br />
	</form>
</c:if>

<div id="WC_CheckoutLogonf_div_9">
	<c:if test="${userType != 'G'}">
		<div class="left" id="shopcartCheckoutButton">
			<c:choose>
				<c:when test="${requestScope.allContractsValid}">
					<div class="button_align left" id="WC_CheckoutLogonf_div_10">
					<a href="#" role="button" class="button_primary" id="shopcartCheckout" tabindex="0" onclick="javascript:TealeafWCJS.processDOMEvent(event);if(CheckoutHelperJS.canCheckoutContinue('<c:out value="${userType}"/>') && CheckoutHelperJS.updateShoppingCart(document.ShopCartForm,true)){ShipmodeSelectionExtJS.registeredUserContinue('<c:out value='${OrderCalculateURL}'/>', '<c:out value='${PhysicalStoreSelectionURL}'/>');}return false;">
				</c:when>
				<c:otherwise>
					<div class="disabled left" id="WC_CheckoutLogonf_div_10">
					<a role="button" class="button_primary" id="shopcartCheckout" tabindex="0" onclick="javascript:TealeafWCJS.processDOMEvent(event);setPageLocation('#')">
				</c:otherwise>
			</c:choose>
			<div class="left_border"></div>
			<div class="button_text"><fmt:message key="SHOPCART_CHECKOUT" /></div>
			<div class="right_border"></div>				
			</a>
			</div>	
			<c:if test="${quickCheckoutProfile}">
				<c:set var="quickOrderId" value="${quickOrder.orderIdentifier.uniqueID}"/>
				<div class="left" id="quickCheckoutButton">
					<div class="button_align" id="WC_CheckoutLogonf_div_13">
						<a href="#" role="button" class="button_primary button_left_padding" id="WC_CheckoutLogonf_links_2" tabindex="0" onclick="javascript:if(CheckoutHelperJS.canCheckoutContinue('<c:out value="${userType}"/>') && CheckoutHelperJS.updateShoppingCart(document.ShopCartForm,true)){setCurrentId('WC_CheckoutLogonf_links_2'); ShipmodeSelectionExtJS.updateCartWithQuickCheckoutProfile('<c:out value='${quickOrderId}'/>');}">
							<div class="left_border"></div>
							<div class="button_text"><fmt:message key="QUICKCHECKOUT" /></div>
							<div class="right_border"></div>
						</a>
					</div>
				</div>
			</c:if>
		</div>
	</c:if>

	<flow:ifDisabled feature="AjaxCheckout">
		<div class="left" id="updateShopCart"> 
			<div class="button_align" id="WC_CheckoutLogonf_div_14">
				<a href="#" role="button" class="button_primary" id="ShoppingCart_NonAjaxUpdate" tabindex="0" onclick="javascript:CheckoutHelperJS.updateShoppingCart(document.ShopCartForm,false);return false;">
					<div class="left_border"></div>
					<div class="button_text"><fmt:message key="SHOPCART_UPDATE" /></div>
					<div class="right_border"></div>
				</a>
			</div>
		</div>	
		<br/>
		<br/>
	</flow:ifDisabled>
</div>
<%@ include file="CheckoutLogonEIExt.jspf"%>
<!-- END CheckoutLogon.jsp -->
