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

	<wcf:url var="SiteMapURL" patternName="SitemapURL" value="SiteMap">
		<wcf:param name="urlLangId" value="${param.urlLangId}" />
		<wcf:param name="storeId"   value="${param.storeId}"  />
		<wcf:param name="catalogId" value="${param.catalogId}"/>
		<wcf:param name="langId" value="${param.langId}" />
	</wcf:url>
	
	<%-- Get the category hierarchy upto 2 levels --%>
	<wcbase:useBean id="newcatalog" classname="com.ibm.commerce.catalog.beans.CategoryHierarchyDataBean">
		<c:set value="${param.catalogId}" target="${newcatalog}" property="catalogId"/>	
		<c:set value="3" target="${newcatalog}" property="catalogLevelNumber"/>	
	</wcbase:useBean>
	
	<c:set var="numTopCat" value="${fn:length(newcatalog.categoryHierarchy)}"/>
	<c:set var="categoryHierarchy" value="${newcatalog.categoryHierarchy}"/>

	<%-- Set the number of sub-categories to be displayed per column in the menu --%>
	<c:set var="numSubCatPerColumn" value="9"/>
	<c:set var="maxColumn" value="3"/>
	<c:set var="numOfTopCategoryToDisplay" value="15"/>
	 
	 <%-- This list will contain all the data to be displayed in the department widger
	      The List contains the Top category name, Top Category URL,
		  List of sub-categories and their corresponding URL
	 --%>
	 <wcf:useBean var="fullCategoryList" classname="java.util.ArrayList" scope="request"/>

	 <c:forEach var="topCategory" items="${categoryHierarchy}" varStatus="status">

			 <wcf:useBean var="categoryMappingList" classname="java.util.ArrayList"/>
			 <wcf:useBean var="subCategoryNameList" classname="java.util.ArrayList"/>
			 <wcf:useBean var="subCategoryURLList" classname="java.util.ArrayList"/>
			
			<wcf:url var="CategoryDisplayURL" patternName="CanonicalCategoryURL" value="Category3">
				<wcf:param name="langId" value="${param.langId}" />
				<wcf:param name="storeId" value="${param.storeId}" />
				<wcf:param name="catalogId" value="${param.catalogId}" />				
				<wcf:param name="categoryId" value="${topCategory.categoryId}" />
				<wcf:param name="pageView" value="${env_defaultPageView}" />
				<wcf:param name="beginIndex" value="0" />
				<wcf:param name="urlLangId" value="${param.urlLangId}" />
			</wcf:url>
			
			 <%-- Get the list of all sub categories and build their corresponding URL --%>
			<c:set var="subTopCategoryList" value="${topCategory.directSubCategories}" />
			
			<wcf:useBean var="fullNextLevelCategoryList" classname="java.util.ArrayList"/>
			
			<c:forEach var="subTopCategory" items="${subTopCategoryList}" varStatus="status2">
			
				<wcf:useBean var="nextLevelCategoryMappingList" classname="java.util.ArrayList"/>
				<wcf:useBean var="nextLevelCategoryNameList" classname="java.util.ArrayList"/>
				<wcf:useBean var="nextLevelCategoryURLList" classname="java.util.ArrayList"/>
				
				<wcf:set target="${subCategoryNameList}" value="${subTopCategory.description.name}"/>
				<wcf:url var="subTopCategoryDisplayUrl" patternName="CategoryURL" value="Category3">
					<wcf:param name="langId" value="${param.langId}"/>
					<wcf:param name="storeId" value="${param.storeId}"/>
					<wcf:param name="catalogId" value="${param.catalogId}"/>
					<wcf:param name="pageView" value="${env_defaultPageView}"/>
					<wcf:param name="beginIndex" value="0"/>
					<wcf:param name="sType" value="SimpleSearch"/>
					<wcf:param name="categoryId" value="${subTopCategory.categoryId}"/>
					<wcf:param name="resultCatEntryType" value="${WCParam.resultCatEntryType}"/>
					<wcf:param name="showResultsPage" value="true"/>
					<wcf:param name="urlLangId" value="${param.urlLangId}" />
					<wcf:param name="top_category" value="${topCategory.categoryId}" />
				</wcf:url>
				<wcf:set target="${subCategoryURLList}" value="${subTopCategoryDisplayUrl}"/>
								
				
					<c:set var="nextLevelCategoryList" value="${subTopCategory.directSubCategories}" />
						
					<c:forEach var="nextLevelCategory" items="${nextLevelCategoryList}" varStatus="status3">
					
					
						<wcf:set target="${nextLevelCategoryNameList}" value="${nextLevelCategory.description.name}"/>
						<wcf:url var="nextLevelCategoryDisplayUrl" patternName="CategoryURLWithParentCategory" value="Category3">
							<wcf:param name="langId" value="${param.langId}"/>
							<wcf:param name="storeId" value="${param.storeId}"/>
							<wcf:param name="catalogId" value="${param.catalogId}"/>
							<wcf:param name="pageView" value="${env_defaultPageView}"/>
							<wcf:param name="beginIndex" value="0"/>
							<wcf:param name="categoryId" value="${nextLevelCategory.categoryId}"/>
							<wcf:param name="parent_category_rn" value="${subTopCategory.categoryId}" />
							<wcf:param name="top_category" value="${topCategory.categoryId}" />
							<wcf:param name="urlLangId" value="${param.urlLangId}" />
						</wcf:url>
						<wcf:set target="${nextLevelCategoryURLList}" value="${nextLevelCategoryDisplayUrl}"/>
					</c:forEach>
					
				<wcf:set target="${nextLevelCategoryMappingList}" value="${subTopCategory.description.name}" />
				<wcf:set target="${nextLevelCategoryMappingList}" value="${subTopCategoryDisplayUrl}" />
				<wcf:set target="${nextLevelCategoryMappingList}" value="${nextLevelCategoryNameList}" />
				<wcf:set target="${nextLevelCategoryMappingList}" value="${nextLevelCategoryURLList}" />
				
				<wcf:set target="${fullNextLevelCategoryList}" value="${nextLevelCategoryMappingList}" />		
			
				<c:remove var="nextLevelCategoryNameList"/>
				<c:remove var="nextLevelCategoryURLList"/>
				<c:remove var="nextLevelCategoryMappingList"/>
				
				
			</c:forEach>
			
			
			<wcf:set target="${categoryMappingList}" value="${topCategory.description.name}" />
			<wcf:set target="${categoryMappingList}" value="${CategoryDisplayURL}" />
			<wcf:set target="${categoryMappingList}" value="${subCategoryNameList}" />
			<wcf:set target="${categoryMappingList}" value="${subCategoryURLList}" />
			<wcf:set target="${categoryMappingList}" value="${fullNextLevelCategoryList}" />
			<wcf:set target="${categoryMappingList}" value="${topCategory.categoryId}" />
			
			<wcf:set target="${fullCategoryList}" value="${categoryMappingList}" />		
			
			<c:remove var="fullNextLevelCategoryList"/>
			<c:remove var="subCategoryNameList"/>
			<c:remove var="subCategoryURLList"/>
			<c:remove var="categoryMappingList"/>

	 </c:forEach>
