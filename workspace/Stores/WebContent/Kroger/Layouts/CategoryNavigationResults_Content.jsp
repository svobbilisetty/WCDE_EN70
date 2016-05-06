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

<!-- BEGIN CategoryNavigationResults_Content.jsp -->

<%@include file="../Common/EnvironmentSetup.jspf" %>
<%@include file="../Common/nocache.jspf" %>

<c:if test="${empty totalContentCount}">
	<%@include file="../Common/SearchContentSetup.jspf" %>
</c:if>

<c:set var="endIndex" value = "${pageSize + beginIndex}"/>
<c:if test="${endIndex > totalContentCount}">
	<c:set var="endIndex" value = "${totalContentCount}"/>
</c:if>


<%-- totalContentCount is set in SearchContentSetup.jspf file.. --%>
<fmt:parseNumber var="total" value="${totalContentCount}" parseLocale="en_US"/> <%-- Get a float value from totalContentCount which is a string --%>
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

<%-- If we are using grid mode, then we need to know the total number of rows to display --%>
<fmt:formatNumber var="totalRows"  value="${total / env_resultsPerRow}"/>
<c:set var="totalRows" value = "${totalRows + (1 - (totalRows % 1)) % 1}"/>


<div class="widget_articles_videos_position container_margin_5px">
	<div class="widget_articles_videos">
		<div class="top">
			<div class="left_border"></div>
			<div class="middle"></div>
			<div class="right_border"></div>
		</div>
											
											
		<div class="middle">
			<div class="left_content_border">
				<div class="right_content_border">
					<div class="content">
						<div class="header">
							<div class="title"><fmt:message key = "ARTICLES_VIDEOS"/></div>
							<span class="small"> 
								<fmt:message key = "ARTICLE_COUNT_{0}_{1}_{2}">
									<fmt:param value= "${totalContentCount == 0 ? 0 : beginIndex + 1}"/>
									<fmt:param value = "${endIndex}"/>
									<fmt:param value = "${totalContentCount}"/>
								</fmt:message>
							</span>
							<div class="paging_controls">
								<%-- display list and grid view icons --%>
								<c:set var="otherViews" value="false"/>
								<c:set var="eventName" value="showResultsForPageNumber_content"/>
								<c:set var="linkPrefix" value="contentResults"/>
								<script>
									dojo.addOnLoad(function(){
										dojo.subscribe("showResultsForPageNumber_content",SearchBasedNavigationDisplayJS,"showResultsPageForContent");
									});

								</script>
								<%@include file="../Common/PaginationControls.jspf" %>

							</div>

							<div class="sorting_controls">
								<span><label for="orderByContent"><fmt:message key="SN_CONTENT_SORT_BY"/></label>:</span>
								<select id="orderByContent" title="<fmt:message key='SN_SORT_BY_USAGE'/>" name="contentOrderBy" onChange="javaScript:setCurrentId('orderByContent');SearchBasedNavigationDisplayJS.sortResults_content(this.value)">
									<option value = ""><fmt:message key="SN_CONTENT_NO_SORT"/></option>
									<option value = "1"><fmt:message key="SN_CONTENT_SORT_BY_NAME"/></option>
									<option value = "2"><fmt:message key="SN_CONTENT_SORT_BY_TYPE"/></option>
								</select>
							</div>
						</div>

						<div class="clear_float"></div>
						<c:forEach items="${contentresults}" var="content" varStatus="status">
							<c:set var="contentName" value="${content.name}"  />
							<c:set var="contentShortDescription" value="${content.metaData.shortdesc}"  />
							<c:set var="contentHLName" value="${content.metaData.hl_name}" />
							<c:if test="${empty contentHLName}">
								<c:set var="contentHLName" value="${contentName}" />
							</c:if>
							<c:set var="contentHLShortDescription" value="${content.metaData.hl_shortdesc}" />
								<c:if test="${empty contentHLShortDescription}">
								<c:set var="contentHLShortDescription" value="${contentShortDescription}" />
							</c:if>
							<c:set var="urlValue" value="${content.URL}"/>
							<c:if test="${fn:startsWith(urlValue, 'StaticContent/')}">
								<wcf:url var="urlValue" patternName="StaticContentURL" value="StaticContent">
									<wcf:param name="url" value="${fn:substringAfter(urlValue, 'StaticContent/')}" />
									<wcf:param name="langId" value="${param.langId}" />
									<wcf:param name="storeId" value="${param.storeId}" />
									<wcf:param name="catalogId" value="${param.catalogId}" />
									<wcf:param name="urlLangId" value="${urlLangId}" />
								</wcf:url>
							</c:if>
							<c:if test="${!(fn:startsWith(urlValue, '/') || fn:contains(urlValue, '://'))}">
								<c:url var="urlValue" value="/servlet/${urlValue}" />
							</c:if>

							<div class="item">
								<div class="icon">
									<c:set var="iconName" value="${content.metaData.mimetype}"/>
									<c:choose>
										<c:when test="${content.metaData.mimetype eq 'text/html'}">
											<c:set var="iconName" value="html"/>
										</c:when>
										<c:when test="${content.metaData.mimetype eq 'application/pdf'}">
											<c:set var="iconName" value="pdf"/>
										</c:when>
										<c:when test="${content.metaData.mimetype eq 'video/mpeg' || content.metaData.mimetype eq 'video/quicktime'|| content.metaData.mimetype eq 'video/x-msvideo'|| content.metaData.mimetype eq 'application/x-shockwave-flash'}">
											<c:set var="iconName" value="video"/>
										</c:when>
									</c:choose>
									<img src="${jspStoreImgDir}${env_vfileColor}widget_articles_videos/${fn:toLowerCase(iconName)}.png" alt="${content.metaData.mimetype}" /> 
								</div>
								<div class="description">
									<div class="header"><a class="link" href="${urlValue}">${contentHLName}</a></div>
									<div class="clear_float"></div>
									<p>${contentHLShortDescription}</p>
									<div class="item_spacer_5px"></div>
									<p>${content.metaData.mimetype}</p>
								</div>
								<div class="clear_float"></div>
							</div>
							<div class="clear_float"></div>
							<c:if test="${!status.last}">
								<div class="divider"></div>
							</c:if>	
						</c:forEach>

						<div class="clear_float"></div>
					</div>
				</div>
			</div>
		</div>
											
		<div class="bottom">
			<div class="left_border"></div>
			<div class="middle"></div>
			<div class="right_border"></div>
		</div>

	</div>
</div>

<!-- END CategoryNavigationResults_Content.jsp -->