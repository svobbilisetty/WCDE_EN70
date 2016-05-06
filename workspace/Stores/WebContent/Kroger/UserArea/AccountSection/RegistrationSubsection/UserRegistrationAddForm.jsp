
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>  
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ taglib uri="http://commerce.ibm.com/coremetrics"  prefix="cm" %>
<%@ include file="../../../Common/EnvironmentSetup.jspf" %>
<%@ include file="../../../Common/nocache.jspf" %>
<%@ include file="../../../include/ErrorMessageSetup.jspf" %>

<!DOCTYPE HTML>

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
<!-- BEGIN UserRegistrationAddForm.jsp -->
<html xmlns="http://www.w3.org/1999/xhtml" lang="${shortLocale}" xml:lang="${shortLocale}">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title><fmt:message key="REGISTER_TITLE"/></title>
	<link rel="stylesheet" href="<c:out value="${jspStoreImgDir}${env_vfileStylesheet}"/>" type="text/css"/>
	
	<%@ include file="../../../Common/CommonJSToInclude.jspf"%>
	<%@ include file="../../../include/ErrorMessageSetupBrazilExt.jspf" %>
	
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Widgets/Search.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Widgets/MiniShopCartDisplay/MiniShopCartDisplay.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Widgets/Department/Department.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/CommonContextsDeclarations.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/CommonControllersDeclaration.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Common/ShoppingActions.js"/>"></script>
	
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/ServicesDeclaration.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/UserArea/LogonForm.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/UserArea/AddressHelper.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/UserArea/MyAccountDisplay.js"/>"></script>
	<c:if test="${isBrazilStore}"> 
		<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/UserArea/MyBrazilAccountDisplay.js"/>"></script>
	</c:if>
	<script type="text/javascript">
		dojo.addOnLoad(function() { 
			ServicesDeclarationJS.setCommonParameters('<c:out value='${WCParam.langId}'/>','<c:out value='${WCParam.storeId}'/>','<c:out value='${WCParam.catalogId}'/>');
			<fmt:message key="PWDREENTER_DO_NOT_MATCH" var="PWDREENTER_DO_NOT_MATCH" />
			<fmt:message key="WISHLIST_INVALIDEMAILFORMAT" var="WISHLIST_INVALIDEMAILFORMAT" />
			<fmt:message key="REQUIRED_FIELD_ENTER" var="REQUIRED_FIELD_ENTER" />
			<fmt:message key="ERROR_INVALIDPHONE" var="ERROR_INVALIDPHONE" />
			<fmt:message key="ERROR_LastNameEmpty" var="ERROR_LastNameEmpty" />
			<fmt:message key="ERROR_AddressEmpty" var="ERROR_AddressEmpty" />      
			<fmt:message key="ERROR_CityEmpty" var="ERROR_CityEmpty" />
			<fmt:message key="ERROR_StateEmpty" var="ERROR_StateEmpty" />
			<fmt:message key="ERROR_CountryEmpty" var="ERROR_CountryEmpty" />
			<fmt:message key="ERROR_ZipCodeEmpty" var="ERROR_ZipCodeEmpty" />
			<fmt:message key="ERROR_EmailEmpty" var="ERROR_EmailEmpty" />
			<fmt:message key="ERROR_LogonIdEmpty" var="ERROR_LogonIdEmpty" />
			<fmt:message key="ERROR_PasswordEmpty" var="ERROR_PasswordEmpty" />
			<fmt:message key="ERROR_VerifyPasswordEmpty" var="ERROR_VerifyPasswordEmpty" />
			<fmt:message key="ERROR_MESSAGE_TYPE" var="ERROR_MESSAGE_TYPE" />
			<fmt:message key="ERROR_INVALIDEMAILFORMAT" var="ERROR_INVALIDEMAILFORMAT"/>
			<fmt:message key="ERROR_FirstNameEmpty" var="ERROR_FirstNameEmpty" />
			<fmt:message key="ERROR_FirstNameTooLong" var="ERROR_FirstNameTooLong" />
			<fmt:message key="ERROR_LastNameTooLong" var="ERROR_LastNameTooLong" />
			<fmt:message key="ERROR_AddressTooLong" var="ERROR_AddressTooLong" />
			<fmt:message key="ERROR_CityTooLong" var="ERROR_CityTooLong" />
			<fmt:message key="ERROR_StateTooLong" var="ERROR_StateTooLong" />
			<fmt:message key="ERROR_CountryTooLong" var="ERROR_CountryTooLong" />
			<fmt:message key="ERROR_ZipCodeTooLong" var="ERROR_ZipCodeTooLong" />
			<fmt:message key="ERROR_EmailTooLong" var="ERROR_EmailTooLong" />
			<fmt:message key="ERROR_PhoneTooLong" var="ERROR_PhoneTooLong" />
			<fmt:message key="ERROR_SpecifyYear" var="ERROR_SpecifyYear" />
			<fmt:message key="ERROR_SpecifyMonth" var="ERROR_SpecifyMonth" />
			<fmt:message key="ERROR_SpecifyDate" var="ERROR_SpecifyDate" />
			<fmt:message key="ERROR_InvalidDate1" var="ERROR_InvalidDate1" />
			<fmt:message key="ERROR_InvalidDate2" var="ERROR_InvalidDate2" />
			<%-- Missing message --%>
			<fmt:message key="ERROR_MOBILE_PHONE_EMPTY" var="ERROR_MOBILE_PHONE_EMPTY" />
			<fmt:message key="AGE_WARNING_ALERT" var="AGE_WARNING_ALERT"/>

			MessageHelper.setMessage("PWDREENTER_DO_NOT_MATCH", <wcf:json object="${PWDREENTER_DO_NOT_MATCH}"/>);
			MessageHelper.setMessage("WISHLIST_INVALIDEMAILFORMAT", <wcf:json object="${WISHLIST_INVALIDEMAILFORMAT}"/>);
			MessageHelper.setMessage("REQUIRED_FIELD_ENTER", <wcf:json object="${REQUIRED_FIELD_ENTER}"/>);
			MessageHelper.setMessage("ERROR_INVALIDPHONE", <wcf:json object="${ERROR_INVALIDPHONE}"/>);
			MessageHelper.setMessage("ERROR_LastNameEmpty", <wcf:json object="${ERROR_LastNameEmpty}"/>);
			MessageHelper.setMessage("ERROR_AddressEmpty", <wcf:json object="${ERROR_AddressEmpty}"/>);
			MessageHelper.setMessage("ERROR_CityEmpty", <wcf:json object="${ERROR_CityEmpty}"/>);
			MessageHelper.setMessage("ERROR_StateEmpty", <wcf:json object="${ERROR_StateEmpty}"/>);
			MessageHelper.setMessage("ERROR_CountryEmpty", <wcf:json object="${ERROR_CountryEmpty}"/>);
			MessageHelper.setMessage("ERROR_ZipCodeEmpty", <wcf:json object="${ERROR_ZipCodeEmpty}"/>);
			MessageHelper.setMessage("ERROR_EmailEmpty", <wcf:json object="${ERROR_EmailEmpty}"/>);
			MessageHelper.setMessage("ERROR_LogonIdEmpty", <wcf:json object="${ERROR_LogonIdEmpty}"/>);
			MessageHelper.setMessage("ERROR_PasswordEmpty", <wcf:json object="${ERROR_PasswordEmpty}"/>);
			MessageHelper.setMessage("ERROR_VerifyPasswordEmpty", <wcf:json object="${ERROR_VerifyPasswordEmpty}"/>);
			MessageHelper.setMessage("ERROR_MESSAGE_TYPE", <wcf:json object="${ERROR_MESSAGE_TYPE}"/>);
			MessageHelper.setMessage("ERROR_INVALIDEMAILFORMAT", <wcf:json object="${ERROR_INVALIDEMAILFORMAT}"/>);
			MessageHelper.setMessage("ERROR_FirstNameEmpty", <wcf:json object="${ERROR_FirstNameEmpty}"/>);
			MessageHelper.setMessage("ERROR_FirstNameTooLong", <wcf:json object="${ERROR_FirstNameTooLong}"/>);
			MessageHelper.setMessage("ERROR_LastNameTooLong", <wcf:json object="${ERROR_LastNameTooLong}"/>);
			MessageHelper.setMessage("ERROR_AddressTooLong", <wcf:json object="${ERROR_AddressTooLong}"/>);
			MessageHelper.setMessage("ERROR_CityTooLong", <wcf:json object="${ERROR_CityTooLong}"/>);
			MessageHelper.setMessage("ERROR_StateTooLong", <wcf:json object="${ERROR_StateTooLong}"/>);
			MessageHelper.setMessage("ERROR_CountryTooLong", <wcf:json object="${ERROR_CountryTooLong}"/>);
			MessageHelper.setMessage("ERROR_ZipCodeTooLong", <wcf:json object="${ERROR_ZipCodeTooLong}"/>);
			MessageHelper.setMessage("ERROR_EmailTooLong", <wcf:json object="${ERROR_EmailTooLong}"/>);
			MessageHelper.setMessage("ERROR_PhoneTooLong", <wcf:json object="${ERROR_PhoneTooLong}"/>);	         
			MessageHelper.setMessage("ERROR_SpecifyYear", <wcf:json object="${ERROR_SpecifyYear}"/>);
			MessageHelper.setMessage("ERROR_SpecifyMonth", <wcf:json object="${ERROR_SpecifyMonth}"/>);
			MessageHelper.setMessage("ERROR_SpecifyDate", <wcf:json object="${ERROR_SpecifyDate}"/>);
			MessageHelper.setMessage("ERROR_InvalidDate1", <wcf:json object="${ERROR_InvalidDate1}"/>);
			MessageHelper.setMessage("ERROR_InvalidDate2", <wcf:json object="${ERROR_InvalidDate2}"/>);
			MessageHelper.setMessage("ERROR_MOBILE_PHONE_EMPTY", <wcf:json object="${ERROR_MOBILE_PHONE_EMPTY}"/>);
			MessageHelper.setMessage("AGE_WARNING_ALERT", <wcf:json object="${AGE_WARNING_ALERT}"/>);
		});
       
	</script>
	<script type="text/javascript">
		function popupWindow(URL) {
			window.open(URL, "mywindow", "status=1,scrollbars=1,resizable=1");
		}
	</script>  

	<%@ include file="../../../Common/CommonJSPFToInclude.jspf"%>
      
