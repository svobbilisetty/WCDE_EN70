<?xml version="1.0" encoding="UTF-8"?>

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
<%@page contentType="text/xml;charset=UTF-8"%>
<%
//* This JSP is responsible for getting the configuration for a specified store.
%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<wcf:getData type="com.ibm.commerce.infrastructure.facade.datatypes.ConfigurationType[]"
		var="configurations"
		expressionBuilder="findAll">
	<wcf:contextData name="storeId" data="${param.storeId}"/>
</wcf:getData>

<object objectType="Store">
	<storeId>${param.storeId}</storeId>
	<c:forEach var="config" items="${configurations}">
		<c:choose>
			<c:when test="${config.configurationIdentifier.uniqueID == 'com.ibm.commerce.foundation.supportedLanguages'}"><c:set var="objectType" value="StoreLanguage"/></c:when>
			<c:when test="${config.configurationIdentifier.uniqueID == 'com.ibm.commerce.foundation.supportedCurrencies'}"><c:set var="objectType" value="StoreCurrency"/></c:when>
			<c:when test="${config.configurationIdentifier.uniqueID == 'com.ibm.commerce.foundation.defaultCurrency'}"><c:set var="objectType" value="StoreDefaultCurrency"/></c:when>
			<c:when test="${config.configurationIdentifier.uniqueID == 'com.ibm.commerce.foundation.inventorySystem'}"><c:set var="objectType" value="StoreInventorySystem"/></c:when>
			<c:when test="${config.configurationIdentifier.uniqueID == 'com.ibm.commerce.foundation.fulfillmentCenter'}"><c:set var="objectType" value="StoreFulfillmentCenter"/></c:when>
			<c:when test="${config.configurationIdentifier.uniqueID == 'com.ibm.commerce.foundation.staticContent'}"><c:set var="objectType" value="StoreStaticContent"/></c:when>
			<c:when test="${config.configurationIdentifier.uniqueID == 'com.ibm.commerce.foundation.shippingMode'}"><c:set var="objectType" value="StoreShippingMode"/></c:when>
			<c:when test="${config.configurationIdentifier.uniqueID == 'com.ibm.commerce.foundation.analytics'}"><c:set var="objectType" value="StoreAnalytics"/></c:when>
			<c:otherwise><c:set var="objectType" value=""/></c:otherwise>
		</c:choose>
		<c:if test="${objectType != ''}">
			<c:forEach var="attribute" items="${config.configurationAttribute}">
				<object objectType="${objectType}">
					<${attribute.primaryValue.name}><wcf:cdata data="${attribute.primaryValue.value}"/></${attribute.primaryValue.name}>
					<c:forEach var="additionalValue" items="${attribute.additionalValue}">
						<${additionalValue.name}><wcf:cdata data="${additionalValue.value}"/></${additionalValue.name}>
					</c:forEach>
				</object>
			</c:forEach>
		</c:if>
	</c:forEach>

<c:if test="${param.storeId != '0'}">
	<wcf:getData type="com.ibm.commerce.infrastructure.facade.datatypes.ConfigurationType"
		var="remoteWidgetsConfig" varException="e" expressionBuilder="findByUniqueID">
		<wcf:contextData name="storeId" data="${param.storeId}" />
		<wcf:param name="uniqueId" value="com.ibm.commerce.foundation.remoteWidgets" />
	</wcf:getData>
	<c:if test="${empty e}">
		<c:forEach var="attribute" items="${remoteWidgetsConfig.configurationAttribute}">
			<object objectType="StoreRemoteWidgets">
				<${attribute.primaryValue.name}><wcf:cdata data="${attribute.primaryValue.value}"/></${attribute.primaryValue.name}>
				<c:forEach var="additionalValue" items="${attribute.additionalValue}">
					<${additionalValue.name}><wcf:cdata data="${additionalValue.value}"/></${additionalValue.name}>
				</c:forEach>
			</object>
		</c:forEach>
	</c:if>
</c:if>
	
	<wcf:getData type="com.ibm.commerce.infrastructure.facade.datatypes.ConfigurationType"
		var="listPriceListConfig" expressionBuilder="findByUniqueID">
		<wcf:contextData name="storeId" data="${param.storeId}" />
		<wcf:param name="uniqueId" value="com.ibm.commerce.foundation.listPriceList" />
	</wcf:getData>
	<c:forEach var="attribute" items="${listPriceListConfig.configurationAttribute}">
		<object objectType="StoreListPriceList">
			<${attribute.primaryValue.name}><wcf:cdata data="${attribute.primaryValue.value}"/></${attribute.primaryValue.name}>
			<c:forEach var="additionalValue" items="${attribute.additionalValue}">
				<${additionalValue.name}><wcf:cdata data="${additionalValue.value}"/></${additionalValue.name}>
			</c:forEach>
		</object>
	</c:forEach>

<c:if test="${param.storeId != '0'}">
	<wcf:getData type="com.ibm.commerce.infrastructure.facade.datatypes.ConfigurationType"
		var="sterlingConfig" varException="e" expressionBuilder="findByUniqueID">
		<wcf:contextData name="storeId" data="${param.storeId}" />
		<wcf:param name="uniqueId" value="com.ibm.commerce.foundation.configurator" />
	</wcf:getData>
	<c:if test="${empty e}">
		<c:forEach var="attribute" items="${sterlingConfig.configurationAttribute}">
			<object objectType="StoreSterlingConfig">
				<${attribute.primaryValue.name}><wcf:cdata data="${attribute.primaryValue.value}"/></${attribute.primaryValue.name}>
				<c:forEach var="additionalValue" items="${attribute.additionalValue}">
					<${additionalValue.name}><wcf:cdata data="${additionalValue.value}"/></${additionalValue.name}>
				</c:forEach>
			</object>
		</c:forEach>
	</c:if>
</c:if>

	<wcf:getData type="com.ibm.commerce.infrastructure.facade.datatypes.ConfigurationType"
		var="seoConfig" expressionBuilder="findByUniqueID">
		<wcf:contextData name="storeId" data="${param.storeId}" />
		<wcf:param name="uniqueId" value="com.ibm.commerce.foundation.seo" />
	</wcf:getData>
	<c:forEach var="attribute" items="${seoConfig.configurationAttribute}">
		<object objectType="StoreSEO">
			<${attribute.primaryValue.name}><wcf:cdata data="${attribute.primaryValue.value}"/></${attribute.primaryValue.name}>
			<c:forEach var="additionalValue" items="${attribute.additionalValue}">
				<${additionalValue.name}><wcf:cdata data="${additionalValue.value}"/></${additionalValue.name}>
			</c:forEach>
		</object>
	</c:forEach>
</object>
