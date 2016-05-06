
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ include file="../../../Common/EnvironmentSetup.jspf"%>
<%@ include file="../../../Common/nocache.jspf" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>    
<%@ taglib uri="http://commerce.ibm.com/coremetrics"  prefix="cm" %>
<%-- ErrorMessageSetup.jspf is used to retrieve an appropriate error message when there is an error --%>
<%@ include file="../../../include/ErrorMessageSetup.jspf" %>

<c:set var="myAccountPage" value="true" scope="request"/>
<c:set var="hasBreadCrumbTrail" value="false" scope="request"/>

<wcf:url var="couponWalletTableView" value="CouponWalletTableView" type="Ajax">
	<wcf:param name="storeId"   value="${WCParam.storeId}"  />
	<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
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
<!-- BEGIN CouponWalletDisplay.jsp -->
<html xmlns="http://www.w3.org/1999/xhtml" lang="${shortLocale}" xml:lang="${shortLocale}">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title><fmt:message key="MYACCOUNT_MY_COUPONS"/></title>
	<link rel="stylesheet" href="<c:out value="${jspStoreImgDir}${env_vfileStylesheet}"/>" type="text/css"/>
	<%@ include file="../../../Common/CommonJSToInclude.jspf"%>

	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Widgets/Search.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Widgets/MiniShopCartDisplay/MiniShopCartDisplay.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Widgets/Department/Department.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/CommonContextsDeclarations.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/CommonControllersDeclaration.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Common/ShoppingActions.js"/>"></script>

	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/UserArea/AddressHelper.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/UserArea/MyAccountDisplay.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/UserArea/MyAccountServicesDeclaration.js"/>"></script>
	<script type="text/javascript">
		MyAccountServicesDeclarationJS.setCommonParameters('<c:out value='${WCParam.langId}'/>','<c:out value='${WCParam.storeId}'/>','<c:out value='${WCParam.catalogId}'/>');
	</script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/ServicesDeclaration.js"/>"></script>
	
	<%@ include file="../../../Common/CommonJSPFToInclude.jspf"%>
</head>
<body>

<!-- Page Start -->
<div id="page">
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
								<!-- Right Nav Start -->

							    <!-- Main Content Start -->
								<div id="box">	
									<div class="left" id="WC_AccountForm_div_1">
										<%-- 
										***
										*	Start: Error handling
										* Show an appropriate error message when a user enters invalid information into the form.
										***
										--%>
					
										<c:if test="${!empty errorMessage}">
											<c:out value="${errorMessage}"/><br /><br />
										</c:if>
										<%-- 
										***
										*	End: Error handling
										***
										--%>	
									</div>
									<div class="my_account" id="WC_NonAjaxCouponWalletDisplay_div_1">		
										<h2 class="myaccount_header bottom_line"><fmt:message key='MYACCOUNT_MY_COUPONS'/></h2>
									
										<span id="CouponDisplay_Widget_ACCE_Label" class="spanacce"><fmt:message key="MYACCOUNT_MY_COUPONS" /></span>
										<div class="body left" id="WC_NonAjaxCouponWalletDisplay_div_6">
											<div class="couponWalletContainer" dojoType="wc.widget.RefreshArea" id="CouponDisplay_Widget" controllerId="CouponDisplay_Controller" role="region" aria-labelledby="CouponDisplay_Widget_ACCE_Label">
												<%out.flush();%>
												<c:import url="/${sdb.jspStoreDir}/Snippets/Marketing/Promotions/CouponWalletTable.jsp">
													<c:param name="returnView" value="${couponWalletTableView}" />
												</c:import>
												<%out.flush();%>
											</div>
											<script type="text/javascript">dojo.addOnLoad(function() { parseWidget("CouponDisplay_Widget"); });</script>
											<br/>								
											<br clear="all" />					
										</div>
										<div class="footer" id="WC_NonAjaxCouponWalletDisplay_div_7">
											<div class="left_corner" id="WC_NonAjaxCouponWalletDisplay_div_8"></div>
											<div class="tile" id="WC_NonAjaxCouponWalletDisplay_div_9"></div>
											<div class="right_corner" id="WC_NonAjaxCouponWalletDisplay_div_10"></div>
										</div>
									</div>
								</div>
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
</div>
<flow:ifEnabled feature="Analytics"><cm:pageview/></flow:ifEnabled>
</body>
</html>
<!-- END CouponWalletDisplay.jsp -->
