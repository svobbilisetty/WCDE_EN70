<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2008, 2012 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<!-- BEGIN QuickCheckoutAddressForm.jsp -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ include file="../../../Common/EnvironmentSetup.jspf" %>
<%@ include file="../../../Common/nocache.jspf" %>
<%-- ErrorMessageSetup.jspf is used to retrieve an appropriate error message when there is an error --%>
<%@ include file="../../../include/ErrorMessageSetup.jspf" %>

<c:set var="prefix" value="${param.prefix}"/>
<c:set var="locale_id" value=""/>
<c:if test="${prefix == 'shipping'}">
	<c:set var="locale_id" value="1"/>
</c:if>

<c:choose>
						<c:when test="${isBrazilStore}"><%-- Regardless of the locale, Brazil store always 
							                                 wants this form/layout of the address fields --%>
							<%@ include file="../../../Snippets/ReusableObjects/QuickCheckoutAddressUpdateForm.jspf"%>
							<input type="hidden" id="AddressForm_FieldsOrderByLocale${locale_id}" value="first_name,LAST_NAME,ADDRESS,CITY,COUNTRY/REGION,STATE/PROVINCE,ZIP,phone1,EMAIL1"/>
					 	</c:when>
						<c:when test="${locale == 'zh_CN'}">
							<%@ include file="../../../Snippets/ReusableObjects/QuickCheckoutAddressUpdateForm_CN.jspf"%>
							<input type="hidden" id="AddressForm_FieldsOrderByLocale${locale_id}" value="LAST_NAME,first_name,COUNTRY/REGION,STATE/PROVINCE,CITY,ADDRESS,ZIP,phone1,EMAIL1"/>
						</c:when>
						<c:when test="${locale == 'zh_TW'}">
							<%@ include file="../../../Snippets/ReusableObjects/QuickCheckoutAddressUpdateForm_TW.jspf"%>
							<input type="hidden" id="AddressForm_FieldsOrderByLocale${locale_id}" value="LAST_NAME,first_name,COUNTRY/REGION,STATE/PROVINCE,CITY,ZIP,ADDRESS,phone1,EMAIL1"/>
						</c:when>
						<c:when test="${locale eq 'ar_EG'}">
							<%@ include file="../../../Snippets/ReusableObjects/QuickCheckoutAddressUpdateForm_AR.jspf"%>
							<input type="hidden" id="AddressForm_FieldsOrderByLocale${locale_id}" value="first_name,LAST_NAME,COUNTRY/REGION,CITY,STATE/PROVINCE,ADDRESS,phone1,EMAIL1"/>
						</c:when>
						<c:when test="${locale == 'ru_RU'}">
							<%@ include file="../../../Snippets/ReusableObjects/QuickCheckoutAddressUpdateForm_RU.jspf"%>
							<input type="hidden" id="AddressForm_FieldsOrderByLocale${locale_id}" value="first_name,middle_name,LAST_NAME,ADDRESS,ZIP,CITY,state/province,COUNTRY/REGION,phone1,EMAIL1"/>
						</c:when>
						<c:when test="${locale == 'ja_JP' || locale == 'ko_KR'}">
							<%@ include file="../../../Snippets/ReusableObjects/QuickCheckoutAddressUpdateForm_JP_KR.jspf"%>
							<input type="hidden" id="AddressForm_FieldsOrderByLocale${locale_id}" value="LAST_NAME,FIRST_NAME,COUNTRY/REGION,ZIP,STATE/PROVINCE,CITY,ADDRESS,phone1,EMAIL1"/>
						</c:when>
						<c:when test="${locale == 'de_DE' || locale == 'es_ES' || locale == 'fr_FR' || locale == 'it_IT' || locale == 'ro_RO'}">
							<%@ include file="../../../Snippets/ReusableObjects/QuickCheckoutAddressUpdateForm_DE_ES_FR_IT_RO.jspf"%>
							<input type="hidden" id="AddressForm_FieldsOrderByLocale${locale_id}" value="first_name,LAST_NAME,ADDRESS,ZIP,CITY,state/province,COUNTRY/REGION,phone1,EMAIL1"/>
						</c:when>
						<c:when test="${locale == 'pl_PL'}">
							<%@ include file="../../../Snippets/ReusableObjects/QuickCheckoutAddressUpdateForm_PL.jspf"%>
							<input type="hidden" id="AddressForm_FieldsOrderByLocale${locale_id}" value="first_name,LAST_NAME,ADDRESS,ZIP,CITY,STATE/PROVINCE,COUNTRY/REGION,phone1,EMAIL1"/>
						</c:when>
						<c:otherwise>
							<%@ include file="../../../Snippets/ReusableObjects/QuickCheckoutAddressUpdateForm.jspf"%>
							<input type="hidden" id="AddressForm_FieldsOrderByLocale${locale_id}" value="first_name,LAST_NAME,ADDRESS,CITY,COUNTRY/REGION,STATE/PROVINCE,ZIP,phone1,EMAIL1"/>
						</c:otherwise>
</c:choose>
<!-- END QuickCheckoutAddressForm.jsp -->
