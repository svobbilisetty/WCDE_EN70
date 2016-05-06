<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2008 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!-- BEGIN AccountAddressForm.jsp -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ include file="../../../Common/EnvironmentSetup.jspf" %>
<%@ include file="../../../Common/nocache.jspf" %>
<%-- ErrorMessageSetup.jspf is used to retrieve an appropriate error message when there is an error --%>
<%@ include file="../../../include/ErrorMessageSetup.jspf" %>
<%@ include file="../../../Snippets/ReusableObjects/AddressHelperCountrySelection.jspf" %>


<script type="text/javaScript"></script>

<wcbase:useBean id="countryBean" classname="com.ibm.commerce.user.beans.CountryStateListDataBean">
	<c:set target="${countryBean}" property="countryCode" value="${contact.address.country}"/>
</wcbase:useBean>

<c:set var="type" value="${WCParam.type}"/>

<c:set var="addressId" value="${WCParam.addressId}"/>

<c:choose>
<c:when test="${addressId eq 'empty'}" >
	<jsp:include page="../AddressbookSubsection/AccountForm.jsp" flush="true">
			<jsp:param name="addressId" value="empty" />
	</jsp:include>
</c:when>
<c:otherwise>
	<wcf:getData type="com.ibm.commerce.member.facade.datatypes.PersonType" 
				var="person" expressionBuilder="findCurrentPerson">
		<wcf:param name="accessProfile" value="IBM_All" />
	</wcf:getData>
	<c:set var="personAddresses" value="${person.addressBook}"/>
	
	<c:set var="shownAddress" value="false"/>
	<c:set var="contact" value="${person.contactInfo}"/>
	<c:if test="${contact.contactInfoIdentifier.uniqueID eq addressId}" >	
		<c:set var="final" value="${contact}"/>
		<jsp:include page="../AddressbookSubsection/AccountForm.jsp" flush="true">
			<jsp:param name="addressId" value="${final.contactInfoIdentifier.uniqueID}" />
			<jsp:param name="nickName" value="${final.contactInfoIdentifier.externalIdentifier.contactInfoNickName}" />
			<jsp:param name="firstName" value="${final.contactName.firstName}"/>
			<jsp:param name="lastName" value="${final.contactName.lastName}"/>
			<jsp:param name="address1" value="${final.address.addressLine[0]}"/>
			<jsp:param name="address2" value="${final.address.addressLine[1]}"/>
			<jsp:param name="city" value="${final.address.city}"/>
			<jsp:param name="state" value="${final.address.stateOrProvinceName}"/>
			<jsp:param name="countryReg" value="${final.address.country}"/>
			<jsp:param name="zipCode" value="${final.address.postalCode}"/>
			<jsp:param name="phone" value="${final.telephone1.value}"/>
			<jsp:param name="email1" value="${final.emailAddress1.value}"/>
			<jsp:param name="addressType" value="${final.address.type_}"/>
		</jsp:include>
		<c:set var="shownAddress" value="true"/>
	</c:if>
	<c:if test="${!shownAddress}" >
		<c:forEach items="${personAddresses.contact}" var="contact">
			<c:if test="${contact.contactInfoIdentifier.uniqueID eq addressId}" >
				<c:set var="final" value="${contact}"/>
				<jsp:include page="../AddressbookSubsection/AccountForm.jsp" flush="true">
					<jsp:param name="addressId" value="${final.contactInfoIdentifier.uniqueID}" />
					<jsp:param name="nickName" value="${final.contactInfoIdentifier.externalIdentifier.contactInfoNickName}" />
					<jsp:param name="firstName" value="${final.contactName.firstName}"/>
					<jsp:param name="lastName" value="${final.contactName.lastName}"/>
					<jsp:param name="address1" value="${final.address.addressLine[0]}"/>
					<jsp:param name="address2" value="${final.address.addressLine[1]}"/>
					<jsp:param name="city" value="${final.address.city}"/>
					<jsp:param name="state" value="${final.address.stateOrProvinceName}"/>
					<jsp:param name="countryReg" value="${final.address.country}"/>
					<jsp:param name="zipCode" value="${final.address.postalCode}"/>
					<jsp:param name="phone" value="${final.telephone1.value}"/>
					<jsp:param name="email1" value="${final.emailAddress1.value}"/>
					<jsp:param name="addressType" value="${final.address.type_}"/>
				</jsp:include>
				<c:set var="shownAddress" value="true"/>
			</c:if>
		</c:forEach>
	</c:if>
</c:otherwise>
</c:choose>
<!-- END AccountAddressForm.jsp -->
