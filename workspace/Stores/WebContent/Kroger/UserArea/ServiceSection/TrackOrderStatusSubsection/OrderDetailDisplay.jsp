<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2008, 2009 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
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
<c:set var="hasBreadCrumbTrail" value="false" scope="request"/>

<wcf:url var="RecurringOrderChildOrdersTableDetailsDisplayURL" value="RecurringOrderChildOrdersTableDetailsDisplay" type="Ajax">
	<wcf:param name="storeId"   value="${WCParam.storeId}"  />
	<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
	<wcf:param name="langId" value="${langId}" />
</wcf:url>
<wcf:url var="SubscriptionChildOrdersTableDetailsDisplayURL" value="SubscriptionChildOrdersTableDetailsDisplay" type="Ajax">
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
<!-- BEGIN OrderDetailDisplay.jsp -->
<html xmlns="http://www.w3.org/1999/xhtml" lang="${shortLocale}" xml:lang="${shortLocale}">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>
		<c:choose>
			<c:when test="${WCParam.isQuote eq true}">
				<fmt:message key='MO_MYQUOTES'/>
			</c:when>
			<c:otherwise>
				<fmt:message key='MO_MYORDERS'/>
			</c:otherwise>
		</c:choose>
	</title>
	
	<link rel="stylesheet" href="<c:out value="${jspStoreImgDir}${env_vfileStylesheet}"/>" type="text/css"/>
	
	<%@ include file="../../../Common/CommonJSToInclude.jspf"%>
	
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Widgets/Search.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Widgets/MiniShopCartDisplay/MiniShopCartDisplay.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Widgets/Department/Department.js"/>"></script>	
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Common/ShoppingActions.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/CommonContextsDeclarations.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/CommonControllersDeclaration.js"/>"></script>
	
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/UserArea/MyAccountDisplay.js"/>"></script>
	<script type="text/javascript" src="<c:out value='${jsAssetsDir}javascript/CheckoutArea/Punchout.js'/>"></script>
	<script type="text/javascript" src="<c:out value='${jsAssetsDir}javascript/UserArea/MyAccountControllersDeclaration.js'/>"></script>
	
	<%@ include file="../../../Common/CommonJSPFToInclude.jspf"%>
	
	<script type="text/javascript">
		dojo.addOnLoad(function() {
			MyAccountControllersDeclarationJS.setControllerURL("RecurringOrderChildOrdersDisplayController", "<c:out value='${RecurringOrderChildOrdersTableDetailsDisplayURL}'/>");
			MyAccountControllersDeclarationJS.setControllerURL("SubscriptionChildOrdersDisplayController", "<c:out value='${SubscriptionChildOrdersTableDetailsDisplayURL}'/>");
		});
	</script>
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
									<flow:ifEnabled feature="SideBySideIntegration">
										<c:choose>
											<c:when test="${!empty WCParam.externalOrderId}">
												<% out.flush(); %>
													<c:import url="../../../Snippets/Order/SterlingIntegration/SBSOrderDetails.jsp" >
													</c:import>
												<% out.flush(); %>
											</c:when>
											<c:otherwise>
												<% out.flush(); %>
												<c:import url="../../../Snippets/Order/Ship/OrderShipmentDetails.jsp" >
													<c:param name= "showCurrentCharges" value= "true"/>
													<c:param name= "showFutureCharges"  value= "true"/>
												</c:import>
												<% out.flush();%>
											</c:otherwise>
										</c:choose>
									</flow:ifEnabled>
									<flow:ifDisabled feature="SideBySideIntegration">
										<% out.flush(); %>
										<c:import url="../../../Snippets/Order/Ship/OrderShipmentDetails.jsp" >
											<c:param name= "showCurrentCharges" value= "true"/>
											<c:param name= "showFutureCharges"  value= "true"/>
										</c:import>
										<% out.flush();%>
									</flow:ifDisabled>
								</div>
								<div class="clear_float"></div>
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
<!-- END OrderDetailDisplay.jsp -->
