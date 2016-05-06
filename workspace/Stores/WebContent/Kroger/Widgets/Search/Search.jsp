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

<!-- BEGIN Search.jsp -->

<%@ include file= "../../Common/JSTLEnvironmentSetup.jspf" %>

<flow:ifEnabled feature="search">


	<%@ include file="ext/Search_Data.jspf" %>
	<c:if test = "${param.custom_data ne 'true'}">
		<%@ include file="Search_Data.jspf" %>
		<!-- Begin Search Widget -->
		<script type="text/javascript">
				dojo.addOnLoad(function(){
					SearchJS.init();
					SearchJS.setCachedSuggestionsURL('<c:out value='${CachedSuggestionsURL}'/>');
					SearchJS.setAutoSuggestURL('<c:out value='${SearchAutoSuggestServletURL}'/>');
				});

				// The primary Array to hold all static search suggestions
				var staticContent = new Array();

				// The titles of each search grouping
				var staticContentHeaders = new Array();
		</script>	
	</c:if>

	<%@ include file="ext/Search_UI.jspf" %>
	<c:if test = "${param.custom_view ne 'true'}">
		<%@ include file="Search_UI.jspf" %>
	</c:if>

	<jsp:useBean id="Search_TimeStamp" class="java.util.Date" scope="request"/>

	<!-- End Search Widget -->

</flow:ifEnabled>

<!-- END Search.jsp -->