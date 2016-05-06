<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2012 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<object>
	<c:if test="${!empty(param.marketingSpotId)}">
		<wcf:getData
			type="com.ibm.commerce.marketing.facade.datatypes.MarketingSpotType[]"
			var="espots" expressionBuilder="findByUniqueIDs" varShowVerb="showVerb">
			<wcf:contextData name="storeId" data="${param.storeId}" />
			<wcf:param name="UniqueID" value="${param.marketingSpotId}" />
		</wcf:getData>
	
		<c:if test="${empty(param.path)}">
			<object objectType="path">
				<elemTemplateName>path</elemTemplateName>
				<elementName>0</elementName>
				<sequence>0.0</sequence>
				<customerCount readonly="true"></customerCount>
			</object>
		</c:if>
		<c:if test="${empty(param.viewEMarketingSpot)}">
			<object objectType="viewEMarketingSpot">
				<parent>
					<c:if test="${empty(param.path)}">
						<object objectId="0"/>
					</c:if>
					<c:if test="${!empty(param.path)}">
						<object objectPath="path"/>
					</c:if>
				</parent>
				<elementName>1</elementName>
				<sequence>1000.0</sequence>
				<customerCount readonly="true"></customerCount>
			</object>
		</c:if>

		<c:forEach var="spot" items="${espots}">
			<c:set var="showVerb" value="${showVerb}" scope="request"/>
			<c:set var="businessObject" value="${spot}" scope="request"/>
			<c:choose>
				<c:when test="${spot.marketingSpotIdentifier.externalIdentifier.storeIdentifier.uniqueID != param.storeId}">
					<c:set var="referenceObjectType" value="ChildInheritedEMarketingSpot" />
				</c:when>
				<c:otherwise>
					<c:set var="referenceObjectType" value="ChildEMarketingSpot" />
				</c:otherwise>
			</c:choose>
			<object objectType="${referenceObjectType}">
				<parent>
					<c:if test="${empty(param.viewEMarketingSpot)}">
						<object objectId="1"/>
					</c:if>
					<c:if test="${!empty(param.viewEMarketingSpot)}">
						<object objectPath="path/viewEMarketingSpot"/>
					</c:if>
				</parent>
				<childEMarketingSpotId>${spot.marketingSpotIdentifier.uniqueID}</childEMarketingSpotId>
				<jsp:directive.include file="SerializeEMarketingSpot.jspf" />
			</object>
		</c:forEach>
	</c:if>
</object>
