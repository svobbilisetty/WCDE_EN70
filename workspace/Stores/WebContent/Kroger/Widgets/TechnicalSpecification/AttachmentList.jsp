<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2012 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%-- 
  ***
  * params: productId, storeId, catalogId, usage, excludeUsageStr 
  ***
--%>

<!-- BEGIN AttachmentList.jsp -->

<%@ include file= "../../Common/EnvironmentSetup.jspf" %>
<c:set var="uniqueID" value="${WCParam.productId}"/>
<c:if test="${empty uniqueID}">
	<c:set var="uniqueID" value="${param.productId}"/>
</c:if>
<c:set var="excludeUsageStr" value="${WCParam.excludeUsageStr}"/>
<c:if test="${empty excludeUsageStr}">
	<c:set var="excludeUsageStr" value="${param.excludeUsageStr}"/>
</c:if>
<c:set var="usage" value="${WCParam.usage}"/>
<c:if test="${empty usage}">
	<c:set var="usage" value="${param.usage}"/>
</c:if>
<c:set var="beginIndex" value="0"/>
<c:if test="${!empty param.beginIndex}">
	<c:set var="beginIndex" value="${param.beginIndex}"/>
</c:if>


<c:set var="attachmentFilter" value="catentry_id:(${uniqueID})"/>
<c:if test="${!empty usage}">
	<c:set var="INCLUSION" value="rulename:( ${usage} )"/>
	<c:set var="attachmentFilter" value="${attachmentFilter} AND ${INCLUSION}"/>
</c:if>
<c:if test="${empty usage && !empty excludeUsageStr}">
	<c:set var="EXCLUSION" value="NOT rulename:("/>
	<c:forTokens items="${excludeUsageStr}" delims="," var="excludeUsage">
		<c:set var="EXCLUSION" value="${EXCLUSION} ${excludeUsage}"/>
	</c:forTokens>
	<c:set var="EXCLUSION" value="${EXCLUSION} )"/>
	<c:set var="attachmentFilter" value="${attachmentFilter} AND ${EXCLUSION}"/>
</c:if>
<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogNavigationViewType" var="catalogNavigationView"	expressionBuilder="getCatalogEntryAttachmentView" 
	varShowVerb="showCatalogNavigationView" maxItems="${pageSize}" recordSetStartNumber="${beginIndex}" scope="request" varShowVerb="showCatalogNavigationView" >
	<wcf:param name="attachmentFilter" value="${attachmentFilter}" />
	<wcf:contextData name="storeId" data="${storeId}" />
	<wcf:contextData name="catalogId" data="${catalogId}" />
</wcf:getData>
<c:set var="catEntry" value="${catalogNavigationView.catalogEntryView[0]}" />

<c:set var="totalCount" value="${showCatalogNavigationView.recordSetTotal}" />
<c:set var="endIndex" value = "${pageSize + beginIndex}"/>
<c:if test="${endIndex > totalCount}">
	<c:set var="endIndex" value = "${totalCount}"/>
</c:if>

<fmt:parseNumber var="total" value="${totalCount}" parseLocale="en_US"/> <%-- Get a float value from totalCount which is a string --%>
<c:set  var="totalPages"  value = "${total / pageSize * 1.0}"/>
<%-- Get a float value from totalPages which is a string --%>
<fmt:parseNumber var="totalPages" value="${totalPages}" integerOnly="false" parseLocale="en_US"/> 

<%-- do a ceil if totalPages contains fraction digits --%>
<c:set var="totalPages" value = "${totalPages + (1 - (totalPages % 1)) % 1}"/>

<c:set var="currentPage" value = "${( beginIndex + 1) / pageSize}" />
<%-- Get a float value from currentPage which is a string --%>
<fmt:parseNumber var="currentPage" value="${currentPage}" integerOnly="false" parseLocale="en_US"/>

<%-- do a ceil if currentPage contains fraction digits --%>
<c:set var="currentPage" value = "${currentPage + (1 - (currentPage % 1)) % 1}"/>

<%-- Get a float value from currentPage which is a string --%>
<fmt:parseNumber var="currentPage" value="${currentPage}" integerOnly="false" parseLocale="en_US"/>

<%-- Get number of items to be displayed in this page --%>
<c:if test="${totalCount>0}">
<fmt:parseNumber var="numOfItemsInPage" value="${endIndex - beginIndex}" integerOnly="false" parseLocale="en_US"/>
<div class="header_bar">
	<div class="title"><fmt:message key="PT_PRODUCT_ATTACHMENT"/> 
		<span class="num_products">&#40;&nbsp;
			<c:set var="beginCounter" value="${beginIndex + 1}"/>
			<c:if test="${totalCount == 0}">
				<c:set var="beginCounter" value = "0"/>
			</c:if>
			<fmt:message key="PAGINATION_{0}_TO_{1}_OF_{2}">
				<fmt:param value="${beginCounter}"/>
				<fmt:param value="${endIndex}"/>
				<fmt:param value="${totalCount}"/>
			</fmt:message>
			&nbsp;&#41;
		</span>
	</div>

	<%-- Set variables used by pagination controls --%>
	<c:set var="otherViews" value="false"/> <%-- display list and grid view icons --%>
	<c:set var="eventName" value="AttachmentPagination_Context"/>
	<c:if test="${totalCount>1}">
		<div class="paging_controls">
			<c:set var="linkPrefix" value="categoryResults"/>
			<%@include file="../../Common/PaginationControls.jspf" %>
		</div>
	</c:if>
