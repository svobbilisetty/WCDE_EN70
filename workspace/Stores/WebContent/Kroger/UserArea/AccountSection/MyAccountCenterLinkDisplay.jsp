<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2008, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<!-- BEGIN MyAccountCenterLinkDisplay.jsp -->
<%@ page import="com.ibm.commerce.member.facade.client.MemberFacadeClient" %>
<%@ page import="com.ibm.commerce.member.facade.datatypes.PersonType" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ include file="../../Common/EnvironmentSetup.jspf" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="http://commerce.ibm.com/coremetrics"  prefix="cm" %>

<c:set var="myAccountPage" value="true" scope="request"/>

<wcf:url var="userRegistrationFormURL" value="UserRegistrationForm">
	<wcf:param name="storeId"   value="${WCParam.storeId}"  />
	<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
	<wcf:param name="langId" value="${langId}" />
	<wcf:param name="editRegistration" value="Y" />
</wcf:url>
<wcf:url var="addressBookFormURL" value="AddressBookForm">
	<wcf:param name="storeId"   value="${WCParam.storeId}"  />
	<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
	<wcf:param name="langId" value="${langId}" />
</wcf:url>
<wcf:url var="profileFormViewURL" value="ProfileFormView">
	<wcf:param name="storeId"   value="${WCParam.storeId}"  />
	<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
	<wcf:param name="langId" value="${langId}" />
</wcf:url>

<wcf:url var="interestItemDisplayURL" value="WishListDisplayView">
	<wcf:param name="storeId"   value="${WCParam.storeId}"  />
	<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
	<wcf:param name="langId" value="${langId}" />
	<wcf:param name="listId" value="." />
</wcf:url>

<wcf:url var="trackOrderStatusURL" value="TrackOrderStatus">
	<wcf:param name="storeId"   value="${WCParam.storeId}"  />
	<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
	<wcf:param name="langId" value="${langId}" />
</wcf:url>

<flow:ifEnabled feature="RecurringOrders">
	<wcf:url var="trackRecurringOrderStatusURL" value="TrackOrderStatus">
		<wcf:param name="storeId"   value="${WCParam.storeId}"  />
		<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
		<wcf:param name="langId" value="${langId}" />
		<wcf:param name="isRecurringOrder" value="true" />
	</wcf:url>
</flow:ifEnabled>

<flow:ifEnabled feature="Subscription">
	<wcf:url var="trackSubscriptionStatusURL" value="TrackOrderStatus">
		<wcf:param name="storeId"   value="${WCParam.storeId}"  />
		<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
		<wcf:param name="langId" value="${langId}" />
		<wcf:param name="isSubscription" value="true" />
	</wcf:url>
</flow:ifEnabled>

<flow:ifEnabled feature="EnableQuotes">
	<wcf:url var="trackQuoteStatusURL" value="TrackOrderStatus">
		<wcf:param name="storeId"   value="${WCParam.storeId}"  />
		<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
		<wcf:param name="langId" value="${langId}" />
		<wcf:param name="isQuote" value="true" />
	</wcf:url>
</flow:ifEnabled>

<wcf:getData type="com.ibm.commerce.member.facade.datatypes.PersonType" var="person" expressionBuilder="findCurrentPerson">
       <wcf:param name="accessProfile" value="IBM_All" />
</wcf:getData>
<flow:ifEnabled feature="Analytics">
<cm:registration personType="${person}"/>
</flow:ifEnabled>

<c:set var="firstName" value="${person.contactInfo.contactName.firstName}"/>
<c:set var="lastName" value="${person.contactInfo.contactName.lastName}"/>
<c:set var="middleName" value="${person.contactInfo.contactName.middleName}"/>
<c:set var="street" value="${person.contactInfo.address.addressLine[0]}"/>
<c:set var="street2" value="${person.contactInfo.address.addressLine[1]}"/>
<c:set var="city" value="${person.contactInfo.address.city}"/>
<c:set var="email1" value="${person.contactInfo.emailAddress1.value}"/>

<c:if test="${WCParam.myAcctUpdate == 1}">
<div id="box">
<div class="my_account" id="WC_MyAccountCenterLinkDisplay_box_1">
<div class="main_header" id="WC_MyAccountCenterLinkDisplay_div_36">
		<div class="left_corner" id="WC_MyAccountCenterLinkDisplay_div_37"></div>
		<div id="WC_MyAccountCenterLinkDisplay_div_38"><span class="main_header_text"><fmt:message key='MA_SUMMARY' bundle='${storeText}'/></span></div>
		<div class="right_corner" id="WC_MyAccountCenterLinkDisplay_div_39"></div>		
