
<%@ page import="com.ibm.commerce.member.facade.client.MemberFacadeClient" %>
<%@ page import="com.ibm.commerce.member.facade.datatypes.PersonType" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ include file="../../../Common/EnvironmentSetup.jspf" %>
<%@ include file="../../../Common/nocache.jspf" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>             
<%@ taglib uri="http://commerce.ibm.com/coremetrics"  prefix="cm" %>
<%@ include file="../../../include/ErrorMessageSetup.jspf" %>
<c:set var="myAccountPage" value="true" scope="request"/>

<wcf:url var="EditAddAddressURL" value="AjaxAccountAddressForm" type="Ajax">
	<wcf:param name="storeId"   value="${WCParam.storeId}"  />
	<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
	<wcf:param name="langId" value="${langId}" />
</wcf:url>

<wcf:url var="addressBookFormURL" value="AjaxAddressBookForm" type="Ajax">
	<wcf:param name="storeId"   value="${param.storeId}"  />
	<wcf:param name="catalogId" value="${param.catalogId}"/>
	<wcf:param name="langId" value="${langId}" />
</wcf:url>

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
<!-- BEGIN AddressBookForm.jsp -->
<html xmlns="http://www.w3.org/1999/xhtml" lang="${shortLocale}" xml:lang="${shortLocale}">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title><fmt:message key="ADDRESSBOOK_TITLE"/></title>
	<link rel="stylesheet" href="<c:out value="${jspStoreImgDir}${env_vfileStylesheet}"/>" type="text/css"/>
	
	<%@ include file="../../../Common/CommonJSToInclude.jspf"%>
	<%@ include file="../../../include/ErrorMessageSetupBrazilExt.jspf" %>

	<script type="text/javascript" src="<c:out value="${jsAssetsDir}/javascript/Widgets/Search.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}/javascript/Widgets/MiniShopCartDisplay/MiniShopCartDisplay.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}/javascript/Widgets/Department/Department.js"/>"></script>
	
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Common/ShoppingActions.js"/>"></script>
	
	<%-- CommonContexts must come before CommonControllers --%>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/CommonContextsDeclarations.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/CommonControllersDeclaration.js"/>"></script>

	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/UserArea/AddressHelper.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/UserArea/AddressBookForm.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/UserArea/MyAccountDisplay.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/UserArea/AccountWishListDisplay.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/UserArea/QuickCheckoutProfile.js"/>"></script>
	
	<%@ include file="../../../Common/CommonJSPFToInclude.jspf"%>
	
	<script type="text/javascript">
		dojo.require("wc.render.common");
		wc.render.declareContext("addressBookContext",{addressId: "0", type: "0"},"");
		
		wc.render.declareRefreshController({
			id: "addressBookController",
			renderContext: wc.render.getContextById("addressBookContext"),
			url: "${EditAddAddressURL}",
			formId: ""
			
			,renderContextChangedHandler: function(message, widget) {
				var controller = this;
				var renderContext = this.renderContext;
				
				if (controller.testForChangedRC(["addressId"])) {
					widget.refresh(renderContext.properties);
				} else if (controller.renderContext.properties["type"] == "add") {
					widget.refresh(renderContext.properties);
				}	 
			}
	
			,postRefreshHandler: function(widget) {
				var controller = this;
				var renderContext = this.renderContext;
				controller.renderContext.properties["addressId"] = "0";
				controller.renderContext.properties["type"] = "0";
			}
		});
	
		wc.render.declareRefreshController({
			id: "addressBookMainController",
			renderContext: wc.render.getContextById("addressBookContext"),
			url: "${addressBookFormURL}",
			formId: ""
	
			,modelChangedHandler: function(message, widget) {
				var controller = this;
				var renderContext = this.renderContext;
				
				if (message.actionId == "updateAddress" || message.actionId == "AddressDelete" || message.actionId == "updateAddressBook" ) {
					widget.refresh(renderContext.properties);
				}
			}
		});
		
		//messages used by AddressBookForm.js
		dojo.addOnLoad(function() { 
			<fmt:message key="ERROR_RecipientTooLong" var="ERROR_RecipientTooLong"/>
			<fmt:message key="ERROR_FirstNameTooLong" var="ERROR_FirstNameTooLong"/>
			<fmt:message key="ERROR_LastNameTooLong" var="ERROR_LastNameTooLong"/>
			<fmt:message key="ERROR_MiddleNameTooLong" var="ERROR_MiddleNameTooLong"/>
			<fmt:message key="ERROR_AddressTooLong" var="ERROR_AddressTooLong"/>
			<fmt:message key="ERROR_CityTooLong" var="ERROR_CityTooLong"/>
			<fmt:message key="ERROR_StateTooLong" var="ERROR_StateTooLong"/>
			<fmt:message key="ERROR_CountryTooLong" var="ERROR_CountryTooLong"/>
			<fmt:message key="ERROR_ZipCodeTooLong" var="ERROR_ZipCodeTooLong"/>
			<fmt:message key="ERROR_PhoneTooLong" var="ERROR_PhoneTooLong"/>
			<fmt:message key="ERROR_RecipientEmpty" var="ERROR_RecipientEmpty"/>
			<fmt:message key="ERROR_FirstNameEmpty" var="ERROR_FirstNameEmpty"/>
			<fmt:message key="ERROR_LastNameEmpty" var="ERROR_LastNameEmpty"/>
			<fmt:message key="ERROR_MiddleNameEmpty" var="ERROR_MiddleNameEmpty"/>
			<fmt:message key="ERROR_AddressEmpty" var="ERROR_AddressEmpty"/>
			<fmt:message key="ERROR_CityEmpty" var="ERROR_CityEmpty"/>
			<fmt:message key="ERROR_StateEmpty" var="ERROR_StateEmpty"/>
			<fmt:message key="ERROR_CountryEmpty" var="ERROR_CountryEmpty"/>
			<fmt:message key="ERROR_ZipCodeEmpty" var="ERROR_ZipCodeEmpty"/>
			<fmt:message key="ERROR_PhonenumberEmpty" var="ERROR_PhonenumberEmpty"/>
			<fmt:message key="ERROR_EmailEmpty" var="ERROR_EmailEmpty"/>
			<fmt:message key="PWDREENTER_DO_NOT_MATCH" var="PWDREENTER_DO_NOT_MATCH"/>
			<fmt:message key="REQUIRED_FIELD_ENTER" var="REQUIRED_FIELD_ENTER"/>
			<fmt:message key="AB_UPDATE_SUCCESS" var="AB_UPDATE_SUCCESS"/>
			<fmt:message key="AB_DELETE_SUCCESS" var="AB_DELETE_SUCCESS"/>
			<fmt:message key="AB_ADDNEW_SUCCESS" var="AB_ADDNEW_SUCCESS"/>
			<fmt:message key="WISHLIST_INVALIDEMAILFORMAT" var="WISHLIST_INVALIDEMAILFORMAT"/>
			<fmt:message key="ERROR_INVALIDPHONE" var="ERROR_INVALIDPHONE"/>
			<fmt:message key="AB_SELECT_ADDRTYPE" var="AB_SELECT_ADDRTYPE"/>
			<fmt:message key="ERROR_DEFAULTADDRESS" var="ERROR_DEFAULTADDRESS"/>
			<fmt:message key="ERROR_INVALIDEMAILFORMAT" var="ERROR_INVALIDEMAILFORMAT"/>
	
			MessageHelper.setMessage("ERROR_RecipientTooLong", <wcf:json object="${ERROR_RecipientTooLong}"/>);
			MessageHelper.setMessage("ERROR_FirstNameTooLong", <wcf:json object="${ERROR_FirstNameTooLong}"/>);
			MessageHelper.setMessage("ERROR_LastNameTooLong", <wcf:json object="${ERROR_LastNameTooLong}"/>);
			MessageHelper.setMessage("ERROR_MiddleNameTooLong", <wcf:json object="${ERROR_MiddleNameTooLong}"/>);
			MessageHelper.setMessage("ERROR_AddressTooLong", <wcf:json object="${ERROR_AddressTooLong}"/>);
			MessageHelper.setMessage("ERROR_CityTooLong", <wcf:json object="${ERROR_CityTooLong}"/>);
			MessageHelper.setMessage("ERROR_StateTooLong", <wcf:json object="${ERROR_StateTooLong}"/>);
			MessageHelper.setMessage("ERROR_CountryTooLong", <wcf:json object="${ERROR_CountryTooLong}"/>);
			MessageHelper.setMessage("ERROR_ZipCodeTooLong", <wcf:json object="${ERROR_ZipCodeTooLong}"/>);
			MessageHelper.setMessage("ERROR_PhoneTooLong", <wcf:json object="${ERROR_PhoneTooLong}"/>);
			MessageHelper.setMessage("ERROR_RecipientEmpty", <wcf:json object="${ERROR_RecipientEmpty}"/>);
			/*Although for English, firstname is not mandatory. But it is mandatory for other languages.*/
			MessageHelper.setMessage("ERROR_FirstNameEmpty", <wcf:json object="${ERROR_FirstNameEmpty}"/>);
			MessageHelper.setMessage("ERROR_LastNameEmpty", <wcf:json object="${ERROR_LastNameEmpty}"/>);
			MessageHelper.setMessage("ERROR_MiddleNameEmpty", <wcf:json object="${ERROR_MiddleNameEmpty}"/>);
			MessageHelper.setMessage("ERROR_AddressEmpty", <wcf:json object="${ERROR_AddressEmpty}"/>);
			MessageHelper.setMessage("ERROR_CityEmpty", <wcf:json object="${ERROR_CityEmpty}"/>);
			MessageHelper.setMessage("ERROR_StateEmpty", <wcf:json object="${ERROR_StateEmpty}"/>);
			MessageHelper.setMessage("ERROR_CountryEmpty", <wcf:json object="${ERROR_CountryEmpty}"/>);
			MessageHelper.setMessage("ERROR_ZipCodeEmpty", <wcf:json object="${ERROR_ZipCodeEmpty}"/>);
			MessageHelper.setMessage("ERROR_PhonenumberEmpty", <wcf:json object="${ERROR_PhonenumberEmpty}"/>);
			MessageHelper.setMessage("ERROR_EmailEmpty", <wcf:json object="${ERROR_EmailEmpty}"/>);
			MessageHelper.setMessage("PWDREENTER_DO_NOT_MATCH", <wcf:json object="${PWDREENTER_DO_NOT_MATCH}"/>);
			MessageHelper.setMessage("REQUIRED_FIELD_ENTER", <wcf:json object="${REQUIRED_FIELD_ENTER}"/>);
			MessageHelper.setMessage("AB_UPDATE_SUCCESS", <wcf:json object="${AB_UPDATE_SUCCESS}"/>);
			MessageHelper.setMessage("AB_DELETE_SUCCESS", <wcf:json object="${AB_DELETE_SUCCESS}"/>);
			MessageHelper.setMessage("AB_ADDNEW_SUCCESS", <wcf:json object="${AB_ADDNEW_SUCCESS}"/>);
			MessageHelper.setMessage("WISHLIST_INVALIDEMAILFORMAT", <wcf:json object="${WISHLIST_INVALIDEMAILFORMAT}"/>);
			MessageHelper.setMessage("ERROR_INVALIDPHONE", <wcf:json object="${ERROR_INVALIDPHONE}"/>);
			MessageHelper.setMessage("AB_SELECT_ADDRTYPE", <wcf:json object="${AB_SELECT_ADDRTYPE}"/>);
			MessageHelper.setMessage("ERROR_DEFAULTADDRESS", <wcf:json object="${ERROR_DEFAULTADDRESS}"/>);
			MessageHelper.setMessage("ERROR_INVALIDEMAILFORMAT", <wcf:json object="${ERROR_INVALIDEMAILFORMAT}"/>);
			
			AddressBookFormJS.setCommonParameters("<c:out value='${langId}'/>", "<c:out value='${WCParam.storeId}'/>","<c:out value='${WCParam.catalogId}'/>");
		});
		
	</script>
