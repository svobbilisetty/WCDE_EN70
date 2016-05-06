<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2011, 2012 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

	
	<%@include file="../../Common/JSTLEnvironmentSetup.jspf" %>

<c:forEach var="subCatStartIndex" begin="0" end="${numSubCat}" varStatus="status2">
													
	<c:if test="${not empty subTopCategoryList[subCatStartIndex]}">
		<c:if test="${filledCatPerColumn eq '0'}">		
			<c:set var="filledCatPerColumn" value="${numSubCatPerColumn}"/>														
		</c:if>	
		<c:if test="${filledCatPerColumn eq numSubCatPerColumn}">
			<div class="sub_category" id="department_${status.count}_next_sub_category_${status2.count}">
		</c:if>	
			<c:choose>
				<c:when test="${topCategoryAdded eq 'false'}">
					<%-- Display the top category--%>
					<div id="top_item_${status.count}" class="name item" role="menuitem">
						<a id="SubCategoryLink_${status.count}" href="${topCategory[1]}"><c:out value="${topCategory[0]}" escapeXml="false"/>
						</a>
					</div>
					<c:set var="topCategoryAdded" value="true"/>
					<c:set var="firstItem" value="false"/>
					<c:set var="filledCatPerColumn" value="${filledCatPerColumn -1}"/> 
				</c:when>
				<c:otherwise>
					<c:set var="firstItem" value="true"/>																		
				</c:otherwise>
			</c:choose>
			<%-- Display the list of subcategories--%>
			
			<c:set var="itemClass" value="item"/>
			<c:if test="${filledCatPerColumn eq numSubCatPerColumn}">
				<c:set var="itemClass" value="first item"/>
			</c:if>
			<c:choose>
				<c:when test="${((status2.count + 1) == maxItems) && (status2.count != fn:length(subTopCategoryList)) }">
					<div id="sub_item_${status.count}_${status2.count}" class="${itemClass}" role="menuitem">
						<a id="SubItemLink_${status.count}_${status2.count}" href="${topCategory[1]}"><fmt:message key="MORE_CATEGORY" />
						</a>
					</div>
				</c:when>
				<c:otherwise>
					<div id="sub_item_${status.count}_${status2.count}" class="${itemClass}" role="menuitem">
						<a id="SubItemLink_${status.count}_${status2.count}" href="${subTopCategoryURLList[subCatStartIndex]}"><c:out value="${subTopCategoryList[subCatStartIndex]}" escapeXml="false"/>
						</a>
					</div>
				</c:otherwise>
			</c:choose>
			
			<c:set var="filledCatPerColumn" value="${filledCatPerColumn -1}"/>
			<c:if test="${filledCatPerColumn eq '0'}">		
				</div>																	
			</c:if>																
	</c:if>
</c:forEach>