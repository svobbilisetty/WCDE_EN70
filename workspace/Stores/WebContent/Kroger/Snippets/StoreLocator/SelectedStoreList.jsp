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
  * This JSP displays the selected physical stores.
  *****
--%>

<!-- BEGIN SelectedStoreList.jsp -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ include file="../../Common/EnvironmentSetup.jspf" %>

<c:set var="fromPage" value="StoreLocator" />
<c:if test="${!empty WCParam.fromPage}">
  <c:set var="fromPage" value="${WCParam.fromPage}" />
</c:if>
<c:if test="${!empty param.fromPage}">
  <c:set var="fromPage" value="${param.fromPage}" />
</c:if>

<c:set var="pickUpStoreId" value="${cookie.WC_pickUpStore.value}" />

<c:set var="cookieVal" value="${cookie.WC_physicalStores.value}" />
<c:if test="${!empty cookieVal}">	
  <c:set var="cookieVal" value="${fn:replace(cookieVal, '%2C', ',')}" scope="page" />
	
  <wcf:getData type="com.ibm.commerce.store.facade.datatypes.PhysicalStoreType[]"
               var="physicalStores" varException="physicalStoreException" expressionBuilder="findPhysicalStoresByUniqueIDs">
    <wcf:param name="accessProfile" value="IBM_Store_Details" />
    <c:forTokens items="${cookieVal}" delims="," var="phyStoreId">
      <wcf:param name="uniqueId" value="${phyStoreId}" />	
    </c:forTokens>
  </wcf:getData>
</c:if>

<c:if test="${fromPage == 'ShoppingCart'}">
  <c:set var="storeId" value="" scope="page" />
  <c:if test="${!empty WCParam.storeId}">
    <c:set var="storeId" value="${WCParam.storeId}" scope="page" />
  </c:if>
  <c:if test="${!empty param.storeId}">
    <c:set var="storeId" value="${param.storeId}" scope="page" />
  </c:if>

  <c:set var="orderId" value="" scope="page" />
  <c:if test="${!empty WCParam.orderId}">
    <c:set var="orderId" value="${WCParam.orderId}" scope="page" />
  </c:if>
  <c:if test="${!empty param.orderId}">
    <c:set var="orderId" value="${param.orderId}" scope="page" />
  </c:if>
  
  <c:if test="${!empty orderId}">
  <%
	String cookieVal = (String)pageContext.getAttribute("cookieVal");
	if (cookieVal!=null && cookieVal.length()>0) {
		java.util.Map parameters = new java.util.HashMap();
		
		String[] orderId = {((String)pageContext.getAttribute("orderId"))};
		parameters.put("orderId", orderId);

		java.util.StringTokenizer tokenizer = new java.util.StringTokenizer(cookieVal, ",");
		java.util.Vector physicalStoreIds = new java.util.Vector();
		physicalStoreIds.add(tokenizer.nextToken());
		while (tokenizer.hasMoreTokens()) {
			physicalStoreIds.add(tokenizer.nextToken());
		}
		
		for (int i=0; i<physicalStoreIds.size(); i++) {
			String[] physicalStoreId = {((String)physicalStoreIds.elementAt(i))};
			parameters.put("physicalStoreId_"+i, physicalStoreId);
		}
		
	    	java.util.Map results = null;
		try {
			com.ibm.commerce.inventory.facade.client.InventoryFacadeClient inventoryFacadeClient = new com.ibm.commerce.inventory.facade.client.InventoryFacadeClient();
			results = inventoryFacadeClient.checkInventory(parameters);
			java.util.List physicalStoreInventoryAvailabilityResult = (java.util.List)(results.get("physicalStoreInventoryAvailability"));
			
			pageContext.setAttribute("physicalStoreSize", Integer.toString(physicalStoreInventoryAvailabilityResult.size()));
			
			java.util.Map physicalStoreResults = null;
			String resultPhysicalStoreIds = null;
			String resultPhysicalStoreInvStatus = null;
			if (physicalStoreInventoryAvailabilityResult.size() > 0) {
				physicalStoreResults = (java.util.Map)physicalStoreInventoryAvailabilityResult.get(0);
				resultPhysicalStoreIds = (String)physicalStoreResults.get("physicalStoreId");
				resultPhysicalStoreInvStatus = (String)physicalStoreResults.get("overallInventoryStatus");
				
				for (int i=1; i<physicalStoreInventoryAvailabilityResult.size(); i++) {
					physicalStoreResults = (java.util.Map)physicalStoreInventoryAvailabilityResult.get(i);
					resultPhysicalStoreIds = resultPhysicalStoreIds + "," + (String)physicalStoreResults.get("physicalStoreId");
					resultPhysicalStoreInvStatus = resultPhysicalStoreInvStatus + "," + (String)physicalStoreResults.get("overallInventoryStatus");
				}
				
				pageContext.setAttribute("resultPhysicalStoreIds", resultPhysicalStoreIds);
				pageContext.setAttribute("resultPhysicalStoreInvStatus", resultPhysicalStoreInvStatus);
			}
		} catch (com.ibm.commerce.inventory.facade.client.InventoryRequirementException exception) {
		}
	}
  %>
  </c:if>
