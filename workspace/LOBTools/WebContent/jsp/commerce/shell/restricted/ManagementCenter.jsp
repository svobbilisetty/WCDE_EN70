
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2012 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<% 
	request.setAttribute(
			com.ibm.commerce.foundation.internal.client.lobtools.servlet.TrimWhitespacePrintWriterImpl.TRIM_WHITESPACE
			, Boolean.FALSE);
%>

<fmt:setLocale value="${pageContext.request.locale}" />
<fmt:setBundle basename="com.ibm.commerce.foundation.client.lobtools.properties.ShellLOB" var="resources" />

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="${pageContext.request.locale.language}" lang="${pageContext.request.locale.language}">

<head>
<title><fmt:message key="applicationTitle" bundle="${resources}" /></title>
<style type="text/css">
html { background-image: url('${pageContext.request.contextPath}/images/shell/background_tile.png'); background-repeat: repeat; }
body { margin: 0 0 0 0; background-image: url('${pageContext.request.contextPath}/images/shell/no_tab_background.png'); background-repeat: x-repeat; }
td.textTitle { font-family: Arial; font-size: 16pt; font-weight: bold; word-wrap: break-word; color: #3050a6; }
td.textMessage { font-family: Arial; font-size: 11pt; word-wrap: break-word; color: #000000; }
</style>
<script type="text/javascript" src="${pageContext.request.contextPath}/javascript/shell/ManagementCenter.js"></script>
<script type="text/javascript">
<!-- hide script from old browsers
var isIE = (navigator.appVersion.indexOf("MSIE") != -1) ? true : false;
var requiredIEVersion = 7.0;
var requiredFFVersion = 3;
var requiredFlashVersion = 10;

function checkBrowser () {
	var isBrowserSupported = false;
	if (navigator.appName == "Microsoft Internet Explorer") {
		if (navigator.appVersion.indexOf("MSIE") != -1) {
			var temp = navigator.appVersion.split("MSIE");
			var ieVersion = parseFloat(temp[1]);
			if (ieVersion >= requiredIEVersion) {
				isBrowserSupported = true;
			}
		}
	}
	else if (navigator.appName == "Netscape") {
		if (navigator.userAgent.indexOf("Firefox") != -1) {
			var versionIndexStart = navigator.userAgent.indexOf("Firefox") + 8;
			var versionIndexEnd = navigator.userAgent.indexOf(".",versionIndexStart);
			var ffVersion = navigator.userAgent.substring(versionIndexStart, versionIndexEnd);
			if (parseInt(ffVersion) >= requiredFFVersion) {
				isBrowserSupported = true;
			}
		}
	}
	return isBrowserSupported;
}

function checkFlashVersion () {
	var flashVersion = -1;
	if (navigator.plugins != null && navigator.plugins.length > 0) {
		if (navigator.plugins["Shockwave Flash"] || navigator.plugins["Shockwave Flash 2.0"]) {
			var tempVersion = navigator.plugins["Shockwave Flash 2.0"] ? " 2.0" : "";
			var flashDesc = navigator.plugins["Shockwave Flash" + tempVersion].description;
			var descArray = flashDesc.split(" ");
			var versionArray = descArray[2].split(".");
			flashVersion = versionArray[0];
		}
	}
	else if (isIE) {
		var tempVersion;
		var activeXObj;
		var exception;
		try {
			// version will be set for 7.X or greater players
			activeXObj = new ActiveXObject("ShockwaveFlash.ShockwaveFlash.7");
			tempVersion = activeXObj.GetVariable("$version");
		}
		catch (e) {
		}
		if (!tempVersion) {
			try {
				// version will be set for 6.X players only
				activeXObj = new ActiveXObject("ShockwaveFlash.ShockwaveFlash.6");
				tempVersion = "WIN 6,0,21,0";
				activeXObj.AllowScriptAccess = "always";
				tempVersion = activeXObj.GetVariable("$version");
			}
			catch (e) {
			}
		}
		if (!tempVersion) {
			try {
				// version will be set for 4.X or 5.X player
				activeXObj = new ActiveXObject("ShockwaveFlash.ShockwaveFlash.3");
				tempVersion = activeXObj.GetVariable("$version");
			}
			catch (e) {
			}
		}
		if (!tempVersion) {
			try {
				// version will be set for 3.X player
				activeXObj = new ActiveXObject("ShockwaveFlash.ShockwaveFlash.3");
				tempVersion = "WIN 3,0,18,0";
			}
			catch (e) {
			}
		}
		if (!tempVersion) {
			try {
				// version will be set for 2.X player
				activeXObj = new ActiveXObject("ShockwaveFlash.ShockwaveFlash");
				tempVersion = "WIN 2,0,0,11";
			}
			catch (e) {
			}
		}
		if (tempVersion) {
			tempVersionArray = tempVersion.split(" ");
			tempVersionString = tempVersionArray[1];
			flashVersion = tempVersionString.split(",")[0];
		}
	}
	if (flashVersion >= requiredFlashVersion) {
		return true;
	}
	else {
		return false;
	}
}

function window_onLoad () {
	if (checkBrowser() && checkFlashVersion()) {
		//
		// set up variables to be used in this function
		//
		var launchURL = "${pageContext.request.contextPath}/cmc/ManagementCenterMain";
		var launchURLParams = "?locale=${pageContext.request.locale}";
		var windowName = "cmcMainWindow_" + removeInvalidChar(window.location.hostname);

		//
		// append parameters to the launch URL
		//
<c:forEach var="aParam" items="${paramValues}">
	<c:forEach var="aValue" items="${aParam.value}">
		launchURLParams += "&${aParam.key}=${aValue}";
	</c:forEach>
</c:forEach>

		//
		// open the main management center page in a separate window
		//
		window.open(launchURL + launchURLParams, windowName, "left=0,top=0,width=1014,height=710,scrollbars=no,toolbar=no,directories=no,status=no,menubar=no,copyhistory=no,resizable=yes").focus();
	}
}
//-->
</script>
</head>

<body onload="window_onLoad()">

<table border="0" cellpadding="0" cellspacing="0">
	<tr><td height="75" /></tr>
	<tr>
		<td width="105" />
		<td width="130" height="130" background="${pageContext.request.contextPath}/images/shell/mc_logo.png" style="background: transparent url('${pageContext.request.contextPath}/images/shell/mc_logo.png') none; background-repeat: no-repeat; filter:progid:DXImageTransform.Microsoft.AlphaImageLoader(enabled=true, src='${pageContext.request.contextPath}/images/shell/mc_logo.png', sizingMethod='image')" />
		<td width="35" />
		<td>
			<div id="mainContent" style="display: none;">
<script type="text/javascript">
if (!checkBrowser()) {
	document.writeln('<div style="display: block;">');
}
else {
	document.writeln('<div style="display: none;">');
}
</script>
			<table border="0" cellpadding="0" cellspacing="0">
				<tr><td class="textTitle"><fmt:message key="errorSupportedBrowserTitle" bundle="${resources}" /></td></tr>
				<tr><td height="10" /></tr>
				<tr><td class="textMessage"><fmt:message key="errorSupportedBrowserMessage" bundle="${resources}" /></td></tr>
			</table>
<script type="text/javascript">
document.writeln('</div>');
</script>

<script type="text/javascript">
if (checkBrowser() && !checkFlashVersion()) {
	document.writeln('<div style="display: block;">');
}
else {
	document.writeln('<div style="display: none;">');
}
</script>
			<table border="0" cellpadding="0" cellspacing="0">
				<tr><td class="textTitle"><fmt:message key="errorFlashVersionTitle" bundle="${resources}" /></td></tr>
				<tr><td height="10" /></tr>
				<tr><td class="textMessage"><fmt:message key="errorFlashVersionMessage" bundle="${resources}" /></td></tr>
			</table>
<script type="text/javascript">
document.writeln('</div>');
</script>

<script type="text/javascript">
if (checkBrowser() && checkFlashVersion()) {
	document.writeln('<div style="display: block;">');
}
else {
	document.writeln('<div style="display: none;">');
}
</script>
			<table border="0" cellpadding="0" cellspacing="0">
				<tr><td class="textTitle"><fmt:message key="applicationTitle" bundle="${resources}" /></td></tr>
				<tr><td height="20" /></tr>
				<tr><td class="textMessage"><fmt:message key="launchPageInformationMessage1" bundle="${resources}" /></td></tr>
				<tr><td height="10" /></tr>
				<tr><td class="textMessage"><fmt:message key="launchPageInformationMessage2" bundle="${resources}" /></td></tr>
				<tr><td height="10" /></tr>
				<tr><td class="textMessage"><fmt:message key="launchPageInformationMessage3" bundle="${resources}" /></td></tr>
			</table>
<script type="text/javascript">
document.writeln('</div>');
</script>
			</div>

			<script type="text/javascript">
				document.getElementById("mainContent").style.display = "block";
			</script>
			<noscript>
			<table border="0" cellpadding="0" cellspacing="0">
				<tr><td class="textTitle"><fmt:message key="errorEnableJavaScriptTitle" bundle="${resources}" /></td></tr>
				<tr><td height="10" /></tr>
				<tr><td class="textMessage"><fmt:message key="errorEnableJavaScriptMessage" bundle="${resources}" /></td></tr>
			</table>
			</noscript>
		</td>
	</tr>
	<tr><td height="425" /></tr>
</table>

</body>

</html>
