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

<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="contact" value="${order.orderItem[0].orderItemShippingInfo.shippingAddress}"/>

<%-- cleanup old beans --%>
<c:remove var="contactCountryBean"/>
<c:remove var="stateBean"/>

<!-- Set the country and state display name to the country and state codes respectively. This is in case the display name is not found. -->
<c:set var="countryDisplayName" value="${contact.address.country}"/>
<c:set var="stateDisplayName" value="${contact.address.stateOrProvinceName}"/>
	
<c:catch var ="catchCountry">
	<c:if test="${!empty(contact.address.country) && fn:length(contact.address.country) <= 5}">
		<!-- Retrieve the country display name from the country code -->
		<wcbase:useBean id="contactCountryBean" classname="com.ibm.commerce.taxation.beans.StoreCountryDataBean">
			<c:set target="${contactCountryBean}" property="dataBeanKeyStrCountryAbbr" value="${contact.address.country}"/>
			<c:set target="${contactCountryBean}" property="dataBeanKeyNLanguageId" value="${langId}"/>
		</wcbase:useBean>
	</c:if>
</c:catch>
	
<c:if test="${catchCountry == null && !empty contactCountryBean}">
	<c:catch var="catchCountryName">
		<c:set var="countryDisplayName" value="${contactCountryBean.name}"/>
	</c:catch>
</c:if>
	
<c:catch var ="catchState">
	<!-- Retrieve the state display name from the state code -->
	<c:if test="${!empty(contact.address.stateOrProvinceName) && fn:length(contact.address.stateOrProvinceName) <= 5}">
		<wcbase:useBean id="stateBean" classname="com.ibm.commerce.taxation.beans.StoreStateProvinceDataBean">
			<c:set target="${stateBean}" property="dataBeanKeyStrStateAbbr" value="${contact.address.stateOrProvinceName}"/>
			<c:set target="${stateBean}" property="dataBeanKeyNLanguageId" value="${langId}"/>
		</wcbase:useBean>
	</c:if>
</c:catch>
	
<c:if test="${catchState == null && !empty stateBean}">
	<c:catch var="catchStateName">
		<c:set var="stateDisplayName" value="${stateBean.name}"/>
	</c:catch>
</c:if>

<table role="presentation" style="border-collapse:collapse; border-spacing:0; width:100%; border-top:1px solid #e5e5e5;">
	<tr>
		<td style="margin:0; padding:0;"><h2 style="color:#808080; font-size:16px; font-weight:normal; margin:11px 0 6px;"><fmt:message key="EMAIL_SHIPPING_INFORMATION"/></h2></td>
	</tr>
</table>
<table role="presentation" style="border-collapse:collapse; border-spacing:0; width:100%;">
	<tr>
		<td style="margin:0; padding:0; width:50%; vertical-align:top;">
			<table role="presentation" style="border-collapse:collapse; border-spacing:0;">
				<tr>
					<td style="margin:0; padding:0;"><strong><fmt:message key="EMAIL_SHIPPING_ADDRESS"/>&#58;</strong></td>
				</tr>
				<tr>
					<td style="margin:0; padding:0; padding-top:10px;">
					<c:choose>
					<c:when test="${locale == 'ar_EG'}">
						<%@ include file="../../Snippets/ReusableObjects/Address_AR.jspf" %>
						</c:when>
						<c:when test="${locale == 'ja_JP' || locale == 'ko_KR' || locale == 'zh_CN' || locale == 'zh_TW'}">
						<%@ include file="../../Snippets/ReusableObjects/Address_CN_JP_KR_TW.jspf" %>
						</c:when>
						<c:when test="${locale == 'de_DE' || locale == 'es_ES' || locale == 'fr_FR' || locale == 'it_IT' || locale == 'pl_PL' || locale == 'ro_RO' || locale == 'ru_RU'}">
						<%@ include file="../../Snippets/ReusableObjects/Address_DE_ES_FR_IT_PL_RO_RU.jspf" %>
						</c:when>
						<c:otherwise>
						<%@ include file="../../Snippets/ReusableObjects/Address.jspf" %>
						</c:otherwise>
						</c:choose>
						
					</td>
				</tr>
			</table>
		</td>
		<td style="margin:0; padding:0; width:50%; vertical-align:top;">
			<table role="presentation" style="border-collapse:collapse; border-spacing:0;">
				<tr>
					<td style="margin:0; padding:0;"><h3 style="display:inline; font-size:12px; padding-right:10px;"><strong><fmt:message key="EMAIL_SHIPPING_METHOD"/>&#58;&nbsp;</strong></h3>
					<c:choose>
						<c:when test="${!empty order.orderItem[0].orderItemShippingInfo.shippingMode.description.value}">
							<c:out value="${order.orderItem[0].orderItemShippingInfo.shippingMode.description.value}"/>
						</c:when>
						<c:otherwise>
							<c:set var="shippingModeIdentifier" value="${order.orderItem[0].orderItemShippingInfo.shippingMode.shippingModeIdentifier}"/>
							<c:out value="${shippingModeIdentifier.externalIdentifier.shipModeCode}"/>
						</c:otherwise>
					</c:choose>
					</td>
				</tr>
				<tr>
					<td style="margin:0; padding:0;"><h3 style="display:inline; font-size:12px; padding-right:10px;"><strong><fmt:message key="EMAIL_SHIP_AS_COMPLETE"/>&#58;</strong></h3>
					<c:if test='${order.shipAsComplete}'>
					<fmt:message key="YES" />
					</c:if>
					<c:if test='${!order.shipAsComplete}'>
					<fmt:message key="NO" />
					</c:if></td>
				</tr>
			</table>
		</td>
	</tr>
</table>

