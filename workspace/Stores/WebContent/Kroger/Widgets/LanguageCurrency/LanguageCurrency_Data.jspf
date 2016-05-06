<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2011 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<wcf:getData type="com.ibm.commerce.infrastructure.facade.datatypes.ConfigurationType"
	var="currentStoreLanguages"
	expressionBuilder="findByUniqueID">
	<wcf:param name="uniqueId" value="com.ibm.commerce.foundation.supportedLanguages" />
	<wcf:contextData name="storeId" data="${storeId}"/>
</wcf:getData>
<c:set var="supportedLanguages" value="${currentStoreLanguages.configurationAttribute}"/>
	
<wcf:getData type="com.ibm.commerce.infrastructure.facade.datatypes.ConfigurationType"
	var="currentStoreDefaultLanguage"
	expressionBuilder="findByUniqueID">
	<wcf:param name="uniqueId" value="com.ibm.commerce.foundation.defaultLanguage" />
	<wcf:contextData name="storeId" data="${storeId}"/>
</wcf:getData>

<c:forEach var="additionalValue" items="${currentStoreDefaultLanguage.configurationAttribute[0].additionalValue}">
	<c:if test="${additionalValue.name == 'languageId'}">
		<c:set var="storeDefaultLangId" value="${additionalValue.value}"/>
	</c:if>
</c:forEach>

<wcf:getData type="com.ibm.commerce.infrastructure.facade.datatypes.ConfigurationType"
	var="currentStoreCurrencies"
	expressionBuilder="findByUniqueID">
	<wcf:param name="uniqueId" value="com.ibm.commerce.foundation.supportedCurrencies" />
	<wcf:contextData name="storeId" data="${storeId}"/>
</wcf:getData>
<c:set var="supportedCurrencies" value="${currentStoreCurrencies.configurationAttribute}"/>
	
<wcf:getData type="com.ibm.commerce.infrastructure.facade.datatypes.ConfigurationType"
	var="currentStoreDefaultCurrency"
	expressionBuilder="findByUniqueID">
	<wcf:param name="uniqueId" value="com.ibm.commerce.foundation.defaultCurrency" />
	<wcf:contextData name="storeId" data="${storeId}"/>
</wcf:getData>

<c:forEach var="additionalValue" items="${currentStoreDefaultCurrency.configurationAttribute[0].additionalValue}">
	<c:if test="${additionalValue.name == 'currencyCode'}">
		<c:set var="storeDefaultCurrency" value="${additionalValue.value}"/>
	</c:if>
</c:forEach>