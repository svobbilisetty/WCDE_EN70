
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
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<fmt:setLocale value="${param.locale}" />
<fmt:setBundle basename="com.ibm.commerce.foundation.client.lobtools.properties.ShellLOB" var="resources" />

<c:set var="backSlash" value="\\\\" />
<c:set var="escapedBackSlash" value="\\\\\\\\" />
<c:set var="singleQuote" value="'" />
<c:set var="escapedSingleQuote" value="\\\\'" />
<c:set var="doubleQuote" value="\"" />
<c:set var="escapedDoubleQuote" value="\\\\\"" />
<c:set var="forwardSlash" value="/" />
<c:set var="escapedForwardSlash" value="\\\\/" />
<c:set var="localeValue" value="${fn:replace(param.locale, backSlash, escapedBackSlash)}" />
<c:set var="localeValue" value="${fn:replace(localeValue, singleQuote, escapedSingleQuote)}" />
<c:set var="localeValue" value="${fn:replace(localeValue, doubleQuote, escapedDoubleQuote)}" />
<c:set var="localeValue" value="${fn:replace(localeValue, forwardSlash, escapedForwardSlash)}" />

<%
	request.setAttribute(com.ibm.commerce.foundation.internal.client.lobtools.servlet.TrimWhitespacePrintWriterImpl.TRIM_WHITESPACE, Boolean.FALSE);
	boolean workspacesEnabled = com.ibm.commerce.tools.common.ToolsConfiguration.isComponentEnabled("WorkspaceTaskList");
	boolean contentVersionEnabled = com.ibm.commerce.server.WcsApp.isFeatureEnabled("content-version");
	String previewWebPath = null;
	String previewWebAlias = null;
	com.ibm.commerce.server.WebModuleConfig previewConfig = com.ibm.commerce.server.WcsApp.configProperties.getWebModule("Preview");
	if (previewConfig != null) {
		previewWebPath = previewConfig.getContextPath() + previewConfig.getUrlMappingPath();
		previewWebAlias = previewConfig.getWebAlias();
	}
%>

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="${pageContext.request.locale.language}" lang="${pageContext.request.locale.language}">

