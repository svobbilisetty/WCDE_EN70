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

<!-- BEGIN ContentRecommendation.jsp -->

<%@ include file= "../../../Common/EnvironmentSetup.jspf" %>

<%@ include file="ext/ContentRecommendation_Data.jspf" %>
<c:if test = "${param.custom_data ne 'true'}">
	<%@ include file="ContentRecommendation_Data.jspf" %>
</c:if>

<c:set var="uniqueID" value="${marketingSpotDatas.marketingSpotIdentifier.uniqueID}"/>
<c:set var="espotName" value="${fn:replace(emsName,' ','')}"/>
<c:set var="espotName" value="${fn:replace(espotName,'\\\\','')}"/>
<c:set var="width" value="${param.adWidth}"/>
<c:set var="height" value="${param.adHeight}"/>
<c:set var="ribbonWidth" value="${param.ribbonAdWidth}"/>
<c:set var="ribbonHeight" value="${param.ribbonAdHeight}"/>

<%@ include file="ext/ContentRecommendation_UI.jspf" %>

<c:if test = "${param.custom_view ne 'true'}">
	
			<c:if test="${env_inPreview && !env_storePreviewLink}">	
				<c:if test="${empty contentFormatMap}">
					<c:set var="eSpotHasNoSupportedDataToDisplay" value="true"/>
				</c:if>
				<%@ include file="../include/ESpotInfoPopupDisplay.jspf"%>				
				<div class="genericESpot">
				    <div class="caption" style="display:none"></div>
					<div class="ESpotInfo">
						 <a id="ContentRecommendation_InfoLink_${espotName}" href="javascript:void(0)" onclick="javascript:showESpotInfoPopup('ESpotInfo_popup_<wcf:out escapeFormat="js" value="${espotName}"/>');" title='<c:out value="${emsName}"/>'>
						 	<fmt:message bundle='${previewText}' key='ShowInformation'/>
						 </a>
					</div>
			</c:if>
			
			<c:choose>
				<c:when test="${!empty param.isEmail && param.isEmail == 'true' && !empty contentFormatMap}">
					<c:if test="${!empty contentFormatMap}">
						<%@include file="ContentRecommendation_Email_UI.jspf"%>
					</c:if>
				</c:when>
				<c:when test="${!empty param.useRibbon && param.useRibbon == 'true'}">
					<c:if test="${!empty contentFormatMap}">
						<c:set var="allImages" value="true"/>
						<c:forEach items="${contentFormatMap}" varStatus="aStatus">
							<c:if test="${contentFormatMap[aStatus.current.key] ne 'File' && contentTypeMap[aStatus.current.key] ne 'image'}">
								<%-- contentTypeMap[aStatus.current.key] == null or {} is still ok --%>
								<c:set var="allImages" value="false"/>
							</c:if>
						</c:forEach>
						<c:if test="${allImages}">	
							<%@include file="ContentRecommendation_Ribbon_UI.jspf"%>
						</c:if>
						<c:if test="${!allImages}">
							<%@include file="ContentRecommendation_UI.jspf"%>
						</c:if>
					</c:if>
				</c:when>
				<c:otherwise>
					<c:if test="${!empty contentFormatMap}">
						<%@include file="ContentRecommendation_UI.jspf"%>
					</c:if>
				</c:otherwise>
			</c:choose>
			
			<c:if test="${env_inPreview && !env_storePreviewLink}">
				</div>
			</c:if>
</c:if>

<!-- END ContentRecommendation.jsp -->