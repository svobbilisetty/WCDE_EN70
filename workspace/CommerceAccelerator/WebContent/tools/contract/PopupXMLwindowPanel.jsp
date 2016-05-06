<!-- ==========================================================================
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
<%@page language="java"
import="com.ibm.commerce.tools.util.UIUtil"
%>

<%@include file="../common/common.jsp" %>

<html>

<head>
 <%= fHeader %>
 <title>Contract XML Definition</title>

 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js">
</script>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/DateUtil.js">
</script>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/FieldEntryUtil.js">
</script>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/ConvertToXML.js">
</script>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Vector.js">
</script>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/contract/Contract.js">
</script>

 <script LANGUAGE="JavaScript">
    function dumpXML() {
        var xmlObject = opener.top.popupXMLobject;
        var xmlObjectRoot = opener.top.popupXMLobjectRootNode;
        
        var xml = convert2XML(xmlObject, xmlObjectRoot, "B2BTrading.dtd");        
        var noDtdXml = xml.replace(/[ ]*SYSTEM[ ]*"B2BTrading.dtd"[ ]*/, "");
        document.xmlwindowform.xmlstring.value = noDtdXml;        
        //alert('submitting form with xml='+noDtdXml);
        
        document.xmlwindowform.submit()       
    }
 
</script>
</head>

<body class="content" onLoad="dumpXML()">
   <form name="xmlwindowform" action="/webapp/wcs/tools/servlet/DisplayXMLwindowView" method="post" id="xmlwindowform">
       <input type="hidden" name="xmlstring" id="PopupXMLwindowPanel_FormInput_xmlstring_In_xmlwindowform_1">
   </form>
</body>

</html>
