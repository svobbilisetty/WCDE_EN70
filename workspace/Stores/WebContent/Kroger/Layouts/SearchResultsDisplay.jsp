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

<!-- BEGIN SearchResultsDisplay.jsp -->

<%@ taglib uri="http://commerce.ibm.com/coremetrics"  prefix="cm" %>
<%@include file="../Common/EnvironmentSetup.jspf" %>
<%@include file="../Common/CommonJSToInclude.jspf" %>
<%@include file="../Common/nocache.jspf" %>

<%-- 
	SearchSetup.jspf file behaves like a singleton instance and will be included only once while processing a request.. 
	It is usually included in LeftNavigation component.
--%>
<%@include file="../Common/SearchSetup.jspf" %>

<%-- If we have only one search result, then redirect shopper to the page directly instead of showing the results --%>
<c:choose>
	<c:when test="${totalContentCount == 0 && totalCount == 1 && !searchMissed && empty WCParam.categoryId && empty WCParam.manufacturer}">
		<c:forEach var="breadcrumb" items="${globalbreadcrumbs.breadCrumbTrailEntryView}">
			<c:if test="${breadcrumb.type_ == 'FACET_ENTRY_CATEGORY'}">
				<c:if test="${empty searchTopCategoryId}">
					<c:set var="searchTopCategoryId" value="${breadcrumb.value}" scope="request"/>
				</c:if>
				<c:set var="searchParentCategoryId" value="${breadcrumb.value}" scope="request"/>
			</c:if>
		</c:forEach>

		<%-- Global Results will contain only one element --%>
		<c:forEach var="catEntry" items="${globalresults}" varStatus="status">
			<c:set var="catEntryIdentifier" value="${catEntry.uniqueID}"/>
		</c:forEach>

		<c:choose>
			<%-- Use the context parameters if they are available; usually in a subcategory --%>
			<c:when test="${!empty searchParentCategoryId && !empty searchTopCategoryId}">
				<%-- both parent and top category are present.. display full product URL --%>
				<c:set var="parent_category_rn" value="${searchTopCategoryId}" />
				<c:set var="top_category" value="${searchTopCategoryId}" />
				<c:set var="categoryId" value="${searchParentCategoryId}" />
				<c:set var="patternName" value="ProductURLWithParentAndTopCategory"/>
			</c:when>
			<c:when test="${!empty searchParentCategoryId}">
				<%-- parent category is not empty..use product URL with parent category --%>
				<c:set var="parent_category_rn" value="${searchParentCategoryId}" />
				<c:set var="top_category" value="${searchTopCategoryId}" />
				<c:set var="categoryId" value="${WCParam.categoryId}" />
				<c:set var="patternName" value="ProductURLWithParentCategory"/>
			</c:when>
			<%-- In a top category; use top category parameters --%>
			<c:when test="${WCParam.top == 'Y'}">
				<c:set var="parent_category_rn" value="${searchParentCategoryId}" />
				<c:set var="top_category" value="${searchTopCategoryId}" />
				<c:set var="categoryId" value="${WCParam.categoryId}" />
				<c:set var="patternName" value="ProductURLWithCategory"/>
			</c:when>
			<%-- Store front main page; usually eSpots, parents unknown --%>
			<c:otherwise>
				<c:set var="parent_category_rn" value="${searchParentCategoryId}" />
				<c:set var="top_category" value="${searchTopCategoryId}" />
				<%-- Just display productURL without any category info --%>
				<c:set var="patternName" value="ProductURL"/>
			</c:otherwise>
		</c:choose>

		<wcf:url var="catEntryDisplayUrl" patternName="${patternName}" value="Product2">
			<wcf:param name="catalogId" value="${catalogId}"/>
			<wcf:param name="storeId" value="${storeId}"/>
			<wcf:param name="productId" value="${catEntryIdentifier}"/>
			<wcf:param name="langId" value="${langId}"/>
			<wcf:param name="errorViewName" value="ProductDisplayErrorView"/>
			<wcf:param name="categoryId" value="${WCParam.categoryId}" />
			<wcf:param name="parent_category_rn" value="${searchParentCategoryId}" />
			<wcf:param name="top_category" value="${searchTopCategoryId}" />
			<wcf:param name="urlLangId" value="${urlLangId}" />
		</wcf:url>
		<%-- 
			Set redirect == true.. Since we have only one result, we will display the product page directly instead of search results page.. 
			do not do <c:redirect here.. SearchTermHistroy cookie will be updated at client browser and then redirect happens
		--%>
		<c:set var="redirect" value="true"/>
		<c:if test="${empty updatedSearchTermHistory}">
			<%-- Nothing to update in cookie.. redirect from here itself --%>
			<c:set var="redirected" value="true"/>
			<c:redirect url="${catEntryDisplayUrl}"/>
		</c:if>
	</c:when>
	<c:otherwise>
		<%-- If we are here, then we have either 0 results or more than 1 result --%>
		<c:set var="pageView" value="${WCParam.pageView}" scope="request"/>
		<c:if test="${empty pageView}" >
			<c:set var="pageView" value="${env_defaultPageView}" scope="request"/>
		</c:if>


		<%-- Get SEO data and canonical URL --%>
		<wcf:url var="CategoryDisplayURL" patternName="CanonicalCategoryURL" value="Category3">
			<wcf:param name="langId" value="${langId}" />
			<wcf:param name="storeId" value="${storeId}" />
			<wcf:param name="catalogId" value="${catalogId}" />
			<wcf:param name="categoryId" value="${WCParam.categoryId}" />	
			<wcf:param name="urlLangId" value="${urlLangId}" />							
		</wcf:url>


		<c:set var="seoTitle"> <fmt:message key="TITLE_SEARCH_RESULTS"/> </c:set>
		<%-- For search results, we dont have metaDescription and metaKeyword --%>
		<c:set var="metaDescription" value=""/>
		<c:set var="metaKeyword" value=""/>

		<wcf:url var="CategoryNavigationResultsViewURL" value="CategoryNavigationResultsView" type="Ajax">
			<wcf:param name="langId" value="${langId}"/>
			<wcf:param name="storeId" value="${storeId}"/>
			<wcf:param name="catalogId" value="${catalogId}"/>
			<wcf:param name="pageSize" value="${pageSize}"/>
			<wcf:param name="sType" value="SimpleSearch"/>						
			<wcf:param name="categoryId" value="${WCParam.categoryId}"/>		
			<wcf:param name="searchType" value="${WCParam.searchType}"/>	
			<wcf:param name="metaData" value="${metaData}"/>	
			<wcf:param name="resultCatEntryType" value="${WCParam.resultCatEntryType}"/>	
			<wcf:param name="filterFacet" value="${WCParam.filterFacet}"/>
			<wcf:param name="manufacturer" value="${WCParam.manufacturer}"/>
			<wcf:param name="searchTermScope" value="${WCParam.searchTermScope}"/>
			<wcf:param name="filterTerm" value="${WCParam.filterTerm}" />
			<wcf:param name="filterType" value="${WCParam.filterType}" />
			<wcf:param name="advancedSearch" value="${WCParam.advancedSearch}"/>
			<wcf:param name="searchForContent" value="false"/>
		</wcf:url>

		<wcf:url var="CategoryNavigationResultsViewContentURL" value="CategoryNavigationResultsContentView" type="Ajax">
			<wcf:param name="langId" value="${langId}"/>
			<wcf:param name="storeId" value="${storeId}"/>
			<wcf:param name="catalogId" value="${catalogId}"/>
			<wcf:param name="pageSize" value="${pageSize}"/>
			<wcf:param name="sType" value="SimpleSearch"/>						
			<wcf:param name="categoryId" value="${WCParam.categoryId}"/>		
			<wcf:param name="searchType" value="${WCParam.searchType}"/>	
			<wcf:param name="metaData" value="${metaData}"/>	
			<wcf:param name="resultCatEntryType" value="${WCParam.resultCatEntryType}"/>	
			<wcf:param name="filterFacet" value="${WCParam.filterFacet}"/>
			<wcf:param name="manufacturer" value="${WCParam.manufacturer}"/>
			<wcf:param name="searchTermScope" value="${WCParam.searchTermScope}"/>
			<wcf:param name="filterTerm" value="${WCParam.filterTerm}" />
			<wcf:param name="filterType" value="${WCParam.filterType}" />
			<wcf:param name="advancedSearch" value="${WCParam.advancedSearch}"/>
		</wcf:url>
	</c:otherwise>
