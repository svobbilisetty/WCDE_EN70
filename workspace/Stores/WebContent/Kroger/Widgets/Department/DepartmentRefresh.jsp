<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2011 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@ include file= "../../Common/EnvironmentSetup.jspf" %>

<script type="text/javascript">
	dojo.addOnLoad(function() {
		if(document.getElementById("widget_departments")){
			document.getElementById("widget_departments").style.display = "block";
		}
		DepartmentJS.init();
		wc.render.getRefreshControllerById("<c:out value='DepartmentDropdownController'/>").url = getAbsoluteURL()+"DepartmentDropdownView?storeId=<c:out value='${storeId}'/>&catalogId=<c:out value='${catalogId}'/>&langId=<c:out value='${langId}'/>&isFirstRefresh=true";
	});

	dojo.addOnUnload(function() {
		if(document.getElementById("drop_down")){
			document.getElementById("drop_down").style.display = "none";
		}
	});
</script>

<fmt:message key="DEPARTMENT_MENU_ACCE" var="departmentMenu"/>
<div id="widget_departments" tabindex="0" title="<c:out value='${departmentMenu}'/>" style="display:none;">
		<div class="left_border"></div>
		<div class="content">
			<span class="label"><fmt:message key="DEPARTMENTS" /></span>
			<div class="arrow"></div>
		</div>
		<div class="right_border"></div>
		<div class="clear_float"></div>
		
		<%-- Top Category Menu--%>
		<div class="drop_down" id="drop_down" dojoType="wc.widget.RefreshArea" widgetId="drop_down" controllerId="DepartmentDropdownController">
			<% out.flush(); %>
				<c:import url = "${env_jspStoreDir}Widgets/Department/Department.jsp" />
			<% out.flush(); %>
		</div>
</div>


