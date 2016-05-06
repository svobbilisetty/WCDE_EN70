<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!-- BEGIN CachedSuggestions.jsp -->

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@include file="../../Common/EnvironmentSetup.jspf" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ page trimDirectiveWhitespaces="true" %>


<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogNavigationViewType" var="catalogNavigationView" 
expressionBuilder="getCatalogNavigationView" scope="request" varShowVerb="showCatalogNavigationView" scope="request">
	<wcf:param name="searchProfile" value="IBM_findNavigationSuggestions" />
	<wcf:param name="categoryId" value="" />
	<wcf:contextData name="storeId" data="${param.storeId}" />
	<wcf:contextData name="catalogId" data="${param.catalogId}" />
</wcf:getData>

<c:set var="suggestionList" value="${catalogNavigationView.suggestionView}"/>
&nbsp;
<div id="cachedSuggestions">
<script type="text/javascript">
	// The primary Array to hold all static search suggestions
	var staticContent = new Array();

	// The titles of each search grouping
	var staticContentHeaders = new Array();

	<c:forEach var="suggestions" items="${suggestionList}">
		// The static search grouping content
		var s = new Array();
		staticContentHeaders.push('<c:out value="${suggestions.label}"/>');
		<c:forEach var="entry" items="${suggestions.entry}">
			<c:remove var="urlValue"/>
			<c:set var="displayName" value="${entry.name}"/>
			<c:choose>
				<c:when test="${suggestions.identifier == 'Brand'}">
					<wcf:url var="urlValue" value="SearchDisplay">
						<wcf:param name="langId" value="${param.langId}" />
						<wcf:param name="storeId" value="${param.storeId}" />
						<wcf:param name="catalogId" value="${param.catalogId}" />
						<wcf:param name="sType" value="SimpleSearch" />
						<wcf:param name="manufacturer" value="${entry.name}"/>
					</wcf:url>
				</c:when>
				<c:when test="${suggestions.identifier == 'Category'}">
					<c:set var="displayName" value="${entry.userData.userDataField.FULL_PATH}"/>
					<c:choose>
						<c:when test="${fn:length(displayName) == fn:length(entry.name)}">
							<wcf:url var="urlValue" patternName="CanonicalCategoryURL" value="Category3">
								<wcf:param name="langId" value="${langId}" />
								<wcf:param name="storeId" value="${storeId}" />
								<wcf:param name="catalogId" value="${catalogId}" />
								<wcf:param name="categoryId" value="${entry.value}" />
								<wcf:param name="pageView" value="${defaultPageView}" />
								<wcf:param name="beginIndex" value="0" />
								<wcf:param name="urlLangId" value="${urlLangId}" />
							</wcf:url>
						</c:when>
						<c:otherwise>
							<wcf:url var="urlValue" patternName="SearchCategoryURL" value="SearchDisplay">
								<wcf:param name="langId" value="${param.langId}" />
								<wcf:param name="storeId" value="${param.storeId}" />
								<wcf:param name="catalogId" value="${param.catalogId}" />
								<wcf:param name="sType" value="SimpleSearch" />
								<wcf:param name="facet" value=""/>
								<wcf:param name="categoryId" value="${entry.value}" />
								<wcf:param name="urlLangId" value="${urlLangId}" />
							</wcf:url>
						</c:otherwise>
					</c:choose>
				</c:when>
				<c:when test="${suggestions.identifier == 'Articles'}">
					<c:set var="urlValue" value="${entry.value}"/>
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
				</c:when>
				<c:otherwise>
					<c:set var="urlValue" value="#"/>
				</c:otherwise>
			</c:choose>
			s.push(["<c:out value="${entry.name}" escapeXml='false'/>", "<c:out value="${urlValue}"/>", "<c:out value="${displayName}" escapeXml='false'/>"]);
		</c:forEach>
		staticContent.push(s);
	</c:forEach>
</script>
</div>

<!-- END CachedSuggestions.jsp -->