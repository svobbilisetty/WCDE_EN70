<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2012, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%--
  *****
  * This JSP file renders the dynamic recommendations from Coremetrics Intelligent
  * Offer. The callback function io_rec_zp in wczpf.js will update the context
  * WC_IntelligentOfferESpot_context_ID_<<zoneId>>. This will call the URL
  * IntelligentOfferResultsView to update the refresh area on the page.
  * The IntelligentOfferResultsView URL is associated with this JSP page. 
  * This JSP requires the following parameters to be included on the URL:
  *   partNumbers - a comma separated list of catalog entry partnumbers 
  *                 that have been returned as recommendations from Intelligent
  *                 Offer
  *   zoneId - The ID of the Intelligent Offer zone. Any whitespace in the zone
  *            name should be removed.
  *   espotTitle - The title to display above the catalog entry recommendations.
  *                This is set up in the Intelligent Offer tool.
  *   langId - the current language ID
  *   storeId - the current store ID
  *   catalogId - the current catalog ID
  *   emsName - the name of the e-Marketing in which the recommendations are displayed
  *   mpe_id - the ID of the e-Marketing in which the recommendations are displayed. 
  *            This is used for the ClickInfo url.
  *   intv_id - the ID of the web activity which specified that Intelligent Offer
  *             recommendations should be displayed. This is used for the ClickInfo url.
  *   experimentId - the ID of the experiment which specified that Intelligent Offer
  *             recommendations should be displayed. This is used for the ClickInfo url.
  *   testElementId - the ID of the test element which specified that Intelligent Offer
  *             recommendations should be displayed. This is used for the ClickInfo url.   
  *   activityName - the name of the activity which provided the recommendation. 
  *            This is used for Analytics reporting.
  *   campaignName - the name of the campaign to which the activity belongs.
  *             This is used for Analytics reporting.
  *   experimentName - the name of the experiment which provided the recommendation. 
  *            This is used for Analytics reporting.
  *   testElementName - the name of the test element which provided the recommendation. 
  *            This is used for Analytics reporting.
  *   controlElement - is the test element which provided the recommendation a control element. 
  *            This is used for Analytics reporting.   
  * 
  * How to use this snippet?
  * This snippet is not intended to be directly included on a store page. It
  * is associated with a refresh area that will display when recommendations
  * are returned from Intelligent Offer.
  *****
--%>


<%@ include file= "../../../Common/EnvironmentSetup.jspf" %>

<c:set var="currentProductCount" value="0" />
<c:set var="emsName" value="${param.emsName}"/>

<c:set var="espotName" value="${fn:replace(emsName,' ','')}"/>
<c:set var="espotName" value="${fn:replace(espotName,'\\\\','')}"/>

<c:choose>
	<c:when test="${empty param.partNumbers}">
		<wcf:getData type="com.ibm.commerce.marketing.facade.datatypes.MarketingSpotDataType" var="marketingSpotDatas" expressionBuilder="findByMarketingSpotName">

			<%-- the name of the e-Marketing Spot --%>
			<wcf:param name="DM_EmsName" value="${emsName}" />

			<%-- do not retrieve the catalog entry SDO but obtain the catalog entry Id only --%>
			<wcf:param name="DM_ReturnCatalogEntryId" value="true" />

			<%-- Give preference to the requestparamter first and then to request attribute --%>
			<c:if test="${!empty param.productId}">
				<c:set var="productId" value="${param.productId}"/>
			</c:if>
            <c:if test="${!empty productId}">
				<wcf:param name="productId" value="${productId}" />
			</c:if>                       

		</wcf:getData>
		
		<c:forEach var="marketingSpotData" items="${marketingSpotDatas.baseMarketingSpotActivityData}">
			<c:if test='${(marketingSpotData.dataType eq "CatalogEntryId") and (!empty marketingSpotData.uniqueID) and (marketingSpotData.uniqueID ne param.mainProductId)}'>
				<c:set var="currentProductCount" value="${currentProductCount+1}" />
				<c:choose>
					<c:when test="${empty catentryIdList}">
						<c:set var="catentryIdList" value="${marketingSpotData.uniqueID}"/>
					</c:when>
					<c:otherwise>
						<c:set var="catentryIdList" value="${catentryIdList},${marketingSpotData.uniqueID}"/>
					</c:otherwise>							
				</c:choose> 	
			</c:if>
		</c:forEach>
	</c:when>
	<c:otherwise>
			<c:forTokens items="${param.partNumbers}" delims="," var="currentPartnumber" varStatus="status">
				<%-- Same product should not be displayed --%>
				<c:if test="${currentPartnumber ne param.mainPartNumber}">
					<c:set var="currentProductCount" value="${currentProductCount+1}" />
				</c:if>
			</c:forTokens>
	</c:otherwise>
</c:choose>

