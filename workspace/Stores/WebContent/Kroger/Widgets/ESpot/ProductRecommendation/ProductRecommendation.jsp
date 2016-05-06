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

<!-- BEGIN ProductRecommendation.jsp -->

<%@ include file= "../../../Common/EnvironmentSetup.jspf" %>


<%@ include file="ext/ProductRecommendation_Data.jspf" %>
<c:if test = "${param.custom_data ne 'true'}">
	<%@ include file="ProductRecommendation_Data.jspf" %>
</c:if>

<c:if test="${!empty param.align}">
	<c:set var="align" value="${param.align}"/>
</c:if>

<c:set var="displayHeader" value="true"/>
<c:if test="${!empty param.displayHeader && param.displayHeader != 'true'}">
	<c:set var="displayHeader" value="false"/>
</c:if>

<c:set var="emsId" value="${marketingSpotDatas.marketingSpotIdentifier.uniqueID}"/>
<c:set var="espotName" value="${fn:replace(emsName,' ','')}"/>
<c:set var="espotName" value="${fn:replace(espotName,'\\\\','')}"/>

<c:if test="${env_inPreview && !env_storePreviewLink}">	
	<c:if test="${empty catentryIdList}">
		<c:set var="eSpotHasNoSupportedDataToDisplay" value="true"/>
	</c:if>
	<%@ include file="../include/ESpotInfoPopupDisplay.jspf"%>				
	<div class="genericESpot">
	    <div class="caption" style="display:none"></div>
		<div class="ESpotInfo">
			 <a id="ProductRecommendation_InfoLink_${espotName}" href="javascript:void(0)" onclick="javascript:showESpotInfoPopup('ESpotInfo_popup_<wcf:out escapeFormat="js" value="${espotName}"/>');" title='<c:out value="${emsName}"/>'>
			 	<fmt:message bundle='${previewText}' key='ShowInformation'/>
			 </a>
		</div>
</c:if>

<%@ include file="ext/ProductRecommendation_UI.jspf" %>

<c:if test = "${param.custom_view ne 'true' && !empty catentryIdList}">
	<c:choose>
		<c:when test="${align eq 'scroll'}">
			<%@include file="ProductRecommendation_Scroll_UI.jspf"%>
		</c:when>
		<c:when test="${align eq 'vertical'}">
				<%@include file="ProductRecommendation_Vertical_UI.jspf"%>
		</c:when>			
		<c:otherwise>
			<%@include file="ProductRecommendation_Horizontal_UI.jspf"%>
		</c:otherwise>
	</c:choose>
</c:if>

<c:if test="${env_inPreview && !env_storePreviewLink}">	
	</div>
</c:if>

<!-- END ProductRecommendation.jsp -->