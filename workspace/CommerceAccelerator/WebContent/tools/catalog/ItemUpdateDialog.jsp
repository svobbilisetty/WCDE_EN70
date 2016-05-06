<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2002, 2009 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%@ page import="java.util.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>

<%@include file="../common/common.jsp" %>

<%
	CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Hashtable rbProduct = (Hashtable) ResourceDirectory.lookup("catalog.ProductNLS", cmdContext.getLocale());
	JSPHelper helper= new JSPHelper(request);
	String catentryId = request.getParameter("catentryId");
	String readonlyAccess = request.getParameter("readonlyAccess");

	// to do, need to change to get value from access control helper after access control is done
	boolean attachmentAccessGained = true;
%>

<SCRIPT>

	var detailPageLoadedTF = false;
	var storeDirectory = "<%= cmdContext.getStore().getDirectory() %>";
	var readonlyAccess = <%=readonlyAccess%>;
	var attachmentAccessGained = <%=attachmentAccessGained%>;

	function isInsideWizard()
	{
		return true;
	}

	function detailPageLoaded()
	{
		detailPageLoadedTF = true;
	}

	function getDetailPageLoaded()
	{
		return detailPageLoadedTF;
	}

	function getHelp()
	{
		return "MC.catalogTool.ItemUpdateDialog.Help";
	}
	
	function visibleList(s)
	{
		if(s=='hidden')
		{
			titleFrame.oPopup.hide();
			contentFrame.oPopup.hide();
		}
	}

	var catentryId  = top.get("SKUUpdateDetailCatentryId", null);
	top.put("SKUUpdateDetailCatentryId" , null);
		
	function onLoad()
	{
		
		top.showProgressIndicator(true);
		var urlPara = new Object();
		urlPara.parentCatentryId="<%=catentryId%>";
		urlPara.menuXML="catalog.CatalogMenuItem";
<%
		Enumeration e = request.getParameterNames();
		String strName = new String();
		while (e.hasMoreElements())
		{
			strName = (String) e.nextElement();
			if (strName == null || strName.trim().equals("")) { continue; }
%>
			urlPara.<%=strName%>="<%=UIUtil.toJavaScript(helper.getParameter(strName))%>";
<%
		}
%>
		urlPara.catentryId= "" + catentryId;
		urlPara.pageSize = "<%=helper.getParameter("displayNum")%>";
		urlPara.displayNum = "9999";
		top.mccmain.submitForm("/webapp/wcs/tools/servlet/ItemUpdateDetail", urlPara, "contentFrame");
	}	

</SCRIPT>

<HTML>
	<FRAMESET BORDER=0 FRAMEBORDER=NO ID=frameset1 NAME=frameset1 ROWS="75,*,33" ONLOAD=onLoad()>
		<FRAME NAME=titleFrame   TITLE="<%= UIUtil.toHTML( (String)rbProduct.get("ItemUpdateDialog_FrameTitle_1")) %>" SRC="/webapp/wcs/tools/servlet/ProductUpdateTitle?menuXML=catalog.CatalogMenuItem&pagingSKU=true">
		<FRAME NAME=contentFrame TITLE="<%= UIUtil.toHTML( (String)rbProduct.get("ItemUpdateDialog_FrameTitle_2")) %>" SRC="/wcs/tools/common/blank.html">
		<FRAME NAME=buttonFrame  TITLE="<%= UIUtil.toHTML( (String)rbProduct.get("ItemUpdateDialog_FrameTitle_3")) %>" SRC="/webapp/wcs/tools/servlet/ItemUpdateBottom">
	</FRAMESET>
</HTML>
