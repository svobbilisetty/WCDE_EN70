	
<%--
  *****
  * DiscountDetailsDisplay.jsp displays the details of a discount code
  * - for item level discounts, display short and long description of the discount and the associated items and a clickable short
  *   description that links to the Item Display page
  * - for product level discounts, display short and long description of the discount and the associated products and a clickable
  *   name that links to the Product Display page
  * - for category level discounts, display the short and long description of the discount
  *****
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ taglib uri="http://commerce.ibm.com/coremetrics"  prefix="cm" %>
<%@ include file="../../Common/EnvironmentSetup.jspf"%>
<%@ include file="../../Common/nocache.jspf"%>

<wcbase:useBean id="calculationCodeListDB" classname="com.ibm.commerce.fulfillment.beans.CalculationCodeListDataBean">
	<c:set property="calculationUsageId" value="-1" target="${calculationCodeListDB}"/>
	<c:set property="code" value="${WCParam.code}" target="${calculationCodeListDB}"/>
	<c:set property="excludePromotionCode" value="false" target="${calculationCodeListDB}"/>
	<c:set property="storeId" value="${WCParam.pStoreId}" target="${calculationCodeListDB}"/>
</wcbase:useBean>

<!DOCTYPE HTML>

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
<!-- BEGIN DiscountDetailsDisplay.jsp -->
<html xmlns="http://www.w3.org/1999/xhtml" lang="${shortLocale}" xml:lang="${shortLocale}">
<head>
	<title>
		<fmt:message key="DISCOUNT_DETAILS_TITLE">
			<fmt:param value="${storeName}"/>
		</fmt:message>
	</title>
	<link rel="stylesheet" href="<c:out value="${jspStoreImgDir}${env_vfileStylesheet}"/>" type="text/css"/>
	<%@ include file="../../Common/CommonJSToInclude.jspf"%>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Widgets/Search.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Widgets/MiniShopCartDisplay/MiniShopCartDisplay.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Widgets/Department/Department.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/CommonContextsDeclarations.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/CommonControllersDeclaration.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Common/ShoppingActions.js"/>"></script>
	<%@ include file="../../Common/CommonJSPFToInclude.jspf"%>
</head>

<body>

