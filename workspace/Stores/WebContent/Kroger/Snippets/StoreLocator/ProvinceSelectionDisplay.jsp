<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2008, 2012 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%-- 
  *****
  * This JSP displays the province selections for the country.
  *****
--%>

<!-- BEGIN ProvinceSelectionDisplay.jsp -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ include file="../../Common/EnvironmentSetup.jspf" %>

<c:set var="countryId" value="-999" />
<c:if test="${!empty WCParam.countryId}">
  <c:set var="countryId" value="${WCParam.countryId}" />
</c:if>
<c:if test="${!empty param.countryId}">
  <c:set var="countryId" value="${param.countryId}" />
</c:if>

<wcf:getData type="com.ibm.commerce.store.facade.datatypes.GeoNodeType[]"
             var="geoNodes" varException="geoNodeException" expressionBuilder="findChildGeoNodesByGeoNodeUniqueID">
  <wcf:param name="accessProfile" value="IBM_Store_All" />
  <wcf:param name="parentUniqueId" value="${countryId}" />
</wcf:getData>


<select name="selectState" id="selectState" title="<fmt:message key='ACCE_PROVINCE_CHANGE'/>" class="drop_down_country" onchange="JavaScript:TealeafWCJS.processDOMEvent(event);storeLocatorJS.changeProvinceSelection(this.options[this.selectedIndex].value);">

  <c:if test="${!empty geoNodeException}">
    <c:out value="${geoNodeException.changeStatus.description.value}" />
    <c:out value="${geoNodeException.clientErrors[0].errorKey}" />
  </c:if>
  <c:if test="${empty geoNodeException}">
    <c:set var="resultNum" value="${fn:length(geoNodes)}" />
    <c:if test="${resultNum > 0}">
      <c:forEach var="i" begin="0" end="${resultNum-1}">
        <option value='<c:out value="${geoNodes[i].geoNodeIdentifier.uniqueID}" />'><c:out value="${geoNodes[i].description[0].name}" /></option>
      </c:forEach>
    </c:if>
  </c:if>

</select>
<!-- END ProvinceSelectionDisplay.jsp -->
