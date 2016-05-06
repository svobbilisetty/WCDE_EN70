<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2012 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!-- BEGIN LeftNavigation.jsp -->

<%@ include file= "../../Common/JSTLEnvironmentSetup.jspf" %>

<%@ include file="ext/LeftNavigation_Data.jspf" %>
<c:if test = "${param.custom_data ne 'true'}">
	<c:choose>
		<%-- 
			If it is a top category page ( top or secondary or any leaf category ) get data using CategoryNavigationSetup.jspf.. 
			Else get data using SearchSetup.jspf 
			CategoryNavigationSetup.jspf is just a subset of SearchSetup.jspf code...
			CategoryNavigationSetup.jspf and SearchSetup.jspf acts as singleton instances.. So these files will be included only once for any given request...
		--%>
		<c:when test="${param.categoryBasedNavigation  == 'true'}">
			<%@ include file="../../Common/CategoryNavigationSetup.jspf" %>
		</c:when>
		<c:when test = "${param.searchBasedNavigation == 'true'}">
			<%@ include file="../../Common/SearchSetup.jspf" %>
		</c:when>
	</c:choose>
	<%@ include file="LeftNavigation_Data.jspf" %>
</c:if>

<%@ include file="ext/LeftNavigation_UI.jspf" %>
<c:if test = "${param.custom_view ne 'true'}">
	<%@ include file="LeftNavigation_UI.jspf" %>
</c:if>

<jsp:useBean id="cacheTimeStamp" class="java.util.Date" scope="request"/>

<!-- END LeftNavigation.jsp -->