<c:set var="espotTitle" value="${param.espotTitle}"/>
<c:if test="${empty espotTitle}">
	<fmt:message key="ES_RECOMMENDATIONS" var="espotTitle"/>
</c:if>
<%@ include file="../include/ESpotTitle_Data.jspf"%>

<c:set var="numEntries" value="${currentProductCount}"/>

<%-- By default pagination will be enabled. If pagination is passed as false, it will be disabled. 
Page size will be set to number of entries so that the result gets displayed in single page.
Also default page size is 4, if no pageSize value is passed as param. --%>
<c:choose>
	<c:when test="${(param.pagination eq 'false') and (numEntries gt 0)}">
		<c:set var="pageSize" value="${numEntries}" />
	</c:when>
	<c:when test="${empty param.pageSize}">
		<c:set var="pageSize" value="4" />
	</c:when>
	<c:otherwise>
		<c:set var="pageSize" value="${param.pageSize}" />
	</c:otherwise>
</c:choose>

<c:set var="currentPage" value="${param.currentPage}" />
<c:if test="${empty currentPage}">
	<c:set var="currentPage" value="0" />
</c:if>

<c:if test="${currentPage < 0}">
	<c:set var="currentPage" value="0"/>
</c:if>

<c:if test="${currentPage >= (totalPages)}">
	<c:set var="currentPage" value="${totalPages-1}"/>
</c:if>

<fmt:formatNumber var="totalPages" value="${(numEntries/pageSize)+1}"/>
<c:if test="${numEntries%pageSize == 0}">
	<fmt:formatNumber var="totalPages" value="${numEntries/pageSize}"/>
	<c:if test="${totalPages == 0 && numEntries!=0}">
		<fmt:formatNumber var="totalPages" value="1"/>
	</c:if>
</c:if>
<fmt:parseNumber var="totalPages" value="${totalPages}" integerOnly="true"/>

<c:choose>
	<c:when test="${param.pageView eq 'list'}">
		<c:set var="viewMode" value="list_mode"/>
	</c:when>
	<c:otherwise>
		<c:set var="viewMode" value="grid_mode"/>
	</c:otherwise>
</c:choose>

<c:if test="${env_inPreview && !env_storePreviewLink}">	
	<%@ include file="../include/ESpotInfoPopupDisplay.jspf"%>				
	<div class="genericESpot">
	    <div class="caption" style="display:none"></div>
		<div class="ESpotInfo">
			 <a id="IntelligentOffer_InfoLink_${espotName}" href="javascript:void(0)" onclick="javascript:showESpotInfoPopup('ESpotInfo_popup_<wcf:out escapeFormat="js" value="${espotName}"/>');" title='<c:out value="${emsName}"/>'>
			 	<fmt:message bundle='${previewText}' key='ShowInformation'/>
			 </a>
		</div>
</c:if>