<!-- Page Start -->
<div id="page">

	<!-- Import Header Widget -->
	<div class="header_wrapper_position" id="headerWidget">
		<%out.flush();%>
		<c:import url = "${env_jspStoreDir}/Widgets/Header/Header.jsp" />
		<%out.flush();%>
	</div>
	<!-- Header Nav End -->

	<!-- Main Content Start -->
	<div class="content_wrapper_position" role="main">
		<div class="content_wrapper">
			<div class="content_left_shadow">
				<div class="content_right_shadow">
					<div class="main_content">
						<div class="container_static_full_width container_margin_5px">
							<div class="static_page_content">
								<div class="page_header">	
									<fmt:message key="DISCOUNT_DETAILS_TITLE"/>
								</div>
								<div class="content_box">		
								
							
									<%-- CalculationCodeListDataBean is used to show the discount information of the product --%>
									<c:set var="calculationCodeDBs" value="${calculationCodeListDB.calculationCodeDataBeans}" scope="request"/>
								
									<%--
										***
										* Start check for valid discount.
										* - if true, then display the discount description and long description and the products associated with the discount.
										* - if false, then display error message stating that there is no valid discount.
										***
									--%>
									<c:choose>
										<c:when test="${ !empty calculationCodeDBs }"  >
											<div id="WC_DiscountDetailsDisplay_div_1" class="header">
												<%-- Show the description of the discount --%>
												<c:out value="${calculationCodeDBs[0].descriptionString}" />
											</div>
											<div id="WC_DiscountDetailsDisplay_div_2" class="info_section">
												<%-- Show the long description of the discount --%>
												<span>
													<c:out value="${calculationCodeDBs[0].longDescriptionString}" escapeXml="false" />
												</span>
											</div>
									
											<tr>
												<td valign="top" id="WC_DiscountDetailsDisplay_TableCell_9">
													<br />
													<table cellpadding="0" cellspacing="0" border="0" id="WC_DiscountDetailsDisplay_Table_3" class="info_section">
														<tbody>
															<tr>
																<%--
																	***
																	* Begin check for discounted products.  For each product, get the parent product and then display the product short description and link to product display page.
																	***
																--%>
																<td valign="top" id="WC_DiscountDetailsDisplay_TableCell_10">
																	<table cellpadding="0" cellspacing="0" border="0" id="WC_DiscountDetailsDisplay_Table_4" role="presentation">
																		<%-- Display the discounted category --%>
										
																		<c:if test="${!empty WCParam.categoryId}">
																			<tr>
																				<wcbase:useBean id="category" classname="com.ibm.commerce.catalog.beans.CategoryDataBean" scope="page">
																					<c:set target="${category}" property="catalogId" value="${WCParam.catalogId}" />
																				</wcbase:useBean>
							
																				<c:if test="${!empty category.description.fullIImage || !empty category.description.shortDescription}">
																					<td valign="top" class="categoryspace" width="165" id="WC_CachedCategoriesDisplay_TableCell_3">
																						<%-- Show category image and short description if available --%>
																						<c:if test="${!empty category.description.fullIImage}">
																							<%-- URL that links to the category display page --%>
																							<wcf:url var="categoryDisplayUrl" patternName="CanonicalCategoryURL" value="Category6">
																								<wcf:param name="catalogId" value="${WCParam.catalogId}" />
																								<wcf:param name="categoryId" value="${category.categoryId}" />
																								<wcf:param name="storeId" value="${WCParam.storeId}" />
																								<wcf:param name="langId" value="${langId}" />
																								<wcf:param name="urlLangId" value="${urlLangId}" />
																							</wcf:url>
																							<div align="center" id="WC_DiscountDetailsDisplay_div_3">
																								<a href="<c:out value="${categoryDisplayUrl}"/>" id="WC_DiscountDetailsDisplay_Link_Cat_1">
																									<img src="<c:out value="${category.objectPath}${category.description.fullIImage}"/>" alt="<c:out value="${category.description.name}"/>" border="0" />
																								</a>
																							</div>
																						</c:if>
																					</td>
																				</c:if>
																			</tr>
																			<c:if test="${!empty category.description.shortDescription}">
																				<tr>
																					<td id="WC_DiscountDetailsDisplay_td_1">
																						<span class="text"><c:out value="${category.description.shortDescription}" /></span>
																					</td>
																				</tr>
																			</c:if>
																		</c:if>
																		
																		<c:if test="${ !empty calculationCodeDBs[0].attachedCatalogEntryDataBeans }"  >
																		<tr>
																		<%-- Set the number of items to show on each row --%>
																			<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogNavigationViewType"	var="promotionCatalogEntry" expressionBuilder="getCatalogEntryViewSummaryByID">
																				<c:forEach var="discountEntry" items="${calculationCodeDBs[0].attachedCatalogEntryDataBeans}">
																					<wcf:param name="UniqueID" value="${discountEntry.catalogEntryID}" />
																				</c:forEach>
																				<wcf:contextData name="storeId" data="${storeId}" />
																				<wcf:contextData name="catalogId" data="${catalogId}" />
																			</wcf:getData>
																			<jsp:useBean id="promotionCatalogEntryMap" class="java.util.HashMap" type="java.util.Map"/>
																			<c:forEach var="discountEntry" items="${promotionCatalogEntry.catalogEntryView}">
																				<c:set target="${promotionCatalogEntryMap}" property="${discountEntry.uniqueID}" value="${discountEntry}" />
																			</c:forEach>
																			<c:set var="maxInRow" value="4"/>
																			<c:forEach var="catalogEntry" items="${calculationCodeDBs[0].attachedCatalogEntryDataBeans}" varStatus="counter">
																				<c:set var="discountCatalogEntryDB" value="${catalogEntry}"/>
										
																				<%-- Display the associated products with the discount code --%>
																				<td class="discountProduct" valign="top" align="center" id="WC_DiscountDetailsDisplay_TableCell_11_<c:out value="${counter.count}"/>">
																				
																					<%-- Will only execute the following code if the catalog entry is not a dynamic kit --%>
																					<c:if test="${empty discountCatalogEntryDB.dynamicKitDataBean}" >
																						<c:set var="discountCatalogEntryView" value="${promotionCatalogEntryMap[discountCatalogEntryDB.catalogEntryReferenceNumber]}"/>
																						<c:forEach var="metadata" items="${discountCatalogEntryView.metaData}">
																							<c:if test="${metadata.key == 'ThumbnailPath'}">
																								<c:set var="thumbNail" value="${env_imageContextPath}/${metadata.value}" />
																							</c:if>
																						</c:forEach>
																						<span class="productName">
																							<%-- URL that links to the Product Display Page --%>
																							<wcf:url var="ProductDisplayURL" patternName="ProductURL" value="Product1">
																								<wcf:param name="langId" value="${langId}" />
																								<wcf:param name="storeId" value="${WCParam.storeId}" />
																								<wcf:param name="catalogId" value="${WCParam.catalogId}" />
																								<wcf:param name="productId" value="${discountCatalogEntryView.uniqueID}" />
																								<wcf:param name="urlLangId" value="${urlLangId}" />
																							</wcf:url>
																							<a href="<c:out value="${ProductDisplayURL}"/>" id="WC_DiscountDetailsDisplay_Link_1_<c:out value="${counter.count}"/>">
																								<c:choose>
																									<c:when test="${!empty discountCatalogEntryView.fullImage}">
																										<img src="${thumbNail}" alt="<c:out value="${discountCatalogEntryView.shortDescription}" />" border="0"/>
																									</c:when>
																									<c:otherwise>
																										<img src="<c:out value="${jspStoreImgDir}"/>images/NoImageIcon.jpg" alt="<fmt:message key="No_Image"/>" border="0"/>						
																									</c:otherwise>
																								</c:choose>
																								<br /><c:out value="${discountCatalogEntryView.name}" escapeXml="false"  /><br /><br />
																							</a>
																						</span>
																						 <%--
																						  ***
																						  *	Start: discountCatalogEntryDB.productDataBean Price
																						  * The 1st choose block below determines the way to show the discountCatalogEntryDB.productDataBean contract price: a) no price available, b) the minimum price, c) the price range.
																						  * The 2nd choose block determines whether to show the list price.
																						  * List price is only displayed if it is greater than the discountCatalogEntryDB.productDataBean price and if the discountCatalogEntryDB.productDataBean does not have price range (i.e. min price == max price)
																						  ***
																						--%>
																						<c:choose>
																							<c:when test="${catalogEntry.product}">
																							 	<c:set var="type" value="product"/>
																								<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogNavigationViewType" var="catalogNavigationView" 
																										expressionBuilder="getCatalogEntryViewPriceByID" varShowVerb="showCatalogNavigationView" maxItems="1" recordSetStartNumber="0" scope="request">
																									<wcf:param name="UniqueID" value="${catalogEntry.productDataBean.productID}" />
																									<wcf:contextData name="storeId" data="${WCParam.storeId}" />
																									<wcf:contextData name="catalogId" data="${WCParam.catalogId}" />
																								</wcf:getData>
																								<c:set var="catalogEntryTemp" value="${catalogEntry}" />
																								<c:set var="catalogEntry" value="${catalogNavigationView.catalogEntryView[0]}" />
																								<%@ include file="../../Snippets/ReusableObjects/CatalogEntryPriceDisplay.jspf"%>
																								<c:set var="catalogEntry" value="${catalogEntryTemp}" />
																							</c:when>
																							<c:otherwise>
																								<c:set var="discountItemDB" value="${catalogEntry}"/>
																								<c:set var="catalogEntryIdForPriceRule" value="${catalogEntry.catalogEntryID}"/>
																								<%@ include file="../../Snippets/ReusableObjects/GetCatalogEntryDisplayPrice.jspf"%>
																								<c:choose>
																									<c:when test="${(empty displayPrice)&&(empty discountItemDB.calculatedContractPrice)}" >
																										<c:set var="productDataBeanPriceString"><fmt:message key="NO_PRICE_AVAILABLE" /></c:set>
																									</c:when>
																									<c:when test="${ listPriced && (!empty displayPrice) && (!empty discountItemDB.calculatedContractPrice) && (discountItemDB.calculatedContractPrice.amount < displayPrice.amount)}" >
																										<c:set var="productDataBeanPriceString" value="${discountItemDB.calculatedContractPrice}" />
																										<!-- The empty gif are put in front of the prices so that the alt text can be read by the IBM Homepage Reader to describe the two prices displayed.
																										These descriptions are necessary for meeting Accessibility requirements -->
																										<a href="#" id="WC_CacheddiscountCatalogEntryDB.productDataBeanOnlyDisplay_Link_2"><img src="<c:out value="${jspStoreImgDir}" />images/empty.gif" alt='<fmt:message key="RegularPriceIs" />' width="1" height="1" border="0"/></a>
																										<span class="listPrice"><c:out value="${displayPrice}" escapeXml="false" /></span>
																										<br />
																										<a href="#" id="WC_CachedProductOnlyDisplay_Link_3_<c:out value='${counter.count}'/>"><img src="<c:out value="${jspStoreImgDir}" />images/empty.gif" alt='<fmt:message key="SalePriceIs" />' width="1" height="1" border="0"/></a>
																										<span class="redPrice"><c:out value="${productDataBeanPriceString}" escapeXml="false" /></span>
																									</c:when>
																							 		<c:otherwise>
																									<%--	The empty gif are put in front of the prices so that the alt text can be read by the IBM Homepage Reader to describe the two prices displayed.
																										These descriptions are necessary for meeting Accessibility requirements --%>
																										<a href="#" id="WC_CacheddiscountCatalogEntryDB.productDataBeanOnlyDisplay_Link_4"><img src="<c:out value="${jspStoreImgDir}" />images/empty.gif" alt='<fmt:message key="PriceIs" />' width="1" height="1" border="0"/></a>
																										<span class="price">
																											<fmt:formatNumber value="${discountItemDB.calculatedContractPrice.amount}" type="currency" currencySymbol="${env_CurrencySymbolToFormat}" maxFractionDigits="${env_currencyDecimal}"/>
																											<c:out value="${CurrencySymbol}"/>
																										</span>
																									</c:otherwise>
																								</c:choose>
																							</c:otherwise>
																						</c:choose>
																					</c:if>
							
																				</td>
																				<%--
																					***
																					* Draw another row if number of items/products displayed on this row is greater than
																					* the number specified by MaxInRow
																					***
																				--%>
																				<c:if test="${(counter.count) % maxInRow==0 }">
																					</tr>
																					<tr>
																				</c:if>
																			</c:forEach>
																		</tr>
																		</c:if>
							
																		<tr>
																			<td colspan="<c:out value="${maxInRow}"/>" id="WC_DiscountDetailsDisplay_TableCell_12">
																				<br />
																				<span class="discount">
																					<fmt:message key="DETAILED_DISCOUNT_DISCLAIMER"/>
																				</span>
																			</td>
																		</tr>
																	</table>
																</td>
																<%--
																	***
																	* End check for discounted products.
																	***
																--%>
												
															</tr>
														</tbody>
													</table>
												</td>
											</tr>
										</c:when>
										<c:otherwise>
											<tr>
												<td id="WC_DiscountDetailsDisplay_TableCell_13">
													<fmt:message key="DISCOUNTDETAILS_ERROR"/>
												</td>
											</tr>
										</c:otherwise>
									</c:choose>
									<%--
										***
										* End check for valid discount
										***
									--%>
								</div>
							</div>
							<!-- Content End -->
						</div>
						<!-- Main Content End -->
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- Footer Start -->
	<div class="footer_wrapper_position">
		<%out.flush();%>
			<c:import url = "${env_jspStoreDir}/Widgets/Footer/Footer.jsp" />
		<%out.flush();%>
	</div>
	<!-- Footer End --> 
	
</div>	
<!-- Page End -->

<flow:ifEnabled feature="Analytics"><cm:pageview/></flow:ifEnabled>
</body>
</html>
<!-- END DiscountDetailsDisplay.jsp -->
