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

<!-- BEGIN IntelligentOffer.jsp -->

<%@ include file= "../../../Common/EnvironmentSetup.jspf" %>

<%@include file="IntelligentOffer_Data.jspf"%>

<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Widgets/ESpot/IntelligentOffer.js"/>"></script>
 
<c:if test="${numIntelligentOffer == 0}">
	<%out.flush();%>
		<c:import url="${env_jspStoreDir}Widgets/ESpot/IntelligentOffer/IntelligentOffer_Result_UI.jsp">
			<c:param name="langId" value="${WCParam.langId}" /> 
			<c:param name="storeId" value="${WCParam.storeId}" />
			<c:param name="catalogId" value="${WCParam.catalogId}" />
			<c:param name="emsName" value="${emsName}" />							
			<c:param name="pageSize" value="${param.pageSize}"/>
			<c:param name="pagination" value="${param.pagination}"/>
			<c:param name="pageView" value="${param.pageView}"/>
			<c:param name="espotTitle" value="${espotTitle}"/>
			<c:param name="currentPage" value="${param.currentPage}"/>							           								
			<c:param name="showBorder" value="${showBorder}"/>
			<c:param name="showHeader" value="${showHeader}"/>
			<c:param name="showCompareBox" value="${showCompareBox}"/>
			<c:param name="mainProductId" value="${param.mainProductId}" />
			<c:param name="partNumber" value=""/>
		</c:import>
	<%out.flush();%>
</c:if>

<c:if test="${numIntelligentOffer != 0}">
	<script type="text/javascript">
		dojo.addOnLoad(function() { 	
			console.warn('before cmDisplayRecs');
		  cmDisplayRecs();
	  });		  
	</script>
</c:if>

<!-- END IntelligentOffer.jsp -->