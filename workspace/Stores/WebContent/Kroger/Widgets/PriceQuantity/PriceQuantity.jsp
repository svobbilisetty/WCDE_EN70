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

<%--
***** 
This object snippet displays the price range against quantity for a catalog entry.
*****
--%>

<!-- BEGIN PriceQuantity.jsp -->

<%@ include file= "../../Common/JSTLEnvironmentSetup.jspf" %>

<%@ include file="ext/PriceQuantity_Data.jspf" %>
<c:if test = "${param.custom_data ne 'true'}">
	<%@ include file="PriceQuantity_Data.jspf" %>
</c:if>

<%@ include file="ext/PriceQuantity_UI.jspf" %>
<c:if test = "${param.custom_view ne 'true'}">
	<%@ include file="PriceQuantity_UI.jspf" %>
</c:if>

<!-- END PriceQuantity.jsp -->
