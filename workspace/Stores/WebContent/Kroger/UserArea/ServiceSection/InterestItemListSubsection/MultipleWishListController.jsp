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
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ include file="../../../Common/EnvironmentSetup.jspf" %>


	<%@ include file="../../../Snippets/MultipleWishList/GetDefaultWishList.jspf" %>
	
	<wcf:getData type="com.ibm.commerce.giftcenter.facade.datatypes.GiftListType[]" var="soaWishLists" expressionBuilder="findWishListsForUser">
		<wcf:contextData name="storeId" data="${WCParam.storeId}"/>
		<wcf:param name="accessProfile" value="IBM_Store_Summary" />
	</wcf:getData>
	
	<wcf:url var="soaWishListBodyURL" value="WishListResultDisplayView" type="Ajax">
		<wcf:param name="storeId"   value="${WCParam.storeId}"  />
		<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
		<wcf:param name="langId" value="${langId}" />
	</wcf:url>

<c:set var="defaultShoppingListId" value="-1"/>
<c:set var="shoppingListNames" value=""/>
<fmt:message key="SL_DEFAULT_WISH_LIST_NAME" var="defaultName"/>
<c:forEach var="shoppingList" items="${soaWishLists}">
	<c:if test="${shoppingList.description.name eq defaultName}">
		<c:set var="defaultShoppingListId" value="${shoppingList.giftListIdentifier.uniqueID}"/>
	</c:if>
	<c:if test="${!empty shoppingListNames}">
		<c:set var="shoppingListNames" value="${shoppingListNames},"/>
	</c:if>
	<%-- Replacing backslash with double-backslash since it gets omitted as it is the escape character --%>
	<c:set var="shoppingListName" value="${fn:replace(shoppingList.description.name,'\\\\','\\\\\\\\')}"/>
	<c:set var="shoppingListNames" value="${shoppingListNames}'${fn:escapeXml(shoppingListName)}': 1"/>
</c:forEach>
<c:if test="${defaultShoppingListId == '-1'}">
	<c:if test="${!empty shoppingListNames}">
		<c:set var="shoppingListNames" value="${shoppingListNames},"/>
	</c:if>
	<%-- Replacing backslash with double-backslash since it gets omitted as it is the escape character --%>
	<c:set var="shoppingListName" value="${fn:replace(defaultName,'\\\\','\\\\\\\\')}"/>
	<c:set var="shoppingListNames" value="${shoppingListNames}'${fn:escapeXml(shoppingListName)}': -1"/>
</c:if>
<c:set var="shoppingListNames" value="${fn:toUpperCase(shoppingListNames)}"/>
<c:set var="catEntryParams" value="{}"/>
<c:set var="storeParams" value="{storeId: '${fn:escapeXml(storeId)}',catalogId: '${fn:escapeXml(catalogId)}',langId: '${fn:escapeXml(langId)}'}"/>

<script>
dojo.addOnLoad(function() {
	var isAuthenticated = ${userType ne 'G'};
	shoppingListJS = new ShoppingListJS(${storeParams}, ${catEntryParams}, {${shoppingListNames}},"shoppingListJS");
	shoppingListJS.refreshLinkState();
});
</script>

		<div class="my_account_wishlist">
			<label for="multipleWishlistController_select" class="spanacce"><fmt:message key="ACCE_WISHLIST_SELECT"/></label>
				<select class="drop_down_language_select" size="1" id="multipleWishlistController_select" name="multipleWishlistController_select"
					onchange="javascript: MultipleWishLists.switchList(this.value);">		
					<c:forEach var="soaList" items="${soaWishLists}" varStatus="status">
						<c:choose>
							<c:when test="${WCParam.giftListId != -1 && defaultWishList.giftListIdentifier.uniqueID == soaList.giftListIdentifier.uniqueID}">
								<option value="<c:out value='${soaList.giftListIdentifier.uniqueID}'/>" selected="selected"><c:out value="${soaList.description.name}"/></option>		
							</c:when>
							<c:otherwise>
								<option value="<c:out value='${soaList.giftListIdentifier.uniqueID}'/>"><c:out value="${soaList.description.name}"/></option>		
							</c:otherwise>
						</c:choose>
					</c:forEach>
					<c:choose>
						<c:when test="${WCParam.giftListId == -1 && defaultShoppingListId == '-1'}">
							<option value="-1" selected="selected"><c:out value="${defaultName}"/></option>
						</c:when>
						<c:when test="${WCParam.giftListId != -1 && defaultShoppingListId == '-1'}">
							<option value="-1"><c:out value="${defaultName}"/></option>
						</c:when>
					</c:choose>
				</select>

		</div>

		
	<c:set var="searchStr" value="'"/>
	<c:set var="replaceStr" value="\\\\'"/>
	<div class="my_account_wishlist multiple_wishlist_actions_border hover_underline">
		<div id="create_popup_link" class="headingtext"> <a role="button" class="bopis_link" id="multipleWishlistController_link_create" href="javascript:shoppingListJS${param.parentPage}.showPopup('create');"><fmt:message key="MULTIPLE_WISHLIST_create"/></a> </div>		
			<div id="editDivider" class="multiple_wishlist_link_divider headingtext"></div>
			<div id="edit_popup_link" class="headingtext">
				<a role="button" class="bopis_link" id="multipleWishlistController_link_edit" href="javascript:dojo.byId('editListName').value='<c:out value='${fn:replace(defaultWishList.description.name, searchStr, replaceStr)}'/>';shoppingListJS${param.parentPage}.showPopup('edit');">
				<fmt:message key="MULTIPLE_WISHLIST_LINK_edit" />
				</a>
			</div>
			<div id="deleteDivider" class="multiple_wishlist_link_divider headingtext "></div>
			<div id="delete_popup_link" class="headingtext"> 
				<a role="button" class="bopis_link" id="multipleWishlistController_link_delete" href="javascript: var wIndex=dojo.byId('multipleWishlistController_select').selectedIndex; var wName=dojo.byId('multipleWishlistController_select').options[wIndex].text; dojo.byId('deleteListName').innerHTML=wName; shoppingListJS${param.parentPage}.showPopup('delete');">
				<fmt:message key="MULTIPLE_WISHLIST_LINK_delete"/>
				</a> 
			</div>		
	</div>
	
	<c:remove var="action"/>