</head>


<wcf:url var="MyAccountURL" value="AjaxLogonForm" type="Ajax">
	<wcf:param name="langId" value="${langId}" />
	<wcf:param name="storeId" value="${WCParam.storeId}" />
	<wcf:param name="catalogId" value="${WCParam.catalogId}" />
</wcf:url>

<c:choose>
	<c:when test="${isBrazilStore}"><!-- For Brazil store, register person and create checkout profile -->
		<c:set var="actionURL" value="PersonProcessServicePersonRegisterWithCheckoutProfile"/>
	</c:when>
	<c:otherwise><!-- For Madisons store, register a person w/o creating a checkout profile  -->
		<c:set var="actionURL" value="PersonProcessServicePersonRegister"/>
	</c:otherwise>
</c:choose>

<body>

<!-- Page Start -->
<div id="page">

		<%--
		  ***
		  * If an error occurs, the page will refresh and the entry fields will be pre-filled with the previously entered value.
		  * The entry fields below use e.g. paramSource.logonId to get the previously entered value.
		  * In this case, the paramSource is set to WCParam.  
		  ***
		--%>
		<c:set var="paramSource" value="${WCParam}"/>  
		<wcf:getData type="com.ibm.commerce.member.facade.datatypes.PersonType" var="person" expressionBuilder="findCurrentPerson">
			<wcf:param name="accessProfile" value="IBM_All" />
		</wcf:getData>
      
		<!-- Main Content Start -->

		<!-- Import Header Widget -->
		<div class="header_wrapper_position" id="headerWidget">
			<%out.flush();%>
			<c:import url = "${env_jspStoreDir}/Widgets/Header/Header.jsp" />
			<%out.flush();%>
		</div>
		<!-- Header Nav End -->
	
		<div class="content_wrapper_position" role="main">
			<div class="content_wrapper">
				<div class="content_left_shadow">
					<div class="content_right_shadow">
						<div class="main_content">					
							<div class="container_full_width">	
								<!-- Content Start -->
								<div id="box">
									<div class="sign_in_registration" id="WC_UserRegistrationAddForm_div_1">
										<div class="title" id="WC_UserRegistrationAddForm_div_2">
											<h1>
												<fmt:message key="UR_PROFILE">
													<fmt:param><c:out value="${storeName}"/></fmt:param>
												</fmt:message>	
											</h1>
										</div>
										<form name="Register" method="post" action="<c:out value="${actionURL}"/>" id="Register">
										
											<input type="hidden" name="myAcctMain" value="<c:out value="${WCParam.myAcctMain}"/>" />
											<input type="hidden" name="new" value="Y" id="WC_UserRegistrationAddForm_FormInput_new_In_Register_1"/>
											<input type="hidden" name="storeId" value="<c:out value="${WCParam.storeId}"  />" id="WC_UserRegistrationAddForm_FormInput_storeId_In_Register_1"/>
											<input type="hidden" name="catalogId" value="<c:out value="${WCParam.catalogId}"  />" id="WC_UserRegistrationAddForm_FormInput_catalogId_In_Register_1"/>
											<flow:ifEnabled feature="AccountActivation">
												<%-- If account activation is enabled, redirect to the next page in the same language --%>
												<input type="hidden" name="langId" value="<c:out value="${langId}" />" id="WC_UserRegistrationAddForm_FormInput_langId" />
											</flow:ifEnabled>
											<c:if test="${!empty WCParam.nextUrl}">
												<input type="hidden" name="nextUrl" value="<c:out value="${WCParam.nextUrl}"/>" id="WC_UserRegistrationAddForm_FormInput_nextUrl_In_Register_1"/>
											</c:if>       	
											<c:choose>
											<c:when test="${!empty WCParam.postRegisterURL}">
													<input type="hidden" name="URL" value="<c:out value='${WCParam.postRegisterURL}'/>" id="WC_UserRegistrationAddForm_FormInput_POSTURL_In_Register_1"/>
												</c:when>
												<c:when test="${!empty WCParam.URL}">
													<input type="hidden" name="URL" value="<c:out value='${WCParam.URL}'/>" id="WC_UserRegistrationAddForm_FormInput_URL_In_Register_1"/>
												</c:when>
												<c:otherwise>
													<wcf:url var="logonURL" value="AjaxLogonForm"></wcf:url>
													<input type="hidden" name="URL" value="${logonURL}?&logonId*=&firstName*=&lastName*=&address1*=&address2*=&city*=&country*=&state*=&zipCode*=&email1*=&phone1*=" id="WC_UserRegistrationAddForm_FormInput_URL_In_Register_1"/>
												</c:otherwise>
											</c:choose>
											<input type="hidden" name="receiveSMSNotification" value="" id="WC_UserRegistrationAddForm_FormInput_receiveSMSNotification_In_Register_1"/>
											<input type="hidden" name="receiveSMS" value="" id="WC_UserRegistrationAddForm_FormInput_receiveSMS_In_Register_1"/>
											<input type="hidden" name="addressType" value="ShippingAndBilling" id="WC_UserRegistrationAddForm_FormInput_addressType_In_Register_1"/>
											<input type="hidden" name="errorViewName" value="UserRegistrationAddFormView" id="WC_UserRegistrationAddForm_FormInput_errorViewName_In_Register_1"/>              
									
											<c:choose>
												<c:when test="${empty WCParam.page}">
													<input type="hidden" name="page" value="account" id="WC_UserRegistrationAddForm_FormInput_page_In_Register_1"/>
												</c:when>
												<c:otherwise>
													<input type="hidden" name="page" value="<c:out value="${WCParam.page}" />" id="WC_UserRegistrationAddForm_FormInput_page_In_Register_1"/>
												</c:otherwise>
											</c:choose>
											<input type="hidden" name="registerType" value="Guest" id="WC_UserRegistrationAddForm_FormInput_registerType_In_Register_1"/>
											<input type="hidden" name="primary" value="true" id="WC_UserRegistrationAddForm_FormInput_primary_In_Register_1"/>
											<input type="hidden" name="profileType" value="Consumer" id="WC_UserRegistrationAddForm_FormInput_profileType_In_Register_1"/>
									      
											<input type="hidden" name="receiveEmail" value="" id="WC_UserRegistrationAddForm_FormInput_receiveEmail_In_Register_1"/>
											<%-- The challenge answer and question are necessary for the forget password feature. Therefore, they are set to "-" here. --%>
											<input type="hidden" name="challengeQuestion" value="-" id="WC_UserRegistrationAddForm_FormInput_challengeQuestion_In_Register_1"/>
											<input type="hidden" name="challengeAnswer" value="-" id="WC_UserRegistrationAddForm_FormInput_challengeAnswer_In_Register_1"/>
	
											<div class="form" id="WC_UserRegistrationAddForm_div_3">
												<div class="myaccount_header" id="WC_UserRegistrationAddForm_div_5">
													<h2 class="registration_header"><fmt:message key="UR_PLEASE_REG"/></h2>
												</div>
												<div class="content" id="WC_UserRegistrationAddForm_div_6">
													<div class="align" id="WC_UserRegistrationAddForm_div_7">
														<div class="form_2column" id="WC_UserRegistrationAddForm_div_8">
	
															<c:if test="${!empty errorMessage}">
																<fmt:message var ="msgType" key="ERROR_MESSAGE_TYPE"/>
																<c:set var = "errorMessage" value ="${msgType}${errorMessage}"/>
																<span id="UserRegistrationErrorMessage" class="error_msg" tabindex="-1"><c:out value="${errorMessage}"/></span><br/>
																<script type="text/javascript">
																	dojo.addOnLoad(function() { 
																		setTimeout("dojo.byId('UserRegistrationErrorMessage').focus()",2000);
																	});
																</script>
																<br/>
															</c:if>
															<c:if test="${isBrazilStore}">   	<%-- section to display 2 radio buttons for shopper option selection (register as consumer or as a business) --%>
																<%@ include file="UserRegistrationAddBrazilExt.jspf"%>
															</c:if>    
	
															<span class="required-field" id="WC_UserRegistrationAddForm_div_9"> *</span>
															<fmt:message key="REQUIRED_FIELDS"/><br />
															<br />
															<div class="column" id="WC_UserRegistrationAddForm_div_10">
																<div class="column_label" id="WC_UserRegistrationAddForm_div_11">
																	<span class="spanacce">
																		<label for="WC_UserRegistrationAddForm_FormInput_logonId_In_Register_1_1">
																			<fmt:message key="LOGON_ID"/>
																		</label>
																	</span>
																<span class="required-field" id="WC_UserRegistrationAddForm_div_12"> *</span>
																	<fmt:message key="LOGON_ID"/>

																</div>
																<input type="text" size="35" maxlength="254" aria-required="true" name="logonId" id="WC_UserRegistrationAddForm_FormInput_logonId_In_Register_1_1"  value="<c:out value="${paramSource.logonId}"/>"/>
															</div>
	                                                                              
					                                        <br clear="all" />
					                                        <div class="column" id="WC_UserRegistrationAddForm_div_13">
					                                             <div class="column_label" id="WC_UserRegistrationAddForm_div_14">
																	<span class="spanacce">
																		<label for="WC_UserRegistrationAddForm_FormInput_logonPassword_In_Register_1">
																			<fmt:message key="PASSWORD3"/>
																		</label>
																	</span>
																	<span class="required-field" id="WC_UserRegistrationAddForm_div_15"> *</span>
																	<fmt:message key="PASSWORD3"/>
																</div>
																<input size="35" maxlength="50" aria-required="true" name="logonPassword" id="WC_UserRegistrationAddForm_FormInput_logonPassword_In_Register_1" type="password" autocomplete="off" value="<c:out value="${paramSource.logonPassword}"/>" />
															</div>
															<div class="column" id="WC_UserRegistrationAddForm_div_16">
																<div class="column_label" id="WC_UserRegistrationAddForm_div_17">
																	<span class="spanacce">
																		<label for="WC_UserRegistrationAddForm_FormInput_logonPasswordVerify_In_Register_1">
																			<fmt:message key="VERIFY_PASSWORD3"/>
																		</label>
																	</span>
																	<span class="required-field" id="WC_UserRegistrationAddForm_div_18"> *</span>
																	<fmt:message key="VERIFY_PASSWORD3"/>
																</div>
																<input size="35" maxlength="50" aria-required="true" name="logonPasswordVerify" id="WC_UserRegistrationAddForm_FormInput_logonPasswordVerify_In_Register_1" type="password" autocomplete="off" value="<c:out value="${paramSource.logonPassword}"/>" />
															</div>
															<br clear="all" />
															<%-- 
																***
																*       Start: Registration Form - First Name and Last Name fields
																* The layouts of these entry fields are different depending on the locale.
																***
															--%>                            
															<c:set var="firstName" value="${paramSource.firstName}"/>
															<c:set var="lastName" value="${paramSource.lastName}"/>
															<c:set var="middleName" value="${paramSource.middleName}"/>
															<c:set var="street" value="${paramSource.address1}"/>
															<c:set var="street2" value="${paramSource.address2}"/>
															<c:set var="city" value="${paramSource.city}"/>
															<c:set var="state" value="${paramSource.state}"/>
															<c:set var="country1" value="${paramSource.country}"/>
															<c:set var="zipCode" value="${paramSource.zipCode}"/>                                                                                                                                                   
															<c:set var="formName" value="document.Register.name"/>
															<c:set var="paramSource" value="${WCParam}" />
															<c:set var="pageName" value="UserRegistrationAddForm"/>
															<c:set var="receiveSMSNotification" value="${paramSource.receiveSMSNotification}"/>
															<c:set var="mobilePhoneNumber1" value="${paramSource.mobilePhone1}"/>
															<c:set var="mobilePhoneNumber1Country" value="${paramSource.mobilePhone1Country}"/>                                                    
															<c:choose>
																<c:when test="${isBrazilStore}">
																	<%-- Regardless of the locale, Brazil store always wants this form/layout of the address fields --%>
																	<%@ include file="../../../Snippets/ReusableObjects/AddressEntryForm.jspf"%>
																	<%-- pass along the CPF_NUMBER for the Brazil store to validate--%>
																	<input type="hidden" id="AddressForm_FieldsOrderByLocale" value="first_name,LAST_NAME,CPF_NUMBER,ADDRESS,CITY,COUNTRY/REGION,STATE/PROVINCE,ZIP,phone1,EMAIL1"/>
																</c:when>
																<c:when test="${locale == 'zh_CN'}">
																	<%@ include file="../../../Snippets/ReusableObjects/AddressEntryForm_CN.jspf"%>
																	<input type="hidden" id="AddressForm_FieldsOrderByLocale" value="LAST_NAME,first_name,COUNTRY/REGION,STATE/PROVINCE,CITY,ADDRESS,ZIP,phone1,EMAIL1"/>
																</c:when>
																<c:when test="${locale eq 'ar_EG'}">
																	<%@ include file="../../../Snippets/ReusableObjects/AddressEntryForm_AR.jspf"%>
																	<input type="hidden" id="AddressForm_FieldsOrderByLocale" value="first_name,LAST_NAME,COUNTRY/REGION,CITY,STATE/PROVINCE,ADDRESS,phone1,EMAIL1"/>
																</c:when>
																<c:when test="${locale == 'ru_RU'}">
																	<%@ include file="../../../Snippets/ReusableObjects/AddressEntryForm_RU.jspf"%>
																	<input type="hidden" id="AddressForm_FieldsOrderByLocale" value="first_name,middle_name,LAST_NAME,ADDRESS,ZIP,CITY,state/province,COUNTRY/REGION,phone1,EMAIL1"/>
																</c:when>
																<c:when test="${locale == 'zh_TW'}">
																	<%@ include file="../../../Snippets/ReusableObjects/AddressEntryForm_TW.jspf"%>
																	<input type="hidden" id="AddressForm_FieldsOrderByLocale" value="LAST_NAME,first_name,COUNTRY/REGION,STATE/PROVINCE,CITY,ZIP,ADDRESS,phone1,EMAIL1"/>
																</c:when>
																<c:when test="${locale == 'ja_JP' || locale == 'ko_KR'}">
																	<%@ include file="../../../Snippets/ReusableObjects/AddressEntryForm_JP_KR.jspf"%>
																	<input type="hidden" id="AddressForm_FieldsOrderByLocale" value="LAST_NAME,FIRST_NAME,COUNTRY/REGION,ZIP,STATE/PROVINCE,CITY,ADDRESS,phone1,EMAIL1"/>
																</c:when>
																<c:when test="${locale == 'de_DE' || locale == 'es_ES' || locale == 'fr_FR' || locale == 'it_IT' || locale == 'ro_RO'}">
																	<%@ include file="../../../Snippets/ReusableObjects/AddressEntryForm_DE_ES_FR_IT_RO.jspf"%>
																	<input type="hidden" id="AddressForm_FieldsOrderByLocale" value="first_name,LAST_NAME,ADDRESS,ZIP,CITY,state/province,COUNTRY/REGION,phone1,EMAIL1"/>
																</c:when>
																<c:when test="${locale == 'pl_PL'}">
																	<%@ include file="../../../Snippets/ReusableObjects/AddressEntryForm_PL.jspf"%>
																	<input type="hidden" id="AddressForm_FieldsOrderByLocale" value="first_name,LAST_NAME,ADDRESS,ZIP,CITY,STATE/PROVINCE,COUNTRY/REGION,phone1,EMAIL1"/>
																</c:when>
																<c:otherwise>
																	<%@ include file="../../../Snippets/ReusableObjects/AddressEntryForm.jspf"%>
																	<input type="hidden" id="AddressForm_FieldsOrderByLocale" value="first_name,LAST_NAME,ADDRESS,CITY,COUNTRY/REGION,STATE/PROVINCE,ZIP,phone1,EMAIL1"/>
																</c:otherwise>
															</c:choose>
															<%-- 
															  ***
															  *       End: AddressEntry Form - Address, City, State/Province, Country/Region and Zip/Postal code fields
															  ***
															--%>
															<br clear="all" />
					                                        <div class="column" id="WC_UserRegistrationAddForm_div_19">
																<div class="column_label" id="WC_UserRegistrationAddForm_div_20">
																	<span class="spanacce">
																		<label for="WC_UserRegistrationAddForm_FormInput_email1_In_Register_1">
																			<fmt:message key="EMAIL"/>
																		</label>
																	</span>
																	<span class="required-field" id="WC_UserRegistrationAddForm_div_21"> *</span>
																	<fmt:message key="EMAIL"/>
					                                             </div>
					                                             <input type="text" size="35" maxlength="50" aria-required="true" name="email1" id="WC_UserRegistrationAddForm_FormInput_email1_In_Register_1" value="<c:out value="${paramSource.email1}"/>" />
					                                        </div>
															<div class="column" id="WC_UserRegistrationAddForm_div_22">
																<div class="column_label" id="WC_UserRegistrationAddForm_div_23">
																	<span class="spanacce">
																		<label for="WC_UserRegistrationAddForm_FormInput_phoneNum_In_Register_1">
																			<fmt:message key="PHONE_NUMBER2"/>
																		</label>
																	</span>
																	<fmt:message key="PHONE_NUMBER2"/>
																</div>
																<input type="tel" size="35" maxlength="32" id="WC_UserRegistrationAddForm_FormInput_phoneNum_In_Register_1" name="phone1" value="<c:out value="${paramSource.phone1}"/>"/>
															</div>
															<br clear="all" />
	
	                                       					<%@ include file="../../../Snippets/ReusableObjects/RegistrationFlexFlows.jspf"%>
	
	 														<br clear="all" />
															<div class="column" id="WC_UserRegistrationAddForm_div_36">
																<div class="input_label" id="WC_UserRegistrationAddForm_div_37">
																	<div class="checkbox_registration" id="WC_UserRegistrationAddForm_div_38">
																		<input class="checkbox" type="checkbox" name="rememberMe" value="true" id="WC_UserRegistrationAddForm_FormInput_rememberMe_In_Register_1"/>
																	</div>
																	<div class="checkbox_label" id="WC_UserRegistrationAddForm_div_39">
																		<label for="WC_UserRegistrationAddForm_FormInput_rememberMe_In_Register_1"><fmt:message key="REMEMBER_ME"/></label>
																	</div>
																</div>
															</div>
															<%@ include file="UserRegistrationAddExt.jspf"%>
														</div>
														<div class="clear_float"></div>
													</div>
												<div class="button_footer_line no_float" id="WC_UserRegistrationAddForm_div_40">
													<a href="#" role="button" class="button_primary" id="WC_UserRegistrationAddForm_links_1" tabindex="0" onclick="JavaScript:LogonForm.prepareSubmit(document.Register);return false;">
														<div class="left_border"></div>
														<div class="button_text"><fmt:message key="SUBMIT"/></div>												
														<div class="right_border"></div>
													</a>
													<a role="button" class="button_secondary button_left_padding" id="WC_UserRegistrationAddForm_links_2" tabindex="0" href="javascript:setPageLocation('<c:out value="${env_TopCategoriesDisplayURL}"/>')">
														<div class="left_border"></div>
														<div class="button_text"><fmt:message key="CANCEL"/></div>												
														<div class="right_border"></div>
													</a>
												</div>

												</div>
											</div>
										</form>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- Content End -->
	
	<!-- Main Content End -->
	<!-- Footer Start -->
	<div class="footer_wrapper_position">
		<%out.flush();%>
		<c:import url = "${env_jspStoreDir}/Widgets/Footer/Footer.jsp" />
		<%out.flush();%>
	</div>
	<!-- Footer End --> 
</div>

<flow:ifEnabled feature="Analytics"><cm:pageview/></flow:ifEnabled>
</body>
</html>
   
<!-- END UserRegistrationAddForm.jsp -->
