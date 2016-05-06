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

<%-- BEGIN ProductDescription.jsp --%>

<%@ include file= "../../Common/JSTLEnvironmentSetup.jspf" %>

<%@ include file="ext/ProductDescription_Data.jspf" %>
<c:if test = "${param.custom_data ne 'true'}">
	<%@ include file="ProductDescription_Data.jspf" %>
</c:if>

<%@ include file="ext/ProductDescription_UI.jspf" %>
<c:if test = "${param.custom_view ne 'true'}">
	<c:choose>
		<c:when test = "${(type eq 'bundle') or (type eq 'package')}">
			<%@ include file="BundleDescription_UI.jspf" %>
		</c:when>
		<c:when test = "${type eq 'dynamickit'}">
			<%@ include file="DynamicKitDescription_UI.jspf" %>
		</c:when>
		<c:otherwise>
			<%@ include file="ProductDescription_UI.jspf" %>
		</c:otherwise>
	</c:choose>
</c:if>
<%-- END ProductDescription.jsp --%>

