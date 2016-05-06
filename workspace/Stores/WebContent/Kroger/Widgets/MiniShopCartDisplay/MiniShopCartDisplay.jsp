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

<%-- BIGIN MiniShopCartDisplay.jsp --%>

<%@ include file= "../../Common/EnvironmentSetup.jspf" %>


<%@ include file="ext/MiniShopCartDisplay_Data.jspf" %>
<c:if test = "${param.custom_data ne 'true'}">
	<%@ include file="MiniShopCartDisplay_Data.jspf" %>
</c:if>

<%@ include file="ext/MiniShopCartDisplay_UI.jspf" %>
<c:if test = "${param.custom_view ne 'true'}">
	<c:choose>
		<c:when test = "${param.page_view eq 'dropdown'}">
			<%@ include file="MiniShopCartContents_UI.jspf" %>
		</c:when>
		<c:otherwise>
			<%@ include file="MiniShopCartDisplay_UI.jspf" %>
		</c:otherwise>
	</c:choose>
</c:if>

<%-- END MiniShopCartDisplay.jsp --%>

<jsp:useBean id="MiniShopCart_TimeStamp" class="java.util.Date" scope="request"/>