</div>

<div class="contentline" id="WC_MyAccountCenterLinkDisplay_div_40">
	<div class="left_corner" id="WC_MyAccountCenterLinkDisplay_div_41"></div>		
	<div  id="WC_MyAccountCenterLinkDisplay_div_42"></div>
	<div class="right_corner" id="WC_MyAccountCenterLinkDisplay_div_43"></div>		
</div>

<div class="body" id="WC_MyAccountCenterLinkDisplay_div_44">
</c:if>

<c:if test="${!empty showOrgLogoName && showOrgLogoName==true}">
	<wcbase:useBean id="contract_DisplayTCBean" classname="com.ibm.commerce.tools.contract.beans.DisplayCustomizationTCDataBean">
		<c:set target="${contract_DisplayTCBean}" property="commandContext" value="${CommandContext}" />
		<c:set target="${contract_DisplayTCBean}" property="languageId" value="${langId}" />
		<c:set target="${contract_DisplayTCBean}" property="userId" value="${CommandContext.userId}" />
		<c:set target="${contract_DisplayTCBean}" property="storeId" value="${WCParam.storeId}" />
	</wcbase:useBean>
	<c:set var="customAccountLogo" value="${contract_DisplayTCBean.attachmentURL[1]}"/>
	<c:if test="${!empty customAccountLogo}">
		<c:set var="loopDone" value="false"/>
		<c:forTokens items="${customAccountLogo}" delims=":" var="token">
			<c:if test="${!loopDone}">
				<c:set var="customAccountPath" value="${token}" />
				<c:set var="loopDone" value="true"/>
			</c:if>
		</c:forTokens>
		<span id="WC_MyAccountCenterLinkDisplay_ContractLogo">
			<c:choose>
				<c:when test="${(customAccountPath eq 'http') or (customAccountPath eq 'https')}">
					<img alt="<c:out value="${requestScope.orgName}"/>" title="<c:out value="${requestScope.orgName}"/>" src='<c:out value="${contract_DisplayTCBean.attachmentURL[1]}"/>' ></img>
				</c:when>
				<c:otherwise>
					<img alt="<c:out value="${requestScope.orgName}"/>" title="<c:out value="${requestScope.orgName}"/>" src='<c:out value="${storeImgDir}${contract_DisplayTCBean.attachmentURL[1]}"/>'  ></img>
				</c:otherwise>
			</c:choose>
		</span>
		<br/>
	</c:if>
	<c:if test="${!empty contract_DisplayTCBean.displayText[1]}">
		<span id="WC_MyAccountCenterLinkDisplay_displayText1">
			<c:out value="${contract_DisplayTCBean.displayText[1]}"/>
			<br/>
		</span>
	</c:if>
	<c:if test="${!empty contract_DisplayTCBean.displayText[2]}">
		<span id="WC_MyAccountCenterLinkDisplay_displayText2">
			<c:out value="${contract_DisplayTCBean.displayText[2]}"/>
			<br/>
		</span>
	</c:if>
</c:if>
<div class="myaccount_desc_title">
	<fmt:message key="MA_WELCOME" >
		<fmt:param><c:out value="${firstName}"/></fmt:param>
		<fmt:param><c:out value="${middleName}"/></fmt:param>
		<fmt:param><c:out value="${lastName}"/></fmt:param>
	</fmt:message>
</div>
<p class="myaccount_desc"><fmt:message key="MA_YOURACC" /></p>
<br />
<div class="myaccount_section_header around_border" id="WC_MyAccountCenterLinkDisplay_div_1">
	<div class="left_corner" id="WC_MyAccountCenterLinkDisplay_div_2"></div>
	<div  id="WC_MyAccountCenterLinkDisplay_div_3"><span class="header"><fmt:message key="MA_PERSONAL_INFO" /></span></div>
	<div class="right_corner" id="WC_MyAccountCenterLinkDisplay_div_4"></div>