</c:if>

<div id="your_store_list" class="gift_content margin_below">

  <c:if test="${!empty physicalStoreException}">
    <br /><span class="instruction"><fmt:message key="STORE_LIST_EMPTY"/></span><br /><br />
  </c:if>
  <c:if test="${empty physicalStoreException}">
    <c:set var="resultNum" value="${fn:length(physicalStores)}" />
    <c:if test="${resultNum <= 0}">
      <br /><fmt:message key="STORE_LIST_EMPTY" /><br /><br />
    </c:if>
    <c:if test="${resultNum > 0}">
    
      <c:if test="${fromPage == 'ShoppingCart'}">
<p class="text_padding"><fmt:message key="PICK_UP_ST_STORE_MESSAGE" /></p>
      </c:if>
<fieldset><legend><span class="spanacce"><fmt:message key='SELECTED_STORES_SUMMARY'/></span></legend>
<table id="bopis_table1" tabindex="-1" summary="<fmt:message key='SELECTED_STORES_SUMMARY'/>" cellpadding="0" cellspacing="0" border="0" width="100%">
  <tr class="nested">
      <c:if test="${fromPage == 'ShoppingCart'}">
    <th class="align_left" id="PhysicalStores_tableCell_0">&nbsp;</th>
      </c:if>
    <th class="align_left" id="PhysicalStores_tableCell_1"><fmt:message key="SELECTED_STORES_COLUMN1" /></th>
    <th class="align_left" id="PhysicalStores_tableCell_2"><fmt:message key="SELECTED_STORES_COLUMN2" /></th>
      <c:if test="${fromPage == 'ShoppingCart'}">
    <th class="align_left" id="PhysicalStores_tableCell_3"><fmt:message key="SELECTED_STORES_COLUMN3" /></th>
      </c:if>
    <th class="align_left" id="PhysicalStores_tableCell_4">&nbsp;</th>
  </tr>
            
      <c:forEach var="i" begin="0" end="${resultNum-1}" varStatus="status">
        <c:set var="storeHourIndex" value=-1 />
        <c:set var="attributeNum" value="${fn:length(physicalStores[i].attribute)}" />
        <c:if test="${attributeNum > 0}">
          <c:forEach var="j" begin="0" end="${attributeNum - 1}">
            <c:if test="${physicalStores[i].attribute[j].name == 'StoreHours'}">
              <c:set var="storeHoursIndex" value="${j}" />
              <c:set var="j" value="${attributeNum}" />
            </c:if>
          </c:forEach>
        </c:if>
					
  <tr>
      <c:if test="${fromPage == 'ShoppingCart'}">
        <c:set var="invStatus" value="" />
        <c:if test="${!empty cookieVal}">
          <c:set var="storeUniqueId" value="${physicalStores[i].physicalStoreIdentifier.uniqueID}" />	
          <c:set var="resultPhyStoreInvStatusArray" value="${fn:split(resultPhysicalStoreInvStatus, ',')}" />
          <c:set var="k" value="0" />
          <c:forTokens items="${resultPhysicalStoreIds}" delims="," var="resultPhyStoreId">
            <c:if test"${resultPhyStoreId == storeUniqueId}">
              <c:set var="invStatus" value="${resultPhyStoreInvStatusArray[k]}" />
            </c:if>
            <c:set var="k" value="${k+1}" />
          </c:forTokens>
        </c:if>

    <td id="WC_SelectedStoreList_td_1_<c:out value='${status.count}'/>" width="23" headers="PhysicalStores_tableCell_0" <c:choose><c:when test="${i == resultNum - 1}"><c:out value="class=no_bottom_border"/></c:when><c:otherwise><c:out value="class=dotted_bottom_border"/></c:otherwise></c:choose>>
        <c:choose>
          <c:when test="${invStatus=='Available' || invStatus=='Backorderable'}">
            <c:choose>
              <c:when test="${!empty pickUpStoreId && pickUpStoreId==physicalStores[i].physicalStoreIdentifier.uniqueID}">
      <input name="pickUpStore" id="pickUpStore_${i}" type="radio" onclick="Javascript:PhysicalStoreCookieJS.setPickUpStoreIdToCookie(${physicalStores[i].physicalStoreIdentifier.uniqueID}); pickUpStoreId=${physicalStores[i].physicalStoreIdentifier.uniqueID};" checked="checked" />
              </c:when>
              <c:otherwise>
      <input name="pickUpStore" id="pickUpStore_${i}" type="radio" onclick="Javascript:PhysicalStoreCookieJS.setPickUpStoreIdToCookie(${physicalStores[i].physicalStoreIdentifier.uniqueID}); pickUpStoreId=${physicalStores[i].physicalStoreIdentifier.uniqueID};" />
              </c:otherwise>
            </c:choose>
          </c:when>
          <c:otherwise>
      <input name="pickUpStore" id="pickUpStore_${i}" type="radio" disabled="true" />
          </c:otherwise>
        </c:choose>
    </td>
      </c:if>

    <td id="WC_SelectedStoreList_td_2_<c:out value='${status.count}'/>" width="250" headers="PhysicalStores_tableCell_1" <c:choose><c:when test="${i == resultNum - 1}"><c:out value="class=no_bottom_border"/></c:when><c:otherwise><c:out value="class=dotted_bottom_border"/></c:otherwise></c:choose>>
    <p class="my_account_content_bold"><label for="pickUpStore_${i}"><c:out value="${physicalStores[i].description[0].name}" /></label></p>
    <p><c:out value="${physicalStores[i].locationInfo.address.addressLine[0]}" /></p>
    <p><c:out value="${physicalStores[i].locationInfo.address.city}" />, <c:out value="${physicalStores[i].locationInfo.address.stateOrProvinceName}" />  <c:out value="${physicalStores[i].locationInfo.address.postalCode}" /></p>
    <p><c:out value="${physicalStores[i].locationInfo.telephone1.value}" /></p></td>

    <c:choose>
      <c:when test="${storeHoursIndex > -1}">
        <td id="WC_SelectedStoreList_td_3_<c:out value='${status.count}'/>" width="160" headers="PhysicalStores_tableCell_2" <c:choose><c:when test="${i == resultNum - 1}"><c:out value="class=no_bottom_border"/></c:when><c:otherwise><c:out value="class=dotted_bottom_border"/></c:otherwise></c:choose>><c:out value="${physicalStores[i].attribute[storeHoursIndex].displayValue}" escapeXml="false" /></td>
      </c:when>
      <c:otherwise>
        <td id="WC_SelectedStoreList_td_4_<c:out value='${status.count}'/>" width="160" headers="PhysicalStores_tableCell_2" <c:choose><c:when test="${i == resultNum - 1}"><c:out value="class=no_bottom_border"/></c:when><c:otherwise><c:out value="class=dotted_bottom_border"/></c:otherwise></c:choose>></td>
      </c:otherwise>
    </c:choose>                 

      <c:if test="${fromPage == 'ShoppingCart'}">
    <td id="WC_SelectedStoreList_td_5_<c:out value='${status.count}'/>" class="avail <c:choose><c:when test="${i == resultNum - 1}"><c:out value="no_bottom_border"/></c:when><c:otherwise><c:out value="dotted_bottom_border"/></c:otherwise></c:choose>" width="168" headers="PhysicalStores_tableCell_3">
      <c:choose>
        <c:when test="${!empty orderId}">
          <c:choose>
            <c:when test="${invStatus != ''}">
              <img src="<c:out value='${jspStoreImgDir}images/' />${invStatus}.gif" alt="<fmt:message key='AVAILABILITY_${invStatus}_IMAGE'/>" />
              <fmt:message key="INV_STATUS_${invStatus}"/> 
            </c:when>
            
            <c:otherwise>
              <fmt:message key="INV_INV_NA"/> 
            </c:otherwise>
          </c:choose>

        </c:when>
        
        <c:otherwise>
          <fmt:message key="INV_STATUS_NO_SHOP_CART_ITEM"/> 
        </c:otherwise>
      </c:choose>
    
    </td>
      </c:if>

    <td id="WC_SelectedStoreList_td_6_<c:out value='${status.count}'/>" headers="PhysicalStores_tableCell_4" <c:choose><c:when test="${i == resultNum - 1}"><c:out value="class=no_bottom_border"/></c:when><c:otherwise><c:out value="class=dotted_bottom_border"/></c:otherwise></c:choose>>
      <a class="remove_store_link hover_underline tlignore" id="removePhysicalStoreAction<c:out value='${i}' />" href="Javascript:setCurrentId('removePhysicalStoreAction${i}'); storeLocatorJS.removePhysicalStore(<c:out value="${physicalStores[i].physicalStoreIdentifier.uniqueID}" />); storeLocatorJS.refreshStoreList('<c:out value="${fromPage}" />');"><img src="<c:out value='${jspStoreImgDir}${env_vfileColor}' />table_x_delete.png" alt="<fmt:message key='TABLE_X_DELETE_IMAGE'/>" /><fmt:message key="REMOVE_PHYSICAL_STORE" /></a>
    </td>
  </tr>
  
      </c:forEach>
</table></fieldset>
    
    </c:if>
  </c:if>

</div>
<!-- END SelectedStoreList.jsp -->
