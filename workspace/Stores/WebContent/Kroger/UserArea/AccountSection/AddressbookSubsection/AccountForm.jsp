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
<!-- BEGIN AccountForm.jsp -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ include file="../../../Common/EnvironmentSetup.jspf" %>
<%@ include file="../../../Common/nocache.jspf" %>
<%-- ErrorMessageSetup.jspf is used to retrieve an appropriate error message when there is an error --%>
<%@ include file="../../../include/ErrorMessageSetup.jspf" %>


	
	<form name="AddressForm" method="post" action="PersonChangeServiceAddressAdd" id="AddressForm">
		<input type="hidden" name="storeId" value="<c:out value="${storeId}" />" id="WC_AccountForm_inputs_4"/>
		<input type="hidden" name="catalogId" value="<c:out value="${catalogId}" />" id="WC_AccountForm_inputs_5"/>
		<input type="hidden" name="langId" value="<c:out value="${langId}" />" id="WC_AccountForm_inputs_6"/>
		<input type="hidden" name="status" value="ShippingAndBilling" id="WC_AccountForm_inputs_7"/>
		<flow:ifDisabled feature="AjaxMyAccountPage">
			<input type="hidden" name="page" value="addressbook" id="WC_QuickCheckoutProfileForm_FormInput_page_In_QuickCheckout_1"/>
			<input type="hidden" name="URL" value="LogonForm?page=addressbook" id="WC_AddressForm_FormInput_URL_In_AddressForm_3"/>
			<input type="hidden" name="errorViewName" value="NonAjaxAddressBookForm" id="WC_AddressForm_FormInput_errorViewName_In_AddressForm_6"/>
			<input type="hidden" name="myAcctMain" value="1" id="WC_AddressForm_inputs_8"/>
		</flow:ifDisabled>
		
		<input type="hidden" name="addressType" value="" id="WC_AccountForm_inputs_8"/>
		<input type="hidden" name="authToken" value="${authToken}" id="WC_AccountForm_inputs_authToken_1"/>
		<flow:ifDisabled feature="AjaxMyAccountPage">

				<input type="hidden" name="nickName" value="" id="nickName"/>
				<input type="hidden" name="addressId" value="" id="addressId"/>
		
		</flow:ifDisabled>
		<div class="headingtext" id="WC_AccountForm_div_1">
		</div>
		<div class="headingtext" id="WC_AccountForm_div_2">
			<div class="form_2column" id="WC_AccountForm_div_3">
			<div class="align" id="WC_AccountForm_div_4">
			<div id="addr_title"><h2 class="status_msg"><c:out value='${param.nickName}'/></h2></div>
				<input type="hidden" var="addresstype" value="<c:out value="${param.addressType}"/>" id="WC_AccountForm_inputs_1"/>
				<fieldset>
				<div class="label_spacer" id="WC_AccountForm_div_5">
					<legend><fmt:message key="AB_CHOOSE"/></legend>
				</div>
				<div id="WC_AccountForm_div_6">
					<input name="sbAddress" id="WC_AccountForm_sbAddress_1" type="radio" class="radio" value="Shipping" <c:if test="${param.addressType == 'Shipping'}">checked</c:if>/>&nbsp;<label for="WC_AccountForm_sbAddress_1"><fmt:message key="SHIPPING_ADDRESS2"/></label>
				</div>
				<div id="WC_AccountForm_div_7">
					<input name="sbAddress" id="WC_AccountForm_sbAddress_2" type="radio" class="radio" value="Billing" <c:if test="${param.addressType == 'Billing'}">checked</c:if>/>&nbsp;<label for="WC_AccountForm_sbAddress_2"><fmt:message key="BILLINGADDRESS"/></label>
				</div>
				<div id="WC_AccountForm_div_8">
					<input name="sbAddress" id="WC_AccountForm_sbAddress_3" type="radio"  class="radio" value="ShippingAndBilling" <c:if test="${param.addressType == 'ShippingAndBilling' || empty param.addressType}">checked</c:if>/>&nbsp;<label for="WC_AccountForm_sbAddress_3"><fmt:message key="AB_SBADDR"/></label>
				</div>
				</fieldset>
			</div>
			
				<div id="WC_AccountForm_div_9">	
					<div class="column" id="WC_AccountForm_div_10">
						<span class="required-field" id="WC_AccountForm_div_11"> * </span><fmt:message key="REQUIRED_FIELDS"/>
					</div>
					<br clear="all"/>
					<flow:ifDisabled feature="AjaxMyAccountPage"> <br clear="all"/> </flow:ifDisabled>
					
					<flow:ifEnabled feature="AjaxMyAccountPage">
					<div class="column" id="WC_AccountForm_div_12">
						<c:choose>
							<c:when test="${param.addressId eq 'empty'}"><br/>
								<div class="label_spacer" id="WC_AccountForm_div_13">
									<span class="spanacce">
									<label for="nickName">
									<fmt:message key="AB_RECIPIENT"/>
									</label>
									</span>
									<span class="required-field" id="WC_AccountForm_div_14"> *</span>
								<fmt:message key="AB_RECIPIENT"/></div>
								<div id="WC_AccountForm_div_15">
									<input size="35" maxlength="128" type="text" aria-required="true" name="nickName" id="nickName" value="<c:out value='${param.nickName}'/>"/>
								</div>
							</c:when>
							<c:otherwise>
								<div id="WC_AccountForm_div_16">
									<input type="hidden" name="addressId" value="<c:out value='${param.addressId}'/>" id="WC_AccountForm_inputs_2"/>
									<input type="hidden" name="nickName" value="<c:out value='${param.nickName}'/>" id="WC_AccountForm_inputs_3"/>
								</div>
							</c:otherwise>
						</c:choose>
					</div>
					
					<br clear="all"/>
					</flow:ifEnabled>
						<%@ include file="../../../Snippets/ReusableObjects/AddressBookAddressEntryFormDisplay.jspf" %>
				</div>
			</div>
		</div>
		<br clear="all" />

	</form>
	<br />
<!-- END AccountForm.jsp -->