<head>
<title><fmt:message key="applicationTitle" bundle="${resources}" /></title>
<style type="text/css">
html { background-image: url('${pageContext.request.contextPath}/images/shell/background_tile.png'); background-repeat: repeat; height: 100%; overflow: hidden; }
body { margin: 0 0 0 0; background-image: url('${pageContext.request.contextPath}/images/shell/no_tab_background.png'); background-repeat: x-repeat; height: 100%; }
td.textTitle { font-family: Arial; font-size: 16pt; font-weight: bold; word-wrap: break-word; color: #3050a6; }
td.textMessage { font-family: Arial; font-size: 11pt; word-wrap: break-word; color: #000000; }
</style>
<script type="text/javascript" src="${pageContext.request.contextPath}/dojo/dojo/dojo.js" djConfig="isDebug: false"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/javascript/shell/ManagementCenter.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/javascript/openLaszlo/embed-compressed.js"></script>
<script type="text/javascript">
<!-- hide script from old browsers
var isIE = (navigator.appVersion.indexOf("MSIE") != -1) ? true : false;
var requiredIEVersion = 7.0;
var requiredFFVersion = 3;
var requiredFlashVersion = 10;
var isUserLoggedOn = false;
var loggedInUserLocale = "<c:out value="${localeValue}" escapeXml="false" />";
var acceleratorWindowObj = null;
var windowBaseName = "cmcMainWindow_" + removeInvalidChar(window.location.hostname);
var isCMCApplicationInitialized = false;
var automationStatusMsg = "";
var automationLastAction = "";
window.name = windowBaseName;
var newWindowObjs = new Object();

//
// Loads the content from the specified URL synchronously and returns the response as the
// data property in a response object.
//
function synchGet(path) {
	var response = {};
	try {
		dojo.xhrGet({
			url: path,
			handleAs: "text",
			load: function(data) {
				response.data = data;
			},
			error: function(error, ioArgs) {
				response.error = error.description;
			},
			sync: true
		});
	}
	catch (e) {
		response.error = e.message;
	}
	return response;
}

//
// Sets the status message to "initiated", "complete" or "aborted" when automation is initialized, complete or aborted.
//
function setAutomationStatusMsg(statusMsg){
	automationStatusMsg = statusMsg;
}

//
// Sets the last automation action
//
function setAutomationLastAction(action){
	automationLastAction = action;
}

//
// This function will be called when CMC is initialized
//
function cmcApplicationInitialized() {
	isCMCApplicationInitialized = true;
}

//
// Reset CMC keys
//
function resetCMCKeys() {
	if (isCMCApplicationInitialized && document.getElementById("cmcApplication").resetKeys) {
		document.getElementById("cmcApplication").resetKeys();
	}
}

//
// If the user has logged on when this window is attempted to close, pop up an alert dialog.
//
function beforeExit () {
	if (isUserLoggedOn) {
        return ''; // Empty message for the dialog.
	}
}

window.onbeforeunload = beforeExit;
window.onunload = closeAllChildWindows;

//
// Checks the browser and its version and determines if it is supported or not.
//
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

//
// Checks the flash plug-in and its version and determines if it is supported or not.
//
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

//
// Gets the locale of the logged on user in Management Center. This locale is used to determine the resourceBundle
// for displaying the texts in AlertDialog.jsp.
//
function getLoggedInUserLocale(){
	return loggedInUserLocale;
}

//
// Opens a new browser window positioned at the center with the URL specified.
// the arg object should contain : windowName, URL or content, windowFeatures, windowHeight and windowWidth.
// windowFeatures should not contain: left, top, width and height. It will calculate and set them before opening the window.
//
function openNewCenteredWindow (arg) {
	var left = 0;
	var top = 0;
	if (isIE) {
		left = (window.screen.availWidth - parseInt(arg.windowWidth)) / 2;
		top = (window.screen.availHeight - parseInt(arg.windowHeight)) / 2;
	}
	else {
		left = window.screenX + ((window.outerWidth - parseInt(arg.windowWidth)) / 2);
		top = window.screenY + ((window.outerHeight - parseInt(arg.windowHeight)) / 2);
	}
	var newWindowFeatures = "left=" + left + ",top=" + top + ",width=" + arg.windowWidth + ",height=" + arg.windowHeight + "," + arg.windowFeatures;
	var newWindowObj = new Object();
	newWindowObj.URL = arg.URL;
	newWindowObj.content = arg.content;
	newWindowObj.windowName = removeInvalidChar(arg.windowName);
	newWindowObj.windowFeatures = newWindowFeatures;
	
	var newWindow = openNewWindow(newWindowObj);
	if (arg.submitForm) {
		newWindow.document.forms[0].submit();
	}
}

//
// Launches openNewModalDialog on a timer.
//
function launchModalDialog (arg) {
	setTimeout(function() {
		openNewModalDialog(arg);
		}, 1);
}

//
// Opens a new modal dialog with the URL specified.
//
function openNewModalDialog (arg) {
	var dialogArguments = arg.windowArguments;
	var dialogName = arg.windowName;
	var dialogWidth = arg.windowWidth;
	var dialogHeight = arg.windowHeight;
	var features = "dialogWidth: " + dialogWidth + "px; dialogHeight: " + dialogHeight + "px; center: yes; resizable: no; status: no; help: no; scroll: yes;";
	var returnValue = window.showModalDialog(arg.URL, dialogArguments, features);
	if (typeof(returnValue) != "undefined") {
		document.getElementById('cmcApplication').setCallbackValue(returnValue, returnValue == "");
	}
	else {
		document.getElementById('cmcApplication').setCallbackValue(null, false);
	}
	resetCMCKeys();
}

//
// Opens a new browser window with the URL or content specified. If the URL is missing or blank,
// the new window will contain the HTML in the arg.content parameter. 
// NOTE: In the case of an Accelerator window, if there is such window with that name already opened
//       then it will just focus on the window.
//
function openNewWindow (arg) {
    var newWindow;
	var windowName = removeInvalidChar(arg.windowName);
    
	if (arg.windowName.indexOf("MerchantCenter") != -1) {
		if (acceleratorWindowObj == null || acceleratorWindowObj.closed) {
			acceleratorWindowObj = window.open(arg.URL, windowName, arg.windowFeatures);
		}
		acceleratorWindowObj.focus();
		newWindow = acceleratorWindowObj;
	}
	else {
		if(arg.URL && arg.URL != "") {
			var newWindowObj = window.open(arg.URL, windowName, arg.windowFeatures);
			newWindowObj.focus();
			newWindow = newWindowObj;

			newWindowObjs[windowName] = newWindowObj;
		}
		else if(arg.content && arg.content != "") {
			if(newWindowObjs[windowName]) {
				newWindowObjs[windowName].close();
			}
			var newWindowObj = window.open("", windowName, arg.windowFeatures);
			newWindowObj.document.write(arg.content);
			newWindowObj.focus();
			newWindow = newWindowObj;

			newWindowObjs[windowName] = newWindowObj;
		}
	}
	resetCMCKeys();
	return newWindow;
}

//
// Closes all child windows that have been opened
//
function closeAllChildWindows() {
	for(var win in newWindowObjs) {
		if(!newWindowObjs[win].closed) {
			newWindowObjs[win].close();
		}
	}
}

//
// Sets the locale of the logged on user in Management Center. This locale is used to determine the resourceBundle
// for displaying the texts in AlertDialog.jsp.
// This method is called from CMC after user is logged successfuly and user locale is retrieved from database.
//
function setLoggedInUserLocale(locale){
	loggedInUserLocale = locale;
}

//
// Sets the ID of the user who has logged on.
//
function setUserLogonId (arg) {
	window.name = arg == null ? windowBaseName : windowBaseName + "_" + removeInvalidChar(arg);
	isUserLoggedOn = arg == null ? false : true;

	if(arg == null) {
		closeAllChildWindows();
	}
}

//
// Event that is triggered when the page is loaded. The flash object that runs Management Center will be focused.
//
function window_onLoad () {
	if (document.getElementById('cmcApplication') != null) {
		document.getElementById('cmcApplication').focus();
	}
}

//
// Forces a user re-login in Management Center
//
function doRelogon(reason) {
	if(reason == "CWXBB1011E" || reason == "1011") {
		document.getElementById("cmcApplication").doSessionTimeout();
	}
	else if(reason == "CWXBB1012E" || reason == "1012") {
		document.getElementById("cmcApplication").doSessionTerminated();
	}
	else {
		document.getElementById("cmcApplication").doSessionCorrupted();
	}
}

function editBusinessObject(toolId, storeId, storeSelection, languageId, searchType, searchOptions) {
	document.getElementById("cmcApplication").triggerAction("wcfOpenObjectActionHandler", {
		toolId: toolId,
		storeId: storeId,
		storeSelection: storeSelection,
		languageId: languageId,
		searchType: searchType,
		searchOptions: searchOptions,
		select: true
	});
}

function createBusinessObject(toolId, storeId, storeSelection, languageId, objectType, newObjectOptions) {
	document.getElementById("cmcApplication").triggerAction("wcfCreateObjectActionHandler", {
		toolId: toolId,
		storeId: storeId,
		storeSelection: storeSelection,
		languageId: languageId,
		objectType: objectType,
		newObjectOptions: newObjectOptions
	});
}
//-->
</script>
</head>

<body onload="window_onLoad()">

<div id="mainContent" style="display: none; height: 100%;">

<script type="text/javascript">
if (!checkBrowser()) {
	document.writeln('<div style="display: block;">');
}
else {
	document.writeln('<div style="display: none;">');
}
</script>
<table border="0" cellpadding="0" cellspacing="0">
	<tr><td height="75" /></tr>
	<tr>
		<td width="105" />
		<td width="130" height="130" background="${pageContext.request.contextPath}/images/shell/mc_logo.png" style="background: transparent url(\'${pageContext.request.contextPath}/images/shell/mc_logo.png\') none; background-repeat: no-repeat; filter:progid:DXImageTransform.Microsoft.AlphaImageLoader(enabled=true, src=\'${pageContext.request.contextPath}/images/shell/mc_logo.png\', sizingMethod=\'image\')" />
		<td width="35" />
		<td>
			<table border="0" cellpadding="0" cellspacing="0">
				<tr><td class="textTitle"><fmt:message key="errorSupportedBrowserTitle" bundle="${resources}" /></td></tr>
				<tr><td height="10" /></tr>
				<tr><td class="textMessage"><fmt:message key="errorSupportedBrowserMessage" bundle="${resources}" /></td></tr>
			</table>
		</td>
	</tr>
	<tr><td height="425" /></tr>
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
	<tr><td height="75" /></tr>
	<tr>
		<td width="105" />
		<td width="130" height="130" background="${pageContext.request.contextPath}/images/shell/mc_logo.png" style="background: transparent url(\'${pageContext.request.contextPath}/images/shell/mc_logo.png\') none; background-repeat: no-repeat; filter:progid:DXImageTransform.Microsoft.AlphaImageLoader(enabled=true, src=\'${pageContext.request.contextPath}/images/shell/mc_logo.png\', sizingMethod=\'image\')" />
		<td width="35" />
		<td>
			<table border="0" cellpadding="0" cellspacing="0">
				<tr><td class="textTitle"><fmt:message key="errorFlashVersionTitle" bundle="${resources}" /></td></tr>
				<tr><td height="10"/></tr>
				<tr><td class="textMessage"><fmt:message key="errorFlashVersionMessage" bundle="${resources}" /></td></tr>
			</table>
		</td>
	</tr>
	<tr><td height="425" /></tr>
</table>
<script type="text/javascript">
document.writeln('</div>');
</script>

<script type="text/javascript">
if (checkBrowser() && checkFlashVersion()) {
	//
	// append parameters to the flash application URL
	//
	var appURLParams = "";

	var previewPort = '<%= com.ibm.commerce.server.ConfigProperties.singleton().getValue("WebServer/PreviewPort") %>';
	if (previewPort != "null" && previewPort != "") {
		appURLParams = appURLParams + "&previewPort=" + previewPort;
	}

	var previewWebPath = '<%= previewWebPath %>';
	if (previewWebPath != "null" && previewWebPath != "") {
		appURLParams = appURLParams + "&previewWebPath=" + previewWebPath;
	}

	var previewWebAlias = '<%= previewWebAlias %>';
	if (previewWebAlias != "null" && previewWebAlias != "") {
		appURLParams = appURLParams + "&previewWebAlias=" + previewWebAlias;
	}
	
	var helpServerHostName = '<%= com.ibm.commerce.server.ConfigProperties.singleton().getValue("Websphere/HelpServerHostName") %>';
	if (helpServerHostName != "null" && helpServerHostName != "") {
		appURLParams = appURLParams + "&helpServerHostName=" + helpServerHostName;
	}

	var helpServerPort = '<%= com.ibm.commerce.server.ConfigProperties.singleton().getValue("Websphere/HelpServerPort") %>';
	if (helpServerPort != "null" && helpServerPort != "") {
		appURLParams = appURLParams + "&helpServerPort=" + helpServerPort;
	}

	var helpServerContextPath = '<%= com.ibm.commerce.server.ConfigProperties.singleton().getValue("Websphere/HelpServerContextPath") %>';
	if (helpServerContextPath != "null" && helpServerContextPath != "") {
		appURLParams = appURLParams + "&helpServerContextPath=" + helpServerContextPath;
	}

<c:forEach var="aParam" items="${paramValues}">
	<c:forEach var="aValue" items="${aParam.value}">
	appURLParams = appURLParams + "&<c:out value="${aParam.key}" />=<c:out value="${aValue}" />";
	</c:forEach>
</c:forEach>
	
	appURLParams = appURLParams + "&workspacesEnabled=<%=workspacesEnabled%>";
	appURLParams = appURLParams + "&contentVersionEnabled=<%=contentVersionEnabled%>";
	appURLParams = appURLParams + "&serviceContextRoot=${pageContext.request.contextPath}";
	
	if (isIE) {
		appURLParams = "?isIE=true" + appURLParams;
	} else {
		appURLParams = "?isIE=false" + appURLParams;
	}

	//
	// open the flash application URL with browser specific features
	//
	lz.embed.swf({url: '${pageContext.request.contextPath}/ManagementCenter.swf'+appURLParams, allowfullscreen: 'false', bgcolor: '#ffffff', width: '100%', height: '100%', id: 'cmcApplication', accessible: 'false', cancelmousewheel: false});

	document.onfocusin = resetCMCKeys;
	document.onfocusout = resetCMCKeys;
	window.onfocus = resetCMCKeys;
	window.onblur = resetCMCKeys;
}
</script>

</div>

<script type="text/javascript">
document.getElementById("mainContent").style.display = "block";
</script>
<noscript>
<table border="0" cellpadding="0" cellspacing="0">
	<tr><td height="75" /></tr>
	<tr>
		<td width="105" />
		<td width="130" height="130" background="${pageContext.request.contextPath}/images/shell/mc_logo.png" style="background: transparent url('${pageContext.request.contextPath}/images/shell/mc_logo.png') none; background-repeat: no-repeat; filter:progid:DXImageTransform.Microsoft.AlphaImageLoader(enabled=true, src='${pageContext.request.contextPath}/images/shell/mc_logo.png', sizingMethod='image')" />
		<td width="35" />
		<td>
			<table border="0" cellpadding="0" cellspacing="0">
				<tr><td class="textTitle"><fmt:message key="errorEnableJavaScriptTitle" bundle="${resources}" /></td></tr>
				<tr><td height="10" /></tr>
				<tr><td class="textMessage"><fmt:message key="errorEnableJavaScriptMessage" bundle="${resources}" /></td></tr>
			</table>
		</td>
	</tr>
	<tr><td height="425" /></tr>
</table>
</noscript>

</body>

</html>
