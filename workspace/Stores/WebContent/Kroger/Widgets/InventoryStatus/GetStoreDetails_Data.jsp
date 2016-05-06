<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2008, 2011 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%-- 
  ***
  * This jsp populates the data required by the physical store details section of the product display page.
  * It creates a JSON object which is returned to the client from the AJAX call.
  ***
--%>

<%@ include file="../../Common/EnvironmentSetup.jspf" %>

<wcf:getData type="com.ibm.commerce.store.facade.datatypes.PhysicalStoreType[]"
		     var="physicalStore" varException="physicalStoreException" expressionBuilder="findPhysicalStoresByUniqueIDs">
	<wcf:param name="accessProfile" value="IBM_Store_Details" />
	<wcf:param name="uniqueId" value="${param.physicalStoreId}" />	
</wcf:getData>

<c:set var="hours" value=""/>
<c:forEach var="attribute" items="${physicalStore[0].attribute}">
	<c:if test="${attribute.name eq 'StoreHours'}">
		<c:set var="hours" value="${fn:escapeXml(attribute.displayValue)}"/>
	</c:if>
</c:forEach>
<%-- Prepares the json object to be returned --%>
<c:set var="address" value="{
	name: '${fn:escapeXml(physicalStore[0].physicalStoreIdentifier.externalIdentifier)}',
	addressLine: '${fn:escapeXml(physicalStore[0].locationInfo.address.addressLine[0])}',
	city: '${fn:escapeXml(physicalStore[0].locationInfo.address.city)}',
	stateOrProvinceName: '${fn:escapeXml(physicalStore[0].locationInfo.address.stateOrProvinceName)}',
	postalCode: '${fn:escapeXml(physicalStore[0].locationInfo.address.postalCode)}',
	country: '${fn:escapeXml(physicalStore[0].locationInfo.address.country)}',
	telephone: '${fn:escapeXml(physicalStore[0].locationInfo.telephone1.value)}'}"/>
/*
{
address: ${address},
hours: '${hours}'
}
*/