</c:choose>
	<c:if test="${!redirected}">

		<html xmlns:wairole="http://www.w3.org/2005/01/wai-rdf/GUIRoleTaxonomy#"
		xmlns:waistate="http://www.w3.org/2005/07/aaa" lang="${shortLocale}" xml:lang="${shortLocale}">
			<head>
			
				<title><c:out value="${seoTitle}"/></title>
				<meta name="description" content="<c:out value="${metaDescription}"/>"/>
				<meta name="keyword" content="<c:out value="${metaKeyword}"/>"/>
				<link rel="canonical" href="<c:out value="${CategoryDisplayURL}"/>" />
				
				<!--Main Stylesheet for browser -->
				<link rel="stylesheet" href="${jspStoreImgDir}${env_vfileStylesheet}" type="text/css" media="screen"/>
				<!-- Style sheet for print -->
				<link rel="stylesheet" href="${jspStoreImgDir}${env_vfileStylesheetprint}" type="text/css" media="print"/>

				<!-- Include script files -->
				<script type="text/javascript" src="${jsAssetsDir}javascript/StoreCommonUtilities.js"></script>
				<script type="text/javascript" src="${jsAssetsDir}javascript/Widgets/Search.js"></script>
				<script type="text/javascript" src="${jsAssetsDir}javascript/CommonContextsDeclarations.js"></script>
				<script type="text/javascript" src="${jsAssetsDir}javascript/CommonControllersDeclaration.js"></script>
				<script type="text/javascript" src="${jsAssetsDir}javascript/Widgets/ShoppingList/ShoppingList.js"></script>
				<script type="text/javascript" src="${jsAssetsDir}javascript/Widgets/ShoppingList/ShoppingListServicesDeclaration.js"></script>
				<script type="text/javascript" src="${jsAssetsDir}javascript/Common/ShoppingActionsServicesDeclaration.js"></script>
				<script type="text/javascript" src="${jsAssetsDir}javascript/Common/ShoppingActions.js"></script>
				<script type="text/javascript" src="${jsAssetsDir}javascript/Widgets/MiniShopCartDisplay/MiniShopCartDisplay.js"></script>
				<script type="text/javascript" src="${jsAssetsDir}javascript/Widgets/Department/Department.js"></script>
				<script type="text/javascript" src="${jsAssetsDir}javascript/Widgets/QuickInfo/QuickInfo.js"></script>
				<script type="text/javascript" src="${jsAssetsDir}javascript/Layouts/SearchBasedNavigationDisplay.js"></script>
				<script type="text/javascript" src="${jsAssetsDir}javascript/Widgets/ESpot/ProductRecommendation.js"></script>
				<input id="searchBoxText" name="searchBoxText" type="hidden" value="<c:out value='${WCParam.searchTerm}'/>"/>
				<c:choose>
					<c:when test="${empty redirect}">
						<script type="text/javascript">
							dojo.addOnLoad(function() { 
								shoppingActionsServicesDeclarationJS.setCommonParameters('${langId}','${storeId}','${catalogId}');
								<c:if test="${!empty updatedSearchTermHistory}">
									SearchJS.updateSearchTermHistoryCookie("<c:out value='${updatedSearchTermHistory}'/>");										
								</c:if>
								dojo.byId("SimpleSearchForm_SearchTerm").className = "search_input";
								dojo.byId("SimpleSearchForm_SearchTerm").value = document.getElementById("searchBoxText").value;
								});
						</script>
						<flow:ifEnabled feature="Analytics">
							<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Analytics.js"/>"></script>
							<script type="text/javascript">
							  dojo.addOnLoad(function() {
									analyticsJS.storeId=<c:out value="${storeId}"/>;
									analyticsJS.catalogId=<c:out value="${catalogId}"/>
							//		analyticsJS.loadMiniShopCartHandler();
									analyticsJS.loadPagingHandler();
									analyticsJS.loadSearchResultHandler("catalogSearchResultDisplay_Controller","catalog_search_result_information", true, "Advanced_Search_Form_div");
								});

							</script>
						</flow:ifEnabled>
					</c:when>
					<c:otherwise>
						<%--- Redirect is needed.... OnLoad,update the searchTermHistory and redirect --%>
						<script type="text/javascript">
							dojo.addOnLoad(function() { 
									SearchJS.updateSearchTermHistoryCookieAndRedirect("<c:out value='${updatedSearchTermHistory}'/>", "${catEntryDisplayUrl}");										
							});
						</script>
					</c:otherwise>
				</c:choose>
				

			</head>
				
