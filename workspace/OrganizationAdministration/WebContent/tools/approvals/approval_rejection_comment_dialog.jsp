<!-- ========================================================================
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2001, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
 ===========================================================================-->

<%@page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.datatype.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.ibm.commerce.command.*"%>
<%@ page import="com.ibm.commerce.*" %>
<%@ page import="com.ibm.commerce.exception.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.approval.util.*" %>

<%@include file="../common/common.jsp" %>

<%
try
{
%>

<HTML>
<HEAD>
<%= fHeader%>

<%        
    Locale locale = null;
    String lang = null;
                         
    CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext"); 
         
    if( aCommandContext!= null )
    {
      locale = aCommandContext.getLocale();
      lang = aCommandContext.getLanguageId().toString();
    }

    String aprv_act = (String) request.getParameter("aprv_act");
    String aprv_ids = (String) request.getParameter("aprv_ids");
    String ActionXMLFile = (String) request.getParameter("ActionXMLFile");    
    String cmd = (String) request.getParameter("cmd");
    String returnLevel = (String) request.getParameter("returnLevel");

    int theFlag = 0;
    try
    {
      theFlag = Integer.parseInt(aprv_act);
    }
    catch(Exception ex) { }

    String theTitle = null;
    String theRemarks = null;

    // Set the title and remarks based on what type of action the user has selected
    if(theFlag > 0 && theFlag < ApprovalConstants.EC_COMMENTS_TITLE.length)
    {
       theTitle = ApprovalConstants.EC_COMMENTS_TITLE[theFlag];
    }
    else
    {
       theTitle = ApprovalConstants.EC_COMMENTS_TITLE[0];
    }
    if(theFlag > 0 && theFlag < ApprovalConstants.EC_COMMENTS_REMARKS.length)
    {
       theRemarks = ApprovalConstants.EC_COMMENTS_REMARKS[theFlag];
    }
    else
    {
       theRemarks = ApprovalConstants.EC_COMMENTS_REMARKS[0];
    }
    
               
   // obtain the resource bundle for display
   Hashtable approvalNLS = (Hashtable)ResourceDirectory.lookup("approvals.approvalsNLS", locale);      
%>

<link rel=stylesheet href="<%= UIUtil.getCSSFile(locale) %>" type="text/css">
<TITLE><%= UIUtil.toHTML((String)approvalNLS.get(theTitle)) %></TITLE>
<SCRIPT Language="JavaScript">

function initializeState()
{
  parent.setContentFrameLoaded(true);
}

function savePanelData()
{

}


function validatePanelData()
{
 return true;
}

function getReturnLevel()
{
  return <%= returnLevel %>
}

// Limit the size of the input from the textarea so it will not exceed the database fieldsize
function limitTextArea() {
      var oneByteMax = 0x007F;
      var twoByteMax = 0x07FF;
      var str = document.commentsForm.comments.value;
      var byteSize = 0;
      

      for (i = 0; i < str.length; i++) {
        byteSize++;
        chr = str.charCodeAt(i);
        if (chr > oneByteMax) byteSize = byteSize + 1;
        if (chr > twoByteMax) byteSize = byteSize + 1;
        if(byteSize > 254)
        {
          //  field is too long... chop it down
          parent.alertDialog('<%= UIUtil.toJavaScript((String)approvalNLS.get("commentsError")) %>');
          document.commentsForm.comments.value = document.commentsForm.comments.value.substring(0, i - 1);
          break;
        }
      }
}

</SCRIPT>

</HEAD>
<BODY ONLOAD="initializeState();" class="content">
<H1><%= UIUtil.toHTML((String)approvalNLS.get(theTitle)) %></H1>
<P><%= UIUtil.toHTML((String)approvalNLS.get(theRemarks)) %>
<P>
<FORM Name="commentsForm" ACTION="HandleApprovals" METHOD="POST">   
<TABLE>
    <TR><TD ALIGN="LEFT"><LABEL for="comments1"><%= UIUtil.toHTML((String)approvalNLS.get("commentsLabel")) %></LABEL></TR>
    <TR><TD><TEXTAREA NAME="comments" COLS="80" ROWS="3" onKeyUp="limitTextArea()" onKeyDown="limitTextArea()" id="comments1"></TEXTAREA></TD></TR>
</TABLE>
    <INPUT TYPE="HIDDEN" NAME="aprv_act" VALUE="<%= aprv_act %>">
    <INPUT TYPE="HIDDEN" NAME="aprv_ids" VALUE="<%= aprv_ids %>">
    <INPUT TYPE="HIDDEN" NAME="viewtask" VALUE="NewDynamicListView">
    <INPUT TYPE="HIDDEN" NAME="ActionXMLFile" VALUE="<%= ActionXMLFile %>">
    <INPUT TYPE="HIDDEN" NAME="cmd" VALUE="<%= cmd %>">
</FORM>
<SCRIPT LANGUAGE="JavaScript">
<!--
document.commentsForm.comments.focus();
// -->
</SCRIPT>
</BODY>
</HTML>

<%
}
catch(Exception e)
{
   ExceptionHandler.displayJspException(request, response, e);
}
%>