</div>
</c:if>
<jsp:useBean id="attachmentGrp" class="java.util.TreeMap" type="java.util.TreeMap"/>
<c:forEach items="${catEntry.attachments}" var="attachment">
	<c:set var="displayAttachment" value="true" />
	<%-- if usage is specified, only display attachment of the specified usage. --%>
	<c:choose>
		<%-- Do not display attachments with empty usage type --%>
		<c:when test="${empty attachment.usage}">
			<c:set var="displayAttachment" value="false" />
		</c:when>
		<c:when test="${!empty usage}">
		    <c:if test="${param.usage ne attachment.usage}">
			    <c:set var="displayAttachment" value="false" />
		    </c:if>
		</c:when>
		<c:when test="${!empty excludeUsageStr}">
			<%-- checks the usage type of this attachment and see if should exclude this attachment from display --%>
            <c:forTokens items="${excludeUsageStr}" delims="," var="usageType">
			    <c:if test="${usageType == attachment.usage}">
				    <c:set var="displayAttachment" value="false" />
			    </c:if>
		    </c:forTokens>
		</c:when>
	</c:choose>
		
	<c:if test="${displayAttachment}">
		<c:set var="mimeType" value="${attachment.mimeType}" />
		<c:set var="mimePart" value="" />
		
	    <c:forTokens items="${mimeType}" delims="/" var="mimePartFromType" end="0">
		    <c:set var="mimePart" value="${mimePartFromType}" />
	    </c:forTokens>
	    
	    <c:set var="attachmentType" value="default"/>
	    <c:if test="${not empty mimeType}">	
	    	<c:if test="${mimeType eq 'text/plain'}">
	    		<c:set var="attachmentType" value="text"/>
	    	</c:if>
	    	<c:if test="${mimeType eq 'image/gif' || mimeType eq 'image/jpeg' || mimeType eq 'image/png'}">
	    		<c:set var="attachmentType" value="image"/>
	    	</c:if>
	    	<c:if test="${mimeType eq 'application/pdf'}">
	    		<c:set var="attachmentType" value="pdf"/>
	    	</c:if>
	    	<c:if test="${mimeType eq 'application/postscript' || mimeType eq 'application/msword'}">
	    		<c:set var="attachmentType" value="doc"/>
	    	</c:if>
	    	<c:if test="${mimeType eq 'application/vnd.ms-powerpoint'}">
	    		<c:set var="attachmentType" value="presentation"/>
	    	</c:if>
	    	<c:if test="${mimeType eq 'application/vnd.ms-excel'}">
	    		<c:set var="attachmentType" value="spreadsheet"/>
	    	</c:if>
	    	<c:if test="${mimeType eq 'audio/x-wav' || mimeType eq 'audio/x-pn-realaudio' || mimeType eq 'audio/x-pn-realaudio-plugin'}">
	    		<c:set var="attachmentType" value="audio"/>
	    	</c:if>
	    	<c:if test="${mimeType eq 'video/mpeg' || mimeType eq 'video/quicktime'|| mimeType eq 'video/x-msvideo'|| mimeType eq 'application/x-shockwave-flash'}">
	    		<c:set var="attachmentType" value="video"/>
	    	</c:if>
	    	<c:if test="${mimeType eq 'application/x-gzip' || mimeType eq 'application/zip' || mimeType eq 'application/x-gtar' || mimeType eq 'application/x-tar' || mimeType eq 'application/java-archive'}">
	    		<c:set var="attachmentType" value="archive"/>
	    	</c:if>
		</c:if>
		<c:if test="${empty mimePart}">
			<c:set var="attachmentType" value="webpage"/>
		</c:if>
		<c:set var="attchImage" value="${jspStoreImgDir}${env_vfileColor}${attachmentType}_32.png" />
		
 		<c:forEach var="metaData" items="${attachment.metaData}">
			<c:if test="${metaData.typedKey == 'name'}">
				<c:set var="attchName" value="${metaData.typedValue}" />
			</c:if>
			<c:if test="${metaData.typedKey == 'shortdesc'}">
				<c:set var="attchShortDesc" value="${metaData.typedValue}" />
			</c:if>
			<c:if test="${metaData.typedKey == 'longdesc'}">
				<c:set var="attchLongDesc" value="${metaData.typedValue}" />
			</c:if>
			<c:if test="${metaData.typedKey == 'size'}">
				<c:set var="size" value="${metaData.typedValue}" />
				<c:if test="${size<1048576}">
					<fmt:formatNumber var="formated_size" value="${size/1024}" pattern="0.00KB"/>
				</c:if>
				<c:if test="${size>=1048576&&size<1073741824}">
					<fmt:formatNumber var="formated_size" value="${size/1048576}" pattern="0.00MB"/>
				</c:if>
				<c:if test="${size>=1073741824}">
					<fmt:formatNumber var="formated_size" value="${size/1073741824}" pattern="0.00GB"/>
				</c:if>
			</c:if>
		</c:forEach>
		<c:choose>
			<c:when test="${empty attachmentGrp[attachment.usage]}">
				<wcf:useBean var="attachmentsList" classname="java.util.ArrayList"/>
				<c:set target="${attachmentGrp}" property="${attachment.usage}" value="${attachmentsList}"/>
			</c:when>
			<c:otherwise>
				<c:set var="attachmentsList" value="${attachmentGrp[attachment.usage]}"/>
			</c:otherwise>
		</c:choose>
		<jsp:useBean id="attachmentDetails" class="java.util.HashMap" type="java.util.Map"/>
		<c:set target="${attachmentDetails}" property="name" value="${attchName}"/>
		<c:set target="${attachmentDetails}" property="assetPath" value="${attachment.attachmentAssetPath}"/>
		<c:set target="${attachmentDetails}" property="shortDesc" value="${attchShortDesc}"/>
		<c:set target="${attachmentDetails}" property="longDesc" value="${attchLongDesc}"/>
		<c:set target="${attachmentDetails}" property="image" value="${attchImage}"/>
		<c:set target="${attachmentDetails}" property="mimeType" value="${mimeType}"/>
		<c:set target="${attachmentDetails}" property="mimePart" value="${mimePart}"/>
		<c:set target="${attachmentDetails}" property="size" value="${formated_size}"/>
		
		<wcf:set target="${attachmentsList}" value="${attachmentDetails}"/>
		<c:remove var="attachmentDetails"/>
		<c:remove var="attachmentsList"/>
	</c:if>
