<%--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
--%>
<%@ page language="java"
         import="com.ibm.commerce.tools.util.ResourceDirectory,
                 com.ibm.commerce.tools.util.UIUtil,
                 com.ibm.commerce.tools.util.Util" %>
<%@ include file="../common/common.jsp" %>
<% String webalias = UIUtil.getWebPrefix(request); %>
<%!
   private String jsFunctions(Vector menus) throws com.ibm.commerce.exception.ECSystemException {
     String jsFilter, jsReset, jsRefresh, jsUpdate, jsDone, result="";
     jsFilter="  document.hiddenForm.submit()";
     jsReset="  document.resetForm.cmd.value=\"reset\";\n";
     jsReset+="  document.resetForm.submit()";
     jsRefresh ="  document.hiddenForm2.runQuery.value=document.hiddenForm.sortField.value+\"_\"+document.hiddenForm.searchString.value+document.hiddenForm.XMLFile.value;\n";
     jsRefresh+="  document.hiddenForm2.submit()";
     jsUpdate="  document.resetForm.cmd.value=\"update\";\n";
     jsUpdate+="  document.resetForm.submit()";
     jsDone="  parent.location.replace(\"AdminConHome\")";
     for (Enumeration e=menus.elements(); e.hasMoreElements();) {
       Hashtable menu = (Hashtable)e.nextElement();
       String itemName = menu.get("name").toString().trim();
       if (itemName.equals("space")) continue;
       String itemAction="";
       if (menu.get("action")==null) {
         if (itemName.equals("Filter")) itemAction=jsFilter; else
         if (itemName.equals("Reset")) itemAction=jsReset; else
         if (itemName.equals("Refresh")) itemAction=jsRefresh; else
         if (itemName.equals("Update")) itemAction=jsUpdate; else
         if (itemName.equals("Done")) itemAction=jsDone; else
         continue; }
       else itemAction=menu.get("action").toString().trim();
       itemAction=UIUtil.replaceURLVariables(itemAction);
       result+="\nfunction "+itemName+"Action() {\n"+itemAction+"; }\n"; }
     return result; }

   private String createButton(String button, boolean isIE, Hashtable customNLS, Locale locale) {
      String buttonName = UIUtil.toHTML((String)customNLS.get("perfBtn"+button));
      if (buttonName == null) buttonName = "null";
      String result="type='BUTTON' value='"+buttonName+"' name='"+button+"Button' id='content' style='width:125px' onClick='javascript:"+button+"Action();'>";
      if (isIE) result="<button "+result+" <font size=" + (Util.isDoubleByteLocale(locale)? "2" : "1") + ">" + buttonName+"</font></button>";
      else result="<input "+result;
      return result; }
%>
<%
   boolean isIE = Util.isIE(request);
   String xmlFileParm = request.getParameter("XMLFile");
   Hashtable xmlfile = (Hashtable)ResourceDirectory.lookup(xmlFileParm);
   Hashtable action = (Hashtable)xmlfile.get("action");
   com.ibm.commerce.command.CommandContext cc = (com.ibm.commerce.command.CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
   Hashtable customNLS = (Hashtable)ResourceDirectory.lookup((String)action.get("resourceBundle"), cc.getLocale());
   Vector menus = (Vector)Util.convertToVector(action.get("menu"));

   Locale locale = cc.getLocale();

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<html>
<head>
<title> </title>
<link rel="stylesheet" href="<%=webalias%>tools/common/centre.css" type="text/css">
<script language="JavaScript">
<!-- hide script from old browsers
<%= jsFunctions(menus) %>
// -->
</script>
</head>
<body>
  <form name="hiddenForm" target="basefrm" action="AdminConPerfStatView3">
    <input type="hidden" name="XMLFile" value="<%=xmlFileParm%>">
    <input type="hidden" name="sortField" value="0">
    <input type="hidden" name="searchString" value="uvc_0_0_0_">
  </form>
  <form name="hiddenForm2" target="basefrm" action="PerfMonitor">
    <input type="hidden" name="cmd" value="search">
    <input type="hidden" name="runQuery">
  </form>
  <form name="resetForm" target="basefrm" action="PerfMonitor">
    <input type="hidden" name="cmd">
    <input type="hidden" name="URL" value="AdminConPerfStatView?XMLFile=<%=xmlFileParm%>">
  </form>
  <form name="buttonForm">
    <table border="0" cellpadding="0" cellspacing="0" summary="<%=UIUtil.toHTML((String)customNLS.get("perfTableSumBtn"))%>">
<%
   for (Enumeration e=menus.elements(); e.hasMoreElements();) {
      Hashtable menu = (Hashtable)e.nextElement();
      if (menu.get("name").equals("space")) {
%>
      <tr><td>&nbsp;</td></tr>
<% continue; } %>
      <tr>
	<td>
          <table cellpadding="0" cellspacing="0" border="0">
            <tr>
              <td>&nbsp;</td>
	      <td bgcolor="#1B436F"> <%= createButton((String)(menu.get("name")), isIE, customNLS, locale) %> </td>
	      <td height="100%"> <img src="<%=webalias%>images/tools/list/but_curve2.gif" alt="" width="9" height="100%"> </td>
	    </tr>
	    <tr><td></td></tr>
	    <tr><td></td></tr>
          </table>
        </td>
      </tr>
<% } %>
    </table>
  </form>
</body>
</html>
