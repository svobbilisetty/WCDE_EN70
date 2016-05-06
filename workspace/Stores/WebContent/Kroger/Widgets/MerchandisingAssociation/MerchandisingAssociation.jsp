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

<!-- BEGIN MerchandisingAssociation.jsp -->

<%@ include file= "../../Common/JSTLEnvironmentSetup.jspf" %>

<%@ include file="ext/MerchandisingAssociation_Data.jspf" %>
<c:if test = "${param.custom_data ne 'true'}">
	<%@ include file="MerchandisingAssociation_Data.jspf" %>
</c:if>

<%@ include file="ext/MerchandisingAssociation_UI.jspf" %>
<c:if test = "${param.custom_view ne 'true'}">
	<%@ include file="MerchandisingAssociation_UI.jspf" %>
</c:if>

<jsp:useBean id="MerchandisingAssociation_TimeStamp" class="java.util.Date" scope="request"/>

<!-- END MerchandisingAssociation.jsp -->