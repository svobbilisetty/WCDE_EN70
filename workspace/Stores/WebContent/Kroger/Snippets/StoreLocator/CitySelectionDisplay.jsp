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
  * This JSP displays the city selections for the province.
  *****
--%>

<!-- BEGIN CitySelectionDisplay.jsp -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ include file="../../Common/EnvironmentSetup.jspf" %>

<c:set var="provinceId" value="-999" />
<c:if test="${!empty WCParam.provinceId}">
  <c:set var="provinceId" value="${WCParam.provinceId}" />
</c:if>
<c:if test="${!empty param.provinceId}">
  <c:set var="provinceId" value="${param.provinceId}" />
</c:if>

<wcf:getData type="com.ibm.commerce.store.facade.datatypes.GeoNodeType[]"
             var="geoNodes" varException="geoNodeException" expressionBuilder="findChildGeoNodesByGeoNodeUniqueID">
  <wcf:param name="accessProfile" value="IBM_Store_All" />
  <wcf:param name="parentUniqueId" value="${provinceId}" />
</wcf:getData>


<select name="selectCity" id="selectCity" class="drop_down_country" onchange="javaScript:TealeafWCJS.processDOMEvent(event);storeLocatorJS.changeCitySelection(this.options[this.selectedIndex].value);">

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
<!-- END CitySelectionDisplay.jsp -->
