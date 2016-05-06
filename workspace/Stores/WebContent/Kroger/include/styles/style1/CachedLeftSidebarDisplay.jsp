<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!-- BEGIN CachedLeftSidebarDisplay.jsp -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ include file="../../../Common/EnvironmentSetup.jspf" %>

<c:if test="${!empty catalogId }">
	<wcf:url var="AjaxBrowsingHistoryEspotDisplayURL" value="AjaxBrowsingHistoryEspotDisplay" type="Ajax">
		<wcf:param name="langId" value="${langId}" />						
		<wcf:param name="storeId" value="${WCParam.storeId}" />
		<wcf:param name="catalogId" value="${WCParam.catalogId}" />
	</wcf:url>
</c:if>	

<script type="text/javascript">
	dojo.addOnLoad(function() {
		CommonControllersDeclarationJS.setControllerURL('BrowsingHistoryController','${AjaxBrowsingHistoryEspotDisplayURL}');
	});
</script>

<c:if test="${requestScope.topCategoryPage || requestScope.categoryPage || requestScope.productPage || requestScope.compareProductPage || requestScope.sharedWishList || requestScope.fastFinder || requestScope.searchPage || requestScope.myAccountPage}">
	<c:choose>
		<%-- New skinning applies to account related pages only --%>
		<c:when test="${requestScope.myAccountPage}">
			<div class="widget_left_nav_position" id="WC_LeftSidebarDisplay_div_1" aria-label="<fmt:message key="HEADER_MY_ACCOUNT"/>" role="navigation">
				<div class="widget_left_nav" id="WC_LeftSidebarDisplay_div_2">
		</c:when>
		<c:otherwise>
			<div id="left_nav" aria-label="<fmt:message key="ARIA_LANDMARK_FILTER"/>" role="navigation">
				<div class="left_nav_container" id="WC_LeftSidebarDisplay_div_1">
					<div class="left_nav_options" id="WC_LeftSidebarDisplay_div_2">
		</c:otherwise>
	</c:choose>
	
	<c:if test="${requestScope.topCategoryPage || requestScope.categoryPage || requestScope.productPage || requestScope.compareProductPage || requestScope.sharedWishList}">
		<c:if test="${empty requestScope.searchFacets}">
			<%@ include file="../../../Snippets/ReusableObjects/CategoriesNavDisplay.jspf"%>
		</c:if>
	</c:if>
	<c:if test="${requestScope.categoryPage}">
		<flow:ifEnabled feature="CategorySubscriptions">
			<wcf:url var="AjaxCategorySubscriptionDisplayURL" value="AjaxCategorySubscriptionDisplay" type="Ajax">
				<wcf:param name="langId" value="${langId}" />						
				<wcf:param name="storeId" value="${WCParam.storeId}" />
				<wcf:param name="catalogId" value="${WCParam.catalogId}" />
				<wcf:param name="categoryId" value="${WCParam.categoryId}" />
				<wcf:param name="requestURI" value="CategoryDisplay" />
				<wcf:param name="isCategorySubsriptionDisplayURL" value="true" />
			</wcf:url>
			<div dojoType="wc.widget.RefreshArea" id="CategorySubscriptionDisplay" widgetId="CategorySubscriptionDisplay" controllerId="CategorySubscriptionController">
				<% out.flush(); %>
				<c:import url="${env_jspStoreDir}/Snippets/Catalog/CategoryDisplay/CategorySubscriptionDisplay.jsp">
					<c:param name="storeId" value="${WCParam.storeId}" />
					<c:param name="catalogId" value="${catalogId}" />
					<c:param name="langId" value="${langId}" />
				</c:import>
				<% out.flush(); %>
			</div>
			<script>
				dojo.addOnLoad(function(){
					CommonControllersDeclarationJS.setControllerURL('CategorySubscriptionController','${AjaxCategorySubscriptionDisplayURL}');
					parseWidget("CategorySubscriptionDisplay");
				});
			</script>
		</flow:ifEnabled>
	</c:if>
	
	<%@ include file="../../../Snippets/ReusableObjects/NavigationExt.jspf"%>
	<c:if test="${requestScope.myAccountPage}">
		<%@ include file="../../../Snippets/ReusableObjects/MyAccountNavDisplay.jspf" %>
	</c:if>

	<flow:ifEnabled feature="BrowsingHistory">
		<c:if test="${!requestScope.shoppingCartPage && !requestScope.pendingOrderDetailsPage && !requestScope.productPage && !requestScope.myAccountPage}">
			<div id="WC_LeftSidebarDisplay_div_5">
				<div class="browsing_history_espot" id="WC_LeftSidebarDisplay_div_6">
					<div class="espot_header" id="WC_LeftSidebarDisplay_div_7">
						<div class="left"></div>
						<div class="center"></div>
						<div class="right"></div>
						<div class="content_container">									
							<div class="content"><h2><fmt:message key="BROWSING_HISTORY" /></h2></div>
						</div>
					</div>				
					<div class="body" id="WC_LeftSidebarDisplay_div_8">
						<div dojoType="wc.widget.RefreshArea" id="browsingHistoryDisplay" widgetId="browsingHistoryDisplay" controllerId="BrowsingHistoryController">
							<div class="loadingStatusArea"></div>
						</div>
					</div>
					<div class="espot_footer" id="WC_LeftSidebarDisplay_div_9">
						<div class="left"> </div>
						<div class="center"> </div>
						<div class="right"> </div>
					</div>
				</div>	
			</div>
			
			<div class="clear_both"></div>

			<script>
				dojo.addOnLoad(function(){
					parseWidget("browsingHistoryDisplay");
					wc.render.updateContext('BrowsingHistoryContext', {'status':'load'});
				});
			</script>
		</c:if>		
	</flow:ifEnabled>				
	<c:choose>
		<%-- New skinning applies to account related pages only --%>
		<c:when test="${requestScope.myAccountPage}">
			</div>
			</div>
		</c:when>
		<c:otherwise>
			</div>
			</div>
			</div>
		</c:otherwise>
	</c:choose>
</c:if>
<!-- END CachedLeftSidebarDisplay.jsp -->
