<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2008, 2009 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%-- 
  ***
  * This jsp displays the address details of a physical store given a physical store addressId.
  * The address is displayed according to the current selected locale's preferences.
  ***
--%>
<!-- BEGIN DOMAddressDisplay.jsp -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ include file="../../../Common/EnvironmentSetup.jspf"%>

<c:set var="physicalStoreId" value="${WCParam.physicalStoreId}"/>
<c:if test="${empty WCParam.physicalStoreId}" >
	<c:set var="physicalStoreId" value="${param.physicalStoreId}"/>
</c:if>

<c:if test="${!empty physicalStoreId}" >

	<wcf:getData type="com.ibm.commerce.store.facade.datatypes.PhysicalStoreType"
			 var="physicalStore" varException="physicalStoreException" expressionBuilder="findPhysicalStoresByUniqueIDs">
		<wcf:param name="accessProfile" value="IBM_Store_Details" />
		<wcf:param name="uniqueId" value="${physicalStoreId}" />	
	</wcf:getData>
	
	<c:set var="contact" value="${physicalStore.locationInfo}"/>
	<%@ include file="../../ReusableObjects/AddressDisplay.jspf"%>
</c:if>
<!-- END DOMAddressDisplay.jsp -->
