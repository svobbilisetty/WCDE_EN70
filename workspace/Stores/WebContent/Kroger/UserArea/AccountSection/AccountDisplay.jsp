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

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ include file="../../Common/EnvironmentSetup.jspf" %>
<%@ include file="../../include/ErrorMessageSetup.jspf" %>
<%@ include file="../../Common/nocache.jspf" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="http://commerce.ibm.com/coremetrics"  prefix="cm" %>

<!-- BEGIN AccountDisplay.jsp -->
<html lang="${shortLocale}" xml:lang="${shortLocale}">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<%@ include file="../../Common/CommonJSToInclude.jspf" %>	
	
	<link rel="stylesheet" href="<c:out value="${jspStoreImgDir}${env_vfileStylesheet}"/>" type="text/css"/>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Widgets/Search.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Widgets/MiniShopCartDisplay/MiniShopCartDisplay.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Widgets/Department/Department.js"/>"></script>	
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Common/ShoppingActions.js"/>"></script>
			
	<title><fmt:message key="REGISTER_LOGIN"/></title>
</head>

<body>

<div id="page">

	<%@ include file="../../Common/CommonJSPFToInclude.jspf"%>	

	<!-- Header Nav Start -->
	<c:if test="${b2bStore eq 'true'}">
    	<c:if test="${userType =='G'}">
			<c:set var="hideHeader" value="true"/>
		</c:if>
	</c:if>
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
						<div class="sign_in_registration" id="WC_AccountDisplay_div_1">
							<%@include file="AccountDisplayContent.jspf" %>
							<br clear="all"/>
							<div class="ad" id="WC_AccountDisplay_div_31">
								<%out.flush();%>
								<c:import url="${env_jspStoreDir}/Widgets/ESpot/ContentRecommendation/ContentRecommendation.jsp">
									<c:param name="emsName" value="SignInPageESpot" />
									<c:param name="numberContentPerRow" value="1" />
									<c:param name="catalogId" value="${WCParam.catalogId}" />
									<c:param name="errorViewName" value="AjaxOrderItemDisplayView" />
								</c:import>
								<%out.flush();%>
							</div>
							<br />
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
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
<!-- END AccountDisplay.jsp -->