</div>
<div class="content" id="WC_MyAccountCenterLinkDisplay_div_5">
	<div class="info" id="WC_MyAccountCenterLinkDisplay_div_6">
		<div class="info_table">
			<div class="row">
				<div class="label"><fmt:message key="MA_NAME" /></div>
				<div class="info_content">
				<%-- Use a single c:out and space if useCDataTrim is on --%>
				<c:choose>
					<c:when test="${locale == 'ja_JP' || locale == 'ko_KR' || locale == 'zh_CN' || locale == 'zh_TW'}">
						<c:out value="${lastName} ${firstName}"/>
					</c:when>
					<c:otherwise>
						<c:out value="${firstName} ${middleName} ${lastName}"/>
					</c:otherwise>
				</c:choose>
				</div>
				<div class="clear_float"></div>
			</div>
			<div class="row">
				<div class="label"><fmt:message key="MA_ADDRESS" /></div>
				<div class="info_content"><c:out value="${street} ${street2}"/></div>
				<div class="clear_float"></div>
			</div>
			<div class="row">
				<div class="label"><fmt:message key="MA_CITY" /></div>
				<div class="info_content"><c:out value="${city}"/></div>
				<div class="clear_float"></div>
			</div>
			<div class="row">
				<div class="label"><fmt:message key="MA_EMAIL" /></div>
				<div class="info_content"><c:out value="${email1}"/></div>
				<div class="clear_float"></div>
			</div>
		</div>
		<br />
		
		<%--
		===============================================
		--%>

		<%@ include file="AccountSCDisplayExt.jspf" %> 
					
		<%--
		===============================================
		--%>
		
		<p><a href="<c:out value='${userRegistrationFormURL}' />" class="myaccount_link hover_underline" id="WC_MyAccountCenterLinkDisplay_inputs_1"><fmt:message key="MA_EDIT" /></a></p>
	</div>
</div>
<div class="footer" id="WC_MyAccountCenterLinkDisplay_div_7">
	<div class="left_corner" id="WC_MyAccountCenterLinkDisplay_div_8"></div>
	<div  id="WC_MyAccountCenterLinkDisplay_div_9"></div>
	<div class="right_corner" id="WC_MyAccountCenterLinkDisplay_div_10"></div>
