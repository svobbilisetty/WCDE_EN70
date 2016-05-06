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

<table role="presentation" style="border-collapse:collapse; border-spacing:0; width:100%; border-top:1px solid #e5e5e5;">
	<tr>
		<td style="margin:0; padding:0;"><h2 style="color:#808080; font-size:16px; font-weight:normal; margin:11px 0 6px;">
		<fmt:message key="EMAIL_BILLING_INFORMATION"/></h2></td>
	</tr>
</table>
<table role="presentation" style="border-collapse:collapse; border-spacing:0; width:100%;">
	<tr>
		<td style="margin:0; padding:0; width:50%; vertical-align:top;">
			<table role="presentation" style="border-collapse:collapse; border-spacing:0;">
				<tr>
					<td style="margin:0; padding:0;"><strong><fmt:message key="EMAIL_BILLING_ADDRESS"/>&#58;</strong></td>
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
					<td style="margin:0; padding:0;"><h3 style="display:inline; font-size:12px; padding-right:10px;"><strong><fmt:message key="EMAIL_BILLING_METHOD"/>&#58;&nbsp;</strong></h3></td>
				</tr>
				<tr>
				 <td style="margin:0; padding:0; padding-top:10px;">
				  <c:forEach var="paymentInstance" items="${order.orderPaymentInfo.paymentInstruction}" varStatus="paymentCount">
				   
					<c:out value="${paymentInstance.paymentMethod.description.value}"/><br />
						<c:forEach var="protocolData" items="${paymentInstance.protocolData}">
							<c:if test="${fn:contains(knownProtocolData,protocolData.name) && !empty protocolData.value}">
								<fmt:message key="${protocolData.name}"/><c:out value="${protocolData.value}"/><br />
							</c:if>
						</c:forEach>
				   
					<fmt:message key="AMOUNT" />
				   
					<fmt:formatNumber value="${paymentInstance.amount.value}" type="currency" maxFractionDigits="${env_currencyDecimal}" 
						currencySymbol="${env_CurrencySymbolToFormat}"/>
						<c:out value='${CurrencySymbol}'/><br />
				  </c:forEach>
				 </td>																				
					
				</tr>
			</table>
		</td>
	</tr>
</table>
