
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ include file="../../../Common/EnvironmentSetup.jspf" %>
<%@ include file="../../../Common/nocache.jspf" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="http://commerce.ibm.com/coremetrics"  prefix="cm" %>

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
<!-- BEGIN PasswordResetDisplay.jsp -->
<html xmlns="http://www.w3.org/1999/xhtml" lang="${shortLocale}" xml:lang="${shortLocale}">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title><fmt:message key="PASSWORD_TITLE"/></title>
	<link rel="stylesheet" href="<c:out value="${jspStoreImgDir}${env_vfileStylesheet}"/>" type="text/css"/>
	<%@ include file="../../../Common/CommonJSToInclude.jspf"%>

	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Widgets/Search.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Widgets/MiniShopCartDisplay/MiniShopCartDisplay.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Widgets/Department/Department.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Common/ShoppingActions.js"/>"></script>
	
</head>
<body>

<%@ include file="../../../Common/CommonJSPFToInclude.jspf"%>
	
<!-- Page Start -->
<div id="page">
	<!-- Header Nav Start -->
	<c:if test="${b2bStore eq 'true'}">
		<c:if test="${userType =='G'}">
			<c:set var="hideHeader" value="true"/>
		</c:if>
	</c:if>
	
	<!-- Header Widget -->
	<div class="header_wrapper_position" id="headerWidget">
		<%out.flush();%>
		<c:import url = "${env_jspStoreDir}/Widgets/Header/Header.jsp" />
		<%out.flush();%>
	</div>

	<!-- Main Content Start -->
	<div class="content_wrapper_position" role="main">
		<div class="content_wrapper">
			<div class="content_left_shadow">
				<div class="content_right_shadow">
					<div class="main_content">
						<div class="container_full_width" id="content_wrapper_border">
							<!-- Content Start -->
							<div id="box">
				
								<div class="content" id="WC_PasswordResetDisplay_div_1">
					
								<br clear="all"/>
					
								<%-- A message is displayed confirming that the forget password email is sent --%>
								<span class="strong"><fmt:message key="PASSWORD_SENT"/></span>
								<br/>
					
								<wcf:url var="LogonFormURL" value="LogonForm">
									<wcf:param name="storeId"   value="${WCParam.storeId}"  />
									<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
									<wcf:param name="langId" value="${langId}" />
									<wcf:param name="myAcctMain" value="1"/>
								</wcf:url>
								
								<div class="button_footer_line">
									<a href="#" role="button" class="button_primary" id="WC_PasswordResetDisplay_Link_1" onclick="javascript:setPageLocation('<c:out value="${LogonFormURL}"/>')">
										<div class="left_border"></div>
										<div class="button_text"><fmt:message key="CONTINUE_LOGIN"/></div>
										<div class="right_border"></div>
									</a>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- Footer Start Start -->
	<div class="footer_wrapper_position">
		<%out.flush();%>
		<c:import url = "${env_jspStoreDir}/Widgets/Footer/Footer.jsp" />
		<%out.flush();%>
	</div> 
    <!-- Footer Start End -->
</div>

<flow:ifEnabled feature="Analytics"><cm:pageview/></flow:ifEnabled>
</body>
</html>
<!-- END PasswordResetDisplay.jsp -->
