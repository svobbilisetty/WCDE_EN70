


<%-- 
  *****
  * This JSP is called whenever a generic error occurs in the store and no specific errorViewName
  *  has been provided to redirect to.  This page handles 3 situations:
  *  - The store is set to closed or locked state
  *  - The customer is not authorized to access a page they requested
  *  - All other generic errors
  * If the store is closed or locked, a message is displayed to the customer telling them the store is closed.
  * If the user does not have authority to access a specific page, then page redirects to the stores logon page.
  * For all other errors, a generic error message is displayed.
  *****
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ include file="Common/EnvironmentSetup.jspf" %>
<%@ include file="Common/nocache.jspf" %>
<%@ include file="include/ErrorMessageSetup.jspf" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="http://commerce.ibm.com/coremetrics"  prefix="cm" %>
<%@page import="com.ibm.commerce.bi.BIConfigRegistry"%>
<%@ page import="com.ibm.commerce.datatype.WcParam" %>

<flow:fileRef id="vfileLogo" fileId="vfile.logo"/>
<%
	// check to see if the wcparam is available; initialise it if it is not available
	if (null == request.getAttribute(com.ibm.commerce.server.ECConstants.EC_INPUT_PARAM)) {
		request.setAttribute(com.ibm.commerce.server.ECConstants.EC_INPUT_PARAM, new WcParam(request));
	}
	WcParam wcParam = (WcParam) request.getAttribute(com.ibm.commerce.server.ECConstants.EC_INPUT_PARAM);
	CommandContext commandContext = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
	Integer storeId = commandContext.getStoreId();
%>

<c:if test="${empty storeId }">
	<c:set var="storeId" value="${WCParam.storeId}"/>
</c:if>
<c:if test="${empty catalogId }">
	<c:set var="catalogId" value="${WCParam.catalogId}"/>
</c:if>

<c:if test="${empty catalogId}">
	<wcbase:useBean id="storeDB" classname="com.ibm.commerce.common.beans.StoreDataBean"/>			
	<c:set var="catalogId" value="${storeDB.masterCatalogDataBean.catalogId}"/>
</c:if>
		
<wcbase:useBean id="errorBean" classname="com.ibm.commerce.beans.ErrorDataBean"/>
<!DOCTYPE HTML>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2000, 2012 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<html lang="${shortLocale}" xml:lang="${shortLocale}">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

	<title>
		<%--
		//  If the store is closed or suspended, we get the message state _ERR_BAD_STORE_STATE (CMN1072E).
		//  We should display the store is closed page.
		--%>
		
		<c:choose>
			<c:when test="${errorBean.messageKey eq '_ERR_BAD_STORE_STATE'}">
				<fmt:message key="GENERICERR_TEXT3"/> 
			</c:when>
			<c:otherwise>
				<fmt:message key="ERROR_TITLE"/>
			</c:otherwise>
		</c:choose>
	</title>
	<link rel="stylesheet" href="<c:out value="${jspStoreImgDir}${env_vfileStylesheet}"/>" type="text/css"/>
	<script type="text/javascript" src="<c:out value="${dojoFile}"/>" djConfig="${dojoConfigParams}"></script>
	<script>
		if(self!=top){
			top.location.href = location.href;
		}
	</script>
	<%@ include file="Common/CommonJSToInclude.jspf"%>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Widgets/Search.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Widgets/MiniShopCartDisplay/MiniShopCartDisplay.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Widgets/Department/Department.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Common/ShoppingActions.js"/>"></script>
	<%@ include file="Common/CommonJSPFToInclude.jspf"%>
	
	<c:if test="${errorBean.messageKey eq '_ERR_CMD_CMD_NOT_FOUND'}">
		<wcf:url var="homePageUrl" patternName="HomePageURLWithLang" value="TopCategories1">
			<wcf:param name="langId" value="${langId}" />
			<wcf:param name="storeId" value="${storeId}" />
			<wcf:param name="catalogId" value="${catalogId}" />
			<wcf:param name="urlLangId" value="${urlLangId}" />
		</wcf:url> 
		<meta http-equiv="Refresh" content="0;URL=${homePageUrl}"/>
    </c:if>
	
	<script type="text/javascript">
	  dojo.addOnLoad(function() {
			setDeleteCartCookie();
		});
	</script>

</head>
 
