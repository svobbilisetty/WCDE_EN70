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

<!-- BEGIN InventoryStatus.jsp -->

<%@ include file= "../../Common/EnvironmentSetup.jspf" %>

<flow:ifEnabled feature="InventoryAvailability">

	<%@ include file="ext/InventoryStatus_Data.jspf" %>
	<c:if test = "${param.custom_data ne 'true'}">
		<%@ include file="InventoryStatus_Data.jspf" %>
	</c:if>

	<%@ include file="ext/InventoryStatus_UI.jspf" %>
	<c:if test = "${param.custom_view ne 'true'}">
		<%@ include file="InventoryStatus_UI.jspf" %>
	</c:if>

</flow:ifEnabled>
<jsp:useBean id="InventoryStatus_TimeStamp" class="java.util.Date" scope="request"/>

<!-- END InventoryStatus.jsp -->