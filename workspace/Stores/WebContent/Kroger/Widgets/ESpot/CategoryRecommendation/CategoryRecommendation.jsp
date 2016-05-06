<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2011, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!-- BEGIN CategoryRecommendation.jsp -->

<%@ include file= "../../../Common/EnvironmentSetup.jspf" %>

<%@ include file="ext/CategoryRecommendation_Data.jspf" %>
<c:if test = "${param.custom_data ne 'true'}">
	<%@ include file="CategoryRecommendation_Data.jspf" %>
</c:if>

<c:set var="uniqueID" value="${marketingSpotDatas.marketingSpotIdentifier.uniqueID}"/>
<c:set var="espotName" value="${fn:replace(emsName,' ','')}"/>
<c:set var="espotName" value="${fn:replace(espotName,'\\\\','')}"/>

<c:if test="${env_inPreview && !env_storePreviewLink}">	
	<c:if test="${empty categoryIdMap}">
		<c:set var="eSpotHasNoSupportedDataToDisplay" value="true"/>
	</c:if>
	<%@ include file="../include/ESpotInfoPopupDisplay.jspf"%>				
	<div class="genericESpot">
	    <div class="caption" style="display:none"></div>
		<div class="ESpotInfo">
			 <a id="CategoryRecommendation_InfoLink_${espotName}" href="javascript:void(0)" onclick="javascript:showESpotInfoPopup('ESpotInfo_popup_<wcf:out escapeFormat="js" value="${espotName}"/>');" title='<c:out value="${emsName}"/>'>
			 	<fmt:message bundle='${previewText}' key='ShowInformation'/>
			 </a>
		</div>
</c:if>	
	
<%@ include file="ext/CategoryRecommendation_UI.jspf" %>
<c:if test = "${param.custom_view ne 'true' && !empty categoryImageMap}">
	<%@ include file="CategoryRecommendation_UI.jspf" %>
</c:if>

<c:if test="${env_inPreview && !env_storePreviewLink}">
	</div>
</c:if>

<!-- END CategoryRecommendation.jsp -->