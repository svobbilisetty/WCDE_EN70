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

<!-- BEGIN Department.jsp -->

<%@ include file= "../../Common/EnvironmentSetup.jspf" %>

<c:if test = "${param.isFirstRefresh eq 'true' && !empty param.catalogId}">
	<%@ include file="ext/Department_Data.jspf" %>
	<c:if test = "${param.custom_data ne 'true'}">
		<%@ include file="Department_Data.jspf" %>
	</c:if>


	<%@ include file="ext/Department_UI.jspf" %>
	<c:if test = "${param.custom_view ne 'true'}">
		<%@ include file="Department_UI.jspf" %>
	</c:if>	
</c:if>
<!-- END Department.jsp -->
