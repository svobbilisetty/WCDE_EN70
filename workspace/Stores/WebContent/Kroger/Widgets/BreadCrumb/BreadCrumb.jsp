<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2011, 2012 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!-- BEGIN BreadCrumb.jsp -->

<%@ include file= "../../Common/EnvironmentSetup.jspf" %>

<c:if test="${!empty param.parent_category_rn}">
	<c:set var="parent_category_rn" value="${param.parent_category_rn}"/>
</c:if>
<c:if test="${!empty WCParam.parent_category_rn}">
	<c:set var="parent_category_rn" value="${WCParam.parent_category_rn}"/>
</c:if>	
<c:if test="${!empty param.productId}">
	<c:set var="productId" value="${param.productId}"/>
</c:if>
<c:if test="${!empty WCParam.productId}">
	<c:set var="productId" value="${WCParam.productId}"/>
</c:if>
<c:if test="${!empty param.categoryId}">
	<c:set var="categoryId" value="${param.categoryId}"/>
</c:if>
<c:if test="${!empty WCParam.categoryId}">
	<c:set var="categoryId" value="${WCParam.categoryId}"/>
</c:if>
<c:if test="${!empty param.pageName}">
	<c:set var="pageName" value="${param.pageName}"/>
</c:if>
<c:if test="${!empty WCParam.pageName}">
	<c:set var="pageName" value="${WCParam.pageName}"/>
</c:if>

<c:choose>
	<c:when test="${pageName eq 'AdvancedSearchPage' || pageName eq 'StaticSearchPage' || (!empty productId && (empty parent_category_rn && empty categoryId))}">
		<%out.flush();%>
			<c:import url = "${env_jspStoreDir}Widgets/BreadCrumb/BreadCrumbGeneric.jsp" />
		<%out.flush();%>					
	</c:when>
	<c:otherwise>
		<%out.flush();%>
			<c:import url = "${env_jspStoreDir}Widgets/BreadCrumb/BreadCrumbHierarchy.jsp" />
		<%out.flush();%>					
	</c:otherwise>
</c:choose>

<jsp:useBean id="BreadCrumb_TimeStamp" class="java.util.Date" scope="request"/>

<!-- END BreadCrumb.jsp -->