<c:if test="${empty redirect}">
			<body>

				<%-- This file includes the progressBar mark-up and success/error message display markup --%>
				<%@ include file="../Common/CommonJSPFToInclude.jspf"%>

				<script type="text/javascript">
					<!-- Initializes the undo stack. This must be called from a <script>  block that lives inside the <body> tag to prevent bugs on IE. -->
					dojo.require("dojo.back");
					dojo.back.init();
					dojo.addOnLoad(function(){
						_originalTotalContentCount = <c:out value="${totalContentCount}"/>;
						SearchBasedNavigationDisplayJS.init('${CategoryNavigationResultsViewURL}');
						SearchBasedNavigationDisplayJS.initContentUrl('${CategoryNavigationResultsViewContentURL}');
						SearchBasedNavigationDisplayJS.updateContextProperties('searchBasedNavigation_context',{'searchTerm':'<wcf:out value="${searchTerm}" escapeFormat="js"/>'});
						shoppingActionsJS.initCompare('<c:out value="${param.fromPage}"/>');
					});
				</script>

				<!-- Begin Page -->
				<c:set var="espotName" value="searchResultSpot"/>
				<c:set var="emsName" value="searchResultSpot"/>
				<div id="page">
				
					<!-- Start Content -->
					<%@ include file="../Widgets/QuickInfo/QuickInfoPopup.jspf" %>
					<%@ include file="../Widgets/ShoppingList/ItemAddedPopup.jspf" %>

					<!-- Import Header Widget -->
					<div class="header_wrapper_position" id="headerWidget">
						<%out.flush();%>
							<c:import url = "${env_jspStoreDir}Widgets/Header/Header.jsp" />
						<%out.flush();%>
					</div>
					
					<!--Start Page Content-->
					<div class="content_wrapper_position" role="main">
						<div class="content_wrapper">
							<!--For border customization -->
							<div class="content_top">
								<div class="left_border"></div>
								<div class="middle"></div>
								<div class="right_border"></div>
							</div>
							<!-- Main Content Area -->
							<div class="content_left_shadow">
								<div class="content_right_shadow">				
									<div class="main_content">
										<!-- Start Main Content -->
										
										<!-- Start Double E-Spot Container -->
										<div class="widget_double_espot_container_position">
											<div class="widget_double_espot_container">
												<c:choose>
													<c:when test="${env_fetchMarketingDetailsOnLoad}">
														<div dojoType="wc.widget.RefreshArea" id="DoubleContentAreaESpot_Widget" controllerId="DoubleContentAreaESpot_Controller">
														</div>
													</c:when>
													<c:otherwise>
														<%out.flush();%>
														<c:import url="${env_jspStoreDir}Widgets/ESpot/ContentRecommendation/ContentRecommendation.jsp">
															<c:param name="emsName" value="CatalogBanner_Content" />
															<c:param name="numberContentPerRow" value="2" />
															<c:param name="catalogId" value="${catalogId}" />
														</c:import>
														<%out.flush();%>
													</c:otherwise>
												</c:choose>
											</div>
										</div>
										<!-- End Double E-Spot Container --->	
										
										<div class="container_full_width container_margin">
											<!-- Widget Breadcrumb-->
											<div class="widget_breadcrumb_position">
												<%out.flush();%>
													<c:import url = "${env_jspStoreDir}Widgets/BreadCrumb/BreadCrumb.jsp">
														<c:param name="pageName" value="SearchPage"/>
													</c:import>
												<%out.flush();%>
											</div>
											<!-- Widget Breadcrumb -->
										</div>
																		
										<!-- Content with Left Sidebar -->
										<div class="container_content_leftsidebar container_margin_5px">
											<div class="left_column">
												<div class="widget_left_nav_position" aria-label="<fmt:message key="ARIA_LANDMARK_FILTER"/>" role="navigation">
													<%out.flush();%>
														<c:import url = "${env_jspStoreDir}Widgets/LeftNavigation/LeftNavigation.jsp" >
															<c:param name="searchBasedNavigation" value="true"/>
														</c:import>
													<%out.flush();%>												
												</div>
											</div>

											<div class="right_column">
												<%-- Start showing search results summary --%>
												<%--
													1. Display search results for original search term
													2. If search is missed (count == 0 for original search term), then display suggested keywords (both content and spell check keywords),else
													   display the break-up of products and articles + videos
													3. Display search results done for the first suggested keyword
													4. If product search results for original search term == 0 and content search for orginal search term > 1, then show
														suggested keywords for only products
													5. Show search results.
												--%>

												<!-- Widget Title Container -->
												<c:if test="${!empty originalSearchTerm}">
													<div class="widget_title_container_position">
														<div class="widget_title_container">
															<span id="search_results_msg" role="heading" aria-level="1">
																<fmt:message key = "SEARCH_RESULTS_FOR"/> <span class="black">"<c:out value='${WCParam.searchTerm}'/>"</span>
																(&rlm;<span id="searchTotalCount"><fmt:message key = "{0}_matches"><fmt:param value="${originalTotalSearchCount}"/></fmt:message></span>)
															</span>
														</div>
													</div>
												</c:if>
												
												<div class="widget_tall_double_espot_position">
													<div class="widget_tall_double_espot">
														<c:choose>
															<c:when test="${env_fetchMarketingDetailsOnLoad}">
																<div dojoType="wc.widget.RefreshArea" id="TallDoubleContentAreaESpot_Widget" controllerId="TallDoubleContentAreaESpot_Controller">
																</div>
															</c:when>
															<c:otherwise>
																<%out.flush();%>
																	<c:import url="${env_jspStoreDir}Widgets/ESpot/ContentRecommendation/ContentRecommendation.jsp">
																		<c:param name="emsName" value="SearchResults_Content" />
																		<c:param name="numberContentPerRow" value="2" />
																		<c:param name="catalogId" value="${catalogId}" />																		
																	</c:import>
																<%out.flush();%>
															</c:otherwise>
														</c:choose>
													</div>											
												</div>
												
												<%-- Show summary if the original search term produced results --%>
												<c:if test="${!empty spellcheck && totalCount == 0 && totalSearchCount > 0}">
													<div class="widget_search_results_position">
														<div class="widget_search_results">
															<%-- 
																We have few articles and videos in the search results, but 0 products.
																Show some suggested keywords for the products. 
															--%>
															<div class="results_description">
																<fmt:message key = "NO_PRODUCTS_FOUND"/>
															</div>
															<div class="clear_float"></div>
															<div class="item_spacer_10px"></div>
															<div class="item_spacer_10px"></div>
														</div>
													</div>
												</c:if>
												<!-- End Widget Title Container -->

												<%-- Show the summary if original search term ended with 0 results --%>
												<c:if test="${originalTotalSearchCount == 0}">
													<wcf:url var="SpellCheckSearchDisplayViewURL" value="SearchDisplay" type="Ajax">
														<wcf:param name="langId" value="${langId}"/>
														<wcf:param name="storeId" value="${storeId}"/>
														<wcf:param name="catalogId" value="${catalogId}"/>		
														<wcf:param name="pageView" value="${pageView}"/>
														<wcf:param name="beginIndex" value="0"/>
														<wcf:param name="pageSize" value="${WCParam.pageSize}"/>
														<wcf:param name="sType" value="${WCParam.sType}"/>						
														<wcf:param name="manufacturer" value="${WCParam.manufacturer}" />
														<wcf:param name="minPrice" value="${WCParam.minPrice}" />
														<wcf:param name="maxPrice" value="${WCParam.maxPrice}" />
														<wcf:param name="resultCatEntryType" value="${WCParam.resultCatEntryType}"/>						
														<wcf:param name="showResultsPage" value="true"/>				  
														<wcf:param name="orderBy" value="${WCParam.orderBy}"/>
														<wcf:param name="searchSource" value="Q"/>
														<wcf:param name="searchTermScope" value="${WCParam.searchTermScope}"/>
													</wcf:url>

													<%-- Search keyword didnt return any results --%>
													<div class="widget_search_results_position">
														<div class="widget_search_results emptySearchResultSpot searchResultSpot">
														<c:if test="${env_inPreview && !env_storePreviewLink}">
															<div class="caption" style="display:none"></div>
															<div class="ESpotInfo">
																<a id="SearchResultsDisplay_Empty_Info_Link" href="javascript:void(0)" onclick="showESpotInfoPopup('ESpotInfo_popup_<wcf:out escapeFormat="js" value="${espotName}"/>'); return false;">
																<fmt:message bundle='${previewText}' key='ShowInformation'/>
																</a>
															</div>
														</c:if>
															<div class="results_description">
																<fmt:message key = "SORRY_MESSAGE_{0}">
																	<c:choose>
																		<c:when test="${empty originalSearchTerm && !empty WCParam.manufacturer}">
																			<fmt:param value="${fn:escapeXml(WCParam.manufacturer)}"/>
																		</c:when>
																		<c:otherwise>
																			<fmt:param value="${fn:escapeXml(WCParam.searchTerm)}"/>
																		</c:otherwise>
																	</c:choose>
																</fmt:message>
															</div>
			