</c:forEach>



<c:if test="${not empty attachmentGrp}">
	<c:forEach var="attachmentsList" items="${attachmentGrp}">
		<div class="header">${attachmentsList.key}</div>
		<div class="attachment">
			<c:forEach var="attachmentDetails" items="${attachmentsList.value}" varStatus="status">
				<div class="attachment">
					<c:set var="mimePart" value="${attachmentDetails['mimePart']}" />
					<c:choose>
			    		<c:when test="${(mimePart eq 'image') || (mimePart eq 'images')|| (mimePart eq 'application') || (mimePart eq 'applications') || ( mimePart eq 'text') 							
										||(mimePart eq 'textyv' ) || (mimePart eq 'video') || (mimePart eq 'audio')	
										|| (mimePart eq 'model')}"> 
									<div class="icon">
										<img src="${attachmentDetails['image']}" alt="${attachmentDetails['longDesc']}" />
									</div>
									<div class="description">
										<a href="${staticAssetContextRoot}/${attachmentDetails['assetPath']}" target="_blank" id="WC_TechnicalSpecification_Links_1_${status.count}">
											<c:out value="${(empty attachmentDetails['name'])?'doc':attachmentDetails['name']}"/>
										</a>
										<div class="clear_float"></div>
										<c:if test="${not empty attachmentDetails['size']}">
											<span class="size">(${attachmentDetails['size']})</span>
										</c:if>
									</div>
						</c:when>			
						<c:when test="${(mimePart eq 'uri')}">
						    <a href="${attachmentDetails['assetPath']}" target="_blank" id="WC_TechnicalSpecification_Links_3_${status.count}"> 
							    <c:out value="${attachmentDetails['name']}" />
						    </a>
						</c:when>
						<c:when test="${empty mimePart}">
							<c:set var="http" value=""/>
							<c:if test="${fn:indexOf(attachmentDetails['assetPath'],'://') == -1 }">
								<c:set var="http" value="http://"/>
							</c:if>
							<div class="icon">
								<img src="${attachmentDetails['image']}" alt="${attachmentDetails['longDesc']}" />
							</div>
							<div class="description">
								<a href="${http}${attachmentDetails['assetPath']}" target="_new" id="WC_TechnicalSpecification_Links_2_${status.count}"> 
									<c:out value="${attachmentDetails['assetPath']}"/>
								</a>
								<div class="clear_float"></div>
							</div>
						</c:when>
						<c:otherwise>
							<!-- Unknown attachment -->
						</c:otherwise>					
					</c:choose>
				</div>
				<div class="clear_float"> </div>
			</c:forEach>
		</div>
		<div class="item_spacer_5px"></div>
		<div class="item_spacer_10px"></div>
	</c:forEach>
</c:if>

<!-- END AttachmentList.jsp -->