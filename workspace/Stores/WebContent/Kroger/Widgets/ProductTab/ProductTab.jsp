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

<!-- BEGIN ProductTab.jsp -->

<%@ include file= "../../Common/JSTLEnvironmentSetup.jspf" %>

<%@ include file="ext/ProductTab_Data.jspf" %>
<c:if test = "${param.custom_data ne 'true'}">
	<%@ include file="ProductTab_Data.jspf" %>
</c:if>

<%@ include file="ext/ProductTab_UI.jspf" %>
<c:if test = "${param.custom_view ne 'true'}">
	<%@ include file="ProductTab_UI.jspf" %>
</c:if>

<jsp:useBean id="ProductTab_TimeStamp" class="java.util.Date" scope="request"/>

<!-- END ProductTab.jsp -->