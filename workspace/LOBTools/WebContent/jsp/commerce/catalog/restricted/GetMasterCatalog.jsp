<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2011 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>
<%--
	==========================================================================
	Call the get service for catalog to retrieve the
	master catalog for the store currently selected.
	==========================================================================
--%>
<c:choose>
	<c:when test="${(param.catalogViewRole == true) || (param.marketingViewRole == true) || (param.promotionViewRole == true) || (param.attachmentViewRole == true) || (param.pricingViewRole == true) || (param.layoutViewRole == true)}">
		<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogType"
			var="masterCatalog"
			expressionBuilder="getMasterCatalog">
			<wcf:contextData name="storeId" data="${param.storeId}"/>
		</wcf:getData>
		
		<wcf:getData
			type="com.ibm.commerce.infrastructure.facade.datatypes.ConfigurationType"
			var="searchEnabled" expressionBuilder="findByUniqueID">
			<wcf:contextData name="storeId" data="${param.storeId}" />
			<wcf:param name="uniqueId"
				value="com.ibm.commerce.foundation.search" />
		</wcf:getData>
		
		
		<values>
			<masterCatalogId>${masterCatalog.catalogIdentifier.uniqueID}</masterCatalogId>
			<masterCatalogIdentifier><wcf:cdata data="${masterCatalog.catalogIdentifier.externalIdentifier.identifier}"/></masterCatalogIdentifier>
			<masterCatalogStoreId>${masterCatalog.catalogIdentifier.externalIdentifier.storeIdentifier.uniqueID}</masterCatalogStoreId>
			<c:forEach var="attribute"	items="${searchEnabled.configurationAttribute}">
				<c:if test="${attribute.primaryValue.name=='searchEnabled'}">
					<searchEnabled>${attribute.primaryValue.value}</searchEnabled>
				</c:if>
			</c:forEach>
		</values>
	</c:when>
	<c:otherwise>
		<values/>
	</c:otherwise>
</c:choose>
