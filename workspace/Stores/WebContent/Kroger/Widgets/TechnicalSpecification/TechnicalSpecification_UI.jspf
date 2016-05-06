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
<p>${catEntry.longDescription}</p>

<c:if test="${not empty descAttrMap}">
	<ul>
	<c:forEach var="descriptiveAttr" items="${descAttrMap}" varStatus="status">
		<li>
			<span id="descAttributeName_${status.count}">
				<fmt:message key="ATTRNAMEKEY">
					<fmt:param value="${descAttrNames[descriptiveAttr.key]}"/>
				</fmt:message>
			</span>
			<c:set var="attrValues" value=""/>
			<c:forEach var="attrValue" items="${descriptiveAttr.value}">
				<c:if test="${!empty attrValues}">
					<c:set var="attrValues" value="${attrValues}, "/>
				</c:if>
				<c:set var="attrValues" value="${attrValues}${attrValue}"/>
			</c:forEach>
			<span id="descAttributeValue_${status.count}"><c:out value="${attrValues}"/></span>
		</li>
	</c:forEach>
	</ul>
</c:if>

<c:if test="${not empty dynamicKitComponentList}">
	<div class="item_spacer_5px"></div>
	<div class="item_spacer_10px"></div>
</c:if>

<c:if test="${not empty dynamicKitComponentList}">
	<div id="configDetailsTable" class="details_table">
		<div class="header color_second"><fmt:message key="CONFIGURATION" /></div>
		<c:forEach items="${dynamicKitComponentList}" var="componentName">
			<div class="color_second">
				<div class="item_description">${componentName}</div>
			</div>
			<div class="dotted_divider"></div>
			<div class="clear_float"></div>
		</c:forEach>
	</div>
</c:if>

<div class="item_spacer_5px"></div>
<div class="item_spacer_10px"></div>
<div dojoType="wc.widget.RefreshArea" controllerId="AttachmentPagination_Controller" id="attachmentPaginationContainer">
	<%out.flush();%>
		<c:import url="${env_jspStoreDir}Widgets/TechnicalSpecification/AttachmentList.jsp">
			<c:param name="catalogId" value="${param.catalogId}" />
			<c:param name="langId" value="${param.langId}" />
			<c:param name="productId" value="${param.productId}" />
			<c:param name="storeId" value="${param.storeId}" />
			<c:param name="excludeUsageStr" value="${excludeUsageStr}" />
		</c:import>
	<%out.flush();%>
</div>