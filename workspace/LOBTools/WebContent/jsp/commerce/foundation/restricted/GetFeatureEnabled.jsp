<?xml version="1.0" encoding="UTF-8"?>

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
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"  prefix="fn" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>

<c:set var="enabledFeatureName" value="${param.enabledFeatureName}"/>
<c:set var="enabledFeatureContextName" value="${param.enabledFeatureContextName}"/>
<c:set var="enabled" value="false"/>

<wcf:getData type="com.ibm.commerce.infrastructure.facade.datatypes.ConfigurationType" var="stConfig" expressionBuilder="findByUniqueID">
	<wcf:contextData name="storeId" data="${param.storeId}"/>
	<wcf:param name="uniqueId" value="com.ibm.commerce.foundation.enabledFeatures"/>
</wcf:getData>

<c:forEach var="attribute" items="${stConfig.configurationAttribute}">
	<c:if test="${attribute.primaryValue.name == 'enabledFeatures'}">
		<c:if test="${fn:indexOf(attribute.primaryValue.value, enabledFeatureName) >= 0}">
			<c:set var="enabled" value="true"/>
		</c:if>
	</c:if>
</c:forEach>
	
<values>
	<${enabledFeatureContextName}>${enabled}</${enabledFeatureContextName}>
</values>