</div>
<p class="space" />
<flow:ifEnabled feature="TrackingStatus">
	<div class="myaccount_section_header around_border" id="WC_MyAccountCenterLinkDisplay_div_11">
		<div class="left_corner" id="WC_MyAccountCenterLinkDisplay_div_12"></div>
		<div  id="WC_MyAccountCenterLinkDisplay_div_13"><span class="header"><fmt:message key="MA_RECENT_ORDER_HISTORY" /></span></div>
		<div class="right_corner" id="WC_MyAccountCenterLinkDisplay_div_14"></div>
	</div>
	<div class="content" id="WC_MyAccountCenterLinkDisplay_div_15">
		<div class="info" id="WC_MyAccountCenterLinkDisplay_div_16">
			<% out.flush(); %>
				<c:import url="${env_jspStoreDir}/Snippets/Order/Cart/OrderStatusTableDisplay.jsp" >
					<c:param name="isMyAccountMainPage" value="true"/>
				</c:import>
			<% out.flush();%>				
			<a href="<c:out value='${trackOrderStatusURL}'/>" class="myaccount_link hover_underline" id="WC_MyAccountCenterLinkDisplay_inputs_2"><fmt:message key="MA_VIEWALL" /></a>
			<br clear="all" />
		</div>
	</div>
	<div class="footer" id="WC_MyAccountCenterLinkDisplay_div_17">
		<div class="left_corner" id="WC_MyAccountCenterLinkDisplay_div_18"></div>
		<div  id="WC_MyAccountCenterLinkDisplay_div_19"></div>
		<div class="right_corner" id="WC_MyAccountCenterLinkDisplay_div_20"></div>
	</div>
	<p class="space" />
	<flow:ifEnabled feature="RecurringOrders">
		<div class="myaccount_section_header around_border" id="WC_MyAccountCenterLinkDisplay_div_56">
			<div class="left_corner" id="WC_MyAccountCenterLinkDisplay_div_57"></div>
			<div  id="WC_MyAccountCenterLinkDisplay_div_58"><span class="header"><fmt:message key="MA_RECENT_SCHEDULEDORDERS" /></span></div>
			<div class="right_corner" id="WC_MyAccountCenterLinkDisplay_div_59"></div>
		</div>
		<div class="content" id="WC_MyAccountCenterLinkDisplay_div_60">
			<div class="info" id="WC_MyAccountCenterLinkDisplay_div_61">
				<% out.flush(); %>
					<c:import url="${env_jspStoreDir}/Snippets/Subscription/RecurringOrder/RecurringOrderTableDisplay.jsp" >
						<c:param name="isMyAccountMainPage" value="true"/>
					</c:import>
				<% out.flush();%>				
				<a href="<c:out value='${trackRecurringOrderStatusURL}'/>" class="myaccount_link hover_underline" id="WC_MyAccountCenterLinkDisplay_inputs_4"><fmt:message key="MA_VIEWALL_SCHEDULEDORDERS" /></a>
				<br clear="all" />
			</div>
		</div>
		<div class="footer" id="WC_MyAccountCenterLinkDisplay_div_62">
			<div class="left_corner" id="WC_MyAccountCenterLinkDisplay_div_63"></div>
			<div  id="WC_MyAccountCenterLinkDisplay_div_64"></div>
			<div class="right_corner" id="WC_MyAccountCenterLinkDisplay_div_65"></div>
		</div>
		<p class="space" />
	</flow:ifEnabled>
	<flow:ifEnabled feature="Subscription">
		<div class="myaccount_section_header around_border" id="WC_MyAccountCenterLinkDisplay_div_66">
			<div class="left_corner" id="WC_MyAccountCenterLinkDisplay_div_67"></div>
			<div  id="WC_MyAccountCenterLinkDisplay_div_68"><span class="header"><fmt:message key="MA_RECENT_SUBSCRIPTIONS" /></span></div>
			<div class="right_corner" id="WC_MyAccountCenterLinkDisplay_div_69"></div>
		</div>
		<div class="content" id="WC_MyAccountCenterLinkDisplay_div_70">
			<div class="info" id="WC_MyAccountCenterLinkDisplay_div_71">
				<% out.flush(); %>
					<c:import url="${env_jspStoreDir}/Snippets/Subscription/SubscriptionTableDisplay.jsp" >
						<c:param name="isMyAccountMainPage" value="true"/>
					</c:import>
				<% out.flush();%>				
				<a href="<c:out value='${trackSubscriptionStatusURL}'/>" class="myaccount_link hover_underline" id="WC_MyAccountCenterLinkDisplay_inputs_5"><fmt:message key="MA_VIEWALL_SUBSCRIPTIONS" /></a>
				<br clear="all" />
			</div>
		</div>
		<div class="footer" id="WC_MyAccountCenterLinkDisplay_div_72">
			<div class="left_corner" id="WC_MyAccountCenterLinkDisplay_div_73"></div>
			<div  id="WC_MyAccountCenterLinkDisplay_div_74"></div>
			<div class="right_corner" id="WC_MyAccountCenterLinkDisplay_div_75"></div>
		</div>
		<p class="space" />
	</flow:ifEnabled>
	<flow:ifEnabled feature="EnableQuotes">
		<div class="contentgrad_header" id="WC_MyAccountCenterLinkDisplay_div_46">
			<div class="left_corner" id="WC_MyAccountCenterLinkDisplay_div_47"></div>
			<div  id="WC_MyAccountCenterLinkDisplay_div_48"><span class="header"><fmt:message key="MA_RECENTQUOTES" /></span></div>
			<div class="right_corner" id="WC_MyAccountCenterLinkDisplay_div_49"></div>
		</div>
		<div class="content" id="WC_MyAccountCenterLinkDisplay_div_50">
			<div class="info" id="WC_MyAccountCenterLinkDisplay_div_51">
				<% out.flush(); %>
					<c:import url="${env_jspStoreDir}/Snippets/Order/Cart/OrderStatusTableDisplay.jsp" >
						<c:param name="isMyAccountMainPage" value="true"/>
						<c:param name="isQuote" value="true"/>
					</c:import>
				<% out.flush();%>				
				<a href="<c:out value='${trackQuoteStatusURL}'/>" class="myaccount_link hover_underline" id="WC_MyAccountCenterLinkDisplay_inputs_3"><fmt:message key="MA_VIEWALL_QUOTES" /></a>
				<br clear="all" />
			</div>
		</div>
		<div class="footer" id="WC_MyAccountCenterLinkDisplay_div_52">
			<div class="left_corner" id="WC_MyAccountCenterLinkDisplay_div_53"></div>
			<div  id="WC_MyAccountCenterLinkDisplay_div_54"></div>
			<div class="right_corner" id="WC_MyAccountCenterLinkDisplay_div_55"></div>
		</div>
		<p class="space" />
	</flow:ifEnabled>
</flow:ifEnabled>

<flow:ifEnabled feature="accountParticipantRole">
	<%@ include file="B2BMyAccountParticipantRole.jspf" %>
	<p class="space" />
</flow:ifEnabled> 

<c:if test="${WCParam.myAcctUpdate == 1}">
</div>
<div class="footer" id="WC_MyAccountCenterLinkDisplay_div_32">
	<div class="left_corner" id="WC_MyAccountCenterLinkDisplay_div_33"></div>
	<div class="tile" id="WC_MyAccountCenterLinkDisplay_div_34"></div>
	<div class="right_corner" id="WC_MyAccountCenterLinkDisplay_div_35"></div>
</div>
</div>
</div>
</c:if>
<!-- END MyAccountCenterLinkDisplay.jsp -->
