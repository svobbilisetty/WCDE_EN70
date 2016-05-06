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
  ***
  * This jsp displays a select box with all applicable shipping addresses.
  ***
--%>
<!-- BEGIN ShippingAddressSelect.jsp -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ include file="../../../Common/EnvironmentSetup.jspf"%>

<c:set var="pageSize" value="${WCParam.pageSize}" />
<c:if test="${empty pageSize}">
	<c:set var="pageSize" value="${maxOrderItemsPerPage}"/>
</c:if>

<c:set var="beginIndex" value="${WCParam.beginIndex}" />
 <c:if test="${empty beginIndex}">
	<c:set var="beginIndex" value="0" />
</c:if>

<c:set var="orderShipInfo" value="${requestScope.orderUsableShipping}"/>
<c:if test="${empty orderShipInfo || orderShipInfo==null}">
	<c:choose>
		<c:when test="${empty param.orderId || param.orderId == null}">
			<wcf:getData type="com.ibm.commerce.order.facade.datatypes.OrderType"
		  			 var="orderShipInfo" expressionBuilder="findCurrentShoppingCart">
		   		<wcf:param name="accessProfile" value="IBM_UsableShippingInfo" />
			</wcf:getData>
		</c:when>
		<c:otherwise>
			<wcf:getData type="com.ibm.commerce.order.facade.datatypes.OrderType"
			   		var="orderShipInfo" expressionBuilder="findUsableShippingInfoWithPagingOnItem" varShowVerb="ShowVerbUsableShippingInfo" maxItems="${pageSize}" recordSetStartNumber="${beginIndex}" recordSetReferenceId="usistatus" scope="request">
				<wcf:param name="orderId" value="${param.orderId}" />	
				<wcf:param name="accessProfile" value="IBM_UsableShippingInfo" />
			</wcf:getData>	
		</c:otherwise>
	</c:choose>
</c:if>

<%-- Get the OrderDataBean to check whether the personal shipping address is allowed for each of the order item --%>
<c:if test="${empty requestScope.orderBean || requestScope.orderBean==null}">
	<wcbase:useBean id="orderBean" classname="com.ibm.commerce.order.beans.OrderDataBean" scope="request">
		<c:set value="${orderShipInfo.orderIdentifier.uniqueID}" target="${orderBean}" property="orderId"/>
	</wcbase:useBean>
</c:if>

<c:set var="selectedAddressId" value="${param.addressId}"/>
<c:set var="hasValidAddresses" value="false"/>

<c:if test="${empty selectedAddressId}">
	<c:set var="order" value="${requestScope.order}" />
	<c:if test="${empty order || order==null}">
		<wcf:getData type="com.ibm.commerce.order.facade.datatypes.OrderType"
			var="order" expressionBuilder="findCurrentShoppingCartWithPagingOnItem" varShowVerb="ShowVerbShipment" maxItems="${pageSize}" recordSetStartNumber="${beginIndex}" recordSetReferenceId="ostatus">
			<wcf:param name="accessProfile" value="IBM_Details" />	 
			<wcf:param name="sortOrderItemBy" value="orderItemID" />
			<wcf:param name="isSummary" value="false" />
		</wcf:getData>
	</c:if>
	<c:set var="selectedAddressId" value="${order.orderItem[0].orderItemShippingInfo.shippingAddress.contactInfoIdentifier.uniqueID}"/>
</c:if>

<wcf:url var="AddressDisplayURL" value="AjaxAddressDisplayView" type="Ajax">
  <wcf:param name="langId" value="${langId}" />						
  <wcf:param name="storeId" value="${WCParam.storeId}" />
  <wcf:param name="catalogId" value="${WCParam.catalogId}" />
</wcf:url>

<!-- this context is for dealing with states for the shipping addresses in all shipments -->
<script type="text/javascript">
	wc.render.declareContext("shippingAddressContext",{shippingAddress: "0"},"");

	wc.render.declareRefreshController({
		id: "shippingAdddressDisplayAreaController",
		renderContext: wc.render.getContextById("shippingAddressContext"),
		url: "${AddressDisplayURL}",
		formId: ""

		,renderContextChangedHandler: function(message, widget) {
			var controller = this;
			var renderContext = this.renderContext;
			if (controller.testForChangedRC(["shippingAddress"])) {
				var addressId = renderContext.properties["shippingAddress"];
				widget.refresh({"addressId": addressId});
			}
			cursor_clear();
		}

	});

</script>

<c:set var="search01" value="'"/>
<c:set var="replaceStr01" value="\\'"/>

