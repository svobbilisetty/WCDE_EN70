<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2009 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%-- 
  ***
  * This jsp displays the address details given an addressId.
  ***
--%>
<!-- BEGIN AddressDisplay.jsp -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ include file="../../../Common/EnvironmentSetup.jspf" %>

<c:set var="addressId" value="${WCParam.addressId}"/>
<c:if test="${empty WCParam.addressId}" >
	<c:set var="addressId" value="${param.addressId}"/>
</c:if>

<c:if test='${param.email != "true"}'>
	<script type="text/javascript">
		dojo.addOnLoad(function() {
			console.debug("addressId= " + "<c:out value="${addressId}"/>");
			console.debug("mode= " + "<c:out value="${mode}"/>");
		});
	</script>
</c:if>

<c:if test="${!empty addressId && addressId != -1}" >
	
	<c:set var="person" value="${requestScope.person}"/>
	<c:if test="${empty person || person==null}">
		<wcf:getData type="com.ibm.commerce.member.facade.datatypes.PersonType" 
					var="person" expressionBuilder="findCurrentPerson" scope="request">
			<wcf:param name="accessProfile" value="IBM_All" />
		</wcf:getData>
	</c:if>
	<c:set var="personAddresses" value="${person.addressBook}"/>
	
	<c:set var="addressFieldsValid" value="true"/>
	<c:set var="shownAddress" value="false"/>
	<c:set var="contact" value="${person.contactInfo}"/>
	<c:if test="${contact.contactInfoIdentifier.uniqueID eq addressId}" >	
		<%@ include file="../../ReusableObjects/AddressDisplay.jspf"%>
		<c:set var="shownAddress" value="true"/>
		<c:choose>
			<c:when test="${!empty contact.address.addressLine[0] && contact.address.addressLine[0] != '-' && !empty contact.address.country && contact.address.country != '-'}" >
				<c:set var="addressFieldsValid" value="true"/>
			</c:when>
			<c:otherwise>
				<c:set var="addressFieldsValid" value="false"/>
			</c:otherwise>
		</c:choose>
	</c:if>
	<c:if test="${!shownAddress}" >
		<c:forEach items="${personAddresses.contact}" var="contact">
			<c:if test="${contact.contactInfoIdentifier.uniqueID eq addressId}" >
				<%@ include file="../../ReusableObjects/AddressDisplay.jspf"%>
				<c:set var="shownAddress" value="true"/>
				<c:choose>
					<c:when test="${!empty contact.address.addressLine[0] && contact.address.addressLine[0] != '-' && !empty contact.address.country && contact.address.country != '-'}" >
						<c:set var="addressFieldsValid" value="true"/>
					</c:when>
					<c:otherwise>
						<c:set var="addressFieldsValid" value="false"/>
					</c:otherwise>
				</c:choose>
			</c:if>
		</c:forEach>
	</c:if>
	
	<c:catch>
		<%-- Display the Organization Address from the contract --%>
		<c:set var="activeOrgId" value="${CommandContext.activeOrganizationId}"/>
		<c:if test="${!shownAddress}">
			<c:set var="organization" value="${requestScope.organization}"/>
			<c:if test="${empty organization || organization==null}">
				<wcf:getData type="com.ibm.commerce.member.facade.datatypes.OrganizationType" 
							var="organization" expressionBuilder="findByUniqueID" scope="request">
					<wcf:param name="organizationId" value="${activeOrgId}" />
					<wcf:param name="accessProfile" value="IBM_All" />
				</wcf:getData>
			</c:if>
			<c:set var="organizationAddresses" value="${organization.addressBook}"/>
			<c:set var ="contact" value="${organization.contactInfo}"/>
			<c:if test="${contact.contactInfoIdentifier.uniqueID eq addressId}">
				<%@ include file="../../ReusableObjects/AddressDisplay.jspf"%>	
				<c:set var ="shownAddress" value="true"/>
				<c:choose>
					<c:when test="${!empty contact.address.addressLine[0] && contact.address.addressLine[0] != '-' && !empty contact.address.country && contact.address.country != '-'}" >
						<c:set var="addressFieldsValid" value="true"/>
					</c:when>
					<c:otherwise>
						<c:set var="addressFieldsValid" value="false"/>
					</c:otherwise>
				</c:choose>
			</c:if>
			<c:if test="${!shownAddress}" >
				<c:forEach items="${organizationAddresses.contact}" var="contact">
					<c:if test="${contact.contactInfoIdentifier.uniqueID eq addressId}" >
						<%@ include file="../../ReusableObjects/AddressDisplay.jspf"%>
						<c:set var="shownAddress" value="true"/>
						<c:choose>
							<c:when test="${!empty contact.address.addressLine[0] && contact.address.addressLine[0] != '-' && !empty contact.address.country && contact.address.country != '-'}" >
								<c:set var="addressFieldsValid" value="true"/>
							</c:when>
							<c:otherwise>
								<c:set var="addressFieldsValid" value="false"/>
							</c:otherwise>
						</c:choose>
					</c:if>
				</c:forEach>
			</c:if>
		</c:if>
	</c:catch>
	<c:if test="${param.fromPage == 'BillingInfo'}">
		<input type="hidden" name="billing_address_isValid" id="billing_address_isValid_<c:out value="${param.count}"/>" value="${addressFieldsValid}"/>
	</c:if>
</c:if>
<!-- END AddressDisplay.jsp -->