<flow:ifEnabled feature="Analytics">
		<c:set var="singleQuote" value="'"/>
		<c:set var="escapedSingleQuote" value="\\\\'"/>
		<c:set var="doubleQuote" value="\""/>
		<c:set var="escapedDoubleQuote" value="\\\\\""/>

		<c:remove var="analyticsEscapedFacetAttributes"/>
		<c:set var="analyticsEscapedFacetAttributes" value="${fn:replace(analyticsFacetAttributes, singleQuote, escapedSingleQuote)}"/>
		<c:set var="analyticsEscapedFacetAttributes" value="${fn:replace(analyticsEscapedFacetAttributes, doubleQuote, escapedDoubleQuote)}"/>

		<c:remove var="analyticsEscapedSearchTerm"/>
		<c:set var="analyticsEscapedSearchTerm" value="${fn:replace(originalSearchTerm, singleQuote, escapedSingleQuote)}"/>
		<c:set var="analyticsEscapedSearchTerm" value="${fn:replace(analyticsEscapedSearchTerm, doubleQuote, escapedDoubleQuote)}"/>
		<div id="catalog_search_result_information" style="visibility:hidden">
			{	searchResult: {
				pageSize: <c:out value="${pageSize}"/>, 
				searchTerms: '<c:out value="${analyticsEscapedSearchTerm}"/>', 
			 	totalPageNumber: <c:out value="0"/>, 
			  	totalResultCount: <c:out value="0"/>, 
			  	currentPageNumber:<c:out value="0"/>,
				attributes: "<c:out value="${analyticsEscapedFacetAttributes}"/>"
				}
			}
			
			
	</div>
	
	
	</flow:ifEnabled>
															<c:if test="${!(empty spellcheck && empty contentspellcheck)}">
																<%-- Help shopper with some suggestions --%>
																<div class="clear_float"></div>
																<div class="item_spacer_10px"></div>
																<div class="item_spacer_10px"></div>
																<span class="black"><fmt:message key="DID_YOU_MEAN"/>&#58;&nbsp;&nbsp;</span>
																<%-- Merge spellcheck and contentspellcheck suggestions and remove duplicates, while maintaining the order --%>
																<wcf:useBean var="suggesstedKeywordsMap" classname="java.util.LinkedHashSet"/>
																<c:forEach var="alternative" items="${spellcheck}">
																	<wcf:set target="${suggesstedKeywordsMap}" key="${alternative}" value="${alternative}" />
																</c:forEach>
																<c:forEach var="alternative" items="${contentspellcheck}">
																	<wcf:set target="${suggesstedKeywordsMap}" key="${alternative}" value="${alternative}" />
																</c:forEach>
																<c:forEach items="${suggesstedKeywordsMap}" varStatus="aStatus">
																	<span><a href="${SpellCheckSearchDisplayViewURL}&searchTerm=<c:out value='${aStatus.current}'/>" class="result"><c:out value="${aStatus.current}"/></a></span>
																	<span>&nbsp;&nbsp;</span>
																</c:forEach>
															</c:if>
															<%-- We did some search ourselves on the first suggested term.. Show the summary --%>
															<div class="clear_float"></div>
															<div class="item_spacer_10px"></div>
															<div class="item_spacer_10px"></div>
															<span>
																<fmt:message key = "SEARCH_RESULTS_FOR"/>
																<span class="black">
																	<c:choose>
																		<c:when test="${empty originalSearchTerm && !empty WCParam.manufacturer}">
																			"<c:out value="${WCParam.manufacturer}"/>"
																		</c:when>
																		<c:otherwise>
																			"<c:out value="${searchTerm}"/>"
																		</c:otherwise>
																	</c:choose>
																</span>
																(<fmt:message key = "{0}_matches">
																	<fmt:param value="${totalSearchCount}"/>
																</fmt:message>)
															</span>
															<div class="clear_float"></div>
															<div class="item_spacer_10px"></div>
														</div>
													</div>
												</c:if>

												<c:set var="showTabs" value="${totalCount > 0 && totalContentCount > 0}"/>
												<c:if test="${showTabs}">
													<div class="widget_search_tab_wrapper" role="tablist">
														<div class="tab_header tab_header_double">
															<a onfocus="SearchJS.focusSearchResultTab('productsResultTab');" onblur="SearchJS.onBlurSearchResultTab('productsResultTab');" id="productsResultTab_wrapper" role="tab" aria-setsize="2" aria-posinset="1" aria-selected="true" href="javascript: SearchJS.selectSearchResultsTab('products');" onkeydown="SearchJS.selectSearchResultsTabWithKeyboard('products', event);"><div id="productsResultTab" class="tab_container active_tab"><fmt:message key="PRODUCTS"/> (<span id="productTotalCount"><c:out value="${totalCount}"/></span>)</div></a>
															<div class="tab_spacer"></div>
															<a onfocus="SearchJS.focusSearchResultTab('contentsResultTab');" onblur="SearchJS.onBlurSearchResultTab('contentsResultTab');" id="contentsResultTab_wrapper" role="tab" aria-setsize="2" aria-posinset="2" href="javascript: SearchJS.selectSearchResultsTab('contents');" onkeydown="SearchJS.selectSearchResultsTabWithKeyboard('contents', event);"><div id="contentsResultTab" class="tab_container inactive_tab"><fmt:message key="ARTICLES_AND_VIDEOS"/> (<c:out value="${totalContentCount}"/>)</div></a>
															<div class="tab_end"></div>
															<div class="clear"></div>
														</div>
													</div>
												</c:if>
					
												<%-- Finally show the product results --%>
												<c:if test="${totalCount > 0}">
													<div id="Search_Area_div" class="searchResultSpot">
														<c:if test="${env_inPreview && !env_storePreviewLink}">
															<div class="caption" style="display:none"></div>
															<div class="ESpotInfo">
																<a id="SearchResultsDisplay_Products_Info_Link" href="javascript:void(0)" onclick="showESpotInfoPopup('ESpotInfo_popup_<wcf:out escapeFormat="js" value="${espotName}"/>'); return false;">
																<fmt:message bundle='${previewText}' key='ShowInformation'/>
																</a>
															</div>
														</c:if>
														<div <c:if test="${showTabs}">id="productsSearchBasedNavigationWidget" class="tabbed_content"</c:if>>
															<span class="spanacce" id="searchBasedNavigation_widget_ACCE_Label"><fmt:message key="ACCE_Region_Product_List"/></span>
															<div dojoType="wc.widget.RefreshArea" widgetId="searchBasedNavigation_widget" id="searchBasedNavigation_widget" controllerId="searchBasedNavigation_controller" ariaMessage="<fmt:message key="ACCE_Status_Product_List_Updated"/>" ariaLiveId="${ariaMessageNode}" role="region" aria-labelledby="searchBasedNavigation_widget_ACCE_Label">
																<% out.flush(); %>
																<c:import url="${env_jspStoreDir}Layouts/CategoryNavigationResults.jsp"/>
																<% out.flush(); %>
															</div>
														</div>
													</div>
												</c:if>
												
												<%-- And also content results.. --%>
												<c:if test="${totalContentCount > 0}">
													<div id="Search_Area_div2" class="searchResultSpot">
														<c:if test="${env_inPreview && !env_storePreviewLink}">
															<div class="caption" style="display:none"></div>
															<div class="ESpotInfo">
																<a id="SearchResultsDisplay_Contents_Info_Link" href="javascript:void(0)" onclick="showESpotInfoPopup('ESpotInfo_popup_<wcf:out escapeFormat="js" value="${espotName}"/>'); return false;">
																<fmt:message bundle='${previewText}' key='ShowInformation'/>
																</a>
															</div>
														</c:if>
														<div <c:if test="${showTabs}">id="contentsSearchBasedNavigationWidget" class="tabbed_content"</c:if>>
															<span class="spanacce" id="searchBasedNavigation_content_widget_ACCE_Label"><fmt:message key="ACCE_Region_Content_List"/></span>
															<div dojoType="wc.widget.RefreshArea" widgetId="searchBasedNavigation_content_widget" id="searchBasedNavigation_content_widget" controllerId="searchBasedNavigation_content_controller" ariaMessage="<fmt:message key="ACCE_Status_Content_List_Updated"/>" ariaLiveId="${ariaMessageNode}" role="region" aria-labelledby="searchBasedNavigation_content_widget_ACCE_Label">
																<% out.flush(); %>
																<c:import url="${env_jspStoreDir}Layouts/CategoryNavigationResults_Content.jsp"/>
																<% out.flush(); %>
															</div>
														</div>
													</div>
												</c:if>			

												<wcf:url var="ProdRecommendationRefreshViewURL" value="ProductRecommendationView" type="Ajax">
													<wcf:param name="emsName" value="SearchResults_CatEntries" />
													<wcf:param name="pageSize" value="4" />
													<wcf:param name="commandName" value="SearchDisplay" />
													<wcf:param name="pageView" value="miniGrid" />
													<wcf:param name="langId" value="${langId}"/>
													<wcf:param name="storeId" value="${storeId}"/>
													<wcf:param name="catalogId" value="${catalogId}" />
													<wcf:param name="categoryId" value="${WCParam.categoryId}" />
													<wcf:param name="urlLangId" value="${urlLangId}" />
												</wcf:url>
												<script type="text/javascript">
													dojo.addOnLoad(function(){
														wc.render.getRefreshControllerById('prodRecommendationRefresh_controller').url = '${ProdRecommendationRefreshViewURL}';
													});
												</script>
												<div class="widget_product_listing_position">
													<c:if test="${!env_fetchMarketingDetailsOnLoad}">
														<div dojoType="wc.widget.RefreshArea" id="SearchProductRecommendationESpot_Widget" controllerId="prodRecommendationRefresh_controller">
														<% out.flush(); %>
														<c:import url="${env_jspStoreDir}Widgets/ESpot/ProductRecommendation/ProductRecommendation.jsp">
															<c:param name="pageSize" value="4" />
															<c:param name="emsName" value="SearchResults_CatEntries" />
															<c:param name="errorViewName" value="AjaxOrderItemDisplayView" />
															<c:param name="pageView" value="miniGrid"/>														
														</c:import>
														<% out.flush(); %>
														</div>
													</c:if>
											</div>
											
											</div>																						
											<!-- End Right Column -->
											<div class="clear_float"></div>
										</div>
										<!-- End Content With Left Sidebar -->
										
										<!-- End Main Content -->
									</div>
								</div>				
							</div>
							<!--For border customization -->
							<div class="content_bottom">
								<div class="left_border"></div>
								<div class="middle"></div>
								<div class="right_border"></div>
							</div>
						</div>
					</div>
					<!--End Page Content-->
					
				<flow:ifEnabled feature="Analytics">
					<script type="text/javascript">
						dojo.addOnLoad(function() {
							analyticsJS.registerSearchResultPageView("catalogSearchResultDisplay_Controller","catalog_search_result_information", true, "Advanced_Search_Form_div");
						});
					</script>
					
				</flow:ifEnabled>
					<!--Start Footer Content-->
					<div class="footer_wrapper_position">
						<%out.flush();%>
							<c:import url = "${env_jspStoreDir}Widgets/Footer/Footer.jsp" />
						<%out.flush();%>
					</div>
					<!--End Footer Content-->
					
					<!--Start: Contents after page load-->
					<c:if test="${env_fetchMarketingDetailsOnLoad}">
					<%out.flush();%>
						<c:import url = "${env_jspStoreDir}Widgets/PageLoadContent/PageLoadContent.jsp">
							<c:param name="doubleContentAreaESpot" value="true"/>
						</c:import>
					<%out.flush();%>
					</c:if>
					<!--End: Contents after page load-->
				</div>
				
			</body>
</c:if>

<!-- END SearchResultsDisplay.jsp -->
		</html>

</c:if>
