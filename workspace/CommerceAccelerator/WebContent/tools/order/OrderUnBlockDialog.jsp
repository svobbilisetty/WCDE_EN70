<%--
//********************************************************************
//*-BR 20011005-1600 updated
//*------------------------------------------------------------------
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
//*
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<%@ page language="java"%>
<%@ page import="java.util.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.ordermanagement.beans.*" %>
<%@include file="../common/common.jsp" %>

<!-- Get the resource bundle with all the NLS strings -->
<%
  CommandContext cmdContextLocale = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
  Locale jLocale = cmdContextLocale.getLocale();
  Hashtable orderLabels = (Hashtable) ResourceDirectory.lookup("order.orderLabels", jLocale);
  
  String  orderId = request.getParameter("orderId");
  String  orderBlockId = request.getParameter("orderBlockId");
  
  OrderBlockDataBean orderBlockDB = new OrderBlockDataBean();
  orderBlockDB.setOrderBlockId(orderBlockId);
  com.ibm.commerce.beans.DataBeanManager.activate(orderBlockDB, request);
  String resolved = orderBlockDB.getResolved().toString();
  String blockCodeId = orderBlockDB.getBlkRsnCodeId().toString();
  String description = orderBlockDB.getBlockReasonCodeDB().getDescription();
%>


<html>
<head>
<script src="/wcs/javascript/tools/common/Util.js"></script>

<link rel="stylesheet" href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css"/>
<script language="JavaScript">
<!-- <![CDATA[
  var orderId=<%=orderId%>;
  
  function onLoad(){
    parent.setContentFrameLoaded(true);
  }
  
  function unBlock(){
    var comments = document.orderBlock.commentsField.value;
    var urlParams = new Object();
    var url = "/webapp/wcs/tools/servlet/BlockNotify";
    urlParams.notifyBlock = 'false';
    urlParams.orderId = orderId;
    urlParams.reasonCodeId = <%=blockCodeId%>;
    urlParams.blockOrUnblockComments = comments;
    urlParams.URL = '/webapp/wcs/tools/servlet/OrderBlockRedirect';
    top.setContent('',url,false,urlParams);
  }
              
// -->
//[[>-->
</script>
</head>

<body class=content onload="onLoad();">

<h1><%= UIUtil.toHTML((String)orderLabels.get("unBlockOrderTitle")) %> </h1>

<table>
		<tr>
			<td align="left"><%= UIUtil.toHTML((String)orderLabels.get("orderBlockOrderNumber")) %><%= UIUtil.toHTML((String)orderLabels.get("orderSummaryDetLabelTextSeparator")) %>
			<i><%= UIUtil.toHTML(orderId) %></i></td>
		</tr>
		<tr>
			<td align="left"><%= UIUtil.toHTML((String)orderLabels.get("orderBlcokDescription")) %><%= UIUtil.toHTML((String)orderLabels.get("orderSummaryDetLabelTextSeparator")) %>
			<i><%= UIUtil.toHTML(blockCodeId) %>  <%= UIUtil.toHTML(description) %></i></td>
		</tr>
</table>

<form name="orderComments" id="orderBlock">
  <label for="commentsField"><%= orderLabels.get("orderBlockComments") %></label><br /><br />
  <textarea name="commentsField" rows="7" cols="60" id="commentsField"><%=orderBlockDB.getBlkComment()%></textarea>
</form>
</body>
</html>

