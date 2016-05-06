<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2009, 2012 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!-- BEGIN AutoSuggestSerialize.jsp -->

<%@include file="../../Common/JSTLEnvironmentSetup.jspf" %>
<%@include file="../../Common/EnvironmentSetup.jspf" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@page import="java.util.List"%>
<%@page import="java.util.Vector"%>
<%@page import="org.apache.solr.client.solrj.SolrQuery"%>
<%@page import="org.apache.solr.client.solrj.impl.CommonsHttpSolrServer"%>
<%@page import="org.apache.solr.client.solrj.SolrServer"%>
<%@page import="org.apache.solr.client.solrj.request.QueryRequest"%>
<%@page import="org.apache.solr.client.solrj.response.TermsResponse.Term"%>
<%@page import="org.apache.solr.common.params.TermsParams"%>
<%@page import="org.apache.solr.client.solrj.SolrRequest"%>
<%@page import="com.ibm.commerce.foundation.internal.server.services.search.config.solr.SolrSearchConfigurationRegistry"%>
<%@page import="com.ibm.commerce.foundation.internal.server.services.search.metadata.solr.SolrSearchServiceConstants"%>


<fmt:message var="suggestedKeyWords" key="SUGGESTED_KEYWORDS" />

<% 

		String SOLR_CORE_NAME = "coreName";
		String SOLR_SERVER_URL = "serverURL";
		String PARAM_TERM = "term";
		String PARAM_COUNT = "count";
		String PARAM_SHOWHEADER = "showHeader";
		String TERM_QUERY_TYPE = "/terms";
		String TERMS_FIELD = "spellCheck";

		int limit = 4; // default limit

		final int BUFFER_SIZE = 50;
		String requestURI = request.getRequestURI();

		String term = request.getParameter(PARAM_TERM);

		if (term != null) {
			int termLength = term.length();
			if (term.length() > 0) {
				String countParameter = request.getParameter(PARAM_COUNT);
				if (countParameter != null && countParameter.length() > 0) {
					limit = Integer.parseInt(countParameter);
				}
				String coreName = request.getParameter(SOLR_CORE_NAME);
				if (coreName == null || coreName.length() == 0) {
					return;
				}
				String serverURL = request.getParameter(SOLR_SERVER_URL);
				if (coreName != null) {
					
					String schema = SolrSearchConfigurationRegistry.getReadSchema();
					SolrServer server = SolrSearchConfigurationRegistry.getInstance()
						.getServer(coreName, SolrSearchServiceConstants.INDEX_NAME_CATALOG_ENTRY, schema);
					if (server != null) {
						String lowerCaseTerm = term.toLowerCase();

						SolrQuery query = new SolrQuery();
						query.setQueryType(TERM_QUERY_TYPE);
						query.setTerms(true);
						query.setTermsLimit(limit);
						query.setTermsSortString(TermsParams.TERMS_SORT_COUNT);
						query.setTermsPrefix(lowerCaseTerm);
						query.addTermsField(TERMS_FIELD);
						QueryRequest termReq = new QueryRequest(query);
						termReq.setMethod(SolrRequest.METHOD.POST);
						List<Term> terms = termReq.process(server).getTermsResponse().getTerms(TERMS_FIELD);

						pageContext.setAttribute("terms", terms);
						pageContext.setAttribute("showHeader", request.getParameter(PARAM_SHOWHEADER));
						pageContext.setAttribute("lowerCaseSearchTerm", lowerCaseTerm);
					
					}
				}
			}
		}
%>

<c:if test="${fn:length(terms) > 0}"> 
<%-- Start showing the results --%>
<div id='suggestedKeywordResults'>
	<c:if test="${showHeader}">
		<div id='suggestedKeywordsHeader' class='heading'>
			<span id="suggest_keywords_ACCE_Label"><c:out value="${suggestedKeyWords}"/></span>
		</div>
	</c:if>
	<div class='list_section'><ul title="${suggestedKeyWords}" role='list' aria-labelledby="suggest_keywords_ACCE_Label">
		<c:forEach items="${terms}" var="resultTerm" varStatus="status">
			<c:set var="result" value="${resultTerm.term}"/>
			<c:set var="resultInLowerCase" value="${fn:toLowerCase(result)}"/>
			<li id='suggestionItem_${status.index}' role='listitem' tabindex='-1'>
				<a role='listitem' href='#' onmouseout="this.className=''"
				onmouseover='SearchJS.enableAutoSelect("${status.index}");' onclick='SearchJS.selectAutoSuggest(this.title); return false;' title="${result}"
				id='autoSelectOption_${status.index}'>
					<%-- Highlight the search term in the result --%>
					<c:out value="${fn:substringBefore(result,lowerCaseSearchTerm)}"/><span class='highlight'><c:out value="${WCParam.term}"/></span><c:out value="${fn:substringAfter(result,lowerCaseSearchTerm)}"/>
				</a>
			</li>
		</c:forEach>
	</ul></div>
	<input type='hidden' id='autoSuggestOriginalTerm' value='${WCParam.term}'/>
	<input type='hidden' id='dynamicAutoSuggestTotalResults' value="${fn:length(terms)}"/>
</div>
</c:if>

<!-- END AutoSuggestSerialize.jsp -->