<fmt:message var="profileshipping" key="QC_DEFAULT_SHIPPING"/>
<fmt:message var="profilebilling"  key="QC_DEFAULT_BILLING"/>

<c:set var="person" value="${requestScope.person}"/>
<c:if test="${empty person || person==null}">
	<wcf:getData type="com.ibm.commerce.member.facade.datatypes.PersonType" 
				var="person" expressionBuilder="findCurrentPerson" scope="request">
		<wcf:param name="accessProfile" value="IBM_All" />
	</wcf:getData>
</c:if>
<c:catch>
	<c:set var="activeOrgId" value="${CommandContext.activeOrganizationId}"/>
	<c:set var="organization" value="${requestScope.organization}" />
	<c:if test="${empty organization || organization==null}">
			<wcf:getData type="com.ibm.commerce.member.facade.datatypes.OrganizationType" 
				var="organization" expressionBuilder="findByUniqueID" scope="request">
				<wcf:param name="organizationId" value="${activeOrgId}" />
				<wcf:param name="accessProfile" value="IBM_All" />
			</wcf:getData>
	</c:if>
	<c:set var="organizationAddresses" value="${organization.addressBook}"/>
	<c:set var ="contact" value="${organization.contactInfo}"/>
	<c:set var = "existingContactOrgAddress" value="${contactOrgAddress}"/>
	<c:set var ="contactOrgAddress" value="${contact.contactInfoIdentifier.uniqueID}" scope="request"/>
	<c:forEach items="${organizationAddresses.contact}" var="contact">
		<c:choose>
			<c:when test="${empty contactOrgAddress || contactOrgAddress eq null}">
				<c:set var="contactOrgAddress" value="${contact.contactInfoIdentifier.uniqueID}" scope="request"/>
			</c:when>
			<c:otherwise>
				<c:set var="contactOrgAddress" value="${contactOrgAddress},${contact.contactInfoIdentifier.uniqueID}" scope="request"/>
			</c:otherwise>
		</c:choose>
	</c:forEach>
	<c:if test="${empty existingContactOrgAddress}">
		<input type="hidden" id="shippingOrganizationAddressList" value="${contactOrgAddress}" name="shippingOrganizationAddressList"/>
	</c:if>
</c:catch>

<div class="shipping_address" id="WC_ShippingAddressSelectSingle_div_1">
	<p class="title"><label for="singleShipmentAddress"><fmt:message key="SHIP_SHIPPING_ADDRESS_COLON"/></label></p>
	<div class="shipping_address_content">
	<p>
	   <select class="drop_down_shipping" name="singleShipmentAddress" id="singleShipmentAddress" onChange="JavaScript:setCurrentId('singleShipmentAddress'); CheckoutHelperJS.displayAddressDetails(this.value,'Shipping');CheckoutHelperJS.updateAddressForAllItems(this);CheckoutHelperJS.showHideEditAddressLink(this,'<c:out value='${param.orderId}'/>')">
			<c:forEach var="contactInfoIdentifier" items="${orderShipInfo.usableShippingAddress}">
				<c:set var="hasValidAddresses" value="true"/>
				<option value="<c:out value='${contactInfoIdentifier.uniqueID}'/>"
					<c:if test="${selectedAddressId eq contactInfoIdentifier.uniqueID}" >
						selected="selected"
					</c:if>
				>
					<c:set var="contactInfoNickName" value="${contactInfoIdentifier.externalIdentifier.contactInfoNickName}"/>
					<c:choose>
						<c:when test="${contactInfoNickName eq  profileShippingNickname}"><fmt:message key="QC_DEFAULT_SHIPPING"/></c:when>
						<c:when test="${contactInfoNickName eq  profileBillingNickname}"><fmt:message key="QC_DEFAULT_BILLING"/></c:when>
						<c:otherwise>${contactInfoNickName}</c:otherwise>
					</c:choose>
				</option>
			</c:forEach>
			<%@ include file="SingleShippingAddressSelectExt.jspf" %>
			<%@ include file="GiftRegistrySingleShippingAddressSelectExt.jspf" %>
		</select>
	</p>

	<!-- Area where selected shipping Address details is showed in short.. Needed only in case of Ajax Checkout -->
	<flow:ifEnabled feature="AjaxCheckout"> 
		<span id="shippingAddressDisplayArea_ACCE_Label" class="spanacce"><fmt:message key="ACCE_Region_Shipping"/></span>
		<div dojoType="wc.widget.RefreshArea" id="shippingAddressDisplayArea" widgetId="shippingAddressDisplayArea" controllerId="shippingAdddressDisplayAreaController" ariaMessage="<fmt:message key="ACCE_Status_Shipping_Updated"/>" ariaLiveId="${ariaMessageNode}" role="region" aria-labelledby="shippingAddressDisplayArea_ACCE_Label">
			<!-- This value is equal to value in struts-config-ext.xml for view Name AjaxAddressDisplayView -->
			<c:import url="/${sdb.jspStoreDir}/Snippets/Member/Address/AddressDisplay.jsp">
				<c:param name="addressId" value= "${selectedAddressId}"/>
			</c:import>
		</div>
		<script type="text/javascript">
			dojo.addOnLoad(function() { 
				parseWidget("shippingAddressDisplayArea");
			});
		</script>
	</flow:ifEnabled> 

	<!-- If its a non-ajax checkout page, then we should get all the address details during page load and use div show/hide logic -->
	<flow:ifDisabled feature="AjaxCheckout"> 
		<c:set var="displayMethod" value="display:none" />
		<c:forEach var="contactInfoIdentifier" items="${orderShipInfo.usableShippingAddress}">
			<c:if test="${selectedAddressId eq contactInfoIdentifier.uniqueID}" >
				<!-- Show the address details div for this addressId -->
				<c:set var="displayMethod" value="display:block" />
			</c:if>
			<div id="addressDetails_<c:out value="${contactInfoIdentifier.uniqueID}"/>" style="<c:out value="${displayMethod}"/>">
				<c:import url="/${sdb.jspStoreDir}/Snippets/Member/Address/AddressDisplay.jsp">
					<c:param name="addressId" value= "${contactInfoIdentifier.uniqueID}"/>
				</c:import>
			</div>
			<c:set var="displayMethod" value="display:none" />
			</c:forEach>
			<!-- One empty div for the option "Please Select" -->
			<div id="addressDetails_-1" style="display:block">
			</div>
	</flow:ifDisabled>
