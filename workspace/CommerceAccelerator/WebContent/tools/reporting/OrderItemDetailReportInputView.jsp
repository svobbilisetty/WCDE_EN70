<%
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* 5697-D24
//*
//* (c) Copyright IBM Corp. 2000, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
 %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%@page import="java.util.*" %>
<%@page import="com.ibm.commerce.tools.util.*" %>
<%@page import="com.ibm.commerce.tools.xml.*" %>

<%@include file="common.jsp" %>
<%@include file="ReportFrameworkHelper.jsp" %>
<%String Orders_id = request.getParameter("Orders_id");%>

<HTML>
<HEAD>
   <%=fHeader%>

   <TITLE><%=reportsRB.get("OrderItemDetailReportInputViewTitle")%></TITLE>
   <SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
   <SCRIPT SRC="/wcs/javascript/tools/common/SwapList.js"></SCRIPT>
   <SCRIPT SRC="/wcs/javascript/tools/reporting/ReportHelpers.js"></SCRIPT>

   <SCRIPT>

      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      // Call the initialize routines for the various elements of the page
      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      function initializeValues() 
      {
         if (parent.setContentFrameLoaded) parent.setContentFrameLoaded(true);
      }


      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      // Call the save routines for the various elements of the page
      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      function savePanelData() 
      {

         ////////////////////////////////////////////////////////////////////////////////////////////////////
         // Specify the report framework particulars
         ////////////////////////////////////////////////////////////////////////////////////////////////////
         setReportFrameworkOutputView("DialogView");
         setReportFrameworkParameter("XMLFile","reporting.OrderItemDetailReportOutputDialog");
         setReportFrameworkReportXML("reporting.OrderItemDetailReport");
         setReportFrameworkReportName("OrderItemDetailReport");

         ////////////////////////////////////////////////////////////////////////////////////////////////////
         // Specify the report specific parameters and save
         ////////////////////////////////////////////////////////////////////////////////////////////////////
         setReportFrameworkParameter("Orders_id",<%= Orders_id %>);
         saveReportFramework();
         top.saveModel(parent.model);
         return true;
      }

      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      // Call the validate routines for the various elements of the page
      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      function validatePanelData()
      {
          return true;
      }

</SCRIPT>
<META name="GENERATOR" content="IBM WebSphere Studio">
</HEAD>

<BODY ONLOAD="initializeValues()" CLASS=content>

   <H1><%=reportsRB.get("OrderItemDetailReportInputViewTitle") %></H1>
   <%=reportsRB.get("OrderItemDetailReportDescription")%>
   <BR>
   <%=reportsRB.get("OrderItemDetailReportInputText")%>


</BODY>
</HTML>
</SCRIPT>
<META name="GENERATOR" content="IBM WebSphere Studio">