<body>

<div id="page">
    <!-- Header Nav Start -->
	<c:choose>
		<c:when test="${!b2bStore}">
			<!-- Import Header Widget -->
			<div class="header_wrapper_position" id="headerWidget">
				<%out.flush();%>
				<c:import url = "${env_jspStoreDir}/Widgets/Header/Header.jsp" />
				<%out.flush();%>
			</div>
			<!-- Header Nav End -->
			<div class="content_wrapper_position">
				<div class="content_wrapper">
					<div class="content_left_shadow">
						<div class="content_right_shadow">
							<div class="main_content">
								<div class="container_full_width">
		</c:when>
		<c:otherwise>
			<div id="header">
				<div id="header_logo">
					<%out.flush();%>
						<c:import url="${env_jspStoreDir}/Widgets/ESpot/ContentRecommendation/ContentRecommendation.jsp">
							<c:param name="storeId" value="${WCParam.storeId}" />
							<c:param name="catalogId" value="${catalogId}" />
							<c:param name="langId" value="${langId}" />
							<c:param name="emsName" value="HeaderStoreLogo_Content" />
							<c:param name="linkId" value="WC_CachedHeaderDisplay_Link_2a" />
						</c:import>
					<%out.flush();%>
				</div>
			</div>
			<!-- Header Nav End -->
			<div class="content_wrapper">
				<div class="content_left_shadow">
					<div class="content_right_shadow">
						<div class="main_content">
							<div class="container_content_leftsidebar">													
							  	<div class="left_column">
							  		<%@ include file="include/LeftSidebarDisplay.jspf"%>
							  	</div>
							  	<div class="right_column"> 
		</c:otherwise>
	</c:choose>

	<!-- Main Content Start -->
	<div id="content_wrapper_border" role="main">
		<!-- Content Start -->
		<div id="box" class="my_account generic_error_container">
			<div id="errorPage">
				<h1 class="myaccount_header"><fmt:message key="ERROR_TITLE"/></h1>
			</div>
				
			<div id="WC_GenericError_5" class="content">
				<div id="WC_GenericError_6" class="info">
					<c:choose>
						<c:when test="${errorBean.messageKey != null}">
							<c:choose>
								<c:when test="${errorBean.messageKey eq '_ERR_USER_AUTHORITY'}">
									<c:choose>
										<c:when test="${userType eq 'G'}">
											<span><fmt:message key="AUTHORIZATION_ERROR1" /></span>
											<br />
											<br />
											<c:url var="LogonFormURL" value="LogonForm">
												<c:param name="storeId" value="${storeId}" />
												<c:param name="langId" value="${langId}" />
												<c:param name="catalogId" value="${catalogId}" />
												<c:param name="myAcctMain" value="1" />
											</c:url>
											<div id="WC_GenericError_7">
												<a href="<c:out value="${LogonFormURL}"/>" class="button_primary" id="WC_GenericError_Link_1">
													<div class="left_border"></div>
													<div class="button_text"><fmt:message key="Logon_Title" /></div>
													<div class="right_border"></div>
												</a>
											</div>
										</c:when>
										<c:otherwise>
											<span><fmt:message key="AUTHORIZATION_ERROR2" /></span>
										</c:otherwise>
									</c:choose>
								</c:when>

								<c:when test="${errorBean.messageKey eq '_ERR_BAD_STORE_STATE'}">
									<span class="warning"><fmt:message key="GENERICERR_TEXT4" /></span>
								</c:when>
									
								<c:when test="${errorBean.messageKey eq '_ERR_INVALID_COOKIE'}">
									<span><fmt:message key="INVALID_COOKIE_ERROR" /></span>
									<br />
									<br />
									<c:url var="LogonFormURL" value="LogonForm">
										<c:param name="storeId" value="${storeId}" />
										<c:param name="langId" value="${langId}" />
										<c:param name="catalogId" value="${catalogId}" />
										<c:param name="myAcctMain" value="1" />
									</c:url>
									<div id="WC_GenericError_7">
										<a href="<c:out value="${LogonFormURL}"/>" class="button_primary" id="WC_GenericError_Link_1">
											<div class="left_border"></div>
											<div class="button_text"><fmt:message key="Logon_Title" /></div>
											<div class="right_border"></div>
										</a>
									</div>
								</c:when>

								<c:when test="${errorBean.messageKey eq '_ERR_CATENTRY_NOT_EXISTING_IN_STORE' || errorBean.messageKey eq '_ERR_PROD_NOT_PUBLISHED' || errorBean.messageKey eq '_ERR_RETRIEVE_PRICE.1002'}">
									<span><fmt:message key="PRODUCT_ERROR" /></span>
								</c:when>

								<c:otherwise>
									<flow:ifEnabled feature="ProductionServer">
										<span >
										<fmt:message key="GENERICERR_MAINTEXT">                                     
											<fmt:param><fmt:message key="GENERICERR_CONTACT_US" /></fmt:param>
										</fmt:message>
										</span>
										<br />
									</flow:ifEnabled>
									<flow:ifDisabled feature="ProductionServer">
										<span ><fmt:message key="GENERICERR_TEXT1" /></span>
										<br />
										<span><fmt:message key="GENERICERR_TEXT2" /></span>
									</flow:ifDisabled>
								</c:otherwise>
							</c:choose>
						</c:when>

						<c:otherwise>
							<flow:ifEnabled feature="ProductionServer">
								<span >
								<fmt:message key="GENERICERR_MAINTEXT">                                     
									<fmt:param><fmt:message key="GENERICERR_CONTACT_US" /></fmt:param>
								</fmt:message>
								</span>
								<br />
							</flow:ifEnabled>
							<flow:ifDisabled feature="ProductionServer">
								<span ><fmt:message key="GENERICERR_TEXT1" /></span>
								<br />
								<span><fmt:message key="GENERICERR_TEXT2" /></span>
							</flow:ifDisabled>								
						</c:otherwise>

					</c:choose>

					<br /><br />
					<flow:ifDisabled feature="ProductionServer">
						<span class="generic_error_developers"><fmt:message key="GENERICERR_DEVELOPER" /></span>
					
						<span><fmt:message key="GENERICERR_HTML" /></span>
								
						<!--
						//********************************************************************
						//*-------------------------------------------------------------------
						
						<fmt:message key="GENERICERR_TEXT1" />
						<fmt:message key="GENERICERR_TEXT2" />
						<fmt:message key="GENERICERR_TYPE" />	<c:out value="${errorBean.exceptionType}" />
						<fmt:message key="GENERICERR_KEY" /> <c:out value="${errorBean.messageKey}"  />
						<fmt:message key="GENERICERR_MESSAGE" /> <c:out value="${errorBean.message}"  />
						<fmt:message key="GENERICERR_SYSMESSAGE" /> <c:out value="${errorBean.systemMessage}"  />
						<fmt:message key="GENERICERR_CMD" /> <c:out value="${errorBean.originatingCommand}"  />
						<fmt:message key="GENERICERR_CORR_ACTION" /> <c:out value="${errorBean.correctiveActionMessage}"  />
						
						<c:if test="${!empty errorBean.exceptionData}">
							<fmt:message key="GENERICERR_EXCEPTIONDATA" />
						</c:if>
						<c:forEach var="entry" items="${errorBean.exceptionData}">
							<fmt:message key="GENERICERR_NAME" /><c:out value="${entry.key}" />
							<fmt:message key="GENERICERR_VALUE" /><c:out value="${entry.value}" />
						</c:forEach>
						
						//*-------------------------------------------------------------------
						//********************************************************************
						-->
					</flow:ifDisabled>			
					</div>
				</div>
							
				<div id="WC_GenericError_8" class="footer">
					<div id="WC_GenericError_9" class="left_corner"></div>
					<div id="WC_GenericError_10" class="left"></div>
					<div id="WC_GenericError_11" class="right_corner"></div>
				</div>
			</div>
		</div>
		<!-- Content End -->
	</div>
	<!-- Main Content End -->
	
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
<%
	boolean useHostedLib = BIConfigRegistry.getInstance().useHostedLibraries(storeId);
%>
<c:set var="useHostedLib" value="<%=useHostedLib%>" /> 
<flow:ifEnabled feature="Analytics">
	<c:choose>
		<c:when test="${useHostedLib == true}">
			<cm:pageview category="ERROR" />
		</c:when>
		<c:otherwise>
			<cm:error />
		</c:otherwise>
	</c:choose>
</flow:ifEnabled>

</body>
</html>
