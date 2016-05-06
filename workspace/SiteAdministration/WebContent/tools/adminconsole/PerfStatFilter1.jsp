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
                 com.ibm.commerce.tools.util.UIUtil" %>
<%@ include file="../common/common.jsp" %>
<%!
   private String rChecked(int i, int pick) {
      if (i==pick) return " checked";
      else return ""; }
%>
<% String webalias = UIUtil.getWebPrefix(request); %>
<%
   String xmlFileParm = request.getParameter("XMLFile");
   Hashtable xmlfile = (Hashtable)ResourceDirectory.lookup(xmlFileParm);
   Hashtable action = (Hashtable)xmlfile.get("action");
   com.ibm.commerce.command.CommandContext cc = (com.ibm.commerce.command.CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
   Hashtable customNLS = (Hashtable)ResourceDirectory.lookup((String)action.get("resourceBundle"), cc.getLocale());
   String descendChecked="";
   String sf=request.getParameter("sortField");
   if (sf.indexOf("-")==0) {
      descendChecked=" checked";
      sf=sf.substring(1); }
   int pick=Integer.parseInt(sf);
   String ss=request.getParameter("searchString");
   int i, j=ss.indexOf("_");
   String uChecked="", vChecked="", cChecked="";
   i=ss.indexOf("u");  if (i!=-1 && i<j) uChecked="checked";
   i=ss.indexOf("v");  if (i!=-1 && i<j) vChecked="checked";
   i=ss.indexOf("c");  if (i!=-1 && i<j) cChecked="checked";
   ss=ss.substring(j+1);

   i=ss.indexOf("_");
   j=Integer.parseInt(ss.substring(0, i));
   String uVal=ss.substring(i+1, i+1+j);
   ss=ss.substring(i+1+j);

   i=ss.indexOf("_");
   j=Integer.parseInt(ss.substring(0, i));
   String vVal=ss.substring(i+1, i+1+j);
   ss=ss.substring(i+1+j);

   i=ss.indexOf("_");
   j=Integer.parseInt(ss.substring(0, i));
   String cVal=ss.substring(i+1, i+1+j);
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<html>
<head>
<title> </title>
<link rel="stylesheet" href="<%=webalias%>tools/common/centre.css" type="text/css">
<script language="JavaScript">
<!--
function getHelp() {
  return "AC.performance.find.Help"; }

function strReform(str) {
  var result="";
  while (true) {
    var i=str.indexOf(" ");
    if (i==-1) {
      result+=str;
      break; }
    result+=str.substring(0, i);
    str=str.substring(i+1, str.length); }
  return ""+result.length+"_"+result; }
  
function doQuery() {
  var ss="", i;
  if (document.filterForm.URL.checked)  ss+="u";
  if (document.filterForm.VIEW.checked) ss+="v";
  if (document.filterForm.CMD.checked)  ss+="c";
  ss+="_";
  ss+=strReform(document.filterForm.furl.value);
  ss+=strReform(document.filterForm.fview.value);
  ss+=strReform(document.filterForm.fcmd.value);
  parent.buttons.document.hiddenForm.searchString.value=ss;
  for (i=0; i<11; i++)
    if (document.filterForm.sortField[i].checked) break;
  if (document.filterForm.useDescend.checked) i=-i;
  parent.buttons.document.hiddenForm.sortField.value=""+i;
  parent.buttons.document.buttonForm.RefreshButton.click(); }

function doClear() {
  document.filterForm.URL.checked=true;
  document.filterForm.VIEW.checked=true;
  document.filterForm.CMD.checked=true;
  document.filterForm.furl.value="";
  document.filterForm.fview.value="";
  document.filterForm.fcmd.value="";
  document.filterForm.sortField[0].checked=true;
  document.filterForm.useDescend.checked=false; }

function doCancel() {
  document.location.replace(top.getWebappPath() + 'AdminConPerfStatView?XMLFile=<%=xmlFileParm%>'); }
// -->
</script>
</head>
<body>
<br><br><center>
<%= UIUtil.toHTML((String)customNLS.get("perfRemark2a")) %><br>
  <form name="filterForm">
    <table summary="<%=customNLS.get("perfTableSumFilter")%>">
      <tr align="left">
      	<td>
      		<input type="checkbox" id="URL1" name="URL"  <%=uChecked%>>
      		<LABEL for="URL1"><%= UIUtil.toHTML((String)customNLS.get("perfURL")) %></LABEL> 
      	</td>
      	<td>
      		<LABEL for="URL2"><%= UIUtil.toHTML((String)customNLS.get("perfURL")) %></LABEL> 
      		<input type="text" name="furl" id="URL2" value="<%=uVal%>" size="50">
      	</td>
      </tr>
      <tr align="left">
      	<td>
      		<input type="checkbox" id="VIEW1" name="VIEW" <%=vChecked%>>
      		<LABEL for="VIEW1"><%= UIUtil.toHTML((String)customNLS.get("perfVIEW")) %></LABEL>
      	</td>
      	<td>
       		<LABEL for="VIEW2"><%= UIUtil.toHTML((String)customNLS.get("perfVIEW")) %></LABEL>
      		<input type="text" name="fview" id="VIEW2" value="<%=vVal%>" size="50">
      	</td>
      </tr>
      <tr align="left">
      	<td>
      		<input type="checkbox" id="CMD1" name="CMD"  <%=cChecked%>>
      		<LABEL for="CMD1"><%= UIUtil.toHTML((String)customNLS.get("perfCMD")) %></LABEL> 
      	</td>
      	<td>
       		<LABEL for="CMD2"><%= UIUtil.toHTML((String)customNLS.get("perfCMD")) %></LABEL> 
      		<input type="text" name="fcmd" id="CMD2" value="<%=cVal%>" size="50">
      	</td>
      </tr>
    </table>
    <br>
    <table>
      <tr><td align="left"><%=UIUtil.toHTML((String)customNLS.get("perfSortBy"))%></td></tr>
      <tr align="left">
        <td><input type="radio" id="sortField0" name="sortField"<%=rChecked(0, pick)%>><LABEL for="sortField0"><%=UIUtil.toHTML((String)customNLS.get("perfCounterType"))%></LABEL></td>
        <td><input type="radio" id="sortField1" name="sortField"<%=rChecked(1, pick)%>><LABEL for="sortField1"><%=UIUtil.toHTML((String)customNLS.get("perfColCounterName"))%></LABEL></td>
        <td><input type="radio" id="sortField2" name="sortField"<%=rChecked(2, pick)%>><LABEL for="sortField2"><%=UIUtil.toHTML((String)customNLS.get("perfColStoreId"))%></LABEL></td>
      </tr>
      <tr align="left">
        <td><input type="radio" id="sortField3" name="sortField"<%=rChecked(3, pick)%>><LABEL for="sortField3"><%=UIUtil.toHTML((String)customNLS.get("perfColHitCount"))%></LABEL></td>
        <td><input type="radio" id="sortField4" name="sortField"<%=rChecked(4, pick)%>><LABEL for="sortField4"><%=UIUtil.toHTML((String)customNLS.get("perfColLastResponseTime"))%></LABEL></td>
        <td><input type="radio" id="sortField5" name="sortField"<%=rChecked(5, pick)%>><LABEL for="sortField5"><%=UIUtil.toHTML((String)customNLS.get("perfColLastAccessTime"))%></LABEL></td>
      </tr>
      <tr align="left">
        <td><input type="radio" id="sortField6" name="sortField"<%=rChecked(6, pick)%>><LABEL for="sortField6"><%=UIUtil.toHTML((String)customNLS.get("perfColMeanResponseTime"))%></LABEL></td>
        <td><input type="radio" id="sortField7" name="sortField"<%=rChecked(7, pick)%>><LABEL for="sortField7"><%=UIUtil.toHTML((String)customNLS.get("perfColFatestResponseTime"))%></LABEL></td>
        <td><input type="radio" id="sortField8" name="sortField"<%=rChecked(8, pick)%>><LABEL for="sortField8"><%=UIUtil.toHTML((String)customNLS.get("perfColSlowestResponseTime"))%></LABEL></td>
      </tr>
      <tr align="left">
        <td><input type="radio" id="sortField9" name="sortField"<%=rChecked(9, pick)%>><LABEL for="sortField9"><%=UIUtil.toHTML((String)customNLS.get("perfColTotalResponseTime"))%></LABEL></td>
        <td><input type="radio" id="sortField10" name="sortField"<%=rChecked(10, pick)%>><LABEL for="sortField10"><%=UIUtil.toHTML((String)customNLS.get("perfColStandardDeviation"))%></LABEL></td>
      </tr>
      <tr align="left">
        <td><input type="checkbox" id="useDescend1" name="useDescend"<%=descendChecked%>><LABEL for="useDescend1"><%=UIUtil.toHTML((String)customNLS.get("perfDescend"))%></LABEL></td>
      </tr>
    </table>
    <br>
    <table>
      <tr align="center">
        <td>
          <input type="button" id="dialog" name="btn_OK" value=" <%= UIUtil.toHTML((String)customNLS.get("perfOk")) %> " onClick="doQuery()">
          <input type="button" id="dialog" name="btn_Clear" value="<%= UIUtil.toHTML((String)customNLS.get("perfClear")) %>" onClick="doClear()">
          <input type="button" id="dialog" name="btn_Cancel" value="<%= UIUtil.toHTML((String)customNLS.get("perfCancel")) %>" onClick="doCancel()">
        </td>
      </tr>
    </table>
  </form>
</center>
</body>
</html>