<%-- Use the value of personalAddressAllowed to hide/show the create/edit address link. --%>
<c:if test="${orderBean.personalAddressesAllowedForShipping}">
	<!-- Show Edit button only if there are any valid address.. -->
	<c:if test="${selectedAddressId != -1}" >
		<br/>
		<div class="editAddressLink hover_underline" id="editAddressLink_<c:out value='${param.orderId}'/>" style="display:block;">
			<a class="tlignore" href="JavaScript:CheckoutHelperJS.editAddress('singleShipmentAddress','-1','<c:out value='${fn:replace(profileshipping,search01,replaceStr01)}'/>','<c:out value='${fn:replace(profilebilling,search01,replaceStr01)}'/>');CheckoutHelperJS.setLastAddressLinkIdToFocus('WC_ShippingAddressSelectSingle_link_1');" id="WC_ShippingAddressSelectSingle_link_1">
				<img src="<c:out value='${jspStoreImgDir}'/>images/edit_icon.png" alt="" />
				<fmt:message key="ADDR_EDIT_ADDRESS"/>
			</a>
		</div>
		<wcf:url var="AddressEditView" value="AddressEditView" type="Ajax">
			<wcf:param name="langId" value="${WCParam.langId}" />
			<wcf:param name="storeId" value="${WCParam.storeId}" />
			<wcf:param name="catalogId" value="${WCParam.catalogId}" />
		</wcf:url>
	</c:if>
	
	<!-- new address link -->
	<div class="newShippingAddressButton hover_underline" id="newShippingAddressLink">
			<a class="tlignore" href="JavaScript:setCurrentId('singleShipmentAddress'); CheckoutHelperJS.addNewShippingAddress('Shipping');JavaScript:setCurrentId('singleShipmentAddress'); CheckoutHelperJS.updateAddressForAllItems('singleShipmentAddress');CheckoutHelperJS.setLastAddressLinkIdToFocus('WC_ShippingAddressSelectSingle_link_2');" id="WC_ShippingAddressSelectSingle_link_2">
				<img src="<c:out value='${jspStoreImgDir}${vfileColor}'/>table_plus_add.png" alt="" />
				<fmt:message key="ADDR_CREATE_ADDRESS"/>
			</a>
	</div>
</c:if>

<script type="text/javascript">
			dojo.addOnLoad(function() { 
				CheckoutHelperJS.showHideEditAddressLink(document.getElementById("singleShipmentAddress"),'<wcf:out value='${param.orderId}' escapeFormat='js'/>');
			});
</script>
	</div>
</div>
<!-- END ShippingAddressSelect.jsp -->