</head>
<body>

<div id="page">
	<!-- Import Header Widget -->
	<div class="header_wrapper_position" id="headerWidget">
		<%out.flush();%>
		<c:import url = "${env_jspStoreDir}/Widgets/Header/Header.jsp" />
		<%out.flush();%>
	</div>
	<!-- Header Nav End -->

	<!-- Main Content Start -->
	<div class="content_wrapper_position" role="main">
		<div class="content_wrapper">
			<div class="content_left_shadow">
				<div class="content_right_shadow">
					<div class="main_content">
						<%out.flush();%>
						<c:import url="/${sdb.jspStoreDir}/include/BreadCrumbTrailDisplay.jsp">
							<c:param name="topCategoryPage" value="${requestScope.topCategoryPage}" />
							<c:param name="categoryPage" value="${requestScope.categoryPage}" />
							<c:param name="productPage" value="${requestScope.productPage}" />
							<c:param name="shoppingCartPage" value="${requestScope.shoppingCartPage}" />
							<c:param name="compareProductPage" value="${requestScope.compareProductPage}" />
							<c:param name="finalBreadcrumb" value="${requestScope.finalBreadcrumb}" />
							<c:param name="extensionPageWithBCF" value="${requestScope.extensionPageWithBCF}" />
							<c:param name="hasBreadCrumbTrail" value="${requestScope.hasBreadCrumbTrail}" />
							<c:param name="requestURIPath" value="${requestScope.requestURIPath}" />
							<c:param name="SavedOrderListPage" value="${requestScope.SavedOrderListPage}" />
							<c:param name="pendingOrderDetailsPage" value="${requestScope.pendingOrderDetailsPage}" />
							<c:param name="sharedWishList" value="${requestScope.sharedWishList}" />
							<c:param name="searchPage" value="${requestScope.searchPage}"/>
						</c:import>
						<%out.flush();%>	
						<div class="container_content_leftsidebar">													
						  	<div class="left_column">
						  		<%@ include file="../../../include/LeftSidebarDisplay.jspf"%>
						  	</div>

							<div class="right_column">
								<!-- Main Content Start -->
								<span id="addressBookMainDiv_ACCE_Label" class="spanacce"><fmt:message key="ACCE_Region_Address_List" /></span>
								<div id="addressBookMainDiv" dojoType="wc.widget.RefreshArea" widgetId="addressBookMain" objectId="addressBookMain" controllerId="addressBookMainController" ariaMessage="<fmt:message key="ACCE_Status_Address_List_Updated"/>" ariaLiveId="${ariaMessageNode}" role="region" aria-labelledby="addressBookMainDiv_ACCE_Label">
									<%out.flush();%>
									<c:import url="/${sdb.jspStoreDir}/UserArea/AccountSection/AddressbookSubsection/AjaxAddressBookForm.jsp">  
										<c:param name="storeId" value="${WCParam.storeId}"/>
										<c:param name="catalogId" value="${WCParam.catalogId}"/>  
										<c:param name="langId" value="${langId}"/>
									</c:import>
									<%out.flush();%>  
								</div>
								<script type="text/javascript">dojo.addOnLoad(function() { parseWidget("addressBookMainDiv"); } );</script>
								<!-- Main Content End -->
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<!-- Footer Start -->
	<div class="footer_wrapper_position">
		<%out.flush();%>
			<c:import url = "${env_jspStoreDir}/Widgets/Footer/Footer.jsp" />
		<%out.flush();%>
	</div>
	<!-- Footer End --> 

</div><!-- end class="page" -->

<flow:ifEnabled feature="Analytics"><cm:pageview/></flow:ifEnabled>
</body>
</html>
<!-- END AddressBookForm.jsp -->