<c:forEach begin="${currentPage+1}" end="${totalPages}" var="pageNo">
	<c:set var="startIndex" value="1"/>
	<c:if test="${currentPage != 0}">
		<c:set var="startIndex" value="${(currentPage * pageSize) + 1}"/>
	</c:if>


	<c:set var="endIndex" value="${(currentPage + 1) * pageSize}"/>
	<c:if test="${endIndex > numEntries}">
		<c:set var="endIndex" value="${numEntries}"/>
	</c:if>
	
	<div class="widget_product_listing" id="widget_Offer_${pageNo}" <c:if test="${pageNo > 1}"> style="display:none" </c:if> >
		<c:if test="${param.showBorder eq 'true'}">
		<div class="top">
			<div class="left_border"></div>
			<div class="middle_tile"></div>
			<div class="right_border"></div>
		</div>
		<div class="middle">
			<div class="left_border">
				<div class="right_border">
		
		</c:if>
					<div class="content">
						<div class="header_bar simple_bar">
							<c:if test="${param.showHeader eq 'true'}">
								<c:set var="espotTextTitleUIPrefix">
									<div class="title">
								</c:set>
								<c:set var="espotTextTitleUISuffix">
									</div>
								</c:set>
								<%@ include file="../include/ESpotTitle_UI.jspf"%>
							</c:if>
								<c:if test="${totalPages > 1 }">
									<div class="paging_controls">
										<c:choose>
											<c:when test="${isBiDiLocale}">
												<c:if test="${currentPage != 0}">
													<a href="javaScript:setCurrentId('Offer_links_1');IntelligentOfferJS.showPrevResults('<c:out value="${pageNo}"/>');" id="Offer_links_1"
														class="right" title="<fmt:message key="ES_SHOW_PREVIOUS_OFFER_SET"/>">
														<img class="right_arrow_enabled" src="<c:out value='${jspStoreImgDir}'/>images/colors/color1/sidebar_containers/right_arrow_enabled.png" alt=""/>
													</a>
												</c:if>
												<span class="right">
													<fmt:message key="CATEGORY_RESULTS_PAGES_DISPLAYING" > 
														<fmt:param><fmt:formatNumber value="${currentPage + 1}"/></fmt:param>
														<fmt:param><fmt:formatNumber value="${totalPages}"/></fmt:param>
													</fmt:message>	
												</span>
												<c:if test="${currentPage < totalPages-1}">
													<a href="javaScript:setCurrentId('Offer_links_2');IntelligentOfferJS.showNextResults('<c:out value="${pageNo}"/>');" id="Offer_links_2"
														class="right" title="<fmt:message key="ES_SHOW_NEXT_OFFER_SET"/>">		
														<img class="left_arrow_enabled" src="<c:out value='${jspStoreImgDir}'/>images/colors/color1/sidebar_containers/left_arrow_enabled.png" alt=""/>
													</a>
												</c:if>
											</c:when>
											<c:otherwise>
												<c:if test="${currentPage != 0}">
													<a href="javaScript:setCurrentId('Offer_links_1');IntelligentOfferJS.showPrevResults('<c:out value="${pageNo}"/>');" id="Offer_links_1"
														class="left" title="<fmt:message key="ES_SHOW_PREVIOUS_OFFER_SET"/>">
														<img class="left_arrow_enabled" src="<c:out value='${jspStoreImgDir}'/>images/colors/color1/sidebar_containers/left_arrow_enabled.png" alt=""/>
													</a>
												</c:if>
												<span class="left">
													<fmt:message key="CATEGORY_RESULTS_PAGES_DISPLAYING" > 
														<fmt:param><fmt:formatNumber value="${currentPage + 1}"/></fmt:param>
														<fmt:param><fmt:formatNumber value="${totalPages}"/></fmt:param>
													</fmt:message>	
												</span>
												<c:if test="${currentPage < totalPages-1}">
													<a href="javaScript:setCurrentId('Offer_links_2');IntelligentOfferJS.showNextResults('<c:out value="${pageNo}"/>');" id="Offer_links_2"
														class="left" title="<fmt:message key="ES_SHOW_NEXT_OFFER_SET"/>">		
														<img class="right_arrow_enabled" src="<c:out value='${jspStoreImgDir}'/>images/colors/color1/sidebar_containers/right_arrow_enabled.png" alt=""/>
													</a>
												</c:if>
											</c:otherwise>
										</c:choose>
										<div class="clear_float"></div>
									</div>
								</c:if>

								<div class="clear_float"></div>
						</div>					
						<div class="product_listing_container">
							<fieldset>
								<legend><span class="spanacce"><fmt:message key='ES_PRODUCT_LISTING'/></span></legend>
								<div class="${viewMode}">
									<div class="row first_row">
										<c:choose>
											<c:when test="${!empty param.partNumbers}">
												<c:forTokens items="${param.partNumbers}" begin="${startIndex-1}" end="${endIndex-1}" delims="," var="currentPartnumber" varStatus="status">
													<%-- Same product should not be displayed --%>
													<c:if test="${currentPartnumber ne param.mainPartNumber}">
														<%out.flush();%>
															<c:import url="${env_jspStoreDir}Widgets/ESpot/IntelligentOffer/IntelligentOffer_SKU_UI.jsp">
																<c:param name="partNumber" value="${currentPartnumber}"/>
																<c:param name="count" value="${status.count}"/>
																<c:param name="pageSize" value="${pageSize}"/>
																<c:param name="pageView" value="${param.pageView}"/>
																<c:param name="showCompareBox" value="${param.showCompareBox}"/>
															</c:import>
														<%out.flush();%>
													</c:if>
												</c:forTokens>
											</c:when>
											<c:otherwise>
												<c:forTokens var="catEntryId" items="${catentryIdList}" begin="${startIndex-1}" end="${endIndex-1}" delims="," varStatus="status">
														<%out.flush();%>
															<c:import url="${env_jspStoreDir}Widgets/ESpot/IntelligentOffer/IntelligentOffer_SKU_UI.jsp">
																<c:param name="catEntryIdentifier" value="${catEntryId}"/>
																<c:param name="count" value="${status.count}"/>
																<c:param name="pageSize" value="${pageSize}"/>
																<c:param name="pageView" value="${param.pageView}"/>
																<c:param name="showCompareBox" value="${param.showCompareBox}"/>
															</c:import>
														<%out.flush();%>	
												</c:forTokens>
											</c:otherwise>
										</c:choose>
									</div>
								</div>
							</fieldset>
						</div>
					</div>
		
		<c:if test="${param.showBorder eq 'true'}">
				</div>
			</div>
		</div>
		<div class="bottom">
			<div class="left_border"></div>
			<div class="middle_tile"></div>
			<div class="right_border"></div>
		</div>
		</c:if>
	</div>
	<c:set var="currentPage" value="${currentPage+1}"/>
</c:forEach>

<c:if test="${env_inPreview && !env_storePreviewLink}">
	</div>
</c:if>
		
