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
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>

<c:if test="${param.sterlingConfigEnabled != 'true' or param.catenttypeId != 'DynamicKitBean'}">
	<wcf:getData type="com.ibm.commerce.price.facade.datatypes.PriceListType[]"
		var="priceList"
		varShowVerb="showVerb"
		expressionBuilder="getCatalogEntryOfferPriceByID">
		<wcf:contextData name="storeId" data="${param.storeId}"/>
		<wcf:param name="catEntryId" value="${param.parentId}"/>
	</wcf:getData>
</c:if>

<objects>
	<c:if test="${!(empty priceList)}">
		<c:forEach var="price" items="${priceList}">
				<c:choose>
			<c:when test="${(empty price.priceListIdentifier.externalIdentifier.storeIdentifier) || (price.priceListIdentifier.externalIdentifier.storeIdentifier.uniqueID eq param.storeId)}">
				<c:set var="objectType" value="CatalogEntryOffer"/>
			</c:when>
				<c:when test="${price.priceListIdentifier.externalIdentifier.storeIdentifier.uniqueID eq param.objectStoreId && !(param.objectStoreId eq param.storeId)}">
					<c:set var="objectType" value="InheritedCatalogEntryOffer"/>
			</c:when>
				<c:otherwise>
					<c:set var="objectType" value="null"/>
				</c:otherwise>
				</c:choose>

			<c:if test="${!(empty price.priceEntry)}">
				<c:forEach var="entry" items="${price.priceEntry}">
					<object objectType="${objectType}">
						<objectStoreId>${price.priceListIdentifier.externalIdentifier.storeIdentifier.uniqueID}</objectStoreId>
						<offerDescription>${entry.description.value}</offerDescription>
						<c:if test="${entry.minimumQuantity != 0.0}">
							<minimumQuantity>${entry.minimumQuantity}</minimumQuantity>
						</c:if>
						<c:if test="${entry.maximumQuantity ne 0.0}">
							<maximumQuantity>${entry.maximumQuantity}</maximumQuantity>
						</c:if>
						<c:set var="startDate" scope="page" value="${entry.startDate}" />
						<c:set var="endDate" scope="page" value="${entry.endDate}" />
						<startDate>
						<%
							Object startDateObj = pageContext.findAttribute("startDate");
							if(startDateObj != null){
			   	 				out.print((String)startDateObj);
							}			
						%>
						</startDate>
						<endDate>
						<%
							Object endDateObj = pageContext.findAttribute("endDate");
							if(endDateObj != null){
			    				out.print((String)endDateObj);
							}							
						%>
						</endDate>	
						<precedence>${entry.precedence}</precedence>
						<priceListId>${price.priceListIdentifier.uniqueID}</priceListId>
						<offerPriceId>${price.priceListIdentifier.uniqueID}_${entry.qualifier}</offerPriceId>
						<qualifier>${entry.qualifier}</qualifier>
						<catentryId>${entry.catalogEntryIdentifier.uniqueID}</catentryId>
						<defaultStoreCurrency>${entry.price.price.currency}</defaultStoreCurrency>
						<c:if test="${!(empty entry.price.price.currency)}">
							<${entry.price.price.currency}>${entry.price.price.value}</${entry.price.price.currency}>
						</c:if>
						<c:if test="${!(empty entry.price.alternativeCurrencyPrice)}">
							<c:forEach var="altPrice" items="${entry.price.alternativeCurrencyPrice}">
								<${altPrice.currency}>${altPrice.value}</${altPrice.currency}>
							</c:forEach>
						</c:if>
						<c:set var="showVerb" value="${showVerb}" scope="request"/>
						<c:set var="businessObject" value="${entry}" scope="request"/>
						<jsp:include page="/cmc/SerializeChangeControlMetaData" />
					</object>
				</c:forEach>
			</c:if>
		</c:forEach>
	</c:if>
</objects>
